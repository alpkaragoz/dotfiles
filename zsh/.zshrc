# ┌──────────────────────────────────────────────────────────────┐
# │  Modular zsh config — edit files in ~/.zsh/ not this file   │
# └──────────────────────────────────────────────────────────────┘

ZSH_DIR="${HOME}/.zsh"

source "${ZSH_DIR}/options.zsh"
source "${ZSH_DIR}/history.zsh"
source "${ZSH_DIR}/completion.zsh"
source "${ZSH_DIR}/prompt.zsh"
source "${ZSH_DIR}/aliases.zsh"
source "${ZSH_DIR}/functions.zsh"
source "${ZSH_DIR}/keybindings.zsh"
source "${ZSH_DIR}/tools.zsh"

# Machine-specific overrides (not tracked by git)
[[ -f "${ZSH_DIR}/local.zsh" ]] && source "${ZSH_DIR}/local.zsh"
