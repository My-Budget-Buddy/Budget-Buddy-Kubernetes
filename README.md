
Budget Buddy Kubernetes
============================

## Overview
This is a project supporting the deployment of the [Budget Buddy personal finance application](https://github.com/My-Budget-Buddy) to a Kubernetes cluster.

Budget Buddy is application utilizing microservice architecture that would benefit from the pod orchestration offered by Kubernetes. This readme will guide the reader to set up Budget Buddy on an Amazon EKS cluster.

## Installation

We will assume the developer intends to deploy **staging** infrastructure. 

### Prerequisites

- An EKS cluster
- `kubectl`
- Appropriate AWS permissions

### Setting kubectl context

Run the command `aws eks --region us-east-1 update-kubeconfig --name project3-eks`, replacing the region and cluster name as necessary.

### Deploying ingress

In the root of the project, run `kubectl apply -f ./ingress.yaml -n staging`. \
\
Then, run `kubectl describe ingress -n staging`. It will output an *address* field, where you will find your load balancer address:
```
Address:          k8s-staging-ingress-af71....us-east-1.elb.amazonaws.com
```
Reference this address in your Route 53 alias record (A Record) for your staging api endpoint, e.g. *staging.api.skillstorm-congo.com*. 

### Applying resource limits

In the *Databases* folder, run `kubectl apply -f ./staging-limit-range.yaml -n staging`.

### Deploying databases

In the *Databases* folder, there is a script *deploy-database.sh* that is run the following way: `./deploy-database.sh <namespace> <postgres username> <postgres password>`. It is not recommended to run this script manually as it will mutate the file *postgres-secret.yaml* with database credentials. Instead, allow the Jenkins pipeline to work with the database deployment script.

In pipelines for staging branches, the staging database is always reset before integration, functional, and performance tests are run, ensuring a consistent set of data with which to work. This seeder data can be found in `initdb-configmap.yaml`.

### Deploying services

When deploying services manually through `kubectl apply`, be aware that our yaml files make use of string templates (e.g. *\<a-string>*) for reusability in our pipeline code. We recommend reading the Jenkinsfile for any given service—if you set the environment variables outlined before the stages, then you do not have to worry about changing these values. However, these strings must be replaced before running `kubectl apply` manually.

In any given yaml file, there is a string template for the database url:

      - name: DATABASE_URL
        value: <database-url>
  
And there is a string template in the image name, which should be test-latest for the staging environment or latest for the production environment:

      - name: tax-service
        image: 924809052459.dkr.ecr.us-east-1.amazonaws.com/tax-service:<image-version>

### Dockerfiles

In the *Dockerfiles* folder, you will find that all of our images are hosted on Amazon ECR. This is to avoid image pull throttling by Docker Hub during intensive pipeline activity. In addition to the images contained therein, we are also utilizing a [custom *kaniko* container by bdgomey](https://github.com/bdgomey/jenkinsK8s) in our pipeline.

