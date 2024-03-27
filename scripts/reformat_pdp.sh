
data_dir="/root/code/opensource/ecom_data/pdp" #train dataset
out_dir="./pdp/train_generated/init"

python spin/reformat.py --data $data_dir --output_dir $out_dir
# python spin/reformat.py --data $data_dir --output_dir $out_dir