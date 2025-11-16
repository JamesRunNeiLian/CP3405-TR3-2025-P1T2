-- ================================================================
-- Reinforcement Learning Tables for SmartSeat System
-- ================================================================
-- These tables store RL recommendation history and user feedback
-- Run these SQL statements in your Supabase SQL Editor
-- ================================================================

-- Table 1: RL Recommendations
-- Stores every recommendation made by the RL model
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

-- Add indexes for faster queries
CREATE INDEX idx_rl_recommendations_user_id ON rl_recommendations(user_id);
CREATE INDEX idx_rl_recommendations_classroom_id ON rl_recommendations(classroom_id);
CREATE INDEX idx_rl_recommendations_timestamp ON rl_recommendations(timestamp);
CREATE INDEX idx_rl_recommendations_zone ON rl_recommendations(zone);

-- Add comments
COMMENT ON TABLE rl_recommendations IS 'Stores all seat zone recommendations made by the RL model';
COMMENT ON COLUMN rl_recommendations.strategy_id IS 'ID of recommendation strategy (0-3)';
COMMENT ON COLUMN rl_recommendations.zone IS 'Zone code: quiet, door, accessible, group';
COMMENT ON COLUMN rl_recommendations.confidence IS 'Model confidence score (0.0 - 1.0)';


-- Table 2: RL Feedbacks
-- Stores user feedback (acceptance/rejection) for model learning
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

-- Add indexes for faster queries
CREATE INDEX idx_rl_feedbacks_user_id ON rl_feedbacks(user_id);
CREATE INDEX idx_rl_feedbacks_strategy_id ON rl_feedbacks(strategy_id);
CREATE INDEX idx_rl_feedbacks_accepted ON rl_feedbacks(accepted);
CREATE INDEX idx_rl_feedbacks_timestamp ON rl_feedbacks(timestamp);

-- Add comments
COMMENT ON TABLE rl_feedbacks IS 'Stores user feedback on RL recommendations for model training';
COMMENT ON COLUMN rl_feedbacks.accepted IS 'Whether user accepted the recommendation';
COMMENT ON COLUMN rl_feedbacks.reward IS 'Reward signal: 1 (accepted) or 0 (rejected)';
COMMENT ON COLUMN rl_feedbacks.updated_confidence IS 'Model confidence after this feedback';


-- ================================================================
-- Optional: Analytics Views
-- ================================================================

-- View: Strategy Performance Summary
CREATE OR REPLACE VIEW rl_strategy_performance AS
SELECT 
    strategy_id,
    strategy_name,
    COUNT(*) as total_recommendations,
    COUNT(CASE WHEN accepted THEN 1 END) as accepted_count,
    COUNT(CASE WHEN NOT accepted THEN 1 END) as rejected_count,
    ROUND(AVG(CASE WHEN accepted THEN 1.0 ELSE 0.0 END), 4) as acceptance_rate,
    MAX(updated_confidence) as latest_confidence
FROM rl_feedbacks
GROUP BY strategy_id, strategy_name
ORDER BY acceptance_rate DESC;

COMMENT ON VIEW rl_strategy_performance IS 'Summary of each strategy performance';


-- View: Daily RL Activity
CREATE OR REPLACE VIEW rl_daily_activity AS
SELECT 
    DATE(timestamp) as date,
    COUNT(DISTINCT r.id) as total_recommendations,
    COUNT(DISTINCT f.id) as total_feedbacks,
    ROUND(AVG(r.confidence), 4) as avg_confidence
FROM rl_recommendations r
LEFT JOIN rl_feedbacks f ON DATE(r.timestamp) = DATE(f.timestamp)
GROUP BY DATE(timestamp)
ORDER BY date DESC;

COMMENT ON VIEW rl_daily_activity IS 'Daily RL system activity summary';


-- View: Zone Popularity
CREATE OR REPLACE VIEW rl_zone_popularity AS
SELECT 
    r.zone,
    COUNT(r.id) as recommendations_count,
    COUNT(f.id) as feedback_count,
    COUNT(CASE WHEN f.accepted THEN 1 END) as accepted_count,
    ROUND(
        COUNT(CASE WHEN f.accepted THEN 1 END)::DECIMAL / 
        NULLIF(COUNT(f.id), 0), 
        4
    ) as acceptance_rate
FROM rl_recommendations r
LEFT JOIN rl_feedbacks f ON r.zone = (
    SELECT zone FROM rl_recommendations 
    WHERE strategy_id = f.strategy_id 
    LIMIT 1
)
GROUP BY r.zone
ORDER BY acceptance_rate DESC;

COMMENT ON VIEW rl_zone_popularity IS 'Popularity and acceptance rate by zone';


-- ================================================================
-- Optional: Enable Row Level Security (RLS)
-- ================================================================

-- Enable RLS on tables (optional - only if you want access control)
-- ALTER TABLE rl_recommendations ENABLE ROW LEVEL SECURITY;
-- ALTER TABLE rl_feedbacks ENABLE ROW LEVEL SECURITY;

-- Example policy: Allow all operations for authenticated users
-- CREATE POLICY "Enable read access for all users" ON rl_recommendations
--     FOR SELECT USING (true);

-- CREATE POLICY "Enable insert for authenticated users" ON rl_recommendations
--     FOR INSERT WITH CHECK (auth.role() = 'authenticated');


-- ================================================================
-- Sample Queries for Testing
-- ================================================================

-- Query 1: Get latest recommendations
-- SELECT * FROM rl_recommendations ORDER BY timestamp DESC LIMIT 10;

-- Query 2: Get strategy performance
-- SELECT * FROM rl_strategy_performance;

-- Query 3: Get acceptance rate by zone
-- SELECT * FROM rl_zone_popularity;

-- Query 4: Count feedback by day
-- SELECT DATE(timestamp) as date, COUNT(*) as feedback_count
-- FROM rl_feedbacks
-- GROUP BY DATE(timestamp)
-- ORDER BY date DESC;

-- Query 5: Get user's recommendation history
-- SELECT * FROM rl_recommendations 
-- WHERE user_id = 'your_user_id' 
-- ORDER BY timestamp DESC;

