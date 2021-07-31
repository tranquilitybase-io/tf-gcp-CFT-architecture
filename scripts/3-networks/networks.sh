NETWORKS_FOLDER=./networks
[ -d $NETWORKS_FOLDER ] && { echo "Removing past deployment file $NETWORKS_FOLDER"; rm -rf $NETWORKS_FOLDER; } || echo "No past deployments found"

echo Creating networks folder
mkdir networks
cd ./networks

echo sourcing required variables
source ./scripts/3-networks/env-variables.sh

echo Cloning CFT
CFT_FOLDER=./terraform-example-foundation
[ -d $CFT_FOLDER ] && { echo "Removing past deployment file: $CFT_FOLDER"; rm -rf $CFT_FOLDER; } || echo "No past deployments found"
git clone https://github.com/terraform-google-modules/terraform-example-foundation.git

echo Cloning gcp networks GSR
GCP_NETWORKS_FOLDER=./gcp-networks
[ -d $GCP_NETWORKS_FOLDER ] && { echo "Removing past deployment file: $GCP_NETWORKS_FOLDER"; rm -rf $GCP_NETWORKS_FOLDER; } || echo "No past deployments found"
gcloud source repos clone gcp-networks --project=$CLOUD_BUILD_PROJECT_ID
cd gcp-networks

echo checkout plan
git checkout -b plan

echo Copying needed build files
cp -R ../terraform-example-foundation/3-networks/ .
cp ../terraform-example-foundation/build/cloudbuild-tf-* .
cp ../terraform-example-foundation/build/tf-wrapper.sh .
chmod 755 ./tf-wrapper.sh


echo Removing unneeded backend example file
TF_EXAMPLE_VARS=./backend-example.tf
[ -f $TF_EXAMPLE_VARS ] && { echo "Removing unneeded $TF_EXAMPLE_VARS file: $TF_EXAMPLE_VARS"; rm $TF_EXAMPLE_VARS; } || { echo "No $TF_EXAMPLE_VARS file found"; exit 1; }

echo Copying in needed backend example file
TF_VARS=../../scripts/3-networks/backend.tf
COPY_LOCATION=./envs/shared/
[ -f $TF_VARS ] && { echo "Copying $TF_VARS to $COPY_LOCATION"; cp $TF_VARS $COPY_LOCATION; } || { echo "No $TF_VARS file found"; exit 1; }

echo Local shared file TF apply
cd ./envs/shared/
rm  ./backend.tf
cp ../../backend.tf .
terraform init
terraform plan
terraform apply
cd ../..

echo Removing unneeded access context variables
TF_EXAMPLE_VARS=./access_context.auto.example.tfvars
[ -f $TF_EXAMPLE_VARS ] && { echo "Removing unneeded $TF_EXAMPLE_VARS file: $TF_EXAMPLE_VARS"; rm $TF_EXAMPLE_VARS; } || { echo "No $TF_EXAMPLE_VARS file found"; exit 1; }

echo Copying in needed access context variables
TF_VARS=../../scripts/2-environments/access_context.auto.tfvars
COPY_LOCATION=.
[ -f $TF_VARS ] && { echo "Copying $TF_VARS to $COPY_LOCATION"; cp $TF_VARS $COPY_LOCATION; } || { echo "No $TF_VARS file found"; exit 1; }

echo Removing unneeded common variables
TF_EXAMPLE_VARS=./common.auto.example.tfvars
[ -f $TF_EXAMPLE_VARS ] && { echo "Removing unneeded $TF_EXAMPLE_VARS file: $TF_EXAMPLE_VARS"; rm $TF_EXAMPLE_VARS; } || { echo "No $TF_EXAMPLE_VARS file found"; exit 1; }

echo Copying in needed common variables
TF_VARS=../../scripts/2-environments/common.auto.tfvars
COPY_LOCATION=.
[ -f $TF_VARS ] && { echo "Copying $TF_VARS to $COPY_LOCATION"; cp $TF_VARS $COPY_LOCATION; } || { echo "No $TF_VARS file found"; exit 1; }

echo Removing unneeded shared variables
TF_EXAMPLE_VARS=./shared.auto.example.tfvars
[ -f $TF_EXAMPLE_VARS ] && { echo "Removing unneeded $TF_EXAMPLE_VARS file: $TF_EXAMPLE_VARS"; rm $TF_EXAMPLE_VARS; } || { echo "No $TF_EXAMPLE_VARS file found"; exit 1; }

echo Copying in needed shared variables
TF_VARS=../../scripts/2-environments/shared.auto.example.tfvars
COPY_LOCATION=.
[ -f $TF_VARS ] && { echo "Copying $TF_VARS to $COPY_LOCATION"; cp $TF_VARS $COPY_LOCATION; } || { echo "No $TF_VARS file found"; exit 1; }

echo Pushing plan
git add .
git commit -m 'Your message'
git push --set-upstream origin plan

sleep 300

git checkout -b production
git push origin production

sleep 300

git checkout -b development
git push origin development

sleep 300

git checkout -b non-production
git push origin non-production