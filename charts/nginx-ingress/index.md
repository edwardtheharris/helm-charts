---
abstract: A brief guide to using the NGINX Helm Chart for bare metal K8S.
author:
  - name: Xander Harris
    email: xandertheharris@gmail.com
date: 2025-09-07
title: NGINX Helm Configuration
---

## NGINX Chart Usage

For basic installations this is a simple process[^nginx-helm-docs].

1. Create the namespace.

   ```{code-block} shell
   :caption: create

   kubectl create ns nginx
   ```

2. Deploy the chart.

   ```{code-block} shell
   helm install nginx-ingress --namespace nginx oci://ghcr.io/nginx/charts/nginx-ingress --version 2.2.2
   ```

[^nginx-helm-docs]: All information provided here was taken from the much
    more reliable
    [actual documentation](https://docs.nginx.com/nginx-ingress-controller/installation/installing-nic/installation-with-helm/#before-you-begin).
