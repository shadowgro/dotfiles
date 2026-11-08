# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

fzf_shortcut_opts="
  --layout=reverse \
  --border=bold \
  --border=rounded \
  --margin=3% \
  --preview ''
"

export FZF_DEFAULT_OPTS="
  --layout=reverse \
  --style minimal \
  --preview 'bat --color=always {} -p' \
  --bind 'focus:transform-header:file --brief {}' \
  --multi
"

export FZF_CTRL_T_OPTS="$fzf_shortcut_opts"
export FZF_CTRL_R_OPTS="$fzf_shortcut_opts"
export FZF_ALT_C_OPTS="$fzf_shortcut_opts"

# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)
