NETWORKS_FOLDER=./networks
[ -d $NETWORKS_FOLDER ] && { echo "Removing past deployment file $NETWORKS_FOLDER"; rm -rf $NETWORKS_FOLDER; } || echo "No past deployments found"

echo Creating networks folder
mkdir networks
cd ./networks



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

echo Local shared file TF apply
cd ./envs/shared/
rm  ./backend.tf
cp ../../backend.tf .
terraform init
terraform plan
terraform apply
cd ../..

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