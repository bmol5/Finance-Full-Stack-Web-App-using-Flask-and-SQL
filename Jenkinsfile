pipeline {
  agent any
   stages {
    stage ('Build') {
      steps {
        sh '''#!/bin/bash
        python3 -m venv test1
        source test1/bin/activate
        pip install pip --upgrade
        pip install -r requirements.txt
        export FLASK_APP=application
        flask run &
        '''
     }
   }

    stage ('Terraform init') {
      agent{label 'terrage'}
      steps {
        withCredentials([string(credentialsId: 'AWS_ACCESS_KEY', variable: 'aws_access_key'), 
                        string(credentialsId: 'AWS_SECRET_KEY', variable: 'aws_secret_key')]) {
                            dir('Staging_Terra') {
                              sh 'terraform init' 
                            }
         }
      }
  }  
     stage('Terraform Plan') {
      agent{label 'terrage'}   
      steps {
        withCredentials([string(credentialsId: 'AWS_ACCESS_KEY', variable: 'aws_access_key'),
                        string(credentialsId: 'API_KEY', variable: 'API_KEY'), 
                        string(credentialsId: 'AWS_SECRET_KEY', variable: 'aws_secret_key')]) {
                            dir('Staging_Terra') {
                              sh 'terraform plan -out plan.tfplan -var="aws_access_key=$aws_access_key" -var="aws_secret_key=$aws_secret_key" -var="API_KEY"=$API_KEY'
                            
                            }
         }
    }
   }
     stage('Terraform Apply') {
      agent{label 'terrage'}
      steps {
        withCredentials([string(credentialsId: 'AWS_ACCESS_KEY', variable: 'aws_access_key'), 
                        string(credentialsId: 'AWS_SECRET_KEY', variable: 'aws_secret_key')]) {
                            dir('Staging_Terra') {

                              sh 'terraform apply plan.tfplan' 
                            
                            }
         }
       }
      }
  
  stage('Terraform Destroy') {
      agent{label 'terrage'}
      steps {
        withCredentials([string(credentialsId: 'AWS_ACCESS_KEY', variable: 'aws_access_key'),
        string(credentialsId: 'API_KEY', variable: 'API_KEY'),
        string(credentialsId: 'AWS_SECRET_KEY', variable: 'aws_secret_key')]) {
        dir('Staging_Terra') {
        sh 'terraform destroy -auto-approve -var="aws_access_key=$aws_access_key" -var="aws_secret_key=$aws_secret_key" -var="API_KEY"=$API_KEY'
      }
    }
  }
  }

   /*
    stage ('test') {
      steps {
        sh '''#!/bin/bash
        source test3/bin/activate
        py.test --verbose --junit-xml test-reports/results.xml
        ''' 
      }
    

      post{
        always {
          junit 'test-reports/results.xml'
        }
       
      }
    }


    stage ('e2e tests - cypress') {
      steps {

      }
    }


    
  }
  /*
  post{
    always{
      emailext to: <email>
    }
  }
  */
 }
}