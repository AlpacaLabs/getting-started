## Intro
This org is a reference project I'm iterating to document some practices and patterns I've observed over the years.

It's definitely a work in progress.

The main "business" function in the project is authentication and authorization.

It's highly decomposed (check out the JPG files) in this repo or download [DrawIO](https://github.com/jgraph/drawio-desktop)
and check out the diagrams there.

I'm definitely not saying you should design your auth system like this, or that you should even roll your own, since
there are "auth as a service" platforms now, such as Auth0.

To reiterate, the purposes of this project are personal:
* to document and iterate on industry best-practices, e.g., transactional outbox pattern, message brokers, etc.
* to explore new tools for testing a "microservices" architecture, e.g., [Garden](https://garden.io/).
* explore the pain points of extremely decomposed, distributed systems.

## Running
You'll need the following:
* Docker (e.g., [for Mac](https://docs.docker.com/docker-for-mac/))
* a local Kubernetes cluster (I'm using the one that came w/ Docker for Mac).
* [Garden](https://garden.io/)

The first repo you'll want to clone is [AlpacaLabs/garden](https://github.com/AlpacaLabs/garden),
which contains a Makefile for cloning all other repos.

## Architecture
One logical application with multiple business functions has been split into several microservices.
Each microservice has its own database. Some services "depend" on others, for which they use
some form of synchronous communication (e.g., gRPC) or a message broker (e.g., Kafka) where durability is needed.

The models of each service are documented in [protorepo](https://github.com/AlpacaLabs/protorepo),
which allows for centralized viewing and documentation.

Diagrams for the entire system exist in [DrawIO](https://github.com/jgraph/drawio-desktop) format 
[here](https://github.com/AlpacaLabs/getting-started/blob/master/architecture.drawio).

We use the [Transactional outbox](https://microservices.io/patterns/data/transactional-outbox.html)
pattern to ensure database updates and message pub/sub occurs reliably/atomically.

A "message relay" process exists to read records from the transactional outbox and write them to the appropriate topic.

Because each pod might run a message relay process, messages should be expected to be sent more than once, and as such, consumers should be idempotent.
