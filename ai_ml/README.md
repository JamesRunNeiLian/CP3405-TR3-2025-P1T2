# SmartSeat AI/ML Module

## Overview

This module provides AI/ML capabilities for the SmartSeat system:
- **Occupancy Forecasting** - ARIMA model for predicting seat occupancy
- **RL Seat Recommendation** - Multi-Armed Bandit algorithm for optimizing seat recommendations

---

## Quick Start

### Installation
```bash
pip install -r requirements.txt
```

### Setup Supabase Database
Run the SQL schema in your Supabase dashboard:
```bash
# File: database/supabase_rl_schema.sql
```

### Start Server
```bash
python app.py
```

Server runs at: `http://localhost:5000`

### Test
```bash
python tests/test_rl_api.py
```

---

## API Endpoints

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/predict` | GET | Occupancy forecasting (ARIMA) |
| `/rl/recommend` | POST | Get seat zone recommendation |
| `/rl/feedback` | POST | Submit user feedback |
| `/rl/status` | GET | View RL model performance |
| `/rl/reset` | POST | Reset RL learning data |
| `/health` | GET | Health check |

---

## Reinforcement Learning System

### Algorithm: Multi-Armed Bandit (Epsilon-Greedy)

**4 Recommendation Strategies:**
- **Quiet Zone** (`quiet`) - Silent study areas
- **Near Door** (`door`) - Convenient access areas
- **Accessible Zone** (`accessible`) - Accessible seating
- **Group Study** (`group`) - Collaborative areas

**Learning Mechanism:**
- 90% Exploitation: Choose best strategy
- 10% Exploration: Try other strategies
- Q-value update: `Q_new = Q_old + (1/N) × (Reward - Q_old)`

### How It Works

```
1. System recommends a zone
   ↓
2. User selects a seat
   ↓
3. Feedback: accepted (in recommended zone) or rejected (different zone)
   ↓
4. Model updates confidence scores
   ↓
5. Better recommendations over time
```

---

## API Usage Examples

### Get Recommendation
```bash
curl -X POST http://localhost:5000/rl/recommend \
  -H "Content-Type: application/json" \
  -d '{"user_id": "student123", "classroom_id": "library_L1"}'
```

**Response:**
```json
{
  "strategy_id": 0,
  "strategy_name": "Quiet Zone",
  "zone": "quiet",
  "confidence": 0.85,
  "description": "Recommend seats in quiet study areas"
}
```

### Submit Feedback
```bash
curl -X POST http://localhost:5000/rl/feedback \
  -H "Content-Type: application/json" \
  -d '{
    "strategy_id": 0,
    "accepted": true,
    "user_id": "student123",
    "seat_id": "Q-A01"
  }'
```

### View Model Status
```bash
curl http://localhost:5000/rl/status
```

**Response:**
```json
{
  "strategies": [
    {"id": 0, "name": "Quiet Zone", "confidence": 0.85, "trials": 120},
    {"id": 1, "name": "Near Door", "confidence": 0.42, "trials": 45},
    {"id": 2, "name": "Accessible Zone", "confidence": 0.67, "trials": 80},
    {"id": 3, "name": "Group Study Zone", "confidence": 0.53, "trials": 65}
  ],
  "best_strategy": {"id": 0, "name": "Quiet Zone", "confidence": 0.85},
  "total_recommendations": 310
}
```

---

## Database Integration (Supabase)

### Tables Created

**`rl_recommendations`** - Stores all recommendations made
- user_id, classroom_id, strategy_id, zone, confidence, timestamp

**`rl_feedbacks`** - Stores user feedback for learning
- user_id, seat_id, strategy_id, accepted, reward, updated_confidence, timestamp

### Analytics Views

- `rl_strategy_performance` - Strategy success rates
- `rl_daily_activity` - Daily usage statistics  
- `rl_zone_popularity` - Zone popularity by acceptance rate

### Query Examples
```sql
-- View recent recommendations
SELECT * FROM rl_recommendations ORDER BY timestamp DESC LIMIT 10;

-- View strategy performance
SELECT * FROM rl_strategy_performance;

-- View zone popularity
SELECT * FROM rl_zone_popularity;
```

---

## Demo for Presentation

### Automated Demo
```bash
python tests/test_rl_api.py
```

This will:
1. Test health check
2. Test get recommendation
3. Test submit feedback
4. Test get status
5. Demonstrate learning (10 feedbacks)

### Manual Demo Script

```bash
# Terminal 1: Start server
python app.py

# Terminal 2: Run demo
# 1. View initial state
curl http://localhost:5000/rl/status

# 2. Get recommendation
curl -X POST http://localhost:5000/rl/recommend \
  -H "Content-Type: application/json" -d '{}'

# 3. Simulate 10 users accepting recommendation
for i in {1..10}; do
  curl -X POST http://localhost:5000/rl/feedback \
    -H "Content-Type: application/json" \
    -d '{"strategy_id":0,"accepted":true}'
done

# 4. View updated state (confidence increased!)
curl http://localhost:5000/rl/status
```

**Talking Points:**
- Initial: all strategies at 0% confidence
- After feedback: confidence increases to ~90%
- Model learned that users accept this strategy
- Future recommendations favor high-confidence strategies

---

## Project Structure

```
ai_ml/
├── README.md                           # This file
├── app.py                              # Flask API server
├── requirements.txt                    # Python dependencies
│
├── models/                             # ML models
│   ├── rl_baseline.py                  # Multi-Armed Bandit algorithm
│   ├── train.py                        # ARIMA model training
│   └── occupancy_forecastin_baseline.py # Forecasting baseline
│
├── config/                             # Configuration
│   └── supabase_config.py              # Supabase & API settings
│
├── database/                           # Database schemas
│   └── supabase_rl_schema.sql          # Supabase tables & views
│
├── tests/                              # Testing
│   ├── test_rl_api.py                  # API test script
│   └── RL_API_Postman_Collection.json  # Postman collection
│
├── rl_agent_state.json                 # RL model state (auto-generated)
└── arima_model.pkl                     # ARIMA model (auto-generated)
```

---

## Configuration

Edit `config/supabase_config.py`:

```python
# Supabase credentials
SUPABASE_URL = "your_supabase_url"
SUPABASE_KEY = "your_supabase_key"

# API settings
API_HOST = "0.0.0.0"
API_PORT = 5000
API_DEBUG = True

# RL settings
RL_EPSILON = 0.1  # Exploration rate (10%)
RL_K_ARMS = 4     # Number of strategies
```

---

## System Architecture

```
┌─────────────────┐
│  Frontend App   │
└────────┬────────┘
         │ HTTP REST
         ↓
┌─────────────────┐
│  Flask API      │
│  (app.py)       │
│  Port 5000      │
└────┬──────┬─────┘
     │      │
     ↓      ↓
┌─────────┐ ┌─────────────┐
│ RL Agent│ │  Supabase   │
│ (MAB)   │ │  Database   │
│         │ │             │
│ Q-values│ │ - History   │
└─────────┘ │ - Feedback  │
            │ - Analytics │
            └─────────────┘
```

---

## Features

✅ **Real-time Learning** - Model improves with each user interaction  
✅ **Persistent State** - Learning survives server restarts (JSON + Supabase)  
✅ **CORS Enabled** - Works with web/mobile frontends  
✅ **Analytics Ready** - Built-in views for performance tracking  
✅ **Production Ready** - Error handling, validation, logging  

---

## Troubleshooting

| Issue | Solution |
|-------|----------|
| `ModuleNotFoundError: flask_cors` | `pip install flask-cors` |
| `ModuleNotFoundError: supabase` | `pip install supabase` |
| Tables don't exist | Run `supabase_rl_schema.sql` in Supabase |
| Port 5000 in use | `lsof -ti:5000 \| xargs kill -9` |
| Supabase auth error | Check URL and key in `app.py` |

---

## Testing

### Quick Test
```bash
# Health check
curl http://localhost:5000/health

# Get recommendation
curl -X POST http://localhost:5000/rl/recommend -H "Content-Type: application/json" -d '{}'

# View status
curl http://localhost:5000/rl/status
```

### Postman
Import `tests/RL_API_Postman_Collection.json` into Postman for interactive testing.

---

## Key Technologies

- **Python** - Flask, NumPy, Pandas, Statsmodels
- **Algorithm** - Multi-Armed Bandit (Epsilon-Greedy), ARIMA
- **Database** - Supabase (PostgreSQL)
- **API** - RESTful with JSON responses

---

**Status: ✅ Complete & Ready for Integration**

All API endpoints tested and documented. Ready for frontend integration and presentation.

