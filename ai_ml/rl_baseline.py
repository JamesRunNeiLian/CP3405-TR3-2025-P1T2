# rl_recommendation_baseline.py
# A baseline Reinforcement Learning model (Multi-Armed Bandit)
# This model is ADAPTED as a RECOMMENDATION ENGINE, not an allocation system.
# Objective: "Optimize real-time seat RECOMMENDATION policies"

import numpy as np
import random

class SeatRecommendationBandit:
    """
    Implements a Multi-Armed Bandit (MAB) simulation using Epsilon-Greedy.
    Each "arm" now represents a different RECOMMENDATION strategy,
    not a forced allocation.
    """
    
    def __init__(self, k_arms, epsilon=0.1):
        """
        Initialize the bandit.
        :param k_arms: The number of recommendation strategies (arms).
        :param epsilon: The probability of exploring (choosing a random arm).
        """
        self.k_arms = k_arms
        self.epsilon = epsilon
        
        # q_values: The estimated average reward (Click-Through Rate) for each arm
        self.q_values = np.zeros(k_arms)
        # n_pulls: The number of times each recommendation strategy has been tried
        self.n_pulls = np.zeros(k_arms)
        
        print(f"Initialized MAB Recommendation Engine with {k_arms} arms and epsilon={epsilon}")

    def choose_recommendation_strategy(self):
        """
        Choose a recommendation strategy (arm) using the Epsilon-Greedy policy.
        """
        if random.random() < self.epsilon:
            # --- EXPLORE ---
            # Try a random recommendation strategy
            return np.random.randint(self.k_arms)
        else:
            # --- EXPLOIT ---
            # Use the strategy with the highest known Click-Through Rate (CTR)
            return np.argmax(self.q_values)

    def update_policy(self, arm_index, reward):
        """
        Update the Q-value (CTR) for the chosen arm based on the reward.
        :param arm_index: The index of the strategy that was tried.
        :param reward: 1 if the user clicked the recommendation, 0 otherwise.
        """
        # Increment the pull count for this arm
        self.n_pulls[arm_index] += 1
        
        # Update the average reward (Q-value) using incremental mean
        # Q_new = Q_old + (1/N) * (Reward - Q_old)
        n = self.n_pulls[arm_index]
        old_q = self.q_values[arm_index]
        new_q = old_q + (1/n) * (reward - old_q)
        
        self.q_values[arm_index] = new_q

# --- Simulation ---

def run_simulation():
    """
    Runs a simulation to test the MAB Recommendation Engine.
    """
    print("\n--- Starting RL Recommendation Simulation ---")
    
    # Define our "arms" (Recommendation Strategies) and their "true" click-through rates.
    # The agent does NOT know these probabilities; it must learn them.
    
    strategy_names = [
        "Strategy 1: Recommend 'Quiet Zone'",      # Most users probably want this
        "Strategy 2: Recommend 'Near Door'",      # Good for 'Alex' (latecomer)
        "Strategy 3: Recommend 'Accessible Zone'",  # Good for 'Priya' (accessibility)
        "Strategy 4: Recommend 'Group Study Zone'"  # Good for groups
    ]
    # These are the "true" probabilities that a user will click our recommendation
    true_click_through_rates = np.array([0.85, 0.40, 0.60, 0.50])
    k = len(strategy_names)

    print(f"The 'ground truth' Click-Through Rates (unknown to the agent) are: {true_click_through_rates}")
    
    # Initialize our agent
    agent = SeatRecommendationBandit(k_arms=k, epsilon=0.1)
    
    # Define the simulation parameters (e.g., 1000 users visit the page)
    n_simulations = 1000
    
    # Run the simulation
    for i in range(n_simulations):
        # 1. Agent chooses a recommendation strategy (e.g., "Recommend Quiet Zone")
        chosen_arm = agent.choose_recommendation_strategy()
        
        # 2. Environment (User) gives a reward
        # Simulate if the user "clicked" the recommendation based on its true CTR
        if random.random() < true_click_through_rates[chosen_arm]:
            reward = 1  # Success: User clicked the recommendation!
        else:
            reward = 0  # Failure: User ignored it and chose their own seat.
            
        # 3. Agent updates its policy
        agent.update_policy(chosen_arm, reward)

    # --- Results ---
    print("\n--- Simulation Complete ---")
    print(f"Ran {n_simulations} simulations (e.g., 1000 user page visits).")
    
    print("\nFinal Learned Q-Values (Agent's belief of Click-Through Rate):")
    for i in range(k):
        print(f"  {strategy_names[i]:<32}: {agent.q_values[i]:.4f} (Tried {agent.n_pulls[i]} times)")

    print("\nComparison to Ground Truth:")
    print(f"  True Probabilities: {true_click_through_rates}")
    print(f"  Learned Values:     {np.round(agent.q_values, 2)}")
    
    best_strategy_index = np.argmax(agent.q_values)
    print(f"\nConclusion: The agent learned that '{strategy_names[best_strategy_index]}' is the optimal recommendation policy.")

# Main entry point to run the script
if __name__ == "__main__":
    run_simulation()