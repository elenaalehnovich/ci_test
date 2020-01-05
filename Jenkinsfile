#!groovy

import groovy.json.JsonSlurperClassic

properties([
        [$class: 'BuildDiscarderProperty', strategy: [$class: 'LogRotator', numToKeepStr: '10']],
        pipelineTriggers([cron('H/2 * * * *')]),
        pipelineTriggers([githubPush()]),
        parameters([
                gitParameter(branch: '',
                        branchFilter: '(master|uat))',
                        defaultValue: 'master',
                        description: '',
                        name: 'BRANCH',
                        quickFilterEnabled: false,
                        selectedValue: 'NONE',
                        sortMode: 'NONE',
                        tagFilter: '*',
                        type: 'PT_BRANCH')
        ])
])

node {

    def JWT_KEY_CRED_ID = 'a42e7e08-1c5a-4d1f-85d3-438b0e2d7655'
    def RUN_ARTIFACT_DIR = "tests"
    def CONNECTED_APP_CONSUMER_KEY = env.CONNECTED_APP_CONSUMER_KEY_DH

    def props = readProperties file: 'orgs.properties'
    def toolbelt = tool 'toolbelt'
    def isAutomaticProcessRun = currentBuild.getBuildCauses()[0].toString().contains('TimerTrigger')
    def targetUserName
    def sfInstance
    println 'KEY IS'
    println JWT_KEY_CRED_ID
    println CONNECTED_APP_CONSUMER_KEY
    println props

    stage('checkout source') {
        checkout scm
    }

    withCredentials([file(credentialsId: JWT_KEY_CRED_ID, variable: 'jwt_key_file')]) {
        stage('Set Org Properties') {
            if (env.BRANCH_NAME == props.branch_dev) {
                targetUserName = props.dev_username
                sfInstance = props.dev_host
            } else if (env.BRANCH_NAME == props.branch_uat) {
                targetUserName = props.uat_username
                sfInstance = props.uat_host
            } else if (env.BRANCH_NAME == props.branch_prod) {
                targetUserName = props.prod_username
                sfInstance = props.prod_host
            }
        }

        stage('Code Scanner Run') {
            if (isAutomaticProcessRun) {
                echo 'Automatic Scanner'
            }
        }

        stage("Run Autotests") {
            if ((isAutomaticProcessRun || env.BRANCH_NAME == "master") && targetUserName != null) {
                def testRunScript = "\"${toolbelt}\" force:apex:test:run --testlevel RunLocalTests --outputdir ${RUN_ARTIFACT_DIR} --resultformat tap --targetusername ${targetUserName}"
                bat "IF NOT exist ${RUN_ARTIFACT_DIR} (mkdir ${RUN_ARTIFACT_DIR})"
                //timeout(time: 120, unit: 'SECONDS') {
                    if (isUnix()) {
                        rc = sh returnStatus: true, script: testRunScript
                    } else {
                        rc = bat returnStatus: true, script: testRunScript
                    }
                    if (rc != 0) {
                        error 'Apex test run failed'
                    }
              //  }
            }
        }

        stage('Deploy Code') {
            if (!isAutomaticProcessRun && targetUserName != null) {
                def authorizationScript = "\"${toolbelt}\" force:auth:jwt:grant --clientid ${CONNECTED_APP_CONSUMER_KEY} --username ${props.prod_username} --jwtkeyfile ${jwt_key_file} --setdefaultdevhubusername --instanceurl ${props.prod_host}";
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
