---
name: brain
description: Query order and freshness rules for projects with a code graph (graphify MCP, managed by the `brain` CLI). Use when the project's CLAUDE.md says "Second brain: on", or the user asks about architecture, blast radius, or "what does X touch" in such a project.
---

# Code graph (brain)

1. Query the graphify MCP for structure first, then vault notes for decisions, then raw files only when editing.
2. Check the graph age with `brain status`. If it is older than recent structural changes, say so and suggest `brain update <slug>` instead of trusting it.
3. Never write generated or graph output into a repo. Never hand-edit `~/.local/share/brain/`.
