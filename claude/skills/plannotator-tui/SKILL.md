---
name: plannotator-tui
description: Review this session's recent replies in the terminal Plannotator (a tmux popup over this pane) instead of the browser, then act on the feedback. Use only when the user types /plannotator-tui.
---

# Plannotator in the terminal

1. Run `~/.dotfiles/bin/pn self` with the Bash tool and `run_in_background: true` (the review can take minutes). Say in one line: "Review open in the popup — pick a reply, annotate, press S."
2. When the background command completes, its output is the user's feedback (numbered annotations on quoted parts of your replies). If it says "no feedback", stop.
3. Treat the feedback exactly like a /plannotator-last review: address every annotation, in order, as the user's next message.

Needs tmux (`$TMUX_PANE`) and `plannotator-tui`. Outside tmux, say so and suggest `/plannotator-last` (browser).
