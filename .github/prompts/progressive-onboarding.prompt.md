---
agent: 'specification'
description: 'Progressively onboard a large project to spec-driven development by onboarding individual features/components incrementally, supporting multi-team adoption.'
tools: ['spec-kit-mcp', 'search/codebase', 'edit/editFiles', 'fetch', 'githubRepo', 'search', 'vscodeAPI']
---
# Progressive Onboarding: Feature-by-Feature Spec-Driven Adoption

Your goal is to onboard the project at `${input:ProjectPath}` progressively, one feature at a time, rather than attempting full project onboarding.

## Why Progressive Onboarding?

Use progressive onboarding when:
- **Large Legacy Codebase**: Full analysis would be overwhelming
- **Multiple Teams**: Different teams own different features
- **Gradual Adoption**: Organization wants to pilot spec-driven development
- **Risk Mitigation**: Start small, prove value, then expand
- **Active Development**: Can't pause for full migration

## Process Overview

1. **Identify Feature Boundaries**: Discover logical feature/component divisions
2. **Prioritize Features**: Select which features to onboard first
3. **Onboard Features**: Incrementally spec each feature
4. **Merge Specifications**: Combine feature specs into master specification
5. **Resolve Conflicts**: Detect and fix conflicts between specs
6. **Track Progress**: Monitor adoption across features and teams

## Execution Steps

### Step 1: Extract Feature Boundaries

Use the `extract_feature_boundaries` MCP tool:
```
{
  "project_path": "${input:ProjectPath}",
  "analysis_depth": 2
}
```

This identifies:
- Logical feature groupings by directory structure
- Component boundaries by dependency analysis
- Module boundaries by import/namespace patterns
- Service boundaries in microservice architectures

Review the output and select 2-3 features to onboard first (start small!).

### Step 2: Analyze Selected Feature

For each feature, use `analyze_feature_component`:
```
{
  "project_path": "${input:ProjectPath}",
  "feature_path": "src/authentication",  // example
  "max_depth": 2
}
```

This performs targeted analysis of the specific feature/component.

### Step 3: Onboard Feature to Spec-Driven

Use `onboard_project_feature`:
```
{
  "project_path": "${input:ProjectPath}",
  "feature_path": "src/authentication",
  "include_dependencies": true
}
```

This generates:
- Feature-specific specification
- Dependency map showing inter-feature connections
- Test strategy for the feature
- Migration recommendations for this feature

**Repeat Steps 2-3 for each priority feature.**

### Step 4: Merge Feature Specifications

Once you have multiple feature specs, use `merge_feature_specifications`:
```
{
  "feature_specifications": [
    <auth feature spec>,
    <user-profile feature spec>,
    <payment feature spec>
  ],
  "master_project_info": {
    "project_name": "MyApp",
    "version": "1.0",
    "owner": "Platform Team"
  }
}
```

This creates a unified master specification that integrates all feature specs.

### Step 5: Detect Specification Conflicts

Use `detect_specification_conflicts`:
```
{
  "feature_specifications": [<list of feature specs>]
}
```

This identifies:
- Conflicting requirements between features
- Inconsistent terminology or definitions
- Overlapping responsibilities
- Incompatible technology choices

### Step 6: Resolve Feature Dependencies

Use `resolve_feature_dependencies`:
```
{
  "feature_specifications": [<list of feature specs>]
}
```

This documents:
- Which features depend on which others
- Suggested onboarding order based on dependencies
- Shared components requiring coordination
- Integration points requiring alignment

### Step 7: Create Progressive Migration Plan

Use `create_progressive_migration_plan`:
```
{
  "project_path": "${input:ProjectPath}",
  "feature_boundaries": <result from step 1>,
  "priority_features": ["authentication", "user-profile", "payments"]
}
```

This generates a phased plan with:
- Recommended onboarding sequence
- Team assignments and coordination needs
- Milestone definitions and success criteria
- Risk assessment per phase

### Step 8: Track Onboarding Progress

As features are completed, use `track_onboarding_progress`:
```
{
  "project_path": "${input:ProjectPath}",
  "migration_plan": <result from step 7>,
  "completed_features": ["authentication", "user-profile"]
}
```

This provides:
- Progress percentage across the project
- Next recommended features to onboard
- Blockers and dependencies preventing progress
- Team velocity and completion estimates

### Step 9: Validate Specification Consistency

Periodically use `validate_specification_consistency`:
```
{
  "feature_specifications": [<all onboarded feature specs>]
}
```

This ensures:
- Consistent terminology across specs
- Aligned architectural decisions
- No conflicting requirements
- Coherent overall system design

## Output Structure

Organize progressive onboarding artifacts:
```
spec/
  progressive-onboarding/
    feature-boundaries.md         # Result of step 1
    migration-plan.md              # Result of step 7
    progress-tracker.md            # Result of step 8
    features/
      001-authentication/
        spec.md                    # Feature specification
        dependencies.md            # Feature dependencies
      002-user-profile/
        spec.md
        dependencies.md
      003-payments/
        spec.md
        dependencies.md
    master-specification.md        # Merged specification
    conflicts-resolved.md          # Conflict resolution log
```

## Multi-Team Coordination

For organizations with multiple teams:

1. **Team Assignment**: Assign each team 1-2 features to onboard
2. **Weekly Sync**: Review progress, resolve conflicts, share learnings
3. **Shared Glossary**: Maintain unified terminology in `master-specification.md`
4. **Integration Testing**: Test feature interactions as specs are completed
5. **Knowledge Sharing**: Have teams demo their specs and migration approach

## Best Practices

- **Start with Independent Features**: Choose features with minimal dependencies first
- **Limit Work in Progress**: Onboard 2-3 features at a time, complete before adding more
- **Validate Early**: Test the spec-driven workflow on first feature before scaling
- **Document Patterns**: Capture reusable patterns discovered during onboarding
- **Celebrate Wins**: Share success stories to build momentum
- **Iterate on Process**: Refine the onboarding approach based on learnings

## Progressive Onboarding Phases

**Phase 1: Pilot (Weeks 1-2)**
- Onboard 1 small, well-understood feature
- Train core team on spec-kit methodology
- Validate tooling and workflow
- Document lessons learned

**Phase 2: Expand (Weeks 3-6)**
- Onboard 3-5 additional features
- Engage multiple teams
- Establish conflict resolution process
- Begin merging specifications

**Phase 3: Scale (Weeks 7-12)**
- Onboard remaining features incrementally
- Track progress and unblock dependencies
- Maintain specification consistency
- Plan for 100% coverage

**Phase 4: Maintain (Ongoing)**
- All new features start spec-first
- Legacy features onboarded opportunistically
- Continuous spec refinement
- Regular consistency validation

## Success Metrics

Track these metrics to measure progressive onboarding success:
- **Features Onboarded**: Count and percentage
- **Specification Coverage**: Percentage of codebase with specs
- **Team Adoption**: Number of teams using spec-driven workflow
- **Conflict Resolution Time**: Average time to resolve spec conflicts
- **Development Velocity**: Feature delivery speed pre vs. post onboarding
- **Defect Reduction**: Bug rates in spec-driven features vs. legacy

## Troubleshooting

**Problem**: Feature boundaries unclear
**Solution**: Use `analyze_feature_component` on candidate groupings, compare results

**Problem**: Too many dependencies between features
**Solution**: Re-examine boundaries, consider onboarding dependent features together

**Problem**: Conflicting specs from different teams
**Solution**: Hold conflict resolution session, use `detect_specification_conflicts` to guide discussion

**Problem**: Progress stalled
**Solution**: Use `track_onboarding_progress` to identify blockers, adjust priorities

## Constitutional Compliance

Each feature specification must align with spec-kit constitutional principles:
- **Article I**: Each feature begins as a standalone library
- **Article III**: Test-first development for all feature implementations
- **Article VII**: Simplicity - ≤3 projects per feature
- **Article VIII**: Anti-abstraction - use frameworks directly
- **Article IX**: Integration-first testing

Reference the project's `memory/constitution.md` for complete principles.

## Next Steps After Feature Onboarding

1. Implement the onboarded feature using spec-driven workflow
2. Measure metrics (velocity, quality) vs. legacy approach
3. Share results with organization to build momentum
4. Onboard next set of features
5. Continuously refine the progressive onboarding process
