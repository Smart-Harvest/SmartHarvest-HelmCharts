{{- define "marketplace-service.name" -}}
marketplace-service
{{- end }}

{{- define "marketplace-service.fullname" -}}
{{ .Release.Name }}-marketplace-service
{{- end }}

{{- define "marketplace-service.selectorLabels" -}}
app.kubernetes.io/name: {{ include "marketplace-service.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "marketplace-service.labels" -}}
helm.sh/chart: marketplace-service-{{ .Chart.Version }}
{{ include "marketplace-service.selectorLabels" . }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}
