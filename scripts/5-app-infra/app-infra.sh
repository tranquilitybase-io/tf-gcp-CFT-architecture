PROJECTS_FOLDER=./app-infra
[ -d $PROJECTS_FOLDER ] && { echo "Removing past deployment file $PROJECTS_FOLDER"; rm -rf $PROJECTS_FOLDER; } || echo "No past deployments found"

echo sourcing required variables
source ./scripts/5-app-infra/env-variables.sh

echo Creating app-infra folder
mkdir app-infra
cd ./app-infra

echo Cloning CFT
CFT_FOLDER=./terraform-example-foundation
[ -d $CFT_FOLDER ] && { echo "Removing past deployment file: $CFT_FOLDER"; rm -rf $CFT_FOLDER; } || echo "No past deployments found"
git clone https://github.com/terraform-google-modules/terraform-example-foundation.git

echo Cloning gcp gcp-policies GSR
GCP_POLICIES_FOLDER=./gcp-policies
[ -d $GCP_POLICIES_FOLDER ] && { echo "Removing past deployment file: $GCP_POLICIES_FOLDER"; rm -rf $GCP_POLICIES_FOLDER; } || echo "No past deployments found"
gcloud source repos clone gcp-policies --project=$YOUR_INFRA_PIPELINE_PROJECT_ID

#TODO: cd into enviroment dir
cd gcp-projects

echo Copy review policies
cp -RT ../terraform-example-foundation/policy-library/ .

echo commit changes
git add .
git commit -m 'Your message'

echo set and push to master
git push --set-upstream origin master
cd ..

#TODO: cd into enviroment dir
echo Cloning gcp bu1-example-app GSR
GCP_PROJECTS_FOLDER=./bu1-example-app
[ -d $GCP_PROJECTS_FOLDER ] && { echo "Removing past deployment file: $GCP_PROJECTS_FOLDER"; rm -rf $GCP_PROJECTS_FOLDER; } || echo "No past deployments found"
gcloud source repos clone bu1-example-app --project=$YOUR_INFRA_PIPELINE_PROJECT_ID
cd bu1-example-app

echo Checkout bu1 example app
git checkout -b plan

echo Copy in needed files
cp -R ../terraform-example-foundation/5-app-infra/ .
cp ../terraform-example-foundation/build/cloudbuild-tf-* .
cp ../terraform-example-foundation/build/tf-wrapper.sh .
chmod 755 ./tf-wrapper.sh

git add .
git commit -m 'Your message'
git push --set-upstream origin plan

sleep 300

git checkout -b development
git push origin development

sleep 300

git checkout -b non-production
git push origin non-production

sleep 300

git checkout -b production
git push origin production
