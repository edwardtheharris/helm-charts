# gateway crds helm

```sh
helm template envoy-gateway-crds . | kubectl apply --server-side --force-conflicts -f -
```
