#!groovy

import groovy.json.JsonSlurperClassic

properties([
        [$class: 'BuildDiscarderProperty', strategy: [$class: 'LogRotator', numToKeepStr: '10']],
        pipelineTriggers([cron('H/5 * * * *')]),
        pipelineTriggers([githubPush()])
])

node {

    def JWT_KEY_CRED_ID = 'b95b9f50-b05a-46b4-aafb-af449cff11c8'
    def CONNECTED_APP_CONSUMER_KEY = env.CONNECTED_APP_CONSUMER_KEY_DH
    def props = readProperties file: 'orgs.properties'
    def toolbelt = tool 'toolbelt'

    println 'KEY IS'
    println JWT_KEY_CRED_ID
    println CONNECTED_APP_CONSUMER_KEY
    println props
    println env.BRANCH_NAME

    stage('checkout source') {
        // when running in multi-branch job, one must issue this command
        checkout scm
    }

    withCredentials([file(credentialsId: JWT_KEY_CRED_ID, variable: 'jwt_key_file')]) {
        stage('Deploy Code') {
            if (isUnix()) {
                rc = sh returnStatus: true, script: "${toolbelt} force:auth:jwt:grant --clientid ${CONNECTED_APP_CONSUMER_KEY} --username ${props.dev_username} --jwtkeyfile ${jwt_key_file} --setdefaultdevhubusername --instanceurl ${props.dev_host}"
            } else {
                rc = bat returnStatus: true, script: "\"${toolbelt}\" force:auth:jwt:grant --clientid ${CONNECTED_APP_CONSUMER_KEY} --username ${props.dev_username} --jwtkeyfile \"${jwt_key_file}\" --setdefaultdevhubusername --instanceurl ${props.dev_host}"
            }
            if (rc != 0) {
                error 'hub org authorization failed'
            }

            println rc

            // need to pull out assigned username
            if (isUnix()) {
                rmsg = sh returnStdout: true, script: "${toolbelt} force:mdapi:deploy -d force-app/main/default/. -u ${props.dev_username}"
            } else {
                rmsg = bat returnStdout: true, script: "\"${toolbelt}\" force:mdapi:deploy -d force-app/main/default/. -u ${props.dev_username}"
            }
            printf rmsg
            println('Hello from a Job DSL script!')
            println(rmsg)
        }
    }
}
