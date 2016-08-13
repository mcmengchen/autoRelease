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



echo "filepath:$(dirname $(locate $0))"
getsd() {
    oldwd=`pwd`
    sr=$(cd "$(dirname "$0")"; pwd)  
	echo "Dir of currently executed script is : ${sr}" 
    cd $oldwd
    echo $sw
    }
    

echo `getsd`

# shell_path='dirname ${0}'
# cd  $shell_path

# echo $(pwd)

# build_cmd=`getsd`'/ipa_build.sh . -w -s Pudding -c ADHOC -o '$output_path' -n y' 

# echo $build_cmd


# getsd() {
#     ldwd=`pwd`
#     rw=`dirname $0`
#     echo $rw
#     cd $rw
#     sw=`pwd`
#     cd $oldwd
#     echo $sw
#     }
    

# echo `getsd`
# # # shell_path='dirname ${0}'
# # # cd  $shell_path

# # echo $(pwd)

# build_cmd=`getsd`'/ipa_build.sh . -w -s Pudding -c ADHOC -o '$output_path' -n y' 

# echo $build_cmd


# # #编译工程
# ${build_cmd} 