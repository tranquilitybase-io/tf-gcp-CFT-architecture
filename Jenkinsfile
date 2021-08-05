pipeline {
    agent {
        kubernetes {
          label 'kubepod'  // all your pods will be named with this prefix, followed by a unique id
          //defaultContainer 'gcloud'  // define a default container if more than a few stages use it, will default to jnlp container
        }
    }
    //environment {
       // def landing_zone_params = "${landing_zone_params}"
        //def environment_params = "${environment_params}"
        
  // }
    stages {
        
        stage ('Test received params') {
            steps {
                sh 'echo Test received params'
//                 sh "echo \$landing_zone_params"
//                 sh "echo \$environment_params"
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
       stage('Install Dependencies') {
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
                     sh ''' 
                         chmod +x ./scripts/bootstrap//Jenkins-bootstrap-deploy.sh
                         . ./scripts/bootstrap/Jenkins-bootstrap-deploy.sh
                         '''

                     }
                 }
             }
             stage('Deploy CFT Org1') {
             steps {
                 container('gcloud') {
                     sh ''' 
                        cd ./scripts/org
                        rm terraform.example.tfvars env-variables-example.sh && touch terraform.tfvars env-variables.sh
                        echo export CLOUD_BUILD_PROJECT_ID=prj-b-cicd >> env-variables.sh
                        echo "Pending"
                  
                     '''
                   }
                }
            
            }
    }
    
}
