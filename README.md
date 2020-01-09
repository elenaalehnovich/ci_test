#Steps for setup

1. Install Salesforce CLI. https://developer.salesforce.com/tools/sfdxcli
2. Create a Self-Signed SSL Certificate and Private Key
    - Download: http://gnuwin32.sourceforge.net/packages/openssl.htm
    - Create a private key and self signed certificate using following instructions:
        -- Set OPENSSL_CONF path  
            set OPENSSL_CONF=C:\openssl\share\openssl.cnf 
        -- Generate an RSA private key :  
            openssl genrsa -des3 -passout pass:SomePassword -out server.pass.key 2048
        -- Create a key file from the server.pass.key file : 
            openssl rsa -passin pass:SomePassword -in server.pass.key -out server.key
        -- Request and generate the certificate :
            openssl req -new -key server.key -out server.csr
        -- Generate the SSL certificate: 
            openssl x509 -req -sha256 -days 365 -in server.csr -signkey server.key -out server.crt
3. Create Connected App for JWT-Based Flow in the Dev hub org
   - Created Connected App
   - Callback URL: http://localhost:1717/OauthRedirect
   - Choose permissions: 'Perform requests on your behalf at any time', 'Access your basic information', 'Provide access to your data via the Web'
    'Access and manage your data' 
   - Use digital signatures To upload your server.crt file.
   - Edit policy and select "Admin approved users are pre-authorized" to avoid "Not approved for access in salesforce" issue. 
   - Assign Connected App to user or System Admin prof ile.
4. Setup Jenkins
   - Install Jenkins. https://jenkins.io/download/
   - Login to Jenkins (by default for local runner server: localhost:8080)
   - Install Git + GitHub(BitBucket/GitLab whatever you use as source repo) + Custom Tool + Pipeline Utility Steps 
        + Warnings Next Generation + Slack Notification plugins in Jenkins
   - Configure the the Server.key from step 2 in the Jenkins credentials.
   (Jenkins -> Credentials -> Add new -> Upload server.key as Secret File)
   - Configure Slack integration follow the instructions using: https://my.slack.com/services/new/jenkins-ci
6. Configure GitHub webhooks
    - Go to {Repository} > Settings > Hooks and services > Add webhook
    - Payload URL: http://{JENKINS_UR}/github-webhook/ 
    (for test where Jenkins is running on local server following instructions from Step 5 could be used: https://webhookrelay.com/blog/2017/11/23/github-jenkins-guide)
    - Content type: Application/json
    - Check 'Send me everything'.
    
# Jenkins Job configuration

1.  Set Environment variable:
    #HUB_ORG_DH:- The username for the Dev Hub org
    #SFDC_HOST_DH:- The login URL of the Salesforce instance that is hosting the Dev Hub org. The default is https://login.salesforce.com
    CONNECTED_APP_CONSUMER_KEY_DH :- The consumer key that was returned after you created a connected app in your Dev Hub org.
    JWT_CRED_ID_DH:- The credentials ID for the private key file from Jenkins (server.key)
2. Update Configs:
    - Set branches, org usernames and instances in config.properties file
    - Set Slack Channel name where build result will be sent as channel_name in config.properties file
    - Set directory for tests result save as tests_dir in config.properties file
3. Create Jenkins job
    - Go to Jenkins -> Create new Item -> Multibranch PIpeline
    - Add new GitHub source in Branching Sources
    - Specify Repository HTTPS URL as your GitHUb repository and your credentials
    - In behaviours click 'Add' choose 'Filter by name (with regular expression)' where push branches which you want to handle: master|develop|uat
    - Save your job

