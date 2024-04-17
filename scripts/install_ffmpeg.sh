FFMPEG_URL_amd64=https://www.johnvansickle.com/ffmpeg/old-releases/ffmpeg-6.0-amd64-static.tar.xz
FFMPEG_MD5_amd64=bef7015ca2fd7f19057cad0262d970d2
FFMPEG_URL_arm64=https://www.johnvansickle.com/ffmpeg/old-releases/ffmpeg-6.0-arm64-static.tar.xz
FFMPEG_MD5_arm64=67ec92e54b3d0f5dbad4e72404c30af7

install_ffmpeg () {
  local tarf=$(mktemp)
  local arch=$(dpkg --print-architecture)
  local urlvar=FFMPEG_URL_$arch
  local md5var=FFMPEG_MD5_$arch

  if ! curl -o $tarf ${!urlvar}; then
    echo "Couldnt download static ffmpeg from ${!urlvar}"
    exit 1
  fi

  if [ "$(md5sum $tarf | awk '{print $1}')" != "${!md5var}" ]; then
    echo "Static ffmpeg tar file md5 did not match"
    exit 1
  fi

  sudo mkdir /usr/local/lib/ffmpeg
  sudo tar -C /usr/local/lib/ffmpeg --strip-components=1 -xJf $tarf
  rm $tarf
  sudo ln -s /usr/local/lib/ffmpeg/ffmpeg /usr/local/bin
}

