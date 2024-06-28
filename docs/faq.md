# Frequently Asked Questions (FAQ)

This section provides answers to common questions about Aurelius Atlas.

## How to use the demo?

To access the online demo environment, click the button below:

<a class="btn btn-success" href="https://aureliusdev.westeurope.cloudapp.azure.com/demo/atlas/">Go to the demo</a>

!!! note
    A Google account is required to access the demo.

Log in with your Google account to start exploring Aurelius Atlas. You can follow along with the [user guide](./user-stories.md#data-discovery)
to learn how to use the platform.

## What does open source mean?

Open source refers to a software licensing model that allows users to freely use the software, as well as view
and modify its source code. Aurelius Atlas is open source and therefore free to use. You can find the source code
on our [GitHub repository](https://github.com/aureliusenterprise/aurelius)

## What license are you using?

Aurelius Atlas is published under the [Elastic License 2.0](https://www.elastic.co/licensing/elastic-license).

## How can I load my data into Aurelius Atlas?

You can find a detailed tutorial on how to load your data into Aurelius Atlas in the
[building the data governance model](./user-stories.md#building-the-data-governance-model) user story.

## Troubleshooting Deployment

This section provides detailed steps to address common deployment issues. You can find the deployment guide in
the [installation and deployment](./installation-and-deployment.md) section.

### Connection is not safe

After many deployment attempts, it can happen that the reflector pod is not restarted automatically.

1. Check if there is a secret called `letsencrypt-secret-aureliusdev` in our namespace:

    ```bash
    kubectl -n <namespace> get secrets
    ```

2. If it is not there, then find the reflector pod in the default namespace:

    ```bash
    kubectl get all
    ```

3. Delete reflector pod (A new one will be created automatically):

    ```bash
    kubectl -n <namespace> delete pod/<podname>
    ```

### Pods Stuck in Initialization Phase

If some pods are stuck in the initialization phase, the source can be resource limitations on the cloud provider.

1. Check the status of all pods:

    ```bash
    kubectl -n <namespace> get pods
    ```

2. Identify the pods that are stuck in the initialization phase.

3. Check the events for the pods to understand the issue:

    ```bash
    kubectl -n <namespace> describe pod <podname>
    ```

4. If resource limitations are suspected, check the resource usage:

    ```bash
    kubectl top nodes
    kubectl top pods -n <namespace>
    ```

If resource limitations are causing pods to be stuck in the initialization phase,
you may need to increase the resources in your cloud provider.
Here are some steps to do this in Azure and Google Cloud:

#### Scale Up the Node Pool

1. Go to the Azure portal or Google Cloud Console.
2. Navigate to your Kubernetes service.
3. Select the node pool you want to scale.
4. Click on "Scale" and increase the number of nodes.
