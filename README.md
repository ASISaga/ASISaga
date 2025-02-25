
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

