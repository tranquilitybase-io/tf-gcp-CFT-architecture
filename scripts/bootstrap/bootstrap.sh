BOOTSTRAP_FOLDER=./bootstrap
[ -d $BOOTSTRAP_FOLDER ] && { echo "Removing past deployment file $BOOTSTRAP_FOLDER"; rm -rf $BOOTSTRAP_FOLDER; } || echo "No past deployments found"

echo Creating bootstrap folder
mkdir bootstrap
cd ./bootstrap

echo Cloning CFT
git clone https://github.com/terraform-google-modules/terraform-example-foundation.git
cd ./terraform-example-foundation/0-bootstrap/

echo Removing unneeded terraform files
rm terraform.example.tfvars

# echo Removing any past deployment terraform.tfvars files
# PAST_TF_VARS_FILE=./terraform.tfvars
# [ -f $PAST_TF_VARS_FILE ] && { echo "Removing past deployment file "; rm $PAST_TF_VARS_FILE; } || echo "No past deployment files found"

# echo Copying in variable file
# TF_VARS_FILE=../../../scripts/bootstrap/terraform.tfvars
# [ -f $TF_VARS_FILE ] && { echo "Copying terraform.tfvars"; cp $TF_VARS_FILE .; } || { echo "can't find $TF_VARS_FILE"; exit 1; }

echo "Running terraform init"
terraform init
echo "Running terraform plan"
terraform plan -out cft-bootstrap-plan -var-file=landing_zone_params.json 
terraform apply -auto-approve cft-bootstrap-plan
