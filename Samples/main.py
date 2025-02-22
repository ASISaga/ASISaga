import asyncio
from Agents import MarketingAgent, FinanceAgent, AccountsAgent, PurchaseAgent, OperationsAgent, HRAgent, QualityAgent

agent1 = MarketingAgent("Facilitate human learning and growth", interval=10)

async def main():
    await agent1.learn("Physics", "Basic concepts of motion, force, and energy")
    await agent1.connect_to_agent("Agent 2")
    await agent1.set_pull_force("Teach a class on Physics", 0.9)
    await agent1.set_pull_force("Collaborate on AI research", 0.8)
    await agent1.adjust_drive(1.2)
    await agent1.perpetual_work() # Start the perpetual working loop

asyncio.run(main())
