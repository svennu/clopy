# GitHub Spec-Kit Commands

This project uses **[GitHub Spec-Kit](https://github.com/github/spec-kit)** for specification-driven development. Here are the available slash commands:

## 🔍 Discovery & Planning Phase

### `/clarify`
**Purpose**: Identify underspecified areas in the feature spec by asking targeted clarification questions.

**What it does**:
- Scans the current spec for ambiguities and missing decision points
- Asks up to 5 highly targeted questions
- Encodes answers back into the spec file
- **Must run BEFORE `/plan`** to reduce downstream rework risk

**Use when**: You have a draft spec but need to resolve ambiguities before planning implementation.

---

### `/specify <feature description>`
**Purpose**: Create or update the feature specification from natural language.

**What it does**:
- Takes your feature description and generates a structured spec
- Creates a concise branch name (2-4 words, action-noun format)
- Generates complete specification using the spec template
- Preserves technical terms and acronyms

**Example**: `/specify Add OAuth2 integration for the API` → creates "oauth2-api-integration" branch with full spec

---

## 📋 Design & Architecture Phase

### `/plan`
**Purpose**: Execute implementation planning workflow to generate design artifacts.

**What it does**:
- Loads the feature spec and constitution
- Generates technical design documents:
  - `research.md` - Technical decisions and unknowns
  - `data-model.md` - Entity definitions
  - `contracts/` - API endpoint definitions
  - `quickstart.md` - Test scenarios
- Evaluates constitution compliance gates
- Updates agent context

**Runs after**: `/clarify` completes

---

### `/tasks`
**Purpose**: Generate actionable, dependency-ordered task list for implementation.

**What it does**:
- Reads all design documents (plan.md, spec.md, data-model.md, contracts/, etc.)
- Extracts user stories with priorities (P1, P2, P3)
- Generates tasks organized by user story
- Creates dependency graph showing completion order
- Provides parallel execution examples

**Runs after**: `/plan` completes

---

## ✅ Validation Phase

### `/checklist [custom requirements]`
**Purpose**: Generate custom checklists to validate requirements quality ("unit tests for English").

**Critical Concept**: Checklists validate the **quality of requirements**, not implementation.

**What it checks**:
- ✅ Completeness: "Are visual hierarchy requirements defined for all card types?"
- ✅ Clarity: "Is 'prominent display' quantified with specific sizing?"
- ✅ Consistency: "Are hover states consistent across all elements?"
- ✅ Coverage: "Are accessibility requirements defined?"
- ✅ Edge cases: "What happens when image fails to load?"

**NOT for**: Testing if code works (that's QA/testing)

---

### `/analyze`
**Purpose**: Perform cross-artifact consistency and quality analysis.

**What it does**:
- Analyzes `spec.md`, `plan.md`, and `tasks.md` for:
  - Inconsistencies between documents
  - Duplications
  - Ambiguities
  - Underspecified items
- **Strictly read-only** - produces analysis report only
- Validates constitution compliance (CRITICAL priority)
- Offers optional remediation plan

**Runs after**: `/tasks` completes

---

## 🚀 Implementation Phase

### `/implement`
**Purpose**: Execute the implementation plan by processing all tasks.

**What it does**:
- Checks checklist completion status
- Processes tasks from `tasks.md` in dependency order
- Validates against constitution gates
- Shows progress table for all checklists
- Executes code changes based on task definitions

**Runs after**: All checklists pass (or explicitly approved to proceed)

---

## 🏛️ Governance

### `/constitution [principles]`
**Purpose**: Create or update the project constitution and sync templates.

**What it does**:
- Updates `.specify/memory/constitution.md`
- Fills template placeholders (PROJECT_NAME, PRINCIPLE_X_NAME, etc.)
- Supports custom number of principles
- Semantic versioning for constitution:
  - **MAJOR**: Backward incompatible changes
  - **MINOR**: New principles added
  - **PATCH**: Clarifications, typo fixes
- Propagates amendments across dependent artifacts

**Use when**: Setting up project governance or updating core principles

---

## 📊 Workflow Summary

```
1. /specify → Create spec from description
2. /clarify → Resolve ambiguities
3. /plan → Generate design artifacts
4. /tasks → Create task list
5. /checklist → Validate requirements quality
6. /analyze → Check cross-artifact consistency
7. /implement → Execute implementation
```

## 📁 Generated Structure

```
.specify/
├── memory/
│   └── constitution.md
├── templates/
│   ├── spec-template.md
│   ├── plan-template.md
│   ├── tasks-template.md
│   └── checklist-template.md
└── scripts/
    └── bash/
        ├── check-prerequisites.sh
        └── setup-plan.sh

features/[feature-name]/
├── spec.md
├── plan.md
├── tasks.md
└── checklists/
    ├── ux.md
    ├── security.md
    └── test.md
```

All commands are designed to work together in a specification-driven development workflow!
