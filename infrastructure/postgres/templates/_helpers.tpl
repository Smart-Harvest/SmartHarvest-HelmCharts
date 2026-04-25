{{/*
───────────────────────────────────────────────────────────────
  postgres — Template Helpers
───────────────────────────────────────────────────────────────
*/}}

{{- define "postgres.name" -}}
postgres
{{- end }}

{{- define "postgres.fullname" -}}
{{ .Release.Name }}-postgres
{{- end }}

{{- define "postgres.selectorLabels" -}}
app.kubernetes.io/name: {{ include "postgres.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/component: database
{{- end }}

{{- define "postgres.labels" -}}
helm.sh/chart: postgres-{{ .Chart.Version }}
{{ include "postgres.selectorLabels" . }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/part-of: smartharvest
{{- end }}
