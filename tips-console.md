## Job 数をカウント
```
println "job Count:" + jenkins.model.Jenkins.instance.items.size()
```

## Job 名を一括変換
```
jobList = jenkins.model.Jenkins.instance.items.findAll{
    it.name ==~ /^build_v1.0_.*/
}.each{ job->
    def job_name = job.name.replaceAll(/v1.0/,"v1.1")
    job.name = job_name
    println job.name
}
```

## Job の一括削除
```
jobList = jenkins.model.Jenkins.instance.items.findAll{
    it.name ==~ /^local-.*/
}.each{ job->
    job.delete()
}
```
