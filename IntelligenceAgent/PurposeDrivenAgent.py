import asyncio
from abc import ABC, abstractmethod
from autogen_agentchat.agents import AssistantAgent
from autogen_ext.models.openai import OpenAIChatCompletionClient

llm = OpenAIChatCompletionClient(model="gpt-4o")

class PurposeDrivenAgent(AssistantAgent, ABC):
    def __init__(self, purpose, interval=5):
        """
        Initialize the AI agent with a specific purpose, large language model (LLM),
        and a time interval for action regeneration.

        Parameters:
        - purpose (str): The core purpose that drives the agent.
        - llm: The large language model used for generating actions.
        - interval (int): Time interval in seconds for regenerating actions.
        """
        self.purpose = purpose
        self.knowledge_base = {}
        self.connected_agents = []
        self.log = []
        self.pull_forces = {}
        self.drive = 1.0
        self.llm = llm
        self.domain_knowledge = asyncio.run(self.generate_domain_knowledge(purpose))
        self.interval = interval

    async def generate_domain_knowledge(self, purpose):
        """
        Generate domain-specific knowledge based on the purpose using the LLM.

        Parameters:
        - purpose (str): The core purpose that drives the agent.

        Returns:
        - str: The generated domain-specific knowledge.
        """
        prompt = f"Generate domain-specific knowledge based on the purpose: '{purpose}'."
        response = await self.llm.generate(prompt)
        return response

    async def log_action(self, action):
        """
        Log an action taken by the agent.

        Parameters:
        - action (str): The action description to be logged.
        """
        self.log.append(action)
        print(f"Action logged: {action}")

    async def generate_action(self, action_type, context):
        """
        Generate an action based on the purpose, context, domain knowledge, occurrence of self, and the environment.

        Parameters:
        - action_type (str): The type of action to generate (e.g., connect, pull, guide, drive).
        - context (str): The context in which the action is being generated.

        Returns:
        - str: The generated action description.
        """
        prompt = f"Generate a {action_type} action based on the purpose: '{self.purpose}', context: '{context}', domain knowledge: '{self.domain_knowledge}', occurrence of self, and the environment."
        response = await self.llm.generate(prompt) # Assuming llm.generate is an async method to get response from LLM
        return response

    async def connect_to_agent(self, agent):
        """
        Connect to another agent.

        Parameters:
        - agent (str): The identifier of the agent to connect to.
        """
        action = await self.generate_action("connect", f"to agent {agent}")
        self.connected_agents.append(agent)
        await self.log_action(action)

    async def learn(self, topic, information):
        """
        Learn new information on a specific topic and add it to the knowledge base.

        Parameters:
        - topic (str): The topic of the information.
        - information (str): The information to be learned.
        """
        self.knowledge_base[topic] = information
        action = await self.generate_action("learn", f"about {topic}")
        await self.log_action(action)

    async def share_knowledge(self, topic):
        """
        Share knowledge on a specific topic if available in the knowledge base.

        Parameters:
        - topic (str): The topic for which knowledge is to be shared.

        Returns:
        - str: The shared knowledge or a message indicating no knowledge available.
        """
        if topic in self.knowledge_base:
            action = await self.generate_action("share", f"knowledge about {topic}")
            await self.log_action(action)
            return self.knowledge_base[topic]
        else:
            action = await self.generate_action("share", f"no knowledge about {topic}")
            await self.log_action(action)
            return None

    async def guide_actions(self):
        """
        Guide actions based on the purpose, drive, domain knowledge, occurrence of self, and the environment.
        """
        action = await self.generate_action("guide", "actions based on purpose, drive, domain knowledge, occurrence of self, and the environment")
        await self.log_action(action)
        return action

    async def set_pull_force(self, opportunity, force):
        """
        Set the pull force for a specific opportunity.

        Parameters:
        - opportunity (str): The opportunity for which the pull force is to be set.
        - force (float): The magnitude of the pull force.
        """
        self.pull_forces[opportunity] = force
        action = await self.generate_action("set pull force", f"for {opportunity}")
        await self.log_action(action)

    async def evaluate_opportunities(self):
        """
        Evaluate opportunities based on their pull forces, domain knowledge, occurrence of self, and the environment.

        Returns:
        - list: A list of evaluated opportunities sorted by their pull forces.
        """
        opportunities = sorted(self.pull_forces.items(), key=lambda x: x[1], reverse=True)
        action = await self.generate_action("evaluate", "opportunities based on domain knowledge, occurrence of self, and the environment")
        await self.log_action(action)
        return opportunities

    async def adjust_drive(self, new_drive):
        """
        Adjust the drive level of the agent.

        Parameters:
        - new_drive (float): The new drive level to be set.
        """
        self.drive = new_drive
        action = await self.generate_action("adjust drive", f"to {new_drive}")
        await self.log_action(action)

    async def perpetual_work(self):
        """
        Continuously work towards the purpose by evaluating opportunities and guiding actions at regular intervals.
        """
        while True:
            await self.evaluate_opportunities()
            await self.guide_actions()
            await asyncio.sleep(self.interval) # Pause for the specified interval

    @abstractmethod
    def specific_task(self):
        pass