#!/bin/bash

JOB_CONFIG_DIR="./jobconfig"

echo "\033[1;32mTarget (dev | live):\033[0;39m" 
read TARGET
echo $TARGET

# config.xml の更新かどうか
# y = 更新, n = Job 作成
echo "\033[1;32mUpdate? (y | n):\033[0;39m" 
read IS_UPDATE
echo $IS_UPDATE

if [ $TARGET = "dev" ]; then
    # dev 
    J_URL="https://dev.jenkins"
    J_VIEW="/view/dev-script"
    J_USER="dev-user"
    J_PASSWORD="hogehoge"
elif [ $TARGET = "prd" ]; then
    # live 
    J_URL="https://live.jenkins"
    J_VIEW="/view/dev-script"
    J_USER="dev-user"
    J_PASSWORD="hogehoge"
else
    # local 
    TARGET="dev"
    J_URL="http://localhost:8080"
    J_VIEW=""
    J_USER="jenkins"
    J_PASSWORD="jenkins"
fi


# crumb の取得
echo "\033[1;32mget crumb \033[0;39m"
CRUMB=`curl -u ${J_USER}:${J_PASSWORD} ${J_URL}/crumbIssuer/api/xml | grep "\<crumb\>" | sed "s/.*<crumb>//g" | sed "s/<\/crumb>.*//g"`
echo ${CRUMB}


if [ $IS_UPDATE = "y" ]; then
    echo "\033[1;32mupdate job \033[0;39m"
else
    echo "\033[1;32mcreate job \033[0;39m"
fi

for file in `find ${JOB_CONFIG_DIR} -maxdepth 1 -type f | sort`; do
    # file name
    #tmp="${file##*/}"
    #fname="${tmp%.*}"

    # Job 名
    tmp=`cat ${file} | grep "/description" | sed "s/<\/description>//g" | sed "s/.*\///g"`
    jname=${TARGET}-script-${tmp}
    echo ${file} ${jname}

    if [ $IS_UPDATE = "y" ]; then
        # config.xml を 更新 (post)
        curl -X POST -u ${J_USER}:${J_PASSWORD} \
        -H 'Content-type: application/xml; charset="UTF-8"' \
        -H "Jenkins-Crumb: ${CRUMB}" \
        -d @${file} ${J_URL}${J_VIEW}/job/${jname}/config.xml
    else
        # config.xml を元に job を作成
        curl -X POST -u ${J_USER}:${J_PASSWORD} \
        -H 'Content-type: application/xml; charset="UTF-8"' \
        -H "Jenkins-Crumb: ${CRUMB}" \
        -d @${file} ${J_URL}${J_VIEW}/createItem?name=${jname}
    fi
done
