#!/bin/bash
admit="/tmp/admit.tmp"
temp="/opt/QtPalmtop/data/z/Install"
info="/opt/QtPalmtop/data/z/Software/Words.info"
data="/mnt/UsrDisk/words"
app="/tmp/Shell"

name="背单词软件"
version="V4.6"

declare -a update=("重新安装 升级安装")

prog_setup(){
  echo "安装中,请稍候..."
  mv "$data/save" "$data/.save"
  cp -rf * /
  [ $? = 0 ] && {
  echo "安装完成!"; sleep 2s; prog_info; return 1
  }
  echo "安装失败!"; sleep 2s; return 0
}
prog_uninstall(){
  cd /
  {
    read named; echo "$named 卸载中,请稍候..."
    while read line; do
      echo "$line"; rm "$line"
    done
  } < "$info"
  rm "$info"
  echo "卸载完成!"
  sleep 2s
}
prog_info(){
  echo "$name $version" > "$info"
  find -type f >> "$info"
}
prog_install(){
  $app/Msgbox.sh "4 14 0 0"\
  "'$name $version' '确认安装吗?'" "是 否"
  case $? in
  0 ) prog_setup; echo $? > $admit;;
  1 ) echo 0 > $admit;;
  esac
}
prog_select(){
  {
    read -a named
  } < "$info"
  $app/Msgbox.sh "4 14 0 0"\
  "'${named[*]}' '已安装'"\
  "'${update[$([ ${named[1]} = $version ])$?]}'\
  '卸载软件' '取消操作'"
  case $? in
  0 ) prog_setup; echo $? > $admit;;
  1 ) echo 0 > $admit; prog_uninstall;;
  2 ) echo 0 > $admit;;
  esac
}

cd "$temp"; echo 0 > $admit; clear
[ ! -e "$info" ] && prog_install && exit
prog_select; exit
