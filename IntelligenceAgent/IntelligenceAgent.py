import asyncio
from LearningAgent import LearningAgent

knowledge_base = """
Physics: Basic concepts of motion, force, and energy.
AI Research: Current trends and methodologies in artificial intelligence.
Education: Effective teaching strategies and methods for knowledge dissemination.
"""

files = ["path/to/file1.txt", "path/to/file2.pdf"]
web_links = ["https://example.com/article1", "https://example.com/article2"]

learning_agent = LearningAgent(knowledge_base, files, web_links)

if __name__ == "__main__":
    asyncio.run(learning_agent.KnowledgeBuilderAgent())