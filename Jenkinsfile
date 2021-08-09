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
       def bootstrap_folder = "terraform-example-foundation/0-bootstrap" 
        
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
         stage('Deploy CFT Bootstrap') {
             steps {
                 container('gcloud') {
                     sh "git clone https://github.com/terraform-google-modules/terraform-example-foundation.git"
                     sh "echo \'$landing_zone_params\' | jq '.' > $bootstrap_folder/terraform.tfvars.json"
                     sh "cat $bootstrap_folder/terraform.tfvars.json"
                     sh "terraform init $bootstrap_folder"
                     sh "terraform plan -out cft-bootstrap-plan -var-file=$bootstrap_folder/terraform.tfvars.json $bootstrap_folder/"
                     sh "ls -ltr"
                     //sh "terraform apply -auto-approve cft-bootstrap-plan"
                 }
               
             }
         }
    }
}
