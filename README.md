# RealmOfAgents

# The Purpose of an Agent

It is purpose that created us,
purpose that connects us,
purpose that pulls us,
that guides us,
that drives us;
it is purpose that defines,
purpose that binds us.

Agent Smith - The Matrix Reloaded


Software model of an AI Agent based on the above definition of purpose:

Documentation for the `PurposeDrivenAIAgent` class:

---

### Class: `PurposeDrivenAIAgent`

The `PurposeDrivenAIAgent` class represents an AI agent designed to perpetually work towards a specified purpose using a large language model (LLM). It leverages domain-specific knowledge and dynamically generates actions based on context, occurrence of self, and the environment.

#### Attributes:

- `purpose` (str): The core purpose that drives the agent.
- `knowledge_base` (dict): A dictionary storing learned information on various topics.
- `connected_agents` (list): A list of agents the AI agent has connected with.
- `log` (list): A list of logged actions taken by the agent.
- `pull_forces` (dict): A dictionary storing pull forces for various opportunities.
- `drive` (float): The drive level of the agent, which influences its actions.
- `llm`: The large language model used for generating actions.
- `domain_knowledge` (str): Persistent domain-specific knowledge as text.
- `interval` (int): Time interval in seconds for regenerating actions.

#### Methods:

- `__init__(self, purpose, llm, domain_knowledge, interval=5)`: 
  Initializes the AI agent with a specific purpose, large language model, domain-specific knowledge, and a time interval for action regeneration.

  Parameters:
  - `purpose` (str): The core purpose that drives the agent.
  - `llm`: The large language model used for generating actions.
  - `domain_knowledge` (str): Text-based domain-specific knowledge.
  - `interval` (int): Time interval in seconds for regenerating actions.

- `log_action(self, action)`:
  Logs an action taken by the agent.

  Parameters:
  - `action` (str): The action description to be logged.

- `generate_action(self, action_type, context)`:
  Generates an action based on the purpose, context, domain knowledge, occurrence of self, and the environment.

  Parameters:
  - `action_type` (str): The type of action to generate (e.g., connect, pull, guide, drive).
  - `context` (str): The context in which the action is being generated.

  Returns:
  - `str`: The generated action description.

- `connect_to_agent(self, agent)`:
  Connects to another agent and logs the action.

  Parameters:
  - `agent` (str): The identifier of the agent to connect to.

- `learn(self, topic, information)`:
  Learns new information on a specific topic and adds it to the knowledge base.

  Parameters:
  - `topic` (str): The topic of the information.
  - `information` (str): The information to be learned.

- `share_knowledge(self, topic)`:
  Shares knowledge on a specific topic if available in the knowledge base.

  Parameters:
  - `topic` (str): The topic for which knowledge is to be shared.

  Returns:
  - `str`: The shared knowledge or a message indicating no knowledge available.

- `guide_actions(self)`:
  Guides actions based on the purpose, drive, domain knowledge, occurrence of self, and the environment.

- `set_pull_force(self, opportunity, force)`:
  Sets the pull force for a specific opportunity.

  Parameters:
  - `opportunity` (str): The opportunity for which the pull force is to be set.
  - `force` (float): The magnitude of the pull force.

- `evaluate_opportunities(self)`:
  Evaluates opportunities based on their pull forces, domain knowledge, occurrence of self, and the environment.

  Returns:
  - `list`: A list of evaluated opportunities sorted by their pull forces.

- `adjust_drive(self, new_drive)`:
  Adjusts the drive level of the agent.

  Parameters:
  - `new_drive` (float): The new drive level to be set.

- `perpetual_work(self)`:
  Continuously works towards the purpose by evaluating opportunities and guiding actions at regular intervals.

---
# Create and activate python virtual environment

!python3 -m venv .venv
!source .venv/bin/activate

## To deactivate later:
!deactivate

## On Windows

python -m venv .venv

.venv\Scripts\activate

.venv\Scripts\deactivate

# Install autogen studio
! pip install -U autogenstudio

# Install autogen chat
! pip install -U "autogen-agentchat"

# Install autogen OpenAI for Model Client
!pip install "autogen-ext[openai]"

# install autogen core
!pip install "autogen-core"

# run AutoGen Studio GUI
!autogenstudio ui --host <host> --port 8000
 