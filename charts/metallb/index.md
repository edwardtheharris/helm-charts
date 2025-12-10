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

You can find the main website at [metallb.io](https://metallb.io/).

```{toctree}
README
```

---

## MetalLB deployment

1. Create `networking`{l=yaml} namespace[^metallb-install].

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

   You can see this example and more,
   [in the metallb helm repostory](https://github.com/metallb/metallb/blob/v0.15.2/configsamples/ipaddresspool_simple.yaml).

5. Apply a simple `IPAddressPool`{l=yaml}.

   ```{code-block} shell
   kubectl apply --namespace metallb-system -f IPAddressPool.yaml
   ```

6. Define an `L2Advertisement`{l=yaml}.

   ```{code-block} yaml
   :caption: L2Advertisement.yaml

   apiVersion: metallb.io/v1beta1
   kind: L2Advertisement
   metadata:
     name: example
     namespace: metallb-system
   ```

7. Apply the `L2Advertisement`{l=yaml}

   ```{code-block} shell
   kubectl --namespace metallb-system -f L2Advertisement.yaml
   ```

   More information is available from the
   [metallb documentation](https://metallb.universe.tf/configuration/#layer-2-configuration).

### MetalLB SubCharts

```{toctree}
charts/crds/README
charts/frr-k8s/README
charts/frr-k8s/charts/crds/README
README
```

[^metallb-install]: You can find the official install guide on the
    [metallb webiste](https://metallb.io/installation/).
