#!/bin/bash

#--------------------------------------------
# 功能：编译xcode项目并打ipa包
# 使用说明：
#		编译project
#			ipa-build <project directory> [-c <project configuration>] [-o <ipa output directory>] [-t <target name>] [-n] [-p <platform identifier>]
#		编译workspace
#			ipa-build  <workspace directory> -w -s <schemeName> [-c <project configuration>] [-n]
#
# 参数说明：-c NAME				工程的configuration,默认为Release。
#			-o PATH				生成的ipa文件输出的文件夹（必须为已存在的文件路径）默认为工程根路径下的”build/ipa-build“文件夹中
#			-t NAME				需要编译的target的名称
#			-w					编译workspace	
#			-s NAME				对应workspace下需要编译的scheme
#			-n					编译前是否先clean工程
#			-p					平台标识符
# 作者：ccf
# E-mail:ccf.developer@gmail.com
# 创建日期：2012/09/24
#--------------------------------------------
# 修改日期：2013/02/18
# 修改人：ccf
# 修改内容：打包方式改为使用xcrun命令，并修改第二个参数
#--------------------------------------------
# 修改日期：2013/04/25
# 修改人：ccf
# 修改内容：采用getopts来处理命令参数，并增加编译前清除选项
#--------------------------------------------
# 修改日期：2013/04/26
# 修改人：ccf
# 修改内容：增加编译workspace的功能
#--------------------------------------------


output_path="/Users/william/Desktop/ipa-build" #ipa 文件输出路径
apppath="Desktop/iOSDomgy/Trunk/Domgo/Domgo" #工程路径
appname="Domgo" #工程名称
profile_id="6e661f4a-f8a0-4ccb-8b83-4b9b3377c69c"
profile_name="domgy_Inhouse"

cd "/Users/william/Desktop/iOSDomgy/Trunk/Domgo"
project_path=$(pwd)
echo "路径 = $project_path"
#app文件中Info.plist文件路径
app_infoplist_path=${project_path}/$appname/Info.plist

echo $app_infoplist_path


pro_path=${project_path}/$appname.'xcodeproj'
cd $pro_path

sed 's/PRODUCT_BUNDLE_IDENTIFIER.*/PRODUCT_BUNDLE_IDENTIFIER = com.roobo.domgyInhouse;/g' project.pbxproj > tmp
mv tmp project.pbxproj
cd $project_path

#获取版本号
bundleShortVersion=$(/usr/libexec/PlistBuddy -c "print CFBundleShortVersionString" ${app_infoplist_path})
echo "bundleShortVersion : $bundleShortVersion"
#获取build值
bundleVersion=$(/usr/libexec/PlistBuddy -c "print CFBundleVersion" ${app_infoplist_path})
echo "bundleVersion : $bundleVersion"
#获取displayName
displayName=$(/usr/libexec/PlistBuddy -c "print CFBundleName" ${app_infoplist_path})
echo "displayName : $displayName"

ipaName="${appname}_InHourse_${bundleShortVersion}_build(${bundleVersion})"


#更新build 号
((bundleVersion++))
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion $bundleVersion" "${app_infoplist_path}"



getsd() {
    oldwd=`pwd`
    sr=$(cd "$(dirname "$0")"; pwd)  
	echo "${sr}" 
    cd $oldwd
    echo $sw
    }
    

echo `getsd`


echo "开始更新svn"
svn update
echo "更新结束"
#编译工程

build_cmd=`getsd`'/ipa_build.sh . -t '$appname' -m Inhouse -o '$output_path' -s  '$profile_name' -p '$profile_id'  -n '$ipaName''

echo $build_cmd

#编译工程
${build_cmd} 

echo "上传蒲公英"
echo "file=@$output_path/$ipaName.ipa"
curl -F "file=@$output_path/$ipaName.ipa" -F "uKey=d145f3d70124152747b79be80b7161da" -F "_api_key=b7ed006d252dc221a0eaeb045d2e3f54" http://www.pgyer.com/apiv1/app/upload
echo "上传完成"


if [ "$output_path" != "" ];then
	echo "Copy ipa file successfully to the path $output_path/${ipa_name}.ipa"
	echo  "开始导入svn"
	svn import -m "加入新版本 $ipa_name" $output_path/$ipaName.ipa svn://mengchen@svn.365jiating.com/com/roobo/Domgo/App/IOS/Other/ipa/${ipaName}.ipa
	echo  "安装包上传svn成功"

fi

echo "发送电子邮件"
sendmail -t <<EOF
From: <mengchen@roo.bo>
To: <mengchen@roo.bo>
Subject:ios app new version Release
ipa version : $ipa_name
ipa type : $build_config
ipa svn address : svn://mengchen@svn.365jiating.com/com/roobo/Domgo/App/IOS/Other/ipa/$ipa_name
pgyer download INHOURSE address : https://www.pgyer.com/domgo


EOF
echo "发送电子邮件完成"
