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


def check_single_path(data_path):
    dataset = load_dataset(data_path, split='train')
    print (len(dataset))

    error_cnt = 0
    template_error, tool_error = 0, 0
    non_eng = 0
    for message in dataset:
        real_message = message['real'][2]['content'][1:]
        generated_message = message['generated'][2]['content']

        if real_message != generated_message:
            error_cnt += 1
            if error_cnt > 4:
                break

    return error_cnt, non_eng, template_error, tool_error


data_path = "/root/code/opensource/SPIN/pdp/train_generated/v1/iter0"
print (check_single_path(data_path))