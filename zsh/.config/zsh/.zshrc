# =========================
# === 🌐 Environment ===
# =========================

export ZDOTDIR="$HOME/.config/zsh"
export DOTFILES="$HOME/dev/dotfiles"
export EDITOR="vim"
export VISUAL="vim"
export HISTFILE="$HOME/.cache/zsh/history"
export HISTSIZE=10000
export SAVEHIST=10000
typeset -gU path PATH
path=("$HOME/.local/bin" $path)

# ============================
# === ⏱️ Startup Timing ===
# ============================

date_cmd="date"
[[ "$OSTYPE" == "darwin"* ]] && date_cmd="gdate"
start_time=$($date_cmd +%s%3N)

# ===============================
# === 🧠 Optional Compilation ===
# ===============================

zsh_compile_if_needed() {
  local src="$1"
  local zwc="${src}.zwc"

  if [[ ! -f $zwc || $src -nt $zwc ]]; then
    echo "Compiling $src..."
    zcompile "$src" "$zwc"
  fi

  [[ -f $zwc ]] && source "$zwc"
}

# =========================
# === ✨ Prompt & Colors ===
# =========================

eval "$(starship init zsh)"

# =====================
# === 📝 History ===
# =====================

setopt EXTENDED_HISTORY HIST_EXPIRE_DUPS_FIRST HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS HIST_FIND_NO_DUPS HIST_IGNORE_SPACE
setopt HIST_SAVE_NO_DUPS HIST_VERIFY

# =========================
# === 🧠 Completion ===
# =========================

zmodload zsh/complist
[[ -d "$ZDOTDIR/completions" ]] && fpath+=("$ZDOTDIR/completions")
fpath=($ZDOTDIR/plugins/zsh-completions/src $fpath)

if command -v brew >/dev/null; then
  FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
fi

# Relocate zcompdump
ZSH_COMPDUMP="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/.zcompdump"

autoload -Uz compinit && compinit -d "$ZSH_COMPDUMP"
_comp_options+=(globdots)

zstyle ':completion:*' menu select
zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/completion"
zstyle ':completion:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' list-colors ''
zstyle ':completion:*:descriptions' format '%U%B%d%b%u'
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'

setopt correct

# =============================
# === ⌨️ Keybindings & Modes ===
# =============================

export KEYTIMEOUT=1
bindkey -v
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -v '^?' backward-delete-char
bindkey "^[^[[C" forward-word
bindkey "^[^[[D" backward-word

cursor_mode() {
  cursor_block='\e[2 q'
  cursor_beam='\e[6 q'

  function zle-keymap-select {
    case $KEYMAP in
      vicmd) echo -ne "$cursor_block" ;;
      viins|main|"") echo -ne "$cursor_beam" ;;
    esac
  }

  zle-line-init() { echo -ne "$cursor_beam" }
  zle -N zle-keymap-select
  zle -N zle-line-init
}
cursor_mode

# =======================
# === 🧩 Plugins ===
# =======================

# zsh-syntax-highlighting
if [[ -f "$ZDOTDIR/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
  source "$ZDOTDIR/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

# zsh-autosuggestions
if [[ -f "$ZDOTDIR/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
  source "$ZDOTDIR/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi

# Atuin
if command -v atuin &>/dev/null; then
  eval "$(atuin init zsh --disable-up-arrow)"
fi

# Zoxide (better `cd`)
if command -v zoxide &>/dev/null; then
  eval "$(zoxide init zsh)"
  alias cd="z"
fi

# FZF
[[ -f "$ZDOTDIR/fzf" ]] && source "$ZDOTDIR/fzf"

# =======================
# === 🧪 Local Hooks ===
# =======================

[[ -f "$ZDOTDIR/aliases" ]] && source "$ZDOTDIR/aliases"
[[ -f "$ZDOTDIR/envs" ]] && source "$ZDOTDIR/envs"
[[ -f "$ZDOTDIR/functions" ]] && source "$ZDOTDIR/functions"
[[ -f "$ZDOTDIR/osx" ]] && [[ "$(uname -s)" == "Darwin" ]] && source "$ZDOTDIR/osx"
[[ -f "$ZDOTDIR/local" ]] && source "$ZDOTDIR/local"

# ===========================
# === ⏱️ Show Elapsed Time ===
# ===========================

end_time=$($date_cmd +%s%3N)
duration=$((end_time - start_time))

if (( duration > 300 )); then
  echo "⏱️  .zshrc sourced in ${duration}ms"
fi
