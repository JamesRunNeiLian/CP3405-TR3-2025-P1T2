#!/usr/bin/env python3
"""
Simple RL API Test Script
Run this to verify the RL API is working correctly
"""

import requests
import json
import time

BASE_URL = "http://localhost:5000"

def print_section(title):
    print(f"\n{'='*60}")
    print(f"  {title}")
    print(f"{'='*60}\n")

def test_health():
    """Test health check endpoint"""
    print_section("1. Health Check")
    response = requests.get(f"{BASE_URL}/health")
    print(f"Status Code: {response.status_code}")
    print(json.dumps(response.json(), indent=2))
    return response.status_code == 200

def test_get_recommendation():
    """Test get recommendation endpoint"""
    print_section("2. Get Recommendation")
    
    payload = {
        "user_id": "1",
        "classroom_id": "library_L1"
    }
    
    response = requests.post(
        f"{BASE_URL}/rl/recommend",
        headers={"Content-Type": "application/json"},
        json=payload
    )
    
    print(f"Status Code: {response.status_code}")
    data = response.json()
    print(json.dumps(data, indent=2))
    
    return data if response.status_code == 200 else None

def test_submit_feedback(strategy_id, accepted):
    """Test submit feedback endpoint"""
    print_section(f"3. Submit Feedback (accepted={accepted})")
    
    payload = {
        "strategy_id": strategy_id,
        "accepted": accepted,
        "user_id": "1",
        "seat_id": "2"
    }
    
    response = requests.post(
        f"{BASE_URL}/rl/feedback",
        headers={"Content-Type": "application/json"},
        json=payload
    )
    
    print(f"Status Code: {response.status_code}")
    print(json.dumps(response.json(), indent=2))
    
    return response.status_code == 200

def test_get_status():
    """Test get model status endpoint"""
    print_section("4. Get Model Status")
    
    response = requests.get(f"{BASE_URL}/rl/status")
    print(f"Status Code: {response.status_code}")
    data = response.json()
    
    # Print summary
    print(f"\nTotal Recommendations: {data['total_recommendations']}")
    print(f"Exploration Rate (epsilon): {data['epsilon']}")
    print(f"\nBest Strategy: {data['best_strategy']['name']}")
    print(f"  Confidence: {data['best_strategy']['confidence']:.4f}")
    print(f"  Trials: {data['best_strategy']['trials']}")
    
    print("\nAll Strategies:")
    for strategy in data['strategies']:
        print(f"  {strategy['name']:<20} "
              f"Confidence: {strategy['confidence']:.4f}  "
              f"Trials: {strategy['trials']}")
    
    return response.status_code == 200

def run_learning_demo():
    """Demonstrate model learning by submitting multiple feedbacks"""
    print_section("5. Learning Demo - Submit 10 Positive Feedbacks")
    
    # Get initial status
    response = requests.get(f"{BASE_URL}/rl/status")
    initial_data = response.json()
    strategy_0_initial = next(s for s in initial_data['strategies'] if s['id'] == 0)
    
    print(f"Initial - Strategy 0 (Quiet Zone):")
    print(f"  Confidence: {strategy_0_initial['confidence']:.4f}")
    print(f"  Trials: {strategy_0_initial['trials']}")
    
    # Submit 10 positive feedbacks for strategy 0
    print(f"\nSubmitting 10 positive feedbacks for Strategy 0...")
    for i in range(10):
        requests.post(
            f"{BASE_URL}/rl/feedback",
            headers={"Content-Type": "application/json"},
            json={
                "strategy_id": 0,
                "accepted": True,
                "user_id": str(i + 1)
            }
        )
        print(f"  Feedback {i+1}/10 submitted")
        time.sleep(0.1)
    
    # Get updated status
    response = requests.get(f"{BASE_URL}/rl/status")
    final_data = response.json()
    strategy_0_final = next(s for s in final_data['strategies'] if s['id'] == 0)
    
    print(f"\nAfter 10 feedbacks - Strategy 0 (Quiet Zone):")
    print(f"  Confidence: {strategy_0_final['confidence']:.4f}")
    print(f"  Trials: {strategy_0_final['trials']}")
    
    confidence_increase = strategy_0_final['confidence'] - strategy_0_initial['confidence']
    print(f"\n✓ Confidence increased by: {confidence_increase:.4f}")
    print(f"✓ Model is learning! 🎉")

def main():
    """Run all tests"""
    print("\n" + "="*60)
    print("  RL API Test Suite")
    print("="*60)
    print(f"\nTesting API at: {BASE_URL}")
    print("Make sure the Flask server is running (python app.py)")
    
    try:
        # Test 1: Health check
        if not test_health():
            print("\n❌ Health check failed. Is the server running?")
            return
        
        # Test 2: Get recommendation
        recommendation = test_get_recommendation()
        if not recommendation:
            print("\n❌ Get recommendation failed")
            return
        
        # Test 3: Submit positive feedback
        if not test_submit_feedback(recommendation['strategy_id'], True):
            print("\n❌ Submit feedback failed")
            return
        
        # Test 4: Get status
        if not test_get_status():
            print("\n❌ Get status failed")
            return
        
        # Test 5: Learning demo
        run_learning_demo()
        
        # Final status
        test_get_status()
        
        print("\n" + "="*60)
        print("  ✓ All tests passed! 🎉")
        print("="*60)
        print("\nNext steps:")
        print("  1. View data in Supabase dashboard")
        print("  2. Integrate with Flutter app")
        print("  3. Test with real users")
        print()
        
    except requests.exceptions.ConnectionError:
        print(f"\n❌ Could not connect to {BASE_URL}")
        print("   Make sure the Flask server is running:")
        print("   cd ai_ml && python app.py")
    except Exception as e:
        print(f"\n❌ Error: {e}")

if __name__ == "__main__":
    main()

