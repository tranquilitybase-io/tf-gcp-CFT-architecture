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
         stage('Deploy CFT Bootstrap') {
             steps {
                 container('gcloud') {
//                      sh "cd ./scripts/bootstrap"
                     sh "git clone https://github.com/terraform-google-modules/terraform-example-foundation.git"
                     sh "cd ./terraform-example-foundation/0-bootstrap/"
                     sh "echo \$landing_zone_params | jq '.' > terraform.tfvars.json"
                     sh "cat terraform.tfvars.json"
                     sh "echo Running terraform init"
                     sh "terraform init"
                     sh "echo Running terraform plan"
                     sh "terraform plan -out cft-bootstrap-plan"
                     sh "terraform apply -auto-approve cft-bootstrap-plan"
                 }
               
             }
         }
    }
}
    

