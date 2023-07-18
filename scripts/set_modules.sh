

_set_modvar () {
	local mod="$1"
	local val="$2"

	eval "MOD_${mod}=$val"
}

_set_modules () {

	local _ALL_MODULES="server main local_recording"

	if [ -z "$MODULES_ENABLED" -o "$MODULES_ENABLED" = "all" ]; then
		MODULES_ENABLED="${_ALL_MODULES}"
	fi

	local mod
	for mod in $_ALL_MODULES; do
		_set_modvar $mod false
	done
	_set_modvar "build" false

	for mod in $MODULES_ENABLED; do
		_set_modvar $mod true
	done

}

_set_modules
