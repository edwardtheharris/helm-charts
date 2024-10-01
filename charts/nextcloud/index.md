---
abstract: >-
   Documentation for the NextCloud Helm Chart values.
authors:
   - name: Xander Harris
     email: xandertheharris@gmail.com
date: 2024-07-30
title: NextCloud Helm Chart Values
---

This folder contains a values file to deploy the NextCloud Community Helm
Chart along with a JSON schema file generated from that values file.

```{admonition} This is a copy
Any documentation here was originally sourced from the NextCloud Community
Helm Chart's
[GitHub](https://github.com/nextcloud/helm/tree/main/charts/nextcloud).
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
   helm schema-gen values.yaml > values.schema.json
   ```

## Usage

1. Add the repository to Helm.

   ```{code-block} shell
   helm repo add nextcloud https://nextcloud.github.io/helm/
   helm repo update
   ```

2. Edit the `values.yaml` as you need.
3. Deploy the chart.

   ```{code-block} shell
   kubectl create ns NextCloud
   helm -n NextCloud upgrade --install NextCloud NextCloud-community/NextCloud -f values.yaml
   ```

### Values

```{autoyaml} charts/nextcloud/values.yaml
```
