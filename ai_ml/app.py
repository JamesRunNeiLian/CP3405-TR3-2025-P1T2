# app.py
# This script loads the pre-trained model and serves predictions via a web API.

from flask import Flask, request, jsonify
import pickle
import pandas as pd

print("--- Starting API Server ---")

# Initialize the Flask application
app = Flask(__name__)

# --- Load the Trained Model ---
# We load the model from the file created by train.py at the start.
model_filename = 'arima_model.pkl'
print(f"Loading the trained model from '{model_filename}'...")
with open(model_filename, 'rb') as file:
    model = pickle.load(file)
print("Model loaded successfully.")


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

# --- Run the Server ---
if __name__ == '__main__':
    # This makes the server accessible on your local machine at port 5000
    app.run(debug=True, port=5000)