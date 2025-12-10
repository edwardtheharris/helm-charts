---
date: 2025-12-10
title: Envoy Installation
---

```{note}
This is adapted from
[the original Envoy Helm installation guide](gateway.envoyproxy.io/latest/install/install-helm/),
which should be considered the authority on how this works.
```

1. Install the chart from OCI.

   ```{code-block} shell
   kubie ctx
   kubie ns networking
   helm install envoy-gateway oci://docker.io/envoyproxy/gateway-helm --version v0.0.0-latest
   ```

2. Wait for the Gateway to become available.

   ```{code-block} shell
   kubectl wait --timeout=5m -n networking deployment/envoy-gateway --for=condition=Available
   ```

3. Install the CRDs and example application.

   ```{code-block} shell
   kubectl apply -f https://github.com/envoyproxy/gateway/releases/download/latest/quickstart.yaml
   ```
