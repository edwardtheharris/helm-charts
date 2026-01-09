---
abstract: >-
  Information that should be helpful deploying
  cert-manager CRDs.
date: 2026-01-09
title: Cert Manager CRDs
---

To deal with the end of support for Ingress NGINX,
we need to use
[Annotated Gateway resources](https://cert-manager.io/docs/usage/gateway/)
instead of
[Annotated Ingress resources](https://cert-manager.io/docs/usage/ingress/).
This requires a few additional steps when installing
cert-manager.

1. Install the API Gateway Bundle.[^source]

   ```{code-block} shell
   kubectl apply -f crds/standard-install.yaml
   ```

2. Add the following configuration to your values.

   ```{code-block} yaml
   config:
     apiVersion: controller.config.cert-manager.io/v1alpha1
     kind: ControllerConfiguration
     enableGatewayAPI: true
   ```

3. Restart the cert-manager deployment.

   ```{code-block} shell
   kubectl rollout restart deployment cert-manager -n cert-manager
   ```

4. Annotate your Gateway resource in the usual way.

   ```{code-block} yaml
   annotations:
     cert-manager.io/cluster-issuer: your-cluster-issuer
   ```

[^source]:
  The original source is available
  [on GitHub](https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.0.0/standard-install.yaml)
