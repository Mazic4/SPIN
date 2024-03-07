import pandas as pd
import json
from datasets import load_dataset

import json
import os
import fnmatch

def write_json(data_list, data_path):
    # Writing to a JSON Lines file
    with open(data_path, 'w') as f:
        for entry in data_list:
            json.dump(entry, f)
            f.write('\n')  # Add newline after each JSON object

def convert_single_file(data_path, output_data_path):

    dataset = load_dataset(data_path, split='test')
    print (len(dataset))


    messages = []
    error_cnt = 0
    for message in dataset:
        real_message = message['real']
        generated_message = message['generated']

        prompt, real_rsp, generated_rsp = real_message[0]["content"], real_message[1]["content"], generated_message[1]["content"]

        instruction, user_prompt = prompt.split('<|user|>\n')[0], prompt.split('<|user|>\n')[1]

        maas_test_message = {
            "instruction": instruction.replace('<|system|>\n', ''),
            "rounds":[
                {"prompt":user_prompt.replace('</s>\n<|assistant|>\n', ''),
                "response":real_message[1]["content"],
                "predict_static_context":generated_message[1]["content"]}
            ]
        }

        messages.append(maas_test_message)

    write_json(messages, output_data_path)


def list_jsonl_files(directory):
    jsonl_files = []
    for root, dirs, files in os.walk(directory):
        for file in files:
            if fnmatch.fnmatch(file, '*.jsonl'):
                jsonl_files.append(os.path.join(root, file))
    return jsonl_files

# Example usage
version="v5"
root_dir = '/root/code/opensource/SPIN/mrgt/test_generated/'
generate_dir = '/root/code/opensource/SPIN/mrgt/test_generated/'
jsonl_files = list_jsonl_files(root_dir+"lang/{}/".format(version))
print(jsonl_files)

for data_path in jsonl_files:
    _ = data_path.split('/')
    iter, checkpoint, lang = _[9], _[10], _[11]
    dir_path = '/'.join(_[:-1])
    print (dir_path, iter, checkpoint, lang)
    os.makedirs(root_dir+"maas_format/lang/{}/{}/{}/".format(version, iter, checkpoint), exist_ok=True)
    convert_single_file(dir_path, root_dir+"maas_format/lang/{}/{}/{}/testset.{}.pred.jsonl".format(version, iter, checkpoint, lang))