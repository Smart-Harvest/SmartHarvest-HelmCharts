{{- define "crop-advisory-service.name" -}}
crop-advisory-service
{{- end }}

{{- define "crop-advisory-service.fullname" -}}
{{ .Release.Name }}-crop-advisory-service
{{- end }}

{{- define "crop-advisory-service.selectorLabels" -}}
app.kubernetes.io/name: {{ include "crop-advisory-service.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "crop-advisory-service.labels" -}}
helm.sh/chart: crop-advisory-service-{{ .Chart.Version }}
{{ include "crop-advisory-service.selectorLabels" . }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}
