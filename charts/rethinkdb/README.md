# RethinkDB Helm chart

Single-node [RethinkDB](https://rethinkdb.com/) for the Expo platform, packaged as its own chart
(and consumed as a subchart by `expo-manager`). It replaces the
[fastlorenzo/rethinkdb-helm-chart](https://github.com/fastlorenzo/rethinkdb-helm-chart) fork this
project used to depend on.

Clustering is not supported: this chart runs exactly one RethinkDB node
(`replicaCount` must stay `1`; the chart fails to render otherwise).

## Parameters

### Global parameters

| Name                      | Description                                                                                        | Value |
| ------------------------- | -------------------------------------------------------------------------------------------------- | ----- |
| `global.imageRegistry`    | Global container image registry, overrides `image.registry` for all images                         | `""`  |
| `global.imagePullSecrets` | Global list of image pull secret names, appended to `image.pullSecrets`                            | `[]`  |
| `global.storageClass`     | Global storageClass for the data PVC, overrides `persistence.storageClass` unless that is also set | `""`  |

### Common parameters

| Name           | Description                                     | Value |
| -------------- | ----------------------------------------------- | ----- |
| `nameOverride` | String to partially override rethinkdb.fullname | `""`  |

### RethinkDB image parameters

| Name                | Description                                                         | Value                 |
| ------------------- | ------------------------------------------------------------------- | --------------------- |
| `image.registry`    | RethinkDB image registry                                            | `docker.io`           |
| `image.repository`  | RethinkDB image repository                                          | `library/rethinkdb`   |
| `image.tag`         | RethinkDB image tag                                                 | `2.4.4-bookworm-slim` |
| `image.digest`      | RethinkDB image digest, overrides `image.tag` when set              | `""`                  |
| `image.pullPolicy`  | RethinkDB image pull policy                                         | `IfNotPresent`        |
| `image.pullSecrets` | RethinkDB image pull secrets, merged with `global.imagePullSecrets` | `[]`                  |

### RethinkDB parameters

| Name                            | Description                                                                                                                                                                                                      | Value   |
| ------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------- |
| `replicaCount`                  | Number of RethinkDB replicas. Clustering is not supported by this chart -- any value other than 1 fails the render.                                                                                              | `1`     |
| `existingSecret`                | Name of an existing Secret carrying the admin password under the `rethinkdb-password` key. Takes precedence over `rethinkdbPassword`.                                                                            | `""`    |
| `rethinkdbPassword`             | RethinkDB admin password, ignored when `existingSecret` is set. When empty, a random password is generated once and kept stable across upgrades.                                                                 | `""`    |
| `cacheSizeMB`                   | RethinkDB `--cache-size` in MB. Keep comfortably below `resources.limits.memory` (RethinkDB's own bookkeeping and connection buffers also need headroom) -- the 512Mi default fits the 2Gi memory limit default. | `512`   |
| `httpAdmin.enabled`             | Enable the RethinkDB web admin UI and its ClusterIP service. The admin UI has no authentication of its own -- only enable this behind a gateway/route that adds one.                                             | `false` |
| `httpAdmin.service.annotations` | Annotations for the admin Service                                                                                                                                                                                | `{}`    |
| `service.annotations`           | Annotations for the driver Service                                                                                                                                                                               | `{}`    |

### StatefulSet parameters

| Name                                                | Description                                                            | Value            |
| --------------------------------------------------- | ---------------------------------------------------------------------- | ---------------- |
| `podAnnotations`                                    | Annotations for the RethinkDB pod                                      | `{}`             |
| `podLabels`                                         | Extra labels for the RethinkDB pod                                     | `{}`             |
| `nodeSelector`                                      | Node labels for pod assignment                                         | `{}`             |
| `tolerations`                                       | Tolerations for pod assignment                                         | `[]`             |
| `affinity`                                          | Affinity for pod assignment                                            | `{}`             |
| `topologySpreadConstraints`                         | Topology spread constraints for the pod                                | `[]`             |
| `priorityClassName`                                 | Priority class for the pod                                             | `""`             |
| `podSecurityContext.runAsNonRoot`                   | Require the pod to run as a non-root user                              | `true`           |
| `podSecurityContext.runAsUser`                      | User ID to run the RethinkDB process as                                | `1000`           |
| `podSecurityContext.runAsGroup`                     | Group ID to run the RethinkDB process as                               | `1000`           |
| `podSecurityContext.fsGroup`                        | Group ID that owns the mounted data PVC                                | `1000`           |
| `podSecurityContext.seccompProfile.type`            | Seccomp profile type                                                   | `RuntimeDefault` |
| `containerSecurityContext.allowPrivilegeEscalation` | Whether the RethinkDB process can gain more privileges than its parent | `false`          |
| `containerSecurityContext.readOnlyRootFilesystem`   | Mount the container's root filesystem as read-only                     | `true`           |
| `containerSecurityContext.capabilities.drop`        | Linux capabilities to drop                                             | `["ALL"]`        |
| `containerSecurityContext.seccompProfile.type`      | Seccomp profile type                                                   | `RuntimeDefault` |
| `startupProbe.enabled`                              | Enable the startupProbe                                                | `true`           |
| `startupProbe.initialDelaySeconds`                  | Initial delay seconds for the startupProbe                             | `0`              |
| `startupProbe.periodSeconds`                        | Period seconds for the startupProbe                                    | `5`              |
| `startupProbe.timeoutSeconds`                       | Timeout seconds for the startupProbe                                   | `1`              |
| `startupProbe.failureThreshold`                     | Failure threshold for the startupProbe (60 x 5s = 5 minutes)           | `60`             |
| `startupProbe.successThreshold`                     | Success threshold for the startupProbe                                 | `1`              |
| `readinessProbe.enabled`                            | Enable the readinessProbe                                              | `true`           |
| `readinessProbe.initialDelaySeconds`                | Initial delay seconds for the readinessProbe                           | `0`              |
| `readinessProbe.periodSeconds`                      | Period seconds for the readinessProbe                                  | `10`             |
| `readinessProbe.timeoutSeconds`                     | Timeout seconds for the readinessProbe                                 | `1`              |
| `readinessProbe.failureThreshold`                   | Failure threshold for the readinessProbe                               | `3`              |
| `readinessProbe.successThreshold`                   | Success threshold for the readinessProbe                               | `1`              |
| `livenessProbe.enabled`                             | Enable the livenessProbe                                               | `true`           |
| `livenessProbe.initialDelaySeconds`                 | Initial delay seconds for the livenessProbe                            | `0`              |
| `livenessProbe.periodSeconds`                       | Period seconds for the livenessProbe                                   | `10`             |
| `livenessProbe.timeoutSeconds`                      | Timeout seconds for the livenessProbe                                  | `1`              |
| `livenessProbe.failureThreshold`                    | Failure threshold for the livenessProbe                                | `3`              |
| `livenessProbe.successThreshold`                    | Success threshold for the livenessProbe                                | `1`              |
| `resources.requests.cpu`                            | Requested CPU                                                          | `250m`           |
| `resources.requests.memory`                         | Requested memory                                                       | `1Gi`            |
| `resources.limits.cpu`                              | CPU limit                                                              | `1`              |
| `resources.limits.memory`                           | Memory limit                                                           | `2Gi`            |

### Persistence parameters

| Name                       | Description                                                                                                                                                                  | Value               |
| -------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------- |
| `persistence.size`         | Size of the data PVC                                                                                                                                                         | `10Gi`              |
| `persistence.storageClass` | StorageClass for the data PVC. Empty uses the cluster default; `"-"` disables dynamic provisioning (`storageClassName: ""`). Falls back to `global.storageClass` when unset. | `""`                |
| `persistence.accessModes`  | Access modes for the data PVC                                                                                                                                                | `["ReadWriteOnce"]` |
| `persistence.labels`       | Extra labels for the data PVC                                                                                                                                                | `{}`                |
| `persistence.annotations`  | Extra annotations for the data PVC, e.g. a backup operator's repository label                                                                                                | `{}`                |
| `persistence.dataSource`   | Data source for the data PVC, e.g. to restore from a VolumeSnapshot                                                                                                          | `{}`                |

### Other parameters

| Name                                      | Description                                                                                                                                  | Value          |
| ----------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------- | -------------- |
| `pdb.enabled`                             | Create a PodDisruptionBudget. With a single replica this only prevents *voluntary* evictions from also being disruptive, so it defaults off. | `false`        |
| `pdb.maxUnavailable`                      | Max unavailable pods allowed by the PodDisruptionBudget                                                                                      | `0`            |
| `networkPolicy.enabled`                   | Create a NetworkPolicy restricting traffic to the pod                                                                                        | `false`        |
| `networkPolicy.allowedPodSelectors`       | List of `matchLabels` maps allowed to reach the driver port (28015)                                                                          | `[]`           |
| `networkPolicy.allowedNamespaceSelectors` | List of namespace `matchLabels` maps allowed to reach the driver port (28015)                                                                | `[]`           |
| `tests.image.registry`                    | Image registry for the `helm test` connection-check pod                                                                                      | `docker.io`    |
| `tests.image.repository`                  | Image repository for the `helm test` connection-check pod                                                                                    | `busybox`      |
| `tests.image.tag`                         | Image tag for the `helm test` connection-check pod                                                                                           | `1.36`         |
| `tests.image.pullPolicy`                  | Image pull policy for the `helm test` connection-check pod                                                                                   | `IfNotPresent` |

## Upgrading from the 1.x fork

The 1.x fork (`fastlorenzo/rethinkdb-helm-chart`, itself a 2021 pozetron fork) ran a 3-node
RethinkDB cluster fronted by a proxy Deployment, a custom `pozetroninc/rethinkdb-cluster` image
running as root, and RBAC for endpoint-based cluster discovery. None of that carries over:

- **Single node, official image.** This chart runs one RethinkDB node on the official
  `docker.io/library/rethinkdb` image, with no proxy and no ClusterRole/ServiceAccount. If you
  were relying on the fork's cluster for read scaling or availability, that capability is gone --
  a single StatefulSet replica is now the supported shape.
- **Data migration.** The data directory layout, and the ownership of the PVC, are both different,
  so an in-place PVC swap will not work. Move data with a dump/restore:
  1. Against the *old* cluster/proxy, take a dump while it is still running:
     `rethinkdb dump -c <old-proxy-host>:28015 --password-file <(echo -n "$OLD_PASSWORD") -f backup.tar.gz`.
  2. Install this chart (it provisions its own PVC and Secret, or point `existingSecret` at your
     existing one -- see below).
  3. Copy the dump into the new pod and restore:
     `kubectl cp backup.tar.gz <namespace>/<release>-rethinkdb-0:/tmp/backup.tar.gz` then
     `kubectl exec -n <namespace> <release>-rethinkdb-0 -- rethinkdb restore /tmp/backup.tar.gz -c localhost:28015 --password-file <(echo -n "$RETHINKDB_PASSWORD")`.
  4. Verify table counts/row counts match before decommissioning the old cluster.
- **Root to uid 1000.** The fork's image ran as root; this chart's defaults run as uid/gid 1000
  with a read-only root filesystem (verified against the official
  `rethinkdb:2.4.4-bookworm-slim` image). If you ever reused a PVC written by the old image
  directly (rather than dump/restore, which sidesteps this entirely), it needs a one-off
  `chown -R 1000:1000` before this chart's pod can write to it. `fsGroup: 1000` handles this
  automatically for a *fresh* PVC.
- **`existingSecret` is unchanged.** The Secret key is still `rethinkdb-password`, and the
  `existingSecret` value still names a Secret carrying that key -- so a GitOps install that
  already sets e.g. `existingSecret: batibouw-2025` needs no change here.
- **Admin UI.** The fork exposed the admin UI unconditionally; this chart defaults
  `httpAdmin.enabled` to `false` and only renders the ClusterIP service on request. Its web UI
  has no authentication of its own -- put it behind a gateway/route that adds some before turning
  it on.
