#!/usr/bin/env python3
"""
Regenerate RL Feedback Data in Supabase
========================================
This script clears old RL data and regenerates simulation feedback data
with pure numeric user_id and seat_id (no padding, no prefixes).
"""

import sys
import os
import random
from datetime import datetime, timedelta

# Add parent directory to path
sys.path.append(os.path.dirname(__file__))

from supabase import create_client, Client
from config.supabase_config import SUPABASE_URL, SUPABASE_KEY

print("="*70)
print("  Regenerate RL Feedback Data in Supabase")
print("="*70)

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

# Connect to Supabase
print("\n[1/4] Connecting to Supabase...")
try:
    supabase: Client = create_client(SUPABASE_URL, SUPABASE_KEY)
    print("✓ Connected to Supabase")
except Exception as e:
    print(f"✗ Error connecting to Supabase: {e}")
    sys.exit(1)

# Clear existing data
print("\n[2/4] Clearing existing RL feedback data...")
try:
    # Delete all records
    response = supabase.table('rl_feedbacks').delete().neq('id', '00000000-0000-0000-0000-000000000000').execute()
    print("✓ Cleared existing data")
except Exception as e:
    print(f"⚠️  Warning: Could not clear data: {e}")
    print("   Continuing anyway...")

# Generate new simulation data
print("\n[3/4] Generating new simulation feedback data...")
print("  Using pure numeric IDs (no padding, no prefixes)")

# True acceptance rates for each strategy (ground truth)
true_acceptance_rates = [0.85, 0.40, 0.60, 0.50]

num_records = 50
simulation_data = []
base_time = datetime.now() - timedelta(days=7)  # Start from 7 days ago

for i in range(num_records):
    # Randomly select a strategy
    strategy_id = random.randint(0, 3)
    strategy = RECOMMENDATION_STRATEGIES[strategy_id]
    
    # Simulate user acceptance based on true acceptance rate
    accepted = random.random() < true_acceptance_rates[strategy_id]
    reward = 1 if accepted else 0
    
    # Create feedback record with pure numeric IDs
    record = {
        'user_id': str(i),  # Pure numeric: "0", "1", "2", ..., "49"
        'seat_id': str(random.randint(1, 20)),  # Pure numeric: "1" to "20"
        'strategy_id': strategy_id,
        'strategy_name': strategy['name'],
        'accepted': accepted,
        'reward': reward,
        'updated_confidence': 0.0,
        'timestamp': (base_time + timedelta(hours=i)).isoformat()
    }
    
    simulation_data.append(record)

print(f"✓ Generated {len(simulation_data)} simulation records")

# Print distribution
print("\n  Data distribution:")
for sid in range(4):
    count = sum(1 for r in simulation_data if r['strategy_id'] == sid)
    accepted = sum(1 for r in simulation_data if r['strategy_id'] == sid and r['accepted'])
    rate = (accepted / count * 100) if count > 0 else 0
    print(f"    Strategy {sid} ({RECOMMENDATION_STRATEGIES[sid]['name']:<20}): "
          f"{count} records, {accepted} accepted ({rate:.1f}%)")

# Upload to Supabase
print("\n[4/4] Uploading new data to Supabase...")
try:
    response = supabase.table('rl_feedbacks').insert(simulation_data).execute()
    print(f"✓ Successfully uploaded {len(simulation_data)} records")
except Exception as e:
    print(f"✗ Error uploading data: {e}")
    sys.exit(1)

print("\n" + "="*70)
print("  RL Data Regeneration Complete! 🎉")
print("="*70)
print("\nSample IDs in database:")
print("  user_id: 0, 1, 2, ..., 49 (pure numeric)")
print("  seat_id: 1, 2, 3, ..., 20 (pure numeric)")
print("\nNext steps:")
print("  1. Retrain RL model: python3 models/rl_train_with_supabase.py")
print("  2. Start Flask server: python3 app.py")
print()
