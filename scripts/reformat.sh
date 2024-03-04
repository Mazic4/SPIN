# # data_dir="/maas-vepfs/data/ultrachat-200k"
# out_dir="./spin-generated/mistral-7b/init"

# # python spin/reformat.py --data $data_dir --output_dir $out_dir
# python spin/reformat.py --output_dir $out_dir


data_dir="/root/code/opensource/SPIN/data"
out_dir="./mrgt/spin-generated/v2/init"

python spin/reformat_mrgt_test.py --data $data_dir --output_dir $out_dir