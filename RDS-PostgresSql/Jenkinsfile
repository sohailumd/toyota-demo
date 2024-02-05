pipeline {
    agent any

    stages {
        stage('AWS Creds') {
            step {

                withCredentials([[
                $class: 'AmazonWebServicesCredentialsBinding', 
                credentialsId: 'awscreds', 
                accessKeyVariable: 'AWS_ACCESS_KEY_ID', 
                secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']])
            }
        }
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
    
        stage ("terraform init") {
            steps {
                sh '''
                cd toyota-demo/RDS-PostgresSql
                ls -l
                terraform init
                '''
            }
        }
        
        stage ("plan") {
            steps {
                sh '''
                cd toyota-demo/RDS-PostgresSql
                ls -l
                terraform plan -var -var="access_key=${access_key}" -var="secret_access_key=${secret_access_key}"
                '''
            }
        }

        stage ("Action") {
            steps {
                sh '''
                echo "Terraform action is --> ${action}"
                cd toyota-demo/RDS-PostgresSql
                ls -l
                terraform ${action} -auto-approve -var="access_key=${access_key}" -var="secret_access_key=${secret_access_key}"
                '''
           }
        }
    }
}
    
