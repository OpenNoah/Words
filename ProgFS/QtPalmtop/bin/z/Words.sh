#!/bin/bash

#�ļ�λ��
app="/opt/QtPalmtop/bin/z"
init_data="/mnt/UsrDisk/words"
data="$init_data"
tmpf="/tmp/Words_filelist.tmp"
ltmp="/tmp/ListSelect.tmp"
save="$data/.save"
savep="$save/Settings.conf"

#��������
n=0; declare -a level word mean sets file \
lshow=("ȫ�� 1�� 2�� 3�� 4�� 5��") saved choose \
order tmp on_off=("�ر� ����") true false dir \
wordsnum

#ת������
titc='\E[1;31;40m'; errc='\E[1;34;40m'
color='\E[1;34;40m'; comc='\E[31m'; wmc='\E[35m'
wdc='\E[94m'; wfc='\E[92m'; wnc='\E[92m'
linc='\E[1;32;40m'; timec='\E[1;36;40m'
inc='\E[1;33;40m'; inp='\E[1;37;40m'
textc="\E[0;37;40m"; tipc="\E[0;37;40m"
numc="\E[1;34;40m"; light="\E[1;37;40m"
swc="\E[1;37;47m"; end='\E[0m'; del='\E[2K'
up1='\E[1A\E[0G'; hide='\E[?25l'; shows='\E[?25h'

#��ʾ����
lines="$linc################################################$end"    #�ָ���
title="$titc      ����Ĭд   ${color}Made by Norman (ZHIYB)    ${swc}h$color ${swc}d$end ${swc}q$end"    #����
tip="$tipc   ${light}l$tipc��һ�� ${light}p$tipc��һ�� ${light}n$tipc��һ�� ${light}s$tipcѡ�� ${light}q$tipc����  $numc"    #ѡ����ĸ��ʾ
help="$inc   Words and Expressions  Ĭд����  ����˵��$end"    #����˵������
helps="$textc            Ĭд����$light�Ľ���$end"
cont="\n$textc��$light�����$textc����...$end"

#����
prog_quit(){ #�����˳�
  echo -e "$inc�˳�...$end"
  killall embeddedkonsole; exit 0
}
prog_desk(){ #��������
  echo -e "$inc��������...$end"
  /opt/QtPalmtop/bin/qcop "QPE/System" "xxExecute(QString)" "qpe"
}
prog_msg(){ #��ȡ�ļ���Ϣ
  echo -ne "$hide$del$inc��ȡ�ļ���Ϣ��...\n$del$textc$dat$end$up1"
  line1=0; n=0; means=""; wordselect=""; unset word[@] mean[@]
  while read line; do
    word[n]="$line"; read line; mean[n++]="$line"
  done < "$data/$dat"
  num=$n; n=0
}
prog_help(){ #����ҳ��
  clear
  echo -e "$title\n$lines\n$help\n$lightSorry...$helps
$textc    û�а������ݡ�����$end"
  read -s tmp
}
prog_filesearch(){ #�����ļ��б�
  ls="$(ls -1)"; dirnum=0
  unset dir[@] file[@] flist wordsnum
  [ "$PWD" != "$init_data" ] && {
    dir[0]=".."; ((dirnum++))
  }
  for ((m=1;m<=$(echo "$ls" | wc -l);m++)); do
    dat="$(echo "$ls" | sed -n "${m}p")"
    if [ -d "$dat" ]; then
      dir[dirnum++]="$dat"
    elif [ -f "$dat" ]; then
      file[${#file[@]}]="$dat"
      prog_msg; wordsnum[${#wordsnum[@]}]=$num
    fi
  done
  for ((n=0;n<dirnum;n++)); do
    [ $n = 0 ] && [ "${dir[n]}" = ".." ] && {
      flist="$flist '$comc �����ϼ�Ŀ¼ '"; continue
    }
    flist="$flist '$wdc ${dir[n]} $wmc-> �ļ��� '"
  done
  for ((n=0;n<${#file[@]};n++)); do
    flist="$flist '$wfc ${file[n]} $wmc-> ��������:$wnc${wordsnum[n]} '"
  done
  lnum=$((dirnum+${#file[@]}))
  saved[0]=$((saved[0]<lnum?saved[0]:0))
}
prog_fileselect(){ #��ʾ�ļ��б�
  tmp=0
  until [ "$tmp" = 1 ]; do
    prog_filesearch
    $app/List.sh "      ����Ĭд"\
    "   ${PWD:$(dirname "$init_data" | wc -L)+1}" "" 1 0 "${saved[0]}"\
    "$flist '$comc ��    �� ' '$comc �� С �� '\
    '$comc ѡ    �� ' '$comc ��    �� '"
    dat=$(<$ltmp)
    case "$dat" in
    "$lnum" ) prog_help ;;
    $((lnum+1)) ) prog_desk ;;
    $((lnum+2)) ) prog_set ;;
    $((lnum+3)) ) prog_quit ;;
    * ) ((dat<dirnum)) && {
        cd "${dir[dat]}"; data="$PWD"; saved[0]=0
        prog_position; continue
      }
      saved[0]=$dat; dat=${file[dat-dirnum]}; tmp=1;;
    esac
  done
}
prog_set(){ #����ѡ��
  export quit=0 tmp2=0
  until [ $quit = 1 ]; do
    $app/List.sh "      Ĭд����"\
    "      Made By Norman (ZHIYB)" "" 1 0 $tmp2\
    "' Ĭд���ʷ�Χ(����): ${lshow[set_level]} '\
    ' ��һ�µȴ�ʱ��: $Look_Time��\
$([ $Look_Time = 0 ] && echo "(�ȴ�����)") '\
    ' ���ʼ����Զ�����: ${on_off[auto_level]} '\
    '$comc ȷ    �� '"
    tmp2=$?
    case $tmp2 in
    0 ) ((set_level=set_level==5?0:set_level+1));;
    1 ) ((Look_Time=Look_Time==5?0:Look_Time+1));;
    2 ) auto_level=$((1-auto_level));;
    3 ) quit=1;;
    esac
  done
}
prog_choose(){ #����ѡ��
  quit=0
  until [ "$quit" = 1 ]; do
    quit=1; prog_save
    $app/List.sh "      ����ѡ��"\
    "      Made By Norman (ZHIYB)" ""\
    1 0 0 "' ���ʼ���: ${lshow[level[order[n]]]} '\
    ' ѡ�񵥴� '\
    '$comc ȷ    �� '"
    case $? in
    0 ) quit=0
      level[order[n]]=$((level[order[n]]==5?1:level[order[n]]+1)) ;;
    1 ) prog_select ;;
    2 ) : ;;
    esac
  done
  quit=0
}
prog_select(){ #����ѡ��
  echo -e "$inc���������б���...$end"
  $app/List.sh "      ����ѡ��"\
  "      Made By Norman (ZHIYB)" "" 0 0 "$n"\
  "$(for ((m=0;m<${#order[@]};m++)); do
    echo -ne "'No.$((m+1)) -> ${mean[order[m]]}' "
  done)\
  '$comc>>>>>>  ȡ    ��  <<<<<<'"
  m=$(<$ltmp)
  case $m in
  "$num" ) : ;;
  * ) n=$m ;;
  esac
}
prog_Atoa(){ #��дתСд
  for letters in "A a" "B b" "C c" "D d" "E e" "F f" "G g" "H h" "I i" "J j" "K k" "L l" "M m" "N n" "O o" "P p" "Q q" "R r" "S s" "T t" "U u" "V v" "W w" "X x" "Y y" "Z z"; do
    declare -a letter=("$letters")
    tmp=${tmp//${letter[0]}/${letter[1]}}
  done
}
prog_save(){ #����浵
  mkdir -p "$save"
  echo "$set_level ${saved[0]} $Look_Time $auto_level
$PWD" > "$savep"
  echo "$set_level ${saved[1]}
${level[@]}
${order[@]}" > "$save/$dat.sav"
}
prog_setload(){ #��ȡ��������
  [ ! -e "$savep" ] && {
    saved[0]=0; set_level=0; Look_Time=1
    auto_level=0; prog_position; return
  }
  {
    read -a sets; read sets2
  } < $savep
  n=0; set_level=${sets[n++]}; saved[0]=${sets[n++]}
  Look_Time=${sets[n++]}; auto_level=${sets[n++]}
  [ "$sets2" != "" ] && {
    cd "$sets2"; saved[0]=$(($?==0?saved[0]:0)); data="$PWD"
  }
  [ "$Look_Time" = "" ] && Look_Time=1
  [ "$auto_level" = "" ] && auto_level=1
  prog_position
}
prog_load(){ #��ȡ���ʴ浵
  [ ! -e "$save/$dat.sav" ] && {
    saved[1]=0; saved[2]=0; saved[3]=0
    for ((n=0;n<num;n++)); do level[n]=1; done
    return 0
  }
  {
    read -a tmp1; read -a level; read -a order
  } < "$save/$dat.sav"
  saved[1]="${tmp1[1]}"; saved[2]="${tmp1[0]}"; saved[3]=1
  for ((n=${#level[@]};n<num;n++)); do
    level[n]=1
  done
  [ ${#order[@]} = 0 ] && order=($(seq 0 $((num-1))))
}
prog_level(){ #�������
  unset order[@]
  [ $set_level = 0 ] &&\
  order=($(seq 0 $((${#level[@]}-1)))) && return 0
  for ((n=0;n<${#level[@]};n++)); do
    [ ${level[n]} = $set_level ] &&\
    order[${#order[@]}]=$n
  done
}
prog_continue(){ #Ĭд˳��ѡ��
  saved[1]=0
  $app/List.sh "      Ĭд˳��"\
  "      Made By Norman (ZHIYB)" "" 1 0 0\
  "$([ ${saved[3]} = 1 ] && echo "����Ĭд")
  ˳��Ĭд ����Ĭд ���˳�� '$comc�����б�'"
  case $? in
  $((saved[3]-1)) ) prog_load; return 0;;
  ${saved[3]} ) return 0;;
  $((saved[3]+1)) ) prog_invert; return 0;;
  $((saved[3]+2)) ) prog_random; return 0;;
  $((saved[3]+3)) ) return 1;;
  esac
}
prog_invert(){ #��������
  unset tmp[@]
  declare -a tmp=(${order[@]}); unset order[@]
  for ((n=0;n<num;n++)); do
    order[n]=${tmp[num-n-1]}
  done
}
prog_random(){ #���˳��
  for ((n=0;n<num;n++)); do
    tmp=${order[n]}
    RanNum=$((RANDOM%(num-n)+n))
    order[n]=${order[RanNum]}
    order[RanNum]=$tmp
  done
}
prog_position(){ #�洢λ��
  save="$data/.save"
}

#������
quit=0; mkdir -p "$data" "$save"
cd "$data"; prog_setload
while :; do
  prog_fileselect
  if [ -f "$data/$dat" ]; then
    if [ -s "$data/$dat" ]; then
      prog_msg; prog_load; prog_level
      if [ ${#order[@]} = 0 ]; then
        echo -e "$incû��${lshow[set_level]}����,Ĭдȫ������!$end"
        m=$set_level; set_level=0; prog_msg
        sleep 1s; set_level=$m; order=($(seq 0 $((num-1))))
      else num=${#order[@]}
      fi
      prog_continue || continue
      ((saved[1]>num)) && saved[1]=0
      echo -e "\E[2J\E[1;1H$title\n$lines\n$inc   �ļ���Ϣ: $dat$end\n$textc   ��������: $light$num$end\n$textc   ��һ��  : $light${mean[order[0]]}$end\n$textc   ���һ��: $light${mean[order[((num-1))]]}$end$cont"
      read -s tmp
    else
      echo -e "$inc���ǿ��ļ�!!!$end"
      usleep 50000; continue
    fi
  else
    echo -e "$inc�ļ�����!!!$end"
    usleep 500000; continue
  fi
  for ((n=0;n<num;n++)); do true[n]=0; false[n]=0; done
  n=$((saved[2]==set_level?saved[1]:0)); echo -ne "$shows"
  until [ "$n" = "$num" ]; do
    saved[1]=$n; prog_save
    echo -e "\E[2J\E[1;1H$title\n$lines\n$timec   $(date)$end\n$tip$((n+1))/$num$end\n$inc${mean[order[n]]}$inp"
    read -e input; echo -en "$end"
    tmp="$input"; prog_Atoa; input="$tmp"
    tmp="${word[order[n]]}"; prog_Atoa; words="$tmp"
    if [ "$input" = "$words" ]; then
      [ "$auto_level" = 1 ] && {
        level[order[n]]=$((level[order[n]]==1?1:level[order[n]]-true[n])); true[n]=$((1-true[n]))
      }
      echo -e "$inc��ȷ!  $light${word[order[n]]}  ${lshow[level[order[n++]]]}$end"
    else
      case "$input" in
      l ) [ "$auto_level" = 1 ] && {
          level[order[n]]=$((level[order[n]]==5?5:level[order[n]]+false[n])); false[n]=$((1-false[n]))
        }
        echo -e "$inc��һ��:  $inp${word[order[n]]}  ${lshow[level[order[n]]]}$end"
        sleep ${Look_Time}s
        [ $Look_Time = 0 ] && read -s; continue;;
      p )
        if [ "$n" = "0" ]; then
          echo -e "$inc���ǵ�һ��!!!$end"
        else
          echo -e "$inc��һ��...$end"; ((n--))
        fi ;;
      n ) ((n++))
        if [ "${order[n]}" = "" ]; then
          echo -e "$inc�������һ��!!!$end"; ((n--))
        else
          echo -e "$inc��һ��...$end"
        fi ;;
      q ) echo -e "$inc�����ļ��б�...$end"
        quit=1; n=$num ;;
      d ) prog_desk ;;
      s ) prog_choose ;;
      h ) prog_help ;;
      quit ) prog_quit ;;
      * ) [ "$auto_level" = 1 ] && {
          level[order[n]]=$((level[order[n]]==5?5:level[order[n]]+false[n])); false[n]=$((1-false[n]))
        }
        echo -e "$inc����!  $light${lshow[level[order[n]]]}$end" ;;
      esac
    fi
    usleep 500000
  done
  if [ "$quit" = "0" ]; then
    saved[1]=0; prog_save; clear
    echo -e "$title\n$lines\n$timec   $(date)$end\n$inc���鵥���ѱ���,�����ļ��б�$end"
    sleep 1s
  fi
done
