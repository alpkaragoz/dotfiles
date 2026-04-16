# ── mkdir + cd ───────────────────────────────────────────────
mkcd() { mkdir -p "$1" && cd "$1"; }

# ── Universal archive extractor ──────────────────────────────
extract() {
  if [[ -z "$1" ]]; then
    echo "Usage: extract <archive>"
    return 1
  fi
  if [[ ! -f "$1" ]]; then
    echo "extract: '$1' is not a file"
    return 1
  fi
  case "$1" in
    *.tar.bz2) tar xjf "$1" ;;
    *.tar.gz)  tar xzf "$1" ;;
    *.tar.xz)  tar xJf "$1" ;;
    *.tar.zst) tar --zstd -xf "$1" ;;
    *.bz2)     bunzip2 "$1" ;;
    *.rar)     unrar x "$1" ;;
    *.gz)      gunzip "$1" ;;
    *.tar)     tar xf "$1" ;;
    *.tbz2)    tar xjf "$1" ;;
    *.tgz)     tar xzf "$1" ;;
    *.zip)     unzip "$1" ;;
    *.Z)       uncompress "$1" ;;
    *.7z)      7z x "$1" ;;
    *)         echo "extract: unknown format — '$1'" ;;
  esac
}

# ── Show listening ports ─────────────────────────────────────
ports() {
  if [[ -n "$1" ]]; then
    ss -tlnp 2>/dev/null | head -1
    ss -tlnp 2>/dev/null | grep ":$1 "
  else
    ss -tlnp
  fi
}

# ── Tree with sane defaults ─────────────────────────────────
tre() {
  tree -C -L "${1:-3}" --dirsfirst \
    -I "node_modules|target|.git|.idea|build|dist" 2>/dev/null || {
    echo "Install tree: sudo apt install tree"
  }
}

# ── Quick HTTP server ────────────────────────────────────────
serve() {
  local port="${1:-8080}"
  echo "Serving on http://localhost:${port}"
  python3 -m http.server "$port" 2>/dev/null || npx serve -p "$port"
}

# ── Docker cheat sheet ───────────────────────────────────────
docker-help() {
cat << 'EOF'
=== DOCKER CHEAT SHEET ===

-- Daemon --
  sudo systemctl start docker       Start Docker
  sudo systemctl stop docker        Stop Docker
  sudo systemctl status docker      Check status

-- Containers --
  docker ps                         List running containers
  docker ps -a                      List all containers
  docker run -d --name NAME IMAGE   Run a container
  docker stop NAME                  Stop a container
  docker start NAME                 Start a container
  docker rm NAME                    Remove a container
  docker logs NAME                  View logs

-- Images --
  docker images                     List images
  docker pull IMAGE                 Pull an image
  docker image rm IMAGE             Remove an image

-- Compose --
  docker compose up -d              Start services
  docker compose down               Stop services
  docker compose logs -f            View logs

-- Cleanup --
  docker system prune               Remove unused stuff
  docker system prune -a            Remove everything unused
EOF
}

# ── DDYS Kubernetes port-forward (colored) ───────────────────
kpf() {
  local g='\033[0;32m' r='\033[0;31m' y='\033[0;33m' n='\033[0m'
  case "$1" in
    start)
      echo -e "${y}Starting port-forwards...${n}"
      kubectl port-forward -n infrastructure svc/postgresql 5432:5432 &>/dev/null &
      echo -e "  ${g}PostgreSQL${n} (5432) PID: $!"
      kubectl port-forward -n infrastructure svc/mongodb 27017:27017 &>/dev/null &
      echo -e "  ${g}MongoDB${n}    (27017) PID: $!"
      echo -e "${g}Done.${n} Use 'kpf stop' to kill all."
      ;;
    stop)
      echo -e "${y}Stopping port-forwards...${n}"
      pkill -f "port-forward.*svc/postgresql" 2>/dev/null \
        && echo -e "  ${g}PostgreSQL stopped.${n}" \
        || echo -e "  ${r}PostgreSQL was not running.${n}"
      pkill -f "port-forward.*svc/mongodb" 2>/dev/null \
        && echo -e "  ${g}MongoDB stopped.${n}" \
        || echo -e "  ${r}MongoDB was not running.${n}"
      ;;
    status)
      echo -e "${y}Active port-forwards:${n}"
      pgrep -af "kubectl port-forward" || echo -e "  ${r}None running.${n}"
      ;;
    *)
      echo "Usage: kpf {start|stop|status}"
      ;;
  esac
}

# ── Quick project jump with tab completion ───────────────────
proj() {
  local base="${HOME}/projects"
  if [[ -z "$1" ]]; then
    ls "$base" 2>/dev/null || echo "No projects directory at ${base}"
    return
  fi
  local target="${base}/$1"
  if [[ -d "$target" ]]; then
    cd "$target"
  else
    echo "proj: '$1' not found in ${base}"
    return 1
  fi
}
_proj() {
  local base="${HOME}/projects"
  [[ -d "$base" ]] || return
  _files -W "$base" -/
}
compdef _proj proj
