# RL API Examples - Request & Response

## Example 1: Get Recommendation (Initial State)

**Request:**
```http
POST /rl/recommend HTTP/1.1
Host: localhost:5000
Content-Type: application/json

{
  "user_id": "student123",
  "classroom_id": "library-L1"
}
```

**Response:**
```json
{
  "strategy_id": 0,
  "strategy_name": "Quiet Zone",
  "description": "Recommend seats in quiet study areas",
  "zone": "quiet",
  "confidence": 0.0,
  "timestamp": "2025-11-07T14:30:00.123456",
  "user_id": "student123",
  "classroom_id": "library-L1"
}
```

---

## Example 2: Submit Positive Feedback

**Request:**
```http
POST /rl/feedback HTTP/1.1
Host: localhost:5000
Content-Type: application/json

{
  "strategy_id": 0,
  "accepted": true,
  "user_id": "student123",
  "seat_id": "Q-A01"
}
```

**Response:**
```json
{
  "success": true,
  "message": "Feedback recorded and model updated",
  "strategy_id": 0,
  "strategy_name": "Quiet Zone",
  "reward": 1,
  "updated_confidence": 1.0,
  "total_trials": 1,
  "timestamp": "2025-11-07T14:31:00.234567"
}
```

---

## Example 3: Submit Negative Feedback

**Request:**
```http
POST /rl/feedback HTTP/1.1
Host: localhost:5000
Content-Type: application/json

{
  "strategy_id": 1,
  "accepted": false,
  "user_id": "student124"
}
```

**Response:**
```json
{
  "success": true,
  "message": "Feedback recorded and model updated",
  "strategy_id": 1,
  "strategy_name": "Near Door",
  "reward": 0,
  "updated_confidence": 0.0,
  "total_trials": 1,
  "timestamp": "2025-11-07T14:32:00.345678"
}
```

---

## Example 4: Get Model Status (After Learning)

**Request:**
```http
GET /rl/status HTTP/1.1
Host: localhost:5000
```

**Response:**
```json
{
  "strategies": [
    {
      "id": 0,
      "name": "Quiet Zone",
      "description": "Recommend seats in quiet study areas",
      "zone": "quiet",
      "confidence": 0.85,
      "trials": 120
    },
    {
      "id": 1,
      "name": "Near Door",
      "description": "Recommend seats near the entrance (convenient for latecomers)",
      "zone": "door",
      "confidence": 0.42,
      "trials": 45
    },
    {
      "id": 2,
      "name": "Accessible Zone",
      "description": "Recommend seats in accessible areas",
      "zone": "accessible",
      "confidence": 0.67,
      "trials": 80
    },
    {
      "id": 3,
      "name": "Group Study Zone",
      "description": "Recommend seats in group study areas",
      "zone": "group",
      "confidence": 0.53,
      "trials": 65
    }
  ],
  "best_strategy": {
    "id": 0,
    "name": "Quiet Zone",
    "description": "Recommend seats in quiet study areas",
    "zone": "quiet",
    "confidence": 0.85,
    "trials": 120
  },
  "total_recommendations": 310,
  "epsilon": 0.1,
  "timestamp": "2025-11-07T14:35:00.456789"
}
```

---

## Example 5: Health Check

**Request:**
```http
GET /health HTTP/1.1
Host: localhost:5000
```

**Response:**
```json
{
  "status": "healthy",
  "services": {
    "occupancy_forecasting": "available",
    "rl_recommendation": "available"
  },
  "timestamp": "2025-11-07T14:36:00.567890"
}
```

---

## Example 6: Reset Model

**Request:**
```http
POST /rl/reset HTTP/1.1
Host: localhost:5000
```

**Response:**
```json
{
  "success": true,
  "message": "RL model has been reset, all learning data cleared"
}
```

---

## Error Examples

### Missing Required Parameters

**Request:**
```http
POST /rl/feedback HTTP/1.1
Host: localhost:5000
Content-Type: application/json

{
  "strategy_id": 0
}
```

**Response (400 Bad Request):**
```json
{
  "error": "Missing required parameters: strategy_id and accepted"
}
```

---

### Invalid Strategy ID

**Request:**
```http
POST /rl/feedback HTTP/1.1
Host: localhost:5000
Content-Type: application/json

{
  "strategy_id": 99,
  "accepted": true
}
```

**Response (400 Bad Request):**
```json
{
  "error": "Invalid strategy_id: 99"
}
```

---

## Learning Progress Visualization

### After 10 Iterations

```
Strategy Performance:
┌────────────────────┬────────────┬────────┐
│ Strategy           │ Confidence │ Trials │
├────────────────────┼────────────┼────────┤
│ Quiet Zone         │ 0.70       │ 7      │
│ Near Door          │ 0.33       │ 1      │
│ Accessible Zone    │ 0.50       │ 1      │
│ Group Study Zone   │ 0.00       │ 1      │
└────────────────────┴────────────┴────────┘
```

### After 100 Iterations

```
Strategy Performance:
┌────────────────────┬────────────┬────────┐
│ Strategy           │ Confidence │ Trials │
├────────────────────┼────────────┼────────┤
│ Quiet Zone ⭐      │ 0.85       │ 60     │
│ Near Door          │ 0.40       │ 15     │
│ Accessible Zone    │ 0.65       │ 18     │
│ Group Study Zone   │ 0.50       │ 7      │
└────────────────────┴────────────┴────────┘

⭐ = Best Strategy
```

### After 1000 Iterations (Converged)

```
Strategy Performance:
┌────────────────────┬────────────┬────────┐
│ Strategy           │ Confidence │ Trials │
├────────────────────┼────────────┼────────┤
│ Quiet Zone ⭐      │ 0.87       │ 750    │
│ Near Door          │ 0.41       │ 100    │
│ Accessible Zone    │ 0.68       │ 100    │
│ Group Study Zone   │ 0.52       │ 50     │
└────────────────────┴────────────┴────────┘

🎯 Model has learned: 87% of users accept Quiet Zone recommendations
```

---

## Full Workflow Example

```javascript
// 1. User enters seat selection page
const recommendation = await fetch('http://localhost:5000/rl/recommend', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({
    user_id: 'student123',
    classroom_id: 'library-L1'
  })
}).then(r => r.json());

// recommendation = {
//   strategy_id: 0,
//   strategy_name: "Quiet Zone",
//   zone: "quiet",
//   confidence: 0.85
// }

// 2. Highlight seats in the "quiet" zone
highlightSeats(recommendation.zone);
showToast(`We recommend: ${recommendation.strategy_name} (${(recommendation.confidence * 100).toFixed(0)}% match rate)`);

// 3. User selects a seat
const selectedSeat = { id: "Q-A01", zone: "quiet" };

// 4. Submit feedback
const accepted = (selectedSeat.zone === recommendation.zone);
await fetch('http://localhost:5000/rl/feedback', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({
    strategy_id: recommendation.strategy_id,
    accepted: accepted,
    user_id: 'student123',
    seat_id: selectedSeat.id
  })
});

// Model has now learned from this interaction!
```

---

## cURL Test Suite

```bash
#!/bin/bash
# Quick test script for RL API

BASE_URL="http://localhost:5000"

echo "1. Health Check"
curl -s $BASE_URL/health | jq .

echo -e "\n2. Get Recommendation"
RESPONSE=$(curl -s -X POST $BASE_URL/rl/recommend \
  -H "Content-Type: application/json" \
  -d '{"user_id":"test_user"}')
echo $RESPONSE | jq .

# Extract strategy_id for feedback
STRATEGY_ID=$(echo $RESPONSE | jq -r '.strategy_id')

echo -e "\n3. Submit Positive Feedback"
curl -s -X POST $BASE_URL/rl/feedback \
  -H "Content-Type: application/json" \
  -d "{\"strategy_id\":$STRATEGY_ID,\"accepted\":true}" | jq .

echo -e "\n4. View Status"
curl -s $BASE_URL/rl/status | jq .
```

Save as `test_rl_api.sh` and run:
```bash
chmod +x test_rl_api.sh
./test_rl_api.sh
```

