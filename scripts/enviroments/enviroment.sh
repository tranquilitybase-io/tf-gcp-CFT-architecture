gcloud source repos clone gcp-environments --project=YOUR_CLOUD_BUILD_PROJECT_ID
cd gcp-environments
git checkout -b plan
cp -RT ../terraform-example-foundation/2-environments/ .
cp ../terraform-example-foundation/build/cloudbuild-tf-* .
cp ../terraform-example-foundation/build/tf-wrapper.sh .
chmod 755 ./tf-wrapper.sh
git add .
git commit -m 'Your message'
git push --set-upstream origin plan
git checkout -b development
git push origin development
git checkout -b non-production
git push origin non-production
git checkout -b production
git push origin production