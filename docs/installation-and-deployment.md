# Installation and Deployment

Aurelius Atlas is distributed as a Helm chart. This allows for easy installation and deployment on
any cloud provider or on-premises Kubernetes cluster.

!!! tip
    For users who want to try out Aurelius Atlas without setting up a Kubernetes cluster, a Docker Compose file
    is also provided.

!!! danger
    Do not use the Docker Compose distribution for production deployments.

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

The following are the minimal infrastructure requirements for deploying Aurelius Atlas:

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

=== "Huawei Cloud"
    For Huawei Cloud, the recommended system requirements are:

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

    - [Helm](https://helm.sh/docs/intro/install/) installed
    - [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli) installed
    - [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/) installed

=== "Google Cloud"
    Please ensure you have the following prerequisites for a deployment on Google Cloud:

    - [Helm](https://helm.sh/docs/intro/install/) installed
    - [Google Cloud SDK](https://cloud.google.com/sdk/docs/install) installed
    - [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/) installed
    - A registered domain name for the Ingress controller

=== "Huawei Cloud"
    Please ensure you have the following prerequisites for deployment on Huawei Cloud:

    - 2 Elastic IPs
    - An Elastic Load Balancer with 5 Mbit/s bandwidth, which can later be changed to traffic-based pricing.
    - A NAT Gateway with an SNAT rule [Huawei Cloud Documentation](https://support.huaweicloud.com/eu/qs-natgateway/en-us_topic_0087895790.html)
    - A registered domain name for the external IP of the Elastic Load Balancer

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
        --set controller.service.annotations."service\.beta\.kubernetes\.io/azure-load-balancer-health-probe-request-path"=/healthz \
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

=== "Huawei Cloud"
    On Huawei Cloud we use Elastic Load Balancer as an nginx ingress controller. To set it up, follow the
    [official documentation](https://support.huaweicloud.com/intl/en-us/usermanual-elb/elb_lb_000006.html).

    To validate whether the ingress service is running, run:

    ```bash
    kubectl get all -n default
    ```

    You should see two NGINX ingress controller instances with a `Running` status.

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

#### Set up DNS

If you are deploying Aurelius Atlas on a cloud provider, but want to use your own domain name, you can set up
a DNS record to point to the Load Balancer's IP address. To find the IP address of the Load Balancer, run the
following command:

```bash
kubectl get service -n ingress-nginx
```

The output will show the external IP address of the Load Balancer.

!!! tip
    Give this IP address to your network administrator and ask them to create a DNS record for your domain.

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

| Key                                          | Description                               |
| -------------------------------------------- | ----------------------------------------- |
| `{{ .Values.global.external_hostname }}`     | Set this to your DNS name.                |
| `{{ .Values.keycloak.keycloakFrontendURL }}` | Set this to your DNS name.                |
| `{{ .Values.post_install.upload_data }}`     | Set this to `true` to upload sample data. |

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

By default, the following users are created:

| User Type                                 | Username    | Default Password (docker-compose) |
| ----------------------------------------- | ----------- | --------------------------------- |
| Aurelius Atlas Admin                      | `atlas`     | `atlas`                           |
| Elasticsearch Admin                       | `elastic`   | `elasticpw`                       |
| Keycloak Admin                            | `admin`     | `admin`                           |
| Aurelius Atlas Data Steward (demo only)   | `steward`   | -                                 |
| Aurelius Atlas Data Scientist (demo only) | `scientist` | -                                 |

For production deployments, the passwords for each user are randomized and stored in a Kubernetes secret. The
helm chart includes a script to retrieve the passwords for each user. To retrieve the passwords, run the following
command:

```bash
./get_passwords.sh <namespace>
```

This script will print the passwords for each user to the console.

## Identity & Access Management

### Integrating Azure Active Directory with Keycloak

Active Directory login is not enabled by default. To enable it in Aurelius Atlas, follow these steps:

- Register an application in Azure Active Directory. For more details, follow this guide: [Azure AD integration](https://medium.com/@andremoriya/keycloak-azure-active-directory-integration-14002c699566).

- Update the `values.yaml` file

    Update the `values.yaml` file in the base folder to load a different Keycloak configuration.
    Set the `{{ .Values.keycloak.realm_file_name }}` key to `realm_m4i_with_provider.json`.

- Customize the realm configuration

    Update the realm configuration file (`charts/keycloak/realms/realm_m4i_with_provider.json`) by entering
    your credentials:

| Key                                            | Description                                |
| ---------------------------------------------- | ------------------------------------------ |
| `{{ .identityProviders.config.clientId }}`     | The client ID of the identity provider.    |
| `{{ .identityProviders.config.clientSecret }}` | The client secret of the identity provider |

!!! note
    In addition to Azure Active Directory, social login is also supported through OAuth 2.0 clients, including
    [Google](https://keycloakthemes.com/blog/how-to-setup-sign-in-with-google-using-keycloak),
    [GitHub](https://medium.com/keycloak/github-as-identity-provider-in-keyclaok-dca95a9d80ca) or
    [Facebook](https://medium.com/@didelotkev/facebook-as-identity-provider-in-keycloak-cf298b47cb84).
    For a complete list of supported identity providers, refer to the [keycloak website](https://www.keycloak.org/).
    These applications can be configured as identity providers in Keycloak.

!!! tip
    If the deployment is already running, you can enable the identity provider directly through the Keycloak UI.

**To enable active directory login on the keycloak UI:**

- Navigate to the Keycloak administration console.
- Click "Identity providers" in the menu, then choose the desired provider from the dropdown menu.
- Set the Client ID and Client Secret. The rest of the settings can remain default.

### Managing Users

In **Aurelius Atlas**, you have the flexibility to control user access through role-based permissions.
Users can either have **read-only** access or **read/edit** permissions, depending on their role within
the system. By default, all users are assigned the **viewing** role, but administrators
can manage and modify roles as needed.

- **Viewing Role (Default):** Users with this role can **view** data but cannot make any changes.
- **Editing Role:** Users with this role have permission to **edit** data and perform updates.

### User Access

Anybody with a company login can access Aurelius Atlas, when **active directory login** is enabled, provided
that they have the user roles assigned. (See section [User Roles and Permissions](#managing-roles-in-keycloak-ui))

For administrators who need more control over user registration, it’s also possible to manually create users
directly within the Keycloak UI. For more information please visit the
official [Keycloak documentation](https://www.keycloak.org/docs/latest/server_admin/#assembly-managing-users_server_administration_guide).

### Managing Roles in Keycloak UI

For organizations using Azure Active Directory (AAD) role assignments can be
managed centrally in AAD, making it easier to maintain consistent user and role configurations across the
organization.

Administrators can also manage user roles through the **Keycloak Admin UI**.

1. In the Keycloak Admin Console, navigate to the **Users** section.
2. Select the desired user and go to the **Role Mappings** tab.
3. Assign `DATA_STEWARD` to grant the user editing rights, or remove roles to make it a read-only user.

### User Roles and Permissions

| Role Name      | Permissions        | Notes                           |
| -------------- | ------------------ | ------------------------------- |
| ROLE_ADMIN     | Edit, View, Delete | Admin role with high privileges |
| DATA_STEWARD   | Edit, View         | Data stewardship role           |
| DATA_SCIENTIST | View               | Role for data scientists        |
