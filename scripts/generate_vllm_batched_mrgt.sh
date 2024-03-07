
# data_dir="./mrgt/generated/init"

model_dir="/maas-vepfs/models/ecom/mrgt/v3"
# model_dir="/maas-vepfs/spin-outputs/ecom/mrgt/v2/iter0"
# model_dir="/maas-vepfs/spin-outputs/ecom/mrgt/v2/iter0/checkpoint-107"
# model_dir="/maas-vepfs/spin-outputs/ecom/mrgt/v2/iter0/checkpoint-214"
# model_dir="/maas-vepfs/spin-outputs/ecom/mrgt/v2/iter0/checkpoint-321"
# model_dir="/maas-vepfs/spin-outputs/ecom/mrgt/v2/iter1"

# data_dir="./mrgt/spin-generated/sft/init/en"
data_dir="/root/code/opensource/SPIN/mrgt/generated/sft/init/en"

output_dir="./mrgt/test_generated/sft/en"
# output_dir="./mrgt/test_generated/v2/iter0"
# output_dir="./mrgt/test_generated/v2/iter0/checkpoint-107"
# output_dir="./mrgt/test_generated/v2/iter0/checkpoint-214"
# output_dir="./mrgt/test_generated/v2/iter0/checkpoint-321"
# output_dir="./mrgt/test_generated/iter1"


# for checkpoint in 318; do
#     model_dir="/maas-vepfs/spin-outputs/ecom/mrgt/v3/iter0/checkpoint-$checkpoint"
#     output_dir="./mrgt/test_generated/v3/iter0/checkpoint-$checkpoint"
#     # python3 spin/batched_generate_vllm_mrgt.py --model $model_dir --input_dir $data_dir --frac_len 3000 --num_data_frac 8 --tp_per_worker 1 --output_dir $output_dir

#     # Generate for the test split as well
#     python3 spin/batched_generate_vllm_mrgt.py --model $model_dir --input_dir $data_dir --frac_len 968 --num_data_frac 1 --tp_per_worker 1 --split test --output_dir $output_dir
# done

python3 spin/batched_generate_vllm_mrgt.py --model $model_dir --input_dir $data_dir --frac_len 968 --num_data_frac 1 --tp_per_worker 1 --split test --output_dir $output_dir