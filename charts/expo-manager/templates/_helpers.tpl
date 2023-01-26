{{/*
Expand the name of the chart.
*/}}
{{- define "expo-manager.name" -}}
{{- include "common.names.name" . -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "expo-manager.fullname" -}}
{{- include "common.names.fullname" . -}}
{{- end -}}


{{/* Returns api internal service name. */}}
{{- define "expo-manager.api.serviceName" -}}
{{- printf "%s-api" (include "expo-manager.fullname" .) -}}
{{- end -}}
{{/* Returns api internal headless service name. */}}
{{- define "expo-manager.api.serviceNameHeadless" -}}
{{- printf "%s-headless" (include "expo-manager.api.serviceName" .) -}}
{{- end -}}

{{/* Returns web internal service name. */}}
{{- define "expo-manager.web.serviceName" -}}
{{- printf "%s-web" (include "expo-manager.fullname" .) -}}
{{- end -}}


{{/*
Create the name of the service account to use
*/}}
{{- define "expo-manager.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "expo-manager.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Return the proper image pull secret names
*/}}
{{- define "expo-manager.imagePullSecrets" -}}
{{- include "common.images.pullSecrets" (dict "images" (list .Values.api.image .Values.web.image) "global" .Values.global) -}}
{{- end -}}

{{/*
Return the proper image for web
*/}}
{{- define "expo-manager.web.image" -}}
{{- include "common.images.image" (dict "imageRoot" .Values.web.image "global" .Values.global) -}}
{{- end -}}

{{/*
Return the proper image for api
*/}}
{{- define "expo-manager.api.image" -}}
{{- include "common.images.image" (dict "imageRoot" .Values.api.image "global" .Values.global) -}}
{{- end -}}


{{/* Get the secret name. */}}
{{- define "expo-manager.secretName" -}}
{{- include "common.secrets.name" (dict "existingSecret" .Values.existingSecret "defaultNameSuffix" "secret" "context" .) }}
{{- end -}}

{{/* Returns the jwtSecret secret key */}}
{{- define "expo-manager.jwtSecret.secretKey" -}}
{{- print "jwt-secret" -}}
{{- end -}}

{{/* Returns the initial user secret key */}}
{{- define "expo-manager.initialUser.secretKey" -}}
{{- print "initial-user-password" -}}
{{- end -}}

{{/* Returns the email smtp password secret key */}}
{{- define "expo-manager.emailSenderPassword.secretKey" -}}
{{- print "email-sender-password" -}}
{{- end -}}

{{/* Returns the jwtSecret value */}}
{{- define "expo-manager.jwtSecret.value" -}}
{{- include "common.secrets.passwords.manage" (dict "secret" (include "expo-manager.secretName" .) "key" (include "expo-manager.jwtSecret.secretKey" .) "providedValues" (list "jwtSecret") "length" 32 "strong" true "context" .) }}
{{- end -}}

{{/* Returns the initial user password */}}
{{- define "expo-manager.initialUser.password" -}}
{{- include "common.secrets.passwords.manage" (dict "secret" (include "expo-manager.secretName" .) "key" (include "expo-manager.initialUser.secretKey" .) "providedValues" (list "initialUserPassword") "length" 12 "strong" true "context" .) }}
{{- end -}}

{{/* Returns the email sender password */}}
{{- define "expo-manager.emailSenderPassword.password" -}}
{{- include "common.secrets.passwords.manage" (dict "secret" (include "expo-manager.secretName" .) "key" (include "expo-manager.emailSenderPassword.secretKey" .) "providedValues" (list "email.senderPassword") "length" 24 "strong" true "context" .) }}
{{- end -}}
