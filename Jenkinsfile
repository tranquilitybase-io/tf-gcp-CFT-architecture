pipeline {
    agent {
        kubernetes {
          label 'kubepod'  // all your pods will be named with this prefix, followed by a unique id
        //   defaultContainer 'terraform'  // define a default container if more than a few stages use it, will default to jnlp container
        }
    }
    //environment {
        //ORG_ID = credentials('org_id')
        
   // }
    stages {
        stage('Configure Gcloud') {
            steps {
                
                container('gcloud') {
                    sh ''' 
                        cat $GOOGLE_APPLICATION_CREDENTIALS
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
        //git clone https://github.com/tranquilitybase-io/tf-gcp-CFT-architecture.git  
        // make bootstrap
        }
        stage('Deploy CFT Bootstrap') {
            steps {
                container('gcloud') {
                    sh ''' 
                        pwd
                        ls
                        echo $org_id
                        cd ./tf-gcp-CFT-architecture/scripts/bootstrap
                        rm terraform.example.tfvars
                        echo org_id = "\"$org_id"\">> terraform.tfvars
                        echo billing_account = "" >> terraform.tfvars
                        echo group_org_admins = "" >> terraform.tfvars
                        echo group_billing_admins = '""' >> terraform.tfvars
                        echo default_region = "" >> terraform.tfvars
                        echo parent_folder = "" >> terraform.tfvars
                        cat terraform.tfvars
                        cd ../..
                  
                    '''
                }
            }
            
        }
    }
    
} 
