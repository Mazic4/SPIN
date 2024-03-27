model_dir="/maas-vepfs/spin-outputs/ecom/pdp/sft"
data_dir="./pdp/train_generated/init"
output_dir="./pdp/debug_generated/iter0"


python3 spin/batched_generate_vllm_pdp.py --model $model_dir --input_dir $data_dir --frac_len 500 --num_data_frac 8 --tp_per_worker 1 --output_dir $output_dir

# Generate for the test split as well
python3 spin/batched_generate_vllm_pdp.py --model $model_dir --input_dir $data_dir --frac_len 500 --num_data_frac 1 --tp_per_worker 1 --split test --output_dir $output_dir
