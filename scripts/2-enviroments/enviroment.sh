echo looking for past deployments to delete:
ENV_FOLDER=./env
[ -d $ENV_FOLDER ] && { echo "Removing past deployment file $ENV_FOLDER"; rm -rf $ENV_FOLDER; } || echo "No past deployments found"

echo Creating root env folder
mkdir env
cd ./env

echo Cloning CFT
CFT_FOLDER=./terraform-example-foundation
[ -d $CFT_FOLDER ] && { echo "Removing past deployment file: $CFT_FOLDER"; rm -rf $CFT_FOLDER; } || echo "No past deployments found"
git clone https://github.com/terraform-google-modules/terraform-example-foundation.git

echo looking for past env folder:
GCP_POLICIES_FOLDER=./gcp-environments
[ -d $GCP_POLICIES_FOLDER ] && { echo "Removing past deployment file: $GCP_POLICIES_FOLDER"; rm -rf $GCP_POLICIES_FOLDER; } || echo "No past deployments found"

echo Cloning gcp environments GSR
gcloud source repos clone gcp-environments --project=$CLOUD_BUILD_PROJECT_ID
cd gcp-environments

echo Copying needed build files
git checkout -b plan
cp -RT ../terraform-example-foundation/2-environments/ .
cp ../terraform-example-foundation/build/cloudbuild-tf-* .
cp ../terraform-example-foundation/build/tf-wrapper.sh .
chmod 755 ./tf-wrapper.sh

echo Removing unneeded variables
TF_EXAMPLE_VARS=./terraform.example.tfvars
[ -f $TF_EXAMPLE_VARS ] && { echo "Removing unneeded terraform.example.tfvars file: $TF_EXAMPLE_VARS"; rm $TF_EXAMPLE_VARS; } || { echo "No terraform.example.tfvars file found"; exit 1; }

echo Copying in needed variables
TF_VARS=../../scripts/2-environments/terraform.tfvars
COPY_LOCATION=.
[ -f $TF_VARS ] && { echo "Copying $TF_VARS to $COPY_LOCATION"; cp $TF_VARS $COPY_LOCATION; } || { echo "No $TF_VARS file found"; exit 1; }

echo pushing plan
git add .
git commit -m 'Your message'
git push --set-upstream origin plan --force

sleep 300

git checkout -b development
git push origin development

sleep 300

git checkout -b non-production
git push origin non-production

sleep 300

git checkout -b production
git push origin production