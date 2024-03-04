
# data_dir="./mrgt/generated/init"

# model_dir="/maas-vepfs/models/ecom/mrgt/v3"
# model_dir="/maas-vepfs/spin-outputs/ecom/mrgt/iter0"
# model_dir="/maas-vepfs/spin-outputs/ecom/mrgt/iter0/checkpoint-788"
model_dir="/maas-vepfs/spin-outputs/ecom/mrgt/iter0/checkpoint-1576"
# model_dir="/maas-vepfs/spin-outputs/ecom/mrgt/iter1"

data_dir="./mrgt/test_generated/init"

# output_dir="./mrgt/test_generated/sft"
output_dir="./mrgt/test_generated/iter0"
# output_dir="./mrgt/test_generated/iter0/checkpoint-788"
output_dir="./mrgt/test_generated/iter0/checkpoint-1576"
# output_dir="./mrgt/test_generated/iter1"


# python3 spin/batched_generate_vllm_mrgt.py --model $model_dir --input_dir $data_dir --frac_len 3000 --num_data_frac 8 --tp_per_worker 1 --output_dir $output_dir

# Generate for the test split as well
python3 spin/batched_generate_vllm_mrgt.py --model $model_dir --input_dir $data_dir --frac_len 10553 --num_data_frac 1 --tp_per_worker 1 --split test --output_dir $output_dir
