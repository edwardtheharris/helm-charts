---
abstract: >-
   Values for the official Grafana Helm Chart.
authors:
  - name: Xander Harris
    email: xandertheharris@gmail.com
date: 2024-09-26
title: Grafana Helm Chart Values
---

```{warning}
This work has been moved to the
[helm-monitoring](https://github.com/edwardtheharris/helm-monitoring)
repo with the remaining monitoring tools.
```

## Repository Contents

```{contents}
```

```{admonition} This is a copy
The following information is copied from the
[GitHub repo](https://github.com/grafana/helm-charts), which should be
considered the source of truth regarding the use of this chart.

In the event of differences between the two sets of information, the
GitHub repo should always be considered as the source of truth.
```

## Grafana Community Kubernetes Helm Charts

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![Artifact HUB](https://img.shields.io/endpoint?url=https://artifacthub.io/badge/repository/grafana)](https://artifacthub.io/packages/search?repo=grafana)

The code is provided as-is with no warranties.

### Usage

{term}`Helm` must be installed to use the charts.
Please refer to Helm's [documentation](https://helm.sh/docs/) to get started.

Once Helm is set up properly, add the repo as follows:

```{code-block} shell
:caption: add the repository

helm repo add grafana https://grafana.github.io/helm-charts
helm repo update
```

You can then run `helm search repo grafana` to see the charts.

Chart documentation is available in
[grafana directory](https://github.com/grafana/helm-charts/blob/main/charts/grafana/README.md).

### Contributing

We'd love to have you contribute! Please refer to our
[contribution guidelines](https://github.com/grafana/helm-charts/blob/main/CONTRIBUTING.md)
for details.

### License

[Apache 2.0 License](https://github.com/grafana/helm-charts/blob/main/LICENSE).

---

### Values

```{autoyaml} charts/grafana/values.yaml
```

```{sectionauthor} Xander Harris <xandertheharris@gmail.com>
```

## Data Sources

The {term}`PostgreSQL` data source requires read-only access.

You can find more information about that
[in this helpful serverfault post](https://serverfault.com/questions/60508/grant-select-to-all-tables-in-postgresql).

You may find [the actual readme](https://github.com/grafana/helm-charts/blob/main/charts/grafana/README.md)
helpful as well.

---

```{toctree}
:caption: official readme
README
```
