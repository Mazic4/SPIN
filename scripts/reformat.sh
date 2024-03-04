data_dir="/maas-vepfs/data/ecom/mrgt"
# data_dir="/app/data/mrgt_en"
out_dir="./mrgt/generated/v3/init"

python spin/reformat.py --data $data_dir --output_dir $out_dir