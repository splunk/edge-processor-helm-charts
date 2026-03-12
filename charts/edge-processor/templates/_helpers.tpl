{{/*
Expand the name of the chart.
*/}}
{{- define "edge-processor.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "edge-processor.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "edge-processor.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "edge-processor.labels" -}}
helm.sh/chart: {{ include "edge-processor.chart" . }}
{{ include "edge-processor.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "edge-processor.selectorLabels" -}}
app.kubernetes.io/name: {{ include "edge-processor.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "edge-processor.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "edge-processor.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create the name of the secret storing principal and secret key info 
*/}}
{{- define "edge-processor.secretName" -}}
{{- if .Values.auth.create }}
{{- default (include "edge-processor.fullname" .) .Values.auth.servicePrincipal.principalSecretName }}
{{- else }}
{{- default "default" .Values.auth.servicePrincipal.principalSecretName }}
{{- end }}
{{- end }}

{{/*
Determine storage class based on cloud provider
*/}}
{{- define "edge-processor.storageClass" -}}
{{- if .Values.persistence.storageClass -}}
{{- .Values.persistence.storageClass -}}
{{- else if .Values.cloudProvider.aws.enabled -}}
{{- .Values.cloudProvider.aws.storageClass -}}
{{- else if .Values.cloudProvider.gcp.enabled -}}
{{- .Values.cloudProvider.gcp.storageClass -}}
{{- else if .Values.cloudProvider.azure.enabled -}}
{{- .Values.cloudProvider.azure.storageClass -}}
{{- else -}}
{{- "" -}}
{{- end -}}
{{- end -}}
