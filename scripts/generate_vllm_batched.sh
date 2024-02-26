model_dir="/maas-vepfs/models/tulu-7b/"
data_dir="./generated/init"
output_dir="./generated/iter0"


python3 spin/batched_generate_vllm.py --model $model_dir --input_dir $data_dir --frac_len 5000 --num_data_frac 11 --tp_per_worker 1 --output_dir $output_dir

# Generate for the test split as well
python3 spin/batched_generate_vllm.py --model $model_dir --input_dir $data_dir --frac_len 5000 --num_data_frac 1 --tp_per_worker 1 --split test --output_dir $output_dir
