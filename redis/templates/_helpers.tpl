{{- define "redis.name" -}}
redis
{{- end }}

{{- define "redis.fullname" -}}
{{ .Release.Name }}-redis
{{- end }}

{{- define "redis.selectorLabels" -}}
app.kubernetes.io/name: {{ include "redis.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "redis.labels" -}}
helm.sh/chart: redis-{{ .Chart.Version }}
{{ include "redis.selectorLabels" . }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}
