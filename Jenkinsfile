#!groovy

import groovy.json.JsonSlurperClassic

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
        pipelineTriggers([githubPush()])
])

node {
    def props = readProperties file: 'config.properties'

    def JWT_KEY_CRED_ID = '0205c40f-b192-4137-b05f-28c48820e46d'
    def RUN_ARTIFACT_DIR = 'tests'

    def toolbelt = tool 'toolbelt'
    def timer_run = currentBuild.getBuildCauses()[0].toString().contains('TimerTrigger')
    def sf_username
    def sf_host
    def consumer_key

    stage('checkout source') {
        checkout scm
    }

    try {
        withCredentials([file(credentialsId: JWT_KEY_CRED_ID, variable: 'jwt_key_file')]) {
            stage('Set Org Properties') {
                if (env.BRANCH_NAME == props.branch_dev) {
                    sf_username = props.dev_username
                    sf_host = props.dev_host
                    consumer_key = env.CONNECTED_APP_CONSUMER_KEY_DEV
                } else if (env.BRANCH_NAME == props.branch_uat) {
                    sf_username = props.uat_username
                    sf_host = props.uat_host
                    consumer_key = env.CONNECTED_APP_CONSUMER_KEY_UAT
                } else if (env.BRANCH_NAME == props.branch_prod) {
                    sf_username = props.prod_username
                    sf_host = props.prod_host
                    consumer_key = env.CONNECTED_APP_CONSUMER_KEY_PROD
                }
            }

            stage('Code Scanner Run') {
                if (timer_run) {
                    echo 'Automatic Scanner'
                }
            }

            stage('Authorization') {
                if(sf_username != null) {
                    def auth_script = "\"${toolbelt}\" force:auth:jwt:grant --clientid ${consumer_key} --username ${sf_username} --jwtkeyfile ${jwt_key_file} --instanceurl ${sf_host}";
                    if (isUnix()) {
                        rc = sh returnStatus: true, script: auth_script;
                    } else {
                        rc = bat returnStatus: true, script: auth_script;
                    }
                }
            }

            stage("Run Autotests") {
                println sf_username
                if ((timer_run || env.BRANCH_NAME == "master") && sf_username != null) {
                    def test_script = "\"${toolbelt}\" force:apex:test:run --testlevel RunLocalTests --outputdir ${RUN_ARTIFACT_DIR} --resultformat tap --targetUsername ${sf_username}"
                    bat "IF NOT exist ${RUN_ARTIFACT_DIR} (mkdir ${RUN_ARTIFACT_DIR})"
                    if (isUnix()) {
                        rc = sh returnStatus: true, script: test_script
                    } else {
                        rc = bat returnStatus: true, script: test_script
                    }
                }
            }

            stage('Deploy Code') {
                if (!timer_run && sf_username != null) {
                   // def mdapi_convert_script = "\"${toolbelt}\" force:source:convert -r ./force-app/ -d manifest";
                    def deploy_script = "\"${toolbelt}\" force:source:deploy -p force-app -u ${sf_username}";
                    if (isUnix()) {
                        sh returnStatus: true, script: mdapi_convert_script
                        rc = sh returnStdout: true, script: deploy_script
                    } else {
                        bat returnStatus: true, script: mdapi_convert_script
                        rc = bat returnStdout: true, script: deploy_script;
                    }
                }
            }

            stage("Send Slack") {
                if (props.slack_channel != null) {
                    slackSend(channel: props.slack_channel, color: 'good', message: "Build finished successfully : ${env.JOB_NAME} [${env.BUILD_NUMBER}] (<${env.RUN_DISPLAY_URL}|Open>) :thumbsup:")
                }
            }
        }
    } catch (e) {
        if (props.slack_channel != null) {
            slackSend(channel: props.slack_channel, color: 'danger', message: "Huh, not good... Build failed : ${env.JOB_NAME} [${env.BUILD_NUMBER}] ${e} (<${env.RUN_DISPLAY_URL}|Open>) :man-shrugging::shrug:")
        }
    }
}
