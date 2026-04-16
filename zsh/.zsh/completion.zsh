# Initialize completion with daily regeneration
autoload -Uz compinit
[[ -d "${HOME}/.zsh/cache" ]] || mkdir -p "${HOME}/.zsh/cache"
if [[ -n ${HOME}/.zcompdump(#qN.mh+24) ]]; then
  compinit -d "${HOME}/.zcompdump"
else
  compinit -C -d "${HOME}/.zcompdump"
fi

# Load menu-select keybindings
zmodload zsh/complist

# ── Matching strategy ────────────────────────────────────────
# 1) Case-insensitive  2) Partial-word on . _ -  3) Substring
zstyle ':completion:*' matcher-list \
  'm:{a-zA-Z}={A-Za-z}' \
  'r:|[._-]=* r:|=*' \
  'l:|=* r:|=*'

# ── Engine ───────────────────────────────────────────────────
zstyle ':completion:*' completer _extensions _complete _approximate
zstyle ':completion:*:approximate:*' max-errors 1 numeric

# ── Caching ──────────────────────────────────────────────────
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "${HOME}/.zsh/cache"

# ── Menu selection ───────────────────────────────────────────
zstyle ':completion:*' menu select
bindkey -M menuselect '^[[Z' reverse-menu-complete   # Shift+Tab backward

# ── Grouping and formatting ──────────────────────────────────
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'
zstyle ':completion:*:corrections'  format '%F{green}-- %d (errors: %e) --%f'
zstyle ':completion:*:messages'     format '%F{magenta}-- %d --%f'
zstyle ':completion:*:warnings'     format '%F{red}-- no matches --%f'

# ── Colors (match ls) ───────────────────────────────────────
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# ── Directory handling ───────────────────────────────────────
zstyle ':completion:*' list-dirs-first true
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*' special-dirs true

# ── Process completion ───────────────────────────────────────
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=34=31'
zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w"

# ── SSH hosts ────────────────────────────────────────────────
zstyle -e ':completion:*:*:ssh:*:hosts' hosts \
  'reply=(${${(f)"$(cat ~/.ssh/known_hosts 2>/dev/null)"}%%[, ]*})'

# ── Tool-specific completions ────────────────────────────────
(( $+commands[kubectl] )) && source <(kubectl completion zsh) 2>/dev/null

zstyle ':completion:*:*:docker:*'   option-stacking yes
zstyle ':completion:*:*:docker-*:*' option-stacking yes
