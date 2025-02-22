from ...PurposeDrivenAgent import PurposeDrivenAIAgent
from ...PurposeDrivenAgent import LargeLanguageModel

domain_knowledge = """
Physics: Basic concepts of motion, force, and energy.
AI Research: Current trends and methodologies in artificial intelligence.
Education: Effective teaching strategies and methods for knowledge dissemination.
"""

llm = LargeLanguageModel()

class FinanceAgent(PurposeDrivenAIAgent):
    def specific_task(self):
        return "Finance specific task"
