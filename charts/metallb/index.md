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

4. Define a simple `IPAddressPool`{l=yaml}.

   ```{code-block} yaml
   :caption: IPAddressPool.yaml

   apiVersion: metallb.io/v1beta1
   kind: IPAddressPool
   metadata:
     name: example
     namespace: metallb-system
   spec:
     addresses:
     - 192.168.10.0/24
     - 192.168.9.1-192.168.9.5
     - fc00:f853:0ccd:e799::/124
   ```

5. Apply a simple `IPAddressPool`{l=yaml}

   ```{code-block} shell
   kubectl apply --namespace metallb-system -f IPAddressPool.yaml
   ```
