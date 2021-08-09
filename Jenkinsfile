pipeline {
    agent {
        kubernetes {
          label 'kubepod'  // all your pods will be named with this prefix, followed by a unique id
          defaultContainer 'gcloud'  // define a default container if more than a few stages use it, will default to jnlp container
        }
    }
    environment {
       def landing_zone_params = "${landing_zone_params}"
       def environment_params = "${environment_params}"
       
        
  }
    stages {
        
        stage ('Test received params') {
            steps {
                sh "echo \$landing_zone_params"
                sh "echo \$environment_params"
            }
        }
        stage('Activate GCP Service Account and Set Project') {
            steps {
                
                container('gcloud') {
                    sh ''' 
                        gcloud auth activate-service-account --key-file=$GOOGLE_APPLICATION_CREDENTIALS
                        gcloud config list
                       '''
                }
            }
            
        }
       stage('Setup Terraform & Dependencies') {
             steps {
                 container('gcloud') {
                     sh ''' 
                         apt-get -y install jq wget unzip
                         wget -O /tmp/terraform.zip https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip
                         unzip -q /tmp/terraform.zip -d /tmp
                         chmod +x /tmp/terraform
                         mv /tmp/terraform /usr/local/bin
                         rm /tmp/terraform.zip
                         terraform --version
                        '''
                 }
             }

         }
         stage('Deploy CFT 0-bootstrap') {
             steps {
                 container('gcloud') {
                     sh '''
                         echo $environment_params
                         cd ./scripts/0-bootstrap/ && echo \"$environment_params\" | jq "." > terraform.auto.tfvars.json
                         cat terraform.auto.tfvars.json
                         cd ../.. && make bootstrap
                         echo "bootstrap layer done"
                         '''
    
                 }
               
             }
         }
          stage('Deploy CFT 1-org') {
             steps {
                 container('gcloud') {
                     sh '''
                         cd ./bootstrap/terraform-example-foundation/0-bootstrap && export CLOUD_BUILD_PROJECT_ID=$(terraform output cloudbuild_project_id)
                         export terraform_service_account=$(terraform output terraform_service_account)
                         cd ./../../../scripts/bootstrap/ && sa_json=$(jq -n --arg sa "$terraform_service_account" '{terraform_service_account: $sa}') && rm terraform.example.tfvars 
                         echo \"$environment_params\" | jq "." > terraform.auto.tfvars.json && echo \"$sa_json\" | jq "." >> terraform.auto.tfvars.json
                         cat terraform.auto.tfvars.json
                         cd ../.. && make org
                         echo "1-org layer done"
                         '''
    
                 }
               
             }
         }
    
    
    }
    
    
    
}
