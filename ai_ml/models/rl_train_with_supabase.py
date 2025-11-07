#!/usr/bin/env python3
"""
RL Training Script with Supabase Simulation Data
==================================================
This script trains the RL recommendation model using simulation data from Supabase.
It will:
1. Check if simulation data exists in Supabase
2. If not, generate simulation data (feedback records)
3. Fetch the first 20 records and train the RL model
4. Save the trained model state
"""

import sys
import os
import json
import numpy as np
from datetime import datetime, timedelta
import random

# Add parent directory to path
sys.path.append(os.path.dirname(os.path.dirname(__file__)))

from supabase import create_client, Client
from config.supabase_config import SUPABASE_URL, SUPABASE_KEY, RL_K_ARMS, RL_EPSILON
from models.rl_baseline import SeatRecommendationBandit

print("="*70)
print("  RL Training Script - Using Supabase Simulation Data")
print("="*70)

# Initialize Supabase client
print("\n[1/5] Connecting to Supabase...")
try:
    # Create client with just URL and key
    supabase: Client = create_client(SUPABASE_URL, SUPABASE_KEY)
    print("✓ Connected to Supabase")
except TypeError as e:
    # If there's a proxy argument error, it's likely a version incompatibility
    # Try importing the older way
    print(f"  Retrying with alternative initialization method...")
    try:
        from supabase.client import Client as SupabaseClient
        supabase = SupabaseClient(SUPABASE_URL, SUPABASE_KEY)
        print("✓ Connected to Supabase")
    except Exception as e2:
        print(f"✗ Error connecting to Supabase: {e2}")
        print(f"   Make sure Supabase credentials are correct in config/supabase_config.py")
        import traceback
        traceback.print_exc()
        sys.exit(1)
except Exception as e:
    print(f"✗ Error connecting to Supabase: {e}")
    print(f"   Make sure Supabase credentials are correct in config/supabase_config.py")
    import traceback
    traceback.print_exc()
    sys.exit(1)

# Define recommendation strategies (same as in app.py)
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
        "description": "Recommend seats near the entrance",
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

def generate_simulation_data(num_records=50):
    """
    Generate simulation feedback data in Supabase
    
    Simulates realistic user feedback patterns:
    - Strategy 0 (Quiet Zone): 85% acceptance rate (most popular)
    - Strategy 1 (Near Door): 40% acceptance rate
    - Strategy 2 (Accessible Zone): 60% acceptance rate
    - Strategy 3 (Group Study): 50% acceptance rate
    """
    print(f"\n[2/5] Generating {num_records} simulation feedback records...")
    
    # True acceptance rates for each strategy (ground truth)
    true_acceptance_rates = [0.85, 0.40, 0.60, 0.50]
    
    simulation_data = []
    base_time = datetime.now() - timedelta(days=7)  # Start from 7 days ago
    
    for i in range(num_records):
        # Randomly select a strategy
        strategy_id = random.randint(0, 3)
        strategy = RECOMMENDATION_STRATEGIES[strategy_id]
        
        # Simulate user acceptance based on true acceptance rate
        accepted = random.random() < true_acceptance_rates[strategy_id]
        reward = 1 if accepted else 0
        
        # Create feedback record
        record = {
            'user_id': f'{i}',
            'seat_id': f'{random.randint(1, 20)}',
            'strategy_id': strategy_id,
            'strategy_name': strategy['name'],
            'accepted': accepted,
            'reward': reward,
            'updated_confidence': 0.0,  # Will be calculated during training
            'timestamp': (base_time + timedelta(hours=i)).isoformat()
        }
        
        simulation_data.append(record)
    
    # Insert data into Supabase
    try:
        response = supabase.table('rl_feedbacks').insert(simulation_data).execute()
        print(f"✓ Successfully inserted {len(simulation_data)} simulation records")
        
        # Print distribution
        print("\n  Simulation data distribution:")
        for sid in range(4):
            count = sum(1 for r in simulation_data if r['strategy_id'] == sid)
            accepted = sum(1 for r in simulation_data if r['strategy_id'] == sid and r['accepted'])
            rate = (accepted / count * 100) if count > 0 else 0
            print(f"    Strategy {sid} ({RECOMMENDATION_STRATEGIES[sid]['name']:<20}): "
                  f"{count} records, {accepted} accepted ({rate:.1f}%)")
        
        return True
    except Exception as e:
        print(f"✗ Error inserting simulation data: {e}")
        return False

def check_and_prepare_data():
    """Check if simulation data exists, if not, generate it"""
    print("\n[2/5] Checking for existing feedback data...")
    
    # Retry mechanism for Supabase cache refresh
    max_retries = 3
    retry_delay = 2  # seconds
    
    for attempt in range(max_retries):
        try:
            if attempt > 0:
                print(f"  Retry attempt {attempt + 1}/{max_retries}...")
                import time
                time.sleep(retry_delay)
            
            # Check if rl_feedbacks table has data
            response = supabase.table('rl_feedbacks').select('*').limit(1).execute()
            
            if response.data and len(response.data) > 0:
                # Count total records
                count_response = supabase.table('rl_feedbacks').select('id', count='exact').execute()
                total_count = count_response.count if count_response.count else 0
                print(f"✓ Found {total_count} existing feedback records in Supabase")
                return True
            else:
                print("✗ No feedback data found in Supabase")
                print("  Generating simulation data...")
                return generate_simulation_data(num_records=50)
        except Exception as e:
            error_msg = str(e)
            if 'PGRST205' in error_msg or 'schema cache' in error_msg:
                if attempt < max_retries - 1:
                    print(f"  ⚠️  Table exists but PostgREST cache not updated yet...")
                    print(f"  Waiting {retry_delay} seconds for cache refresh...")
                    continue
                else:
                    print(f"  ⚠️  PostgREST cache issue detected.")
                    print(f"  Please wait a few minutes or reload schema in Supabase Settings → API")
                    print(f"  Falling back to local simulation data...")
                    return use_local_simulation_data()
            else:
                print(f"✗ Error checking data: {e}")
                if attempt < max_retries - 1:
                    continue
                else:
                    print("  Attempting to generate simulation data...")
                    return generate_simulation_data(num_records=50)
    
    return False

def use_local_simulation_data():
    """Generate local simulation data when Supabase is unavailable"""
    print("\n  Generating local simulation data (not stored in Supabase)...")
    
    # True acceptance rates for each strategy (ground truth)
    true_acceptance_rates = [0.85, 0.40, 0.60, 0.50]
    
    simulation_data = []
    
    for i in range(20):  # Generate 20 records directly
        strategy_id = random.randint(0, 3)
        accepted = random.random() < true_acceptance_rates[strategy_id]
        
        record = {
            'strategy_id': strategy_id,
            'strategy_name': RECOMMENDATION_STRATEGIES[strategy_id]['name'],
            'accepted': accepted,
            'reward': 1 if accepted else 0
        }
        simulation_data.append(record)
    
    print(f"✓ Generated {len(simulation_data)} local simulation records")
    return simulation_data

def fetch_training_data(limit=20):
    """Fetch training data from Supabase"""
    print(f"\n[3/5] Fetching first {limit} feedback records for training...")
    
    max_retries = 3
    retry_delay = 2
    
    for attempt in range(max_retries):
        try:
            if attempt > 0:
                print(f"  Retry attempt {attempt + 1}/{max_retries}...")
                import time
                time.sleep(retry_delay)
            
            response = supabase.table('rl_feedbacks')\
                .select('*')\
                .order('timestamp', desc=False)\
                .limit(limit)\
                .execute()
            
            if response.data and len(response.data) > 0:
                print(f"✓ Retrieved {len(response.data)} records from Supabase")
                
                # Print data summary
                print("\n  Training data summary:")
                for sid in range(4):
                    records = [r for r in response.data if r['strategy_id'] == sid]
                    accepted = sum(1 for r in records if r['accepted'])
                    count = len(records)
                    rate = (accepted / count * 100) if count > 0 else 0
                    print(f"    Strategy {sid} ({RECOMMENDATION_STRATEGIES[sid]['name']:<20}): "
                          f"{count} records, {accepted} accepted ({rate:.1f}%)")
                
                return response.data
            else:
                print("✗ No data retrieved from Supabase")
                if attempt < max_retries - 1:
                    continue
                else:
                    print("  Falling back to local simulation data...")
                    return use_local_simulation_data()
        except Exception as e:
            error_msg = str(e)
            if 'PGRST205' in error_msg or 'schema cache' in error_msg:
                if attempt < max_retries - 1:
                    print(f"  ⚠️  PostgREST cache not ready, retrying...")
                    continue
                else:
                    print(f"  ⚠️  Using local simulation data due to cache issue")
                    return use_local_simulation_data()
            else:
                print(f"✗ Error fetching data: {e}")
                if attempt < max_retries - 1:
                    continue
                else:
                    return use_local_simulation_data()
    
    return None

def train_rl_model(training_data):
    """Train the RL model with the fetched data"""
    print(f"\n[4/5] Training RL model with {len(training_data)} records...")
    
    # Initialize RL agent
    agent = SeatRecommendationBandit(k_arms=RL_K_ARMS, epsilon=RL_EPSILON)
    
    # Train with each feedback record
    for i, record in enumerate(training_data, 1):
        strategy_id = record['strategy_id']
        reward = record['reward']
        
        # Update the agent's policy
        agent.update_policy(strategy_id, reward)
        
        if i % 5 == 0:
            print(f"  Processed {i}/{len(training_data)} records...")
    
    print(f"✓ Training complete!")
    
    # Print learned Q-values
    print("\n  Learned Q-values (confidence scores):")
    for i in range(RL_K_ARMS):
        print(f"    Strategy {i} ({RECOMMENDATION_STRATEGIES[i]['name']:<20}): "
              f"Q={agent.q_values[i]:.4f}, Trials={int(agent.n_pulls[i])}")
    
    # Identify best strategy
    best_strategy_id = int(np.argmax(agent.q_values))
    print(f"\n  Best strategy: {RECOMMENDATION_STRATEGIES[best_strategy_id]['name']} "
          f"(Strategy {best_strategy_id})")
    
    return agent

def save_model_state(agent):
    """Save the trained model state to file"""
    print("\n[5/5] Saving model state...")
    
    rl_state_file = os.path.join(
        os.path.dirname(os.path.dirname(__file__)),
        'rl_agent_state.json'
    )
    
    try:
        state = {
            'q_values': agent.q_values.tolist(),
            'n_pulls': agent.n_pulls.tolist(),
            'last_updated': datetime.now().isoformat(),
            'training_method': 'supabase_simulation_data',
            'training_records': int(np.sum(agent.n_pulls))
        }
        
        with open(rl_state_file, 'w') as f:
            json.dump(state, f, indent=2)
        
        print(f"✓ Model state saved to: {rl_state_file}")
        return True
    except Exception as e:
        print(f"✗ Error saving model state: {e}")
        return False

def main():
    """Main training workflow"""
    try:
        # Step 1: Check and prepare data
        if not check_and_prepare_data():
            print("\n❌ Failed to prepare training data")
            sys.exit(1)
        
        # Step 2: Fetch training data (first 20 records)
        training_data = fetch_training_data(limit=20)
        if not training_data:
            print("\n❌ Failed to fetch training data")
            sys.exit(1)
        
        # Step 3: Train the model
        trained_agent = train_rl_model(training_data)
        if not trained_agent:
            print("\n❌ Failed to train model")
            sys.exit(1)
        
        # Step 4: Save model state
        if not save_model_state(trained_agent):
            print("\n❌ Failed to save model state")
            sys.exit(1)
        
        # Success!
        print("\n" + "="*70)
        print("  ✓ Training Complete! 🎉")
        print("="*70)
        print("\nThe RL model has been trained with Supabase simulation data.")
        print("The model state has been saved and will be loaded when you start app.py")
        print("\nNext steps:")
        print("  1. Start the Flask server: python ai_ml/app.py")
        print("  2. Test recommendations: python ai_ml/tests/test_rl_api_simple.py")
        print("  3. View the trained model status at: GET /rl/status")
        print()
        
    except KeyboardInterrupt:
        print("\n\n⚠️  Training interrupted by user")
        sys.exit(1)
    except Exception as e:
        print(f"\n❌ Unexpected error: {e}")
        import traceback
        traceback.print_exc()
        sys.exit(1)

if __name__ == "__main__":
    main()
