---
abstract: Index for the Envoy Gateway CRDs Helm chart docs.
date: 2026-01-09
title: gateway crds helm
---

Because of a limitation of the size of annotations in Helm, this
chart must be installed on the server side.

```{code-block} shell
helm template envoy-gateway-crds . | kubectl apply --server-side --force-conflicts -f -
```

```{toctree}
readme
```
