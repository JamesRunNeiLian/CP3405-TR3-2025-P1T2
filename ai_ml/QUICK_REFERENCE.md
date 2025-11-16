# Quick Reference

## Directory Structure

```
ai_ml/
├── app.py                    # Flask API server (main entry point)
├── requirements.txt          # Python dependencies
├── README.md                 # Full documentation
│
├── config/                   # Configuration files
│   └── supabase_config.py    # Supabase URL, API settings, RL parameters
│
├── models/                   # Machine learning models
│   ├── rl_baseline.py        # Multi-Armed Bandit (RL algorithm)
│   ├── train.py              # ARIMA model training script
│   └── occupancy_forecastin_baseline.py  # Forecasting baseline
│
├── database/                 # Database schemas
│   └── supabase_rl_schema.sql  # SQL for Supabase tables
│
└── tests/                    # Testing scripts
    ├── test_rl_api.py        # API test script
    └── RL_API_Postman_Collection.json  # Postman collection
```

---

## Quick Commands

### Setup
```bash
# Install dependencies
pip install -r requirements.txt

# Setup database (run SQL in Supabase dashboard)
# File: database/supabase_rl_schema.sql

# Configure (optional)
# Edit: config/supabase_config.py
```

### Run
```bash
# Start server
python app.py

# Test API
python tests/test_rl_api.py
```

### API Endpoints
```bash
# Health check
curl http://localhost:5000/health

# Get recommendation
curl -X POST http://localhost:5000/rl/recommend \
  -H "Content-Type: application/json" \
  -d '{"user_id":"test","classroom_id":"room1"}'

# Submit feedback
curl -X POST http://localhost:5000/rl/feedback \
  -H "Content-Type: application/json" \
  -d '{"strategy_id":0,"accepted":true}'

# View status
curl http://localhost:5000/rl/status
```

---

## Configuration Files

**`config/supabase_config.py`** - Edit to change:
- Supabase URL and key
- API host/port
- RL exploration rate (epsilon)
- Number of strategies

**`app.py`** - Main API server (rarely needs editing)

---

## Key Files to Know

| File | Purpose | When to Edit |
|------|---------|--------------|
| `config/supabase_config.py` | Settings | Always (set your credentials) |
| `app.py` | API server | Rarely (add new endpoints) |
| `models/rl_baseline.py` | RL algorithm | Rarely (modify algorithm) |
| `database/supabase_rl_schema.sql` | DB schema | Once (initial setup) |
| `tests/test_rl_api.py` | Tests | For debugging |

---

## Common Tasks

### Change Supabase Credentials
Edit `config/supabase_config.py`:
```python
SUPABASE_URL = "your_url_here"
SUPABASE_KEY = "your_key_here"
```

### Change API Port
Edit `config/supabase_config.py`:
```python
API_PORT = 8080  # Change from 5000
```

### Adjust RL Exploration Rate
Edit `config/supabase_config.py`:
```python
RL_EPSILON = 0.2  # 20% exploration (default: 0.1)
```

### Add New Recommendation Strategy
Edit `app.py`, find `RECOMMENDATION_STRATEGIES` array:
```python
RECOMMENDATION_STRATEGIES.append({
    "id": 4,
    "name": "Window Seats",
    "description": "Recommend window seats",
    "zone": "window"
})
```

Also update in `config/supabase_config.py`:
```python
RL_K_ARMS = 5  # Increase from 4
```

---

## Troubleshooting

| Problem | Solution |
|---------|----------|
| `ModuleNotFoundError` | Run `pip install -r requirements.txt` |
| Can't connect to server | Check if server is running: `python app.py` |
| Port 5000 in use | Change port in `config/supabase_config.py` |
| Tables don't exist | Run `database/supabase_rl_schema.sql` in Supabase |
| Import errors | Make sure you're in `ai_ml/` directory |

---

## For Presentation

**Quick Demo:**
```bash
# Terminal 1
python app.py

# Terminal 2
python tests/test_rl_api.py
```

**Manual Demo:**
```bash
# 1. Show initial state
curl http://localhost:5000/rl/status

# 2. Get recommendation
curl -X POST http://localhost:5000/rl/recommend \
  -H "Content-Type: application/json" -d '{}'

# 3. Simulate 10 positive feedbacks
for i in {1..10}; do
  curl -X POST http://localhost:5000/rl/feedback \
    -H "Content-Type: application/json" \
    -d '{"strategy_id":0,"accepted":true}'
done

# 4. Show updated state (confidence increased!)
curl http://localhost:5000/rl/status
```

---

## Documentation

- **Full docs**: `README.md`
- **This file**: Quick reference
- **Code comments**: All files have detailed comments

