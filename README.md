# CS_Postgres
Demo of reference implementation of Liquibase Secure with GitHub Actions

## GitHub Actions Pipeline Overview

This repository implements a comprehensive Liquibase Secure workflow using GitHub Actions with five distinct pipeline actions, each designed for specific database lifecycle management tasks. All pipelines integrate with AWS S3 for artifact storage and reporting.

## Available Pipeline Actions

### 1. **Premerge** (`lb_premerge_action.yml`) 
**Purpose**: Pre-merge validation using temporary ephemeral database

**Workflow**:
- **Ephemeral Database Creation**: Creates a temporary database clone (`${DATABASE}_eph`)
- **Database Population**: 
  - Dumps schema and changelog data from source database
  - Restores to temporary database for isolated testing
- **Validation**: Runs `liquibase-premerge.flowfile.yaml` against ephemeral database
- **Policy Checks**: Non-blocking policy validation
- **Cleanup**: Destroys temporary database after validation

**Key Benefits**:
- **Isolated Testing**: Changes tested in complete isolation
- **Zero Impact**: No effect on existing databases during validation  
- **Pre-merge Safety**: Validates changes before branch merge
- **Comprehensive Validation**: Full schema and data validation

**Database Operations**:
- Uses PostgreSQL client tools (`pg_dump`, `psql`) for database cloning
- Creates separate database with `_eph` suffix
- Includes both schema and changelog history in clone

### 2. **Build** (`lb_build_action.yml`)
**Purpose**: Performs initial database deployment to development environment

**Workflow**:
- Runs Policy Checks with `liquibase-checks.flowfile.yaml`
- **Non-blocking Policy Checks**: Build continues even if policies fail
- Executes Build Flow using `liquibase-build.flowfile.yaml`
- Deploys changes to the first database environment (typically DEV)
- Uploads reports and artifacts to S3

**Trigger**: Manual workflow dispatch with environment selection

**Key Features**:
- Environment-specific configuration through GitHub environments
- Optional tagging support for builds
- Comprehensive logging in JSON format

### 3. **Deploy** (`lb_deploy_action.yml`)
**Purpose**: Environment-targeted deployment with conditional approval workflow

**Workflow**:
1. **Policy Checks Job**: Runs `liquibase-checks.flowfile.yaml` and sets approval flags
2. **Manual Approval Job**: Activated only if policy checks fail
3. **Deploy Job**: Executes `liquibase-deploy.flowfile.yaml` deployment

**Conditional Logic**:
- ✅ **Policy Checks Pass**: Deployment proceeds automatically
- ❌ **Policy Checks Fail**: Manual approval required via `manual-approval` environment
- Deployment only runs after successful approval or if checks passed

**Features**:
- Drift detection option
- Multi-environment support with environment-specific secrets
- Comprehensive approval workflow for production safety

### 4. **Rollback** (`lb_rollback_action.yml`)
**Purpose**: Environment-targeted database rollback operations

**Workflow**:
- User selects rollback method:
  - **rollback_to_tag**: Rollback to specific tag
  - **rollback_by_label**: Rollback using changeset labels
- Executes `liquibase-rollback.flowfile.yaml` with specified parameters
- Uploads rollback reports and artifacts

**Features**:
- Multiple rollback strategies (tag-based or label-based)
- Environment-specific rollback targeting
- Comprehensive rollback reporting

### 5. **Snapshot** (`lb_snapshot_action.yml`)
**Purpose**: Create database snapshots for documentation and comparison

**Workflow**:
- Connects to specified environment database
- Executes `liquibase-snapshot.flowfile.yaml`
- Generates database structure snapshots
- Stores snapshots for later comparison or documentation

**Use Cases**:
- Database state documentation
- Environment comparison
- Drift detection reference points
- Audit trail creation

## Policy Check Integration

All pipelines integrate Liquibase Policy Checks with different behaviors:

| Pipeline | Policy Check Behavior | Action on Failure |
|----------|---------------------|------------------|
| **Premerge** | Non-blocking | ⚠️ Warning logged, validation continues |
| **Build** | Non-blocking | ⚠️ Warning logged, build continues |
| **Deploy** | Conditional blocking | 🚫 Manual approval required |
| **Rollback** | N/A | Not applicable |
| **Snapshot** | N/A | Not applicable |

## Environment Configuration

Each pipeline supports:
- **Environment-specific secrets**: Database URLs, credentials stored in GitHub environments
- **AWS S3 integration**: Report storage and artifact management
- **Flexible schema targeting**: Multi-schema support (`gha`, `abc`)
- **Comprehensive logging**: JSON-formatted logs with configurable levels

## Flow Files Structure

Each pipeline uses dedicated Liquibase Flow files:
- `liquibase-build.flowfile.yaml`: Development deployment flow
- `liquibase-deploy.flowfile.yaml`: Production deployment flow  
- `liquibase-premerge.flowfile.yaml`: Pre-merge validation with ephemeral DB
- `liquibase-rollback.flowfile.yaml`: Rollback operations flow
- `liquibase-snapshot.flowfile.yaml`: Database snapshot flow
- `liquibase-checks.flowfile.yaml`: Policy checks flow (shared across pipelines)
