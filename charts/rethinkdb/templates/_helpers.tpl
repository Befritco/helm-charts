{{/* vim: set filetype=mustache: */}}

{{/*
The following four helpers (rethinkdb.name, rethinkdb.fullname, rethinkdb.chart,
rethinkdb.secretName) are carried over verbatim from the fastlorenzo/rethinkdb-helm-chart
1.2.4 fork this chart replaces, so that the release naming and secret lookup (and therefore
`existingSecret` references from existing installs, e.g. batibouw-2025) keep working unchanged.
*/}}

{{/*
Expand the name of the chart.
*/}}
{{- define "rethinkdb.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "rethinkdb.fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "rethinkdb.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Get the RethinkDB secret name.
*/}}
{{- define "rethinkdb.secretName" -}}
{{- if .Values.existingSecret }}
    {{- printf "%s" (tpl .Values.existingSecret $) -}}
{{- else -}}
    {{- printf "%s-secret" (include "rethinkdb.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Common labels.
*/}}
{{- define "rethinkdb.labels" -}}
helm.sh/chart: {{ include "rethinkdb.chart" . }}
{{ include "rethinkdb.selectorLabels" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
{{- end -}}

{{/*
Selector labels. Kept to name+instance only (no chart version) so upgrades never change the
StatefulSet's immutable selector.
*/}}
{{- define "rethinkdb.selectorLabels" -}}
app.kubernetes.io/name: {{ include "rethinkdb.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Effective image reference (registry/repository:tag or registry/repository@digest),
honouring global.imageRegistry.
*/}}
{{- define "rethinkdb.image" -}}
{{- $registry := .Values.image.registry -}}
{{- if .Values.global.imageRegistry -}}
{{- $registry = .Values.global.imageRegistry -}}
{{- end -}}
{{- if .Values.image.digest -}}
{{- printf "%s/%s@%s" $registry .Values.image.repository .Values.image.digest -}}
{{- else -}}
{{- printf "%s/%s:%s" $registry .Values.image.repository .Values.image.tag -}}
{{- end -}}
{{- end -}}

{{/*
Merged image pull secrets (global + chart-local), rendered as a full imagePullSecrets list
including the key, or nothing when empty.
*/}}
{{- define "rethinkdb.imagePullSecrets" -}}
{{- $pullSecrets := list -}}
{{- range .Values.global.imagePullSecrets -}}
{{- $pullSecrets = append $pullSecrets . -}}
{{- end -}}
{{- range .Values.image.pullSecrets -}}
{{- $pullSecrets = append $pullSecrets . -}}
{{- end -}}
{{- if $pullSecrets }}
imagePullSecrets:
{{- range $pullSecrets }}
  - name: {{ . }}
{{- end }}
{{- end -}}
{{- end -}}

{{/*
RethinkDB admin password used when the chart manages the Secret (existingSecret unset).
Prefers the configured value; otherwise reuses whatever is already stored for this release so
`helm template`/`helm upgrade` do not roll the password on every render, and only falls back to a
fresh random value on first install.
*/}}
{{- define "rethinkdb.password" -}}
{{- if .Values.rethinkdbPassword -}}
{{- .Values.rethinkdbPassword -}}
{{- else -}}
{{- $secret := (lookup "v1" "Secret" .Release.Namespace (include "rethinkdb.secretName" .)) -}}
{{- if $secret -}}
{{- index $secret.data "rethinkdb-password" | b64dec -}}
{{- else -}}
{{- randAlphaNum 20 -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Effective storageClassName for the data PVC: persistence.storageClass wins, then
global.storageClass, then the cluster default (key omitted). "-" means no storage class.
*/}}
{{- define "rethinkdb.storageClass" -}}
{{- $sc := .Values.persistence.storageClass | default .Values.global.storageClass -}}
{{- if $sc -}}
{{- if eq $sc "-" -}}
storageClassName: ""
{{- else -}}
storageClassName: {{ $sc | quote }}
{{- end -}}
{{- end -}}
{{- end -}}
