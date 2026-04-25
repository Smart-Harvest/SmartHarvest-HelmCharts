{{/*
───────────────────────────────────────────────────────────────
  redis — Template Helpers
───────────────────────────────────────────────────────────────
*/}}

{{- define "redis.name" -}}
redis
{{- end }}

{{- define "redis.fullname" -}}
{{ .Release.Name }}-redis
{{- end }}

{{- define "redis.selectorLabels" -}}
app.kubernetes.io/name: {{ include "redis.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/component: cache
{{- end }}

{{- define "redis.labels" -}}
helm.sh/chart: redis-{{ .Chart.Version }}
{{ include "redis.selectorLabels" . }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/part-of: smartharvest
{{- end }}
