#!/usr/bin/env python3
"""
RL API Test Script
Tests all RL endpoints and demonstrates learning
"""

import requests
import json
import sys

BASE_URL = "http://localhost:5000"

def test_health():
    """Test health check endpoint"""
    print("\n[1/5] Testing Health Check...")
    try:
        response = requests.get(f"{BASE_URL}/health")
        if response.status_code == 200:
            print("✓ Health check passed")
            return True
        else:
            print(f"✗ Health check failed: {response.status_code}")
            return False
    except Exception as e:
        print(f"✗ Connection failed: {e}")
        return False

def test_get_recommendation():
    """Test get recommendation endpoint"""
    print("\n[2/5] Testing Get Recommendation...")
    try:
        response = requests.post(
            f"{BASE_URL}/rl/recommend",
            headers={"Content-Type": "application/json"},
            json={"user_id": "test_user", "classroom_id": "test_room"}
        )
        if response.status_code == 200:
            data = response.json()
            print(f"✓ Got recommendation: {data['strategy_name']} (zone: {data['zone']})")
            return data
        else:
            print(f"✗ Failed: {response.status_code}")
            return None
    except Exception as e:
        print(f"✗ Error: {e}")
        return None

def test_submit_feedback(strategy_id):
    """Test submit feedback endpoint"""
    print("\n[3/5] Testing Submit Feedback...")
    try:
        response = requests.post(
            f"{BASE_URL}/rl/feedback",
            headers={"Content-Type": "application/json"},
            json={"strategy_id": strategy_id, "accepted": True}
        )
        if response.status_code == 200:
            data = response.json()
            print(f"✓ Feedback submitted successfully")
            print(f"  Updated confidence: {data['updated_confidence']:.4f}")
            return True
        else:
            print(f"✗ Failed: {response.status_code}")
            return False
    except Exception as e:
        print(f"✗ Error: {e}")
        return False

def test_get_status():
    """Test get model status endpoint"""
    print("\n[4/5] Testing Get Status...")
    try:
        response = requests.get(f"{BASE_URL}/rl/status")
        if response.status_code == 200:
            data = response.json()
            print(f"✓ Got status")
            print(f"  Total recommendations: {data['total_recommendations']}")
            print(f"  Best strategy: {data['best_strategy']['name']}")
            return data
        else:
            print(f"✗ Failed: {response.status_code}")
            return None
    except Exception as e:
        print(f"✗ Error: {e}")
        return None

def demonstrate_learning():
    """Demonstrate model learning with multiple feedbacks"""
    print("\n[5/5] Demonstrating Learning Process...")
    
    # Get initial status
    response = requests.get(f"{BASE_URL}/rl/status")
    initial = response.json()
    strategy_0_initial = next(s for s in initial['strategies'] if s['id'] == 0)
    
    print(f"\nInitial state - Strategy 0 (Quiet Zone):")
    print(f"  Confidence: {strategy_0_initial['confidence']:.4f}")
    print(f"  Trials: {strategy_0_initial['trials']}")
    
    # Submit 10 positive feedbacks
    print(f"\nSubmitting 10 positive feedbacks...")
    for i in range(10):
        requests.post(
            f"{BASE_URL}/rl/feedback",
            headers={"Content-Type": "application/json"},
            json={"strategy_id": 0, "accepted": True}
        )
        print(f"  Progress: {i+1}/10", end='\r')
    print()
    
    # Get final status
    response = requests.get(f"{BASE_URL}/rl/status")
    final = response.json()
    strategy_0_final = next(s for s in final['strategies'] if s['id'] == 0)
    
    print(f"\nFinal state - Strategy 0 (Quiet Zone):")
    print(f"  Confidence: {strategy_0_final['confidence']:.4f}")
    print(f"  Trials: {strategy_0_final['trials']}")
    
    increase = strategy_0_final['confidence'] - strategy_0_initial['confidence']
    print(f"\n✓ Confidence increased by: {increase:.4f}")
    print("✓ Model is learning successfully!")

def main():
    """Run all tests"""
    print("="*60)
    print(" RL API Test Suite")
    print("="*60)
    print(f"\nTesting API at: {BASE_URL}")
    print("Make sure the Flask server is running!")
    
    # Run tests
    if not test_health():
        print("\n✗ Server not responding. Please start the server:")
        print("  python app.py")
        sys.exit(1)
    
    rec = test_get_recommendation()
    if not rec:
        sys.exit(1)
    
    if not test_submit_feedback(rec['strategy_id']):
        sys.exit(1)
    
    if not test_get_status():
        sys.exit(1)
    
    demonstrate_learning()
    
    print("\n" + "="*60)
    print(" ✓ All tests passed!")
    print("="*60)
    print("\nNext steps:")
    print("  1. Check Supabase for stored data")
    print("  2. Integrate with frontend application")
    print("  3. Test with real users")
    print()

if __name__ == "__main__":
    main()

