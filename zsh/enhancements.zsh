# =============================================================================
# Zsh Enhancements — portable, symlinked from ~/dotfiles
#
# Source this file from your ~/.zshrc:
#   source ~/.zsh-enhancements
#
# This file should be sourced first
# so the Powerlevel10k instant prompt stays at the top of shell init.
# =============================================================================

# Enable Powerlevel10k instant prompt. Must run before any console output.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# --- Plugin Manager (Zinit) --------------------------------------------------
# Self-bootstraps: clones itself if missing, then auto-clones plugins on first run.
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
source "${ZINIT_HOME}/zinit.zsh"

# --- Plugins ------------------------------------------------------------------
zinit ice depth=1; zinit light romkatv/powerlevel10k
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# --- Completions --------------------------------------------------------------
autoload -Uz compinit && compinit
zinit cdreplay -q

# --- Powerlevel10k prompt config ----------------------------------------------
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# --- Keybindings --------------------------------------------------------------
bindkey -e
bindkey "^[[A" history-search-backward
bindkey "^[[B" history-search-forward

# --- History ------------------------------------------------------------------
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# --- Completion styling -------------------------------------------------------
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:*' fzf-preview ''
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza --tree --level=2 --color=always $realpath'
zstyle ':fzf-tab:complete:ls:*' fzf-preview 'if [ -d $realpath ]; then eza -1 --color=always $realpath; else bat --color=always --line-range=:200 $realpath; fi'

# --- Aliases ------------------------------------------------------------------
alias ls='ls --color'

# --- Shell integrations -------------------------------------------------------
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"
