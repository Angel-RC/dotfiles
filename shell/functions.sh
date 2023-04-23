function lsoff() {
	selected=$(ps axc | awk 'NR > 1' | awk '{print substr($0,index($0,$5))}' | sort -u | fzf)
	if [ ! -z $1 ]; then
  		lsof -r 2 -c "$selected"
	else
  		lsof -c "$selected"
	fi
}

function z() {
	fname=$(declare -f -F _z)

	[ -n "$fname" ] || source "$DOTLY_PATH/modules/z/z.sh"

	_z "$1"
}

function recent_dirs() {
	# This script depends on pushd. It works better with autopush enabled in ZSH
	escaped_home=$(echo $HOME | sed 's/\//\\\//g')
	selected=$(dirs -p | sort -u | fzf)

	cd "$(echo "$selected" | sed "s/\~/$escaped_home/")" || echo "Invalid directory"
}


cd() {
  # Esta funcion sobreescribe el comportamiento de cd.
  # Si se le pasa un directorio como parametro, actua igual que el clasico cd.
  # Si no se le pasa nada, te permite moverte entre directorios con fzf  
  if [[ $# -eq 0 ]]; then
    # No se ha pasado ningún parámetro, listar directorios disponibles
    local dir
    while true; do
      dir=$(echo "$(find -maxdepth 1 -path '*/\.*' -prune \
                -o -type d -print 2> /dev/null)\n.." | fzf +m)
      if [[ $dir == '.' ]]; then
        break
      fi
      builtin cd "$dir"
    done
  else
    # Se ha pasado al menos un parámetro, cambiar al directorio especificado
    builtin cd "$@"
  fi
}

cecho () {
 
    declare -A colors;
    colors=(\
        ['red']='\033[31m'\
        ['green']='\033[32m'\
        ['yellow']='\033[0;33m'\
        ['blue']='\033[34m'\
        ['magenta']='\033[35m'\
        ['cyan']='\033[36m'\
        ['white']='\033[0;37m'\
		['orange']='\033[33m'\
		['default']='\033[39m'\
    );
 
    local defaultMSG="No message passed.";
    local defaultColor="default";
    local defaultNewLine=true;
 
    while [[ $# -gt 1 ]];
    do
    key="$1";
 
    case $key in
        -c|--color)
            color="$2";
            shift;
        ;;
    esac
    shift;
    done
 
    message=${1:-$defaultMSG};   # Defaults to default message.
    color=${color:-$defaultColor};   # Defaults to default color, if not specified.
	
    echo -e "${colors[$color]}" "$@";
    tput sgr0; #  Reset text attributes to normal without clearing screen.
 
    return;
}
 
warning () {
 
    cecho -c 'yellow' "$@";
}
 
error () {
 
    cecho -c 'red' "$@";
}
 
information () {
 
    cecho -c 'blue' "$@";
}