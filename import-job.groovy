import jenkins.model.*
import groovy.xml.StreamingMarkupBuilder

def TARGET = "dev"
def CONFIG_DIR = "/var/jenkins_home/jobconfig/"

def getJobName(configXml, TARGET) {
    def parser = new XmlSlurper()
    String description = parser.parseText(configXml).description
    String tmp = description.split().last()
    return TARGET + "-script-" + tmp.split("/").last()
}

// config の書き換え
def setConfig(configXml, target) {
    def parser = new XmlSlurper()
    def config = parser.parseText(configXml)

    // 無効化しておく
    config.disabled = true

    // branch の設定
    if (target == "prd") {
        config.definition.scm.branches.'hudson.plugins.git.BranchSpec'.name = "master" 
    } else {
        config.definition.scm.branches.'hudson.plugins.git.BranchSpec'.name = "develop"
    }

    // text にもどす
    StreamingMarkupBuilder builder = new StreamingMarkupBuilder()
    builder.encoding = "UTF8"
    def newXml = builder.bind{mkp.yield config};

    return newXml
}
//def validation(configXml) {
//    def parser = new XmlSlurper()
//    def config = parser.parseText(configXml)
//
//    if (config.definition.scm.branches.'hudson.plugins.git.BranchSpec'.name != "develop") {
//        println (config.definition.scriptPath + " branch=" + config.definition.scm.branches.'hudson.plugins.git.BranchSpec'.name)
//    }
//}

def instance  = Jenkins.getInstance()
File dir = new File(CONFIG_DIR)
File[] files = dir.listFiles().sort()
println files.length

//for (int i = 0; i < files.length; i++) {
for (int i = 0; i < 1; i++) {
    File file = files[i]
    String fileName = file.getName()
    println fileName

    def configXml = new File(CONFIG_DIR + fileName).text
//validation(configXml)
    String jobName = getJobName(configXml, TARGET)
    String newConfig = setConfig(configXml, TARGET)

//    def xmlStream = new ByteArrayInputStream(newConfig.getBytes())
//    instance.createProjectFromXML(jobName, xmlStream)
}
