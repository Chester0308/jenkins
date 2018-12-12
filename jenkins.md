## Job の config.xml を取得
```
curl -u <user>:<pass> http://host.to.jenkins/job/<job-name>/config.xml
```

## Job の情報一覧
```
curl -u <user>:<pass> http://host.to.jenkins/api/json

// 項目をフィルタリング
curl -u <user>:<pass> http://host.to.jenkins/api/json?depth=2&tree=jobs[displayName,buildable,lastCompletedBuild[number,timestamp,result,url,duration]]
```

## crumb の取得
```
curl -u <user>:<pass> http://host.to.jenkins/crumbIssuer/api/xml
```

## Job を作成 (config.xml を post)
```
curl -X POST -u <user>:<pass> \
-H 'Content-type: application/xml; charset="UTF-8"' \
-H "Jenkins-Crumb: <CRUMB> \
-d @config.xml http://host.to.jenkins/createItem?name=<job-name>
```

## Job の設定を更新 (config.xml を post)
```
curl -X POST -u <user>:<pass> \
-H 'Content-type: application/xml; charset="UTF-8"' \
-H "Jenkins-Crumb: <CRUMB> \
-d @config.xml http://host.to.jenkins/job/<job-name>/config.xml
```
