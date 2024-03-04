# Set which GPU devices to be visible to the process, --num_processes should be adjusted accordingly
export CUDA_VISIBLE_DEVICES="0,1,2,3,4,5,6,7"

# Set the home directory for Hugging Face transformers library cache.
#export HF_HOME="${your_hf_home}"

# Set the logging level for the `accelerate` library to output informational messages.
ACCELERATE_LOG_LEVEL=info

MAIN_BASE_DIR=$(pwd)
MODEL_BASE_DIR=/maas-vepfs/models/mistral-instruct-7b

N_ITERATIONS=1
for iter in 0 1 2 3 4; do

    # #run generation via batch llm
    if [ "$iter" -eq 0 ]; then
        model_dir="${MODEL_BASE_DIR}/models/mistral-instruct-7b"
        data_dir="${MAIN_BASE_DIR}/spin-generated/mistral-7b/init"
        output_dir="${MAIN_BASE_DIR}/spin-generated/mistral-7b/iter$iter"
    else
        model_dir="${MODEL_BASE_DIR}/spin-outputs/mistral-instruct-7b/iter$((iter-1))"
        data_dir="${MAIN_BASE_DIR}/spin-generated/mistral-7b/init"
        output_dir="${MAIN_BASE_DIR}/spin-generated/mistral-7b/iter$iter"
    fi

    mkdir -p ${MODEL_BASE_DIR}/spin-outputs/mistral-instruct-7b
    mkdir -p ${MAIN_BASE_DIR}/spin-generated/mistral-7b/


    python3 spin/batched_generate_vllm.py --model $model_dir --input_dir $data_dir --frac_len 5000 --num_data_frac 10 --tp_per_worker 1 --output_dir $output_dir
    python3 spin/batched_generate_vllm.py --model $model_dir --input_dir $data_dir --frac_len 5000 --num_data_frac 1 --tp_per_worker 1 --split test --output_dir $output_dir

    echo "Iteration $iter: generation done"

    # #convert datatype
    input_dir=$output_dir
    data_output_dir=$output_dir"_post"

    python spin/convert_data.py --num_fracs 10 --input_dir $input_dir --output_dir $data_output_dir

    echo "Iteration $iter: convert data type done"

    # #finetune
    config_path="configs/test_mistral_7b/config_iter$iter.yaml"
    output_dir=${MODEL_BASE_DIR}/spin-outputs/mistral-instruct-7b/iter$iter

    bash scripts/write_config.sh $model_dir $data_output_dir": 1.0" $config_path

    accelerate launch --config_file configs/deepspeed_zero3.yaml --num_processes=8 --main_process_port 2950 \
    spin/run_spin.py $config_path --num_train_epochs=3 --output_dir=$output_dir

    echo "Iteration $iter: finetuning done"


done