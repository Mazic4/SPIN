import json
import os


def convert_zephyr_to_mass(maas_input_file, zephyr_pred_file, output_file):
	with (open(maas_input_file, 'r', encoding='utf-8') as fin_m, open(zephyr_pred_file, 'r',encoding='utf-8') as fin_z, open(output_file, 'w',encoding='utf-8') as fout):
		for gold_item, pred_item in zip(fin_m, fin_z):
			pred_item = json.loads(pred_item)
			pred = pred_item['out'][0]
			gold_item = json.loads(gold_item)
			gold_item['rounds'][0].update({"predict_static_context": pred})
			fout.write(f'{json.dumps(gold_item, ensure_ascii=False)}\n')


def main():
	# en: get_gold_label
	maas_input_file = '/Users/bytedance/Data/pcs_op_data/sft_data/sft_v18-2/testset.tl.jsonl'
	# get pred
	zephyr_pred_file = '/Users/bytedance/Models/mrgt_model/modeldata18-2_ecomMistral/v3/testset.tl.pred.zephyr.jsonl'
	output_file = '/Users/bytedance/Models/mrgt_model/modeldata18-2_ecomMistral/v3/testset.tl.pred.jsonl'
	convert_zephyr_to_mass(maas_input_file, zephyr_pred_file, output_file)




if __name__ == "__main__":
	main()
