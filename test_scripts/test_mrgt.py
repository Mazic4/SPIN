import pandas as pd
import json
from datasets import load_dataset



# data_path = "/root/code/opensource/SPIN/mrgt/test_generated/v2/sft/"
# data_path = "/root/code/opensource/SPIN//mrgt/test_generated/v2/iter0/
# data_path = "/root/code/opensource/SPIN//mrgt/test_generated/v2/iter0/checkpoint-107"
# data_path = "/root/code/opensource/SPIN//mrgt/test_generated/v2/iter0/checkpoint-214"
# data_path = "/root/code/opensource/SPIN//mrgt/test_generated/v2/iter0/checkpoint-321"
# data_path = "/root/code/opensource/SPIN//mrgt/test_generated/v2/iter1/checkpoint-105"
# data_path = "/root/code/opensource/SPIN//mrgt/test_generated/v2/iter1/checkpoint-210"
# data_path = "/root/code/opensource/SPIN//mrgt/test_generated/v2/iter1/checkpoint-315"
# data_path = "/root/code/opensource/SPIN//mrgt/test_generated/v2/iter2/checkpoint-105"
# data_path = "/root/code/opensource/SPIN//mrgt/test_generated/v2/iter2/checkpoint-210"
# data_path = "/root/code/opensource/SPIN//mrgt/test_generated/v2/iter2/checkpoint-315"
# data_path = "/root/code/opensource/SPIN//mrgt/test_generated/v2/iter3/checkpoint-105"
# data_path = "/root/code/opensource/SPIN//mrgt/test_generated/v2/iter3/checkpoint-210"
data_path = "/root/code/opensource/SPIN//mrgt/test_generated/v2/iter3/checkpoint-315"

dataset = load_dataset(data_path, split='test')
# dataset = dataset = load_dataset(data_path, split='test')
print (len(dataset))

error_cnt = 0
for message in dataset:
    real_message = message['real']
    generated_message = message['generated']

    if real_message != generated_message:

        prompt, real_rsp, generated_rsp = real_message[0]["content"], real_message[1]["content"], generated_message[1]["content"]
        print ('prompt', prompt)
        print ('real_rsp:', real_rsp)
        print ('generated_rsp:', generated_rsp)

        error_cnt += 1
        if error_cnt > 9:
            break

print (error_cnt)