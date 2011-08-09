#!/bin/bash
admit="/tmp/admit.tmp"
temp="/opt/QtPalmtop/data/z/Install"
info="/opt/QtPalmtop/data/z/Software/Words.info"
data="/mnt/UsrDisk/words"
app="/tmp/Shell"

name="���������"
version="V4.6"

declare -a update=("���°�װ ������װ")

prog_setup(){
  echo "��װ��,���Ժ�..."
  mv "$data/save" "$data/.save"
  cp -rf * /
  [ $? = 0 ] && {
  echo "��װ���!"; sleep 2s; prog_info; return 1
  }
  echo "��װʧ��!"; sleep 2s; return 0
}
prog_uninstall(){
  cd /
  {
    read named; echo "$named ж����,���Ժ�..."
    while read line; do
      echo "$line"; rm "$line"
    done
  } < "$info"
  rm "$info"
  echo "ж�����!"
  sleep 2s
}
prog_info(){
  echo "$name $version" > "$info"
  find -type f >> "$info"
}
prog_install(){
  $app/Msgbox.sh "4 14 0 0"\
  "'$name $version' 'ȷ�ϰ�װ��?'" "�� ��"
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
  "'${named[*]}' '�Ѱ�װ'"\
  "'${update[$([ ${named[1]} = $version ])$?]}'\
  'ж�����' 'ȡ������'"
  case $? in
  0 ) prog_setup; echo $? > $admit;;
  1 ) echo 0 > $admit; prog_uninstall;;
  2 ) echo 0 > $admit;;
  esac
}

cd "$temp"; echo 0 > $admit; clear
[ ! -e "$info" ] && prog_install && exit
prog_select; exit
