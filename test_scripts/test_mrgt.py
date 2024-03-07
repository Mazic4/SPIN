import pandas as pd
import json
from datasets import load_dataset
import os
import fnmatch

def isEnglish(s):
    try:
        s.encode(encoding='utf-8').decode('ascii')
    except UnicodeDecodeError:
        return False
    else:
        return True


def check_single_path(data_path):
    dataset = load_dataset(data_path, split='test')
    print (len(dataset))

    error_cnt = 0
    non_eng = 0
    for message in dataset:
        real_message = message['real']
        generated_message = message['generated']

        if real_message != generated_message:

            if not isEnglish(str(generated_message)):
                # print (generated_message)
                non_eng += 1

            # print (real_message)
            # print (generated_message)
            # print()

            error_cnt += 1

    return error_cnt, non_eng


# def list_jsonl_files(directory):
#     jsonl_files = []
#     for root, dirs, files in os.walk(directory):
#         print (root)
#         for file in files:
#             if fnmatch.fnmatch(file, '*.jsonl'):
#                 jsonl_files.append(os.path.join(root, file))
#     return jsonl_files

# Example usage

# root_dir = "/root/code/opensource/SPIN/mrgt/test_generated/lang/v3/iter3/checkpoint-315"
root_dir = "/root/code/opensource/SPIN/mrgt/test_generated/sft/"
# check_dir(root_dir)

# root_dir = '/root/code/opensource/SPIN/mrgt/test_generated/'
# generate_dir = '/root/code/opensource/SPIN/mrgt/test_generated/'
# jsonl_files = list_jsonl_files(root_dir)
# jsonl_files.sort()

def check_dir(root_dir):
    json_files = []

    # for lang in ['en', 'ms', 'tl']:
    for lang in ['en']:
        data_path = root_dir + "/{}".format(lang)
        json_files.append(data_path)

    res = {}
    for data_path in json_files:
        # print (data_path)
        error_cnt = check_single_path(data_path)
        res[data_path] = error_cnt

    print (res)


version = "v5"
for iter in [0, 1, 2, 3]:
    for checkpoint in [105, 210, 315, 106, 212, 318, 107, 214, 321, 104, 208, 312]:
    # for checkpoint in [6, 12, 18]:
        root_dir = "/root/code/opensource/SPIN/mrgt/test_generated/lang/{}/iter{}/checkpoint-{}".format(version, iter, checkpoint)
        if os.path.exists(root_dir):
            check_dir(root_dir)

# # root_dir='/root/code/opensource/SPIN/mrgt/test_generated/lang/v2/iter2/checkpoint-105/'
# root_dir='/root/code/opensource/SPIN/mrgt/test_generated/lang/v4/iter3/checkpoint-18/'
# root_dir='/root/code/opensource/SPIN/mrgt/test_generated/lang/v2/iter3/checkpoint-210/'
# # # root_dir = "/root/code/opensource/SPIN/mrgt/test_generated/sft/"

# check_dir(root_dir)


# def check_single_path_train(data_path):
#     dataset = load_dataset(data_path, split='test')
#     print (len(dataset))

#     error_cnt = 0
#     for message in dataset:
#         real_message = message['real']
#         generated_message = message['generated']

#         if real_message[1] != generated_message[1]:

#             print (real_message[1])
#             print (generated_message[1])
#             print()
            
#             error_cnt += 1

#     return error_cnt


# def check_dir_train(root_dir):
#     error_cnt = check_single_path_train(root_dir)
#     print(error_cnt)

# root_dir="/root/code/opensource/SPIN/mrgt/generated/v5/iter3"
# check_dir_train(root_dir)