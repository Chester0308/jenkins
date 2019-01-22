#!/bin/bash

echo "\033[1;32mTarget (dev | stg | prd):\033[0;39m" 
read TARGET

CONFIG_DIR="jobconfig"

if [ $TARGET = "dev" -o $TARGET = "stg" ]; then
    # dev 
    J_URL="https://dev"
    J_VIEW="/view/dev"
    J_USER=""
    J_PASSWORD=""
    J_JOB=""

elif [ $TARGET = "prd" ]; then
    # prd 
    J_URL="https://prd"
    J_VIEW="/view/prd"
    J_USER=""
    J_PASSWORD=""
    J_JOB=""
fi

# ジョブ名一覧取得 &  config.xml をダウンロード
for line in `curl -u ${J_USER}:${J_PASSWORD} "${J_URL}${J_VIEW}/api/json?pretty=true&tree=jobs%5Bname%5D" \
    | grep name \
    | sed "s/.*${J_JOB}//g" \
    | sed "s/\"//g"`
do
    echo ${line}
    curl -so ${CONFIG_DIR}/${line}.config -u ${J_USER}:${J_PASSWORD} ${J_URL}${J_VIEW}/job/${J_JOB}${line}/config.xml
done
