from ...PurposeDrivenAgent import PurposeDrivenAgent

domain_knowledge = """
Physics: Basic concepts of motion, force, and energy.
AI Research: Current trends and methodologies in artificial intelligence.
Education: Effective teaching strategies and methods for knowledge dissemination.
"""

class QualityAgent(PurposeDrivenAgent):
    def specific_task(self):
        return "Quality specific task"
