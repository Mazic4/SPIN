# input_dir="/root/code/opensource/SPIN/generated/iter0"
# output_dir="/root/code/opensource/SPIN/generated/iter0_post"

input_dir="/root/code/opensource/SPIN/pdp/train_generated/v1/iter0"
output_dir="/root/code/opensource/SPIN/pdp/train_generated/v1/iter0_post"

python spin/convert_data_pdp.py --num_fracs 8 --input_dir $input_dir --output_dir $output_dir