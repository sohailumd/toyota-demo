pipeline {
    agent any
    
    environment {
        PG_HOST = 'demo-postgresql.c4fcwcpo9bzm.us-east-2.rds.amazonaws.com'
        PG_PORT = '5432'
        PG_DATABASE = 'postgres'
        PG_pg = credentials('pgdbcreds')
    }
    
    stages {
        stage('Clone Repository') {
            steps {
                script {
                    echo 'Cloning repository...'
                    sh '''
                    git --version
                    which git
                    whoami
                    '''
                    checkout([$class: 'GitSCM', 
                              branches: [[name: 'main']], 
                              doGenerateSubmoduleConfigurations: false, 
                              extensions: [], 
                              userRemoteConfigs: [[url: 'git@github.com:sohailumd/toyota-demo.git']]])
					def sqlQuery = readFile('psql_scripts/Table_Create.sql')
                    sh """
                    pwd
                    ls -l
					PGPASSWORD=${PG_pg_PSW} psql -h ${env.PG_HOST} -p ${env.PG_PORT} -d ${env.PG_DATABASE} -U ${PG_pg_USR} -c \"${sqlQuery}\"
					echo "HURRAY"
					"""
                }
            }
        }
    }
}