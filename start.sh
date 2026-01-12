#!/usr/bin/env bash
set -e

# Activate venv
source /workspace/venv/bin/activate

# Start Jupyter (classic Notebook)
jupyter notebook \
  --ip=0.0.0.0 \
  --port=8888 \
  --no-browser \
  --NotebookApp.token='' \
  --NotebookApp.password=''
