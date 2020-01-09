#!groovy

import groovy.json.JsonSlurperClassic

#!test

properties([
        buildDiscarder(
                logRotator(
                        daysToKeepStr: '-1',
                        numToKeepStr: '7',
                        artifactDaysToKeepStr: '14',
                        artifactNumToKeepStr: '3'
                )
        ),
        disableConcurrentBuilds(),
        pipelineTriggers([cron('H */12 * * *')]),
        pipelineTriggers([githubPush()]),
        /*pipelineTriggers([githubBranches(
                restriction (
                        matchAsPattern: true,
                        matchCriteriaStr: 'uat|develop'))])*/

        /*pipelineTriggers([
                [$class: 'CodingPushTrigger', branchFilterType: 'RegexBasedFilter', targetBranchRegex: '(uat|develop)']
        ])*/
])

node {

    def props = readProperties file: 'config.properties'

    def JWT_KEY_CRED_ID = '0205c40f-b192-4137-b05f-28c48820e46d'
    def RUN_ARTIFACT_DIR = props.tests_dir == null ? 'tests' : props.tests_dir
    def CONNECTED_APP_CONSUMER_KEY = env.CONNECTED_APP_CONSUMER_KEY_DH

    def toolbelt = tool 'toolbelt'
    def isAutomaticProcessRun = currentBuild.getBuildCauses()[0].toString().contains('TimerTrigger')
    def targetUserName
    def orgHost

    stage('checkout source') {
        checkout scm
    }

    try {
        withCredentials([file(credentialsId: JWT_KEY_CRED_ID, variable: 'jwt_key_file')]) {
            stage('Set Org Properties') {
                println env.BRANCH_NAME
                println props.branch_prod
                println env.BRANCH_NAME == props.branch_prod
                if (env.BRANCH_NAME == props.branch_dev) {
                    targetUserName = props.dev_username
                    orgHost = props.dev_host
                } else if (env.BRANCH_NAME == props.branch_uat) {
                    targetUserName = props.uat_username
                    orgHost = props.uat_host
                } else if (env.BRANCH_NAME == props.branch_prod) {
                    targetUserName = props.prod_username
                    orgHost = props.prod_host
                }
            }

            stage('Code Scanner Run') {
                if (isAutomaticProcessRun) {
                    echo 'Automatic Scanner'
                }
            }

            stage('Authorization') {
                if(targetUserName != null) {
                    def authorizationScript = "\"${toolbelt}\" force:auth:jwt:grant --clientid ${CONNECTED_APP_CONSUMER_KEY} --username ${targetUserName} --jwtkeyfile ${jwt_key_file} --instanceurl ${orgHost}";
                    if (isUnix()) {
                        rc = sh returnStatus: true, script: authorizationScript;
                    } else {
                        rc = bat returnStatus: true, script: authorizationScript;
                    }
                    if (rc != 0) {
                        error 'Authorization failed'
                    }
                }
            }

            stage("Run Autotests") {
                println targetUserName
                if ((isAutomaticProcessRun || env.BRANCH_NAME == "master") && targetUserName != null) {
                    def testRunScript = "\"${toolbelt}\" force:apex:test:run --testlevel RunLocalTests --outputdir ${RUN_ARTIFACT_DIR} --resultformat tap --targetusername ${targetUserName}"
                    bat "IF NOT exist ${RUN_ARTIFACT_DIR} (mkdir ${RUN_ARTIFACT_DIR})"
                    if (isUnix()) {
                        rc = sh returnStatus: true, script: testRunScript
                    } else {
                        rc = bat returnStatus: true, script: testRunScript
                    }
                    if (rc != 0) {
                        error 'Apex test run failed'
                    }
                }
            }

            stage('Deploy Code') {
                if (!isAutomaticProcessRun && targetUserName != null) {
                    def mdapiConvertScript = "\"${toolbelt}\" force:source:convert -r ./force-app/ -d manifest";
                    def deployCodeScript = "\"${toolbelt}\" force:mdapi:deploy -d manifest/. -u ${targetUserName}";
                    if (isUnix()) {
                        sh returnStatus: true, script: mdapiConvertScript
                        rc = sh returnStdout: true, script: deployCodeScript
                    } else {
                        bat returnStatus: true, script: mdapiConvertScript
                        rc = bat returnStdout: true, script: deployCodeScript;
                    }
                    if (rc != 0) {
                        error 'Deploy Code Failed'
                    }
                }
            }
        }
    } catch (e) {
        if (props.slack_channel != null) {
            slackSend(channel: props.slack_channel, color: 'danger', message: "Huh, not good... Build failed : ${env.JOB_NAME} [${env.BUILD_NUMBER}] ${e} (<${env.RUN_DISPLAY_URL}|Open>) :man-shrugging::shrug:")
        }
    } finally {
        if (props.slack_channel != null) {
            slackSend(channel: props.slack_channel, color: 'good', message: "Build finished successfully : ${env.JOB_NAME} [${env.BUILD_NUMBER}] (<${env.RUN_DISPLAY_URL}|Open>) :thumbsup:")
        }
    }
}
