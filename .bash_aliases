# Adds an alias to the current shell and to this file.
# Borrowed from Mislav (http://github.com/mislav/dotfiles/tree/master/bash_aliases)
add-alias ()
{
   local name=$1 value=$2
   echo "alias $name='$value'" >> ~/.bash_aliases
   eval "alias $name='$value'"
   alias $name
}

############################################################
## Bash
############################################################

alias cd..="cd .."
alias ..="cd .."
alias ...="cd ../../"
alias ....="cd ../../../"
alias .2="cd ../../"
alias .3="cd ../../../"
alias .4="cd ../../../../"
alias .5="cd ../../../../../"
alias ~="cd ~"

alias c="clear"
alias path='echo -e ${PATH//:/\\n}'
alias ax="chmod a+x"

############################################################
## List
############################################################

if [[ `uname` == 'Darwin' ]]; then
  alias ls="ls -G"
  # good for dark backgrounds
  export LSCOLORS=gxfxcxdxbxegedabagacad
else
  alias ls="ls --color=auto"
  # good for dark backgrounds
  export LS_COLORS='no=00:fi=00:di=00;36:ln=00;35:pi=40;33:so=01;35:bd=40;33;01:cd=40;33;01:or=01;05;37;41:mi=01;05;37;41:ex=00;31:'
  # For LS_COLORS template: $ dircolors /etc/DIR_COLORS
fi

alias l="ls -alt"
alias ll="ls -lh"
alias la="ls -a"
alias lal="ls -alh"

############################################################
## Git
############################################################

alias g="git"
alias gb="git branch -a -v"
alias gc="git commit -v"
alias gca="git commit -v -a"
alias gd="git diff"
alias gl="git pull"
alias glr="git pull --rebase"
alias gf="git fetch"
alias gp="git push"
alias gs="git status -sb"
alias gr="git remote"
alias grp="git remote prune"
alias gcp="git cherry-pick"
alias gg="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%ci)%Creset' --abbrev-commit --date=relative"
alias ggs="gg --stat"
alias gsl="git shortlog -sn"
alias gw="git whatchanged"
alias gsu="git submodule update --init --recursive"
alias gi="git config branch.master.remote 'origin'; git config branch.master.merge 'refs/heads/master'"
if [ `which hub 2> /dev/null` ]; then
  alias git="hub"
fi
alias git-churn="git log --pretty="format:" --name-only | grep -vE '^(vendor/|$)' | sort | uniq -c | sort"

function gsd {
  target=${1%/}
  git submodule deinit $target
  git rm -f $target
  rm -rf .git/modules/$target
}

# Useful report of what has been committed locally but not yet pushed to another
# branch.  Defaults to the remote origin/master.  The u is supposed to stand for
# undone, unpushed, or something.
function gu {
  local branch=$1
  if [ -z "$1" ]; then
    branch=master
  fi
  if [[ ! "$branch" =~ "/" ]]; then
    branch=origin/$branch
  fi
  local cmd="git cherry -v $branch"
  echo $cmd
  $cmd
}

function gco {
  if [ -z "$1" ]; then
    git checkout master
  else
    git checkout $*
  fi
}

function gprune {
  local remote=$1
  if [ -z "$1" ]; then
    remote=origin
  fi
  local cmd="git remote prune $remote"
  echo $cmd
  $cmd
}

function st {
  if [ -d ".svn" ]; then
    svn status
  else
    git status -sb
  fi
}

############################################################
## Subversion
############################################################

# Remove all .svn folders from directory recursively
alias svn-clean='find . -name .svn -print0 | xargs -0 rm -rf'

############################################################
## OS X
############################################################

# Get rid of those pesky .DS_Store files recursively
alias dstore-clean='find . -type f -name .DS_Store -print0 | xargs -0 rm'

# Track who is listening to your iTunes music
alias whotunes='lsof -r 2 -n -P -F n -c iTunes -a -i TCP@`hostname`:3689'

# Empty the Trash on all mounted volumes and the main HDD
# Also, clear Apple’s System Logs to improve shell startup speed
alias emptytrash="sudo rm -rfv /Volumes/*/.Trashes; sudo rm -rfv ~/.Trash; sudo rm -rfv /private/var/log/asl/*.asl"

# Show/hide hidden files in Finder
alias showdotfiles="defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder"
alias hidedotfiles="defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder"

# Hide/show all desktop icons (useful when presenting)
alias showdeskicons="defaults write com.apple.finder CreateDesktop -bool true && killall Finder"
alias hidedeskicons="defaults write com.apple.finder CreateDesktop -bool false && killall Finder"

############################################################
## Middleman
############################################################
alias m="be middleman"

############################################################
## Heroku
############################################################

function heroku_command {
  if [ -z "$*" ]; then
    echo "run console"
  else
    echo "$*"
  fi
}

function hstaging {
  heroku `heroku_command $*` --remote staging
}

function hproduction {
  heroku `heroku_command $*` --remote production
}

alias deploy_hproduction='hproduction maintenance:on && git push production && hproduction run rake db:migrate && hproduction maintenance:off'
alias deploy_hstaging='hstaging maintenance:on && git push staging && hstaging run rake db:migrate && hstaging maintenance:off'

############################################################
## Rails
############################################################

alias tl="tail -f log/development.log"
alias ss="spring stop"

# Rails 3 or 4
function r {
  if [ -e "script/rails" ]; then
    script/rails $*
  else
    rails $* # Assumes ./bin is in the PATH
  fi
}

# Pow / Powder
alias p="powder"

############################################################
## MongoDB
############################################################
alias repair-mongo="rm /usr/local/var/mongodb/mongod.lock && mongod --repair"

############################################################
## Media
############################################################

# brew install ffmpeg --with-libvorbis --with-theora --with-fdk-aac --with-tools
function mp32ogg {
  file=$1
  ffmpeg -i "$file" -c:a libvorbis -q:a 4 $(basename ${file} .mp3).ogg
}

function ogg2mp3 {
  file=$1
  ffmpeg -i "$file" -c:a libmp3lame $(basename ${file} .ogg).mp3
}

############################################################
## Emacs
############################################################

alias e="emacs -nw"
alias eq="emacs -nw -Q"
alias en="emacsclient -n"
alias install_emacs='brew install emacs --srgb --with-cocoa'
alias install_emacs_head='brew install emacs --HEAD --srgb --with-cocoa'
alias link_emacs='ln -snf /usr/local/Cellar/emacs/24.5/bin/emacs /usr/local/bin/emacs && ln -snf /usr/local/Cellar/emacs/24.5/bin/emacsclient /usr/local/bin/emacsclient && brew linkapps emacs'
alias link_emacs_head='ln -snf /usr/local/Cellar/emacs/HEAD/bin/emacs /usr/local/bin/emacs && ln -snf /usr/local/Cellar/emacs/HEAD/bin/emacsclient /usr/local/bin/emacsclient && brew linkapps emacs'
alias upgrade_emacs='brew uninstall emacs && install_emacs && link_emacs'
alias upgrade_emacs_head='brew uninstall emacs && install_emacs_head && link_emacs_head'

############################################################
## Miscellaneous
############################################################

alias install_ffmpeg='brew install ffmpeg --with-libvorbis --with-theora --with-fdk-aac --with-faac --with-tools'

export GREP_COLOR="1;37;41"
alias grep="grep --color=auto"
alias wgeto="wget -q -O -"
alias wgeta="wget --name=rgajare --password=Winters@1"
alias sha1="openssl dgst -sha1"
alias sha2="openssl dgst -sha256"
alias sha512="openssl dgst -sha512"
alias b64="openssl enc -base64"
alias 256color="export TERM=xterm-256color"
alias prettyjson="python -mjson.tool"
alias dig="dig +noall +answer"

function flushdns {
  if pgrep mDNSResponder > /dev/null
  then # OS X <= 10.9
    dscacheutil -flushcache
  else # OS X >= 10.10
    sudo discoveryutil udnsflushcaches
  fi
}

alias whichlinux='uname -a; cat /etc/*release; cat /etc/issue'

alias myip="dig +short myip.opendns.com @resolver1.opendns.com"

function serve {
  local port=$1
  : ${port:=3000}
  ruby -rwebrick -e"s = WEBrick::HTTPServer.new(:Port => $port, :DocumentRoot => Dir.pwd, :MimeTypes => WEBrick::HTTPUtils::load_mime_types('/etc/apache2/mime.types')); trap(%q(INT)) { s.shutdown }; s.start"
}

function eachd {
  for dir in *; do
    cd $dir
    echo $dir
    $1
    cd ..
  done
}

function fakefile {
  let mb=$1
  let bytes=mb*1048576
  dd if=/dev/random of=${mb}MB-fakefile bs=${bytes} count=1 &> /dev/null
}

############################################################

alias vnc-server="sudo x11vnc -once -nopw -auth guess -display :0"
alias whichgcc="sudo update-alternatives --config gcc"
alias p4-history="perl /home/rgajare/scripts/client_log.pl"

function dvs-compiler {

 usage() { echo "Usage: dvs-compiler [-c <cl-number>] [-a <AMD64|aarch64|ARMv7>] -t" 1>&2; }
 RELEASE=0
 NUMARGS=$#
 FILEPATH=http://dvstransfer.nvidia.com/dvsshare/dvs-binaries/
 OS=Linux
 ARCH=AMD64
 r=false
 t=false

 while true; do
   case $1 in
     -h|--help)
       usage
       return
       ;;
     -c|--changelist)
       c=$2
       shift 2
       ;;
     -t|--cudart)
       t=true
       shift
       ;;
     *)
       shift
       break
       ;;
   esac
 done

 PWD=`pwd`
 mkdir -p $c
 FILENAME=gpu_drv_module_compiler_
 cd $c
 if $r ; then
     FILENAME+="Release_${OS}_"
 else
     FILENAME+="Debug_${OS}_"
 fi
 FILENAME+="${ARCH}_GPGPU_COMPILER"
 if $t ; then
     echo "*** Getting the cudart from DVS ***"
     FILENAME+="_cudart"
 fi
 FILEPATH+="${FILENAME}/SW_${c}.0_${FILENAME}.tgz"

 echo "*** Downloading from $FILEPATH ***"
 TMPFILE=`mktemp`
 wget "$FILEPATH" -O $TMPFILE
 #aria2c -x 8 "$FILEPATH" -o $TMPFILE --dir='\'
 tar xvf $TMPFILE
 echo Extracting the compiler
 echo Please wait...
 for f in *.tar *.bz2 *.tgz
 do
   tar xvf $f
   sudo rm -rf $f
 done
 sudo rm -rf $TMPFILE
 echo Everything looks sane.
}

function cuda-utility {

  # Fonts
NORM=`tput sgr0`
BOLD=`tput bold`
REV=`tput smso`

# Colours
BLACK=$'\e[0;30m'
BLUE=$'\e[0;34m'
CYAN=$'\e[0;36m'
PURPLE=$'\e[0;35m'
LIGHT_GREEN=$'\e[1;32m'
RED=$'\e[0;31m'
BROWN=$'\e[0;33m'

cudart=false
cudalibtools=false
nvvm=false
tools=false
jas=false
cufft=false
cublas=false
curand=false
cupti=false
npp=false
thrust=false
math=false
perennial=false
modena=false
misc_samples=false
curand_samples=false
clean=false

USAGE () {
    printf "${BOLD}Usage${NORM}: ./host_compiler_test.sh [options]
${BOLD}Options:${NORM}
\t${BOLD}--help${NORM}\t\t\t\tPrint this message
\t${BOLD}--clean${NORM}\t\t\t\tRemove bin, built and depends directories from the toolkit path
\t${BOLD}--standard${NORM}\t\t\tStandard host compiler tests specified in the test plan
\t\t\t\t\tIncludes:
\t\t\t\t\t\tCUDART
\t\t\t\t\t\tCUDALIBTOOLS
\t\t\t\t\t\tCUFFT
\t\t\t\t\t\tCUBLAS
\t\t\t\t\t\tCURAND
\t\t\t\t\t\tThrust
\t\t\t\t\t\tMath
\t\t\t\t\t\tMISC. CUDA Samples
\t\t\t\t\t\tCURAND CUDA Samples
\t\t\t\t\t\tCUFFT CUDA Samples
\t\t\t\t\t\tPerennial
\t${BOLD}--cudart${NORM}\t\t\tBuild CUDART
\t${BOLD}--cudalibtools${NORM}\t\t\tBuild CUDALIBTOOLS
\t${BOLD}--nvvm${NORM}\t\t\t\tBuild NVVM
\t${BOLD}--tools${NORM}\t\t\t\tBuild Tools
\t${BOLD}--jas${NORM}\t\t\t\tBuild JAS
\t${BOLD}--cufft${NORM}\t\t\t\tBuild CUFFT
\t${BOLD}--cublas${NORM}\t\t\tBuild CUBLAS
\t${BOLD}--curand${NORM}\t\t\tBuild CURAND
\t${BOLD}--cupti${NORM}\t\t\t\tBuild CUPTI
\t${BOLD}--npp${NORM}\t\t\t\tBuild NPP
\t${BOLD}--thrust${NORM}\t\t\tBuild Thrust
\t${BOLD}--misc_samples${NORM}\t\t\tBuild MISC. CUDA Samples
\t${BOLD}--curand_samples${NORM}\t\tBuild CURAND CUDA Samples
\t${BOLD}--math${NORM}\t\t\t\tBuild and execute CUDA Math tests
\t${BOLD}--perennial${NORM}\t\t\tBuild and execute Perennial language specification tests
\t${BOLD}--host_compiler${NORM} <path>\t\tSpecify a host compiler that will be used by Perennial
\t${BOLD}--modena${NORM}\t\t\tBuild and execute Modena language specification tests
\t${BOLD}--cufft_samples${NORM}\t\t\tBuild CUFFT CUDA Samples
\t${BOLD}--branch${NORM} <path>\t\t\tCUDA toolkit branch (default: gpgpu)
\t${BOLD}--host_arch${NORM} <arch>\t\tHost architecture (default: x86_64)
\t${BOLD}--os${NORM} <os>\t\t\tHost Operating System (options: Linux | Darwin | Windows) (default: Linux)
\t${BOLD}--export_compiler_to${NORM} <path>\tExport the compiler components to <path>
\t${BOLD}--output_dir${NORM} <path>\t\tDirectory for log files and results (default: $PWD)
\t${BOLD}--p4root${NORM} <path>\t\t\tP4ROOT path (optional); can be set through the environment variable
\t${BOLD}--gpgpu_compiler_export${NORM} <path>\tGPGPU_COMPILER_EXPORT path (optional); can be set through the environment variable\n"
}
# Local variables
branch=gpgpu
script_dir=$PWD
nvcc_extra_flags="-v -keep"
make_extra_flags=""
# Local variables continued
tmp_root=$P4ROOT
make=make


host_arch=x86_64
os=Linux
perennial_os=$os

while true; do
    case $1 in
  --help)
      USAGE
      return
      ;;
  --clean)
      clean=true
      shift
      ;;
  --cudart)
      cudart=true
      shift
      ;;
  --cudalibtools)
      cudalibtools=true
      shift
      ;;
  --nvvm)
      nvvm=true
      shift
      ;;
  --tools)
      tools=true
      shift
      ;;
  --jas)
      jas=true
      shift
      ;;
  --cufft)
      cufft=true
      shift
      ;;
  --cublas)
      cublas=true
      shift
      ;;
  --curand)
      curand=true
      shift
      ;;
  --cupti)
      cupti=true
      shift
      ;;
  --npp)
      npp=true
      shift
      ;;
  --thrust)
      thrust=true
      shift
      ;;
  --misc_samples)
      misc_samples=true
      shift
      ;;
  --curand_samples)
      curand_samples=true
      shift
      ;;
  --cufft_samples)
      cufft_samples=true
      shift
      ;;
  --math)
      math=true
      shift
      ;;
  --perennial)
      perennial=true
      shift
      ;;
  --host_compiler)
      host_compiler=$2
      shift 2
      ;;
  --modena)
      modena=true
      shift
      ;;
  --branch)
      branch=$2
      shift 2
      ;;
  --host_arch)
      host_arch=$2
      shift 2
      ;;
  --os)
      os=$2
      perennial_os=$2
      shift 2
      ;;
  --output_dir)
      script_dir=$2
      shift 2
      ;;
  --standard)
      cudart=true
      cudalibtools=true
      cufft=true
      cublas=true
      curand=true
      thrust=true
      misc_samples=true
      curand_samples=true
      cufft_samples=true
      math=true
      perennial=true
      clean=true
      shift
      ;;
  --p4root)
      P4ROOT=$2
      shift 2
      ;;
  --gpgpu_compiler_export)
      GPGPU_COMPILER_EXPORT=$2
      shift 2
      ;;
  --export_compiler_to)
      export_compiler_to=$2
      shift 2
      ;;
  *)
      if [[ $1 != "" ]]; then
          echo "${RED}ERROR: $1 illegal option detected${NORM}"
      fi
      shift
      break
      ;;
    esac
done

if [[ -z ${P4ROOT} ]]; then
    echo "${RED}ERROR: P4ROOT variable is not set.${NORM}"
    exit 1
fi
echo ${BROWN}This is cuda-utility for host compiler testing...${NORM}
echo "${BROWN}***************************************************${NORM}"
echo "${BROWN}P4ROOT=${P4ROOT}${NORM}"
echo "${BROWN}DRIVER_ROOT=${DRIVER_ROOT}${NORM}"
echo "${BROWN}HOST_ARCH=${host_arch}${NORM}"
echo "${BROWN}OS=${os}${NORM}"
echo "${BROWN}${NORM}"
echo "${BROWN}***************************************************${NORM}"


# General environment variables
export BUILDROOT=$tmp_root/sw/$branch

if [ -z $DRIVER_ROOT ]; then
    export DRIVER_ROOT=$tmp_root/sw/dev/gpu_drv/module_compiler
fi
export TOOLSDIR=$tmp_root/sw/tools
export VERBOSE=1
if [[ $os == "Linux" ]]; then
    perennial_os="linux"
    export LD_LIBRARY_PATH=$BUILDROOT/bin/${host_arch}_Linux_release
fi

if [[ $os == "Windows" ]]; then
    perennial_os="windows"
fi

if [[ $os == "Darwin" ]]; then
    perennial_os="darwin"
    export DYLD_LIBRARY_PATH=$BUILDROOT/bin/${host_arch}_Darwin_release
    make=make
fi

if [[ $clean == true ]]; then
    echo Removing the previous build files. Requires sudo!
    sudo rm -rf $BUILDROOT/bin/*
    sudo rm -rf $BUILDROOT/built/*
    sudo rm -rf $BUILDROOT/depends/*
fi

if [[ $nvvm == true ]]; then
    tmp_path=$PATH
    export PATH=$tmp_root/sw/misc/linux:$PATH
    cd $tmp_root/sw/dev/gpu_drv/module_compiler/drivers/compiler
    if [[ $clean == true ]]; then
        echo "${RED}Attempting to clean previous build. Clobber!${NORM}"
        sudo $make RELEASE=1 clean
        echo ""
        echo Everything looks sane.
    else
      echo Performing incremental build.
    fi
    echo "${PURPLE}*** Starting the build for NVVM ***${NORM}"
    echo Please wait...
    sudo $make nvvm_install RELEASE=1 PARALLEL_NVVM_BUILD= GPGPU_COMPILER_EXPORT_DIR=$BUILDROOT/bin > $script_dir/build_nvvm.log 2>&1
    #chown -R tester:tester $BUILDROOT/bin/${host_arch}_${os}_release
    if [ -z `grep -Irine "&&&& Installing nvvm` ]; then
        echo Everything is sane.
    fi
    export PATH=$tmp_path
fi

# Tools
if [[ $tools == true ]]; then
    cd $tmp_root/sw/dev/gpu_drv/module_compiler/drivers/compiler
    if [[ $clean == true ]]; then
        echo "${RED}Attempting to clean previous build. Clobber!${NORM}"
        sudo rm -rf built/*
        echo ${GREEN}Everything looks sane.${NORM}
    else
      echo Performing incremental build.
    fi
    echo "${PURPLE}*** Starting the build for Tools ***${NORM}"
    echo Please wait...
    sudo $make $make_extra_flags tools_install RELEASE=1 -j12 GPGPU_COMPILER_EXPORT_DIR=$BUILDROOT/bin > $script_dir/build_tools.log 2>&1
fi


## Do clean up after messing your env variables
echo Restoring the env variables.
unset BUILDROOT
cd $script_dir
echo ${GREEN}Everything looks sane.${NORM}

}
