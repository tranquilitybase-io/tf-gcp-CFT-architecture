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
       def bootstrap_params = "${bootstrap_params}"
       def org_params = "${$org_params}"
       def environments_params = "${environments_params}"
       def networks_params = "${networks_params}"
       def projects_params = "${projects_params}"
       def app_infra_params = "${app_infra_params}"
        
  }
    stages {
        
        stage ('Test received params') {
            steps {
                sh '''
                echo \"$environment_params\"
                echo \"$landing_zone_params\"
                echo \"$bootstrap_params\"
                echo \"$org_params\"
                echo \"$environments_params\"
                echo \"$networks_params\"
                echo \"$projects_params\"
                echo \"$app_infra_params\"
                '''
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
                         wget -O /tmp/terraform.zip https://releases.hashicorp.com/terraform/0.14.6/terraform_0.14.6_linux_amd64.zip
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
                        '''
//                          cd ./scripts/0-bootstrap/ && echo \"$bootstrap_params\" | jq "." > terraform.auto.tfvars.json
//                          cat terraform.auto.tfvars.json
//                          cd ../.. && make bootstrap
//                          echo "bootstrap layer done"
//                          '''
    
                 }
               
             }
         }
          stage('Deploy CFT 1-org') {
             steps {
                 container('gcloud') {
                     sh """
                        export terraform_service_account=\"hdhdhdhd\"
                        echo $terraform_service_account
                        sed -e 's/^"//' -e 's/"$//' <<< ${terraform_service_account}
                        echo $terraform_service_account
                        """
//                          cd ./bootstrap/terraform-example-foundation/0-bootstrap && export CLOUD_BUILD_PROJECT_ID=$(terraform output cloudbuild_project_id)
//                          sed -e 's/^"//' -e 's/"$//' <<<"$terraform_service_account" && export terraform_service_account=$(terraform output terraform_service_account)
//                          cd ./../../../scripts/1-org/ && sa_json=$(jq -n --arg sa "$terraform_service_account" '{terraform_service_account: $sa}')
//                          echo \"$org_params\" | jq "." > terraform.auto.tfvars.json && echo $sa_json | jq "." >> terraform.auto.tfvars.json
//                          gcloud config set project $CLOUD_BUILD_PROJECT_ID
//                          echo $terraform_service_account && cat terraform.auto.tfvars.json
//                          cd ../.. && make org
//                          echo "1-org done"
//                          '''
    
                 }
               
             }
         }
         stage('Deploy CFT env') {
             steps {
                 container('gcloud') {
                     sh '''
                        '''
                        //  cd ./bootstrap/terraform-example-foundation/0-bootstrap && export CLOUD_BUILD_PROJECT_ID=$(terraform output cloudbuild_project_id)
                        //  export terraform_service_account=$(terraform output terraform_service_account)
                        //  cd ./../../../scripts/2-environments/ && echo \"$environment_params\" | jq "." > terraform.auto.tfvars.json
                        //  cd ../.. && make env
                        //  echo "2-environments done"
                        //  '''
    
                 }
               
             }
         }
        stage('Deploy CFT networks') {
             steps {
                 container('gcloud') {
                     sh '''
                        echo "Done"
                        '''
//                          cd ./bootstrap/terraform-example-foundation/0-bootstrap && export CLOUD_BUILD_PROJECT_ID=$(terraform output cloudbuild_project_id)
//                          export terraform_service_account=$(terraform output terraform_service_account)
//                          cd ./../../../scripts/3-networks/ && echo \"$environment_params\" | jq "." > common.auto.tfvars.json 
//                          mv shared.auto.example.tfvars ./shared.auto.tfvars && echo \"$environment_params\" | jq "." > access_context.auto.tfvars.json
//                          cd ../.. && make networks
//                          echo "3-networks  done"
//                          '''
    
                 }
               
             }
         }
         stage('Deploy CFT projects') {
             steps {
                 container('gcloud') {
                     sh '''
                        echo "Done"
                        '''
//                          cd ./bootstrap/terraform-example-foundation/0-bootstrap && export CLOUD_BUILD_PROJECT_ID=$(terraform output cloudbuild_project_id)
//                          export terraform_service_account=$(terraform output terraform_service_account)
//                          cd ./../../../scripts/4-projects/ && echo \"$environment_params\" | jq "." > common.auto.tfvars.json 
//                          mv shared.auto.example.tfvars ./shared.auto.tfvars && echo \"$environment_params\" | jq "." > access_context.auto.tfvars.json
//                          echo \"$environment_params\" | jq "." > development.auto.tfvars.json && cd ../.. && make networks
//                          echo "4-projects done"
//                          '''
    
                 }
               
             }
         }
    
    
    }
    
    
    
}
