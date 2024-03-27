# model_dir="/maas-vepfs/spin-outputs/ecom/pdp/sft"
# model_dir="/maas-vepfs/spin-outputs/ecom/pdp/v1/iter1/checkpoint-1226"
# model_dir="/maas-vepfs/spin-outputs/ecom/pdp/v2/iter1"
model_dir="/maas-vepfs/spin-outputs/ecom/pdp/v2/iter1/checkpoint-1226"
data_dir="./pdp/train_generated/v2/init"
# data_dir="./pdp/train_generated/v1/init"
# output_dir="./pdp/inference/v2/sft"
# output_dir="./pdp/inference/v1/iter1/checkpoint-1226"
# output_dir="./pdp/inference/v2/iter1/"
output_dir="./pdp/inference/v2/iter1/checkpoint-1226"


# Generate for the test split as well
python3 spin/batched_generate_vllm_pdp_inference.py --model $model_dir --input_dir $data_dir --frac_len 500 --num_data_frac 1 --tp_per_worker 1 --split test --output_dir $output_dir
