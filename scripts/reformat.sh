data_dir="/maas-vepfs/data/ecom/mrgt"
# data_dir="/app/data/mrgt_en"
out_dir="./mrgt/generated/v3/init"

# # python spin/reformat.py --data $data_dir --output_dir $out_dir
# python spin/reformat.py --output_dir $out_dir


data_dir="/root/code/opensource/SPIN/data"
out_dir="./mrgt/spin-generated/v2/init"

python spin/reformat_mrgt_test.py --data $data_dir --output_dir $out_dir