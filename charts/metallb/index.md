---
abstract: Documentation index for MetalLB L2 deployment.
authors:
  - name: Xander Harris
    email: xandertheharris@gmail.com
  - name: MetalLB Project
    email: metallb-users@gmail.com
date: 2025-09-16
title: Index for MetalLB L2 deployment to bare metal.
---


## MetalLB Readme

```{toctree}
README
```

---

## MetalLB deployment

1. Create `networking`{l=yaml} namespace.

   ```{code-block} shell
   kubectl create ns networking
   ```

2. Update the values file for your environment.

3. Deploy the L2 version to your cluster.

   ```{code-block} shell
   helm install --namespace networking metallb . -f values.yaml
   ```
