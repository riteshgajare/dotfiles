## This file is sourced by all *interactive* bash shells on startup.  This
## file *should generate no output* or it will break the scp and rcp commands.
############################################################

if [ -e /etc/bashrc ] ; then
  . /etc/bashrc
fi

export P4ROOT=/home/rgajare/p4
#export PATH=$P4ROOT/sw/misc/linux:$P4ROOT/sw/gpgpu/bin/x86_64_Linux_release:$PATH
# export DRIVER_ROOT=$P4ROOT/sw/dev/gpu_drv/module_compiler
export TOOLSDIR=$P4ROOT/sw/tools
export NV_TOOLS=$P4ROOT/sw/tools
export VERBOSE=1
# export LD_LIBRARY_PATH=$P4ROOT/sw/gpgpu/bin/x86_64_Linux_release:$LD_LIBRARY_PATH
export VVS_P4CLIENT=rgajare-dev
export VVS_P4SERVER=p4sw:2006
# Needed for CUFFT
export LM_LICENSE_FILE=$P4ROOT/sw/gpgpu/cudalibTesting/license/cuda.lic
export VULCAN_CONFIG=.vcnf
# export CUDA_INC_PATH=$P4ROOT/sw/gpgpu/cuda/import
# export CUDA_LIB_PATH=$P4ROOT/sw/gpgpu/bin/x86_64_Linux_release/stub
# export NVCC=$P4ROOT/sw/gpgpu/bin/x86_64_Linux_release/nvcc
# export NVRTC_INC_PATH=$P4ROOT/sw/gpgpu/bin/x86_64_Linux_release/nvrtc/include
# # the next variable will have either .../lib or .../lib64 at the end, depending on your distro
# export NVRTC_LIB_PATH=$P4ROOT/sw/gpgpu/bin/x86_64_Linux_release/nvrtc/lib64
# export PERENNIAL_ROOT=$P4ROOT/sw/compiler/test/gpgpu/perennial/ported/perennial/CCVS/testsrc

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
conditionally_prefix_path /home/rgajare/p4/sw/eris/bin
conditionally_prefix_path /home/rgajare/llvm/install/bin

if [ `which rbenv 2> /dev/null` ]; then
  eval "$(rbenv init -)"
fi

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

conditionally_prefix_cdpath ~/work
conditionally_prefix_cdpath ~/work/oss

CDPATH=.:${CDPATH}

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

# Change the window title of X terminals
case $TERM in
  xterm*|rxvt|Eterm|eterm)
    PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/$HOME/~}\007"'
    ;;
  screen)
    PROMPT_COMMAND='echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/$HOME/~}\033\\"'
    ;;
esac

# Show the git branch and dirty state in the prompt.
function parse_git_dirty {
  [[ -n $(git status -s 2> /dev/null) ]] && echo "*"
}
function parse_git_branch {
  git rev-parse --abbrev-ref HEAD 2> /dev/null
}

if [ `which git 2> /dev/null` ]; then
  function git_prompt {
    echo $(parse_git_branch)$(parse_git_dirty)
  }
else
  function git_prompt {
    echo ""
  }
fi

if [ `which rbenv 2> /dev/null` ]; then
  function ruby_prompt {
    echo $(rbenv version-name)
  }
elif [ `which ruby 2> /dev/null` ]; then
  function ruby_prompt {
    echo $(ruby --version | cut -d' ' -f2)
  }
else
  function ruby_prompt {
    echo ""
  }
fi

if [ `which rbenv-gemset 2> /dev/null` ]; then
  function gemset_prompt {
    local gemset=$(rbenv gemset active 2> /dev/null)
    if [ $gemset ]; then
      echo " ${gemset}"
    fi
  }
else
  function gemset_prompt {
    echo ""
  }
fi

function total_filesize {
  for filesize in $(ls -l . | grep "^-" | awk '{print $5}')
  do
    let totalsize=$totalsize+$filesize
  done
  if [[ $totalsize -eq "" ]]; then
    echo ""
  else
    echo -n "$totalsize bytes"
  fi
}

 if [ -n "$BASH" ]; then
    export PS1='\[\033[32m\]\n[\s: \w] $(total_filesize) $(git_prompt)\n\[\033[31m\][\u@\h]\$ \[\033[00m\]'
  fi

############################################################
## Optional shell behavior
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

############################################################
## CLang and LLVM
############################################################

function install_llvm {

  WGET=wget
  CURRENT_DIR=`pwd`
  INSTALL_DIR=`pwd`/install

  PYTHON=python27
  CLASS=566
  VERSION="3.8.1"
  TARGET=
  RTTI="REQUIRES_RTTI=1"

  # select file extension based on version

  CLANG_SRC=""
  LLVM_SRC=""
  RT_SRC=""
  LIBCXX_SRC=""
  LIBCXXABI_SRC=""
  LLDB_SRC=""
  LLD_SRC=""
  POLLY_SRC=""
  OPENMP_SRC=""
  CLANG_TOOLS_SRC=""
  TEST_SUITE_SRC=""

  SUFFIX=".tar.gz"

  RTVERSION=$VERSION

  if [ "$VERSION" == "3.4.2" ]; then
      RTVERSION="3.4"
      SUFFIX = ".tar.gz"
      CLANG_SRC="cfe-$VERSION.src"
      LLVM_SRC="llvm-$VERSION.src"
      RT_SRC="compiler-rt-3.4.src"
      LIBCXX_SRC="libcxx-$VERSION.src"
      LLDB_SRC="lldb-3.4.src"
      POLLY_SRC="polly-3.4.src"
      CLANG_TOOLS_SRC="clang-tools-extra-3.4.src"
      TEST_SUITE_SRC="test-suite-3.4.src"
  else
    SUFFIX=".tar.xz"
    CLANG_SRC="cfe-$VERSION.src"
    LLVM_SRC="llvm-$VERSION.src"
    RT_SRC="compiler-rt-$VERSION.src"
    LIBCXX_SRC="libcxx-$VERSION.src"
    LIBCXXABI_SRC="libcxxabi-$VERSION.src"
    LLDB_SRC="lldb-$VERSION.src"
    LLD_SRC="lldb-$VERSION.src"
    POLLY_SRC="polly-$VERSION.src"
    OPENMP_SRC="openmp-$VERSION.src"
    CLANG_TOOLS_SRC="clang-tools-extra-$VERSION.src"
    TEST_SUITE_SRC="test-suite-$VERSION.src"
  fi


  if [ "$(uname)" == "Darwin" ]; then
      WGET='curl -O '
      TARGET='--target=x86_64'
  fi

  if [ -d $LLVM_SRC ]; then
      echo Found $LLVM_SRC! Not downloading source again.
  else
    $WGET http://www.llvm.org/releases/$VERSION/$LLVM_SRC$SUFFIX
    tar xf $LLVM_SRC$SUFFIX
  fi

  if [ -d $LLVM_SRC ]; then
      echo Everything looks sane.
  else
    echo Install had problems. Quitting.
    exit
  fi

  if [ -d $CURRENT_DIR/$LLVM_SRC/tools ]; then
      cd $CURRENT_DIR/$LLVM_SRC/tools
  else
    echo Fail! Something is wrong with your $LLVM_SRC checkout!
    exit 1
  fi

  if [ -d clang ]; then
      echo Found clang! Not downloading clang again.
  else
    $WGET http://www.llvm.org/releases/$VERSION/$CLANG_SRC$SUFFIX
    tar xf $CLANG_SRC$SUFFIX
    mv $CLANG_SRC clang
    if [ -d clang ]; then
        echo Everything looks sane.
    else
      echo Install had problems. Quitting.
      exit
    fi
  fi

  cd $CURRENT_DIR

  if [ -d $CURRENT_DIR/$LLVM_SRC/projects ]; then
      cd $CURRENT_DIR/$LLVM_SRC/projects
  else
    echo Fail! Something is wrong wint $LLVM_SRC.
    exit 1
  fi

  if [ -d compiler-rt ]; then
      echo Found compiler-rt! Not downloading compiler-rt again.
  else
    $WGET http://www.llvm.org/releases/$RTVERSION/$RT_SRC$SUFFIX
    tar xf $RT_SRC$SUFFIX
    mv $RT_SRC compiler-rt
    if [ -d compiler-rt ]; then
        echo Everything looks sane.
    else
      echo Install had problems. Quitting.
      exit
    fi
  fi

  #if [ -d libcxx ]; then
  #    echo Found libcxx! Not downloading libcxx again.
  #else
  #$WGET http://www.llvm.org/releases/$VERSION/$LIBCXX_SRC$SUFFIX
  #tar xf $LIBCXX_SRC$SUFFIX
  #mv $LIBCXX_SRC libcxx
  #if [ -d libcxx ]; then
  #echo Everything looks sane.
  #else
  #echo Install had problems. Quitting.
  #exit
  #    fi
  #fi

  #if [ $LIBCXXABI_SRC != "" ]; then
  #    if [ -d libcxxabi ]; then#
  #echo Found libcxxabi! Not downloading libcxx again.
  #    else
  #$WGET http://www.llvm.org/releases/$VERSION/$LIBCXXABI_SRC$SUFFIX
  #tar xf $LIBCXXABI_SRC$SUFFIX
  #mv $LIBCXXABI_SRC libcxxabi
  #if [ -d libcxxabi ]; then
  #    echo Everything looks sane.
  #else
  #    echo Install had problems. Quitting.
  #    exit
  #fi
  #    fi
  #fi

  BUILD_DIR=$CURRENT_DIR/$LLVM_SRC/build

  if [ -d $BUILD_DIR ]; then
      cd $BUILD_DIR
      echo Found $BUILD_DIR.  Remove to reconfigure LLVM and Clang.
      make
  else
    mkdir -p $BUILD_DIR
    mkdir -p $INSTALL_DIR
    cd $BUILD_DIR
    cmake -DCMAKE_BUILD_TYPE=RelWithDebInfo -DCMAKE_C_COMPILER=gcc -DCMAKE_CXX_COMPILER=g++ -DCMAKE_INSTALL_PREFIX=$INSTALL_DIR  ..
    cmake --build .
    #make cxx
    #make check-libcxx
    cmake --build . --target install
  fi

  if [ -x $INSTALL_DIR/bin/clang ]; then
      true
  else
    echo LLVM not installed properly.
    exit 0
  fi

  cd $CURRENT_DIR
  echo "Remember to add $INSTALL_DIR/bin to your PATH variable."
  export PATH="$INSTALL_DIR/bin:$PATH"
}


export LESSOPEN="| /usr/share/source-highlight/src-hilite-lesspipe.sh %s"
export LESS=' -R '
