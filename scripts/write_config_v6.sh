#!/bin/bash

# 接收命令行参数
MODEL_PATH=$1
DATASET_MIXER=$2
CONFIG_FILE_PATH=$3

# 使用cat命令创建配置文件
cat <<EOF > $CONFIG_FILE_PATH
# Model arguments
model_name_or_path: $MODEL_PATH

# Data training arguments
dataset_mixer:
  $DATASET_MIXER
dataset_splits:
- train
- test
preprocessing_num_workers: 12

# Trainer arguments
bf16: true
beta: 0.1
do_eval: true
evaluation_strategy: "steps"
eval_steps: 500
gradient_accumulation_steps: 1
gradient_checkpointing: true
hub_model_id: tulu-7b-spin
learning_rate: 2.0e-7
log_level: info
logging_steps: 10
lr_scheduler_type: linear
max_length: 1024
max_prompt_length: 512
num_train_epochs: 3
optim: rmsprop
output_dir: outputs
per_device_train_batch_size: 8
per_device_eval_batch_size: 4
push_to_hub: false
save_strategy: "epoch"
save_total_limit: null
seed: 42
warmup_ratio: 0.1
EOF

echo "Configuration saved to $CONFIG_FILE_PATH"