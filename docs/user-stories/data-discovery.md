# Streamlining Data Discovery

In a data analytics project, **data scientists** or **data engineers** often need to find specific data to answer
critical business questions. However, identifying relevant data, understanding where it is stored, and knowing
who to contact for access can be challenging, especially in organizations lacking data governance tools. This process
typically involves reaching out to multiple people, and can be time-consuming and inefficient.

## Challenges

1. Lack of visibility into available data.
2. Uncertainty about data storage locations.
3. Difficulty identifying the accountable individuals for data access.
4. Time-consuming processes to understand data attributes and their meanings.
5. Inefficiency for engineers, particularly those with smaller networks within the organization.

## Benefits and Features

Aurelius Atlas provides a centralized solution that makes information about data availability, storage locations,
and accountable contacts easily accessible. The tool facilitates quicker and more efficient data discovery and
access, reducing the time and effort required to find and understand relevant data.

### Business Context

Users can search for data by entering relevant terms related to their business context. The platform shows which
data sets are available that match the search criteria. Comprehensive explanations of individual atomic attributes
help users understand the meaning and relevance of the data.

### Storage Locations

Information about where the data is stored is readily accessible.

### Accountability

Users can see who is responsible for the data, making it easier to request access.

## Walkthrough

Let's consider a scenario where a data scientist needs to calculate the number of people who currently work for
their company as part of the annual report.

!!! tip
    You can follow along with the scenario on the Aurelius Atlas demo environment.

    <a class="btn btn-success" href="https://aureliusdev.westeurope.cloudapp.azure.com/demo/atlas/">Go to the demo</a>

Watch the video walkthrough below or read the step-by-step instructions.

<iframe
    width="560"
    height="315"
    src="https://www.youtube-nocookie.com/embed/gt-NzPn5KCU?si=ASCaTPWaTLI8-8MO"
    title="YouTube video player"
    frameborder="0"
    allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"
    referrerpolicy="strict-origin-when-cross-origin"
    allowfullscreen
>
</iframe>

### Searching for Data

Let's start on the Aurelius Atlas landing page. Here, the data scientist can enter search terms like "employee",
"staff", or "workforce". See the screenshot below.

[![Data Discovery](../img/screenshots/data-discovery/business-context.jpg)](../img/screenshots/data-discovery/business-context.jpg)

Here's an explanation of the highlighted elements:

1. **Business Context**: The landing page has a dedicated section to help you get started exploring the business
    context of the data. You can enter search terms related to your business question to find relevant data sets.
2. **Info Panel**: Click the question mark icon for an explanation of the business context meta model.
3. **Search Bar**: Queries made through this search bar will have business context filters pre-applied.
