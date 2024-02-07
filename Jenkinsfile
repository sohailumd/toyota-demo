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
                    sh """
                    git clone git@github.com:sohailumd/toyota-demo.git
                    ls -l
                    cd demo-ddl-dml

					def sqlQueryforCreateTable = readFile('psql_script/Table_Create.sql')
                    def sqlQueryforInsertRows  = readFile('psql_script/Table_Insert.sql')
                    pwd
                    ls -l
					PGPASSWORD=${PG_pg_PSW} psql -h ${env.PG_HOST} -p ${env.PG_PORT} -d ${env.PG_DATABASE} -U ${PG_pg_USR} -c \"${sqlQueryforCreateTable}\"
                    PGPASSWORD=${PG_pg_PSW} psql -h ${env.PG_HOST} -p ${env.PG_PORT} -d ${env.PG_DATABASE} -U ${PG_pg_USR} -c \"${sqlQueryforInsertRows}\"
					echo "HURRAY"
					"""
                }
            }
        }
    }
}