---
description: How to onboard an AI developer agent to BondConnect
---

# BondConnect: AI Agent Handover Guide

This guide provides a standardized starting point for assigning work to an AI agent (like Cursor, Windsurf, or a fresh task-based assistant).

## Recommended Starting Prompt
Copy and paste this prompt when starting a new session with an AI agent:

```text
I am building BondConnect, an Expo/Firebase app. 
1. START by reading `.agent/agent-rules.md` for project standards.
2. Run `./scripts/check-env.sh` to verify your environment.
3. Review `docs/technical/README.md` to understand the project structure.
4. Check the `implementation-roadmap.md` for the current priority.
5. Your first objective is to implement BOND-01 (specs located in `docs/technical/implementation/specs/`). 
Do not start coding until you've verified the environment and summarized your plan for BOND-01.
```

## Why this sequence?
1. **Context First**: Agents often jump into code without reading requirements. Forcing them to read `agent-rules.md` ensures they follow your design patterns.
2. **Environment Validation**: If the Firebase CLI isn't logged in or the Emulator isn't running, the agent will waste time on cryptic errors. `check-env.sh` catches this immediately.
3. **Phased Implementation**: The Roadmap prevents the agent from trying to build the UI (BOND-04) before the backend logic (BOND-03) exists.

## Handover Checklist
- [ ] Ensure `.agent/agent-rules.md` is present.
- [ ] Ensure `scripts/check-env.sh` is executable.
- [ ] Share the `bondconnect-dev` Firebase project ID with the agent.
- [ ] Verify the agent has access to the `docs/technical/` directory.
