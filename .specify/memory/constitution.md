<!--
SYNC IMPACT REPORT
==================
Version Change: none → 1.0.0
Rationale: Initial constitution ratification

Modified Principles: N/A (initial creation)
Added Sections:
  - All core principles (1-12)
  - Governance framework
  - Compliance expectations

Removed Sections: N/A

Templates Requiring Updates:
  ⚠ .specify/templates/plan-template.md (pending creation)
  ⚠ .specify/templates/spec-template.md (pending creation)
  ⚠ .specify/templates/tasks-template.md (pending creation)

Follow-up TODOs: Create supporting template files to align with constitution
-->

# Clopy Project Constitution

**Version:** 1.0.0  
**Ratified:** 2025-10-26  
**Last Amended:** 2025-10-26

---

## Preamble

This constitution establishes the foundational principles governing the development, maintenance, and evolution of Clopy—a native macOS clipboard management application. These principles are non-negotiable constraints that guide all technical and product decisions.

---

## Core Principles

### Principle 1: Native Platform Integration

**Declaration:** Clopy is a native macOS application written in Swift, leveraging SwiftUI and AppKit to deliver a seamless clipboard management experience that integrates naturally with the macOS ecosystem.

**Rationale:** Users expect clipboard utilities to feel indistinguishable from system functionality. Non-native implementations introduce latency, visual inconsistency, and behavior mismatches that erode trust and usability.

**Requirements:**
- MUST use Swift as primary language
- MUST leverage SwiftUI for modern UI components
- MUST use AppKit where SwiftUI capabilities are insufficient
- MUST follow Apple Human Interface Guidelines
- MUST respect system appearance (light/dark mode, accessibility settings)

---

### Principle 2: Minimalism and Essentialism

**Declaration:** Build only what is essential, nothing more.

**Rationale:** Feature bloat degrades performance, increases maintenance burden, and obscures core functionality. Clipboard management is utility software—clarity and reliability trump comprehensiveness.

**Requirements:**
- MUST justify every feature against core workflow support
- MUST remove features that become redundant or conflict with core principles
- MUST NOT implement features speculatively
- SHOULD prefer configuration through conventions over settings UI

---

### Principle 3: Privacy by Design

**Declaration:** User data never leaves the device or persists after quit. Clipboard data is sensitive and temporary.

**Rationale:** Clipboard contents frequently include passwords, personal information, and confidential data. Network transmission or persistent storage introduces unacceptable privacy risks.

**Requirements:**
- MUST store clipboard data only in memory
- MUST clear all data on application quit
- MUST NOT transmit clipboard data over network
- MUST NOT use cloud sync or remote storage
- MUST NOT log clipboard content (even in debug builds)
- MUST request only necessary permissions with clear justification

---

### Principle 4: Platform Conformance

**Declaration:** Embrace platform conventions and design patterns. Users expect native behavior and appearance.

**Rationale:** Platform divergence creates cognitive friction and reduces discoverability. Users rely on learned patterns from system and other native apps.

**Requirements:**
- MUST follow standard macOS UI patterns (menus, keyboard shortcuts, gestures)
- MUST use system-provided UI components where available
- MUST respect user accessibility preferences
- MUST integrate with macOS services and automation frameworks where appropriate

---

### Principle 5: Specification-Driven Development

**Declaration:** Code follows the specification document. Clear requirements prevent scope creep and maintain focus.

**Rationale:** Small projects suffer from informal planning that leads to drift, incomplete features, and inconsistent behavior. Written specifications serve as contract and documentation.

**Requirements:**
- MUST maintain current specification document describing all features
- MUST NOT implement features without specification entry
- MUST update specification before implementing changes
- MUST reconcile code and specification during reviews

---

### Principle 6: API Stability and Compatibility

**Declaration:** Use only documented, public platform APIs. Ensures broad distribution eligibility and long-term compatibility.

**Rationale:** Private APIs create App Store rejection risk, brittle dependencies on undocumented behavior, and compatibility breaks across OS updates.

**Requirements:**
- MUST use only public Apple frameworks and APIs
- MUST NOT use private APIs, runtime injection, or method swizzling
- MUST verify API availability for minimum supported OS version
- SHOULD monitor deprecation notices and plan migrations proactively

---

### Principle 7: Graceful Degradation

**Declaration:** Core functionality works even when optional features fail. Users should always have a working app.

**Rationale:** Partial failures should not cascade into complete application failure. Clipboard management is background utility—it must be reliable above all else.

**Requirements:**
- MUST isolate optional features from core clipboard operations
- MUST handle permission denials gracefully
- MUST continue operating when non-critical services fail
- MUST provide clear feedback when features are unavailable

---

### Principle 8: Silent Reliability

**Declaration:** Errors are logged but don't disrupt user workflow. Clipboard management is background functionality.

**Rationale:** Alert fatigue and modal dialogs break concentration. Users expect clipboard tools to work silently unless intervention is required.

**Requirements:**
- MUST log errors with structured, categorized logging
- MUST NOT show error dialogs for recoverable failures
- MUST degrade gracefully without user interruption
- MAY show unobtrusive notifications for actionable errors only

---

### Principle 9: Performance and Responsiveness

**Declaration:** All interactions feel immediate. Clipboard operations are frequent and interrupting.

**Rationale:** Perceived latency in clipboard operations disrupts user flow. Users paste dozens or hundreds of times daily—any delay is multiplied across usage.

**Requirements:**
- MUST complete clipboard capture in <50ms
- MUST render UI updates in <16ms (60fps)
- MUST keep memory footprint minimal (clipboard data is transient)
- MUST NOT block main thread for I/O or computation
- SHOULD profile hot paths and optimize critical sections

---

### Principle 10: Predictability and Transparency

**Declaration:** Users always know what will happen. Surprising behavior breaks trust.

**Rationale:** Clipboard managers modify fundamental system behavior. Unpredictable actions (auto-paste, format changes, unexpected filtering) erode confidence.

**Requirements:**
- MUST make clipboard modifications explicit and obvious
- MUST NOT auto-paste or auto-modify clipboard without clear user action
- MUST show clear UI state (active clip, history position, mode)
- MUST preserve clipboard format fidelity unless explicitly transformed

---

### Principle 11: Keyboard-First Interaction

**Declaration:** All actions accessible via keyboard. Power users prefer keyboard efficiency.

**Rationale:** Clipboard workflows are high-frequency, low-duration interactions. Mouse requirement destroys flow state for keyboard-centric users.

**Requirements:**
- MUST provide keyboard shortcuts for all primary actions
- MUST support keyboard navigation in all UI components
- MUST follow macOS keyboard shortcut conventions
- SHOULD allow customization of non-standard shortcuts
- MUST document all keyboard shortcuts in help/documentation

---

### Principle 12: Visual Clarity and Scanability

**Declaration:** UI communicates state clearly without clutter. Users need to scan clips quickly.

**Rationale:** Clipboard history review is a scanning task—users locate target clip by visual cues. Dense layouts or ambiguous presentation slow selection.

**Requirements:**
- MUST show clip preview with sufficient context (text preview, image thumbnail, type indicator)
- MUST differentiate clip types visually (text, image, file, rich content)
- MUST highlight current selection clearly
- MUST use whitespace and typography to aid scanning
- MUST NOT include decorative or non-functional UI elements

---

## Development Practices

### Code Quality Standards

**Single Responsibility Principle:** Each class has a single, well-defined responsibility. Maintainable, testable, and understandable code.

**Reactive Architecture:** UI reacts to state changes automatically through SwiftUI bindings and Combine publishers.

**Code Clarity:** Code behavior is obvious from reading it. Prefer explicit over clever. Comments explain why, not what.

**Testing Strategy:** Manual testing is sufficient for this scope. Small codebase, single developer, specification-driven development reduces automated test ROI.

---

### Feature Lifecycle

**Addition Criteria:** A feature may be added only if:
1. It directly supports the core clipboard workflow
2. Implementation is minimal and bounded in complexity
3. It is specified in the specification document with clear requirements
4. Implementation uses only public platform APIs
5. It does not compromise privacy, performance, or reliability principles

**Removal Criteria:** A feature should be removed when:
1. It becomes redundant with platform or other features
2. It conflicts with core principles or user expectations
3. It cannot be maintained or fixed within reasonable constraints
4. Usage data (if collected) shows negligible adoption

**Change Management:** Breaking changes require:
1. Major version bump (semantic versioning)
2. Update to specification document
3. Documented migration path
4. User-facing changelog in release notes

---

### Documentation Requirements

**Release Documentation:** All releases include:
- Installation instructions
- Current specification document
- Version history with notable changes
- License and attribution

**Code Documentation:**
- Public APIs documented with Swift DocC comments
- Complex algorithms explained with inline rationale
- Architecture decisions recorded in specification

---

## Security and Privacy

### Permission Model

**Minimal Permissions:** Request only necessary permissions with clear justification. Minimize security surface and respect user privacy.

**Just-In-Time Requests:** Request permissions only when needed, with clear explanation of purpose.

**Graceful Degradation:** Continue operating with reduced functionality when permissions denied.

### Data Protection

**Minimize Collection:** Minimize data collection, storage, and transmission. User data is sensitive and should be protected.

**No External Dependencies:** Avoid external dependencies beyond platform frameworks. Third-party code introduces supply chain risk.

**Build Integrity:** Sign and verify all distributed builds to ensure authenticity and integrity.

---

## Error Handling and Observability

### Logging Standards

**Structured Logging:** Use structured logging with consistent categorization. Enables effective debugging and monitoring.

**Log Levels:** Log levels indicate severity (debug, info, warning, error, critical).

**Contextual Information:** Log meaningful context (operation, state, environment) while respecting privacy (never log clipboard content).

**Balance:** Balance debugging needs with user privacy. Logs may contain sensitive metadata.

### User-Facing Error Handling

**Minimize Dialogs:** Minimize error dialogs. Errors should inform, not obstruct.

**Actionable Guidance:** When errors require user action, provide clear next steps.

**Silent Logging:** Log all errors for debugging but only surface critical, actionable issues.

---

## Platform Version Support

### Version Policy

**Modern Platform Support:** Support modern platform versions that enable core features. Balance innovation with user accessibility.

**Support Window:** Support recent platform versions within reasonable maintenance window (typically current + 2 previous major versions).

**Proactive Monitoring:** Monitor and adopt platform evolution proactively. Prevent technical debt and deprecation issues.

**Deprecation Strategy:** When dropping platform versions, provide advance notice and migration guidance.

---

## Governance

### Amendment Process

1. Proposed amendments must identify:
   - Principle(s) affected
   - Rationale for change
   - Impact on existing code and features
   - Version bump type (major/minor/patch)

2. Amendments require:
   - Updated specification alignment
   - Review of dependent templates and documentation
   - Sync impact report documenting cascade changes

3. Version semantics:
   - **MAJOR:** Backward incompatible governance/principle removals or redefinitions
   - **MINOR:** New principle/section added or materially expanded guidance
   - **PATCH:** Clarifications, wording, typo fixes, non-semantic refinements

### Compliance Review

- Constitution compliance reviewed during specification updates
- Breaking changes flagged during code review
- Quarterly review of principles against actual practice
- User feedback monitored for principle violations

### Conflict Resolution

When principles conflict in specific scenarios:
1. Privacy and security trump features and convenience
2. Reliability and performance trump completeness
3. User expectations trump implementation convenience
4. Specification clarity required before implementation proceeds

---

## Versioning

This constitution follows semantic versioning:
- **Current Version:** 1.0.0
- **Ratified:** 2025-10-26
- **Last Amended:** 2025-10-26

---

*This constitution serves as the foundational contract for Clopy development. All code, features, and decisions must align with these principles. When in doubt, return to first principles.*
