# tf-gcp-CFT-architecture

##  GFT - Terraform-Cloud Foundation Toolkit for creating Landing Zones. (draft)

## Table of Contents

* [Table of Contents](#table-of-contents)

     * [Prerequisites](#prerequisites)
     * [The Deployment Process (Overview)](#the-deployment-process-overview)
     * [0-bootstrap](#0-bootstrap)
     * [1-org](#1-org)
     * [2-environment](#2-environment)
     * [3-network](#3-network)
     * [FAQ](#FAQ)
         
 

## Prerequisites
  
  To run the commands described in this document, you need to have the following installed:
  
  The Google Cloud SDK version 319.0.0 or later
  Terraform version 0.13.7.
  An existing project which the user has access to be used by terraform-validator.
      Note: Make sure that you use the same version of Terraform throughout this series. Otherwise, you might experience Terraform state snapshot lock errors.

   Also make sure that you've done the following:

   Set up a Google Cloud organization.
   Set up a Google Cloud billing account.
   Created Cloud Identity or Google Workspace (formerly G Suite) groups for organization and billing admins.
   Added the user who will use Terraform to the group_org_admins group. They must be in this group, or they won't have roles/resourcemanager.projectCreator access.
   For the user who will run the procedures in this document, granted the following roles:
   The roles/resourcemanager.organizationAdmin role on the Google Cloud organization.
   The roles/billing.admin role on the billing account.
   The roles/resourcemanager.folderCreator role.
   If other users need to be able to run these procedures, add them to the group represented by the org_project_creators variable. For more information about the permissions that are required, and the resources that          are created, see the organization bootstrap module documentation.

## The Deployment Process (Overview)

<img width="1018" alt="Screenshot 2021-07-27 at 11 43 57 am" src="https://user-images.githubusercontent.com/80045831/127141366-262007ca-c4a6-48c5-a0bc-b89bdeb694a8.png">


## 0-bootstrap
This repo is part of a multi-part guide that shows how to configure and deploy the example.com reference architecture described in Google Cloud security foundations guide (PDF). 

### Instructions: 

	git clone https://github.com/tranquilitybase-io/tf-gcp-CFT-architecture.git
	
	cd ./tf-gcp-CFT-architecture/scripts/bootstrap
	
Edit the file called "terraform.example.tfvars"	
Rename the file "terraform.example.tfvars" to "terraform.tfvars"

	cd ../..
	
	make bootstrap
	
Go to the folder:
	
	tf-gcp-CFT-architecture/bootstrap/terraform-example-foundation/0-bootstrap$

Note the email address of the admin. You need this address in a later procedure.

	 terraform output terraform_service_account

## 1-org
This repo is part of a multi-part guide that shows how to configure and deploy the example.com reference architecture described in Google Cloud security foundations guide (PDF). 

### Instructions: 

	cd ./tf-gcp-CFT-architecture/scripts/bootstrap
	
Edit the file called "terraform.example.tfvars"	 with your project information

Rename the file "terraform.example.tfvars" to "terraform.tfvars"

    	mv terraform.example.tfvars terraform.tfvars

Edit the file called "env-variables-example.sh" and rename the file "env-variables-example.sh" to env-variables.sh 
export CLOUD_BUILD_PROJECT_ID=<project_id>
Project Id is the project id of the CI/CD ex (prj-b-cicd-7a1a)

   	mv env-variables-example.sh env-variables.sh
	
Run org.sh

	cd ../..
	make org


# Frequently Asked Questions

## Why am I encountering a low quota with projects created via Terraform?

If you are running the Terraform Project Factory using Service Account credentials, the quota will be based on the
reputation of your service account rather than your user identity. In many cases, this quota is initially low.

If you encounter such quota issues, you should consider opening a support case with Google Cloud to have your quota lifted.

## How should I organize my Terraform structure?

The specific directory structure which works for your organization can vary, but there two principles you should keep in mind:

1. Minimize how many resources are contained in each directory. In general, try to have each directory of Terraform config control no more than a few dozen resources. For the project factory, this means each directory should typically only contain a few projects.

2. Mirror organizational boundaries. It should be very easy for a team to find where their projects are configured, and the easiest way to do this is typically to have the directory structure mirror your organizational structure.

With these principles in mind, this is a structure we've seen organizations successfully implement:

```
Projects Repo
|-- terraform/
|---- config.tf
|---- terraform.tfvars
|---- team1/
|------ config.tf
|------ main.tf
|------ terraform.tfvars
|------ projects.tf
|---- team2/
|---- team3/
```

In this structure, the `config.tf` in the root `terraform/` directory can be symlinked into each of the team directories, as can the `terraform.tfvars` file to store common variables (such as the organization ID). The projects for each team live within that team's `projects.tf` file.

## Where should I store my Terraform state?

We recommend that Terraform state be stored on Google Cloud Storage, using the [gcs backend](https://www.terraform.io/docs/backends/types/gcs.html).

In keeping with the recommended directory structure above, we recommend using a single GCS bucket for the configuration, with separate prefixes for each team. For example:

```hcl
terraform {
  backend "gcs" {
    bucket  = "tf-state-projects"
    prefix  = "terraform/state/team1"
  }
}
```

## Can you expand on why the project factory adds all API Service Accounts to a group?

The purpose of the `api_sa_group` variable is to provide a group where all the [Google-managed service accounts](https://cloud.google.com/iam/docs/service-accounts#google-managed_service_accounts) will automatically be placed for your projects. This is useful to allow them to pull common resources such as shared VM images which products like Managed Instance Groups need access to.

## How do I fork the module?

If you want to modify a module to make customizations, we recommend that you fork it to an internal or external Git repository, with each module getting its own repository.

These forks can then be [referenced directly](https://www.terraform.io/docs/modules/sources.html#generic-git-repository) from Terraform, as follows:

```
module "vpc" {
  source = "git::https://my-git-instance/terraform/terraform-google-project-factory.git"
}
```

## How does the project factory work with a Shared VPC?

The Project Factory supports *attaching* projects to a Shared VPC, while the [Network Factory](https://github.com/terraform-google-modules/terraform-google-network) supports *creating* a shared VPC.

The pattern we encourage is to:

1. Create a Shared VPC host project using the Project Factory
2. Create a shared network in that project using the Network Factory
3. Create additional service projects and attach them to the Shared VPC using the Project Factory

## Why do you delete the default Service Account?

By default, every project comes configured with a [default Service Account](https://cloud.google.com/compute/docs/access/service-accounts#compute_engine_default_service_account). While this Service Account is convenient, it comes with  risks as it automatically has Editor access to your project and is automatically used for gcloud commands or the UI. This can lead to security threats where instances are launched with access they don't need and are compromised.

Therefore, the Project Factory deletes the default Service Account to prevent these risks. In its place, it creates a new Service Account which has a number of advantages:

1. No default roles. This Service Account doesn't have access to any GCP resources unless you explicitly grant them.

2. No default usage. With the default Service Account deleted, you have to be explicit in choosing a Service Account for VMs which ensures developers make an informed choice when deciding what access level to give applications.

