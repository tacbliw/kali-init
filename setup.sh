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
apt install -y python3-pip checksec gdb libmpc-dev strace elfutils gdbserver 1>/dev/null

# Python
echo "Setting up Python..."
rm -rf /bin/python
ln -s /bin/python3 /bin/python
python --version

pip3 install pwn pwntools angr PyCrypto z3-solver gmpy2 1>/dev/null

# pwninit
echo "Setting up pwninit..."
wget -O "/bin/pwninit" "https://github.com/io12/pwninit/releases/download/2.2.0/pwninit"
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

cat << EOF >> /etc/hosts
127.0.0.1 www.sublimetext.com
127.0.0.1 license.sublimehq.com
EOF

echo "++++++++++++ KEY ++++++++++++"
cat << EOF
----- BEGIN LICENSE -----
Member J2TeaM
Single User License
EA7E-1011316
D7DA350E 1B8B0760 972F8B60 F3E64036
B9B4E234 F356F38F 0AD1E3B7 0E9C5FAD
FA0A2ABE 25F65BD8 D51458E5 3923CE80
87428428 79079A01 AA69F319 A1AF29A4
A684C2DC 0B1583D4 19CBD290 217618CD
5653E0A0 BACE3948 BB2EE45E 422D2C87
DD9AF44B 99C49590 D2DBDEE1 75860FD2
8C8BB2AD B2ECE5A4 EFC08AF2 25A9B864
------ END LICENSE ------
EOF
echo "++++++++++ END KEY ++++++++++"

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

git clone --quiet https://github.com/pwndbg/pwndbg ~/tools/pwn/pwndbg --quiet
git clone --quiet https://github.com/scwuaptx/Pwngdb ~/tools/pwn/Pwngdb

cd ~/tools/pwn/pwndbg
./setup.sh

cp ./gdbinit ~/.gdbinit

# gems: one_gadget, seccomp-tools
echo "Setting up Gems..."
gem install one_gadget
gem install seccomp-tools

# ROPGadget
echo "Setting up ROPGadget..."
git clone --quiet https://github.com/JonathanSalwan/ROPgadget ~/tools/pwn/ROPGadget

# ghidra
echo "Setting up Ghidra..."

wget -P ~/tools/ https://ghidra-sre.org/ghidra_9.2.2_PUBLIC_20201229.zip
cd ~/tools/
unzip ./ghidra_9.2.2_PUBLIC_20201229.zip

# crypto stuff
echo "Setting up Crypto stuff..."

git clone --quiet https://github.com/cr-marcstevens/hashclash ~/tools/crypto/hashclash

git clone --quiet https://github.com/Ganapati/RsaCtfTool ~/tools/crypto/RsaCtfTool

git clone --quiet https://github.com/p4-team/crypto-commons ~/tools/crypto/crypto-commons
cd ~/tools/crypto/crypto-commons
python ./setup.py install


cd ${SAVED_PWD}
