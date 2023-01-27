# Expo manager Helm chart

## Parameters

### Global parameters

| Name                      | Description                                       | Value |
| ------------------------- | ------------------------------------------------- | ----- |
| `global.imageRegistry`    | Global container image registry                   | `""`  |
| `global.imagePullSecrets` | Global container image pull secret                | `[]`  |
| `global.storageClass`     | Global storageClass to use for persistent volumes | `""`  |


### Common parameters

| Name                         | Description                                                                                                             | Value  |
| ---------------------------- | ----------------------------------------------------------------------------------------------------------------------- | ------ |
| `nameOverride`               | String to partially override mailu.fullname include (will maintain the release name)                                    | `""`   |
| `fullnameOverride`           | String to fully override mailu.fullname template                                                                        | `""`   |
| `commonLabels`               | Add labels to all the deployed resources                                                                                | `{}`   |
| `commonAnnotations`          | Add annotations to all the deployed resources                                                                           | `{}`   |
| `tolerations`                | Tolerations for pod assignment                                                                                          | `[]`   |
| `affinity`                   | Affinity for pod assignment                                                                                             | `{}`   |
| `serviceAccount.create`      | Specifies whether a service account should be created                                                                   | `true` |
| `serviceAccount.annotations` | Annotations to add to the service account                                                                               | `{}`   |
| `serviceAccount.name`        | The name of the service account to use - if not set and create is true, a name is generated using the fullname template | `""`   |


### Expo-manager parameters

| Name                     | Description                                                                                                                                                                | Value                          |
| ------------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------ |
| `environment`            | Environment to run expo-manager in                                                                                                                                         | `production`                   |
| `rethinkdbName`          | Name of the rethinkdb database                                                                                                                                             | `expo`                         |
| `apm.enabled`            | Enable APM                                                                                                                                                                 | `false`                        |
| `apm.server`             | APM server fqdn                                                                                                                                                            | `localhost`                    |
| `jwtSecret`              | JWT secret - ignored if existingSecret is set                                                                                                                              | `""`                           |
| `initialUserPassword`    | Initial password for the first user - ignored if existingSecret is set                                                                                                     | `""`                           |
| `existingSecret`         | Name of an existing secret to use for the jwtSecret (jwt-secret key), initialUserPassword (initial-user-password key) and email.senderPassword (email-sender-password key) | `""`                           |
| `email.server`           | SMTP server hostname or IP                                                                                                                                                 | `example.com`                  |
| `email.port`             | SMTP server port                                                                                                                                                           | `587`                          |
| `email.senderAddress`    | Email address to send emails from                                                                                                                                          | `expo@example.com`             |
| `email.senderName`       | Name to send emails from                                                                                                                                                   | `Expo 2023`                    |
| `email.senderUsername`   | SMTP server username used for authentication                                                                                                                               | `expo@example.com`             |
| `email.senderPassword`   | SMTP server password - ignored if existingSecret is set                                                                                                                    | `""`                           |
| `email.bcc`              | Email address to send bcc emails to                                                                                                                                        | `expo@example.com`             |
| `email.subject`          | Email subject                                                                                                                                                              | `Checkout stand`               |
| `checkout.text.fr`       | Text to show in checkout email and documents in french                                                                                                                     | `Texte en français`            |
| `checkout.text.nl`       | Text to show in checkout email and documents in dutch                                                                                                                      | `Tekst in het Nederlands`      |
| `checkout.text.en`       | Text to show in checkout email and documents in english                                                                                                                    | `Text in English`              |
| `checkout.entity`        | Entity name shown in email text and documents                                                                                                                              | `Befritco SCOM`                |
| `exposition.id`          | Id of the exposition                                                                                                                                                       | `exposition2023`               |
| `exposition.name`        | Name of the exposition                                                                                                                                                     | `Exposition 2023`              |
| `exposition.description` | Description of the exposition                                                                                                                                              | `Expo 2023`                    |
| `exposition.logo`        | Logo of the exposition (url)                                                                                                                                               | `https://example.com/logo.png` |
| `debug`                  | Debug mode (use a string to enable - e.g. "*" for all)                                                                                                                     | `""`                           |


### Web parameters

| Name                                     | Description                                               | Value               |
| ---------------------------------------- | --------------------------------------------------------- | ------------------- |
| `web.replicaCount`                       | Number of web replicas to deploy                          | `1`                 |
| `web.image.registry`                     | Pod image registry                                        | `ghcr.io`           |
| `web.image.repository`                   | Pod image repository                                      | `befritco/expo-web` |
| `web.image.tag`                          | Pod image tag (defaults to appVersion)                    | `""`                |
| `web.image.pullPolicy`                   | Pod image pull policy                                     | `IfNotPresent`      |
| `web.image.digest`                       | Pod image digest (overrides tag)                          | `""`                |
| `web.image.pullSecrets`                  | Pod image pull secrets                                    | `[]`                |
| `web.service.type`                       | web service type                                          | `ClusterIP`         |
| `web.service.port`                       | web service port                                          | `80`                |
| `web.service.annotations`                | web service annotations                                   | `{}`                |
| `web.resources.limits`                   | The resources limits for the container                    | `{}`                |
| `web.resources.requests`                 | The requested resources for the container                 | `{}`                |
| `web.livenessProbe.enabled`              | Enable livenessProbe                                      | `true`              |
| `web.livenessProbe.failureThreshold`     | Failure threshold for livenessProbe                       | `3`                 |
| `web.livenessProbe.initialDelaySeconds`  | Initial delay seconds for livenessProbe                   | `10`                |
| `web.livenessProbe.periodSeconds`        | Period seconds for livenessProbe                          | `10`                |
| `web.livenessProbe.successThreshold`     | Success threshold for livenessProbe                       | `1`                 |
| `web.livenessProbe.timeoutSeconds`       | Timeout seconds for livenessProbe                         | `5`                 |
| `web.readinessProbe.enabled`             | Enable readinessProbe                                     | `true`              |
| `web.readinessProbe.initialDelaySeconds` | Initial delay seconds for readinessProbe                  | `10`                |
| `web.readinessProbe.periodSeconds`       | Period seconds for readinessProbe                         | `10`                |
| `web.readinessProbe.timeoutSeconds`      | Timeout seconds for readinessProbe                        | `5`                 |
| `web.readinessProbe.failureThreshold`    | Failure threshold for readinessProbe                      | `1`                 |
| `web.readinessProbe.successThreshold`    | Success threshold for readinessProbe                      | `1`                 |
| `web.startupProbe.enabled`               | Enable startupProbe                                       | `false`             |
| `web.startupProbe.initialDelaySeconds`   | Initial delay seconds for startupProbe                    | `10`                |
| `web.startupProbe.periodSeconds`         | Period seconds for startupProbe                           | `10`                |
| `web.startupProbe.timeoutSeconds`        | Timeout seconds for startupProbe                          | `5`                 |
| `web.startupProbe.failureThreshold`      | Failure threshold for startupProbe                        | `30`                |
| `web.startupProbe.successThreshold`      | Success threshold for startupProbe                        | `1`                 |
| `web.podLabels`                          | Add extra labels to pod                                   | `{}`                |
| `web.podAnnotations`                     | Add extra annotations to the pod                          | `{}`                |
| `web.nodeSelector`                       | Node labels selector for pod assignment                   | `{}`                |
| `web.initContainers`                     | Add additional init containers to the pod                 | `[]`                |
| `web.priorityClassName`                  | Pods' priorityClassName                                   | `""`                |
| `web.terminationGracePeriodSeconds`      | In seconds, time given to the pod to terminate gracefully | `2`                 |
| `web.affinity`                           | Affinity for front pod assignment                         | `{}`                |
| `web.tolerations`                        | Tolerations for pod assignment                            | `[]`                |
| `web.topologySpreadConstraints`          | Topology Spread Constraints for pod assignment            | `[]`                |
| `web.updateStrategy.type`                | Strategy to use to update Pods                            | `RollingUpdate`     |


### API parameters

| Name                                     | Description                                                                           | Value                       |
| ---------------------------------------- | ------------------------------------------------------------------------------------- | --------------------------- |
| `api.replicaCount`                       | Number of API replicas to deploy                                                      | `1`                         |
| `api.image.repository`                   | Pod image repository                                                                  | `ghcr.io/befritco/expo-api` |
| `api.image.tag`                          | Pod image tag (defaults to appVersion)                                                | `""`                        |
| `api.image.pullPolicy`                   | Pod image pull policy                                                                 | `IfNotPresent`              |
| `api.image.pullSecrets`                  | Pod image pull secrets                                                                | `[]`                        |
| `api.service.type`                       | api service type                                                                      | `ClusterIP`                 |
| `api.service.port`                       | api service port                                                                      | `9000`                      |
| `api.service.annotations`                | api service annotations                                                               | `{}`                        |
| `api.resources.limits`                   | The resources limits for the container                                                | `{}`                        |
| `api.resources.requests`                 | The requested resources for the container                                             | `{}`                        |
| `api.livenessProbe.enabled`              | Enable livenessProbe                                                                  | `true`                      |
| `api.livenessProbe.failureThreshold`     | Failure threshold for livenessProbe                                                   | `3`                         |
| `api.livenessProbe.initialDelaySeconds`  | Initial delay seconds for livenessProbe                                               | `10`                        |
| `api.livenessProbe.periodSeconds`        | Period seconds for livenessProbe                                                      | `10`                        |
| `api.livenessProbe.successThreshold`     | Success threshold for livenessProbe                                                   | `1`                         |
| `api.livenessProbe.timeoutSeconds`       | Timeout seconds for livenessProbe                                                     | `5`                         |
| `api.readinessProbe.enabled`             | Enable readinessProbe                                                                 | `true`                      |
| `api.readinessProbe.initialDelaySeconds` | Initial delay seconds for readinessProbe                                              | `10`                        |
| `api.readinessProbe.periodSeconds`       | Period seconds for readinessProbe                                                     | `10`                        |
| `api.readinessProbe.timeoutSeconds`      | Timeout seconds for readinessProbe                                                    | `5`                         |
| `api.readinessProbe.failureThreshold`    | Failure threshold for readinessProbe                                                  | `1`                         |
| `api.readinessProbe.successThreshold`    | Success threshold for readinessProbe                                                  | `1`                         |
| `api.startupProbe.enabled`               | Enable startupProbe                                                                   | `false`                     |
| `api.startupProbe.initialDelaySeconds`   | Initial delay seconds for startupProbe                                                | `10`                        |
| `api.startupProbe.periodSeconds`         | Period seconds for startupProbe                                                       | `10`                        |
| `api.startupProbe.timeoutSeconds`        | Timeout seconds for startupProbe                                                      | `5`                         |
| `api.startupProbe.failureThreshold`      | Failure threshold for startupProbe                                                    | `30`                        |
| `api.startupProbe.successThreshold`      | Success threshold for startupProbe                                                    | `1`                         |
| `api.podLabels`                          | Add extra labels to pod                                                               | `{}`                        |
| `api.podAnnotations`                     | Add extra annotations to the pod                                                      | `{}`                        |
| `api.nodeSelector`                       | Node labels selector for pod assignment                                               | `{}`                        |
| `api.initContainers`                     | Add additional init containers to the pod                                             | `[]`                        |
| `api.priorityClassName`                  | Pods' priorityClassName                                                               | `""`                        |
| `api.terminationGracePeriodSeconds`      | In seconds, time given to the pod to terminate gracefully                             | `2`                         |
| `api.affinity`                           | Affinity for front pod assignment                                                     | `{}`                        |
| `api.tolerations`                        | Tolerations for pod assignment                                                        | `[]`                        |
| `api.topologySpreadConstraints`          | Topology Spread Constraints for pod assignment                                        | `[]`                        |
| `api.updateStrategy.type`                | Strategy to use to update Pods                                                        | `RollingUpdate`             |
| `api.extraEnvVars`                       | Extra environment variable to pass to the running container                           | `[]`                        |
| `api.extraEnvVarsCM`                     | Name of existing ConfigMap containing extra environment variables to mount in the pod | `""`                        |
| `api.extraEnvVarsSecret`                 | Name of existing Secret containing extra environment variables to mount in the pod    | `""`                        |
| `api.extraVolumeMounts`                  | Optionally specify extra list of additional volumeMounts for the pod                  | `[]`                        |
| `api.extraVolumes`                       | Optionally specify extra list of additional volumes for the pod(s)                    | `[]`                        |
| `api.persistence.enabled`                | Enable persistence using PVC                                                          | `true`                      |
| `api.persistence.size`                   | Pod pvc size                                                                          | `10Gi`                      |
| `api.persistence.storageClass`           | Pod pvc storage class                                                                 | `""`                        |
| `api.persistence.accessModes`            | Pod pvc access modes                                                                  | `["ReadWriteOnce"]`         |
| `api.persistence.annotations`            | Pod pvc annotations                                                                   | `{}`                        |
| `api.persistence.labels`                 | Pod pvc labels                                                                        | `{}`                        |
| `api.persistence.selector`               | Additional labels to match for the PVC                                                | `{}`                        |
| `api.persistence.dataSource`             | Custom PVC data source                                                                | `{}`                        |
| `api.persistence.existingClaim`          | Use a existing PVC which must be created manually before bound                        | `""`                        |


### Ingress parameters

| Name                       | Description                                                                                                                      | Value                    |
| -------------------------- | -------------------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| `ingress.enabled`          | Enable ingress controller resource                                                                                               | `true`                   |
| `ingress.ingressClassName` | IngressClass that will be be used to implement the Ingress (Kubernetes 1.18+)                                                    | `""`                     |
| `ingress.pathType`         | Ingress path type                                                                                                                | `ImplementationSpecific` |
| `ingress.apiVersion`       | Force Ingress API version (automatically detected if not set)                                                                    | `""`                     |
| `ingress.annotations`      | Additional annotations for the Ingress resource. To enable certificate autogeneration, place here your cert-manager annotations. | `{}`                     |
| `ingress.hosts`            | Ingress hostnames                                                                                                                | `[]`                     |
| `ingress.tls`              | Ingress TLS configuration                                                                                                        | `[]`                     |


### RethinkDB parameters

| Name                                          | Description                                                  | Value       |
| --------------------------------------------- | ------------------------------------------------------------ | ----------- |
| `rethinkdb.enabled`                           | Enable RethinkDB                                             | `true`      |
| `rethinkdb.cluster.rethinkCacheSize`          | RethinkDB Cache Size in MB                                   | `512`       |
| `rethinkdb.cluster.storage`                   | RethinkDB Storage Size                                       | `40Gi`      |
| `rethinkdb.cluster.replicas`                  | RethinkDB Replicas                                           | `3`         |
| `rethinkdb.cluster.resources.limits.cpu`      | RethinkDB CPU Limit                                          | `500m`      |
| `rethinkdb.cluster.resources.limits.memory`   | RethinkDB Memory Limit                                       | `2048Mi`    |
| `rethinkdb.cluster.resources.requests.cpu`    | RethinkDB CPU Request                                        | `300m`      |
| `rethinkdb.cluster.resources.requests.memory` | RethinkDB Memory Request                                     | `2048Mi`    |
| `rethinkdb.proxy.replicas`                    | RethinkDB Proxy Replicas                                     | `1`         |
| `rethinkdb.proxy.resources.limits.cpu`        | RethinkDB Proxy CPU Limit                                    | `100m`      |
| `rethinkdb.proxy.resources.limits.memory`     | RethinkDB Proxy Memory Limit                                 | `1024Mi`    |
| `rethinkdb.proxy.resources.requests.cpu`      | RethinkDB Proxy CPU Request                                  | `100m`      |
| `rethinkdb.proxy.resources.requests.memory`   | RethinkDB Proxy Memory Request                               | `1024Mi`    |
| `rethinkdb.rethinkdbPassword`                 | RethinkDB Admin Password - ignored if using `existingSecret` | `rethinkdb` |
| `rethinkdb.existingSecret`                    | Use existing secret for rethinkDB password and certificates  | `""`        |


