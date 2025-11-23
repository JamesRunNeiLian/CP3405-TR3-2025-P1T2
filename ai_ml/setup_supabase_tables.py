#!/usr/bin/env python3
"""
Setup Supabase Tables Script
=============================
This script creates the necessary tables in Supabase for RL training.
Run this BEFORE running the training script.
"""

import sys
import os

# Add parent directory to path
sys.path.append(os.path.dirname(__file__))

from supabase import create_client, Client
from config.supabase_config import SUPABASE_URL, SUPABASE_KEY

print("="*70)
print("  Supabase Table Setup")
print("="*70)

print("\n[1/2] Connecting to Supabase...")
try:
    supabase: Client = create_client(SUPABASE_URL, SUPABASE_KEY)
    print("✓ Connected to Supabase")
except Exception as e:
    print(f"✗ Error connecting to Supabase: {e}")
    sys.exit(1)

print("\n[2/2] Creating tables...")
print("\nIMPORTANT: This script requires admin access to create tables.")
print("Please run the SQL commands manually in your Supabase SQL Editor:")
print("\n" + "="*70)
print("\nStep 1: Go to your Supabase Dashboard")
print("  https://app.supabase.com/project/" + SUPABASE_URL.split('//')[1].split('.')[0] + "/sql/new")
print("\nStep 2: Copy and paste the following SQL:")
print("\n" + "="*70)

sql_schema = """
-- RL Recommendations Table
CREATE TABLE IF NOT EXISTS rl_recommendations (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id TEXT,
    classroom_id TEXT,
    strategy_id INTEGER NOT NULL,
    strategy_name TEXT NOT NULL,
    zone TEXT NOT NULL,
    confidence DECIMAL(5,4),
    timestamp TIMESTAMPTZ DEFAULT NOW(),
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- RL Feedbacks Table (for training)
CREATE TABLE IF NOT EXISTS rl_feedbacks (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id TEXT,
    seat_id TEXT,
    strategy_id INTEGER NOT NULL,
    strategy_name TEXT NOT NULL,
    accepted BOOLEAN NOT NULL,
    reward INTEGER NOT NULL,
    updated_confidence DECIMAL(5,4),
    timestamp TIMESTAMPTZ DEFAULT NOW(),
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Add indexes
CREATE INDEX IF NOT EXISTS idx_rl_feedbacks_user_id ON rl_feedbacks(user_id);
CREATE INDEX IF NOT EXISTS idx_rl_feedbacks_strategy_id ON rl_feedbacks(strategy_id);
CREATE INDEX IF NOT EXISTS idx_rl_feedbacks_timestamp ON rl_feedbacks(timestamp);
"""

print(sql_schema)
print("="*70)

print("\nStep 3: Click 'Run' to execute the SQL")
print("\nStep 4: After tables are created, run the training script:")
print("  python3 models/rl_train_with_supabase.py")
print("\n" + "="*70)

# Try to verify tables exist (read-only check)
print("\n\nAttempting to verify tables...")
try:
    response = supabase.table('rl_feedbacks').select('id').limit(1).execute()
    print("✓ Table 'rl_feedbacks' exists!")
    print("\nYou can now run the training script:")
    print("  python3 models/rl_train_with_supabase.py")
except Exception as e:
    print("✗ Tables not found. Please create them using the SQL above.")
    print(f"  Error: {e}")
