#!/bin/bash

# 使用方法
# bash End2EndEval.sh <<predict_path>> <<eval_point_path>> <<meta_path>>
# 注:
# (1) 第8行，pcs_op_prediction的local地址加入到PYTHONPATH中, 如果你的项目local地址不同，按需修改
# (2) 需要在环境变量中，配置OpenAI API key. Before running the example, make sure the OPENAI_API_KEY environment variable is set by executing echo $OPENAI_API_KEY. If it is not already set, it can be set by using export OPENAI_API_KEY=YOUR_API_KEY on Unix/Linux/MacOS systems or set OPENAI_API_KEY=YOUR_API_KEY on Windows systems.
# (3) 用到了GPTCache这个库，需要安装requirements.txt中gptcache, redis, redis-om, tiktoken 这几个包

export PYTHONPATH=$PYTHONPATH:/Users/bytedance/Workspace/pcs_op_prediction:/Users/bytedance/projects/pcs_op_prediction

#skip_autoeval='False'
skip_autoeval='False'

param_cnt=$0

# 根据拆分成单轮的test set，完成预测； 一行为一轮
if [ ! -n "$1" ] ;then
  predict_path='/Users/bytedance/Models/mrgt_model/modeldata12_v31/testset.en.pred.jsonl'
else
  predict_path=$1
fi
echo "Predict path: ${predict_path}"

log_path=${predict_path}.eval.log

# 根据拆分成单轮的test set，生成的对应的eval point； 一行为一轮
if [ ! -n "$2" ] ;then
  eval_point_path='/Users/bytedance/Data/pcs_op_data/sft_data/sft_v12_1/testset.en.evalpoint.jsonl'
else
  eval_point_path=$2
fi
echo "`date +%c` Eval point path: ${eval_point_path}" >> ${log_path}

# 对应于test set的metadata； 一行为一轮
if [ ! -n "$3" ] ;then
  meta_path='/Users/bytedance/Data/pcs_op_data/sft_data/sft_v12_1/testset_meta.en.jsonl'
else
  meta_path=$3
fi
echo "`date +%c` Meta path: ${meta_path}" >> ${log_path}

# 根据eval point进行评估； 输入和输出都是一行一轮
autoeval_output_path=${predict_path}.autoeval.jsonl
if [ -e ${autoeval_output_path} ];
then
  echo "`date +%c` ${autoeval_output_path} already exists!" >> ${log_path}
else
  python eval_by_points.py --input_path=${predict_path} --eval_points_path=${eval_point_path} --meta_points_path=${meta_path} --output_path=${autoeval_output_path} --skip_autoeval=${skip_autoeval}
  echo "`date +%c` Auto eval by point, result path: ${autoeval_output_path}" >> ${log_path}
fi

# 计算最终结果，统计结果为会话维度
metric_output_path=${predict_path}.metric.xlsx
python EvaluateDialogGPT.py --input_path=${autoeval_output_path} --data_format_version='v2' --output_metric_path=${metric_output_path}
  echo "`date +%c` Metric result path: ${autoeval_output_path}" >> ${log_path}


