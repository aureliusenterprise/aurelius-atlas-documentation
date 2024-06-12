# Installation and Deployment

Aurelius Atlas is distributed as a Helm chart. This allows for easy installation and deployment on
any cloud provider or on-premises Kubernetes cluster.

!!! tip
    For users who want to try out Aurelius Atlas without setting up a Kubernetes cluster, a Docker Compose file
    is also provided.

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

    - A Kubernetes cluster
    - [Helm](https://helm.sh/docs/intro/install/) installed
    - [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/) installed

=== "Azure"
    Please ensure you have the following prerequisites for a deployment on Azure:

    - An Azure account
    - [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli) installed
    - [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/) installed

=== "Google Cloud"
    Please ensure you have the following prerequisites for a deployment on Google Cloud:

    - A Google Cloud account
    - [Google Cloud SDK](https://cloud.google.com/sdk/docs/install) installed
    - [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/) installed
    - A registered domain name for the Ingress controller

=== "Docker Compose"
    Please ensure you have the following prerequisites for a local deployment:

    - [Docker](https://docs.docker.com/get-docker/) installed
