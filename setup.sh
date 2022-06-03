#/bin/bash

SAVED_PWD=`pwd`
mkdir -p ~/tools
mkdir -p ~/tools/pwn
mkdir -p ~/tools/crypto

# enable SSH remote root login
echo "Setting up SSH ..."
echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
systemctl enable ssh
service ssh start

# Git
echo "Setting up Git..."
git config --global user.name wildcat
git config --global user.email letranhaitung@gmail.com
git config --global credential.helper store

git clone --quiet https://github.com/tacbliw/ctf ~/tools/ctf

# Vim
echo "Setting up Vim..."
cp /usr/share/vim/vimrc /usr/share/vim/vimrc.bak
cp ./vimrc /usr/share/vim/vimrc


# apt stuff, run upgrade first
#apt install -y --reinstall open-vm-tools-desktop
apt install -y python3-pip checksec gdb libmpc-dev strace elfutils gdbserver gdb-multiarch ropper checksec binutils patchelf || exit 1

# Python
echo "Setting up Python..."
rm -rf /bin/python
ln -s /bin/python3 /bin/python
python --version

pip3 install pwn pwntools angr pycryptodome z3-solver gmpy2 || exit 1

# pwninit
echo "Setting up pwninit..."
wget -O "/bin/pwninit" "https://github.com/io12/pwninit/releases/download/3.2.0/pwninit"
chmod +x /bin/pwninit

if [ -e ~/.zshrc ]; then
    echo 'alias "pwninit"="pwninit --template-path=~/tools/ctf/scripts/pwn/pwninit/base.py"' >> ~/.zshrc
else
    echo 'alias "pwninit"="pwninit --template-path=~/tools/ctf/scripts/pwn/pwninit/base.py"' >> ~/.bashrc
fi

# sublime
echo "Setting up Sublime..."
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
apt install apt-transport-https
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list

sudo apt-get update
sudo apt-get install sublime-text

# Autojump for zsh
echo "Setting up Autojump..."

git clone git://github.com/wting/autojump.git /usr/share/zsh-autojump
cd /usr/share/zsh-autojump
./install.py

if [ -e ~/.zshrc ]; then
    cat << EOF >> ~/.zshrc

if [[ -s /root/.autojump/etc/profile.d/autojump.sh ]]; then
    source /root/.autojump/etc/profile.d/autojump.sh
fi

EOF
fi

# pwn environment
dpkg --add-architecture i386
apt-get update

# pwndbg
echo "Setting up pwndbg..."

git clone --quiet https://github.com/pwndbg/pwndbg ~/tools/pwn/pwndbg
git clone --quiet https://github.com/scwuaptx/Pwngdb ~/tools/pwn/Pwngdb

cd ~/tools/pwn/pwndbg
./setup.sh

cp ${SAVED_PWD}/gdbinit ~/.gdbinit

# gems: one_gadget, seccomp-tools
echo "Setting up Gems..."
gem install one_gadget
gem install seccomp-tools

# ROPGadget
echo "Setting up ROPGadget..."
git clone --quiet https://github.com/JonathanSalwan/ROPgadget ~/tools/pwn/ROPGadget

# # ghidra
# echo "Setting up Ghidra..."
# 
# wget -P ~/tools/ https://ghidra-sre.org/ghidra_9.2.2_PUBLIC_20201229.zip
# cd ~/tools/
# unzip ./ghidra_9.2.2_PUBLIC_20201229.zip

# crypto stuff
echo "Setting up Crypto stuff..."

git clone --quiet https://github.com/cr-marcstevens/hashclash ~/tools/crypto/hashclash

git clone --quiet https://github.com/Ganapati/RsaCtfTool ~/tools/crypto/RsaCtfTool

git clone --quiet https://github.com/p4-team/crypto-commons ~/tools/crypto/crypto-commons
cd ~/tools/crypto/crypto-commons
python ./setup.py install


cd ${SAVED_PWD}
