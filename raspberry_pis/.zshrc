# Set PATH for essential binaries
export PATH=$HOME/bin:/usr/local/bin:$PATH

# Add Neovim to PATH
export PATH=$PATH:/home/jmvaldez/neovim/bin

# NVM setup for Node.js
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads bash_completion for nvm

# Aliases
alias vi="nvim"
alias vim="nvim"

# Enable command auto-correction
setopt CORRECT

# Preferred editor
export EDITOR="nvim"

# Prompt (minimal PS1 prompt for simplicity)
PS1='%F{green}%n@%m%f:%~%# '

# History configuration
HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=1000

# Enable syntax highlighting (optional if desired, requires installation)
# source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Enable auto-suggestions (optional if desired, requires installation)
# source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh

