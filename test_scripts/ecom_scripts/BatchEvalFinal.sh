#!/bin/bash
export PYTHONPATH=$PYTHONPATH:/root/code/opensource/SPIN/test_scripts/ecom_scripts/mrgt_eval
export PYTHONPATH=$PYTHONPATH:/root/miniconda3/envs/mrgt_test/lib/python3.12/site-packages/basis/



# for lg in en ms tl; do
for lg in en; do
#  bash End2EndEval.sh /Users/bytedance/Models/mrgt_model/modeldata18-2_ecomMistral/v3/testset.${lg}.pred.jsonl /Users/bytedance/Data/pcs_op_data/sft_data/sft_v18-2/testset.${lg}.evalpoint.jsonl /Users/bytedance/Data/pcs_op_data/sft_data/sft_v18-2/testset_meta.${lg}.jsonl
  # bash End2EndEval.sh /Users/bytedance/Models/mrgt_model/modeldata18-3_v89/testset.${lg}.pred.jsonl /Users/bytedance/Data/pcs_op_data/sft_data/sft_v18-2/testset.${lg}.evalpoint.jsonl /Users/bytedance/Data/pcs_op_data/sft_data/sft_v18-2/testset_meta.${lg}.jsonl
  bash End2EndEval.sh /root/code/opensource/SPIN/mrgt/test_generated/maas_format/lang/v5/iter3/checkpoint-104/testset.${lg}.pred.jsonl /Users/bytedance/Data/pcs_op_data/sft_data/sft_v18-2/testset.${lg}.evalpoint.jsonl /Users/bytedance/Data/pcs_op_data/sft_data/sft_v18-2/testset_meta.${lg}.jsonl
done

