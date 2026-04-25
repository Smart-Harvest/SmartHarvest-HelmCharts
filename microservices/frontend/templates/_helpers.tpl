{{/*
───────────────────────────────────────────────────────────────
  frontend — Template Helpers
───────────────────────────────────────────────────────────────
*/}}

{{- define "frontend.name" -}}
frontend
{{- end }}

{{- define "frontend.fullname" -}}
{{ .Release.Name }}-frontend
{{- end }}

{{- define "frontend.selectorLabels" -}}
app.kubernetes.io/name: {{ include "frontend.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/component: frontend
{{- end }}

{{- define "frontend.labels" -}}
helm.sh/chart: frontend-{{ .Chart.Version }}
{{ include "frontend.selectorLabels" . }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/part-of: smartharvest
{{- end }}
