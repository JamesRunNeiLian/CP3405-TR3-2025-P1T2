# train.py
# This script is responsible for training the model and saving it.

import pandas as pd
import numpy as np
from statsmodels.tsa.arima.model import ARIMA
import pickle

print("--- Starting Model Training Script ---")

# --- 1. Mock Data Generation ---
# This section is the same as before, generating our training data.
print("Step 1: Generating mock training data...")
date_rng = pd.date_range(start='2025/09/22', end='2025/12/14', freq='H')
data = pd.DataFrame(date_rng, columns=['time'])
data.set_index('time', inplace=True)

baseline_occupancy = np.sin(np.linspace(0, 2 * np.pi * 84, len(data))) * 25 + 50
weekday_multiplier = np.where(data.index.dayofweek < 5, 1.2, 0.4)
data['occupancy_percentage'] = baseline_occupancy * weekday_multiplier + np.random.randn(len(data)) * 3
data['occupancy_percentage'] = np.clip(data['occupancy_percentage'], 0, 100)
print("Mock data generated successfully.")


# --- 2. Model Training ---
# We train the ARIMA model on the entire dataset.
# [cite_start]This model choice is based on the project brief's suggestion for forecasting[cite: 38].
print("Step 2: Training the ARIMA model...")
# Using common parameters for a baseline model
model = ARIMA(data['occupancy_percentage'], order=(5, 1, 0))
model_fit = model.fit()
print("Model training complete.")
print(model_fit.summary())


# --- 3. Save the Trained Model ---
# We use the 'pickle' library to serialize our trained model and save it to a file.
# This file can then be loaded by our API later without needing to retrain.
model_filename = 'arima_model.pkl'
print(f"Step 3: Saving the trained model to '{model_filename}'...")
with open(model_filename, 'wb') as file:
    pickle.dump(model_fit, file)