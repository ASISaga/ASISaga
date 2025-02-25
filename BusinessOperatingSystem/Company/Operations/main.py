import asyncio
from Company import MarketingAgent, FinanceAgent, AccountsAgent, PurchaseAgent, OperationsAgent, HRAgent, QualityAgent

marketing_agent = MarketingAgent("Facilitate human learning and growth", interval=10)

async def main():
    await marketing_agent.learn("Physics", "Basic concepts of motion, force, and energy")
    await marketing_agent.connect_to_agent("Agent 2")
    await marketing_agent.set_pull_force("Teach a class on Physics", 0.9)
    await marketing_agent.set_pull_force("Collaborate on AI research", 0.8)
    await marketing_agent.adjust_drive(1.2)
    await marketing_agent.perpetual_work() # Start the perpetual working loop

asyncio.run(main())
