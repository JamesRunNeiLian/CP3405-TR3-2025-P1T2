# train.py
# This script is responsible for training the model and saving it.

import sys
import os
import pandas as pd
import numpy as np
from statsmodels.tsa.arima.model import ARIMA
import pickle

# Add parent directory to path
sys.path.append(os.path.dirname(os.path.dirname(__file__)))

from supabase import create_client, Client
from config.supabase_config import SUPABASE_URL, SUPABASE_KEY

print("--- Starting Model Training Script ---")

# --- 1. Fetch Training Data from Supabase ---
print("Step 1: Connecting to Supabase...")
try:
    supabase: Client = create_client(SUPABASE_URL, SUPABASE_KEY)
    print("✓ Connected to Supabase")
except Exception as e:
    print(f"✗ Error connecting to Supabase: {e}")
    sys.exit(1)

print("\nStep 2: Fetching occupancy history data...")
try:
    response = supabase.table('occupancy_history')\
        .select('*')\
        .order('timestamp', desc=False)\
        .execute()
    
    if not response.data or len(response.data) == 0:
        print("✗ No occupancy data found in Supabase")
        print("   Please run: python3 generate_occupancy_data.py")
        sys.exit(1)
    
    # Convert to DataFrame
    data = pd.DataFrame(response.data)
    data['timestamp'] = pd.to_datetime(data['timestamp'])
    data.set_index('timestamp', inplace=True)
    data = data.sort_index()
    
    # Explicitly set hourly frequency to avoid warnings
    data.index = pd.DatetimeIndex(data.index, freq='H')
    
    print(f"✓ Fetched {len(data)} occupancy records from Supabase")
    print(f"  Date range: {data.index.min()} to {data.index.max()}")
    print(f"  Occupancy range: {data['occupancy_percentage'].min():.2f}% to {data['occupancy_percentage'].max():.2f}%")
    print(f"  Frequency: {data.index.freq} (hourly)")
    
except Exception as e:
    print(f"✗ Error fetching data: {e}")
    print("   Make sure the occupancy_history table exists in Supabase")
    sys.exit(1)


# --- 2. Model Training ---
# We train the ARIMA model on the entire dataset.
print("\nStep 3: Training the ARIMA model...")
# Using common parameters for a baseline model
model = ARIMA(data['occupancy_percentage'], order=(5, 1, 0))
model_fit = model.fit()
print("Model training complete.")
print(model_fit.summary())


# --- 3. Save the Trained Model ---
# We use the 'pickle' library to serialize our trained model and save it to a file.
# This file can then be loaded by our API later without needing to retrain.
model_filename = 'arima_model.pkl'
print(f"\nStep 4: Saving the trained model to '{model_filename}'...")
with open(model_filename, 'wb') as file:
    pickle.dump(model_fit, file)