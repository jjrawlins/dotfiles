# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"


# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
# Download Znap, if it's not there yet.
[[ -r ~/Repos/znap/znap.zsh ]] ||
    git clone --depth 1 -- \
        https://github.com/marlonrichert/zsh-snap.git ~/Repos/znap
source ~/Repos/znap/znap.zsh  # Start Znap

### Load Plugins with ZNAP
znap source marlonrichert/zsh-autocomplete

# Configure zsh-autocomplete
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':autocomplete:tab:*' completion select
zstyle ':autocomplete:tab:*' insert-unambiguous yes
zstyle ':autocomplete:*' min-input 1

# Enable menu-select
zmodload zsh/complist

# Keybindings for completion and history navigation
bindkey -M menuselect '^M' .accept-line # Enter to accept the current selection
bindkey -M menuselect '^[[Z' reverse-menu-complete # Shift+Tab to go backwards
bindkey '^I' menu-complete # Tab to cycle forward through options
bindkey '^[[A' up-line-or-history       # Up arrow
bindkey '^[[B' down-line-or-history     # Down arrow
bindkey '^P' up-line-or-search          # Ctrl+P for searching backwards
bindkey '^N' down-line-or-search        # Ctrl+N for searching forwards
bindkey '^R' history-incremental-search-backward  # Ctrl+R for reverse history search
bindkey '^S' history-incremental-search-forward   # Ctrl+S for forward history search

# Function to browse recent history (keep this from the previous update)
browse_recent_history() {
    local lines=${1:-100}
    local selected_command
    selected_command=$(fc -l -n -r -$lines | fzf --tac --no-sort --prompt="Select command: ")
    if [[ -n $selected_command ]]; then
        print -z $selected_command
    fi
}

# Alias for quick access to recent history browser
alias rh='browse_recent_history'

znap source marlonrichert/zsh-edit

#znap source marlonrichert/zsh-hist
#bindkey '^[q' push-line-or-edit
#bindkey -r '^Q' '^[Q'

ZSH_AUTOSUGGEST_STRATEGY=( history )
znap source zsh-users/zsh-autosuggestions

ZSH_HIGHLIGHT_HIGHLIGHTERS=( main brackets )
znap source zsh-users/zsh-syntax-highlighting

### EXPORTS ###
export AWS_PAGER=""

### ALIASES ###
alias pj="npx projen"
alias lg="lazygit"
alias v="nvim"
alias crd='/usr/local/bin/connect-redshift'
alias cpg='/usr/local/bin/connect-postgres'
alias kd='git mergetool'
alias k3='kdiff3'

### LANGUAGES
export GOPATH=$HOME/go
alias go-reshim='asdf reshim golang && export GOROOT="$(asdf where golang)/go/"'

### PATH ####
export PATH=$PATH:/opt/homebrew/bin
export PATH=$PATH:/usr/local/nvim-macos-arm64/bin
export PATH=$PATH:/Users/jjrawlins/.asdf/bin
export PATH=$PATH:/Users/jjrawlins/.asdf/shims
export PATH=$PATH:/Users/jjrawlins/.cargo/bin
export PATH=$PATH:/Applications/love.app/Contents/MacOS
export PATH=$PATH:/opt/homebrew/opt/postgresql@15/bin
export PATH=$PATH:/Applications/kdiff3.app/Contents/MacOS/

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/Users/jjrawlins/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/jjrawlins/.local/share/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/jjrawlins/.local/share/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/jjrawlins/.local/share/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/jjrawlins/.local/share/google-cloud-sdk/completion.zsh.inc'; fi



autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /opt/homebrew/bin/terraform terraform
