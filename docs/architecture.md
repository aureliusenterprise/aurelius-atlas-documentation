# Architecture

This page describes the architecture of Aurelius Atlas.

## Components

The system consists of the following main components:

```mermaid
graph LR
    subgraph Aurelius Atlas
        subgraph Kubernetes
            subgraph Web
                WebApp["Web App"]
            end
            subgraph Backend
                ApacheAtlas["Apache Atlas"]
                Keycloak["Keycloak"]
                ApacheKafka["Apache Kafka"]
                ApacheFlink["Apache Flink"]
                Elasticsearch["Elasticsearch"]
            end
        end
    end

    ApacheAtlas --> Keycloak
    ApacheAtlas --> ApacheKafka
    ApacheKafka --> ApacheFlink
    ApacheFlink --> Elasticsearch
    WebApp --> Keycloak
    WebApp --> ApacheAtlas
    WebApp --> Elasticsearch
```

!!! note
    The diagram shows the components of Aurelius Atlas required to realize the primary data flow. Other components,
    such as backend services serving the Web App and microservices running on Apache Flink, are not shown for simplicity.

### Web App

The Web App is the main user interface for Aurelius Atlas. It is a single-page application (SPA) built with Angular.
The Web App is responsible for displaying the data stored in Apache Atlas and Elasticsearch. It communicates with
the backend services using REST APIs. Authentication is handled by Apache Keycloak.

### Apache Atlas

Apache Atlas is a metadata management and governance platform. It provides a scalable and extensible set of core
metadata services for data governance. Apache Atlas is used to store metadata about data assets, such as definitions,
relationships, and classifications.

### Keycloak

Keycloak is an open-source identity and access management solution. It acts as the main identity provider
for Aurelius Atlas, handling user authentication and authorization. All interactions with the Web App and backend
services are authenticated and authorized by Keycloak.

### Apache Kafka

Apache Kafka is a distributed event streaming platform. It is used as the messaging backbone for back-end data
processing and integration. Apache Atlas publishes metadata change events to Apache Kafka, which are consumed by
Apache Flink for real-time processing.

### Apache Flink

Apache Flink is a distributed stream processing framework. It is used to process metadata change events from Apache
Atlas in real-time. Apache Flink enriches the metadata events and stores them in Elasticsearch to enable advanced
user queries in the Web App.

### Elasticsearch

Elasticsearch is a distributed search and analytics engine. It is used to store the enriched metadata from Apache
Flink. Elasticsearch provides fast and scalable full-text search capabilities for the Web App.

## Security

All communication between the public-facing components of Aurelius Atlas is secured with TLS. Authentication and
authorization are enforced using Keycloak.

!!! tip
    You have the option to integrate keycloak with your existing identity and access management system. See the
    [Keycloak documentation](https://www.keycloak.org/docs/latest/server_admin/#_identity_broker) for more details.
