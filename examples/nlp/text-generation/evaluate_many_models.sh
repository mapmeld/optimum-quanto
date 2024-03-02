#!/bin/bash
# Absolute path to this script, e.g. /home/user/bin/foo.sh
SCRIPT=$(readlink -f "$0")
# Absolute path this script is in, thus /home/user/bin
SCRIPT_PATH=$(dirname "$SCRIPT")

models=(
    facebook/opt-125m
    facebook/opt-350m
    facebook/opt-1.3b
    EleutherAI/pythia-160m
    EleutherAI/pythia-410m
    EleutherAI/pythia-1b
    princeton-nlp/Sheared-LLaMA-1.3B
    01-ai/Yi-6B
    HuggingFaceH4/zephyr-7b-beta
)

weights=(
    int4
    int8
    float8
)

activations=(
    int8
    float8
)

for m in ${models[@]}; do
    python ${SCRIPT_PATH}/quantize_causal_lm_model.py --model $m --weights int8 --activations none --skip_generation
    for w in ${weights[@]}; do
        for a in ${activations[@]}; do
            python ${SCRIPT_PATH}/quantize_causal_lm_model.py --model $m --weights $w --activations $a --skip_float --skip_generation
        done
    done
done
