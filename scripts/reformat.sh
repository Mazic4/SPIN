# data_dir="/maas-vepfs/data/ecom/mrgt" #train dataset
data_dir="/maas-vepfs/data/ecom/mrgt/mrgt_mixchat" #mrgt+open_source_chat


# data_dir="/root/code/opensource/SPIN/test_scripts/data_ms"
# out_dir="./mrgt/generated/sft/init/ms"

# # python spin/reformat.py --data $data_dir --output_dir $out_dir
# python spin/reformat.py --output_dir $out_dir


# data_dir="/root/code/opensource/SPIN/data"
# out_dir="./mrgt/spin-generated/v4/init"
out_dir="./mrgt/train_generated/v2_5/init"
# out_dir="./mrgt/test_generated/v/init"

# python spin/reformat_mrgt_test.py --data $data_dir --output_dir $out_dir
python spin/reformat_multiround.py --data $data_dir --output_dir $out_dir