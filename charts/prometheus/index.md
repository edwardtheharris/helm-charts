---
abstract: >-
   Documentation for the Prometheus Helm Chart values.
authors:
   - name: Xander Harris
     email: xandertheharris@gmail.com
date: 2024-07-30
title: Prometheus Helm Chart Values
---

This folder contains a values file to deploy the Prometheus Community Helm
Chart along with a JSON schema file generated from that values file.

```{admonition} This is a copy
Any documentation here was originally sourced from the Prometheus Community
Helm Chart's
[ArtifactHub](https://artifacthub.io/packages/helm/prometheus-community/prometheus).
In the event of conflicts between this information and the source repository,
the source repository should be considered the truth.
```

## Schema Generation

If you need to update the JSON schema, follow these steps.

1. Make sure the Helm `schema-gen` plugin is installed.

   ```{code-block} shell
   helm plugin install https://github.com/karuppiah7890/helm-schema-gen
   ```

2. Use the plugin to generate the new schema.

   ```{code-block} shell
   helm schema-gen values.yaml
   ```

## Usage

1. Add the repository to Helm.

   ```{code-block} shell
   helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
   helm repo update
   ```

2. Edit the `values.yaml` as you need.
3. Deploy the chart.

   ```{code-block} shell
   kubectl create ns prometheus
   helm -n prometheus upgrade --install prometheus-community/prometheus -f values.yaml
   ```

### Values

```{autoyaml} charts/prometheus/values.yaml
```
