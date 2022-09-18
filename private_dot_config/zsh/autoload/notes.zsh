function note() {
  viewer=""
  file=""
  case $1 in
    '-v')
        viewer="lookatme"
        # if [ ! $2 ]; then echo "Please include a file name"; return 1; fi
        file=$2
        ;;
    *)
        viewer=$EDITOR
        file=$1
  esac
  if [ $file ]
  then
    notefile=$XDG_DATA_HOME/notes/$file
    mkdir -p "${notefile%/*}" && touch "$notefile"
  else
    notefile="$XDG_DATA_HOME/notes/Note-$(date +%F).md"
    if [ ! -f $notefile ]; then
      echo "# $(date +"%a %d %b %Y")" > $notefile
    fi
  fi
  if [ "$viewer" = 'lookatme' ]
  then
      $viewer $notefile
  else
      $viewer -c "norm G" $notefile "+cd ${XDG_DATA_HOME}/notes"
  fi
}

function notes() {
  nvim $XDG_DATA_HOME/notes "+cd ${XDG_DATA_HOME}/notes"
}
