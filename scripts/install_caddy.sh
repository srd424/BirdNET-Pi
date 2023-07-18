install_caddy_build_pre () {
  curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | sudo gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg
  curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | sudo tee /etc/apt/sources.list.d/caddy-stable.list
}

install_caddy_build () {
  mkdir -p $HOME/.cache/caddy
  cd $HOME/.cache/caddy
  apt-get -qqy download caddy
  apt-get -qq -s install caddy | grep ^Inst\ caddy | awk '{print $3}' | sed -e 's/^(//' >latest.txt
}

install_caddy_final () {
  cd $HOME/.cache/caddy
  dpkg -i caddy_$(cat latest.txt)_*.deb
}  

# vim: set ts=2 et sw=2:
