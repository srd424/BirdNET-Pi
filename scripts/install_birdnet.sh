#!/usr/bin/env bash
# Install BirdNET script
set -x # Debugging
exec > >(tee -i installation-$(date +%F).txt) 2>&1 # Make log
set -e # exit installation if anything fails

my_dir=$HOME/BirdNET-Pi
export my_dir=$my_dir

cd $my_dir/scripts || exit 1

arch=$(uname -m)
if [ $arch != "aarch64" ] && [ $arch != "x86_64" ];then
  echo "BirdNET-Pi requires a 64-bit OS.
It looks like your operating system is using $(uname -m),
but would need to be aarch64 or x86_64.
Please take a look at https://birdnetwiki.pmcgui.xyz for more
information"
  exit 1
fi

#Install/Configure /etc/birdnet/birdnet.conf
./install_config.sh || exit 1
sudo -E HOME=$HOME USER=$USER ./install_services.sh || exit 1
source /etc/birdnet/birdnet.conf

source $my_dir/set_modules.sh

install_birdnet() {
  cd ~/BirdNET-Pi || exit 1
  echo "Establishing a python virtual environment"
  python3 -m venv birdnet
  source ./birdnet/bin/activate
  
  local debarch="$(dpkg --print-architecture)"

  local mod
  local reqd=$HOME/BirdNET-Pi/reqs
  for mod in common $MODULES_ENABLED; do
    local reqf=$reqd/$mod-$debarch.txt
    [ ! -e $reqf ] && reqf=$reqd/$mod.txt
    [ ! -e $reqf ] && continue
    pip3 install -U -r $reqd
  done
}

[ -d ${RECS_DIR} ] || mkdir -p ${RECS_DIR} &> /dev/null

install_birdnet

cd $my_dir/scripts || exit 1

./install_language_label_nm.sh -l $DATABASE_LANG || exit 1



exit 0
