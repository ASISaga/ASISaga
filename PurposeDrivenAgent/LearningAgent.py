# Agent based on the FileBrowser and WebBrowser agents from the MagenticOne project.
# It parses the works of the greatest thinkers in various fields, and builds a domain specific knowledge base.
# The works are provided as plain text files, pdf files, or web links.
# The domain specific knowledge base is then used to guide actions of the Domain specefic PurposeDrivenAgents along with the purpose, occurrence of self, and the environment.
# It uses asynchronous model of autogen.

from autogen_ext.agents.web_surfer import MultimodalWebSurfer
from autogen_ext.agents.file_surfer import FileSurfer
from autogen_ext.models.openai import OpenAIChatCompletionClient
from autogen_agentchat.ui import Console
from autogen_agentchat.teams import RoundRobinGroupChat

model_client = OpenAIChatCompletionClient(model="gpt-4o-2024-08-06")

class LearningAgent:
    def __init__(self, knowledge_base, files, web_links):
        self.knowledge_base = knowledge_base
        self.files = files
        self.web_links = web_links

    async def KnowledgeBuilderAgent(self) -> None:
        # Define web surfer agent
        web_surfer_agent = MultimodalWebSurfer(name="MultimodalWebSurfer", model_client = model_client,)

        # Define file surfer agent
        file_surfer_agent = FileSurfer(name="FileSurfer", model_client = model_client,)

        # Define a team
        agent_team = RoundRobinGroupChat([web_surfer_agent, file_surfer_agent], max_turns=3)

        # Process web links
        for link in self.web_links:
            stream = agent_team.run_stream(task=f"Navigate to {link} and extract knowledge.")
            await Console(stream)

        # Process files
        for file in self.files:
            stream = agent_team.run_stream(task=f"Read the file {file} and extract knowledge.")
            await Console(stream)

        # Close the browser controlled by the agent
        await web_surfer_agent.close()

