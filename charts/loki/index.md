---
abstract: >-
   Values for the official Loki Helm Chart.
authors:
  - name: Xander Harris
    email: xandertheharris@gmail.com
date: 2024-09-26
title: Loki Helm Chart Values
---

## Usage

1. Create a namespace.

   ```{code-block} shell
   kubectl create ns loki
   ```

2. Update the values.
3. Deploy the service.

   ```{code-block} shell
   helm -n loki upgrade --install --force loki grafana/loki -f values.yaml
   ```

4. Create some test data.

   ```{code-block} shell
   echo "{\"streams\": [{\"stream\": {\"job\": \"test\"}, \"values\": [[\"$(date +%s)000000000\", \"fizzbuzz\"]]}]}" > data.json
   ```

5. Run a test pod.

   ```{code-block} shell
   kubectl run -n loki -it --image alpine:latest loki-test -- sh
   ---
   apk add httpie
   ```

6. Test the service.

   ```{code-block} shell
   http post http://loki-gateway.loki.svc.cluster.local/loki/api/v1/push \
      'Content-Type:application/json' 'X-Scope-OrgId:foo' < data.json
   ```
