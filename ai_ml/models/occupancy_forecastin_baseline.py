import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from statsmodels.tsa.arima.model import ARIMA
from statsmodels.graphics.tsaplots import plot_acf, plot_pacf

# --- 1. Mock Data Generation ---
# For demonstration, we'll generate a mock time-series dataset representing hourly seat occupancy
# over a 12-week period. The project brief emphasizes prototypes and simulations, making this a great starting point.
print("--- Generating mock data ---")

# Create an hourly time index for 84 days (12 weeks) starting from Sep 22, 2025
# This simulates a typical semester period.
date_rng = pd.date_range(start='2025/09/22', end='2025/12/14', freq='H')

# Create an empty DataFrame
data = pd.DataFrame(date_rng, columns=['time'])
data.set_index('time', inplace=True)

# Generate baseline occupancy data, simulating daily and weekly cycles
# np.sin simulates daily peaks and troughs (e.g., busier mid-day, empty overnight)
# data.index.dayofweek < 5 checks for weekdays (Monday=0 to Sunday=6) for higher occupancy
baseline_occupancy = np.sin(np.linspace(0, 2 * np.pi * 84, len(data))) * 25 + 50
weekday_multiplier = np.where(data.index.dayofweek < 5, 1.2, 0.4) # Multiplier > 1 for weekdays, < 1 for weekends

# Combine baseline, weekday effect, and some random noise
data['occupancy_percentage'] = baseline_occupancy * weekday_multiplier + np.random.randn(len(data)) * 3
# Ensure the occupancy percentage stays within a realistic range (0% to 100%)
data['occupancy_percentage'] = np.clip(data['occupancy_percentage'], 0, 100)

print(f"Successfully generated {len(data)} mock data points.")
print("Data preview:")
print(data.head())
print("\n")


# --- 2. Data Visualization ---
# Plot the generated time-series data to visually inspect its patterns
print("--- Visualizing the raw data... ---")
plt.figure(figsize=(15, 7))
plt.plot(data.index, data['occupancy_percentage'], label='Simulated Occupancy')
plt.title('Simulated Hourly Seat Occupancy (12 Weeks)')
plt.xlabel('Date')
plt.ylabel('Occupancy (%)')
plt.legend()
plt.grid(True)
plt.show()


# --- 3. ARIMA Model Construction and Training ---
# ARIMA is a classic time-series forecasting model, explicitly mentioned in the project brief.
# In ARIMA(p, d, q):
# p: The order of the AutoRegressive (AR) term
# d: The number of differencing required to make the time series stationary (I for Integrated)
# q: The order of the Moving Average (MA) term

# For this baseline model, we'll choose a common set of parameters, e.g., (5, 1, 0)
# p=5: The current value depends on the previous 5 values
# d=1: Use first-order differencing to stabilize the series
# q=0: Do not include a moving average component
print("--- Constructing and training the ARIMA model... ---")
# Note: ARIMA model training can take a moment
model = ARIMA(data['occupancy_percentage'], order=(5, 1, 0))
model_fit = model.fit()

# Print the model summary to understand its details
print("Model training complete.")
print(model_fit.summary())
print("\n")


# --- 4. Forecasting and Result Visualization ---
# Use the trained model to predict future occupancy rates
# We'll forecast for the next 7 days (168 hours)
print("--- Forecasting future occupancy for the next 7 days... ---")
forecast_steps = 24 * 7
forecast = model_fit.get_forecast(steps=forecast_steps)

# Get the mean of the forecast and the confidence intervals
forecast_index = pd.date_range(start=data.index[-1], periods=forecast_steps + 1, freq='H')[1:]
forecast_mean = forecast.predicted_mean
confidence_intervals = forecast.conf_int()

# Ensure the forecast index aligns with the forecast mean length
if len(forecast_index) != len(forecast_mean):
    forecast_index = forecast_index[:len(forecast_mean)]

print("Forecast complete.")

# Plot the original data, in-sample fit, and out-of-sample forecast
print("--- Visualizing the forecast results... ---")
plt.figure(figsize=(15, 7))
# Plot the last 2 weeks of historical data for a clearer view
plt.plot(data.index[-24*14:], data['occupancy_percentage'][-24*14:], label='Historical Occupancy (Last 2 Weeks)')
# Plot the forecasted values
plt.plot(forecast_index, forecast_mean, label='Forecasted Occupancy (Next 7 Days)', color='red')
# Plot the confidence interval
plt.fill_between(forecast_index,
                 confidence_intervals.iloc[:, 0],
                 confidence_intervals.iloc[:, 1], color='pink', alpha=0.5, label='95% Confidence Interval')

plt.title('ARIMA Model Seat Occupancy Forecast')
plt.xlabel('Date')
plt.ylabel('Occupancy (%)')
plt.legend()
plt.grid(True)
plt.show()