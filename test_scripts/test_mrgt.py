import pandas as pd
import json
from datasets import load_dataset
import os
import fnmatch

from langdetect import detect

def isEnglish(s):
    if detect(s) == "en":
        return True
    else:
        False

def check_template_and_tool(text):

    _ = text[1]["content"].split(":")

    for i in range(len(_)):
        if "[TEMP" in _[i]:
            template_idx = i+1
        if "[TOOL]" in _[i]:
            tool_idx = i+1
    try:
        template = _[template_idx].split('\n')[0]
        tool = _[tool_idx].split('\n')[0]
        return template, tool
    except:
        print(text)
        print("template or tool not found.")
        return [], []


def check_single_path(data_path):
    dataset = load_dataset(data_path, split='test')
    print (len(dataset))

    error_cnt = 0
    template_error, tool_error = 0, 0
    non_eng = 0
    for message in dataset:
        real_message = message['real']
        generated_message = message['generated']

        if real_message[:1024] != generated_message[:1024]:

            if not isEnglish(str(generated_message)):
                print (generated_message)
                non_eng += 1

            real_template, real_tool = check_template_and_tool(real_message)
            gen_template, gen_tool = check_template_and_tool(generated_message)

            if real_template != gen_template:
                # print (real_template, gen_template)
                template_error += 1
            if real_tool != gen_tool:
                # print (real_tool, gen_tool)
                tool_error += 1
            # if real_template == gen_template and real_tool == gen_tool:
            #     print ("*******real message********")
            #     print (real_message)
            #     print ("*******generate message********")
            #     print (generated_message)

            # print (real_message)
            # print (generated_message)
            # print()

            error_cnt += 1

    return error_cnt, non_eng, template_error, tool_error


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


version = "v2_10"

root_path = "/root/code/opensource/SPIN/mrgt/test_generated/lang/sft/"
print (check_single_path(root_path))

for iter in [0, 1, 2, 3]:
    for checkpoint in [39, 78, 117, 36, 72, 108, 35, 70, 105]:
    # for checkpoint in [41, 82, 123, 40, 80, 120, 38, 76, 114]:
    # for checkpoint in [39, 78, 117, 91, 182, 273, 48, 96, 144]:
    # for checkpoint in [217, 434, 651, 252, 504, 756, 239, 478, 717, 228, 456, 684]:
    # for checkpoint in [213, 426, 639, 216, 432, 648, 212, 424, 636]:
    # for checkpoint in [219, 438, 657, 217, 434, 651, 216, 432, 648]:
    # for checkpoint in [216, 432, 648, 217, 434, 651, 213, 426, 639]:
    # for checkpoint in [109, 218, 327, 108, 216, 324, 107, 214, 321]:
    # for checkpoint in [117, 234, 351, 154, 308, 462, 116, 232, 348]:
    # for checkpoint in [603, 1206, 1809, 685, 1370, 2055, 726, 1452, 2178, 727, 1454, 2181]:
    # for checkpoint in [105, 210, 315, 106, 212, 318, 107, 214, 321, 104, 208, 312]:
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
#     template_error, tool_error = 0, 0
#     non_eng = 0
#     for message in dataset:
#         real_message = message['real']
#         generated_message = message['generated']

#         if real_message != generated_message:

#             # if not isEnglish(str(generated_message)):
#             #     # print (generated_message)
#             #     non_eng += 1

#             # if not isEnglish(str(real_message)):
#             #     continue

#             real_template, real_tool = check_template_and_tool(real_message)
#             gen_template, gen_tool = check_template_and_tool(generated_message)

#             if real_template != gen_template:
#                 template_error += 1
#                 print ("template error:", real_template, gen_template)
#             if real_tool != gen_tool:
#                 tool_error += 1
#                 print ("tool error:", real_tool, gen_tool)

#             error_cnt += 1

#     return error_cnt, non_eng, template_error, tool_error


# def check_dir_train(root_dir):
#     error_cnt = check_single_path_train(root_dir)
#     print(error_cnt)

# root_dir="/root/code/opensource/SPIN/mrgt/generated/v6/iter3"
# check_dir_train(root_dir)