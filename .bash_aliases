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

noout() {
    "$@" >/dev/null 2>&1 &
}
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
# Utility functions
############################################################

alias vnc-server="sudo x11vnc -forever -nopw -auth guess -display :0"
alias whichgcc="sudo update-alternatives --config gcc"
alias p4-history="perl /home/rgajare/scripts/client_log.pl"

function extract {
 tar xvf $1
 echo Extracting the compiler
 echo Please wait...
 rm -rf $1
 for f in *.tar *.bz2 *.tgz
 do
   tar xvf $f
   sudo rm -rf $f
 done
}


function inquire ()  {
  echo  -n "$@ [y/n]? "
  read answer
  finish="-1"
  while [ "$finish" = '-1' ]
  do
    finish="1"
    if [ "$answer" = '' ];
    then
      answer=""
    else
      case $answer in
  y | Y | yes | YES ) answer="y";;
  n | N | no | NO ) answer="n";;
  *) finish="-1";
     echo -n 'Invalid response -- please reenter:';
     read answer;;
       esac
    fi
  done
}



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
     -r|--release)
       r=true
       shift
       ;;
     -c|--changelist)
       c=$2
       shift 2
       ;;
     -t|--cudart)
       t=true
       shift
       ;;
     -a|--arch)
       ARCH=$2
       shift 2
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
 extract $TMPFILE
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
export=false
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
TARGET_OS=Linux
HOST_ARCH=x86_64
os=Linux
perennial_os=$os
sudo echo "Welcome to CUDA Utility for Host compiler testing!!"
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
      HOST_ARCH=$2
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
    -target-arch)
      TARGET_ARCH=$2
      shift 2
      ;;
    -target-os)
      TARGET_OS=$2
      shift 2
      ;;
    -branch)
      BRANCH=$2
      shift 2
      ;;
    --export_compiler_to)
      export_compiler_to=$2
      export=true
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

if [[ -z ${TARGET_ARCH} ]]; then
    TARGET_ARCH=$HOST_ARCH
fi

if [[ -z ${BRANCH} ]]; then
    BRANCH=module_compiler
fi

if [[ -z ${P4ROOT} ]]; then
    echo "${RED}ERROR: P4ROOT variable is not set.${NORM}"
    exit 1
fi
echo ${BROWN}This is cuda-utility for host compiler testing...${NORM}
echo "***************************************************"
echo "P4ROOT=${P4ROOT}"
echo "DRIVER_ROOT=${DRIVER_ROOT}"
echo "HOST_ARCH=${HOST_ARCH}"
echo "OS=${os}"
echo "TARGET_ARCH=${TARGET_ARCH}"
echo "NV_TOOLS=${P4ROOT}/sw/tools"
echo "***************************************************"

# General environment variables
export BUILDROOT=$tmp_root/sw/$branch

if [ -z $DRIVER_ROOT ]; then
    export DRIVER_ROOT=$tmp_root/sw/dev/gpu_drv/${BRANCH}
fi
export TOOLSDIR=$tmp_root/sw/tools
export VERBOSE=1
if [[ $os == "Linux" ]]; then
    perennial_os="linux"
    export LD_LIBRARY_PATH=$BUILDROOT/bin/${HOST_ARCH}_Linux_release
fi

if [[ $os == "Windows" ]]; then
    perennial_os="windows"
fi

NUMPROCS=`grep processor /proc/cpuinfo | wc -l`

if [[ $os == "Darwin" ]]; then
    perennial_os="darwin"
    export DYLD_LIBRARY_PATH=$BUILDROOT/bin/${HOST_ARCH}_Darwin_release
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
    cd $tmp_root/sw/dev/gpu_drv/${BRANCH}/drivers/compiler
    if [[ $clean == true ]]; then
  echo "${RED}Attempting to clean previous build. Clobber!${NORM}"
  sudo $make RELEASE=1 clean > $script_dir/build_nvvm.log 2>&1
  echo ""
  echo Everything looks sane.
    else
      echo Performing incremental build.
    fi
    echo "${PURPLE}*** Starting the build for NVVM ***${NORM}"
    echo Please wait...
    set -x
    sudo $make nvvm_install RELEASE=1 PARALLEL_NVVM_BUILD=$NUMPROCS GPGPU_COMPILER_EXPORT_DIR=$BUILDROOT/bin > $script_dir/build_nvvm.log 2>&1
    set +x
    sudo chown -R rgajare:rgajare $P4ROOT/sw/gpgpu/bin
    if [ -z `grep -Irine "&&&& Installing nvvm` ]; then
  echo Everything is sane.
    fi
    export PATH=$tmp_path
fi

# Tools
if [[ $tools == true ]]; then
    cd $tmp_root/sw/dev/gpu_drv/${BRANCH}/drivers/compiler
    if [[ $clean == true ]]; then
  echo "${RED}Attempting to clean previous build. Clobber!${NORM}"
  sudo rm -rf built/*
  echo ${GREEN}Everything looks sane.${NORM}
    else
      echo Performing incremental build.
    fi
    echo "${PURPLE}*** Starting the build for Tools ***${NORM}"
    echo Please wait...
    set -x
    sudo $make $make_extra_flags tools_install RELEASE=1 -j$NUMPROCS GPGPU_COMPILER_EXPORT_DIR=$BUILDROOT/bin > $script_dir/build_tools.log 2>&1
    sudo chown -R rgajare:rgajare $P4ROOT/sw/gpgpu/bin
    set +x
fi

if [[ $jas == true ]]; then
    cd $tmp_root/sw/dev/gpu_drv/${BRANCH}/drivers/compiler
    echo "${PURPLE}*** Starting the build for Jas ***${NORM}"
    echo Please wait...
    set -x
    sudo $make $make_extra_flags jas_install RELEASE=1 -j$NUMPROCS GPGPU_COMPILER_EXPORT_DIR=$BUILDROOT/bin > $script_dir/build_jas.log 2>&1
    set +x
fi

if [[ $TARGET_OS == "QNX" ]]; then
    QNX_HOST=$P4ROOT/sw/tools/embedded/qnx/qnx700-eval/host/linux/x86_64
    QNX_TARGET=$P4ROOT/sw/tools/embedded/qnx/qnx700-eval/target/qnx7
    echo QNX Target detected! Continuing with the following configuration -
    echo QNX_HOST=$QNX_HOST
    echo QNX_TARGET=$QNX_TARGET
    if [[ -z $TARGET_ARCH ]]; then
  TARGET_ARCH=aarch64
    fi
    echo TARGET_ARCH=$TARGET_ARCH
fi

GPGPU_COMPILER_EXPORT=$P4ROOT/sw/gpgpu/bin/x86_64_Linux_release

if [[ $cudart == true ]]; then
    echo "${PURPLE}Starting the build for Cuda Libs {CUDART}${NORM}"
    set -x
    cd $P4ROOT/sw/gpgpu/
    $make TARGET_ARCH=${TARGET_ARCH} TARGET_OS=${TARGET_OS} -j$NUMPROCS RELEASE=1 cuda DRIVER_ROOT=${DRIVER_ROOT} GPGPU_COMPILER_EXPORT=$GPGPU_COMPILER_EXPORT > $script_dir/build_cuda.log 2>&1
    $make TARGET_ARCH=${TARGET_ARCH} TARGET_OS=${TARGET_OS} -j$NUMPROCS RELEASE=1 cudalibtools DRIVER_ROOT=${DRIVER_ROOT} GPGPU_COMPILER_EXPORT=$GPGPU_COMPILER_EXPORT > $script_dir/build_cuda.log 2>&1
    if $export; then
      tar -chzf cudart.tgz --exclude 'build/scripts/testing/*' build bin cuda/import/*.h* cuda/tools/cudart/*.h* cuda/tools/cudart/nvfunctional cuda/tools/cnprt/*.h* cuda/common/*.h*
      find built/ -name "*.ptx" | xargs tar rvf built_ptx.tar
      bzip2 -z built_ptx.tar
      mv cudart.tgz $script_dir
      mv built_ptx.tar $script_dir
    fi
    set +x
    echo Everything looks sane.
fi

## Do clean up after messing your env variables
echo Restoring the env variables.
unset BUILDROOT
cd $script_dir
echo ${GREEN}Everything looks sane.${NORM}

}

alias p4sw='cd /home/rgajare/p4/sw'
alias find-name='find . -name "$1"'
alias less='less -N'

function vulcan-cuda {
  rev=$1
  if [[ -z $rev ]]; then
    rev=tot
  fi
  set -x
  vulcan --eris --install --target-revision==cl-$rev compiler_internal_base
  echo This is what would be the output
  echo $?
  vulcan --install ]=cuda
  set +x
}

function isolate_change {
if [ -z /mnt/compilershare/compiler ]; then
   sudo mount -t cifs -o username=rgajare //compilershare/binarydrop /mnt/compilershare
fi
for cl in /mnt/compilershare/compiler/gpu_drv_module_compiler/Linux_GPGPU_COMPILER/*; do
    echo "using the build from ${cl}"
    ${cl}/x86_64_Linux_release/bin/ptxas -arch=sm_35 -m64 -po stress-maxrregcount=24  "zgemm_largek.o.keep_dir/zgemm_largek.compute_35.ptx"  -o "zgemm_largek.o.keep_dir/zgemm_largek.compute_35.cubin"

    if [ $? == 1 ]; then
       echo Something broke!
       break
    fi
done

}

############################################################
## Perforce
############################################################

function install_p4 {
 sudo su
 touch  /etc/apt/sources.list.d/perforce.list && echo 'deb http://package.perforce.com/apt/ubuntu/ trusty release' >>  /etc/apt/sources.list.d/perforce.list
 wget -qO - https://package.perforce.com/perforce.pubkey | sudo apt-key add -
 apt-get update && sudo apt-get install helix-p4d -y
 exit
}

alias p4d="p4 describe"
alias p4s="p4 sync"
alias p4f="p4 filelog -L"
alias p4top="p4 changes -t -m1 #have"
alias mychanges='p4 changes -u rgajare -s pending'
alias p4review='/home/rgajare/p4/sw/main/apps/p4review/p4review.pl'
alias p4rmerge='/home/rgajare/p4/sw/main/apps/p4review/p4rmerge.pl'
alias dvsbuild='~/p4/sw/automation/dvs/dvsbuild/dvsbuild.pl -web'
alias p4revert='perl /home/rgajare/p4/sw/tools/scripts/p4revert.pl'

function p4clean {
 find . -type f | p4 -x - fstat 2>&1 > /dev/null | sed 's/ -.*$//' > /tmp/list
 less /tmp/list
 inquire "Do you want to continue deleting the files?"
 if [[ $answer == "y" ]]; then
   xargs rm < /tmp/list
   #Remove the empty directories if any
   find -depth -type d -empty -exec rmdir {} \;
 fi
 rm -rf /tmp/list
}

function client_log {
  if [[ -n $1 ]];
  then p4 filelog //sw_spec/client/$1
  else echo "Usage: client_log <client-name>"
  fi
}

alias vless='vim -u ~/.less.vim'

function build_compiler {
  usage() { echo "Usage: fast-cudart [-c <cl-number>] -r" 1>&2; }
  PDIR=`pwd`
  clc=""
  unset COMPILER_DIR
  re=false
  while true; do
    case $1 in
      -h|--help)
        usage
        return
        ;;
      -r|--release)
        re=true
        shift
        ;;
      -c|--changelist)
        clc=$2
        shift 2
        ;;
      *)
        shift
        break
        ;;
    esac
  done
  if [[ $clc ]]; then
  p4 sync  //sw/dev/gpu_drv/module_compiler/drivers/common/build/...@$clc
  p4 sync  //sw/dev/gpu_drv/module_compiler/drivers/common/cop/...@$clc
  p4 sync  //sw/dev/gpu_drv/module_compiler/drivers/common/dwarf/...@$clc
  p4 sync  //sw/dev/gpu_drv/module_compiler/drivers/common/inc/...@$clc
  p4 sync  //sw/dev/gpu_drv/module_compiler/drivers/common/nvi/...@$clc
  p4 sync  //sw/dev/gpu_drv/module_compiler/drivers/common/src/...@$clc
  p4 sync  //sw/dev/gpu_drv/module_compiler/drivers/compiler/...@$clc
  p4 sync  //sw/dev/gpu_drv/module_compiler/drivers/gpgpu/cuda/common/...@$clc
  p4 sync  //sw/dev/gpu_drv/module_compiler/sdk/nvidia/inc/...@$clc
  p4 sync  //sw/compiler/gpgpu/nvvm/...@$clc
  echo Synced workspace to chnagelist $clc
  else p4 sync
  fi
  sudo rm -rf $P4ROOT/sw/gpgpu/bin/*
  sudo rm -rf $P4ROOT/sw/gpgpu/built/*
  sudo rm -rf $P4ROOT/sw/gpgpu/depends/*
  cd $P4ROOT/sw/dev/gpu_drv/module_compiler/drivers/compiler
  if $re; then
      echo Release build...
      ./build/make-4.00 RELEASE=1 clean
      ./build/make-4.00 -O nvvm_install RELEASE=1 PARALLEL_NVVM_BUILD=`grep processor /proc/cpuinfo | wc -l` GPGPU_COMPILER_EXPORT_DIR=$P4ROOT/sw/gpgpu/bin NV_TOOLS=$P4ROOT/sw/tools > build_nvvm.log 2>&1
      ./build/make-4.00 -O tools_install RELEASE=1 PARALLEL_NVVM_BUILD=`grep processor /proc/cpuinfo | wc -l` GPGPU_COMPILER_EXPORT_DIR=$P4ROOT/sw/gpgpu/bin > build_tools 2>&1
  else
      echo Debug build...
      ./build/make-4.00 clean
      ./build/make-4.00 -O nvvm_install PARALLEL_NVVM_BUILD=`grep processor /proc/cpuinfo | wc -l` GPGPU_COMPILER_EXPORT_DIR=$P4ROOT/sw/gpgpu/bin NV_TOOLS=$P4ROOT/sw/tools > build_nvvm.log 2>&1
      ./build/make-4.00 -O tools_install PARALLEL_NVVM_BUILD=`grep processor /proc/cpuinfo | wc -l` GPGPU_COMPILER_EXPORT_DIR=$P4ROOT/sw/gpgpu/bin > build_tools 2>&1
  fi
  sudo chown -R rgajare:rgajare $P4ROOT/sw/gpgpu/bin
  if [[ $clc ]]; then
     echo Exporting the compiler to ~/compiler/${clc}
     mkdir -p ~/compiler/$clc
     cp -R ~/p4/sw/gpgpu/bin/* ~/compiler/$clc
  fi
  cd $PDIR
}

function build_cudart {
  usage() { echo "Usage: fast-cudart [-c <cl-number>] -r" 1>&2; }
  cl=""
  unset COMPILER_DIR
  r=false
  ARCH_OS_MO=x86_64_Linux_debug/
  while true; do
    case $1 in
      -h|--help)
        usage
        return
        ;;
      -r|--release)
        r=true
        ARCH_OS_MO=x86_64_Linux_release/
        shift
        ;;
      -c|--changelist)
        cl=$2
        shift 2
        ;;
      *)
        shift
        break
        ;;
    esac
  done
  if [ -d /mnt/compilershare/compiler ]; then
      OLD_PATH=$PATH
      WORK_DIR=~/compiler
      export TEST_ROOT=$P4ROOT/sw/gpgpu
      export DRIVER_ROOT=$P4ROOT/sw/dev/gpu_drv/module_compiler
      if [[ ! -d ~/compiler/${cl} || ! -e ~/compiler/${cl}/libcudart.so ]]; then
          export COMPILER_DIR=`readlink -e ~/compiler/${cl}/${ARCH_OS_MO}`
          echo $COMPILER_DIR
          if [[ -z $COMPILER_DIR ]]; then
              export COMPILER_DIR=`readlink -e /mnt/compilershare/compiler/gpu_drv_module_compiler/Linux_GPGPU_COMPILER/${cl}/${ARCH_OS_MO}`
          fi
          if [[ -z $COMPILER_DIR ]]; then
              echo "No compiler found in binarydrop... Getting it from DVS!"
              cd ~/compiler
              if $r;
              then `dvs-compiler -c ${cl} -r`
              else `dvs-compiler -c ${cl}`
              fi
              export COMPILER_DIR=${WORK_DIR}/${cl}/${ARCH_OS_MO}
          fi
          echo Getting the compiler from ${COMPILER_DIR}
          export LD_LIBRARY_PATH=${TEST_ROOT}/bin/${ARCH_OS_MO}
          export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games
          export PATH=$PATH:$COMPILER_DIR/bin
          export PATH=$PATH:$COMPILER_DIR/nvvm/bin
          export PATH=$P4ROOT/sw/tools/unix/hosts/Linux-x86/doxygen-1.5.8:$PATH
          echo "Compiling CUDA runtime & Library tools for ${cl} ..."
          cd ${TEST_ROOT}
          rm -rf bin built depends
          if $r; then
              ./build/make-4.00 RELEASE=1 cuda -j12 GPGPU_COMPILER_EXPORT=$COMPILER_DIR > build_cuda.log 2>&1
              ./build/make-4.00 RELEASE=1 cudalibtools -j12 GPGPU_COMPILER_EXPORT=$COMPILER_DIR > /dev/null 2>&1
          else
            ./build/make-4.00 cuda -j12 GPGPU_COMPILER_EXPORT=$COMPILER_DIR > build_cuda.log 2>&1
            ./build/make-4.00 cudalibtools -j12 GPGPU_COMPILER_EXPORT=$COMPILER_DIR > /dev/null 2>&1
          fi
          cd ${TEST_ROOT}/bin/${ARCH_OS_MO}
          if [[ -e libcudart.so && -e libcudadevrt.a ]]; then
              echo Exporting the compiler to /home/rgajare/compiler/${cl}
              #cp -R ${TEST_ROOT}/bin/${ARCH_OS_MO} ${TEST_ROOT}/build_cuda.log /home/rgajare/compiler/${cl}
              echo Everything looks sane.
              echo "Don't forget to add it in path - conditionally_prefix_path /home/rgajare/compiler/${cl}"
          else
            echo Compilation errors. Please check logs...
          fi
          export PATH=$OLD_PATH
          export LD_LIBRARY_PATH=
      else
        echo Runtime already built in ~/compiler/${cl}
        echo "use rm -rf ~/p4/sw/gpgpu/bin && mkdir -p ~/p4/sw/gpgpu/bin/${ARCH_OS_MO} && cp -R  ~/p4/sw/gpgpu/bin/ ~/p4/sw/gpgpu/bin/${ARCH_OS_MO}"
      fi
      unset DRIVER_ROOT
      unset TEST_ROOT
      unset ARCH_OS_MO
      unset WORK_DIR
  else
    mkdir -p /mnt/compilershare
    sudo mount -t cifs -o username=rgajare //compilershare/binarydrop /mnt/compilershare
    echo "Unable to mount compilershare. Try again!"
  fi
}
alias rebash='. /home/rgajare/.bashrc'
alias tree='tree | less'

function findfile {
  /usr/bin/tree -f | grep -ie $1
}

function findinitiator {
  cd "/home/rgajare/p4/sw/automation/DVS 2.0/Build System/Build Initiators"
  /usr/bin/tree -f | grep -ie $1
}

function wgeta {
  wget --user=rgajare --password=Winters@1 $1 -O $2
}

function run_test {


#This is the main DVS builder entry script for all linux unit_test build side processing.  It sets up the unix-build jail for build side processing.  It then starts the jail and performs the requuested build side processing.

# REQUIRED ENV VARIABLES
# P4ROOT

# REQUIRED INPUTS
# host_compiler_version - select a host compiler that is installed in the compiler-verification tools area.

set -u

#### options procesing ####
_compiler_version="gcc-5.1.0"
_log_level=1
_testcase=""
_changelist=""
_gpu_arch=sm_30
while getopts "h:i:l:g:c:t:" opt; do
    case $opt in
        h ) _compiler_version=$OPTARG ;;
        l ) _log_level=$OPTARG ;;
        g ) _gpu_arch=$OPTARG ;;
        c ) _changelist=$OPTARG ;;
        t ) _testcase=$OPTARG ;;
        * ) exit 1 ;;
    esac
done
shift $(($OPTIND - 1))

if [[ $_testcase ]]; then
    rm -rf testlist.txt && touch testlist.txt
    echo $_testcase > testlist.txt
fi

#### options validation ####
if [ "$_compiler_version" == "NONE" ]; then
    echo "ERROR: no host compiler selected (-h)."
    usage
    exit 1
fi


if [ -z "${P4ROOT+is_set}" ]; then
    echo "Error: The required env variable P4ROOT is not set"
    exit 1
fi

echo "************ OPTIONS ************"
echo "P4ROOT:${P4ROOT}"
echo "_compiler_version:${_compiler_version}"
echo "_log_level:${_log_level}"
echo "_gpu_arch:${_gpu_arch}"
echo
echo

set -x
#### build jail env setup ####
_tool_root=$P4ROOT/sw/compiler/test/gpgpu/tools/unix/hosts/Linux-x86_64
_unix_build_rootfs_dir=${_tool_root}/unix-build
_python_root_dir=${_tool_root}/python-2.7.10
_binutils_root_dir=
_toolkit_root_dir=${P4ROOT}/sw/compiler/test

if [[ $_changelist ]]; then
    build_cudart -c $_changelist -r
    _toolkit_root_dir=$(P4ROOT)/sw/gpgpu
fi

echo Cudart built successfully.

_test_root_dir=$P4ROOT/sw/compiler/test/unit_tests

#### test_harness parameters
_toolkit_bin_dir=${_toolkit_root_dir}/bin/x86_64_Linux_release
_test_src_dir=${_test_root_dir}/testsuite
_num_threads=`grep processor /proc/cpuinfo | wc -l`

case $_compiler_version in
    gcc-5.1.0)
        _host_compiler_root_dir=${_tool_root}/targets/Linux-x86_64/gcc-5.1.0
        _host_compiler_inc_dir=${_host_compiler_root_dir}/include/c++/5.1.0
        _host_compiler_lib_dir=${_host_compiler_root_dir}/lib64
        _host_compiler_bin_dir=${_host_compiler_root_dir}/bin
        _binutils_root_dir=${_tool_root}/targets/Linux-x86_64/binutils-2.25.1
    ;;
    *)
        echo "Error: unsupported compiler version $_compiler_version"
        exit 1
    ;;
esac

echo "************ BUILD JAIL SETUP ************"
echo "_tool_root:$_tool_root"
echo "_unix_build_rootfs_dir:${_unix_build_rootfs_dir}"
echo "_python_root_dir:${_python_root_dir}"
echo "_host_compiler_root_dir:${_host_compiler_root_dir}"
echo "_host_compiler_inc_dir:${_host_compiler_inc_dir}"
echo "_host_compiler_lib_dir:${_host_compiler_lib_dir}"
echo "_host_compiler_bin_dir:${_host_compiler_bin_dir}"
echo "_binutils_root_dir:${_binutils_root_dir}"
echo "_test_root_dir:${_test_root_dir}"
echo
echo

echo "************ test_harness.py SETUP ************"
echo "_toolkit_root_dir:${_toolkit_root_dir}"
echo "_toolkit_bin_dir:${_toolkit_bin_dir}"
echo "_num_threads:${_num_threads}"
echo "_log_level:${_log_level}"
echo "_gpu_arch:${_gpu_arch}"
echo
echo

echo "************ FINAL COMMAND************"
echo " cmd:  test_harness.py -p ${_num_threads} --log_level=${_log_level} --testroot ${_test_src_dir} --use_cudaroot_for_tools --cudaroot ${_toolkit_bin_dir} --gpu ${_gpu_arch} --testlist testlist.txt --mode build --run_from_testroot"
echo
echo


unix-build \
    --no-bind-mount-tools --no-devrel --native-personality \
    --extra-with-bind-point ${_unix_build_rootfs_dir}/bin /bin \
    --extra-with-bind-point ${_unix_build_rootfs_dir}/lib64 /lib64 \
    --extra-with-bind-point ${_unix_build_rootfs_dir}/usr /usr \
    --extra ${_host_compiler_root_dir} \
    --extra ${_binutils_root_dir} \
    --extra ${_python_root_dir} \
    --extra ${_toolkit_root_dir} \
    --extra ${P4ROOT} \
    --extra /proc \
    --source ${_test_root_dir} \
    --envvar P4ROOT=$P4ROOT \
    --envvar PATH=${_test_src_dir}:${_binutils_root_dir}/bin:${_python_root_dir}/bin:${_host_compiler_bin_dir}:/usr/bin:/bin \
    python ${_test_root_dir}/test_harness.py -p ${_num_threads}  --log_level=${_log_level} --testroot ${_test_src_dir} --use_cudaroot_for_tools --cudaroot ${_toolkit_bin_dir} --gpu ${_gpu_arch} --testlist testlist.txt --mode build --run_from_testroot


if [ $? -ne 0 ]; then
    echo "Error: unix-build command failed"
    exit 1
fi

}

function p4dc {
   p4 opened -c $1 | awk 'BEGIN { FS = "#" } // { print "p4 diff " $1 }' | csh | less
}

function install_driver {
  usage() { echo "Usage: install-driver [-c <cl-number>] -r" 1>&2; }
  cl=""
  unset COMPILER_DIR
  r=false
  ARCH_OS_MO=x86_64_Linux_debug/
  while true; do
    case $1 in
      -h|--help)
        usage
        return
        ;;
      -r|--release)
        r=true
        ARCH_OS_MO=x86_64_Linux_release/
        shift
        ;;
      -c|--changelist)
        cl=$2
        shift 2
        ;;
      *)
        shift
        break
        ;;
    esac
  done
  if [ -d /mnt/compilershare/compiler ]; then
    OLD_PATH=$PATH
    WORK_DIR=~/compiler
    export TEST_ROOT=$P4ROOT/sw/gpgpu
    export DRIVER_ROOT=$P4ROOT/sw/dev/gpu_drv/module_compiler
  fi
}