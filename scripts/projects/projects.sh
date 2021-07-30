gcloud source repos clone gcp-projects --project=YOUR_CLOUD_BUILD_PROJECT_ID
git checkout -b plan
cp -RT ../terraform-example-foundation/4-projects/ .
cp ../terraform-example-foundation/build/cloudbuild-tf-* .
cp ../terraform-example-foundation/build/tf-wrapper.sh .
chmod 755 ./tf-wrapper.sh
git add .
git commit -m 'Your message'
git push --set-upstream origin plan
git checkout -b production
git push origin production
git checkout -b development
git push origin development
git checkout -b non-production
git push origin non-production