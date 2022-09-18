if [ ! $TMUX ]
then
  if [ $(pgrep tmux) ]
  then
    tmux a
  fi
fi
