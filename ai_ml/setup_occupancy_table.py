#!/usr/bin/env python3
"""
Setup Occupancy Table in Supabase
==================================
This script provides instructions for creating the occupancy_history table.
"""

import sys
import os

sys.path.append(os.path.dirname(__file__))

from config.supabase_config import SUPABASE_URL

print("="*70)
print("  Supabase Occupancy Table Setup")
print("="*70)

print("\nTo store occupancy history data for ARIMA training:")
print("\n" + "="*70)
print("\nStep 1: Go to your Supabase Dashboard SQL Editor")
print(f"  https://app.supabase.com/project/{SUPABASE_URL.split('//')[1].split('.')[0]}/sql/new")

print("\nStep 2: Copy and paste the following SQL:")
print("\n" + "="*70)

sql_schema = """
-- Occupancy History Table
CREATE TABLE IF NOT EXISTS occupancy_history (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    classroom_id TEXT,
    timestamp TIMESTAMPTZ NOT NULL,
    occupancy_percentage DECIMAL(5,2) NOT NULL,
    total_seats INTEGER,
    occupied_seats INTEGER,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Add indexes
CREATE INDEX IF NOT EXISTS idx_occupancy_timestamp ON occupancy_history(timestamp);
CREATE INDEX IF NOT EXISTS idx_occupancy_classroom ON occupancy_history(classroom_id);

-- Add constraint
DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint 
        WHERE conname = 'check_occupancy_range'
    ) THEN
        ALTER TABLE occupancy_history 
            ADD CONSTRAINT check_occupancy_range 
            CHECK (occupancy_percentage >= 0 AND occupancy_percentage <= 100);
    END IF;
END $$;
"""

print(sql_schema)
print("="*70)

print("\nStep 3: Click 'Run' to execute the SQL")
print("\nStep 4: Generate historical data:")
print("  python3 generate_occupancy_data.py")
print("\nStep 5: Train the ARIMA model:")
print("  python3 models/train.py")
print("\n" + "="*70)
