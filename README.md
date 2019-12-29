#Setup

1. Install Salesforce CLI. https://developer.salesforce.com/tools/sfdxcli
2. Create a Self-Signed SSL Certificate and Private Key
    - Download: http://gnuwin32.sourceforge.net/packages/openssl.htm
    - Create a private key and self signed certificate
    - Set OPENSSL_CONF path  
        set OPENSSL_CONF=C:\openssl\share\openssl.cnf 
    - Generate an RSA private key :  
        openssl genrsa -des3 -passout pass:x -out server.pass.key 2048
    - Create a key file from the server.pass.key file : 
        openssl rsa -passin pass:x -in server.pass.key -out server.key
    - Request and generate the certificate :
        openssl req -new -key server.key -out server.csr
    - Generate the SSL certificate: 
        openssl x509 -req -sha256 -days 365 -in server.csr -signkey server.key -out server.crt
3. Create Connected App for JWT-Based Flow in the Dev hub org
   - Created Connected App
   - Callback URL: http://localhost:1717/OauthRedirect
   - Use digital signatures To upload your server.crt file.
   - Edit policy and select "Admin approved users are pre-authorized" to avoid "Not approved for access in salesforce" issue. 
   - Assign Connected App to user or System Admin profile.
4. Setup Jenkins
   - Install Jenkins. https://jenkins.io/download/
   - Login to Jenkins (localhost:8080)
   - Install Git + GitHub(BitBucket/GitLab whatever you use as source repo) + Custom Tool plugins in Jenkins
   - Configure the the Server.key from step 2 in the credential plugins.(Jenkins -> Credentials -> Add new -> Upload server.key as Secret File)
5. Configure the Jenkins environment Variable
   - Set Environment variable:
        HUB_ORG_DH:- The username for the Dev Hub org
        SFDC_HOST_DH:- The login URL of the Salesforce instance that is hosting the Dev Hub org. The default is https://login.salesforce.com
        CONNECTED_APP_CONSUMER_KEY_DH :- The consumer key that was returned after you created a connected app in your Dev Hub org.
        JWT_CRED_ID_DH:- The credentials ID for the private key file from Jenkins (server.key)
6. Add Jenkins file to the root of the Git folder
7. relay-windows-amd64.exe forward --bucket github-jenkins http://localhost:8080/github-webhook/
https://webhookrelay.com/blog/2017/11/23/github-jenkins-guide/__
