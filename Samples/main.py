import asyncio
from PurposeDrivenAIAgent import PurposeDrivenAIAgent, LargeLanguageModel

domain_knowledge = """
Physics: Basic concepts of motion, force, and energy.
AI Research: Current trends and methodologies in artificial intelligence.
Education: Effective teaching strategies and methods for knowledge dissemination.
"""

llm = LargeLanguageModel()
agent1 = PurposeDrivenAIAgent("Facilitate human learning and growth", llm, domain_knowledge, interval=10)

async def main():
    await agent1.learn("Physics", "Basic concepts of motion, force, and energy")
    await agent1.connect_to_agent("Agent 2")
    await agent1.set_pull_force("Teach a class on Physics", 0.9)
    await agent1.set_pull_force("Collaborate on AI research", 0.8)
    await agent1.adjust_drive(1.2)
    await agent1.perpetual_work() # Start the perpetual working loop

asyncio.run(main())
