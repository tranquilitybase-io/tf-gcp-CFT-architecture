#!/bin/bash

cd ./scripts/org
echo export CLOUD_BUILD_PROJECT_ID=prj-b-cicd-416c >> env-variables.sh
echo domains_to_allow = ["\"$domains_to_allow"\"] >> terraform.tfvars
echo billing_data_users = "\"$billing_data_users"\" >> terraform.tfvars
echo audit_data_users = "\"$audit_data_users"\" >> terraform.tfvars
echo org_id = "\"$org_id"\" >> terraform.tfvars
echo billing_account = "\"$billing_account"\" >> terraform.tfvars
echo terraform_service_account = "\"$terraform_service_account"\" >> terraform.tfvars
echo default_region = "\"$default_region"\" >> terraform.tfvars
echo scc_notification_name = "\"$scc_notification_name"\" >> terraform.tfvars
echo create_access_context_manager_access_policy = "false" >> terraform.tfvars
echo parent_folder =  "\"$parent_folder"\" >> terraform.tfvars
cat terraform.tfvars
cd ../..
make org

