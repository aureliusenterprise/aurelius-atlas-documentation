# Support and Maintenance

This page provides essential information for contacting Aurelius Enterprise
support, accessing our community, and troubleshooting common issues.

## Contact Us

We are here to help you with any questions, issues, or feedback you may have about Aurelius Enterprise.
Reach out to us through any of the following channels, and our team will respond as promptly as possible.

### Email

For general inquiries, technical support, or any other questions, feel free to email us:

- 📧 [info@aureliusenterprise.com](mailto:info@aureliusenterprise.com)

Our support team monitors this inbox regularly and will get back to you within 24-48 hours.

### Website

Visit our official website for more information about our products, services, and the latest updates:

- 🔗 [Aurelius Enterprise Website](https://aureliusenterprise.com/)

Our website features detailed documentation, tutorials, and resources to help you make the most out of our offerings.

### User Communities

Join our user communities to connect with other Aurelius Enterprise users,
share your experiences, and stay updated on the latest news and developments.

| Community | Link                                                                                                                                                                                             | Description                                                             |
| --------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ----------------------------------------------------------------------- |
| GitHub    | ![GitHub Logo](https://github.githubassets.com/favicon.ico) [Aurelius Enterprise on GitHub](https://github.com/aureliusenterprise)                                                               | Contribute to projects, report issues, and collaborate with developers. |
| LinkedIn  | ![LinkedIn Logo](https://static.licdn.com/scds/common/u/images/logos/favicons/v1/favicon.ico) [Aurelius Enterprise on LinkedIn](https://www.linkedin.com/company/aurelius-enterprise/mycompany/) | Follow for company news, updates, and professional insights.            |

Engage with us and other professionals in the field to expand your network and stay ahead in the industry.

We look forward to hearing from you and assisting you with your needs!

## Troubleshooting Deployment

This section provides detailed steps to address common deployment issues.

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
