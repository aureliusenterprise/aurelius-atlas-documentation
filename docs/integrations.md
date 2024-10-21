# Integrations

This page provides public APIs that users can utilize to interact with Aurelius Atlas.

## Apache Atlas API

Apache Atlas offers a versatile REST API designed for managing metadata entities, types, lineage, and data discovery.
For detailed documentation and examples, refer to the [Apache Atlas API Documentation](https://atlas.apache.org/api/v2/index.html).

## Lineage API

This API lets you automatically register data lineage information in Aurelius Atlas. It provides endpoints for
registering data producers and consumers, as well as any data transformations that occur between them.

!!! tip
    Integrate your [DevOps](https://www.gartner.com/en/information-technology/glossary/devops) and [DataOps](https://www.gartner.com/en/information-technology/glossary/dataops)
    pipelines with Aurelius Atlas using the Lineage API

For further details and guidelines on usage, please visit the [API documentation](https://github.com/aureliusenterprise/aurelius/blob/main/backend/m4i-lineage-rest-api/README.md).

## Federated Identity with Keycloak

Keycloak is an open-source identity and access management solution that simplifies authentication and
authorization for applications. It supports federated identity, allowing users to authenticate through
external identity providers without needing separate credentials for each application. Keycloak manages this
by integrating multiple identity providers and managing the user sessions centrally.

### Key Features for Federated Identity

Keycloak provides several key features that make federated identity management easier to implement and
customize for your application:

1. Unified Authentication and Single Sign-On

    Keycloak enables Single Sign-On (SSO) and Single Sign-Out across multiple applications, allowing users to
    authenticate once and access various services seamlessly. It supports OpenID Connect, OAuth 2.0, and SAML,
    providing flexibility in integrating with different identity providers.

2. Social Login and Identity Brokering

    Users can authenticate using their existing social accounts (e.g., Google, GitHub, Facebook) through
    social login features. Additionally, Keycloak supports identity brokering, enabling authentication with
    external identity providers that utilize OpenID Connect or SAML protocols.

3. User Management and Federation

    The Admin Console allows for centralized management of users, roles, and configurations, while the
    User Federation feature enables synchronization of users from LDAP and Active Directory servers. This
    facilitates streamlined user management without duplicating accounts.

4. Enhanced Security and Customization

    Keycloak provides robust security features, including Two-Factor Authentication, customizable login flows,
    and session management for both users and administrators. Additionally, theme support allows customization
    of user-facing pages to align with your application's branding.

For more information, please visit [Keycloak Documentation](https://www.keycloak.org/documentation).
