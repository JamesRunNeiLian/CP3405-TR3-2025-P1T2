# app.py
# This script loads the pre-trained model and serves predictions via a web API.
# Now includes Reinforcement Learning API endpoints for seat recommendations

from flask import Flask, request, jsonify
import pickle
import pandas as pd
import numpy as np
import json
import os
from datetime import datetime

print("--- Starting API Server ---")

# Initialize the Flask application
app = Flask(__name__)

# --- Load the Trained ARIMA Model ---
# We load the model from the file created by train.py at the start.
model_filename = 'arima_model.pkl'
print(f"Loading the trained model from '{model_filename}'...")
with open(model_filename, 'rb') as file:
    model = pickle.load(file)
print("Model loaded successfully.")

# --- Import and Initialize RL Agent ---
# Import the RL recommendation engine
from rl_baseline import SeatRecommendationBandit

# Define recommendation strategies
RECOMMENDATION_STRATEGIES = [
    {
        "id": 0,
        "name": "Quiet Zone",
        "description": "Recommend seats in quiet study areas",
        "zone": "quiet"
    },
    {
        "id": 1,
        "name": "Near Door",
        "description": "Recommend seats near the entrance (convenient for latecomers)",
        "zone": "door"
    },
    {
        "id": 2,
        "name": "Accessible Zone",
        "description": "Recommend seats in accessible areas",
        "zone": "accessible"
    },
    {
        "id": 3,
        "name": "Group Study Zone",
        "description": "Recommend seats in group study areas",
        "zone": "group"
    }
]

# Initialize RL agent
rl_agent = SeatRecommendationBandit(k_arms=len(RECOMMENDATION_STRATEGIES), epsilon=0.1)
print(f"RL Agent initialized with {len(RECOMMENDATION_STRATEGIES)} recommendation strategies.")

# File to persist RL agent state
RL_STATE_FILE = 'rl_agent_state.json'

# Load existing RL agent state if available
def load_rl_state():
    """Load the RL agent state from file"""
    global rl_agent
    if os.path.exists(RL_STATE_FILE):
        try:
            with open(RL_STATE_FILE, 'r') as f:
                state = json.load(f)
                rl_agent.q_values = np.array(state['q_values'])
                rl_agent.n_pulls = np.array(state['n_pulls'])
                print("RL agent state loaded successfully.")
        except Exception as e:
            print(f"Error loading RL state: {e}")

# Save RL agent state to file
def save_rl_state():
    """Save the RL agent state to file"""
    try:
        state = {
            'q_values': rl_agent.q_values.tolist(),
            'n_pulls': rl_agent.n_pulls.tolist(),
            'last_updated': datetime.now().isoformat()
        }
        with open(RL_STATE_FILE, 'w') as f:
            json.dump(state, f)
    except Exception as e:
        print(f"Error saving RL state: {e}")

# Load existing state on startup
load_rl_state()


# --- Define the API Endpoint ---
# We define a route '/predict'. When someone accesses this URL, this function will run.
@app.route('/predict', methods=['GET'])
def predict():
    """
    Predicts future occupancy for a given number of hours.
    Takes 'hours' as a URL parameter.
    Example: http://127.0.0.1:5000/predict?hours=24
    """
    # Get the 'hours' parameter from the URL, default to 24 if not provided
    try:
        hours_to_forecast = int(request.args.get('hours', 24))
    except ValueError:
        return jsonify({'error': 'Invalid "hours" parameter. Please provide an integer.'}), 400

    print(f"Received request to forecast for {hours_to_forecast} hours.")

    # Use the loaded model to make a forecast
    forecast = model.get_forecast(steps=hours_to_forecast)

    # Prepare the forecast data for JSON response
    # We create a timestamp for each prediction
    last_timestamp = model.data.endog.index[-1]
    forecast_index = pd.date_range(start=last_timestamp, periods=hours_to_forecast + 1, freq='H')[1:]
    
    predictions = {
        'forecast': list(forecast.predicted_mean),
        'timestamps': [ts.isoformat() for ts in forecast_index],
        'confidence_interval_lower': list(forecast.conf_int().iloc[:, 0]),
        'confidence_interval_upper': list(forecast.conf_int().iloc[:, 1]),
    }

    # Return the predictions as a JSON response
    return jsonify(predictions)


# ============================================
# --- Reinforcement Learning API Endpoints ---
# ============================================

@app.route('/rl/recommend', methods=['POST'])
def get_seat_recommendation():
    """
    Get seat recommendation using Reinforcement Learning
    
    Request Body (JSON):
    {
        "user_id": "student123",  // Optional: User ID
        "classroom_id": "room101",  // Optional: Classroom ID
        "user_preferences": {}  // Optional: User preferences
    }
    
    Response:
    {
        "strategy_id": 0,
        "strategy_name": "Quiet Zone",
        "description": "Recommend seats in quiet study areas",
        "zone": "quiet",
        "confidence": 0.85,
        "timestamp": "2025-11-07T10:30:00"
    }
    """
    try:
        # Get request data (optional)
        data = request.get_json() if request.is_json else {}
        
        # Use RL agent to choose recommendation strategy
        strategy_id = rl_agent.choose_recommendation_strategy()
        strategy = RECOMMENDATION_STRATEGIES[strategy_id]
        
        # Build response
        response = {
            "strategy_id": strategy_id,
            "strategy_name": strategy["name"],
            "description": strategy["description"],
            "zone": strategy["zone"],
            "confidence": float(rl_agent.q_values[strategy_id]),
            "timestamp": datetime.now().isoformat(),
            "user_id": data.get("user_id", None),
            "classroom_id": data.get("classroom_id", None)
        }
        
        print(f"Recommended strategy: {strategy['name']} (ID: {strategy_id})")
        return jsonify(response), 200
        
    except Exception as e:
        print(f"Error in get_seat_recommendation: {e}")
        return jsonify({"error": str(e)}), 500


@app.route('/rl/feedback', methods=['POST'])
def submit_feedback():
    """
    Submit user feedback on recommendation (reward signal)
    
    Request Body (JSON):
    {
        "strategy_id": 0,  // Required: Recommended strategy ID
        "accepted": true,  // Required: Whether user accepted the recommendation (true=1, false=0)
        "user_id": "student123",  // Optional
        "seat_id": "A-01"  // Optional: Final seat selected
    }
    
    Response:
    {
        "success": true,
        "message": "Feedback recorded and model updated",
        "updated_confidence": 0.87,
        "total_trials": 156
    }
    """
    try:
        data = request.get_json()
        
        # Validate required parameters
        if data is None or 'strategy_id' not in data or 'accepted' not in data:
            return jsonify({
                "error": "Missing required parameters: strategy_id and accepted"
            }), 400
        
        strategy_id = int(data['strategy_id'])
        accepted = bool(data['accepted'])
        
        # Validate strategy_id
        if strategy_id < 0 or strategy_id >= len(RECOMMENDATION_STRATEGIES):
            return jsonify({
                "error": f"Invalid strategy_id: {strategy_id}"
            }), 400
        
        # Convert user feedback to reward signal (1=accepted, 0=rejected)
        reward = 1 if accepted else 0
        
        # Update RL agent policy
        rl_agent.update_policy(strategy_id, reward)
        
        # Save updated state
        save_rl_state()
        
        # Build response
        response = {
            "success": True,
            "message": "Feedback recorded and model updated",
            "strategy_id": strategy_id,
            "strategy_name": RECOMMENDATION_STRATEGIES[strategy_id]["name"],
            "reward": reward,
            "updated_confidence": float(rl_agent.q_values[strategy_id]),
            "total_trials": int(rl_agent.n_pulls[strategy_id]),
            "timestamp": datetime.now().isoformat()
        }
        
        print(f"Feedback received for strategy {strategy_id}: reward={reward}, new confidence={response['updated_confidence']:.4f}")
        return jsonify(response), 200
        
    except Exception as e:
        print(f"Error in submit_feedback: {e}")
        return jsonify({"error": str(e)}), 500


@app.route('/rl/status', methods=['GET'])
def get_rl_status():
    """
    Get current status of the Reinforcement Learning model
    
    Response:
    {
        "strategies": [
            {
                "id": 0,
                "name": "Quiet Zone",
                "confidence": 0.85,
                "trials": 250
            },
            ...
        ],
        "best_strategy": {...},
        "total_recommendations": 1000,
        "epsilon": 0.1
    }
    """
    try:
        # Get status of all strategies
        strategies_status = []
        for i, strategy in enumerate(RECOMMENDATION_STRATEGIES):
            strategies_status.append({
                "id": strategy["id"],
                "name": strategy["name"],
                "description": strategy["description"],
                "zone": strategy["zone"],
                "confidence": float(rl_agent.q_values[i]),
                "trials": int(rl_agent.n_pulls[i])
            })
        
        # Find best strategy
        best_strategy_id = int(np.argmax(rl_agent.q_values))
        best_strategy = strategies_status[best_strategy_id].copy()
        
        # Build response
        response = {
            "strategies": strategies_status,
            "best_strategy": best_strategy,
            "total_recommendations": int(np.sum(rl_agent.n_pulls)),
            "epsilon": float(rl_agent.epsilon),
            "timestamp": datetime.now().isoformat()
        }
        
        return jsonify(response), 200
        
    except Exception as e:
        print(f"Error in get_rl_status: {e}")
        return jsonify({"error": str(e)}), 500


@app.route('/rl/reset', methods=['POST'])
def reset_rl_agent():
    """
    Reset the Reinforcement Learning model (Warning: Clears all learning data)
    
    Response:
    {
        "success": true,
        "message": "RL model has been reset"
    }
    """
    try:
        global rl_agent
        
        # Reinitialize agent
        rl_agent = SeatRecommendationBandit(
            k_arms=len(RECOMMENDATION_STRATEGIES), 
            epsilon=0.1
        )
        
        # Save reset state
        save_rl_state()
        
        print("RL agent has been reset.")
        return jsonify({
            "success": True,
            "message": "RL model has been reset, all learning data cleared"
        }), 200
        
    except Exception as e:
        print(f"Error in reset_rl_agent: {e}")
        return jsonify({"error": str(e)}), 500


@app.route('/health', methods=['GET'])
def health_check():
    """
    Health check endpoint
    """
    return jsonify({
        "status": "healthy",
        "services": {
            "occupancy_forecasting": "available",
            "rl_recommendation": "available"
        },
        "timestamp": datetime.now().isoformat()
    }), 200


# --- Run the Server ---
if __name__ == '__main__':
    # This makes the server accessible on your local machine at port 5000
    print("\n=== API Endpoints Available ===")
    print("1. GET  /predict         - Occupancy Forecasting")
    print("2. POST /rl/recommend    - Get Seat Recommendation")
    print("3. POST /rl/feedback     - Submit User Feedback")
    print("4. GET  /rl/status       - View RL Model Status")
    print("5. POST /rl/reset        - Reset RL Model")
    print("6. GET  /health          - Health Check")
    print("================================\n")
    
    app.run(debug=True, port=5000, host='0.0.0.0')