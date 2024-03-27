# model_dir="/maas-vepfs/spin-outputs/ecom/mrgt/v5/iter3/checkpoint-104" #spin-v1.0
#model_dir="/maas-vepfs/spin-outputs/ecom/mrgt/v6/iter1/checkpoint-106" #spin-v2.0
# model_dir="/maas-vepfs/spin-outputs/ecom/mrgt/v2_4/iter0/checkpoint-657/" #spin-v2_4
model_dir="/maas-vepfs/spin-outputs/ecom/mrgt/v2_10/iter0/checkpoint-78/" #spin-v2_10
data_dir="/root/code/opensource/SPIN/test_scripts/data_en"
# data_dir="/root/code/opensource/SPIN/test_scripts/hard_cases/hard_cases_en"
# output_dir="./mrgt/inference/v5/hard/only_pred"
# output_dir="./mrgt/inference/v2_4/hard/iter0/checkpoint-657/ms"
output_dir="./mrgt/inference/v2_10/iter0/checkpoint-78/en"


python3 spin/batched_generate_vllm_mrgt_inference_full.py --model $model_dir --input_dir $data_dir --frac_len 968 --num_data_frac 1 --tp_per_worker 1 --output_dir $output_dir