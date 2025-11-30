---
agent: 'specification'
description: 'Onboard an existing project to spec-driven development by analyzing codebase, extracting requirements, and creating standardized specifications with migration plan.'
tools: ['spec-kit-mcp', 'search/codebase', 'edit/editFiles', 'fetch', 'githubRepo', 'search', 'vscodeAPI']
---
# Onboard Existing Project to Spec-Driven Development

Your goal is to onboard the existing project at `${input:ProjectPath}` to spec-driven development methodology.

## Process Overview

This prompt orchestrates a complete end-to-end onboarding using spec-kit-mcp tools:

1. **Analyze Project Structure**: Scan directories, identify languages, frameworks, and organization
2. **Parse Documentation**: Extract requirements from README, docs, wikis, and markdown files
3. **Mine Code**: Extract requirements from code comments, docstrings, TODO/FIXME markers
4. **Generate Specification**: Create standardized spec-kit compatible specification
5. **Create Migration Plan**: Develop phased adoption roadmap with concrete steps

## Execution Steps

### Step 1: Project Analysis

Use the `analyze_existing_project` MCP tool:
```
{
  "project_path": "${input:ProjectPath}",
  "max_depth": 3
}
```

Review the analysis output to understand:
- Project size and complexity
- Languages and frameworks detected
- Directory structure and organization patterns
- Key entry points and configuration files

### Step 2: Documentation Parsing

Use the `parse_existing_documentation` MCP tool:
```
{
  "project_path": "${input:ProjectPath}",
  "file_patterns": ["*.md", "README*", "*.txt", "docs/**"]
}
```

This extracts:
- User stories and features from documentation
- Existing requirements and acceptance criteria
- API documentation and usage examples
- Known issues and limitations

### Step 3: Code Analysis

Use the `extract_requirements_from_code` MCP tool:
```
{
  "project_path": "${input:ProjectPath}",
  "file_patterns": ["*.py", "*.js", "*.ts", "*.java", "*.cs", "*.go"]
}
```

This mines:
- Functional requirements from docstrings
- Edge cases from test files
- Technical constraints from configuration
- TODO/FIXME markers indicating missing features

### Step 4: Specification Generation

Use the `generate_standardized_spec` MCP tool:
```
{
  "project_analysis": <result from step 1>,
  "documentation_analysis": <result from step 2>,
  "code_analysis": <result from step 3>
}
```

This produces a complete specification with:
- Consolidated requirements in EARS notation
- Identified gaps requiring clarification
- Extracted acceptance criteria
- System architecture overview

### Step 5: Migration Planning

Use the `create_migration_plan` MCP tool:
```
{
  "project_analysis": <result from step 1>,
  "standardized_spec": <result from step 4>
}
```

This generates:
- Phased migration roadmap
- Risk assessment and mitigation strategies
- Team training recommendations
- Success metrics and checkpoints

### Step 6: Alternatively, Use Single Tool

For convenience, you can use `onboard_existing_project` which combines all steps:
```
{
  "project_path": "${input:ProjectPath}",
  "max_depth": 3,
  "include_migration_plan": true
}
```

## Output Structure

Save the generated artifacts:
- `spec/onboarding-analysis.md`: Project analysis summary
- `spec/spec-<project-name>.md`: Standardized specification
- `spec/migration-plan.md`: Adoption roadmap and implementation plan
- `spec/onboarding-summary.md`: Executive summary with next steps

## Best Practices

- **Review Before Committing**: The generated spec will have `[NEEDS CLARIFICATION]` markers - review and fill these in
- **Validate with Stakeholders**: Share the extracted requirements with original authors
- **Iterate on Gaps**: Use the gaps list to drive clarification sessions
- **Start Small**: Begin migration with a single module or feature
- **Measure Progress**: Track metrics defined in the migration plan

## Clarification Prompts

If the analysis identifies ambiguities, ask targeted questions:
- "The codebase has feature X but no documentation. What are the requirements for X?"
- "Test file Y suggests edge case Z but no requirement exists. Should this be formalized?"
- "Configuration suggests deployment to platform P. What are the deployment constraints?"

## Next Steps After Onboarding

1. Review and refine the generated specification
2. Validate requirements with stakeholders
3. Follow Phase 1 of the migration plan
4. Set up spec-kit environment: `spec-kit-mcp init_project`
5. Train team on spec-driven workflow
6. Begin implementing first feature using the new methodology

## Constitutional Compliance

Ensure the migration plan aligns with the spec-kit constitution:
- Article I: Library-First Principle
- Article III: Test-First Imperative
- Article VII: Simplicity (≤3 projects initially)
- Article VIII: Anti-Abstraction (use frameworks directly)
- Article IX: Integration-First Testing (real databases, not mocks)

Reference `memory/constitution.md` in the generated spec-kit project for full constitutional principles.
