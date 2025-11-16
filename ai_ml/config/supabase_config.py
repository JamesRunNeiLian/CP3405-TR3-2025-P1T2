"""
Supabase Configuration
Update these values with your Supabase project credentials
"""

# Supabase Project Settings
# Get these from: https://app.supabase.com/project/_/settings/api
SUPABASE_URL = "https://vqjtaaejsjovdiotacqe.supabase.co"
SUPABASE_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZxanRhYWVqc2pvdmRpb3RhY3FlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjE4ODkyNTMsImV4cCI6MjA3NzQ2NTI1M30.FpbGZXWULKY4YqREvvaWy7D2BcgyO7RiFURAA6J_2js"

# API Configuration
API_HOST = "0.0.0.0"
API_PORT = 5000
API_DEBUG = True

# RL Model Configuration
RL_EPSILON = 0.1  # Exploration rate (10%)
RL_K_ARMS = 4     # Number of recommendation strategies

