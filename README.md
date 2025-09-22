
# ASISaga: Unified Agent Operating System & Business Infinity

## Overview
ASISaga is a comprehensive AI agent platform that separates generic orchestration (Agent Operating System, AOS) from business-specific implementation (Business Infinity, BI). It enables perpetual, self-evolving executive decision-making through a modular, extensible agent architecture.

---

## Architecture

- **Agent Operating System (AOS):**
	- Provides generic OS-like functionality for agent orchestration, resource management, and workflow execution.
	- Defines the `LeadershipAgent` base class and orchestration primitives.
	- Domain-agnostic and reusable for any agent-based application.

- **Business Infinity (BI):**
	- Implements business-specific logic as an Azure Functions app.
	- Contains a full C-Suite of agents (CEO, CFO, CMO, COO, CTO, CHRO, Founder, Investor), each inheriting from `LeadershipAgent`.
	- Each agent is implemented as a single class per file, with file name matching the class name.

---

## Key Features
- **Separation of Concerns:** Clean split between generic OS and business logic.
- **C-Suite Agents:** Comprehensive, domain-specific agents for executive leadership, each with deep business logic.
- **Extensible:** Add new agents or domains by extending `LeadershipAgent` in BI.
- **Azure Functions Ready:** BI is structured for scalable, cloud-native deployment.

---

## Project Structure

- `BusinessInfinity/` — Business-specific Azure Functions app and C-Suite agents
- `RealmOfAgents/AgentOperatingSystem/` — Generic agent OS, orchestration, and base classes
- `MCP/` — Model Context Protocol and integration modules
- `Buddhi/`, `Manas/` — Knowledge and documentation modules
- `Website/` — Web assets and documentation

---

## Quickstart

1. **Clone the repository**
2. **Create and activate a Python virtual environment**
	 - On Windows:
		 ```powershell
		 python -m venv .venv
		 .venv\Scripts\activate
		 ```
	 - On Unix/macOS:
		 ```bash
		 python3 -m venv .venv
		 source .venv/bin/activate
		 ```
3. **Install dependencies**
	 ```bash
	 pip install -e ./BusinessInfinity
	 pip install -e ./RealmOfAgents/AgentOperatingSystem
	 # (and other modules as needed)
	 ```
4. **Configure environment variables and Azure credentials as needed**
5. **Deploy BI as an Azure Functions app**

---

## Documentation
- See `BusinessInfinity/README.md` for business agent details
- See `RealmOfAgents/AgentOperatingSystem/README.md` for OS architecture
- See `manifest.json` for agent registry and specifications

---

## License
See LICENSE file for details.

!ollama list
!ollama pull deepseek-r1:1.5b
!ollama list
!ollama run deepseek-r1:1.5b

## Install `transformers` library.
pip install torch transformers

## Install HuggingFace datasets for easily accessing and sharing datasets in fine tuned LLM
pip install datasets

pip install openai
pip install azure-storage-blob

# MCP Server for Manas
npm install -g @modelcontextprotocol/server-filesystem