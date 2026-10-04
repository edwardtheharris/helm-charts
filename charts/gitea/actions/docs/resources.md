# Resource limits and capacity

By default, all resource values are empty (`{}`). Without explicit limits, runner pods can consume unbounded CPU and memory on a node. This guide explains how to configure resource usage properly.

## Pod architecture

Each runner pod contains two resource-consuming containers:

| Container | Role | Helm value |
| --- | --- | --- |
| `runner` | Polls Gitea and orchestrates CI jobs | `statefulset.runner.resources` |
| `dind` | Docker-in-Docker daemon; executes job containers | `statefulset.dind.resources` |

The DinD container runs as a native sidecar (`initContainer` with `restartPolicy: Always`).

## Helm resource keys

Three values control Kubernetes resource requests and limits:

| Key | Purpose |
| --- | --- |
| `statefulset.resources` | Shared fallback applied to **both** containers when no override is set |
| `statefulset.runner.resources` | Override for the `runner` container only |
| `statefulset.dind.resources` | Override for the `dind` container only |

Precedence:

```text
statefulset.runner.resources  →  else statefulset.resources
statefulset.dind.resources    →  else statefulset.resources
```

**Recommendation:** set `statefulset.runner.resources` and `statefulset.dind.resources`
explicitly instead of relying on the shared fallback. The runner process is lightweight;
DinD and CI workloads need most of the budget.

## Example: separate runner and DinD limits

```yaml
enabled: true
giteaRootURL: https://gitea.example.com
existingSecret: runner-secret
existingSecretKey: runner-token

statefulset:
  replicas: 1

  runner:
    resources:
      requests:
        cpu: 100m
        memory: 256Mi
      limits:
        cpu: 500m
        memory: 512Mi
    config: |
      log:
        level: info
      cache:
        enabled: false
      runner:
        capacity: 1
      container:
        require_docker: true
        docker_timeout: 300s

  dind:
    resources:
      requests:
        cpu: 500m
        memory: 2Gi
      limits:
        cpu: 2
        memory: 4Gi
```

## Two layers of limiting

Kubernetes limits and act-runner job limits serve different purposes. Use both for a robust setup.

### 1. Kubernetes limits (Helm values)

These apply to the `runner` and `dind` containers in the pod.

- **`dind` limits** cap the Docker daemon and everything it runs inside the pod (images, build caches, job containers).
- **`runner` limits** cap the act-runner process itself.

If neither is set, a runaway build can exhaust the entire node.

### 2. Per-job Docker limits (`container.options`)

CI jobs run as Docker containers spawned by act-runner through the Docker socket. They are
**not** separate Kubernetes containers. Configure per-job limits in `statefulset.runner.config`
— see [act-runner configuration](https://docs.gitea.com/usage/actions/act-runner#configuration)
and [config.example.yaml](https://gitea.com/gitea/runner/src/branch/main/internal/pkg/config/config.example.yaml).

## act-runner settings that affect resource usage

Settings such as `runner.capacity` and `container.options` live in `statefulset.runner.config`, not in the Helm resource values. Refer to the runner documentation for details:

- [act-runner configuration](https://docs.gitea.com/usage/actions/act-runner#configuration)
- [config.example.yaml](https://gitea.com/gitea/runner/src/branch/main/internal/pkg/config/config.example.yaml) in the [Gitea/runner](https://gitea.com/gitea/runner) repository

When concurrent jobs or per-job Docker limits increase expected load, size `statefulset.dind.resources` accordingly on the Helm side.

## Capacity planning

These formulas apply to the Helm resource values (`statefulset.runner.resources`, `statefulset.dind.resources`, `statefulset.replicas`):

### Per pod

```text
pod budget ≈ runner.limits + dind.limits
```

### Per node

```text
node budget ≈ (runner.limits + dind.limits) × statefulset.replicas + system overhead
```

Example with the configuration above and `replicas: 3`:

- runner: 512Mi × 3 = 1.5Gi
- dind: 4Gi × 3 = 12Gi
- total: ~13.5Gi minimum, excluding other workloads on the node

Use `statefulset.nodeSelector` and `statefulset.tolerations` to place runners on dedicated nodes when needed.

## Why not only set `statefulset.resources`?

Before chart 0.1.2, one value was copied to **both** containers. **Requests** are where it
hurts most: the scheduler reserves capacity per container, and both inherit the same numbers.

```yaml
# Only statefulset.resources — requests copied to runner AND dind:
statefulset:
  resources:
    requests:
      cpu: 500m
      memory: 2Gi      # what DinD needs…
  # runner also requests 500m + 2Gi → pod ~1 CPU + ~4Gi reserved (mostly wasted)
  # dind requests 500m + 2Gi ✓
```

```yaml
statefulset:
  resources:
    requests:
      cpu: 100m
      memory: 256Mi    # what the runner actually needs…
  # runner requests 100m + 256Mi ✓
  # dind requests 100m + 256Mi too → tiny slot, builds starve ✗
```

```yaml
# Separate overrides — scheduler sees the real footprint:
statefulset:
  resources: {}
  runner:
    resources:
      requests:
        cpu: 100m
        memory: 256Mi
  dind:
    resources:
      requests:
        cpu: 500m
        memory: 2Gi
  # pod requests ~600m CPU + ~2.25Gi RAM — not 1 CPU + 4Gi, nor 200m + 512Mi
```

Limits follow the same split. Unset overrides (`{}`) still fall back to `statefulset.resources`.
