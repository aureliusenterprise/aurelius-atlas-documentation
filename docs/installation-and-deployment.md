# Installation and Deployment

Aurelius Atlas is distributed as a Helm chart. This allows for easy installation and deployment on
any cloud provider or on-premises Kubernetes cluster.

!!! tip
    For users who want to try out Aurelius Atlas without setting up a Kubernetes cluster, a Docker Compose file
    is also provided.

    **Do not use the Docker Compose distribution for production deployments.**

All distributions of Aurelius Atlas are available on GitHub:

<div class="wy-btn-group">
    <a class="btn btn-success" href="https://github.com/aureliusenterprise/Aurelius-Atlas-helm-chart">
        Get the Helm chart
    </a>
    <a class="btn btn-info" href="https://github.com/aureliusenterprise/Aurelius-Atlas-docker-compose">
        Get the Docker Compose
    </a>
</div>

## Infrastructure Requirements

The following are the infrastructure requirements for deploying Aurelius Atlas:

=== "Kubernetes Cluster"
    For an on-premises Kubernetes cluster, the system requirements are:

    | Resource   | Specification |
    | ---------- | ------------- |
    | Node Count | 2             |
    | CPU Cores  | 4             |
    | RAM        | 16 GB         |
    | Disk Space | 100 GB        |

=== "Azure"
    For Azure, the recommended system requirements are:

    | Resource   | Specification |
    | ---------- | ------------- |
    | Node Count | 2             |
    | CPU Cores  | 4             |
    | RAM        | 16 GB         |
    | Disk Space | 100 GB        |

=== "Google Cloud"
    For Google Cloud, the recommended system requirements are:

    | Resource   | Specification |
    | ---------- | ------------- |
    | Node Count | 2             |
    | CPU Cores  | 4             |
    | RAM        | 16 GB         |
    | Disk Space | 100 GB        |

=== "Docker Compose"
    For a local deployment, the recommended system requirements are:

    | Resource   | Specification |
    | ---------- | ------------- |
    | CPU Cores  | 4             |
    | RAM        | 32 GB         |
    | Disk Space | 100 GB        |

## Prerequisites

Before you begin the installation process, ensure that you have the following prerequisites:

=== "Kubernetes Cluster"
    Please ensure you have the following prerequisites for a deployment on a Kubernetes cluster:

    - [Helm](https://helm.sh/docs/intro/install/) installed
    - [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/) installed

=== "Azure"
    Please ensure you have the following prerequisites for a deployment on Azure:

    - [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli) installed
    - [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/) installed

=== "Google Cloud"
    Please ensure you have the following prerequisites for a deployment on Google Cloud:

    - [Google Cloud SDK](https://cloud.google.com/sdk/docs/install) installed
    - [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/) installed
    - A registered domain name for the Ingress controller

=== "Docker Compose"
    Please ensure you have the following prerequisites for a local deployment:

    - [Docker](https://docs.docker.com/get-docker/) installed

## First Time Installation

Once you have your cluster and prerequisites set up, you can install Aurelius Atlas using the Helm chart or Docker
Compose. The following sections will guide you through the process.

### Configuration Manager

Aurelius Atlas recommends [Reflector](https://github.com/emberstack/kubernetes-reflector) for managing the configuration
of the Kubernetes cluster. To install Reflector, run the following commands:

```bash
helm repo add emberstack https://emberstack.github.io/helm-charts
helm repo update
helm upgrade --install reflector emberstack/reflector
```

### Certificate Manager and Issuer

To secure your deployment, Aurelius Atlas requires TLS certificates for your domain. Follow the steps below to
set up the certificate manager and issuer.

#### Set Up Certificate Manager

First, you need to install a certificate manager to manage the TLS certificates for your domain.

!!! tip
    If your organization already has a certificate manager set up, you can use it and skip this step. Please
    note that you will need to provide your certificate manager's details in later steps.

Aurelius Atlas recommends using [cert-manager](https://cert-manager.io/docs/installation/kubernetes/) for
managing TLS certificates in Kubernetes.

To install cert-manager, run the following commands:

```bash
helm repo add jetstack https://charts.jetstack.io
helm repo update
helm install cert-manager jetstack/cert-manager \
    --namespace cert-manager \
    --create-namespace \
    --version v1.15 \
    --set installCRDs=true \
    --set global.leaderElection.namespace=cert-manager
```

On successful installation, you should see the following output:

```plaintext
NOTES:
cert-manager v1.15 has been deployed successfully
```

!!! note
    Please use a version of cert-manager that is compatible with your Kubernetes cluster. You can find the compatibility
    matrix [here](https://cert-manager.io/docs/releases/).

#### Set Up Issuer

Next, you need to set up an issuer to issue the TLS certificates for your domain.

Aurelius Atlas recommends using the `letsencrypt-prod` issuer for production deployments. The helm chart includes
a default configuration for the `letsencrypt-prod` issuer. To set up the issuer with the default configuration,
follow these steps:

1. Uncomment the content of the `templates/prod_issuer.yaml` file in the Helm chart.
2. Update `{{ .Values.ingress.email_address }}` in the `values.yaml` file with your email address.

Next, run the following command to install the issuer:

```bash
helm template -s templates/prod_issuer.yaml . | kubectl apply -f -
```

This sets up the `letsencrypt-prod` issuer with the default configuration in the `cert-manager` namespace. To
verify that the issuer is set up correctly, run the following command:

```bash
kubectl get clusterissuer -n cert-manager
```

You should see the `letsencrypt-prod` issuer in the list of cluster issuers with a status of `Ready`.

```plaintext
NAME                                       READY   AGE
letsencrypt-clusterissuer-aurelius-atlas   True    24h
```

### Ingress Controller

Next, you need to set up an ingress controller to route external traffic to your services.

!!! tip
    If your organization already has an ingress controller set up, you can use it and skip this step. Please
    note that you will need to provide your ingress controller's details in later steps.

#### Set Up Ingress Controller

Aurelius Atlas recommends using an [NGINX ingress controller](https://kubernetes.github.io/ingress-nginx/). To
install the ingress controller, follow the steps below:

=== "Kubernetes Cluster"
    To install the NGINX ingress controller on a Kubernetes cluster, run the following commands:

    ```bash
    helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
    helm repo update
    helm install nginx-ingress ingress-nginx/ingress-nginx \
        --set controller.publishService.enabled=true
    ```

=== "Azure"
    To install the NGINX ingress controller on Azure, run the following commands:

    ```bash
    helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
    helm repo update
    helm install nginx-ingress ingress-nginx/ingress-nginx \
        --set controller.publishService.enabled=true \
        --set controller.service.annotations."service\.beta\.kubernetes\.io/azure-load-balancer-health-probe-request-path"=/healthz
    --set controller.service.annotations."service\.beta\.kubernetes\.io/azure-dns-label-name"=<label>
    ```

    !!! note
        Replace `<label>` with a DNS label name for the Azure Load Balancer. This label name should be unique within
        the Azure region.

        For example, if you use the label `aurelius-atlas`, the Load Balancer's DNS name will be `aurelius-atlas.<region>.cloudapp.azure.com`.

=== "Google Cloud"
    To install the NGINX ingress controller on Google Cloud, run the following commands:

    ```bash
    helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
    helm repo update
    helm install nginx-ingress ingress-nginx/ingress-nginx \
        --set controller.publishService.enabled=true
    ```

=== "Docker Compose"
    You can skip this step when making a local deployment.

#### Set Up Certificate

Next, you need to set up a certificate for the ingress controller. To do this, follow the steps below:

1. Uncomment the content of the `templates/certificate.yaml` file in the Helm chart.
2. Update `{{ .Values.ingress.dns_url }}` in the `values.yaml` file with your DNS name.

Next, run the following command to install the certificate:

```bash
helm template -s templates/certificate.yaml . | kubectl apply -f -
```

This sets up the certificate for the ingress controller. To verify that the certificate is set up correctly, run
the following command:

```bash
kubectl get certificate -n cert-manager
```

You should see the certificate in the list of certificates with a status of `Ready`.

```plaintext
NAME                          READY   AGE
aurelius-atlas-ingress-cert   True    24h
```

### Elastic Cloud

Aurelius Atlas uses [Elastic Cloud on Kubernetes (ECK)](https://www.elastic.co/guide/en/cloud-on-k8s/current/index.html)
to manage its internal Elasticsearch cluster. To set up ECK, run the following commands:

```bash
kubectl create -f https://download.elastic.co/downloads/eck/2.13.0/crds.yaml
kubectl apply -f https://download.elastic.co/downloads/eck/2.13.0/operator.yaml
```

!!! note
    Please use a version of ECK that is compatible with your Kubernetes cluster. The ECK docs provide a list
    of supported versions [here](https://www.elastic.co/guide/en/cloud-on-k8s/current/k8s_supported_versions.html).

### Zookeeper

Aurelius Atlas internally relies on Zookeeper. Please ensure that the Zookeeper dependencies are updated by
running the following commands:

```bash
cd charts/zookeeper/
helm dependency update
```

## Deploying Aurelius Atlas

Once you have set up the prerequisites and configured the necessary components, you are ready to deploy Aurelius
Atlas.

### Configure Values

Before deploying Aurelius Atlas, you need to configure the values in the `values.yaml` file. The `values.yaml`
file contains the configuration settings for Aurelius Atlas.

The following are the key configuration settings that you need to update:

| Key                                         | Description                               |
| ------------------------------------------- | ----------------------------------------- |
| `{{ .Values.keycloak.keycloakFrontendURL}}` | Set this to your DNS name.                |
| `{{ .Values.post_install.upload_data }}`    | Set this to `true` to upload sample data. |

!!! tip
    Aurelius Atlas ships with sample data that you can us to explore the platform. To load the sample data,
    set `{{ .Values.post_install.upload_data }}` to `true`.

### Deploy Helm Chart

To deploy Aurelius Atlas using the Helm chart, run the following commands:

```bash
helm dependency update
helm install --generate-name -n <namespace> -f values.yaml --wait --timeout 15m0s .
```

!!! note
    Replace `<namespace>` with the namespace where you want to deploy Aurelius Atlas.

### Accessing Aurelius Atlas

Once the deployment is complete, you can access Aurelius Atlas using the DNS name you configured earlier. To
access the platform, open a web browser and navigate to `https://<dns-name>/<namespace>/atlas/`.

!!! note
    Replace `<dns-name>` with the DNS name you configured earlier, and `<namespace>` with the namespace where
    you deployed Aurelius Atlas.

#### Default Credentials

By default, the helm chart creates the following users:

| User type                                 | Username    |
| ----------------------------------------- | ----------- |
| Aurelius Atlas Admin                      | `atlas`     |
| Elasticsearch Admin                       | `elastic`   |
| Keycloak Admin                            | `admin`     |
| Aurelius Atlas Data Steward (demo only)   | `steward`   |
| Aurelius Atlas Data Scientist (demo only) | `scientist` |

The credentials for each user are randomized and stored in a Kubernetes secret. The helm chart includes a script
to retrieve the passwords for each user. To retrieve the passwords, run the following command:

```bash
./get_passwords.sh <namespace>
```

This script will print the passwords for each user to the console.
