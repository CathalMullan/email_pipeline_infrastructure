# Email Pipeline Infrastructure
Follow the guides in `docs/` to create the infrastructure needed to manage the distributed email pipeline.

# Components

## Kafka & Zookeeper
Stateful storage of events from web crawlers.

## Crawlers & Generators
Scrape the MARC mail archive for emails, publishing then into a Kafka queue.

## Spark Streaming
Read from Kafka email queue, process files into a Parquet structure stored in a GCP bucket.

## Spark TensorFlow
Read from GCP Parquet bucket, perform training on files. Saved models in individual GCP buckets.

## Frontend
PWA Email client deployed as a service. pulling saved models from GCP buckets.
