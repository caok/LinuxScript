#!/bin/bash
# ARGV[0] - enviroment

pause() {
  read -p "$*"
}

echo "Are you bootstrap for development $1? (Y/N) (default: N) __"
read dorm
dorm=${dorm:=N}

if [ $dorm = Y ]; then
  echo "-----Start bootstrap for development-----"
  sudo apt-get update
  sudo apt-get -y install git-core curl zsh exuberant-ctags vim autoconf automake openssl \
   build-essential libc6-dev libreadline6 libreadline6-dev zlib1g zlib1g-dev libssl-dev libyaml-dev \
   ncurses-dev libtool bison libxslt1-dev libxml2 libxml2-dev libqt4-dev tmux

  curl -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | bash
  chsh -s `which zsh`
  curl https://raw.github.com/wongyouth/vimfiles/master/install.sh | bash
else
  echo "-----Start bootstrap for production-----"
  sudo apt-get update
  sudo apt-get -y install git-core curl vim openssl ncurses-dev libtool bison tmux\
   build-essential libc6-dev libreadline6 libreadline6-dev zlib1g zlib1g-dev libssl-dev libyaml-dev \
fi

#sudo apt-get -y install git-core curl zsh exuberant-ctags vim autoconf automake openssl \
#  build-essential libc6-dev libreadline6 libreadline6-dev zlib1g zlib1g-dev libssl-dev libyaml-dev \
#  mysql-server libmysqlclient-dev ncurses-dev libtool bison libxslt1-dev libxml2-dev tmux
#
#

install_nodejs(){
  if [ $dorm = Y ]; then
    curl https://raw.github.com/creationix/nvm/v0.4.0/install.sh | sh
    sudo npm install -g express supervisor
  else
    sudo apt-get install python-software-properties python g++ make
    sudo add-apt-repository ppa:chris-lea/node.js
    sudo apt-get update
    sudo apt-get install nodejs

    echo "registry = http://registry.cnpmjs.org" >> .npmrc

    sudo npm install -g express pm2
  fi
}

install_ruby(){
  curl https://raw.github.com/fesplugas/rbenv-installer/master/bin/rbenv-installer | bash
  rbenv bootstrap-ubuntu-12-04
  rbenv install 2.1.1
  gem update --system
  gem install bundler rake
  rbenv rehash
}

install_mysql(){
  sudo apt-get -y install mysql-server libmysqlclient-dev 
}

install_nginx(){
  sudo apt-get -y install nginx
  sudo service nginx start
}

#pause "Installing nodejs...  [press Enter]"
#install_nodejs

#pause "Installing ruby...  [press Enter]"
#install_ruby

#pause "Installing mysql...  [press Enter]"
#install_mysql

#pause "Installing nginx...  [press Enter]"
#install_nginx
