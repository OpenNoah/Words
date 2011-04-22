#!/bin/bash
data="/mnt/UsrDisk/words"
data="$PWD/words"
titc='\E[1;31;40m'
color='\E[1;34;40m'
linc='\E[1;32;40m'
timec='\E[1;36;40m'
inc='\E[1;33;40m'
listc="\E[1;32;44m"
inp='\E[1;37;40m'
textc="\E[0;37;40m"
tipc="\E[0;37;40m"
numc="\E[1;34;40m"
light="\E[1;37;40m"
swc="\E[1;37;47m"
end='\E[0m'
lines="$linc################################################$end"
title="$titc 单词默写 ${color}Made by Norman (ZHIYB) ${swc}h$color ${swc}d$end ${swc}q$end"
tip="$tipc ${light}l$tipc看一下 ${light}p$tipc上一个 ${light}n$tipc下一个 ${light}s$tipc选词 ${light}q$tipc返回 $numc"
help="$inc Words and Expressions 默写程序 帮助说明$end"
helps="$textc 输入${light}h$textc以显示此帮助! ${light}d$textc最小化 $light"
cont="$textc按输入键继续...$end"
prog_quit(){
	echo -e "$inc退出...$end"
	killall embeddedkonsole
	exit 0
}
prog_desk(){
	echo -e "$inc返回桌面...$end"
	/opt/QtPalmtop/bin/qcop "QPE/System" "xxExecute(QString)" "qpe"
}
prog_msg(){
	echo -e "$inc检索文件信息中...$end"
	line1=0
	n=0
	while read line ; do
		if [ "$line1" = "0" ] ; then
			word[$n]="$line"
			line1=1
		else
			mean[$n]="$line"
			line1=0
			let n++
		fi
	done < "$data/$dat"
	num=$n
	n=0
}
prog_help(){
	clear
	echo -e "$title"
	echo -e "$lines"
	echo -e "$help"
	echo -e "$helps基本说明:$end"
	echo -e "$textc文件选择: 输入$light文件名$textc以选择,可用$light$textc自动完成功能。$end"
	echo -e "$textc单词输入: 输入$light正确$textc的单词,会显示$light正确$textc,否则显示$light错误$textc。$end"
	echo -e "$cont"
	read -s tmp
	clear
	echo -e "$title"
	echo -e "$lines"
	echo -e "$help"
	echo -e "$helps其它选项:$end"
	echo -e "$textc文件选择: ${light}q$textc退出 共有: ${light}h$textc帮助 ${light}d$textc最小化$end"
	echo -e "$textc单词输入: ${light}p$textc上一个 ${light}n$textc下一个 ${light}s$textc选词 ${light}l$textc看一秒 ${light}q$textc返回$end"
	echo -e "$cont"
	read -s tmp
	clear
	echo -e "$title"
	echo -e "$lines"
	echo -e "$help"
	echo -e "$helps单词选择:$end"
	echo -e "$textc单词输入${light}->$textc输入${light}s$textc选择单词: 输入单词$light序号$textc,确认后转到。$end"
	echo -e "$textc输入${light}h$textc帮助,${light}d$textc最小化,${light}q$textc返回单词默写$end"
	echo -e "$cont"
	read -s tmp
}
quit=0
cd $data
while : ; do
	clear
	echo -e "$title"
	echo -e "$lines"
	echo -e "$timec `date`$end"
	echo -e "$inc文件列表: ${light}h$textc帮助 ${light}d$textc最小化 ${light}q$textc退出$end"
	echo -e "$listc`ls -1`$end"
	echo -e "$inc选择单词表文件:$end"
	echo -en "$inp"
	read -e dat
	echo -en "$end"
	case "$dat" in
		q | Q )
			prog_quit;;
		h | H )
			prog_help
			continue;;
		d | D )
			prog_desk
			continue;;
		* )
			if [ -f "$data/$dat" ] ; then
				if [ -s "$data/$dat" ] ; then
					prog_msg
					clear
					echo -e "$title"
					echo -e "$lines"
					echo -e "$inc 文件信息: $dat$end"
					echo -e "$textc 单词总数: $light$num$end"
					echo -e "$textc 第一个 : $light${mean[n]}$end"
					echo -e "$textc 最后一个: $light${mean[`expr $num - 1`]}$end"
					echo -e "$cont"
					read -s tmp
				else
					echo -e "$inc这是空文件!!!$end"
					usleep 500000
					continue
				fi
			else
				echo -e "$inc输入错误!!!$end"
				usleep 500000
				continue
			fi;;
	esac
	until [ "$n" = "$num" ] ; do
		clear
		echo -e "$title"
		echo -e "$lines"
		echo -e "$timec `date`$end"
		echo -e "$tip`expr $n + 1`/$num$end"
		echo -e "$inc${mean[n]}$end"
		echo -en "$inp"
		read -e input
		echo -en "$end"
		if [ "$input" = "${word[n]}" ] ; then
			echo -e "$inc正确!$end"
			let n++
		else
			case "$input" in
				l | L )
					echo -e "$inc看一下: $inp${word[n]}$end";;
				p | P )
					if [ "$n" = "0" ] ; then
						echo -e "$inc这是第一个!!!$end"
					else
						echo -e "$inc上一个...$end"
						let n--
					fi;;
				n | N )
					let n++
					if [ "${word[n]}" = "" ] ; then
						echo -e "$inc这是最后一个!!!$end"
						let n--
					else
						echo -e "$inc下一个...$end"
					fi;;
				q | Q )
					echo -e "$inc返回文件列表...$end"
					quit=1
					n=$num;;
				d | D )
					prog_desk;;
				s | S )
					clear
					echo -e "$title"
					echo -e "$lines"
					echo -e "$timec `date`$end"
					echo -e "$inc单词选择: 共$num个,请从中选择! ${light}q$inc返回$inp"
					read -e select
					case "$select" in
						h | H )
							prog_help;;
						d | D )
							prog_desk;;
						q | Q )
							echo -e "$inc返回单词...$end";;
						*[!0-9]* | "" )
							echo -e "$inc选择错误!!!$end";;
						* )
							select=`expr $select + 0`
								if (( "$select" < "1" )) ; then
									echo -e "$inc选择范围超出下限${light}1$inc!$end"
								elif (( "$select" > "$num" )) ; then
									echo -e "$inc选择范围超出上限$light$num$inc!$end"
								else
									echo -e "$inc选择成功! $numc$select/$num$end"
									let n=$select-1
									echo -e "$textc${mean[n]}$end"
								fi;;
						esac;;
					h | H )
						prog_help;;
					* )
						echo -e "$inc错误!$end";;
				esac
			fi
			usleep 500000
		done
		if [ "$quit" = "0" ] ; then
			clear
			echo -e "$title"
			echo -e "$lines"
			echo -e "$timec `date`$end"
			echo -e "$inc本组单词已背完,返回文件列表。$end"
			sleep 1s
		fi
	done
