# 强化学习模型训练完整指南 / RL Model Training Complete Guide

## 📋 概述 / Overview

本指南将帮助你使用Supabase中的模拟数据训练强化学习（RL）座位推荐模型。

This guide helps you train the Reinforcement Learning (RL) seat recommendation model using simulation data from Supabase.

---

## 🚀 快速开始 / Quick Start

### 步骤 1: 安装依赖 / Step 1: Install Dependencies

```bash
cd ai_ml
pip3 install -r requirements.txt
```

### 步骤 2: 在Supabase创建数据表 / Step 2: Create Tables in Supabase

**方法 A: 使用设置脚本查看SQL（推荐）/ Method A: Use setup script to view SQL (Recommended)**

```bash
python3 setup_supabase_tables.py
```

脚本会显示需要执行的SQL命令。

The script will display the SQL commands you need to run.

**方法 B: 手动执行SQL / Method B: Manual SQL Execution**

1. 登录 Supabase Dashboard / Login to Supabase Dashboard:
   ```
   https://app.supabase.com/project/vqjtaaejsjovdiotacqe/sql/new
   ```

2. 复制并粘贴以下SQL / Copy and paste the following SQL:

```sql
-- RL Recommendations Table
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

-- RL Feedbacks Table (for training)
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

-- Add indexes
CREATE INDEX IF NOT EXISTS idx_rl_feedbacks_user_id ON rl_feedbacks(user_id);
CREATE INDEX IF NOT EXISTS idx_rl_feedbacks_strategy_id ON rl_feedbacks(strategy_id);
CREATE INDEX IF NOT EXISTS idx_rl_feedbacks_timestamp ON rl_feedbacks(timestamp);
```

3. 点击 "Run" 执行SQL / Click "Run" to execute the SQL

### 步骤 3: 运行训练脚本 / Step 3: Run Training Script

```bash
python3 models/rl_train_with_supabase.py
```

**脚本功能 / Script Functions:**
- ✅ 自动检查Supabase是否有反馈数据
- ✅ 如无数据，自动生成50条模拟记录
- ✅ 获取前20条记录训练模型
- ✅ 保存训练后的模型状态

**Script automatically:**
- ✅ Checks if feedback data exists in Supabase
- ✅ Generates 50 simulation records if no data
- ✅ Fetches first 20 records to train model
- ✅ Saves trained model state

### 步骤 4: 启动API服务器 / Step 4: Start API Server

```bash
python3 app.py
```

服务器将自动加载训练好的模型。

Server will automatically load the trained model.

### 步骤 5: 测试模型 / Step 5: Test the Model

```bash
python3 tests/test_rl_api_simple.py
```

---

## 📊 训练输出示例 / Training Output Example

```
======================================================================
  RL Training Script - Using Supabase Simulation Data
======================================================================

[1/5] Connecting to Supabase...
✓ Connected to Supabase

[2/5] Checking for existing feedback data...
✗ No feedback data found in Supabase
  Generating simulation data...

[2/5] Generating 50 simulation feedback records...
✓ Successfully inserted 50 simulation records

  Simulation data distribution:
    Strategy 0 (Quiet Zone         ): 12 records, 10 accepted (83.3%)
    Strategy 1 (Near Door          ): 13 records, 5 accepted (38.5%)
    Strategy 2 (Accessible Zone    ): 14 records, 8 accepted (57.1%)
    Strategy 3 (Group Study Zone   ): 11 records, 6 accepted (54.5%)

[3/5] Fetching first 20 feedback records for training...
✓ Retrieved 20 records

  Training data summary:
    Strategy 0 (Quiet Zone         ): 5 records, 4 accepted (80.0%)
    Strategy 1 (Near Door          ): 5 records, 2 accepted (40.0%)
    Strategy 2 (Accessible Zone    ): 5 records, 3 accepted (60.0%)
    Strategy 3 (Group Study Zone   ): 5 records, 2 accepted (40.0%)

[4/5] Training RL model with 20 records...
  Processed 5/20 records...
  Processed 10/20 records...
  Processed 15/20 records...
  Processed 20/20 records...
✓ Training complete!

  Learned Q-values (confidence scores):
    Strategy 0 (Quiet Zone         ): Q=0.8000, Trials=5
    Strategy 1 (Near Door          ): Q=0.4000, Trials=5
    Strategy 2 (Accessible Zone    ): Q=0.6000, Trials=5
    Strategy 3 (Group Study Zone   ): Q=0.4000, Trials=5

  Best strategy: Quiet Zone (Strategy 0)

[5/5] Saving model state...
✓ Model state saved to: /path/to/rl_agent_state.json

======================================================================
  ✓ Training Complete! 🎉
======================================================================
```

---

## 🎯 模型策略说明 / Model Strategies Explanation

系统有4种推荐策略，模型会学习哪种最受用户欢迎：

The system has 4 recommendation strategies, and the model learns which is most popular:

| 策略 ID<br>Strategy ID | 策略名称<br>Strategy Name | 目标接受率<br>Target Acceptance | 适用场景<br>Use Case |
|---|---|---|---|
| 0 | Quiet Zone<br>安静区域 | 85% | 学习专注<br>Focused study |
| 1 | Near Door<br>门口附近 | 40% | 短时停留、迟到者<br>Short stay, latecomers |
| 2 | Accessible Zone<br>无障碍区域 | 60% | 无障碍需求<br>Accessibility needs |
| 3 | Group Study Zone<br>小组学习区 | 50% | 团队协作<br>Group collaboration |

---

## 🔧 高级配置 / Advanced Configuration

### 修改训练数据量 / Modify Training Data Size

编辑 `models/rl_train_with_supabase.py`:

Edit `models/rl_train_with_supabase.py`:

```python
# 生成更多模拟数据 / Generate more simulation data
generate_simulation_data(num_records=100)  # 默认50 / Default 50

# 使用更多训练数据 / Use more training data
training_data = fetch_training_data(limit=50)  # 默认20 / Default 20
```

### 修改探索率 / Modify Exploration Rate

编辑 `config/supabase_config.py`:

Edit `config/supabase_config.py`:

```python
RL_EPSILON = 0.1  # 10% 探索，90% 利用 / 10% exploration, 90% exploitation
```

- 更高的ε：更多随机探索，学习更慢但更全面
- 更低的ε：更多利用已知最佳策略，收敛更快

- Higher ε: More random exploration, slower but more comprehensive learning
- Lower ε: More exploitation of known best strategy, faster convergence

---

## 📁 生成的文件 / Generated Files

训练后会生成以下文件：

After training, these files are generated:

```
ai_ml/
├── rl_agent_state.json          # 模型状态文件 / Model state file
└── models/
    └── rl_train_with_supabase.py  # 训练脚本 / Training script
```

### rl_agent_state.json 结构 / Structure

```json
{
  "q_values": [0.8000, 0.4000, 0.6000, 0.4000],
  "n_pulls": [5, 5, 5, 5],
  "last_updated": "2024-11-14T15:30:00",
  "training_method": "supabase_simulation_data",
  "training_records": 20
}
```

---

## 🔍 验证训练结果 / Verify Training Results

### 方法 1: 通过API / Method 1: Via API

```bash
# 启动服务器 / Start server
python3 app.py

# 在另一个终端 / In another terminal
curl http://localhost:5000/rl/status
```

### 方法 2: 查看Supabase数据 / Method 2: View Supabase Data

登录Supabase，运行查询：

Login to Supabase and run query:

```sql
-- 查看所有反馈数据 / View all feedback data
SELECT * FROM rl_feedbacks ORDER BY timestamp DESC LIMIT 20;

-- 统计各策略表现 / Statistics by strategy
SELECT 
    strategy_id,
    strategy_name,
    COUNT(*) as total,
    SUM(CASE WHEN accepted THEN 1 ELSE 0 END) as accepted,
    ROUND(AVG(CASE WHEN accepted THEN 1.0 ELSE 0.0 END), 2) as acceptance_rate
FROM rl_feedbacks
GROUP BY strategy_id, strategy_name
ORDER BY acceptance_rate DESC;
```

### 方法 3: 查看状态文件 / Method 3: View State File

```bash
cat rl_agent_state.json
```

---

## ❓ 常见问题 / FAQ

### Q1: 为什么只用20条数据训练？
**A:** 这是一个baseline演示。20条数据足以让模型学习基本趋势。实际应用中，模型会在运行时持续学习更新。

**Q: Why only 20 records for training?**  
**A:** This is a baseline demo. 20 records are sufficient for the model to learn basic trends. In production, the model learns continuously at runtime.

---

### Q2: 训练需要多久？
**A:** 通常1-3秒。如果使用更多数据（如100条），可能需要5-10秒。

**Q: How long does training take?**  
**A:** Typically 1-3 seconds. With more data (e.g., 100 records), it may take 5-10 seconds.

---

### Q3: 可以重新训练吗？
**A:** 可以！随时运行 `python3 models/rl_train_with_supabase.py` 重新训练。如果数据已存在，脚本会跳过生成步骤。

**Q: Can I retrain?**  
**A:** Yes! Run `python3 models/rl_train_with_supabase.py` anytime. If data exists, the script skips generation.

---

### Q4: 如何清除数据重新开始？
**A:** 在Supabase SQL编辑器运行：

**Q: How to clear data and start over?**  
**A:** Run in Supabase SQL Editor:

```sql
TRUNCATE TABLE rl_feedbacks CASCADE;
TRUNCATE TABLE rl_recommendations CASCADE;
```

然后重新运行训练脚本。

Then rerun the training script.

---

### Q5: 模型会自动更新吗？
**A:** 是的！当用户提交反馈（通过 `/rl/feedback` API），模型会立即更新Q值。无需重新训练。

**Q: Does the model update automatically?**  
**A:** Yes! When users submit feedback (via `/rl/feedback` API), the model immediately updates Q-values. No retraining needed.

---

## 📚 相关文档 / Related Documentation

- `models/README_RL_TRAINING.md` - 训练详细说明 / Detailed training docs
- `database/supabase_rl_schema.sql` - 完整数据库架构 / Full database schema
- `docs/aiml_api_flow.md` - API文档 / API documentation
- `QUICK_REFERENCE.md` - 快速参考 / Quick reference

---

## 🎓 算法原理 / Algorithm Principles

### Multi-Armed Bandit (MAB)

本系统使用**ε-贪心策略**的多臂老虎机算法：

The system uses **ε-greedy Multi-Armed Bandit**:

```python
# 10%时间：探索（尝试随机策略）
# 10% time: Explore (try random strategy)
if random() < 0.1:
    choose_random_strategy()
    
# 90%时间：利用（选择最佳已知策略）
# 90% time: Exploit (choose best known strategy)
else:
    choose_best_strategy()
```

### Q值更新公式 / Q-value Update Formula

每次收到用户反馈后，更新该策略的Q值：

After each user feedback, update Q-value for that strategy:

```
Q_new = Q_old + (1/N) * (Reward - Q_old)
```

其中 / Where:
- `Q_old` = 当前置信度分数 / Current confidence score
- `N` = 该策略被尝试的总次数 / Total times strategy was tried
- `Reward` = 1（接受）或 0（拒绝） / 1 (accepted) or 0 (rejected)
- `Q_new` = 新的置信度分数 / New confidence score

---

## 🐛 故障排除 / Troubleshooting

### 错误: "Could not find the table"

**原因 / Cause:** 数据表尚未创建

**解决 / Solution:** 运行步骤2创建表 / Run Step 2 to create tables

---

### 错误: "Module not found"

**原因 / Cause:** 依赖未安装

**解决 / Solution:**
```bash
pip3 install -r requirements.txt
```

---

### 错误: "Connection refused"

**原因 / Cause:** Supabase凭据错误或网络问题

**解决 / Solution:** 检查 `config/supabase_config.py` 中的URL和KEY / Check URL and KEY in `config/supabase_config.py`

---

## 📞 支持 / Support

如有问题，请：

For questions:
1. 查看项目README / Check project README
2. 查看相关文档 / Check related documentation
3. 联系开发团队 / Contact development team

---

**祝训练顺利！🎉 / Happy Training! 🎉**
