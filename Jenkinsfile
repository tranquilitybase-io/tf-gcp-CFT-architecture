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
                         chmod +x ./scripts/Jenkins-bootstrap-deploy.sh
                         . ./Jenkins-bootstrap-deploy.sh
                         '''
//                          echo $org_id
//                          cd ./scripts/bootstrap
//                          rm terraform.example.tfvars && touch terraform.tfvars
//                          echo org_id = \"'$org_id'\">> terraform.tfvars
//                          echo billing_account = \"'$billing_account'\" >> terraform.tfvars
//                          echo group_org_admins = \"'$group_org_admins'\" >> terraform.tfvars
//                          echo group_billing_admins = \"'$group_billing_admins'\" >> terraform.tfvars
//                          echo default_region = \"'$default_region'\" >> terraform.tfvars
//                          echo parent_folder = "\'$parent_folder'\" >> terraform.tfvars
//                          (sed -E "s/'([^']*)'/\"\1\"/g" terraform.tfvars) > terraform.tfvars
//                          cat terraform.tfvars
//                          cd ../..
                        
                  
//                         '''
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
