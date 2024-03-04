from datasets import load_dataset
import argparse
import json
from pathlib import Path
import pyarrow.parquet as pq
import logging
import os
import random


def setup_arg_parser():
    parser = argparse.ArgumentParser()
    parser.add_argument('--output_dir', type=str, default='reformatted')
    parser.add_argument('--data', type=str, default='HuggingFaceH4/ultrachat_200k')
    return parser.parse_args()

def split_to_spin_message(text):

    prompt = text['question']
    answer = text['answer']

    system_user_prompt = prompt.split('<|user|>\n')
    if len(system_user_prompt) > 2:
        raise ValueError("More than 1 system-user prompt pair found")

    system_prompt = system_user_prompt[0]
    user_prompt = system_user_prompt[1]

    spin_message = {
        'generated': [system_prompt, user_prompt,""], 
        'real': [system_prompt, user_prompt, answer]
    }

    return spin_message

def load_and_process_data_mrgt(datset_name, split=None, test_size=0.05):

    from transformers import AutoTokenizer, AutoModel

    model_path="/maas-vepfs/models/ecom/mrgt/v3"

    tokenizer = AutoTokenizer.from_pretrained(
            model_path,
            revision="main",
        )
    
    dataset = load_dataset(datset_name, split='train')
    dataset_dict = dataset.train_test_split(test_size=test_size)
    train_dataset, test_dataset = dataset_dict["train"], dataset_dict["test"]
    
    try:
        train_reformatted_data = [split_to_spin_message(message) for message in train_dataset]
        test_reformatted_data = [split_to_spin_message(message) for message in test_dataset]

        return train_reformatted_data, test_reformatted_data
    except Exception as e:
        logging.error(f"Error loading or processing dataset: {e}")
        return [], []


    return train_reformatted_data, test_reformatted_data


def load_and_process_data_tuluv2(dataset_name, split=None):
    #todo: check split is always train or not.
    try:
        dataset = load_dataset(dataset_name, split="train")
        dataset_dict = dataset.train_test_split(test_size=0.2)
        train_dataset, test_dataset = dataset_dict["train"], dataset_dict["test"]
        train_reformatted_data = [{
            'generated': [message['messages'][0], {"role": "assistant", "content": ""}], 
            'real': [message['messages'][0], message['messages'][1]]
        } for message in train_dataset]
        test_reformatted_data = [{
            'generated': [message['messages'][0], {"role": "assistant", "content": ""}], 
            'real': [message['messages'][0], message['messages'][1]]
        } for message in test_dataset]
        return train_reformatted_data, test_reformatted_data
    except Exception as e:
        logging.error(f"Error loading or processing dataset: {e}")
        return [], []

def load_and_process_data_ultrachat(dataset_name, split):
    try:
        dataset = load_dataset(dataset_name, split=split)
        reformatted_data = [{
            'generated': [message['messages'][0], {"role": "assistant", "content": ""}], 
            'real': [message['messages'][0], message['messages'][1]]
        } for message in dataset]
        return reformatted_data
    except Exception as e:
        logging.error(f"Error loading or processing dataset: {e}")
        return []

def save_to_json(data, path):
    try:
        with open(path, 'w') as f:
            json.dump(data, f, indent=4)
    except IOError as e:
        logging.error(f"Error saving data to {path}: {e}")

def save_to_parquet(dataset, path):
    try:
        pq.write_table(dataset.data.table, path)
    except Exception as e:
        logging.error(f"Error saving data to {path}: {e}")

def main():
    args = setup_arg_parser()
    output_dir = Path(args.output_dir)
    output_dir.mkdir(parents=True, exist_ok=True)

    # train_data, test_data = load_and_process_data_tuluv2(args.data)
    train_data, test_data = load_and_process_data_mrgt(args.data)

    train_json_path = output_dir / 'train.json'
    test_json_path = output_dir / 'test.json'

    save_to_json(train_data, train_json_path)
    save_to_json(test_data, test_json_path)

    dataset = load_dataset('json', data_files=str(train_json_path), split='train')
    dataset_test = load_dataset('json', data_files=str(test_json_path), split='train')

    save_to_parquet(dataset, output_dir / 'train_prefs-00000-of-00001.parquet')
    save_to_parquet(dataset_test, output_dir / 'test_prefs-00000-of-00001.parquet')

    os.remove(train_json_path)
    os.remove(test_json_path)

if __name__ == "__main__":
    main()