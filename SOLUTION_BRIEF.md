# Liquibase Policy Checks Exception Handling - Solution Brief

## 1. Summary

This solution demonstrates how to implement intelligent Policy Checks exception handling across multiple CI/CD platforms (GitHub Actions, Azure DevOps, and GitLab) using Liquibase Pro. The approach enables development teams to maintain velocity while ensuring production safety through conditional approval workflows.

**Key Innovation**: Rather than blocking all deployments when policy checks fail, this solution allows development environments to proceed automatically while requiring manual approval only for higher environments (TEST/PROD) when policy violations are detected.

### Core Principles
- **Non-blocking Development**: Policy check failures don't halt development workflow
- **Conditional Production Gates**: Manual approval required only when needed
- **Environment-Specific Risk Management**: Different approval requirements based on environment criticality
- **Comprehensive Audit Trail**: Full visibility into policy decisions and approvals

## 2. Business Benefits

### Accelerated Development Velocity
- **Reduced Development Friction**: Developers can continue working even when policy checks fail
- **Faster Iteration Cycles**: No waiting for policy fixes to deploy to development environments
- **Improved Developer Experience**: Clear feedback without workflow interruption

### Enhanced Production Safety
- **Risk-Based Approvals**: Manual review triggered only when policy violations are detected
- **Environmental Risk Stratification**: Different approval requirements for DEV vs TEST vs PROD
- **Compliance Maintenance**: Ensures policy violations are reviewed before reaching production

### Operational Efficiency
- **Reduced Manual Overhead**: Automatic approvals when policies pass
- **Focused Review Process**: Manual intervention only when necessary
- **Clear Decision Points**: Well-defined criteria for when manual approval is required

### Cost Optimization
- **Reduced Deployment Delays**: Faster time-to-market for compliant changes
- **Optimized Resource Utilization**: Less time spent on unnecessary approvals
- **Lower Operational Overhead**: Automated decision-making where appropriate

## 3. Example Scenarios

### Scenario 1: Compliant Change Deployment
**Situation**: Developer adds a new table with proper naming conventions and documentation

**Flow**:
1. Policy checks execute and pass (exit code 0)
2. DEV deployment proceeds automatically
3. TEST deployment proceeds automatically 
4. PROD deployment proceeds with standard manual approval (business process)

**Outcome**: Smooth deployment with minimal manual intervention

### Scenario 2: Policy Violation - Minor Issue
**Situation**: Developer creates table without proper documentation comments

**Flow**:
1. Policy checks execute and fail (exit code > 0) 
2. DEV deployment proceeds automatically (allows development to continue)
3. TEST deployment requires manual approval and review
4. Team reviews violation, adds documentation, re-runs pipeline
5. Updated changes pass policy checks and deploy automatically

**Outcome**: Issue identified early, fixed quickly, minimal disruption

### Scenario 3: Policy Violation - Major Compliance Issue
**Situation**: Developer attempts to drop a production table

**Flow**:
1. Policy checks execute and fail with critical violation
2. DEV deployment proceeds (isolated development environment)
3. TEST deployment blocked, requires manual approval
4. Database administrator reviews, rejects deployment
5. Developer revises approach using safer migration strategy

**Outcome**: Critical issue prevented from reaching production, proper governance applied

### Scenario 4: Policy Check System Failure
**Situation**: Policy check system experiences unexpected error (exit code 2)

**Flow**:
1. Policy checks fail with unexpected exit code
2. System treats as policy failure (fail-safe approach)
3. All higher environment deployments require manual approval
4. Operations team investigates policy check system
5. Once resolved, deployments can proceed normally

**Outcome**: System degradation handled gracefully with fail-safe behavior

## 4. High-level Architecture & Flow

### Architecture Components

```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   Source Code   │───▶│  CI/CD Platform  │───▶│  Target Envs    │
│                 │    │                  │    │                 │
│ • Changelogs    │    │ • Policy Checks  │    │ • DEV (Auto)    │
│ • Flow Files    │    │ • Approval Gates │    │ • TEST (Cond.)  │
│ • Policy Rules  │    │ • Environment    │    │ • PROD (Manual) │
└─────────────────┘    │   Configuration  │    └─────────────────┘
                       └──────────────────┘
```

### Decision Flow Logic

```
Policy Checks Execute
         │
    ┌────▼────┐
    │ Pass?   │
    │(Exit=0) │
    └────┬────┘
         │
    ┌────▼────────────────────┐
    │                         │
 ┌──▼──┐ YES            NO ┌──▼──┐
 │Auto │                   │Manual│
 │Deploy│                  │Review│
 └──┬──┘                   └──┬──┘
    │                         │
    ▼                         ▼
┌───────────────┐      ┌──────────────┐
│All Envs       │      │Higher Envs   │
│Deploy         │      │Require       │
│Automatically  │      │Approval      │
└───────────────┘      └──────────────┘
```

### Environment Risk Matrix

| Environment | Policy Pass | Policy Fail | Critical Fail |
|-------------|-------------|-------------|---------------|
| **DEV**     | Auto Deploy | Auto Deploy | Auto Deploy   |
| **TEST**    | Auto Deploy | Manual Approval | Manual Approval |
| **PROD**    | Manual Approval | Manual Approval | Manual Approval |

## 5. Reference Architectures

### a) GitHub Actions Architecture

**Implementation**: `CS_Postgres` repository with GitHub Actions workflows

**Key Components**:
- **Policy Checks Job**: Runs policy validation and sets output variables
- **Manual Approval Job**: Conditional job that runs only on policy failures  
- **Deploy Job**: Conditional deployment based on policy results and approval status

**Workflow Structure**:
```yaml
Deploy Pipeline:
├── run-policy-checks (always runs)
│   ├── Sets needs_approval = true/false
│   └── Sets exit_message with results
├── manual-approval (conditional on policy failure)
│   ├── Requires 'manual-approval' environment
│   └── Only runs if needs_approval = true
└── deploy (conditional execution)
    ├── Runs if policy passed OR manual approval succeeded
    └── Uses environment-specific configurations
```

**Conditional Logic**:
- **Policy Pass**: `needs_approval=false` → Deploy runs automatically
- **Policy Fail**: `needs_approval=true` → Manual approval required → Deploy after approval

**Environment Configuration**:
- Uses GitHub Environments for approval gates
- Environment-specific secrets for database connections
- Built-in approval workflow UI

### b) Azure DevOps Architecture  

**Implementation**: `test_project_policy_exceptions` repository with Azure Pipelines

**Key Components**:
- **Policy Checks Stage**: Runs checks and sets pipeline variables
- **Build Stage**: Always runs, provides warnings about approval requirements
- **Manual Approval Stage**: Conditional stage for policy failures
- **Production Deploy Stage**: Conditional on policy status and approvals

**Pipeline Structure**:
```yaml
Pipeline Stages:
├── Run_Policy_Checks
│   ├── Sets needs_approval variable  
│   └── Always exits successfully (non-blocking)
├── Build (Deploy to Dev) 
│   ├── Always runs regardless of policy status
│   └── Shows warnings about production requirements
├── Manual_Approval (conditional)
│   ├── Only runs if needs_approval = true
│   └── Uses 'Prod-approval' environment
└── Deploy_to_Prod (conditional)
    ├── Runs if policy passed OR manual approval succeeded
    └── Uses production environment configuration
```

**Stage Dependencies**:
```yaml
Manual_Approval:
  condition: eq(dependencies.Run_Policy_Checks.outputs['needs_approval'], true)
  
Deploy_to_Prod:
  condition: or(
    eq(dependencies.Run_Policy_Checks.outputs['needs_approval'], false),
    succeeded('Manual_Approval')
  )
```

**Variable Passing**:
- Uses Azure DevOps stage dependencies to pass variables
- `stageDependencies.Run_Policy_Checks.policy_checks_with_override.outputs`
- Environment-specific variable groups for database configurations

### c) GitLab Pipeline Architecture

**Implementation**: `test_project_policy_exceptions` repository with GitLab CI

**Key Components**:
- **Policy Checks Stage**: Creates environment file with policy results
- **Build Stage**: Consumes policy results, always deploys to DEV
- **Deploy Stages**: Use rules for conditional execution based on policy status

**Pipeline Structure**:
```yaml
Stages:
├── policy-checks
│   ├── Creates policy_check.env artifact
│   └── Sets POLICY_CHECK_FAILED variable
├── build  
│   ├── Always runs, shows policy status
│   └── Deploys to DEV regardless of policy results
├── deploy-to-test
│   ├── Rules-based conditional execution
│   └── Manual if POLICY_CHECK_FAILED=true
└── deploy-to-prod
    ├── Always manual (production safety)
    └── Shows policy status in deployment logs
```

**Conditional Rules**:
```yaml
deploy-to-test:
  rules:
    - if: '$POLICY_CHECK_FAILED == "true"'
      when: manual
    - if: '$POLICY_CHECK_FAILED == "false"'  
      when: on_success

deploy-to-prod:
  rules:
    - if: '$POLICY_CHECK_FAILED == "true"'
      when: manual
    - when: manual  # Always manual for PROD
```

**Variable Sharing**:
- Uses GitLab's `dotenv` reports to pass variables between stages
- `reports: dotenv: policy_check.env`
- Variables automatically available in downstream jobs

## Implementation Comparison

| Feature | GitHub Actions | Azure DevOps | GitLab CI |
|---------|----------------|---------------|-----------|
| **Variable Passing** | Job outputs | Stage dependencies | dotenv reports |
| **Conditional Logic** | Job conditions | Stage conditions | Rules syntax |
| **Approval Gates** | Environments | Environments | Manual when |
| **Policy Integration** | Continue-on-error | Always exit 0 | Always exit 0 |
| **Environment Management** | GitHub Environments | Variable Groups | GitLab Environments |

## Getting Started

1. **Choose Your Platform**: Select GitHub Actions, Azure DevOps, or GitLab based on your current CI/CD infrastructure
2. **Configure Environments**: Set up environment-specific configurations and approval requirements  
3. **Implement Policy Checks**: Configure Liquibase policy rules appropriate for your organization
4. **Test Workflow**: Verify the conditional approval logic works with both passing and failing policy scenarios
5. **Monitor and Refine**: Adjust policy rules and approval processes based on team feedback and operational experience

This solution provides a robust foundation for implementing intelligent database governance that balances development velocity with production safety across any major CI/CD platform.