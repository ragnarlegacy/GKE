# This project demonstrates the ability to manage GCP resources using Terraform and Helm

## Prerequisites
- [Google Cloud SDK](https://cloud.google.com/sdk/docs/install)
- [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)
- [Helm](https://helm.sh/docs/intro/install/)
- [Docker](https://docs.docker.com/get-docker/)
- A GCP account with billing enabled
- Kubectl
- gke-gcloud-auth-plugin
  

## Setup Instructions

### 1. Configure GCP Project
1. Create a new GCP project.
2. Enable the Kubernetes Engine API and Compute Engine API.
3. Authenticate using the Google Cloud SDK:
```sh
gcloud auth application-default login

OR

gcloud auth login
gcloud config set project <your-gcp-project-id>
```

### 2. Create Google Cloud Storage and Service account to configure remote backend
Either, you can login to GCP console and create manually or follow the below given instructions.

1. Clone the repository:
```sh
git clone https://github.com/ragnarlegacy/GKE.git
cd GKE/Backend
```
2. Initialize Terraform:
```sh
terraform init
```
3. Plan the Terraform Configuration
```sh
terraform plan --auto-approve
```

4. Apply the Terraform configuration:
```sh
terraform apply --auto-approve
```

### 3. Deploy GKE Cluster using Terraform
1. Moved back to directory GKE
```sh
cd ../GKE
terraform init
terraform plan --auto-approve
terraform apply --auto-approve
```
2. Interact with the GKE Cluster:
   
After the cluster is created, you can connect to it using kubectl:
```sh
gcloud container clusters get-credentials YOUR_GKE_CLUSTER --region us-central1 --project YOUR_PROJECT_ID

kubectl cluster-info
kubectl get nodes
```
### 4. Set Up Helm
1. Install Helm if not already installed:
```sh
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
```
```sh
Through Package Managers from Homebrew (macOS)

brew install helm
```
2. Initialize Helm and add any necessary repositories:
```sh
helm repo add stable https://charts.helm.sh/stable
helm repo update
```
### 4. Create a Sample Node.js API Docker Image
First, create a simple Node.js API service and containerize it using Docker. Skip this step if you already have a containerized API.
Change Directory:
```sh
cd app
```
1. Create the API:
- index.js:
  ```sh
  const express = require('express');
  const app = express();
  const port= 3000;

  app.get('/', (req, res) => res.send('Hello, GKE!'));

  app.listen(port, () => {
      console.log(`Example app listening at http://localhost:${port}`);
  });
  ```

2. Create a Dockerfile for the API service:
- Dockerfile:
```
FROM --platform=linux/amd64 node:14

# Create app directory
WORKDIR /usr/src/app

# Install app dependencies
COPY package*.json ./

RUN npm install \
    npm install express --save

# Bundle app source
COPY . .

EXPOSE 3000
CMD [ "node", "index.js" ]
```
3. Build the Docker image:
```sh
docker build -t apiservice:latest -f Dockerfile .
```
4. Image push to GCR
Create a repository to store docker images at GCP console.

### Go to GCP console > Go to search bar > Search for container registry > Create one 

```sh
At local machine terminal, execute below command to authenticate and configure created registry in the specified location.

gcloud auth configure-docker us-central1-docker.pkg.dev

Tag the image:
docker tag apiservice:latest us-central1-docker.pkg.dev/gcp_pro/repository/nodeapp
docker push us-central1-docker.pkg.dev/gcp_pro/repository/nodeapp
```

### 5. Deploy API Service using Helm
1. Create a Helm chart for the API service:
```sh
cd helm-app
```
2. Deploy the application to the GKE cluster:
```sh
helm install node-app ./helm-app
```

### 6. Verify Deployment
1. Get the external IP of the service:
```sh
kubectl get services
```
2. Script interactions with the API service to validate its
functionality:
```sh
curl <http://<external-ip>>:3000
```

## Cleanup
To destroy the resources created by Terraform:
```sh
terraform destroy
```

### 6. Monitoring on your GKE cluster with Promoetheus and Grafana
#### Set Up Prometheus on GKE

1. Install Prometheus using Helm:
```sh
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

helm install prometheus prometheus-community/prometheus \
  --namespace monitoring \
  --create-namespace
```
This will install Prometheus in the monitoring namespace.

2. Verify Prometheus Installation:
```sh
kubectl get pods -n monitoring
```

3. Access Prometheus Dashboard:
You can port-forward the Prometheus server to access it locally:
```sh
kubectl port-forward -n monitoring deploy/prometheus-server 9090
```
Then, access it via your browser at http://localhost:9090.

#### Set Up Grafana for Visualization on GKE

1. Install Grafana using Helm:
```sh
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update
helm install my-grafana grafana/grafana --namespace monitoring
```
2. Verify Prometheus Installation:
```sh
kubectl get pods -n monitoring
```
3. Get Grafana Admin Password:
```sh
kubectl get secret --namespace monitoring my-grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
```
4. Access Grafana Dashboard:
```sh
export POD_NAME=$(kubectl get pods --namespace monitoring -l "app.kubernetes.io/name=grafana,app.kubernetes.io/instance=my-grafana" -o jsonpath="{.items[0].metadata.name}")
kubectl --namespace monitoring port-forward $POD_NAME 3000
```
Then, access it via your browser at http://localhost:3000.

### 7. Connect Prometheus to Grafana:
#### Add Prometheus as a Data Source in Grafana:
```sh
Go to Settings (gear icon) in the left sidebar.
Click on Data Sources.
Click Add data source and choose Prometheus.
In the URL field, enter http://prometheus-server.monitoring.svc.cluster.local:80.
Click Save & Test to verify the connection.
```
#### Import Pre-built Dashboards:

Grafana has a library of pre-built dashboards for Kubernetes and Prometheus. 
```sh
To import:

Go to the Dashboards section and click Import.
Enter the dashboard ID, for example, 315 for the Kubernetes cluster monitoring dashboard.
Click Load, select Prometheus as the data source, and click Import.
```
#### Visualize Your Cluster:

Now you can see various metrics related to your GKE cluster, such as node resource usage, pod status, and more.
