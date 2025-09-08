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
:caption: contents

charts/cert-manager/index
charts/flannel/index
charts/grafana/index
charts/loki/index
charts/nautobot/index
charts/nextcloud/index
charts/nginx/index
charts/prometheus/index
```

```{toctree}
:caption: meta

changelog
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

````{glossary}
:sorted:
alertingRules
   Definition of alerts that Prometheus should send when adverse conditions
   are detected. Alerts configuration information available
   [here](https://prometheus.io/docs/prometheus/latest/configuration/alerting_rules/).

   ```{code-block} yaml
   alerting_rules.yml:
     groups:
       - name: Instances
         rules:
           - alert: InstanceDown
             expr: up == 0
             for: 5m
             labels:
               severity: page
             annotations:
               description: '{{ $labels.instance }} of job {{ $labels.job }} has been down for more than 5 minutes.'
               summary: 'Instance {{ $labels.instance }} down'
   ```

deployment strategy
   Strategy used when deploying new versions of resources. More information
   is available
   [here](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#strategy).

exemplars
   A Prometheus feature. Must be enabled via
   `--enable-feature=exemplar-storage`{l=shell}
   More information available
   [here](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#exemplars)

   ```{code-block} yaml
   :caption: example exemplars

   exemplars:
      max_exemplars: 100000
   ```

Helm
  [Helm](https://helm.sh) is the package manager for Kubernetes

ingress
   Any method for allowing traffic into a Kubernetes cluster. More information
   is available [here](https://kubernetes.io/docs/concepts/services-networking/ingress/)

lifecycle events
   An event during the lifecycle of a workload that can be used to trigger
   an action in the cluster. More information is available
   [here](https://kubernetes.io/docs/tasks/configure-pod-container/attach-handler-lifecycle-event/).

liveness
   Whether or not a service is alive. Learn more
   [here](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/).

podAntiAffinityTopologyKey
   If anti-affinity is enabled sets the topologyKey to use for anti-affinity.
    This can be changed to, for example, failure-domain.beta.kubernetes.io/zone

podDisruptionBudget
  PodDisruptionBudget settings. More information available
  [here](https://kubernetes.io/docs/concepts/workloads/pods/disruptions/).

podSecurityPolicy
   Specify pod annotations, for example:
   - [apparmor](https://kubernetes.io/docs/concepts/policy/pod-security-policy/#apparmor)
   - [seccomp](https://kubernetes.io/docs/concepts/policy/pod-security-policy/#seccomp)
   - [sysctl](https://kubernetes.io/docs/concepts/policy/pod-security-policy/#sysctl)

   ```{code-block} yaml
   podSecurityPolicy:
      annotations:
        seccomp.security.alpha.kubernetes.io/allowedProfileNames: '*'
        seccomp.security.alpha.kubernetes.io/defaultProfileName: 'docker/default'
        apparmor.security.beta.kubernetes.io/defaultProfileName: 'runtime/default'
   ```

readiness
   Whether or not a service is ready to use. Learn more
   [here](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/)

remoteRead
   Information available
   [here](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#remote_read)

remoteWrite
   Information available
   [here](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#remote_write).

resources
   A method for requesting and limiting resources available to a workload.
   Learn more
   [here](http://kubernetes.io/docs/user-guide/compute-resources/).

retentionSize
   Prometheus' data retention size.
   Supported units: `B`, `KB`, `MB`, `GB`, `TB`, `PB`, `EB`.

serverFiles
   Prometheus configuration files as defined in `values.yaml`.

   Records configuration, more information available
   [here](https://prometheus.io/docs/prometheus/latest/configuration/recording_rules/).

storagePath
   The data directory used by prometheus to set `--storage.tsdb.path`{l=shell}
   When empty `server.persistentVolume.mountPath`{l=yaml} is used instead.

topologySpreadConstraints
  Pod topology spread constraints. More information available
  [here](https://kubernetes.io/docs/concepts/scheduling-eviction/topology-spread-constraints/)

tsdb
   Time Series Database, more information available
   [here](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#tsdb).

   ```{code-block} yaml
   :caption: tsdb example

   tsdb:
      out_of_order_time_window: 0s
   ```

unhealthyPodEvictionPolicy
   `unhealthyPodEvictionPolicy`{l=yaml} is available since 1.27.0 (beta) More
   information is available
   [here](https://kubernetes.io/docs/tasks/run-application/configure-pdb/#unhealthy-pod-eviction-policy).

   `unhealthyPodEvictionPolicy: IfHealthyBudget`{l=yaml}
````
