# tmux

`tmux` is a terminal multiplexer: it keeps shell sessions running, divides a terminal into panes, and lets an operator reconnect after an interrupted remote connection. This is useful for long-running captures, log searches, and other command-line work that should survive a dropped session.

## Session workflow

```bash
tmux new -s investigation
tmux ls
tmux attach -t investigation
tmux detach-client -s investigation
```

Inside a session, the default command prefix is `Ctrl-b`. Follow it with `c` to create a window, `%` to split vertically, `"` to split horizontally, an arrow key to change panes, or `d` to detach. Use `tmux rename-session -t investigation case-2026-001` to give a session a durable, recognizable name.

## Operational notes

- Name sessions by case or task rather than leaving anonymous numbered sessions.
- Keep collection commands and interpretation work in separate panes.
- Capture important output to a file; scrollback is convenient but is not an evidence record.
- Close sessions that contain sensitive output when the work is complete.
