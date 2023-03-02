{{/* vim: set filetype=mustache: */}}

{{/*
Return true if an existing secret object should be used
*/}}
{{- define "neverland.existingSecret" -}}
{{- if (.Values.keycloak.auth.existingSecret) -}}
    {{- true -}}
{{- end -}}
{{- end -}}
