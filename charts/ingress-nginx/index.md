---
abstract: A brief guide to using the Ingress NGINX Helm Chart for bare metal K8S.
author:
  - name: Xander Harris
    email: xandertheharris@gmail.com
date: 2025-09-07
title: Ingress NGINX Helm Configuration
---

## Ingress NGINX Chart Usage

For basic installations this is a simple process[^flannel-helm-docs].

1. Create the namespace.

   ```{code-block} shell
   :caption: create

   kubectl create ns networking
   ```

2. Label the namespace.

   ```{code-block} shell
   kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.13.2/deploy/static/provider/baremetal/deploy.yaml
   ```

3. Consider the 
   [bare metal considerations](https://kubernetes.github.io/ingress-nginx/deploy/baremetal/).

[^ingress-nginx-docs]: All information provided here was taken from the much
    more reliable
    [actual documentation](https://kubernetes.github.io/ingress-nginx/deploy/#bare-metal-clusters).

