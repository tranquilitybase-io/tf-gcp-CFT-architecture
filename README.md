# tf-gcp-CFT-architecture

##  GFT - Terraform-Cloud Foundation Toolkit for creating Landing Zones. (draft)

## Table of Contents

* [Table of Contents](#table-of-contents)

     * [Prerequisites](#prerequisites)
     * [The Deployment Process (Overview)](#the-deployment-process-overview)
     * [Roles and Required Access](#roles-and-access)
     * [0-bootstrap](#0-bootstrap)
     * [1-org](#1-org)
     * [2-environment](#2-environment)
     * [3-network](#3-network)
 
         
 

## Prerequisites
  
  To run the commands described in this document, you need to have the following installed:
  
  The Google Cloud SDK version 319.0.0 or later
  Terraform version 0.13.7.
  An existing project which the user has access to be used by terraform-validator.
      Note: Make sure that you use the same version of Terraform throughout this series. Otherwise, you might experience Terraform state snapshot lock errors.

   Also make sure that you've done the following:

   Set up a Google Cloud organization.
   Set up a Google Cloud billing account.
   Created Cloud Identity or Google Workspace (formerly G Suite) groups for organization and billing admins.
   Added the user who will use Terraform to the group_org_admins group. They must be in this group, or they won't have roles/resourcemanager.projectCreator access.
   For the user who will run the procedures in this document, granted the following roles:
   The roles/resourcemanager.organizationAdmin role on the Google Cloud organization.
   The roles/billing.admin role on the billing account.
   The roles/resourcemanager.folderCreator role.
   If other users need to be able to run these procedures, add them to the group represented by the org_project_creators variable. For more information about the permissions that are required, and the resources that          are created, see the organization bootstrap module documentation.

## The Deployment Process (Overview)

<img width="1018" alt="Screenshot 2021-07-27 at 11 43 57 am" src="https://user-images.githubusercontent.com/80045831/127141366-262007ca-c4a6-48c5-a0bc-b89bdeb694a8.png">

## Roles and Required Access

### User account :
-
-
-
### Service account : 
-
-



## 0-bootstrap
This repo is part of a multi-part guide that shows how to configure and deploy the example.com reference architecture described in Google Cloud security foundations guide (PDF). 

### Instructions: 
1. Git clone repo.
   ```
   git clone https://github.com/tranquilitybase-io/tf-gcp-CFT-architecture.git
   ```

1. Checkout relevant branch.
   ```
   git checkout master
   ```
1. Change into bootstrap script folder.
   ```
   cd ./tf-gcp-CFT-architecture/scripts/0-bootstrap
   ```
1. Rename `terraform.example.tfvars` to `terraform.tfvars`  
   and update the file with values from your environment.
   ```
   mv terraform.example.tfvars terraform.tfvars
   ```
1. Change back into root `./tf-gcp-CFT-architecture` directory. 
   ```
   cd ..
   ```
1. Execute bootstrap script.
   ```
   make bootstrap
   ```
1. Make note of the `cloudbuild_project_id` terraform output which will be used a later procedure.
1. Make note of the `terraform_service_account` terraform output which will be used a later procedure.
1. Make note of the `gcs_bucket_tfstate` terraform output which will be used a later procedure. 




## 1-org


### Instructions: 

1. Change into org script folder.
   ```
   cd ./tf-gcp-CFT-architecture/scripts/1-org
   ```
1. Rename `terraform.example.tfvars` to `terraform.tfvars` and update the file with values from your environment.

1. Rename `env-variables-example.sh` to `env-variables.sh` and update the file with the project id of the cicd project created within the bootstrap step.

1. Change back into root `./tf-gcp-CFT-architecture` directory.
   ```
   cd ..
   ```
1. Execute org script.
   ```
   make org
   ```


## 2-env


### Instructions:

1. Change into env script folder.
   ```
   cd ./tf-gcp-CFT-architecture/scripts/2-env
   ```
1. Rename `terraform.example.tfvars` to `terraform.tfvars` and update the file with values from your environment.

1. Rename `env-variables-example.sh` to `env-variables.sh` and update the file with the project id of the cicd project created within the bootstrap step.

1. Change back into root `./tf-gcp-CFT-architecture` directory.
   ```
   cd ..
   ```
1. Execute env script.
   ```
   make env
   ```
   
## 3-networks


### Instructions:

1. Change into networks script folder.
   ```
   cd ./tf-gcp-CFT-architecture/scripts/3-networks
   ```
1. Rename `terraform.example.tfvars` to `terraform.tfvars` and update the file with values from your environment.

1. Rename `env-variables-example.sh` to `env-variables.sh` and update the file with the project id of the cicd project created within the bootstrap step.

1. Rename `access_context.auto.example.tfvars` to `access_context.auto.tfvars` and update the file with the project id of the cicd project created within the bootstrap step.
   ```
   #You can obtain the value for the access_context_manager_policy_id variable via the following command:
   gcloud access-context-manager policies list --organization YOUR_ORGANIZATION_ID --format="value(name)"
   ```

1. Rename `backend-example.tf` to `backend-example.tf` and update the file with the project id of the cicd project created within the bootstrap step.
   ```
   #You can find the bucket name from the output gcs_bucket_tfstate from the bootstrap layer.
   ```
1. Rename `common.auto.example.tfvars` to `common.auto.tfvars` and update the file with the project id of the cicd project created within the bootstrap step.

1. Rename `shared.auto.example.tfvars` to `shared.auto.tfvars` and update the file with the project id of the cicd project created within the bootstrap step.

1. Change back into root `./tf-gcp-CFT-architecture` directory.
   ```
   cd ..
   ```
1. Execute networks script.
   ```
   make networks
   ```

## 4-projects


### Instructions:

1. Change into projects script folder.
   ```
   cd ./tf-gcp-CFT-architecture/scripts/4-projects
   ```
1. Rename `env-variables-example.sh` to `env-variables.sh` and update the file with the project id of the cicd project created within the bootstrap step.

1. Rename `access_context.auto.example.tfvars` to `access_context.auto.tfvars` and update the file with the project id of the cicd project created within the bootstrap step.
   ```bash
   #You can obtain the value for the access_context_manager_policy_id variable via the following command:
   gcloud access-context-manager policies list --organization YOUR_ORGANIZATION_ID --format="value(name)"
   ```

1. Rename `backend-example.tf` to `backend-example.tf` and update the file with the project id of the cicd project created within the bootstrap step.
   ```bash
    #You can find the bucket name from the output gcs_bucket_tfstate from the bootstrap layer.
   ```
1. Rename `common.auto.example.tfvars` to `common.auto.tfvars` and update the file with the project id of the cicd project created within the bootstrap step.

1. Rename `shared.auto.example.tfvars` to `shared.auto.tfvars` and update the file with the project id of the cicd project created within the bootstrap step.

1. Rename `development.auto.example.tfvars` to `development.auto.tfvars` and update the file with the `perimeter_name` variable from the relevant environment variable.
1. Rename `non-production.auto.example.tfvars` to `non-production.auto.tfvars` and update the file with the `perimeter_name` variable from the relevant environment variable.
1. Rename `production.auto.example.tfvars` to `production.auto.tfvars` and update the file with the `perimeter_name` variable from the relevant environment variable.

   ```bash
   #Obtaining the values for the `perimeter_name` for each environment variable.
   gcloud access-context-manager perimeters list --policy ACCESS_CONTEXT_MANAGER_POLICY_ID --format="value(name)"
   ```

   **Note:** If you have more than one service perimeter for each environment, you can also get the values from the `restricted_service_perimeter_name` output from each of the`3-networks` environments.

1. Change back into root `./tf-gcp-CFT-architecture` directory.
   ```
   cd ..
   ```
1. Execute networks script.
   ```
   make networks
   ```






