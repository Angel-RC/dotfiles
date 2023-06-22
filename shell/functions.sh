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


#
# Usage: extract <file>
# Description: extracts archived files / mounts disk images
# Note: .dmg/hdiutil is macOS-specific.
#
# credit: http://nparikh.org/notes/zshrc.txt
extract () {
    if [ -f $1 ]; then
        case $1 in
            *.tar.bz2)  tar -jxvf $@                        ;;
            *.tar.gz)   tar -zxvf $@                        ;;
            *.bz2)      bunzip2 $@                          ;;
            *.dmg)      hdiutil mount $@                    ;;
            *.gz)       gunzip $@                           ;;
            *.tar)      tar -xvf $@                         ;;
            *.tbz2)     tar -jxvf $@                        ;;
            *.tgz)      tar -zxvf $@                        ;;
            *.zip)      unzip $@                            ;;
            *.ZIP)      unzip $@                            ;;
            *.pax)      cat $@ | pax -r                     ;;
            *.pax.Z)    uncompress $@ --stdout | pax -r     ;;
            *.rar)      unrar x $@                          ;;
            *.Z)        uncompress $@                       ;;
            *)          echo "'$1' cannot be extracted/mounted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

cd() {
  # Esta funcion sobreescribe el comportamiento de cd.
  # Si se le pasa un directorio como parametro, actua igual que el clasico cd.
  # Si no se le pasa nada, te permite moverte entre directorios con fzf  
  if [[ $# -eq 0 ]]; then
    # No se ha pasado ningún parámetro, listar directorios disponibles
    local dir
    while true; do
      dir=$(find . -type d -print 2>/dev/null | ls -a | fzf --prompt="Selecciona un directorio> ")
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