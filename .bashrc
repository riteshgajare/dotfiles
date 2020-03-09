## This file is sourced by all *interactive* bash shells on startup.  This
## file *should generate no output* or it will break the scp and rcp commands.
############################################################

if [ -e /etc/bashrc ] ; then
  . /etc/bashrc
fi

# export P4ROOT=$(p4 client -o | grep '^Root:' | awk -F ' ' '{print $NF}')
# export P4PORT=p4sw:2006
# export P4USER=rgajare
# export TOOLSDIR=$P4ROOT/sw/tools
# export NV_TOOLS=$P4ROOT/sw/tools
# export VERBOSE=1
# export LD_LIBRARY_PATH=$P4ROOT/sw/gpgpu/bin/x86_64_Linux_release:$LD_LIBRARY_PATH
# export VVS_P4CLIENT=rgajare-dev
# export VVS_P4SERVER=p4sw:2006
# Needed for CUFFT
# export LM_LICENSE_FILE=$P4ROOT/sw/gpgpu/cudalibTesting/license/cuda.lic
# export VULCAN_CONFIG=.vcnf
export WORKON_HOME=~/Envs
source /usr/local/bin/virtualenvwrapper.sh

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

############################################################
## PATH
############################################################

function conditionally_prefix_path {
  local dir=$1
  if [ -d $dir ]; then
    PATH="$dir:${PATH}"
  fi
}

PATH=.:./bin:${PATH}

conditionally_prefix_path /usr/local/bin
conditionally_prefix_path /usr/local/sbin
conditionally_prefix_path /usr/local/share/npm/bin
conditionally_prefix_path /usr/texbin
conditionally_prefix_path ~/bin
conditionally_prefix_path ~/bin/private
conditionally_prefix_path $P4ROOT/sw/misc/linux
conditionally_prefix_path $P4ROOT/sw/eris/bin
conditionally_prefix_path /home/rgajare/llvm/install/bin
conditionally_prefix_path $P4ROOT/tools/VRL

############################################################
## MANPATH
############################################################

function conditionally_prefix_manpath {
  local dir=$1
  if [ -d $dir ]; then
    MANPATH="$dir:${MANPATH}"
  fi
}

conditionally_prefix_manpath /usr/local/man
conditionally_prefix_manpath ~/man

############################################################
## Other paths
############################################################

function conditionally_prefix_cdpath {
  local dir=$1
  if [ -d $dir ]; then
    CDPATH="$dir:${CDPATH}"
  fi
}

conditionally_prefix_cdpath ~/p4
conditionally_prefix_cdpath ~/work/oss

CDPATH=.:${CDPATH}

############################################################
## Other paths
############################################################

function conditionally_prefix_ldpath {
  local dir=$1
  if [ -d $dir ]; then
    LD_LIBRARY_PATH="$dir:${LD_LIBRARY_PATH}"
  fi
}

# Set INFOPATH so it includes users' private info if it exists
# if [ -d ~/info ]; then
#   INFOPATH="~/info:${INFOPATH}"
# fi

############################################################
## General development configurations
###########################################################

if [ -f ~/.nvm/nvm.sh ]; then
  . ~/.nvm/nvm.sh
fi

export RBXOPT=-X19

############################################################
## Terminal behavior
############################################################

shopt -s cdspell
shopt -s extglob
shopt -s checkwinsize

export PAGER="less"
export EDITOR="emacs -nw"

############################################################
## History
############################################################

# When you exit a shell, the history from that session is appended to
# ~/.bash_history.  Without this, you might very well lose the history of entire
# sessions (weird that this is not enabled by default).
shopt -s histappend

export HISTIGNORE="&:pwd:ls:ll:lal:[bf]g:exit:rm*:sudo rm*"
# remove duplicates from the history (when a new item is added)
export HISTCONTROL=erasedups
# increase the default size from only 1,000 items
export HISTSIZE=10000

############################################################
## Aliases
############################################################

if [ -e ~/.bash_aliases ]; then
  . ~/.bash_aliases
fi

############################################################
## Bash Completion, if available
############################################################

if [ -f /usr/local/etc/bash_completion ]; then
  . /usr/local/etc/bash_completion
elif  [ -f /etc/bash_completion ]; then
  . /etc/bash_completion
elif  [ -f /etc/profile.d/bash_completion ]; then
  . /etc/profile.d/bash_completion
elif [ -e ~/.bash_completion ]; then
  # Fallback. This should be sourced by the above scripts.
  . ~/.bash_completion
fi

############################################################
## Other
############################################################

if [[ "$USER" == '' ]]; then
  # mainly for cygwin terminals. set USER env var if not already set
  USER=$USERNAME
fi

# Make sure this appears even after rbenv, git-prompt and other shell extensions
# that manipulate the prompt.
if [ `which direnv 2> /dev/null` ]; then
  eval "$(direnv hook bash)"
fi

############################################################
## Ruby Performance Boost (see https://gist.github.com/1688857)
############################################################

# export RUBY_GC_MALLOC_LIMIT=60000000
# # export RUBY_FREE_MIN=200000 # Ruby <= 2.0
# export RUBY_GC_HEAP_FREE_SLOTS=200000 # Ruby >= 2.1

export LESSOPEN="| /usr/share/source-highlight/src-hilite-lesspipe.sh %s"
export LESS=' -R '

PATH="/home/rgajare/perl5/bin${PATH:+:${PATH}}"; export PATH;
PERL5LIB="/home/rgajare/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/home/rgajare/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/home/rgajare/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/home/rgajare/perl5"; export PERL_MM_OPT;

############################################################
## NV
############################################################

if [ -e ~/.nvrc ]; then
  . ~/.nvrc
fi

## eval "$(register-python-argcomplete ngc)"
