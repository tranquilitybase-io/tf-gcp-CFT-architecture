#!/bin/bash

cd ./scripts/bootstrap
rm terraform.example.tfvars && touch terraform.tfvars
echo org_id = "\"$org_id"\" >> terraform.tfvars
echo billing_account = "\"$billing_account"\" >> terraform.tfvars
echo group_org_admins ="\"$group_org_admins"\" >> terraform.tfvars
echo group_billing_admins ="\"$group_billing_admins"\" >> terraform.tfvars
echo default_region = "\"$default_region"\" >> terraform.tfvars
echo parent_folder = "\"$parent_folder"\" >> terraform.tfvars
cat terraform.tfvars
cd ../..
make bootstrap

