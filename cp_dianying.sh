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
by="#### 脚本仓库地址:https://github.com/ITdesk01/Checkjs"

#推送log日志到server酱的时间
push_server_time="22"


red="\033[31m"
green="\033[32m"
yellow="\033[33m"
white="\033[0m"


start() {

cat > $dir_file/tmp/dianying_name.txt <<EOF
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
		if [ -e $dir_file/$dianying_name ];then
			echo "》$dir_file/$dianying_name 文件夹存在"
			
			#开始判断文件是否为空
			if [[ -z $(ls -A $dir_file/$dianying_name) ]];then
				echo "》》$dir_file/$dianying_name 文件夹空的"
			else
				#开始判断文件是否存在未下载完成的文件
				aria2_if=$(ls -A $dir_file/$dianying_name | grep -o "aria2" | sort -u)
				if [ "$aria2_if" == "aria2" ];then
					echo "》》》检测到 $dir_file/$dianying_name 有未下载好的aria2，暂时不处理"
				else
					pan_path=$(echo "${dir_file}:" | sed "s/\/drives\///g" | sed "s/:/:\//" |sed "s/\//\\\\\\\/g")

					file_path=$(cat $dir_file/tmp/dianying_name.txt | grep "$dianying_name" | awk '{print $2$3}'| sed "s/\\\/\\\\\\\/g")				

					#对某些剧进行命名更新
					dianying_rename=$(cat $dir_file/tmp/dianying_rename.txt | grep "$dianying_name" )
					dianying_rename1=$(echo "$dianying_rename" | awk '{print $1}')
					dianying_rename2=$(echo "$dianying_rename" | awk '{print $2}')
					dianying_rename3=$(echo "$dianying_rename" | awk '{print $3}')
					dianying_rename3_grep=$(echo $dianying_rename3| grep -o "txt")
					if [ "$dianying_rename1" == "$dianying_name" ];then
					
						if [ "$dianying_rename3_grep" == "txt" ];then
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
					
					
					echo "》》》开始复制$pan_path$dianying_name 到 $file_path"
					echo "##《$dianying_name》新增 " >>$dir_file/tmp/new_file.txt
					echo "$(ls -A $dir_file/$dianying_name |sed "s/$/\n/g" | sed '/^$/d')" >>$dir_file/tmp/new_file.txt
					
					cmd.exe  /c xcopy "$pan_path$dianying_name" "$file_path" /E /I /Y 

					cmd.exe  /c rd $pan_path$dianying_name /S /Q
					
					#开始判断文件是否新增，推送给手机
					new_file="$dir_file/tmp/new_file.txt"
					old_file="$dir_file/tmp/old_file.txt"
					add_file="$dir_file/tmp/add_file.txt"
					if [ -e "$new_file" ];then
						if [ -e "$old_file" ];then
							grep -vwf $old_file $new_file > $add_file
							
							if [ ! `cat $add_file | wc -l` == "0" ];then
								title="$dianying_name 新增"
								weixin_content=$(cat $add_file |grep -v "##" | sed "s/^/<br>/g" |sed ':t;N;s/\n//;b t')
								weixin_desp=$(echo "$weixin_content" | sed "s/<hr\/><b>/$weixin_line\n/g" |sed "s/<hr\/><\/b>/\n$weixin_line\n/g"| sed "s/<b>/\n/g"| sed "s/<br>/\n/g" | sed "s/<br><br>/\n/g" | sed "s/#/\n/g" )
								weixin_push
								cat $new_file >$old_file
								
							fi
						else
							echo "" >$dir_file/tmp/old_file.txt
						fi
					fi
				fi
			fi
		else
			echo "》$dir_file/$dianying_name 文件夹不存在"
		fi
	done
				
		i=$(expr $i + 1) 
		time="7200"
		echo "----------------------------------------"
		echo "开始第$i次循环，$time秒下次执行"
		echo "----------------------------------------"
		
		sleep $time
done
}


weixin_push() {


current_time=$(date +%s)
expireTime="7200"


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



if [ ! $time_before ];then
	#获取access_token
	access_token=$(curl "https://qyapi.weixin.qq.com/cgi-bin/gettoken?corpid=${corpid}&corpsecret=${corpsecret}" | sed "s/,/\n/g" | grep "access_token" | awk -F ":" '{print $2}' | sed "s/\"//g")
	sed -i "/$corpsecret/d" $weixin_file
	echo "$corpid $corpsecret $access_token `date +%s`" >> $weixin_file
	echo ">>>刷新access_token成功<<<"
else
	if [ $(($current_time - $time_before)) -gt "$expireTime" ];then
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

if [ ! $media_id ];then
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

