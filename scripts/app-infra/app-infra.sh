terraform output cloudbuild_project_id
gcloud source repos clone gcp-policies --project=YOUR_INFRA_PIPELINE_PROJECT_ID
cd gcp-policies
cp -RT ../terraform-example-foundation/policy-library/ .
git add .
git commit -m 'Your message'
git push --set-upstream origin master
cd ..
gcloud source repos clone bu1-example-app --project=YOUR_INFRA_PIPELINE_PROJECT_ID
cd bu1-example-app
git checkout -b plan
cp -RT ../terraform-example-foundation/5-app-infra/ .
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
