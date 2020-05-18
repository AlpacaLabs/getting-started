Install Docker (e.g., [for Mac](https://docs.docker.com/docker-for-mac/))

Install a local Kubernetes cluster

Install [Garden](https://garden.io/)

If not all dependencies are public, configure Go to know about these.
You'll also need to set up your GitHub account with an SSH key.
```
# clone w/ ssh instead of https
git config --global url.git@github.com:.insteadOf https://github.com/

# configure Go to automatically pull private repos from the org
go env -w GOPRIVATE=github.com/AlpacaLabs/*
```

What is important here is not the set of particular technologies that are being used,
but the patterns and architecture.

We've split up a logical application with multiple business functions into several microservices.
Each microservice has its own database, but some services depend on others.
For this, they use synchronous communication (e.g., gRPC) and a message broker (e.g., Kafka) where needed.
The models of each service are documented in [protorepo](https://github.com/AlpacaLabs/protorepo),
which allows for centralized viewing and documentation.
Diagrams for the entire system exist in [DrawIO](https://github.com/jgraph/drawio-desktop) format 
[here](https://github.com/AlpacaLabs/protorepo/blob/master/architecture.drawio).

We use the [Transactional outbox](https://microservices.io/patterns/data/transactional-outbox.html)
pattern to ensure database updates and message pub/sub occurs reliably/atomically.

A "message relay" process exists to read records from the transactional outbox and write them to the appropriate topic.

Because each pod might run a message relay process, messages should be expected to be sent more than once, and as such, consumers should be idempotent.
