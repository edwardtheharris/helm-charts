---
abstract: >-
   Documentation for the Cert Manager Helm Chart values.
authors:
   - name: Xander Harris
     email: xandertheharris@gmail.com
date: 2024-07-30
title: Cert Manager Helm Chart Values
---

This folder contains a values file to deploy the Cert Manager Helm
Chart along with a JSON schema file generated from that values file.

```{admonition} This is a copy
Any documentation here was originally sourced from the Cert Manager's
Helm Chart
[documentation](https://cert-manager.io/docs/installation/helm/).
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
   helm repo add jetstack https://charts.jetstack.io --force-update
   helm repo update
   ```

2. Edit the `values.yaml` as you need.
3. Create the namesapce.

   ```{code-block} shell
   kubectl create ns cert-manager
   ```

4. Deploy the chart.

   ```{code-block} shell
   helm install \
    cert-manager jetstack/cert-manager \
    --namespace cert-manager \
    --create-namespace \
    --version v1.15.3 \
    -f values.yaml
   ```

If the deployment succeeds, you'll see something like this in your output.

```{code-block} shell
NAME: cert-manager
LAST DEPLOYED: Mon Sep 30 17:08:34 2024
NAMESPACE: cert-manager
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
cert-manager v1.15.3 has been deployed successfully!

In order to begin issuing certificates, you will need to set up a ClusterIssuer
or Issuer resource (for example, by creating a 'letsencrypt-staging' issuer).

More information on the different types of issuers and how to configure them
can be found in our documentation:

https://cert-manager.io/docs/configuration/

For information on how to configure cert-manager to automatically provision
Certificates for Ingress resources, take a look at the `ingress-shim`
documentation:

https://cert-manager.io/docs/usage/ingress/
```

### Bootstrap a PKI

We'll be self-signing things since this is intended to run locally. Information
on how that works is available
[here](https://cert-manager.io/docs/configuration/selfsigned/).

1. Bootstrap an in-cluster issuer.

   ```{code-block} shell
   kubectl -n cert-manager apply -f manifests/BootstrapCA.yaml
   ```

2. Issue a root CA cert.

   ```{code-block} shell
   kubectl -n cert-manager apply -f manifests/IssueCACert.yaml
   ```

   This is described [here](https://cert-manager.io/docs/configuration/ca/).

3. Start securing resources.

   This process is described
   [here](https://cert-manager.io/docs/usage/ingress/).

### Values

```{autoyaml} charts/cert-manager/values.yaml
```
