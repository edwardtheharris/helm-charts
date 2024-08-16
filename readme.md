---
abstract: >-
    This is the Helm Charts repository for charts written by @edwardtheharris.
authors:
    - name: Xander Harris
      email: xandertheharris@gmail.com
date: 2024-07-18
title: Helm Charts
---

[![wakatime](https://wakatime.com/badge/github/edwardtheharris/helm-charts.svg)](https://wakatime.com/badge/github/edwardtheharris/helm-charts)

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
