{{/*
───────────────────────────────────────────────────────────────
  gateway — Template Helpers
───────────────────────────────────────────────────────────────
*/}}

{{- define "gateway.name" -}}
gateway
{{- end }}

{{- define "gateway.labels" -}}
helm.sh/chart: gateway-{{ .Chart.Version }}
app.kubernetes.io/name: {{ include "gateway.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/part-of: smartharvest
{{- end }}
