---
abstract: A brief guide to using the Flannel Helm Chart for bare metal K8S.
author:
  - name: Xander Harris
    email: xandertheharris@gmail.com
date: 2025-09-07
title: Flannel Helm Configuration
---

## Flannel Chart Usage

For basic installations this is a simple process[^flannel-helm-docs].

1. Create the namespace.

   ```{code-block} shell
   :caption: create

   kubectl create ns kube-flannel
   ```

2. Label the namespace.

   ```{code-block} shell
   kubectl label --overwrite ns kube-flannel pod-security.kubernetes.io/enforce=privileged
   ```

3. Update your local repositories.

   ```{code-block} shell
   helm repo add flannel https://flannel-io.github.io/flannel/
   ```

4. Deploy the chart.

   ```{code-block} shell
   helm install flannel -f values.yaml --namespace kube-flannel flannel/flannel
   ```

[^flannel-helm-docs]: All information provided here was taken from the much
    more reliable
    [actual documentation](https://github.com/flannel-io/flannel?tab=readme-ov-file#deploying-flannel-with-helm).
