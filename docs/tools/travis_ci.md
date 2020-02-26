# Travis CI Setup
Setting up Travis CI with credentials to access the Google Cloud Platform registry.

## Install Travis CLI

```console
brew install ruby
gem update --system
gem install travis -v 1.8.10
```

## Create Service Account Key
Create a service account named `travis-ci`

```console
gcloud beta iam service-accounts create travis-ci \
    --description "Travis CI Service Account" \
    --display-name "travis-ci"
```

Add the following role

```console
gcloud projects add-iam-policy-binding "distributed-email-pipeline" \
    --member="serviceAccount:travis-ci@distributed-email-pipeline.iam.gserviceaccount.com" \
    --role roles/owner
```

Create a JSON key and store it.

```console
gcloud iam service-accounts keys create \
    ~/.config/gcloud/travis-ci_service_account.json \
    --iam-account "travis-ci@distributed-email-pipeline.iam.gserviceaccount.com"
```

## Login to Travis

```console
travis login --pro
```

## Encrypt Service Account Key
Encrypt the file for chosen repository.

```console
travis encrypt-file ~/.config/gcloud/travis-ci_service_account.json --add --repo CathalMullan/[REPO_NAME]
```

From here, you can move the generated json file to a sub-directory, and alter the `.travis.yml` file as needed.
