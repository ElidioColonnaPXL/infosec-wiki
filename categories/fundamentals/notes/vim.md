# Vim

Vim is a modal text editor commonly available on Linux and Unix-like systems. It is practical for editing configuration files, scripts, detection rules, and notes over a terminal connection.

## Core modes

- **Normal mode** is used for navigation and commands. Press `Esc` to return to it.
- **Insert mode** enters text. Press `i`, `a`, or `o` from Normal mode.
- **Visual mode** selects text. Press `v` for character selection or `V` for whole lines.
- **Command-line mode** handles saving, quitting, substitution, and settings with `:`.

```vim
:w             " save
:q             " quit
:wq            " save and quit
:q!            " discard unsaved changes
/indicator     " search forward
n              " repeat the search
:%s/old/new/g  " replace throughout the file
```

Before editing an important configuration, preserve a copy and use the relevant program's validation command before reloading the service.
