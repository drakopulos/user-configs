#!/bin/bash
# bash functions sourced in bashrc

man () {
  env LESS_TERMCAP_mb=$'\E[01;31m' \
      LESS_TERMCAP_md=$'\E[0;30;0;36m' \
      LESS_TERMCAP_me=$'\E[0m' \
      LESS_TERMCAP_se=$'\E[0m' \
      LESS_TERMCAP_so=$'\E[38;5;246m' \
      LESS_TERMCAP_ue=$'\E[0m' \
      LESS_TERMCAP_us=$'\E[04;38;5;146m' \
      man "$@"
}

function extract () {
if [ -f $1 ] ; then
  case $1 in
    *.tar.bz2)   tar xvjf $1     ;;
    *.tar.gz)    tar xvzf $1     ;;
    *.bz2)       bunzip2 $1      ;;
    *.rar)       unrar x $1      ;;
    *.gz)        gunzip $1       ;;
    *.tar)       tar xvf $1      ;;
    *.tbz2)      tar xvjf $1     ;;
    *.tgz)       tar xvzf $1     ;;
    *.zip)       unzip $1        ;;
    *.Z)         uncompress $1   ;;
    *.7z)        7z x $1         ;;
    *)           echo "'$1' cannot be extracted via >extract<" ;;
  esac
else
  echo "'$1' is not a valid file!"
fi
}

rre () {
  ls | while read -r FILE
do
  mv -v "$FILE" $(echo $FILE |
  tr ' ' '-' |
  tr '_' '-' |
  tr -d '[{}(),\!+#&<>]' |
  tr -d "\'" |
  tr '[A-Z]' '[a-z]' |
  sed 's/_-_/-/g' |
  sed 's/---/-/g' |
  sed 's/--/-/g')
  echo $0
  done
}

genpass () { cat /dev/urandom | tr -dc 'a-z0-4A-Z5-7a-z0-9' | fold -w 12 | head -n 4 ; }

genpass-char () {
cat /dev/urandom |
tr -dc 'a-zA-Z0-9-_!@#$%^&*()_+{}|:<>?=' |
fold -w 12 | head -n 4 |
grep -i '[!@#$%^&*()_+{}|:<>?=]'
}

aptsite () { xdg-open $(apt-cache show $1 | grep '\<http.*\>' | awk '{print $2}') &>/dev/null || echo nope ; }

aptshow () { apt-cache show $1 | grep Description-en -A 20 ; }

bak () { cp $@{,.bak}; echo "$@... $@.bak" ; }

dlog () { dialog --textbox $1 0 0 ; }

ytdl () { youtube-dl -x --audio-format=wav $1 ; }

md5al () { for i in *; do md5sum $i > $i.md5; done; }

srvoff () { sudo service $1 stop ; }

srvon () { sudo service $1 start ; }

indexpdf () { gs -dBATCH -pNOPAUSE -sDEVICE=pdfwrite -OutputFile=$1 $2 index.info ; }

dynex () { xrandr --output HDMI-1 --mode 1920x1080 --"$1" LVDS-1 ; }

sorttofile () {
  cp $1{,.bak}; echo "$1... $1.bak"
  sleep 1s
  cat $1 | sort > tmmp && cat tmmp > $1
  rm tmmp
  cat $1
}

cpdate () {
  date=$( date +%F )
  cp $1 $1_$date
}

netinfo () {
  /sbin/ifconfig | awk /'inet addr/ {print $2}'
  /sbin/ifconfig | awk /'Bcast/ {print $3}'
  /sbin/ifconfig | awk /'inet addr/ {print $4}'
  /sbin/ifconfig | awk /'HWaddr/ {print $4,$5}'
}
