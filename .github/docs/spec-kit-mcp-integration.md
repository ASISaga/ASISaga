# Spec-Kit MCP Integration Guide

This guide documents how to use the **spec-kit-mcp** Model Context Protocol server in combination with the ASISaga specification agent, prompts, and workflow instructions to achieve best-in-class specification-driven development.

## Overview

The integration combines four powerful components:

1. **spec-kit-mcp Server**: 25+ MCP tools for automated specification management
2. **Specification Agent** (`.github/agents/specification.agent.md`): AI agent instructions for spec workflows
3. **Prompts** (`.github/prompts/*.prompt.md`): Templated workflows for specific scenarios
4. **Workflow Instructions** (`.github/instructions/spec-driven-workflow.instructions.md`): 6-phase development process

Together, these create a unified system where specifications drive development, code serves specifications, and AI automates mechanical translation between intent and implementation.

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                     GitHub Copilot                          │
│                  (orchestrates workflow)                     │
└────────────────────────┬────────────────────────────────────┘
                         │
        ┌────────────────┼────────────────┐
        │                │                │
┌───────▼────────┐  ┌───▼────────┐  ┌───▼─────────┐
│ Specification  │  │  Prompts   │  │  Workflow   │
│  Agent.md      │  │  *.prompt  │  │ Instructions│
│                │  │     .md    │  │     .md     │
│ • Capabilities │  │ • Green-   │  │ • 6-Phase   │
│ • Tool Mapping │  │   field    │  │   Process   │
│ • Workflows    │  │ • Brown-   │  │ • Templates │
└───────┬────────┘  │   field    │  │ • Validation│
        │           │ • Progress │  └─────────────┘
        │           │   -ive      │
        │           └────┬───────┘
        │                │
        └────────────────┼────────────────┐
                         │                │
                 ┌───────▼────────────────▼──────┐
                 │   spec-kit-mcp Server         │
                 │   (25+ MCP Tools)              │
                 │                                 │
                 │ • Project Init & Scaffolding   │
                 │ • Codebase Analysis            │
                 │ • Documentation Parsing        │
                 │ • Requirement Extraction       │
                 │ • Spec Generation              │
                 │ • Migration Planning           │
                 │ • Progressive Onboarding       │
                 │ • Conflict Detection           │
                 │ • Consistency Validation       │
                 └─────────────────────────────────┘
```

## Setup

### 1. Install spec-kit-mcp Server

```powershell
# Install from repository
pip install git+https://github.com/ASISaga/spec-kit-mcp.git

# Or install from local clone
cd C:\Development\ASISaga\MCP\spec-kit-mcp
pip install -e .
```

### 2. Configure MCP Server for Copilot

Add to your MCP configuration (location varies by Copilot client):

**For Claude Desktop:**
```json
{
  "mcpServers": {
    "spec-kit": {
      "command": "spec-kit-mcp",
      "args": []
    }
  }
}
```

**For VS Code with MCP Extension:**
```json
{
  "mcp.servers": [
    {
      "name": "spec-kit",
      "command": "spec-kit-mcp"
    }
  ]
}
```

### 3. Verify Installation

In Copilot chat, type:
```
@workspace /mcp list
```

You should see `spec-kit` listed with 25+ available tools.

## Usage Scenarios

### Scenario 1: Create New Feature in Existing Spec-Kit Project

**User Goal**: Add a new feature to a project already using spec-driven development.

**Workflow**:
1. User: "Create a new feature for user authentication"
2. Agent invokes `create_new_feature` MCP tool
3. Agent invokes `setup_plan` to generate implementation plan
4. Agent follows 6-phase workflow from `spec-driven-workflow.instructions.md`

**MCP Tools Used**:
- `create_new_feature`
- `setup_plan`
- `check_task_prerequisites`
- `update_agent_context`
- `get_feature_paths`

**Example Prompt**:
```
@specification Create a new feature for JWT-based authentication with refresh tokens
```

**Agent Behavior**:
1. Calls `create_new_feature` with feature description
2. Creates feature branch (e.g., `003-jwt-authentication`)
3. Scaffolds `specs/003-jwt-authentication/` directory
4. Generates `spec.md` from template
5. Calls `setup_plan` to create implementation plan
6. Guides user through ANALYZE → DESIGN → IMPLEMENT phases

### Scenario 2: Onboard Existing Project (Full)

**User Goal**: Migrate a legacy codebase to spec-driven development.

**Workflow**:
1. User: "Onboard the existing project at ./legacy-app to spec-driven development"
2. Agent uses `onboard-existing-project.prompt.md`
3. Agent calls sequence of analysis tools
4. Agent generates comprehensive specification and migration plan

**MCP Tools Used**:
- `analyze_existing_project`
- `parse_existing_documentation`
- `extract_requirements_from_code`
- `generate_standardized_spec`
- `create_migration_plan`
- Or single tool: `onboard_existing_project` (combines all above)

**Example Prompt**:
```
@specification Use prompt onboard-existing-project for ./BusinessInfinity
```

**Agent Behavior**:
1. Scans directory structure (max_depth=3)
2. Parses README.md, docs/, *.md files
3. Extracts requirements from Python docstrings and comments
4. Generates `spec/spec-businessinfinity.md`
5. Creates `spec/migration-plan.md` with phased adoption
6. Outputs summary with `[NEEDS CLARIFICATION]` markers

### Scenario 3: Progressive Onboarding (Large Legacy Codebase)

**User Goal**: Incrementally adopt spec-driven development feature-by-feature.

**Workflow**:
1. User: "Progressively onboard ./monolith starting with the API layer"
2. Agent uses `progressive-onboarding.prompt.md`
3. Agent identifies feature boundaries
4. Agent onboards selected features incrementally

**MCP Tools Used**:
- `extract_feature_boundaries`
- `analyze_feature_component`
- `onboard_project_feature`
- `merge_feature_specifications`
- `detect_specification_conflicts`
- `resolve_feature_dependencies`
- `create_progressive_migration_plan`
- `track_onboarding_progress`
- `validate_specification_consistency`

**Example Prompt**:
```
@specification Use prompt progressive-onboarding for ./monolith, prioritize: api, authentication, user-management
```

**Agent Behavior**:
1. Calls `extract_feature_boundaries` to map features
2. For each priority feature:
   - Calls `analyze_feature_component`
   - Calls `onboard_project_feature`
   - Saves to `spec/progressive-onboarding/features/<feature>/`
3. Calls `merge_feature_specifications` to create master spec
4. Calls `detect_specification_conflicts` and reports issues
5. Calls `create_progressive_migration_plan`
6. Provides roadmap with recommended sequence

### Scenario 4: New Greenfield Project

**User Goal**: Start a brand new project using spec-driven development from day one.

**Workflow**:
1. User: "Initialize a new spec-kit project for an e-commerce platform"
2. Agent calls `init_project` MCP tool
3. Agent guides user through spec creation
4. Agent generates implementation plan

**MCP Tools Used**:
- `init_project`
- `create_new_feature`
- `setup_plan`

**Example Prompt**:
```
@specification Initialize a new spec-kit project called "ecommerce-platform" using Claude AI
```

**Agent Behavior**:
1. Calls `init_project` with project name and AI choice
2. Downloads spec-kit templates
3. Initializes Git repository
4. Creates `memory/constitution.md`, `templates/`, `scripts/`
5. Guides user: "Now use /specify command to create your first feature"

## Tool Mapping by Workflow Phase

Map spec-kit-mcp tools to the 6-phase spec-driven workflow:

### Phase 1: ANALYZE

**Objective**: Understand problem, analyze system, produce testable requirements.

**Relevant MCP Tools**:
- `analyze_existing_project`: Scan codebase structure
- `parse_existing_documentation`: Extract existing requirements
- `extract_requirements_from_code`: Mine requirements from code
- `extract_feature_boundaries`: Identify feature divisions (progressive)
- `analyze_feature_component`: Analyze specific feature (progressive)

**Workflow**:
1. Determine if greenfield or brownfield
2. For brownfield: run analysis tools
3. Document findings in `requirements.md`
4. Generate Confidence Score
5. Proceed to DESIGN if >66% confidence, else research

### Phase 2: DESIGN

**Objective**: Create technical design and implementation plan.

**Relevant MCP Tools**:
- `generate_standardized_spec`: Create spec from analysis
- `setup_plan`: Generate implementation plan
- `create_migration_plan`: Plan spec-driven adoption (brownfield)
- `create_progressive_migration_plan`: Plan incremental adoption

**Workflow**:
1. Transform requirements into technical design
2. Document in `design.md`
3. Define technology choices with rationale
4. Create `tasks.md` with implementation sequence
5. Validate against constitutional principles

### Phase 3: IMPLEMENT

**Objective**: Write production code according to design.

**Relevant MCP Tools**:
- `check_task_prerequisites`: Validate dependencies before coding
- `run_script`: Execute spec-kit scripts for automation
- `update_agent_context`: Refresh agent context as code evolves

**Workflow**:
1. Follow Test-First Imperative (Constitution Article III)
2. Code in small increments
3. Update task status in `tasks.md`
4. Document decisions in Decision Records

### Phase 4: VALIDATE

**Objective**: Verify implementation meets requirements.

**Relevant MCP Tools**:
- `validate_specification_consistency`: Ensure spec alignment (progressive)
- `detect_specification_conflicts`: Find conflicts (progressive)

**Workflow**:
1. Execute automated tests
2. Verify against acceptance criteria
3. Test edge cases
4. Document validation results

### Phase 5: REFLECT

**Objective**: Improve codebase, update docs, analyze performance.

**Relevant MCP Tools**:
- `track_onboarding_progress`: Monitor migration progress (progressive)
- `resolve_feature_dependencies`: Document dependencies (progressive)

**Workflow**:
1. Refactor for maintainability
2. Update specification if requirements changed
3. Identify improvements for backlog
4. Document technical debt

### Phase 6: HANDOFF

**Objective**: Package work, deploy, transition.

**Relevant MCP Tools**:
- `merge_feature_specifications`: Combine specs (progressive)
- `get_feature_paths`: Retrieve all feature files for PR

**Workflow**:
1. Generate executive summary
2. Prepare pull request with spec links
3. Archive artifacts to `.agent_work/`
4. Update master specification (if progressive)

## Tool Reference Table

| Tool Name | Category | Use Case | Input | Output |
|-----------|----------|----------|-------|--------|
| `init_project` | Greenfield | Initialize new spec-kit project | project_name, ai_assistant | Project scaffolding |
| `create_new_feature` | Greenfield | Create feature branch + spec | feature_description | Feature scaffolding |
| `setup_plan` | Greenfield | Generate implementation plan | - | plan.md, details/ |
| `analyze_existing_project` | Brownfield | Scan project structure | project_path, max_depth | Project analysis JSON |
| `parse_existing_documentation` | Brownfield | Extract from docs | project_path, file_patterns | Requirements JSON |
| `extract_requirements_from_code` | Brownfield | Mine from code | project_path, file_patterns | Code analysis JSON |
| `generate_standardized_spec` | Brownfield | Create spec from analysis | analysis results | Standardized spec |
| `create_migration_plan` | Brownfield | Plan spec adoption | project_analysis, spec | Migration roadmap |
| `onboard_existing_project` | Brownfield | Full onboarding workflow | project_path | Complete onboarding |
| `extract_feature_boundaries` | Progressive | Identify features | project_path, depth | Feature boundaries |
| `analyze_feature_component` | Progressive | Analyze single feature | project_path, feature_path | Feature analysis |
| `onboard_project_feature` | Progressive | Onboard one feature | project_path, feature_path | Feature spec |
| `merge_feature_specifications` | Progressive | Combine specs | feature_specs | Master spec |
| `detect_specification_conflicts` | Progressive | Find conflicts | feature_specs | Conflict report |
| `resolve_feature_dependencies` | Progressive | Document dependencies | feature_specs | Dependency map |
| `create_progressive_migration_plan` | Progressive | Plan incremental adoption | project_path, boundaries | Phased plan |
| `track_onboarding_progress` | Progressive | Monitor progress | project_path, plan, completed | Progress report |
| `validate_specification_consistency` | Progressive | Ensure consistency | feature_specs | Validation report |
| `check_requirements` | Utility | Verify prerequisites | - | System check |
| `list_scripts` | Utility | Show available scripts | - | Script list |
| `run_script` | Utility | Execute script | script_name, args | Script output |
| `check_task_prerequisites` | Utility | Validate dependencies | - | Prerequisite check |
| `update_agent_context` | Utility | Refresh context | - | Updated context |
| `get_feature_paths` | Utility | Get feature files | - | Path list |

## Best Practices

### 1. Choose the Right Workflow

- **Greenfield**: Use `init_project` → `create_new_feature`
- **Small Brownfield**: Use `onboard_existing_project`
- **Large Brownfield**: Use `progressive-onboarding` approach
- **Hybrid**: Mix approaches as needed

### 2. Validate Before Proceeding

Always check `Confidence Score` in ANALYZE phase:
- >85%: Full implementation
- 66-85%: Build PoC first
- <66%: Research and clarify

### 3. Use Constitutional Principles

Reference `memory/constitution.md`:
- Article I: Library-First
- Article III: Test-First
- Article VII: Simplicity (≤3 projects)
- Article VIII: Anti-Abstraction
- Article IX: Integration-First Testing

### 4. Iterate on Specifications

Specifications are living documents:
- Mark unclear items with `[NEEDS CLARIFICATION]`
- Refine through stakeholder feedback
- Update as requirements evolve
- Version specifications with code

### 5. Leverage Parallel Tools

When analyzing existing projects, run tools in parallel:
- `analyze_existing_project` + `parse_existing_documentation` simultaneously
- Then combine results for `generate_standardized_spec`

### 6. Track Progress

For progressive onboarding:
- Use `track_onboarding_progress` weekly
- Celebrate completed features
- Adjust plan based on learnings

## Troubleshooting

### Issue: "spec-kit-mcp tool not found"

**Solution**: Verify MCP server is running and configured correctly.
```powershell
spec-kit-mcp  # Should start the server
# Check MCP configuration in your Copilot client
```

### Issue: Analysis tools return empty results

**Solution**: Check file patterns and project path.
```
# Verify project path exists
Test-Path C:\Development\ASISaga\BusinessInfinity

# Check file patterns match your codebase
# For Python: ["*.py"]
# For JavaScript: ["*.js", "*.ts"]
```

### Issue: Generated spec has many [NEEDS CLARIFICATION] markers

**Solution**: This is expected! Review and fill in:
1. Gather stakeholders for clarification session
2. Review code/docs to fill gaps
3. Make reasonable assumptions, document them
4. Iterate until <5% of spec needs clarification

### Issue: Progressive onboarding: features have circular dependencies

**Solution**: Re-examine feature boundaries.
1. Use `analyze_feature_component` on candidate groupings
2. Consider merging tightly coupled features
3. Or onboard dependent features together as a unit

### Issue: Specification conflicts detected

**Solution**: Use `detect_specification_conflicts` output to guide resolution.
1. Hold conflict resolution session with feature owners
2. Update conflicting specs to align
3. Re-run `validate_specification_consistency`

## Advanced Usage

### Custom Scripts

spec-kit-mcp supports custom scripts. Add to `scripts/` directory:

```bash
# scripts/my-custom-workflow.py
import sys
from pathlib import Path

def main():
    # Your custom logic
    print("Custom workflow executed")

if __name__ == "__main__":
    main()
```

Then run via MCP:
```
{
  "tool": "run_script",
  "args": {
    "script_name": "my-custom-workflow",
    "args": []
  }
}
```

### Extending the Constitution

Add project-specific principles to `memory/constitution.md`:

```markdown
## Article X: Custom Principle

Section 10.1: Project-Specific Constraint
All API endpoints MUST use JSON:API specification format.

Rationale: Organizational standard for API design.
```

Reference in specifications and implementation plans.

### Multi-Repository Coordination

For monorepos or multi-repo projects:

1. Run `extract_feature_boundaries` at repository level
2. Onboard features within each repository
3. Use `merge_feature_specifications` across repos
4. Maintain master spec at organization level

## FAQ

**Q: Can I use spec-kit-mcp without the prompts?**
A: Yes, call MCP tools directly. Prompts provide structured workflows for common scenarios.

**Q: Do I need to onboard my entire codebase?**
A: No. Progressive onboarding lets you adopt feature-by-feature.

**Q: Can I mix greenfield and brownfield approaches?**
A: Absolutely. Use progressive onboarding for legacy code, greenfield for new features.

**Q: How do I handle constantly changing requirements?**
A: Specifications are living documents. Update specs, regenerate implementation plans, refactor code.

**Q: What if my organization uses different naming conventions?**
A: Customize templates in `templates/` directory. spec-kit is flexible.

**Q: Can I use spec-kit-mcp with languages other than Python?**
A: Yes! The analysis tools support Python, JavaScript, TypeScript, Java, C#, Go, etc.

**Q: How do I ensure team adoption?**
A: Start small (1-2 features), prove value, share results, scale incrementally.

## Resources

- **spec-kit-mcp Repository**: [ASISaga/spec-kit-mcp](https://github.com/ASISaga/spec-kit-mcp)
- **Specification Agent**: `.github/agents/specification.agent.md`
- **Workflow Instructions**: `.github/instructions/spec-driven-workflow.instructions.md`
- **Prompts**: `.github/prompts/*.prompt.md`
- **Constitution Template**: `MCP/spec-kit-mcp/base/memory/constitution.md`

## Next Steps

1. Install spec-kit-mcp: `pip install git+https://github.com/ASISaga/spec-kit-mcp.git`
2. Configure MCP server in your Copilot client
3. Try a simple workflow: `@specification Create new feature for user login`
4. Explore prompts: `@specification Use prompt onboard-existing-project`
5. Read the constitution: `MCP/spec-kit-mcp/base/memory/constitution.md`
6. Join the community: Share your experiences and learnings

---

**Remember**: Specifications drive code. Code serves specifications. AI automates the translation. You focus on the **what** and **why**—let spec-driven development handle the **how**.
