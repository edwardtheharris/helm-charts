---
abstract: >-
   Charts documentation master file, created by
   sphinx-quickstart on Tue Jul 30 10:32:33 2024.
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.
authors:
   - name: Xander Harris
     email: xandertheharris@gmail.com
date: 2024-07-30
title: Charts Index
---

A small index of Helm charts intended to serve the author's purposes and shared
publicly in case someone else has similar purposes.

```{toctree}
:caption: meta

charts/grafana/index
license
readme
```

## Usage

[Helm](https://helm.sh) must be installed to use the charts.  Please refer to
Helm's [documentation](https://helm.sh/docs) to get started.

Once Helm has been set up correctly, add the repo as follows:

```shell
helm repo add eth https://edwardtheharris.github.io/helm-charts
```

If you had already added this repo earlier, run `helm repo update` to retrieve
the latest versions of the packages.  You can then run `helm search repo
eth` to see the charts.

To install the `${chart_name}` chart:

```shell
helm install ${chart_name} ${eth}/${chart_name}
```

To uninstall the chart:

```shell
helm delete ${chart_name}
```

## Glossary

```{glossary}
Helm
   This is a simple program that allows for easy maintenance of Kubernetes
   resources. More information is available at [helm.sh](https://helm.sh),
   or the [helm repo](https://helm.sh/docs/helm/helm_repo/).
```
