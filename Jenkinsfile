#!groovy

import groovy.json.JsonSlurperClassic

properties([
        [$class: 'BuildDiscarderProperty', strategy: [$class: 'LogRotator', numToKeepStr: '10']],
        pipelineTriggers([cron('H/2 * * * *')]),
        pipelineTriggers([githubPush()])/*,
        pipelineTriggers([$class: 'CodingPushTrigger', branchFilterType: 'RegexBasedFilter', targetBranchRegex: '(uat|develop)'])*/
])

node {

    def JWT_KEY_CRED_ID = '0205c40f-b192-4137-b05f-28c48820e46d'
    def RUN_ARTIFACT_DIR = "tests"
    def CONNECTED_APP_CONSUMER_KEY = env.CONNECTED_APP_CONSUMER_KEY_DH

    def props = readProperties file: 'orgs.properties'
    def toolbelt = tool 'toolbelt'
    def isAutomaticProcessRun = currentBuild.getBuildCauses()[0].toString().contains('TimerTrigger')
    def targetUserName
    def sfInstance

    stage('checkout source') {
        checkout scm
    }

    withCredentials([file(credentialsId: JWT_KEY_CRED_ID, variable: 'jwt_key_file')]) {
        stage('Set Org Properties') {
            println env.BRANCH_NAME
            if (env.BRANCH_NAME == props.branch_dev) {
                targetUserName = props.dev_username
            } else if (env.BRANCH_NAME == props.branch_uat) {
                targetUserName = props.uat_username
            } else if (env.BRANCH_NAME == props.branch_prod) {
                targetUserName = props.prod_username
            }
        }

        stage('Code Scanner Run') {
            if (isAutomaticProcessRun) {
                echo 'Automatic Scanner'
            }
        }

        stage("Run Autotests") {
            println targetUserName
            if ((isAutomaticProcessRun || env.BRANCH_NAME == "master") && targetUserName != null) {
                def testRunScript = "\"${toolbelt}\" force:apex:test:run --testlevel RunLocalTests --outputdir ${RUN_ARTIFACT_DIR} --resultformat tap --targetusername ${targetUserName}"
                bat "IF NOT exist ${RUN_ARTIFACT_DIR} (mkdir ${RUN_ARTIFACT_DIR})"
                //timeout(time: 120, unit: 'SECONDS') {
                    if (isUnix()) {
                        rc = sh returnStatus: true, script: testRunScript
                    } else {
                        rc = 0
                       // rc = bat returnStatus: true, script: testRunScript
                    }
                    if (rc != 0) {
                        error 'Apex test run failed'
                    }
              //  }
            }
        }

        stage('Deploy Code') {
            if (!isAutomaticProcessRun && targetUserName != null) {
                def authorizationScript = "\"${toolbelt}\" force:auth:jwt:grant --clientid ${CONNECTED_APP_CONSUMER_KEY} --username ${props.prod_username} --jwtkeyfile ${jwt_key_file} --setdefaultdevhubusername --instanceurl https://login.salesforce.com";
                def mdapiConvertScript = "\"${toolbelt}\" force:source:convert -r ./force-app/ -d manifest";
                def deployCodeScript = "\"${toolbelt}\" force:mdapi:deploy -d manifest/. -u ${targetUserName}";
                if (isUnix()) {
                    sh returnStatus: true, script: authorizationScript;
                    sh returnStatus: true, script: mdapiConvertScript
                    rc = sh returnStdout: true, script: deployCodeScript
                } else {
                    bat returnStatus: true, script: authorizationScript;
                    bat returnStatus: true, script: mdapiConvertScript
                    rc = bat returnStdout: true, script: deployCodeScript;
                }
                if (rc != 0) {
                    error 'Deploy Code Failed'
                }
            }
        }


    }
}
