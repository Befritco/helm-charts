{{/* vim: set filetype=mustache: */}}

{{/*
Expand the name of the chart.
*/}}
{{- define "expo-manager.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "expo-manager.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "expo-manager.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Selector labels. Kept to name+instance only (never the chart version) so an upgrade never tries
to change a Deployment's immutable selector. Templates append app.kubernetes.io/component.
*/}}
{{- define "expo-manager.selectorLabels" -}}
app.kubernetes.io/name: {{ include "expo-manager.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Standard labels (plus commonLabels, tpl-rendered).
*/}}
{{- define "expo-manager.labels" -}}
helm.sh/chart: {{ include "expo-manager.chart" . }}
{{ include "expo-manager.selectorLabels" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- with .Values.commonLabels }}
{{ tpl (toYaml .) $ }}
{{- end }}
{{- end -}}

{{/*
Common annotations block (key included), or nothing when empty.
*/}}
{{- define "expo-manager.annotations" -}}
{{- with .Values.commonAnnotations -}}
annotations:
  {{- tpl (toYaml .) $ | nindent 2 }}
{{- end }}
{{- end -}}

{{/*
Effective image reference for one component.
Usage: {{ include "expo-manager.image" (dict "image" .Values.api.image "global" .Values.global "chart" .Chart) }}
registry/repository:tag or registry/repository@digest; global.imageRegistry overrides the
registry; the tag defaults to the chart's appVersion; an empty registry yields repository:tag so a
fully qualified repository still renders.
*/}}
{{- define "expo-manager.image" -}}
{{- $registry := .image.registry | default "" -}}
{{- if .global.imageRegistry -}}
{{- $registry = .global.imageRegistry -}}
{{- end -}}
{{- $repository := .image.repository -}}
{{- if $registry -}}
{{- $repository = printf "%s/%s" $registry .image.repository -}}
{{- end -}}
{{- if .image.digest -}}
{{- printf "%s@%s" $repository .image.digest -}}
{{- else -}}
{{- printf "%s:%s" $repository (.image.tag | default .chart.AppVersion | toString) -}}
{{- end -}}
{{- end -}}

{{/*
Merged image pull secrets (global.imagePullSecrets + api.image.pullSecrets + web.image.pullSecrets),
rendered as a full imagePullSecrets list including the key, or nothing when empty.
*/}}
{{- define "expo-manager.imagePullSecrets" -}}
{{- $pullSecrets := list -}}
{{- range .Values.global.imagePullSecrets -}}
{{- $pullSecrets = append $pullSecrets . -}}
{{- end -}}
{{- range .Values.api.image.pullSecrets -}}
{{- $pullSecrets = append $pullSecrets . -}}
{{- end -}}
{{- range .Values.web.image.pullSecrets -}}
{{- $pullSecrets = append $pullSecrets . -}}
{{- end -}}
{{- $pullSecrets = $pullSecrets | uniq -}}
{{- if $pullSecrets -}}
imagePullSecrets:
{{- range $pullSecrets }}
  - name: {{ . }}
{{- end }}
{{- end -}}
{{- end -}}

{{/*
Service names. These are part of the chart's contract: external HTTPRoutes/Ingresses reference
<fullname>-api:9000 and <fullname>-web:80.
*/}}
{{- define "expo-manager.api.serviceName" -}}
{{- printf "%s-api" (include "expo-manager.fullname" .) -}}
{{- end -}}

{{- define "expo-manager.web.serviceName" -}}
{{- printf "%s-web" (include "expo-manager.fullname" .) -}}
{{- end -}}

{{/*
Name of the API ConfigMap (every non-secret environment variable).
*/}}
{{- define "expo-manager.configMapName" -}}
{{- printf "%s-api" (include "expo-manager.fullname" .) -}}
{{- end -}}

{{/*
Name of the Secret holding jwt-secret / initial-user-password / email-sender-password
(and rethinkdb-password when the RethinkDB subchart is disabled).
*/}}
{{- define "expo-manager.secretName" -}}
{{- if .Values.existingSecret -}}
{{- tpl .Values.existingSecret . -}}
{{- else -}}
{{- printf "%s-secret" (include "expo-manager.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Name of the service account to use.
*/}}
{{- define "expo-manager.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
{{- default (include "expo-manager.fullname" .) .Values.serviceAccount.name -}}
{{- else -}}
{{- default "default" .Values.serviceAccount.name -}}
{{- end -}}
{{- end -}}

{{/*
Fullname of the rethinkdb subchart as the subchart itself computes it (release name + chart name
or its nameOverride) -- NOT derived from this chart's fullname. The 1.x chart resolved the
subchart's secret against the parent's fullname, which is the bug this helper fixes.
*/}}
{{- define "expo-manager.rethinkdb.fullname" -}}
{{- $name := default "rethinkdb" .Values.rethinkdb.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
RETHINKDB_SERVER: the subchart's ClusterIP driver Service, or rethinkdb.externalHost.
*/}}
{{- define "expo-manager.rethinkdb.host" -}}
{{- if .Values.rethinkdb.enabled -}}
{{- include "expo-manager.rethinkdb.fullname" . -}}
{{- else if .Values.rethinkdb.externalHost -}}
{{- tpl .Values.rethinkdb.externalHost . -}}
{{- else -}}
{{- fail "expo-manager: rethinkdb.enabled is false but rethinkdb.externalHost is empty. Set rethinkdb.externalHost to the hostname of your external RethinkDB (driver port 28015), or set rethinkdb.enabled=true to deploy the bundled one." -}}
{{- end -}}
{{- end -}}

{{/*
Secret the API reads RETHINKDB_PASSWORD from (key rethinkdb-password). Always the same Secret the
database itself uses:
  1. rethinkdb.existingSecret when set (the subchart reads it too);
  2. else, with the subchart enabled, the subchart's own generated Secret (<release>-rethinkdb-secret);
  3. else (external RethinkDB) this chart's Secret (existingSecret or the chart-managed one).
*/}}
{{- define "expo-manager.rethinkdb.secretName" -}}
{{- if .Values.rethinkdb.existingSecret -}}
{{- tpl .Values.rethinkdb.existingSecret . -}}
{{- else if .Values.rethinkdb.enabled -}}
{{- printf "%s-secret" (include "expo-manager.rethinkdb.fullname" .) -}}
{{- else -}}
{{- include "expo-manager.secretName" . -}}
{{- end -}}
{{- end -}}

{{/*
Value for one key of the chart-managed Secret. Uses the provided value when set; otherwise reuses
what is already stored in the cluster for this release (so `helm upgrade` never rotates a
generated secret) and only falls back to a fresh random value on first install.
Usage: {{ include "expo-manager.secretValue" (dict "context" $ "key" "jwt-secret" "value" .Values.jwtSecret "length" 48) }}
*/}}
{{- define "expo-manager.secretValue" -}}
{{- if .value -}}
{{- .value -}}
{{- else -}}
{{- $existing := lookup "v1" "Secret" .context.Release.Namespace (include "expo-manager.secretName" .context) -}}
{{- if and $existing $existing.data (hasKey $existing.data .key) -}}
{{- index $existing.data .key | b64dec -}}
{{- else -}}
{{- randAlphaNum (int .length) -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Renders a probe block (httpGet on the named "http" port) from a values map with an `enabled`
key plus the standard timing fields.
Usage: {{ include "expo-manager.httpProbe" (dict "probe" .Values.api.livenessProbe "path" .Values.api.healthPath) }}
*/}}
{{- define "expo-manager.httpProbe" -}}
httpGet:
  path: {{ .path }}
  port: http
initialDelaySeconds: {{ .probe.initialDelaySeconds }}
periodSeconds: {{ .probe.periodSeconds }}
timeoutSeconds: {{ .probe.timeoutSeconds }}
failureThreshold: {{ .probe.failureThreshold }}
successThreshold: {{ .probe.successThreshold }}
{{- end -}}

{{/*
Effective storageClassName line for an API PVC: <pvc>.storageClass wins, then global.storageClass,
then the cluster default (key omitted). "-" means no storage class (storageClassName: "").
Usage: {{ include "expo-manager.storageClass" (dict "persistence" .Values.api.persistence.photos "global" .Values.global) }}
*/}}
{{- define "expo-manager.storageClass" -}}
{{- $sc := .persistence.storageClass | default .global.storageClass -}}
{{- if $sc -}}
{{- if eq $sc "-" -}}
storageClassName: ""
{{- else -}}
storageClassName: {{ $sc | quote }}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Name of an API PVC ("photos" or "reports"): the existingClaim when set, else <fullname>-api-<name>.
Usage: {{ include "expo-manager.api.claimName" (dict "name" "photos" "persistence" .Values.api.persistence.photos "context" $) }}
*/}}
{{- define "expo-manager.api.claimName" -}}
{{- if .persistence.existingClaim -}}
{{- tpl .persistence.existingClaim .context -}}
{{- else -}}
{{- printf "%s-api-%s" (include "expo-manager.fullname" .context) .name -}}
{{- end -}}
{{- end -}}
