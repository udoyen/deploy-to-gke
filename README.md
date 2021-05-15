# Terraform GCP Cluster Creating, Workload Deployment, and Exposer using an Ingress Object



## Steps:

1. Install terraform binary on your system
2. Signup and create a project if you don't have a gcp account
3. Clone the repository
4. Run the terraform from the terraform-new folder:

   1. terraform init -reconfigure
   2. terraform validate
   3. terraform plan
   4. terraform apply

4. Create a Cloud [build trigger](https://cloud.google.com/build/docs/automating-builds/create-manage-triggers#before_you_begin) for the cloned repository in **step 3**
5. To deploy the workload:
   
   1. Build the Dockerfile and push to GCP Container registery
   2. Change the image in the following files **flask.yaml**, and **cloudbuild.yaml** to your own image
   3. Create a small change and push to github to trigger the deployment, or
   4. Trigger it manually from the GCP console
