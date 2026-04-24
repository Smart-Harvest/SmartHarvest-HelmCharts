{{- define "user-service.name" -}}
user-service
{{- end }}

{{- define "user-service.fullname" -}}
{{ .Release.Name }}-user-service
{{- end }}

{{- define "user-service.selectorLabels" -}}
app.kubernetes.io/name: {{ include "user-service.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "user-service.labels" -}}
helm.sh/chart: user-service-{{ .Chart.Version }}
{{ include "user-service.selectorLabels" . }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}
