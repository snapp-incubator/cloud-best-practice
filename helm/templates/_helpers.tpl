{{/*
Expand the name of the chart.
*/}}
{{- define "tmpl.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "tmpl.fullname" -}}
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
{{- define "tmpl.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}


{{/*
Create the name of the service account to use
*/}}
{{- define "tmpl.serviceAccountName" -}}
{{- default (include "tmpl.fullname" .) .Values.serviceAccountName }}
{{- end }}



{{- define "tmpl.image" -}}
{{- if .Values.image.digest -}}
image-registry.openshift-image-registry.svc:5000/{{ .Release.Namespace }}/{{ .Chart.Name }}-fpm:{{ .Values.image.digest }}
{{- else -}}
image-registry.openshift-image-registry.svc:5000/{{ .Release.Namespace }}/{{ .Chart.Name }}-fpm:{{ .Values.image.tag }}
{{- end -}}
{{- end -}}










{{/*
Common labels
*/}}
{{- define "tmpl.labels" -}}
helm.sh/chart: {{ include "tmpl.chart" .context }}
{{ include "tmpl.selectorLabels" (dict "context" .context "component" .component "name" .name) }}
app.kubernetes.io/part-of: {{ .context.Chart.Name }}
{{- if .context.Chart.AppVersion }}
app.kubernetes.io/version: {{ .context.Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .context.Release.Service }}
{{- end }}



{{/*
Selector labels
*/}}
{{- define "tmpl.selectorLabels" -}}
{{- if .name -}}
app.kubernetes.io/name: {{ include "tmpl.name" .context }}-{{ .name }}
{{ end -}}
app.kubernetes.io/instance: {{ .context.Release.Name }}
{{- if .component }}
app.kubernetes.io/component: {{ .component }}
{{- end }}
{{- end }}
