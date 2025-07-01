# ASI Saga Main Repo


# Setup

## Create and activate python virtual environment

!python3 -m venv .venv
!source .venv/bin/activate

## To deactivate later:
!deactivate

## On Windows

python -m venv .venv

.venv\Scripts\activate

.venv\Scripts\deactivate

## Install autogen studio
!pip install -U autogenstudio

## Install autogen chat
!pip install -U "autogen-agentchat"

## Install autogen OpenAI for Model Client
!pip install "autogen-ext[openai]"

## Install autogen core
!pip install "autogen-core"

## Run AutoGen Studio GUI
!autogenstudio ui --host <host> --port 8000

## Install Magentic One modules

!pip install "autogen-ext[magentic-one]"

!pip install "autogen-ext[web-surfer]"

!pip install "autogen-ext[file-surfer]"

## Install Ollama for your operating system

https://ollama.com/download

## Pull and install desired model of DeepSeek R1

!ollama list
!ollama pull deepseek-r1:1.5b
!ollama list
!ollama run deepseek-r1:1.5b

## Install `transformers` library.
pip install torch transformers

## Install HuggingFace datasets for easily accessing and sharing datasets in fine tuned LLM
pip install datasets

pip install openai
pip install azure-storage-blob