# RethinkDB Helm chart

[RethinkDB](https://rethinkdb.com/) for the Expo platform, packaged as its own chart (and consumed
as a subchart by `expo-manager`). It replaces the
[fastlorenzo/rethinkdb-helm-chart](https://github.com/fastlorenzo/rethinkdb-helm-chart) fork this
project used to depend on.

The default is a single node (`replicaCount: 1`). Setting `replicaCount` to 3 (or more) forms a
RethinkDB cluster on the official image, without a custom image, a proxy tier or any Kubernetes
API access -- see [Clustering and HA](#clustering-and-ha). Table replication is a separate,
per-table setting the application raises afterwards -- see [Replication](#replication).

## Parameters

### Global parameters

| Name                      | Description                                                                                        | Value |
| ------------------------- | -------------------------------------------------------------------------------------------------- | ----- |
| `global.imageRegistry`    | Global container image registry, overrides `image.registry` for all images                         | `""`  |
| `global.imagePullSecrets` | Global list of image pull secret names, appended to `image.pullSecrets`                            | `[]`  |
| `global.storageClass`     | Global storageClass for the data PVC, overrides `persistence.storageClass` unless that is also set | `""`  |

### Common parameters

| Name            | Description                                                                                                                       | Value           |
| --------------- | --------------------------------------------------------------------------------------------------------------------------------- | --------------- |
| `nameOverride`  | String to partially override rethinkdb.fullname                                                                                   | `""`            |
| `clusterDomain` | Kubernetes cluster domain, used to build the pods' stable DNS names (`<pod>.<fullname>-headless.<namespace>.svc.<clusterDomain>`) | `cluster.local` |

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

| Name                                | Description                                                                                                                                                                                                                                                                                                                                         | Value   |
| ----------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------- |
| `replicaCount`                      | Number of RethinkDB servers. `1` runs a single node; any higher value forms a cluster in which every pod joins every other pod (an odd count, typically 3, is recommended so table primaries can be elected by majority). Table replication is a per-table setting that the application (or you) must raise afterwards -- see README "Replication". | `1`     |
| `cluster.peerResolveTimeoutSeconds` | How long (seconds) a starting member waits for the DNS records of its lower-ordinal peers before starting without those `--join`s. RethinkDB exits when a `--join` hostname does not resolve; a peer that comes up later joins on its own.                                                                                                          | `60`    |
| `existingSecret`                    | Name of an existing Secret carrying the admin password under the `rethinkdb-password` key. Takes precedence over `rethinkdbPassword`.                                                                                                                                                                                                               | `""`    |
| `rethinkdbPassword`                 | RethinkDB admin password, ignored when `existingSecret` is set. When empty, a random password is generated once and kept stable across upgrades; the generated Secret is kept on uninstall (like the data PVCs) so a reinstall under the same release name reuses it -- see README "Reinstalling with retained volumes".                            | `""`    |
| `cacheSizeMB`                       | RethinkDB `--cache-size` in MB. Keep comfortably below `resources.limits.memory` (RethinkDB's own bookkeeping and connection buffers also need headroom) -- the 512Mi default fits the 2Gi memory limit default.                                                                                                                                    | `512`   |
| `httpAdmin.enabled`                 | Enable the RethinkDB web admin UI and its ClusterIP service. The admin UI has no authentication of its own -- only enable this behind a gateway/route that adds one.                                                                                                                                                                                | `false` |
| `httpAdmin.service.annotations`     | Annotations for the admin Service                                                                                                                                                                                                                                                                                                                   | `{}`    |
| `service.annotations`               | Annotations for the driver Service                                                                                                                                                                                                                                                                                                                  | `{}`    |

### StatefulSet parameters

| Name                                                | Description                                                                                                                                                 | Value            |
| --------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------- |
| `podAnnotations`                                    | Annotations for the RethinkDB pod                                                                                                                           | `{}`             |
| `podLabels`                                         | Extra labels for the RethinkDB pod                                                                                                                          | `{}`             |
| `nodeSelector`                                      | Node labels for pod assignment                                                                                                                              | `{}`             |
| `tolerations`                                       | Tolerations for pod assignment                                                                                                                              | `[]`             |
| `affinity`                                          | Affinity for pod assignment. When empty and `replicaCount` > 1, a preferred pod anti-affinity on `kubernetes.io/hostname` spreads the members across nodes. | `{}`             |
| `topologySpreadConstraints`                         | Topology spread constraints for the pod                                                                                                                     | `[]`             |
| `priorityClassName`                                 | Priority class for the pod                                                                                                                                  | `""`             |
| `podSecurityContext.runAsNonRoot`                   | Require the pod to run as a non-root user                                                                                                                   | `true`           |
| `podSecurityContext.runAsUser`                      | User ID to run the RethinkDB process as                                                                                                                     | `1000`           |
| `podSecurityContext.runAsGroup`                     | Group ID to run the RethinkDB process as                                                                                                                    | `1000`           |
| `podSecurityContext.fsGroup`                        | Group ID that owns the mounted data PVC                                                                                                                     | `1000`           |
| `podSecurityContext.seccompProfile.type`            | Seccomp profile type                                                                                                                                        | `RuntimeDefault` |
| `containerSecurityContext.allowPrivilegeEscalation` | Whether the RethinkDB process can gain more privileges than its parent                                                                                      | `false`          |
| `containerSecurityContext.readOnlyRootFilesystem`   | Mount the container's root filesystem as read-only                                                                                                          | `true`           |
| `containerSecurityContext.capabilities.drop`        | Linux capabilities to drop                                                                                                                                  | `["ALL"]`        |
| `containerSecurityContext.seccompProfile.type`      | Seccomp profile type                                                                                                                                        | `RuntimeDefault` |
| `startupProbe.enabled`                              | Enable the startupProbe                                                                                                                                     | `true`           |
| `startupProbe.initialDelaySeconds`                  | Initial delay seconds for the startupProbe                                                                                                                  | `0`              |
| `startupProbe.periodSeconds`                        | Period seconds for the startupProbe                                                                                                                         | `5`              |
| `startupProbe.timeoutSeconds`                       | Timeout seconds for the startupProbe                                                                                                                        | `1`              |
| `startupProbe.failureThreshold`                     | Failure threshold for the startupProbe (60 x 5s = 5 minutes)                                                                                                | `60`             |
| `startupProbe.successThreshold`                     | Success threshold for the startupProbe                                                                                                                      | `1`              |
| `readinessProbe.enabled`                            | Enable the readinessProbe                                                                                                                                   | `true`           |
| `readinessProbe.initialDelaySeconds`                | Initial delay seconds for the readinessProbe                                                                                                                | `0`              |
| `readinessProbe.periodSeconds`                      | Period seconds for the readinessProbe                                                                                                                       | `10`             |
| `readinessProbe.timeoutSeconds`                     | Timeout seconds for the readinessProbe                                                                                                                      | `1`              |
| `readinessProbe.failureThreshold`                   | Failure threshold for the readinessProbe                                                                                                                    | `3`              |
| `readinessProbe.successThreshold`                   | Success threshold for the readinessProbe                                                                                                                    | `1`              |
| `livenessProbe.enabled`                             | Enable the livenessProbe                                                                                                                                    | `true`           |
| `livenessProbe.initialDelaySeconds`                 | Initial delay seconds for the livenessProbe                                                                                                                 | `0`              |
| `livenessProbe.periodSeconds`                       | Period seconds for the livenessProbe                                                                                                                        | `10`             |
| `livenessProbe.timeoutSeconds`                      | Timeout seconds for the livenessProbe                                                                                                                       | `1`              |
| `livenessProbe.failureThreshold`                    | Failure threshold for the livenessProbe                                                                                                                     | `3`              |
| `livenessProbe.successThreshold`                    | Success threshold for the livenessProbe                                                                                                                     | `1`              |
| `resources.requests.cpu`                            | Requested CPU                                                                                                                                               | `250m`           |
| `resources.requests.memory`                         | Requested memory                                                                                                                                            | `1Gi`            |
| `resources.limits.cpu`                              | CPU limit                                                                                                                                                   | `1`              |
| `resources.limits.memory`                           | Memory limit                                                                                                                                                | `2Gi`            |

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

| Name                                      | Description                                                                                                                                                                                           | Value          |
| ----------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------- |
| `pdb.enabled`                             | Create a PodDisruptionBudget when `replicaCount` > 1. Never rendered for a single node, where a budget could only block node drains without adding availability.                                      | `true`         |
| `pdb.maxUnavailable`                      | Max unavailable pods allowed by the PodDisruptionBudget                                                                                                                                               | `1`            |
| `serviceAccount.create`                   | Create a dedicated ServiceAccount for the RethinkDB pods. Its identity lets mesh authorization (e.g. Istio `principals`) admit only the members themselves to the unauthenticated cluster port 29015. | `true`         |
| `serviceAccount.name`                     | Name of the ServiceAccount. The fullname when empty and `create` is true; `default` otherwise.                                                                                                        | `""`           |
| `serviceAccount.annotations`              | Annotations for the ServiceAccount                                                                                                                                                                    | `{}`           |
| `networkPolicy.enabled`                   | Create a NetworkPolicy restricting traffic to the pod                                                                                                                                                 | `false`        |
| `networkPolicy.allowedPodSelectors`       | List of `matchLabels` maps allowed to reach the driver port (28015)                                                                                                                                   | `[]`           |
| `networkPolicy.allowedNamespaceSelectors` | List of namespace `matchLabels` maps allowed to reach the driver port (28015)                                                                                                                         | `[]`           |
| `tests.image.registry`                    | Image registry for the `helm test` connection-check pod                                                                                                                                               | `docker.io`    |
| `tests.image.repository`                  | Image repository for the `helm test` connection-check pod                                                                                                                                             | `busybox`      |
| `tests.image.tag`                         | Image tag for the `helm test` connection-check pod                                                                                                                                                    | `1.36`         |
| `tests.image.pullPolicy`                  | Image pull policy for the `helm test` connection-check pod                                                                                                                                            | `IfNotPresent` |

## Clustering and HA

`replicaCount > 1` turns the StatefulSet into a RethinkDB cluster. Everything below was verified
on RethinkDB 2.4.4 in kind (3 members, pod deletion, scale down/up, upgrade from chart 1.0.0;
chart 1.0.1's addressing as described below).

### How the cluster forms

Each pod runs a small `sh` wrapper (see `templates/statefulset.yaml`) that derives everything
from its own hostname; no sidecar, operator, custom image or ServiceAccount token is involved:

- `--server-name` is the pod hostname with `-` mapped to `_` (RethinkDB only allows
  `[A-Za-z0-9_]`), so the members are `<fullname>_0`, `<fullname>_1`, ... A name is only applied
  to a fresh data directory; on an existing one RethinkDB logs
  `WARNING: ignoring --server-name because this server already has a name.` and keeps the
  persisted identity (a node upgraded from chart 1.0.0 keeps its generated `<host>_<random>`
  name; rename it through `r.db('rethinkdb').table('server_config')` if you care).
- `--canonical-address` is the pod IP (downward API `status.podIP`; IPv6 is bracketed), and every
  `--join` is the IP the wrapper resolved from the peer's stable name
  `<fullname>-<i>.<fullname>-headless.<namespace>.svc.<clusterDomain>` (`clusterDomain` defaults
  to `cluster.local`). **RethinkDB itself is never given a DNS name.** It resolves canonical and
  `--join` addresses again on every (re)connection, and while a member's pod is being replaced
  its record does not exist: up to chart 1.0.0, which passed the names, the other members then
  either aborted on `Guarantee failed: [peer.ips().size() > 0]` (an empty answer, as given by
  Istio ambient's DNS proxy) or dropped the returning peer as `unresolvable hostname` and could
  stay partitioned (seen in production during a rolling update). A stale IP is harmless: the
  dial is refused and retried, and a replaced member announces its new IP when it joins. The
  headless Service keeps `publishNotReadyAddresses: true`, so a member's name resolves as soon
  as its pod exists.
- `--join <ip>:29015` is passed for the other ordinals. Two RethinkDB behaviours shape how that
  list is built:
  - a `--join` target that cannot be resolved at startup is fatal (the process exits), which
    the wrapper avoids by resolving the names itself;
  - a `--join` target that is **down** is retried indefinitely, but the server
    does not open its driver port (28015) until at least one join has succeeded (observed for
    more than four minutes with a peer refusing connections: `Listening for intracluster
    connections` is logged, `Listening for client driver connections` is not).

  So the wrapper waits (up to `cluster.peerResolveTimeoutSeconds`, default 60) for the DNS
  records of the *lower* ordinals -- which the StatefulSet's `OrderedReady` policy guarantees are
  Running and Ready before this pod is created -- and joins them; *higher* ordinals are joined only
  if they already resolve (rolling restart, full restart) and are otherwise left to dial this pod
  themselves when they come up. On a cold start pod 0 therefore starts alone, pod 1 joins pod 0,
  pod 2 joins both, and a fresh 3-member cluster is ready in about 30 seconds. A lower-ordinal
  peer that never resolves (its pod object is gone) is skipped with a log line and the member
  starts without it. `podManagementPolicy` stays `OrderedReady` on purpose: the field is
  immutable, so switching it would break `helm upgrade` for every existing install.
- `--initial-password` is passed on every pod from the shared Secret. RethinkDB only honours it
  on a brand-new data directory that starts a new cluster; on a node that joins an existing
  cluster the cluster's password wins (tested with two *different* passwords in both join orders:
  the pre-existing cluster's password was accepted on every node, the joiner's was rejected), and
  on an existing data directory it logs `Ignoring --initial-password option because the admin
  password is already configured.` All members read the same Secret, so this never conflicts.

Since chart 1.0.1 RethinkDB does no DNS lookup for its peers, so neither of those errors has a
path left. Verified in kind on a 3-member cluster with a 3-replica table, after an in-place upgrade
from 1.0.0, by deleting each member in turn, two members at once and all three: the mesh stayed
full, no container restarted, every row stayed readable and neither error was logged.

**Upgrading from 1.0.0** rolls the StatefulSet once. While members on 1.0.0 still run, they dial
the replaced members by name and can hit the bug above one last time. Afterwards, check that every
member is connected to all the others: `r.db('rethinkdb').table('server_status')`, each server's
`network.connected_to` must list every other member as `true`. If two members are not connected
(queries hang, the API hangs at startup), restart **all** members together, for example
`kubectl exec <pod> -- kill -TERM 1` on each in quick succession: the containers restart in place,
every name keeps resolving, and the members form a full mesh again.

### Access

Drivers keep using the ClusterIP Service `<fullname>:28015`; it load-balances connections over the
Ready members, and any RethinkDB server serves any query (it routes to the right primary
internally). There is no proxy Deployment: RethinkDB's proxy mode mainly saves cluster-wide
metadata traffic per client connection, which is irrelevant at this scale. One can be added later
without changing the interface (`rethinkdb proxy --join ...` behind the same Service name).

`<fullname>-headless` resolves every member individually (`<fullname>-<i>.<fullname>-headless`),
which is what the wrapper, and the `helm test` pod, use.

### Failover

With a table replicated on 3 members (`replicas: 3`), deleting the pod that holds its primary
gave, through the ClusterIP, uninterrupted reads and exactly two failed writes over ~2 seconds
(`Cannot perform write: lost contact with primary replica`, then
`The primary replica is currently changing from one replica to another`). `server_status`
dropped to 2 while the pod was gone and was back at 3 about 7 seconds after the delete, with the
same server UUID and name (the data PVC is retained and re-attached). Writes to a table with a
single replica are of course unavailable while its only server is down: replication is what makes
the failover useful, see [Replication](#replication).

Defaults that switch on with `replicaCount > 1`:

- a preferred (`preferredDuringSchedulingIgnoredDuringExecution`) pod anti-affinity on
  `kubernetes.io/hostname`, so members land on different nodes when possible; set `affinity` to
  replace it (e.g. with a `required` one, or a zone topology key);
- a PodDisruptionBudget with `maxUnavailable: 1` (`pdb.enabled`, never rendered for one replica);
- the NetworkPolicy, when enabled, allows 29015 between the release's own pods.

`resources`/`cacheSizeMB` are per member and unchanged. Use an odd `replicaCount` (3): RethinkDB
tolerates any count, but table primaries are elected by a majority of a table's replicas, so 2 of
3 keeps writes available while 1 of 2 does not.

### Scaling

- **Up** (`helm upgrade --set replicaCount=3` on a 1-node install works in place): the rolling
  update restarts existing members once with the new `--join` list, new pods join their
  predecessors. Then wait until `r.db('rethinkdb').table('server_status').count()` equals the new
  count before raising table replicas (see [Replication](#replication)).
- **Down**: first reconfigure every table to `replicas <=` the new count (tables still
  referencing a removed member show that replica as `disconnected` in `table_status`; a
  disconnected server no longer appears in `server_config`, so it cannot be "deleted" -- the
  reconfigure is what drops it). Then lower `replicaCount`. The PVCs of the removed ordinals are
  retained (`whenScaled: Retain`): delete `data-<fullname>-<i>` yourself if you will not scale
  back, otherwise the member simply rejoins with its old data when you do.
- A table that lost a majority of its replicas for good needs
  `reconfigure({emergencyRepair: 'unsafe_rollback'})` -- see the RethinkDB failover docs.

## Service mesh

On an Istio ambient mesh all mTLS traffic reaches the pods on the HBONE port 15008, so the
NetworkPolicy's per-port rules (`networkPolicy.*`) do not restrict mesh clients. RethinkDB has no
authentication on its cluster port (29015) or its admin UI (8080), so restrict them with L4
`AuthorizationPolicy` rules on the source identity. The chart gives the pods their own
ServiceAccount (`serviceAccount.*`) for that:

```yaml
apiVersion: security.istio.io/v1
kind: AuthorizationPolicy
metadata:
  name: my-release-rethinkdb-deny
spec:
  selector:
    matchLabels:
      app.kubernetes.io/name: rethinkdb
      app.kubernetes.io/instance: my-release
  action: DENY
  rules:
    # Only the application may use the driver port.
    - from:
        - source:
            notPrincipals: ["cluster.local/ns/<ns>/sa/<app-serviceaccount>"]
      to:
        - operation:
            ports: ["28015"]
    # Only the other members may join the cluster.
    - from:
        - source:
            notPrincipals: ["cluster.local/ns/<ns>/sa/my-release-rethinkdb"]
      to:
        - operation:
            ports: ["29015"]
```

## Replication

RethinkDB replication and sharding are **per-table** settings, not cluster-wide ones: a table
created on a 3-member cluster still has 1 replica (on the server that happened to create it)
until it is reconfigured. The chart deliberately does not touch tables -- it does not know which
ones exist -- so:

- The Expo API applies the topology itself when it creates or opens its tables, from
  `RETHINKDB_TABLE_REPLICAS` / `RETHINKDB_TABLE_SHARDS` (added to the API alongside this chart
  change; set them to `3`/`1` for a 3-member cluster). Nothing else is needed for Expo.
- For any other consumer, raise it once per database (or per table) from any driver, e.g. in
  the Data Explorer or a `python:3-alpine` pod with `pip install rethinkdb`:

  ```js
  r.db('expo').reconfigure({shards: 1, replicas: 3})
  // or, one table at a time:
  r.db('expo').table('booths').reconfigure({shards: 1, replicas: 3})
  r.db('expo').table('booths').wait({waitFor: 'all_replicas_ready'})
  ```

  Sharding is only worth it for tables far larger than one member's cache; `shards: 1` keeps
  every query local to one primary.

Order of operations when growing a cluster: scale the StatefulSet first, wait until every member
is listed in `r.db('rethinkdb').table('server_status')` (Ready pods are not enough -- a member
serves drivers a moment before its peers see it), then raise `replicas`. `reconfigure` fails with
"not enough servers" if you do it the other way round.

## Reinstalling with retained volumes

`helm uninstall` keeps the data PVCs (`persistentVolumeClaimRetentionPolicy: Retain`) and, since
this version, also the chart-generated Secret (`helm.sh/resource-policy: keep`), because the two
belong together: RethinkDB stores the admin password *in the data directory* and ignores any
later `--initial-password` (`Ignoring --initial-password option because the admin password is
already configured.`). Reinstalling under the same release name and namespace adopts both, and
the password stays what the data was initialised with.

If the Secret is gone but the volumes are not (an uninstall of chart 1.0.0, or a deleted
Secret), a reinstall generates a *new* password that the data does not accept and every consumer
fails with `Wrong password`. Either reinstall with `existingSecret` pointing at a Secret holding
the old password, or delete the retained `data-<fullname>-<i>` PVCs to start empty. The
lookup-based password helper is only a convenience for keeping the value stable across upgrades
and same-name reinstalls; anything more deliberate (GitOps, a different release name, restoring
elsewhere) should use `existingSecret`.

## Upgrading from the 1.x fork

The 1.x fork (`fastlorenzo/rethinkdb-helm-chart`, itself a 2021 pozetron fork) ran a 3-node
RethinkDB cluster fronted by a proxy Deployment, a custom `pozetroninc/rethinkdb-cluster` image
running as root, and RBAC for endpoint-based cluster discovery. None of that carries over:

- **Official image, no proxy, no RBAC.** This chart runs RethinkDB on the official
  `docker.io/library/rethinkdb` image, one node by default, with no proxy tier and no
  ClusterRole/ServiceAccount. A cluster is still available (`replicaCount: 3`, see
  [Clustering and HA](#clustering-and-ha)) but drivers connect to the members directly through
  the ClusterIP Service instead of a proxy.
- **Data migration.** The data directory layout, and the ownership of the PVC, are both different,
  so an in-place PVC swap will not work. Move data with a dump/restore:
  1. Against the *old* cluster/proxy, take a dump while it is still running, from a pod that has
     the Python driver (the official image does not ship it -- `rethinkdb dump` fails inside the
     RethinkDB pod itself), e.g. `python:3-alpine` with `pip install rethinkdb`:
     `printf %s "$OLD_PASSWORD" > /tmp/pw && rethinkdb-dump -c <old-proxy-host>:28015 --password-file /tmp/pw -f /tmp/backup.tar.gz`.
  2. Install this chart (it provisions its own PVC and Secret, or point `existingSecret` at your
     existing one -- see below).
  3. From the same kind of pod, restore against the new driver Service:
     `printf %s "$NEW_PASSWORD" > /tmp/pw && rethinkdb-restore -c <release>-rethinkdb:28015 --password-file /tmp/pw /tmp/backup.tar.gz`.
  4. Verify table counts/row counts match before decommissioning the old cluster. On a cluster,
     raise the restored tables' replicas afterwards (see [Replication](#replication)).
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
