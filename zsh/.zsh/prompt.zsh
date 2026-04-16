zmodload zsh/datetime
autoload -Uz add-zsh-hook

# ── Command timer ────────────────────────────────────────────
_prompt_cmd_start=0

_prompt_preexec() {
  _prompt_cmd_start=$EPOCHREALTIME
}

# ── Git status ───────────────────────────────────────────────
_prompt_git_info() {
  local git_output
  git_output=$(command git status --porcelain=v2 --branch 2>/dev/null) || return
  [[ -z "$git_output" ]] && return

  local branch="" ahead=0 behind=0 staged=0 unstaged=0 untracked=0

  local line
  while IFS= read -r line; do
    case "$line" in
      '# branch.head '*)
        branch="${line#\# branch.head }"
        ;;
      '# branch.ab '*)
        local ab="${line#\# branch.ab }"
        ahead="${${ab%% *}#+}"
        behind="${${ab##* }#-}"
        ;;
      1\ * | 2\ *)
        [[ "${line[3]}" != "." ]] && ((staged++))
        [[ "${line[4]}" != "." ]] && ((unstaged++))
        ;;
      u\ *)
        ((unstaged++))
        ;;
      '? '*)
        ((untracked++))
        ;;
    esac
  done <<< "$git_output"

  # Detached HEAD — show short hash
  [[ "$branch" == "(detached)" ]] && \
    branch=$(command git rev-parse --short HEAD 2>/dev/null)

  # Escape % in branch names (safety)
  branch="${branch//\%/%%}"

  local info="%F{yellow}${branch}%f"
  (( unstaged ))  && info+=" %F{red}*${unstaged}%f"
  (( staged ))    && info+=" %F{green}+${staged}%f"
  (( untracked )) && info+=" %F{243}?${untracked}%f"
  (( ahead ))     && info+=" %F{cyan}↑${ahead}%f"
  (( behind ))    && info+=" %F{cyan}↓${behind}%f"

  print -n "  ${info}"
}

# ── Terminal title ───────────────────────────────────────────
_prompt_set_title() {
  print -Pn "\e]2;%~\a"
}

# ── Assemble prompt ──────────────────────────────────────────
_prompt_precmd() {
  local exit_code=$?

  # Timer
  local duration=""
  if (( _prompt_cmd_start > 0 )); then
    local elapsed=$(( EPOCHREALTIME - _prompt_cmd_start ))
    _prompt_cmd_start=0
    if (( elapsed >= 3 )); then
      local secs=${elapsed%.*}
      if (( secs >= 3600 )); then
        duration="%F{243}$(( secs / 3600 ))h $(( (secs % 3600) / 60 ))m%f"
      elif (( secs >= 60 )); then
        duration="%F{243}$(( secs / 60 ))m $(( secs % 60 ))s%f"
      else
        duration="%F{243}${secs}s%f"
      fi
    fi
  fi

  # Git
  local git_info=$(_prompt_git_info)

  # Prompt character
  local prompt_char="%F{green}❯%f"
  (( exit_code != 0 )) && prompt_char="%F{red}❯%f"

  # Line 1: path + git info
  # Line 2: prompt char
  PROMPT="%B%F{blue}%~%f%b${git_info}
${prompt_char} "

  # Right side: command duration
  RPROMPT="${duration}"

  # Terminal title
  _prompt_set_title
}

add-zsh-hook preexec _prompt_preexec
add-zsh-hook precmd _prompt_precmd
