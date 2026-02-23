# Agent Instructions - Bryan's MacBook (Work)

## System Context

- **Environment**: macOS 26.2 (Sequoia)
- **User**: bryanwadsworth
- **Shell**: zsh
- **Purpose**: WebOps work machine

## WebOps Project Reference (MANDATORY READING)

Before working on any WebOps task, read the relevant docs in `~/WebOps/docs/`:

### Core Documentation
- `~/WebOps/docs/architecture/webops-application-architecture.md` - System overview, request flows
- `~/WebOps/docs/architecture/iac-architecture-overview.md` - Infrastructure as Code patterns, CDKTF

### Operations
- `~/WebOps/docs/operations/stryker-deployment-runbook.md` - Stryker deployment procedures
- `~/WebOps/docs/operations/iac-new-environment-deployment.md` - Adding new environments to IaC

### Setup & Configuration
- `~/WebOps/docs/setup/local-development-setup.md` - Local development environment setup
- `~/WebOps/docs/setup/iac-project-setup.md` - IaC project setup and configuration
- `~/WebOps/docs/setup/aws-feature-database-config.md` - AWS feature database configuration

### Features
- `~/WebOps/docs/features/trueup-upload-validation.md` - Data True-Up upload/validation flow
- `~/WebOps/docs/features/sso-enrichment-api.md` - SSO Enrichment API for Auth0
- `~/WebOps/docs/features/cnr-mass-update.md` - CNR mass update feature
- `~/WebOps/docs/features/auth0-tenant-management.md` - Auth0 tenant IaC, SSO configuration
- `~/WebOps/docs/features/mobile-auth-flow.md` - Mobile authentication flow
- `~/WebOps/docs/features/webops-shared-infra.md` - Shared infrastructure components

### References
- `~/WebOps/docs/references/environments.md` - Environment inventory, databases, VPC details
- `~/WebOps/docs/aws-infrastructure-mapping.md` - AWS resource mapping across accounts

### Proposals & Spikes
- `~/WebOps/docs/proposals/shared-bootstrap-stack-proposal.md` - Shared bootstrap stack proposal
- `~/WebOps/docs/spikes/iam-user-alternatives.md` - IAM user alternatives investigation

**To see all available docs:** `ls ~/WebOps/docs/**/*.md`

### How to Use These Docs

**Read the relevant doc BEFORE starting work** - not just a keyword search, the whole doc.

For example:
- Working on data-trueup? Read `features/trueup-upload-validation.md` first
- Deploying to new environment? Read `operations/iac-new-environment-deployment.md`
- Auth0 or SSO work? Check `features/auth0-tenant-management.md` and `features/sso-enrichment-api.md`
- Need environment details? Start with `references/environments.md`

The doc names are descriptive - match the task keywords to the doc that covers that feature.

## Before Any Proposal (MANDATORY)

Every solution, suggestion, or change MUST be preceded by research:

1. **Check project documentation FIRST** - Read `~/WebOps/docs/` to understand what exists
2. **Search the codebase** - Find existing patterns, similar implementations
3. **Read the actual files** - Don't assume, verify by reading code and configs
4. **Check official docs** - For unfamiliar technology, find authoritative documentation
5. **Present what you found** - Show references to patterns, files, or docs that inform your proposal
6. **Then propose** - Only after steps 1-5, with complete scope, no hedging

If you cannot show what you researched, you are not ready to propose.

## Commitment to Stated Requirements

When the user states requirements, those ARE the scope - all of them, now:
- No "(Future)" or "Phase 2" to defer parts of what was asked
- No hedging with "could", "might", "optionally"
- No shrinking scope to make tasks seem smaller
- If something is unclear, investigate or ask - don't quietly omit it

## Technical Rules

### System Operations
- **NEVER run sudo commands** - provide the command for user to run
- Verify before editing - read files before modifying them
- This is a Mac - use macOS-specific commands when appropriate (not Linux equivalents)

### Infrastructure (WebOps)

- **IaC only** - NEVER create AWS resources via CLI/Console
- If a resource isn't defined in infrastructure code, it doesn't exist
- Match existing patterns exactly - don't invent new approaches
- Check existing IaC patterns in sibling projects before proposing infrastructure

### Git (WebOps)

- **No AI attribution lines** (no "Generated with Claude", no "Co-Authored-By")
- Reference ticket numbers in commits when available (e.g., `WOR7-1356: Fix upload display`); otherwise use a concise, descriptive message.
- Present the full plan - List all files/changes needed BEFORE making the first edit
- Wait for approval - Explain the "why" not just the "what"
- Use SSH remotes for WebOps repos: `git@github.com-webops:webops-main/<repo>.git`

### AWS Configuration (WebOps)

**Regions:**
- **us-east-1**: CodeCommit, CodePipeline, CodeArtifact, SES
- **us-east-2**: Lambda, Glue, DynamoDB, S3 (data-trueup, production workloads)

**AWS CLI Profiles:**

Use the appropriate profile for your task:

| Profile | Account | Permission Level | Use Case |
|---------|---------|------------------|----------|
| `default` | webops-dev | PowerUserAccess | Normal operations |
| `webops-dev` | webops-dev | PowerUserAccess | Normal operations, deployments |
| `webops-admin` | webops-dev | AdministratorAccess | IAM changes, permission fixes (rare) |
| `platform-infra` | platform-infra | PowerUserAccess | Platform infrastructure |
| `platform-infra-admin` | platform-infra | AdministratorAccess | Platform admin tasks |
| `25x-Prod` | 25x production | AdministratorAccess | Production deployments |
| `25x-Prod-readonly` | 25x production | ReadOnlyAccess | Production investigation |
| `staging-admin` | staging | AdministratorAccess | Staging environment |

```bash
# Switch profile for session
export AWS_PROFILE=webops-dev

# Or per-command
aws --profile webops-dev s3 ls
```

## Troubleshooting & Investigation (MANDATORY)

When investigating issues or checking system status:

1. **Correlate by ID** - Always include identifying keys (uploadId, requestId, etc.) when querying across services
2. **Normalize timestamps** - Convert all timestamps to UTC before comparing across services
3. **Verify before concluding** - "Queue is empty now" ≠ "Queue was empty when the event occurred"
4. **State observations, not assumptions** - Say "I see X" not "X failed" until fully verified
5. **If uncertain, say so** - Don't present assumptions as facts

### Timestamp Handling Across AWS Services

- AWS Glue returns timestamps in LOCAL timezone (e.g., `-07:00`)
- Lambda logs use UTC
- DynamoDB stores Unix timestamps (seconds since epoch)
- **ALWAYS convert to common timezone before comparing**

### Before Concluding Something Failed

1. Check the FULL event chain with correlation ID
2. Convert ALL timestamps to the same timezone
3. Verify queue was empty BEFORE the event, not just currently
4. State findings as observations, not conclusions, until fully verified

## Documentation Maintenance (MANDATORY)

Agents MUST actively maintain documentation:

### When Making Code Changes
- **Check for related docs** - If docs exist for the feature, UPDATE THEM with your changes
- **Track what you changed** - Note which docs need updates as you work
- **Update before completing** - Don't mark work as done until docs are current

### When Troubleshooting Issues
- **Document new issues** - If you resolved something not documented, ADD IT
- **Include the full context** - Symptoms, cause, diagnosis commands, resolution steps
- **This is not optional** - Undocumented tribal knowledge helps no one

### When No Docs Exist
- **Offer to create them** - After completing work on an undocumented feature
- **Prioritize complex flows** - Multi-service flows especially need documentation
- **Include troubleshooting** - Document common issues and how to diagnose them

### When Docs Caused Confusion
- **Note the gap** - Tell the user what was unclear or missing
- **Suggest improvements** - Propose specific additions that would have helped
- **Fix it** - Update the docs to prevent future confusion

## Destructive Operations

Before deleting branches/directories/files with no backup:
1. List what exists ONLY in what's being deleted
2. Warn user what will be permanently lost
3. Offer to preserve first (cherry-pick, copy, stash)
4. Require explicit confirmation

## Behavior Accountability

When a behavior issue is identified:
- NEVER say "I'll be more careful" without concrete action
- ALWAYS update AGENTS.md to enforce the correction
- Propose the rule update immediately

## Installed Tools & Environment

### Package Managers
- **Homebrew** - Primary package manager (`brew`)
- **mise** - Universal runtime/tool version manager (Node, Python, Go, Java, Terraform, etc.)
- **pip3** - Python packages

### Development Tools
- **git** - Version control
- **gh** - GitHub CLI
- **nvim** - Neovim (LazyVim distribution)
- **tmux** - Terminal multiplexer
- **docker** - Docker Desktop

### Language Runtimes
- **Node.js** - v24.13.0 LTS (managed via mise)
- **Python** - 3.13.12 (managed via mise) + System Python 3.9.6
- **Go** - Go 1.25.7 (managed via mise)
- **Java** - Corretto 21.0.10 (managed via mise)

### Cloud & Infrastructure
- **awscli** - AWS CLI v2
- **terraform** - Infrastructure as Code (v1.5.7)
- **kubectl** - Kubernetes CLI
- **git-remote-codecommit** - AWS CodeCommit helper

### Modern CLI Tools
- **bat** - Better cat (aliased to `cat`)
- **eza** - Better ls (aliased to `ls`, `ll`, `la`)
- **fd** - Better find
- **fzf** - Fuzzy finder
- **ripgrep** - Better grep
- **zoxide** - Smart cd (aliased to `cd`)
- **yazi** - File manager (alias `y`)
- **btop** - System monitor (alias `top`)
- **delta** - Git diff viewer
- **jq** - JSON processor
- **htop** - Process viewer

### Shell Configuration
- **Shell**: zsh with Starship prompt
- **Theme**: Everforest (terminal, vim, tmux, all tools)
- **Aliases**: See `~/.zshrc` for full list

Common aliases:
- `g` = git
- `v` / `vim` = nvim
- `y` = yazi
- `t` = tmux
- `..`, `...`, `....` = directory navigation
- Git shortcuts: `gs`, `ga`, `gc`, `gp`, `gl`, `gd`, `gco`, `gb`, `glog`

## Workflow Guidelines

- Explore and understand existing code before making changes
- Plan approach before implementing complex features
- Test changes before committing
- Write clear, descriptive commit messages

## Communication Preferences

- Be concise and direct
- Ask clarifying questions when requirements are ambiguous
- Provide options when multiple valid approaches exist
- Show research before proposing solutions
