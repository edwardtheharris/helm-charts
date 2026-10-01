---
abstract: A brief installation document
title: cert-manager install
---

```{code-block} shell
:caption: cms
k create ns cert-manager && kubie ns cert-manager
h upgrade --install cert-manager jetstack/cert-manager -f cms.values.yaml
```


```{code-block} shell
:caption: cms
k apply -f manifests/cms.bs.yaml
```


```{code-block} shell
:caption: cms
k apply -f manifests/cms.issue.yaml
```

