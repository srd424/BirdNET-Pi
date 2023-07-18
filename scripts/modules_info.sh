PKGS_build="swig cmake make libjpeg-dev zlib1g-dev python3-dev python3-pip python3-venv \
	debian-keyring debian-archive-keyring apt-transport-https gnupg"

PKGS_common="sqlite3 sox libsox-fmt-mp3 wget unzip curl bc lsof net-tools"

PKGS_server="${PKGS_common}"

PKGS_main="${PKGS_common} \
    ftpd php-sqlite3 alsa-utils avahi-utils php php-fpm php-curl php-xml \
    php-zip icecast2 caddy ffmpeg"

PKGS_local_recording="pulseaudio"

SVCS_server="birdnet_server"
SVCS_main="birdnet_analysis birdnet_start_server extraction birdnet_recording \
    caddy avahi-alias@$(hostname).local birdnet_stats spectrogram_viewer \
  chart_viewer birdnet_log web_terminal icecast2 livestream"

filter_pkg () {
  local var="$1"
  local pkg="$2"

  eval "NEED_$var=false"
  for mod in $MODULES_ENABLED; do
    local pkgvar="PKGS_${mod}"
    if echo "${!pkgvar}" | grep -E "(^| )$pkg(\$| )"; then
	eval "NEED_$var=true"
	eval PKGS_${mod}=\""$(echo "${!pkgvar}" | sed -re "s/(^| )$pkg(\$| )/ /g")"\"
    fi
  done
}
