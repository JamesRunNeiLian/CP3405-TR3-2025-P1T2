-- ================================================================
-- Occupancy History Table for SmartSeat System
-- ================================================================
-- Stores historical occupancy data for ARIMA forecasting model
-- Run this SQL in your Supabase SQL Editor
-- ================================================================

-- Table: Occupancy History
-- Stores hourly occupancy percentage data
CREATE TABLE IF NOT EXISTS occupancy_history (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    classroom_id TEXT,
    timestamp TIMESTAMPTZ NOT NULL,
    occupancy_percentage DECIMAL(5,2) NOT NULL,
    total_seats INTEGER,
    occupied_seats INTEGER,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Add indexes for faster queries
CREATE INDEX idx_occupancy_timestamp ON occupancy_history(timestamp);
CREATE INDEX idx_occupancy_classroom ON occupancy_history(classroom_id);

-- Add constraints
ALTER TABLE occupancy_history 
    ADD CONSTRAINT check_occupancy_range 
    CHECK (occupancy_percentage >= 0 AND occupancy_percentage <= 100);

-- Add comments
COMMENT ON TABLE occupancy_history IS 'Historical occupancy data for forecasting';
COMMENT ON COLUMN occupancy_history.occupancy_percentage IS 'Percentage of seats occupied (0-100)';
COMMENT ON COLUMN occupancy_history.timestamp IS 'Time of the occupancy reading';

-- Sample query to view recent data
-- SELECT * FROM occupancy_history ORDER BY timestamp DESC LIMIT 100;
