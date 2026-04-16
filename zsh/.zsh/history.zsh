HISTSIZE=100000
SAVEHIST=100000
HISTFILE=~/.zsh_history

setopt HIST_IGNORE_DUPS        # Skip consecutive duplicates
setopt HIST_IGNORE_ALL_DUPS    # Remove older duplicate from history
setopt HIST_IGNORE_SPACE       # Skip commands starting with space
setopt HIST_REDUCE_BLANKS      # Remove extra whitespace
setopt HIST_VERIFY             # Show expanded history before executing
setopt HIST_FIND_NO_DUPS       # Skip duplicates when searching
setopt APPEND_HISTORY          # Append instead of overwrite
setopt SHARE_HISTORY           # Share history between sessions
