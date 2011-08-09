#!/bin/bash

#�ļ�λ��
ctrlf="/mnt/Data/z/common/ctrl.dat" #��������
outf="/tmp/ListSelect.tmp"

#��������
declare -a tmp=(`cat $ctrlf`)    #�������ݴ���
up="${tmp[0]}"    #�ϼ�����
down="${tmp[1]}"    #�¼�����
left="${tmp[2]}"    #�������
right="${tmp[3]}"    #�Ҽ�����
pageup="${tmp[4]}"    #�Ϸ�ҳ������
pagedown="${tmp[5]}"    #�·�ҳ������
back="${tmp[6]}"    #���ؼ�����

#��ɫ����
titc='\E[1;31;40m'    #����
errc='\E[1;34;40m'    #����  û���б���Ŀ
color='\E[1;34;40m'    #��Ȩ  Made By Norman (ZHIYB)
linc='\E[1;32;40m'    #�ָ�  ###�ָ���###��ɫ
inc='\E[1;33;40m'    #��ʾ  ��ʾ����
declare -a listc=("'\E[0;34;40m' '\E[1;34;102m'") \
term=("'\E[0;34;40m' '\E[1;32;44m'")
light="\E[1;37;40m"    #����  ǿ������
end='\E[0m'    #����  ���س�ʼ��ɫ

#��ʾ����
if [ "$1" = "" ] ; then
  in_title="      �б�ѡ��" ; in_made="      Made by Norman (ZHIYB)"
  in_show="1" ; in_pagenum="0" ; in_init="0"
  declare -a in_list=( "'�б�ѡ�����'\
  '����: ���� ���� ���� ǿ�� ���� ��ʼ'\
  '����1: �������'\
  '����2: ���������Ϣ'\
  '����3: ��ѡ�������ʾ'\
  '����4: ѡ��������ʾ����ʾ?'\
  '����5: ÿҳ��ʾ����'\
  '����6: ��ʼѡ����(��0��ʼ)'\
  '����7: �б���'\
  '�б�����ϸ��Ϣ���ڶ�ҳ'\
  '���򷵻�ֵ: ѡ�����Ŀ(��0��ʼ)'\
  '����ֵ��0��255,���ɷ���256��'\
  '�б�������˵��:'\
  'ȫ���б�����\"\"��ס,��Ϊλ�ò���7'\
  '������֮���ÿո�ֿ�'\
  '��ð�ÿһ��ֱ���'\'\''��ס'\
  'ĳЩ�����ַ�����\\ת��'\
  '����:'\
  '�������ı�������ʹ��\E[32;41mecho\E[7mת��\E[27m����'\
  'λ�ò����������(��Ϊ��)'\
  '�������ʾ������'\
  '�������Զ���ѡ�����浽'\
  '\E[31m$outf�ļ���'\
  '��������ѡ����256������'" )
else
  in_title="$1" ; in_made="$2" ; in_err="$3"
  in_show="$4" ; in_pagenum="$5" ; in_init="$6"
  declare -a in_list=("$7") #�б���
  if [ "$in_init" = "" ] ; then in_init=0 ; fi
fi
lines="$linc################################################$end" #�ָ���
title="$titc$in_title$color$in_made$end"    #����
if [ "$in_show" = 1 ] ; then
  declare -a chl=("'------ ' '>>>>>> '") chr=("' ------' ' <<<<<<'")
else declare -a chl=("'' ''") chr=("'' ''")
fi

#����
prog_Auto(){
  ((pagenum=in_pagenum==0?$(tput lines)-4:in_pagenum))
  n=$lnum ; pages=0
  while ((n>pagenum)) ; do
    ((pages++)) ; ((n-=pagenum))
  done
}

#������
lnum=${#in_list[@]} ; prog_Auto
quit=0 ; dat=$in_init ; pageno=1
echo -ne '\E[?25l' ; stty -echo
until [ "$quit" = "1" ] ; do
  if [ "$pages" = "0" ] ; then
    n=0 ; page=$lnum #ҳ����ʾ��
  else
    page=0 ; pageno=1 ; n=$dat
    while ((n>((pagenum-1)))) ; do
      ((page+=pagenum)) ; ((n-=pagenum)) ; ((pageno++))
    done
    n=$page ; ((page+=pagenum))
    if ((page>=((lnum+pagenum)))) ; then
      ((n-=pagenum)) ; ((pageno--)) ; page=$lnum
    elif ((page>lnum)) ; then page=$lnum
    fi
  fi
  echo -e "\E[2J\E[1;1H$title\n$lines\n$inc���¼�ѡ��,���Ҽ���ҳ: ��$light$pageno$incҳ,��$light$((tmp=$pages+1))$incҳ$end"
  if [ "${#in_list[@]}" = "0" ] ; then
    echo -e "$errc$in_err$end" ; dat=0 ; quit=1
    read -s ; continue
  fi
  until [ "$n" = "$page" ] ; do
    echo -e "${term[((tmp=n++==dat))]}${chl[tmp]}${listc[tmp]}${in_list[((n-1))]}${term[tmp]}${chr[tmp]}$end"
  done
  read -sn 3 key
  if [ "$key" = "$up" ] ; then ((dat--))
    ((dat=dat==-1?lnum-1:dat))
  elif [ "$key" = "$down" ] ; then ((dat++))
    ((dat=dat==lnum?0:dat))
  elif [ "$key" = "$right" ] ; then ((dat+=pagenum))
    ((dat=dat>=lnum?lnum-1:dat))
  elif [ "$key" = "$left" ] ; then
    ((dat=dat>=lnum?lnum-pagenum:((dat<pagenum?0:dat-pagenum))))
  elif [ "$key" = "" ] ; then
    quit=1
  fi
  prog_Auto
done
echo -n $dat > "$outf" ; echo -ne '\E[?25h'
stty echo ; exit $dat
