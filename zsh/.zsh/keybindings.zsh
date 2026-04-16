# Emacs keymap as base
bindkey -e

# ── Navigation ───────────────────────────────────────────────
bindkey '^[[H'    beginning-of-line      # Home
bindkey '^[[F'    end-of-line            # End
bindkey '^[[3~'   delete-char            # Delete
bindkey '^[[1;5D' backward-word          # Ctrl+Left
bindkey '^[[1;5C' forward-word           # Ctrl+Right
bindkey '^[[1;3D' backward-word          # Alt+Left
bindkey '^[[1;3C' forward-word           # Alt+Right
bindkey '^H'      backward-kill-word     # Ctrl+Backspace — delete word left

# ── History: prefix search ───────────────────────────────────
# Type "git" then press Up — only shows history starting with "git"
# Empty line + Up/Down — normal history navigation
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^[[A' up-line-or-beginning-search     # Up
bindkey '^[[B' down-line-or-beginning-search   # Down

# ── Edit command in $EDITOR ──────────────────────────────────
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^X^E' edit-command-line         # Ctrl+X Ctrl+E

# ── Ctrl+Z toggle ───────────────────────────────────────────
# Empty line → resume background job (fg)
# Text in line → push text aside, clear screen
_toggle_ctrl_z() {
  if [[ $#BUFFER -eq 0 ]]; then
    BUFFER="fg"
    zle accept-line
  else
    zle push-input
    zle clear-screen
  fi
}
zle -N _toggle_ctrl_z
bindkey '^Z' _toggle_ctrl_z
