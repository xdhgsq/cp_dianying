#!/bin/bash
#set -x
#获取当前脚本目录copy脚本之家
Source="$0"
while [ -h "$Source"  ]; do
    dir_file="$( cd -P "$( dirname "$Source"  )" && pwd  )"
    Source="$(readlink "$Source")"
    [[ $Source != /*  ]] && Source="$dir_file/$Source"
done
dir_file="$( cd -P "$( dirname "$Source"  )" && pwd  )"
red="\033[31m"
green="\033[32m"
yellow="\033[33m"
white="\033[0m"

#企业微信
weixin_line="------------------------------------------------"
wrap="%0D%0A%0D%0A" #Server酱换行
wrap_tab="     "
current_time=$(date +"%Y-%m-%d")

#推送log日志到server酱的时间
push_server_time="22"
red="\033[31m"
green="\033[32m"
yellow="\033[33m"
white="\033[0m"


start() {
cat > $dir_file/tmp/dianying_name.txt <<EOF
	赘婿		Y:\video\动漫\赘婿 (2023)\S02
	日月同错	Y:\video\动漫\日月同错\S01
	电影	Y:\video\电影
	香港三级	Y:\video\香港三级
	动漫电影	Y:\video\动漫电影
	回铭之烽火三月	Y:\video\动漫\回铭之烽火三月\S01
	原来我早就无敌了	Y:\video\动漫\原来我早就无敌了\S02
	正邪	Y:\video\动漫\正邪\S01
	宗门里除了我都是卧底	Y:\video\动漫\宗门里除了我都是卧底\S01
	关于我转生变成史莱姆这档事	Y:\video\动漫\关于我转生变成史莱姆这档事\S03
	廉政行动		Y:\video\电视剧\廉政行动\S01
	巾帼枭雄之悬崖	Y:\video\电视剧\巾帼枭雄之悬崖\S01
	来自地狱的法官	Y:\video\电视剧\来自地狱的法官\S01	
	黑色月光		Y:\video\电视剧\黑色月光\S01
	仙逆		Y:\video\动漫\仙.逆（2023）\Season 1
	完美世界		Y:\video\动漫\完美世界\S01
	师兄啊师兄	Y:\video\动漫\师兄啊师兄（2023）\S02
	炼气十万年	Y:\video\动漫\炼气十万年\S01
	凡人修仙传	Y:\video\动漫\凡人修仙传\S01
	剑来		Y:\video\动漫\剑来 (2024)\S01
	一念永恒		Y:\video\动漫\一念永恒\S03
	刺客伍六七	Y:\video\动漫\刺客伍六七\S05
EOF
cat > $dir_file/tmp/dianying_rename.txt <<EOF
	日月同错	S01
	回铭之烽火三月	S01
	原来我早就无敌了	S02
	正邪	S01	
	关于我转生变成史莱姆这档事	S03	史莱姆.txt
	刺客伍六七	S05
	宗门里除了我都是卧底	S01
EOF

	
	i=0
	while true
	do
		for dianying_name in `cat $dir_file/tmp/dianying_name.txt | awk '{print $1}'`
		do
			pan_path=$(echo "${dir_file}:" | sed "s/\/drives\///g" | sed "s/:/:\//" |sed "s/\//\\\\\\\/g")
			case "$dianying_name" in
				电影|动漫电影|香港三级)
				dianying
				;;
				*)
				dianshiju
				;;
			esac
		done
		
	
				
		i=$(expr $i + 1) 
		time="7200"
		echo "----------------------------------------"
		echo "开始第$i次循环，$time秒下次执行"
		echo "----------------------------------------"
		
		sleep $time
	done
}

dianying() {
	if [[ -e $dir_file/$dianying_name ]];then
		echo "》$dir_file/$dianying_name 文件夹存在"
		ls -A $dir_file/$dianying_name >$dir_file/tmp/dianying_file.txt
		dianying_file_num=$(cat $dir_file/tmp/dianying_file.txt | wc -l)
		if [[ `cat $dir_file/tmp/dianying_file.txt | wc -l ` -ge "1" ]];then
			echo "》》发现$dianying_name里面有新文件"
			dianying_file_count="1"
			while [ "$dianying_file_num" -ge "$dianying_file_count" ]
			do
				dianying_file_name=$(cat $dir_file/tmp/dianying_file.txt | sed -n "${dianying_file_count}p")
				dianying_file_name_sort=$(echo "$dianying_file_name" |awk -F "." '{print $1}')
				
				#将电影放到文件夹里面
				if [[ ! -d "$dir_file/$dianying_name/$dianying_file_name" ]];then
					#先判断是否为文件夹，如果不是文件夹，判断一下是否为aria2文件
					if [[ `echo "$dir_file/$dianying_name/$dianying_file_name" | grep -o "aria2" | sort -u` == "aria2" ]];then
						echo "》》》检测到 $dianying_file_name 是aria2文件，暂时不处理"
					else
						echo "$dianying_file_name 不是文件夹，开始创建"
						cmd /c mkdir "$pan_path\\$dianying_name\\$dianying_file_name_sort"
						cmd /c move "$pan_path\\$dianying_name\\$dianying_file_name" "$pan_path\\$dianying_name\\$dianying_file_name_sort"
					fi
				else
					#判断文件夹里面带不带aria2
					aria2_if=$(ls -A "$dir_file/$dianying_name/$dianying_file_name" | grep -Eo "aria2|xltd" | sort -u)
					if [[ "$aria2_if" == "aria2" ]];then
						echo "》》》检测到 $dir_file/$dianying_name/$dianying_file_name 有未下载好的$aria2_if，暂时不处理"
					elif [[ "$aria2_if" == "xltd" ]];then
						echo "》》》检测到 $dir_file/$dianying_name/$dianying_file_name 有未下载好的$aria2_if，暂时不处理"
					else
						#判断文件夹是否为空
						if [[ -z $(ls -A "$dir_file/$dianying_name/$dianying_file_name") ]];then
							echo "》》》检测到 $dir_file/$dianying_name/$dianying_file_name 文件夹为空，暂时不处理"
						else
							dianying_if="1"
							title="$dianying_name新增《$dianying_file_name》 "
							copy_file
						fi
					fi
					
				fi
				dianying_file_count=$(expr $dianying_file_count + 1)
				
			done
		else
			echo "》》没有发现$dianying_name里面有新文件"
		fi
	else
		echo "》$dir_file/$dianying_name 文件夹不存在"
	fi
}



dianshiju() {
		if [[ -e $dir_file/$dianying_name ]];then
			echo "》$dir_file/$dianying_name 文件夹存在"
			
			#开始判断文件是否为空
			if [[ -z $(ls -A $dir_file/$dianying_name) ]];then
				echo "》》$dir_file/$dianying_name 文件夹空的"
			else
				#开始判断文件是否存在未下载完成的文件
				aria2_if=$(ls -A $dir_file/$dianying_name | grep -Eo "aria2|xltd" | sort -u)
				if [[ "$aria2_if" == "aria2" ]];then
					echo "》》》检测到 $dir_file/$dianying_name 有未下载好的$aria2_if，暂时不处理"
				elif [[ "$aria2_if" == "xltd" ]];then
					echo "》》》检测到 $dir_file/$dianying_name 有未下载好的$aria2_if，暂时不处理"
				else
					file_path=$(cat $dir_file/tmp/dianying_name.txt | grep "$dianying_name" | awk '{print $2$3}'| sed "s/\\\/\\\\\\\/g")
					#对某些剧进行命名更新
					dianying_rename=$(cat $dir_file/tmp/dianying_rename.txt | grep "$dianying_name" )
					dianying_rename1=$(echo "$dianying_rename" | awk '{print $1}')
					dianying_rename2=$(echo "$dianying_rename" | awk '{print $2}')
					dianying_rename3=$(echo "$dianying_rename" | awk '{print $3}')
					dianying_rename3_grep=$(echo $dianying_rename3| grep -o "txt")
					if [[ "$dianying_rename1" == "$dianying_name" ]];then
					
						if [[ "$dianying_rename3_grep" == "txt" ]];then
							echo "检测到$dianying_name始对命名规则进行修正"
							ls -A $dir_file/$dianying_name |sed "s/$/\n/g" | sed '/^$/d' >$dir_file/old_name.txt
							
							cike_num=$(cat $dir_file/old_name.txt | wc -l)
							cike="1"
							while [ "$cike_num" -ge "$cike" ]
							do
								old_set=$(sed -n "$cike p" $dir_file/old_name.txt | sed "s/$dianying_name ${dianying_rename2}E//g" | awk -F "." '{print $1}')
								new_set=$(grep "$old_set" $dir_file/tmp/${dianying_rename3} |awk '{print $2}')
								
								cmd /c ren "$pan_path$dianying_name\\$dianying_name ${dianying_rename2}E${old_set}*" "$dianying_name ${dianying_rename2}E${new_set}*"
								cike=$(expr $cike + 1)
							done
							
							rm -rf $dir_file/old_name.txt
							rm -rf $dir_file/new_name.txt
						else
							echo "检测到$dianying_name，开始对命名规则进行修正"
							ls -A $dir_file/$dianying_name |sed "s/$/\n/g" | sed '/^$/d' >$dir_file/old_name.txt
							cat $dir_file/old_name.txt | sed "s/^/$dianying_name ${dianying_rename2}E/g" >$dir_file/new_name.txt
							
							cike_num=$(cat $dir_file/old_name.txt | wc -l)
							cike="1"
							while [ "$cike_num" -ge "$cike" ]
							do
								old_name=$(cat  $dir_file/old_name.txt | sed -n "$cike p")
								new_name=$(cat $dir_file/new_name.txt | grep "$old_name")
								cmd /c ren "$pan_path$dianying_name\\${old_name}" "$new_name"
								cike=$(expr $cike + 1)
							done
							
							rm -rf $dir_file/old_name.txt
							rm -rf $dir_file/new_name.txt
						fi
						
					
					
					fi
					title="$dianying_name 新增"
					copy_file
				fi
			fi
					
		else
			echo "》$dir_file/$dianying_name 文件夹不存在"
		fi
	
}

copy_file() {
					if [[ "$dianying_if" == "1" ]];then
						#检测到电影
						
						dianying_dir=$(echo "$pan_path$dianying_name$dianying_file_name" | sed "s/$dianying_name/$dianying_name\\\\\\\/g")
						file_path=$(cat $dir_file/tmp/dianying_name.txt | grep "$dianying_name" |sed -n "1p" | awk '{print $2$3}'| sed "s/\\\/\\\\\\\/g" |sed "s/$dianying_name/$dianying_name\\\\\\\/g" | sed "s/$/$dianying_file_name/g")
						echo "》》》开始复制$dianying_dir 到 $file_path"
						new_file=$(ls -A "$dir_file/$dianying_name/$dianying_file_name" |sed "s/$/\n/g" | sed '/^$/d'| sed "s/【//g"|  sed "s/】//g" | sed "s/\[//g" |sed "s/\]//g" |sed "s/：//g")
						cmd /c mkdir "$file_path"
						cmd /c xcopy "$dianying_dir" "$file_path" /E /Y
						cmd.exe /c rd "$dianying_dir" /S /Q
					else
						#检测到其他
						echo "》》》开始复制$pan_path$dianying_name 到 $file_path"
						new_file=$(ls -A "$dir_file/$dianying_name" |sed "s/$/\n/g" | sed '/^$/d'| sed "s/【//g"|  sed "s/】//g" | sed "s/\[//g" |sed "s/\]//g" |sed "s/：//g")
						cmd.exe  /c xcopy "$pan_path$dianying_name" "$file_path" /E /I /Y 
						cmd.exe  /c rd "$pan_path$dianying_name" /S /Q
					fi
					
					#开始判断文件是否新增，推送给手机
					if [[ ! -z "$new_file" ]];then		
						weixin_content=$(echo "$new_file" |grep -v "##" | sed "s/^/<br>/g" |sed ':t;N;s/\n//;b t')
						weixin_desp=$(echo "$weixin_content" | sed "s/<hr\/><b>/$weixin_line\n/g" |sed "s/<hr\/><\/b>/\n$weixin_line\n/g"| sed "s/<b>/\n/g"| sed "s/<br>/\n/g" | sed "s/<br><br>/\n/g" | sed "s/#/\n/g" )
						weixin_push	
					fi

}


weixin_push() {
current_time=$(date +%s)
expireTime="7200"
weixinkey=$(cat $dir_file/weixinkey.txt)
weixin_file="$dir_file/tmp/weixin_token.txt"
#企业名
corpid=$(echo $weixinkey | awk -F "," '{print $1}')
#自建应用，单独的secret
corpsecret=$(echo $weixinkey | awk -F "," '{print $2}')
# 接收者用户名,@all 全体成员
touser=$(echo $weixinkey | awk -F "," '{print $3}')
#应用ID
agentid=$(echo $weixinkey | awk -F "," '{print $4}')
#图片id
media_id=$(echo $weixinkey | awk -F "," '{print $5}')
time_before=$(cat $weixin_file |grep "$corpsecret" | awk '{print $4}')
if [[ ! $time_before ]];then
	#获取access_token
	access_token=$(curl "https://qyapi.weixin.qq.com/cgi-bin/gettoken?corpid=${corpid}&corpsecret=${corpsecret}" | sed "s/,/\n/g" | grep "access_token" | awk -F ":" '{print $2}' | sed "s/\"//g")
	sed -i "/$corpsecret/d" $weixin_file
	echo "$corpid $corpsecret $access_token `date +%s`" >> $weixin_file
	echo ">>>刷新access_token成功<<<"
else
	if [[ $(($current_time - $time_before)) -gt "$expireTime" ]];then
		#获取access_token
		access_token=$(curl "https://qyapi.weixin.qq.com/cgi-bin/gettoken?corpid=${corpid}&corpsecret=${corpsecret}" | sed "s/,/\n/g" | grep "access_token" | awk -F ":" '{print $2}' | sed "s/\"//g")
		sed -i "/$corpsecret/d" $weixin_file
		echo "$corpid $corpsecret $access_token `date +%s`" >>$weixin_file
		echo ">>>刷新access_token成功<<<"
	else
		echo "access_token 还没有过期，继续用旧的"
		access_token=$(cat $weixin_file |grep "$corpsecret" | awk '{print  $3}')
	fi
fi
if [[ ! $media_id ]];then
	msg_body="{\"touser\":\"$touser\",\"agentid\":$agentid,\"msgtype\":\"text\",\"text\":{\"content\":\"$title\n$weixin_desp\"}}"
else
	msg_body="{\"touser\":\"$touser\",\"agentid\":$agentid,\"msgtype\":\"mpnews\",\"mpnews\":{\"articles\":[{\"title\":\"$title\",\"thumb_media_id\":\"$media_id\",\"content\":\"$weixin_content\",\"digest\":\"$weixin_desp\"}]}}"
fi
	echo -e "$green 企业微信开始推送$title$white"
	curl -s "https://qyapi.weixin.qq.com/cgi-bin/message/send?access_token=$access_token" -d "$msg_body"
	if [[ $? -eq 0 ]]; then
		echo -e "$green 企业微信推送成功$title$white"
	else
		echo -e "$red 企业微信推送失败。请检查报错代码$title$white"
	fi
}
start
