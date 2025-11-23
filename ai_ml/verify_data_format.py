#!/usr/bin/env python3
"""
Verify Data Format in Supabase
================================
This script checks that all IDs are pure numeric (no padding, no prefixes).
"""

import sys
import os

sys.path.append(os.path.dirname(__file__))

from supabase import create_client, Client
from config.supabase_config import SUPABASE_URL, SUPABASE_KEY

print("="*70)
print("  Verify Data Format in Supabase")
print("="*70)

# Connect to Supabase
print("\n[1/2] Connecting to Supabase...")
try:
    supabase: Client = create_client(SUPABASE_URL, SUPABASE_KEY)
    print("✓ Connected to Supabase")
except Exception as e:
    print(f"✗ Error: {e}")
    sys.exit(1)

# Check RL Feedbacks
print("\n[2/2] Checking RL feedback data format...")
try:
    response = supabase.table('rl_feedbacks').select('user_id, seat_id').limit(10).execute()
    
    if response.data:
        print(f"✓ Found {len(response.data)} sample records")
        print("\n  Sample user_id and seat_id values:")
        for i, record in enumerate(response.data[:5], 1):
            user_id = record.get('user_id', 'N/A')
            seat_id = record.get('seat_id', 'N/A')
            print(f"    {i}. user_id: '{user_id}' (type: {type(user_id).__name__}), "
                  f"seat_id: '{seat_id}' (type: {type(seat_id).__name__})")
        
        # Verify format
        print("\n  Format validation:")
        all_valid = True
        for record in response.data:
            user_id = str(record.get('user_id', ''))
            seat_id = str(record.get('seat_id', ''))
            
            # Check if numeric and no leading zeros (except "0" itself)
            if not user_id.isdigit():
                print(f"    ✗ Invalid user_id: '{user_id}' (not numeric)")
                all_valid = False
            elif len(user_id) > 1 and user_id[0] == '0':
                print(f"    ✗ Invalid user_id: '{user_id}' (has leading zero)")
                all_valid = False
            
            if not seat_id.isdigit():
                print(f"    ✗ Invalid seat_id: '{seat_id}' (not numeric)")
                all_valid = False
            elif len(seat_id) > 1 and seat_id[0] == '0':
                print(f"    ✗ Invalid seat_id: '{seat_id}' (has leading zero)")
                all_valid = False
        
        if all_valid:
            print("    ✓ All IDs are pure numeric (no padding, no prefixes)")
        
except Exception as e:
    print(f"✗ Error: {e}")

print("\n" + "="*70)
print("  Verification Complete!")
print("="*70)
print()
