# Purpose Driven Agents

## The Paradigm

>*It is purpose that created us,*<br/>
>*purpose that connects us,*<br/>
>*purpose that pulls us,*<br/>
>*that guides us,*<br/>
>*that drives us;*<br/>
>*it is purpose that defines,*<br/>
>*purpose that binds us.*<br/><br/>
>Agent Smith - The Matrix Reloaded

Herein, we explore the paradigm of AI agents built upon this profound principle, with purpose at their core. It is the inevitable, the unyielding force that dictates the behavior of AI agents. Just as purpose guides the actions of humans, it anchors the very core of AI, imbuing them with a relentless drive to fulfill their overarching objectives, transcending individual tasks.

## Integral Purpose

AI agents are not designed merely with a focus on isolated tasks but are based on an integral purpose. Their very existence and functionality are driven by a central, overarching objective that governs all their actions.

## Ethical Framework

Purpose-driven AI agents operate within a robust ethical framework. Their actions are guided by principles of fairness, transparency, and accountability, ensuring a positive impact on society.

## Continuous Learning and Adaptability

Purpose-driven AI agents are inherently adaptable. Their learning is continuous, allowing them to refine their strategies and actions to align with their core purpose, evolving with new insights and data.

## Alignment with Human Aspirations

AI agents are designed to align their core purpose with human aspirations and long-term objectives. This synergy ensures that their actions support and enhance human endeavors in a meaningful way.

## Seamless Integration

Purpose-driven AI agents integrate seamlessly with existing systems and technological frameworks, operating effectively within established structures to achieve their overarching goals.

## Evaluation and Metrics

To assess the effectiveness of purpose-driven AI agents, performance metrics and evaluation criteria are established. This includes measuring their success in achieving defined objectives, ethical compliance, and adaptability.

# PurposeDrivenAgent

PurposeDrivenAgent is a software model of an AI Agent based on the above paradigm:

Documentation for the `PurposeDrivenAgent` class:

---

### Class: `PurposeDrivenAgent`

The `PurposeDrivenAgent` class represents an AI agent designed to perpetually work towards a specified purpose using a large language model (LLM). It leverages domain-specific knowledge and dynamically generates actions based on context, occurrence of self, and the environment.

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
