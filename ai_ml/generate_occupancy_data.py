#!/usr/bin/env python3
"""
Generate Historical Occupancy Data to Supabase
================================================
This script generates mock historical occupancy data and uploads it to Supabase
for ARIMA model training.
"""

import sys
import os
import pandas as pd
import numpy as np
from datetime import datetime

# Add parent directory to path
sys.path.append(os.path.dirname(__file__))

from supabase import create_client, Client
from config.supabase_config import SUPABASE_URL, SUPABASE_KEY

print("="*70)
print("  Generate Historical Occupancy Data to Supabase")
print("="*70)

# Connect to Supabase
print("\n[1/3] Connecting to Supabase...")
try:
    supabase: Client = create_client(SUPABASE_URL, SUPABASE_KEY)
    print("✓ Connected to Supabase")
except Exception as e:
    print(f"✗ Error connecting to Supabase: {e}")
    sys.exit(1)

# Generate mock occupancy data
print("\n[2/3] Generating historical occupancy data...")
date_rng = pd.date_range(start='2025/09/22', end='2025/12/14', freq='H')
data = pd.DataFrame(date_rng, columns=['timestamp'])

# Generate realistic occupancy patterns
baseline_occupancy = np.sin(np.linspace(0, 2 * np.pi * 84, len(data))) * 25 + 50
weekday_multiplier = np.where(data['timestamp'].dt.dayofweek < 5, 1.2, 0.4)
data['occupancy_percentage'] = baseline_occupancy * weekday_multiplier + np.random.randn(len(data)) * 3
data['occupancy_percentage'] = np.clip(data['occupancy_percentage'], 0, 100)

# Add classroom_id
data['classroom_id'] = 'library_L1'

print(f"✓ Generated {len(data)} occupancy records")
print(f"  Date range: {data['timestamp'].min()} to {data['timestamp'].max()}")
print(f"  Occupancy range: {data['occupancy_percentage'].min():.2f}% to {data['occupancy_percentage'].max():.2f}%")

# Upload to Supabase in batches
print("\n[3/3] Uploading data to Supabase...")
batch_size = 500
total_records = len(data)

for i in range(0, total_records, batch_size):
    batch = data.iloc[i:i+batch_size]
    records = []
    
    for _, row in batch.iterrows():
        records.append({
            'classroom_id': row['classroom_id'],
            'timestamp': row['timestamp'].isoformat(),
            'occupancy_percentage': float(row['occupancy_percentage'])
        })
    
    try:
        supabase.table('occupancy_history').insert(records).execute()
        print(f"  Uploaded batch {i//batch_size + 1}/{(total_records + batch_size - 1)//batch_size} ({len(records)} records)")
    except Exception as e:
        print(f"✗ Error uploading batch: {e}")
        sys.exit(1)

print(f"\n✓ Successfully uploaded {total_records} occupancy records to Supabase")
print("\n" + "="*70)
print("  Data Upload Complete! 🎉")
print("="*70)
print("\nNext steps:")
print("  1. Run training script: python3 models/train.py")
print("  2. Start Flask server: python3 app.py")
print()
