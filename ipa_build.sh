#!/bin/bash

# 参数说明：		-m modle				工程的configuration,默认为Release。
#		 		-o PATH					生成的ipa文件输出的文件夹（必须为已存在的文件路径）默认为工程根路径下的”build/ipa-build“文件夹中
#				-t NAME					需要编译的target的名称
#				-s CODE_SIGN_IDENTITY	编译所需要的证书名称
#				-p PROVISIONING_PROFILE	编译所需要的证书id
#               -n ipaname              编译完成后的安装包名称

#工程绝对路径
cd $1
project_path=$(pwd)
echo "绝对路径=======$project_path"
#编译的configuration，默认为Release
build_config=Release

param_pattern=":m:t:o:s:p:n:"

OPTIND=2
while getopts $param_pattern optname
  do
    case "$optname" in       
      "m")
        tmp_optind=$OPTIND
        tmp_optname=$optname
        tmp_optarg=$OPTARG

        OPTIND=$OPTIND-1
        if getopts $param_pattern optname ;then
            echo  "Error argument value for option $tmp_optname"
            exit 2
        fi
        OPTIND=$tmp_optind

        buildModle=$tmp_optarg
        
        ;;
      "t")        
        tmp_optind=$OPTIND
        tmp_optname=$optname
        tmp_optarg=$OPTARG
        OPTIND=$OPTIND-1
        if getopts $param_pattern optname ;then
            echo  "Error argument value for option $tmp_optname"
            exit 2
        fi
        OPTIND=$tmp_optind
        targetName=$tmp_optarg
        ;;
      "o")
        tmp_optind=$OPTIND
        tmp_optname=$optname
        tmp_optarg=$OPTARG

        OPTIND=$OPTIND-1
        if getopts $param_pattern optname ;then
            echo  "Error argument value for option $tmp_optname"
            exit 2
        fi

        echo $optname
        echo $tmp_optarg
        OPTIND=$tmp_optind
        if [ ! -d $output_path ];then
            mkdir $output_path
        fi

        cd $tmp_optarg
        outputPath=$tmp_optarg
        cd ${project_path}

        

        ;;

      "s")
        tmp_optind=$OPTIND
        tmp_optname=$optname
        tmp_optarg=$OPTARG

        OPTIND=$OPTIND-1
        if getopts $param_pattern optname ;then
            echo  "Error argument value for option $tmp_optname"
            exit 2
        fi
        OPTIND=$tmp_optind
        codeIdentity=$tmp_optarg    
        
        ;;
      "p")
        tmp_optind=$OPTIND
        tmp_optname=$optname
        tmp_optarg=$OPTARG

        OPTIND=$OPTIND-1
        if getopts $param_pattern optname ;then
            echo  "Error argument value for option $tmp_optname"
            exit 2
        fi
        OPTIND=$tmp_optind
        codeProfile=$tmp_optarg 
        ;;
     "n")        
        tmp_optind=$OPTIND
        tmp_optname=$optname
        tmp_optarg=$OPTARG
        OPTIND=$OPTIND-1
        if getopts $param_pattern optname ;then
            echo  "Error argument value for option $tmp_optname"
            exit 2
        fi
        OPTIND=$tmp_optind
        outIpaName=$tmp_optarg
        ;;

      "?")
        echo "Error! Unknown option $OPTARG"
        exit 2
        ;;
      ":")
        echo "Error! No argument value for option $OPTARG"
        exit 2
        ;;
      *)
      # Should not occur
        echo "Error! Unknown error while processing options"
        exit 2
        ;;
    esac
  done


echo "工程的configuration=================$buildModle"
echo "生成的ipa文件输出的文件夹==============$outputPath"
echo "需要编译的target的名称=================$targetName"
echo "编译所需要的证书名称====================$codeIdentity"
echo "编译所需要的证书id ====================$codeProfile"


project_path=$(pwd)

#build文件夹路径
build_path=${project_path}/build
#编译后文件路径(仅当编译workspace时才会用到)
compiled_path=${build_path}/build_iphoneos


 echo "正在清理"
 #清理xcode 缓冲
 xcodebuild clean -configuration ${buildModle}
 echo "清理完成"


# "获取xcworkspace文件"
workspace_name='*.xcworkspace'
ls $project_path/$workspace_name &>/dev/null
rtnValue=$?
echo $rtnValue

if [ $rtnValue = 0 ];then
	build_workspace=$(echo $(basename $project_path/$workspace_name))
else
	echo  "Error!Current path is not a xcode workspace.Please check, or do not use -w option."
	exit 2
fi
echo $build_workspace



if [ -d ./$outputPath ];then
    rm -rf $outputPath
fi
mkdir $outputPath

echo $outputPath

#组合编译命令
build_cmd='xcodebuild'

build_cmd=${build_cmd}' -workspace '${build_workspace}' -scheme '${targetName}' -configuration '${buildModle}' -sdk iphoneos build CODE_SIGN_IDENTITY='${codeIdentity}' PROVISIONING_PROFILE='${codeProfile}'  CONFIGURATION_BUILD_DIR='${compiled_path}' ONLY_ACTIVE_ARCH=NO'


echo $build_cmd



# 编译工程
 $build_cmd || exit


#进入build路径
cd $build_path
#创建ipa-build文件夹
if [ -d ./ipa-build ];then
    rm -rf ipa-build
fi
mkdir ipa-build


#xcrun打包
xcrun -sdk iphoneos PackageApplication -v ./build_iphoneos/*.app -o ${outputPath}/${outIpaName}.ipa || exit








