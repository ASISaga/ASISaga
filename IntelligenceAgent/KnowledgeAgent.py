# Autonomously complete a coding task:
import asyncio
from autogen_ext.models.openai import OpenAIChatCompletionClient

from autogen_agentchat.agents import AssistantAgent
from autogen_agentchat.ui import Console
from autogen_agentchat.teams import RoundRobinGroupChat

from autogen_ext.teams.magentic_one import MagenticOne

from autogen_ext.code_executors.local import LocalCommandLineCodeExecutor
from autogen_ext.tools.code_execution import PythonCodeExecutionTool
from autogen_ext.agents.web_surfer import MultimodalWebSurfer
from autogen_ext.agents.file_surfer import FileSurfer

client = OpenAIChatCompletionClient(model="gpt-4o")

async def CodeExecuter() -> None:
    tool = PythonCodeExecutionTool(LocalCommandLineCodeExecutor(work_dir="coding"))
    agent = AssistantAgent(
        "assistant", client = client, tools=[tool], reflect_on_tool_use=True
    )
    await Console(
        agent.run_stream(
            task="Create a plot of MSFT stock prices in 2024 and save it to a file. Use yfinance and matplotlib."
        )
    )

async def CoderAgent():
    m1 = MagenticOne(client=client)
    # to enable human-in-the-loop mode, set hil_mode=True
    # m1 = MagenticOne(client=client, hil_mode=True)

    task = "Write a Python script to fetch data from an API."
    result = await Console(m1.run_stream(task=task))
    print(result)

async def FileWebSurferAgent() -> None:
    # Define web surfer agent
    web_surfer_agent = MultimodalWebSurfer(
        name="MultimodalWebSurfer",
        model_client=OpenAIChatCompletionClient(model="gpt-4o-2024-08-06"),
    )

    # Define file surfer agent
    file_surfer_agent = FileSurfer(
        name="FileSurfer",
        model_client=OpenAIChatCompletionClient(model="gpt-4o-2024-08-06"),
    )

    # Define a team
    agent_team = RoundRobinGroupChat([web_surfer_agent, file_surfer_agent], max_turns=3)

    # Run the team and stream messages to the console
    stream = agent_team.run_stream(task="Navigate to the AutoGen readme on GitHub.")
    await Console(stream)
    # Close the browser controlled by the agent
    await web_surfer_agent.close()


if __name__ == "__main__":
    asyncio.run(CoderAgent())