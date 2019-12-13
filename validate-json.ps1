npm install @prantlf/jsonlint -g

Write-Output "Validate targets.json ..."
jsonlint config/targets.json --quiet --no-duplicate-keys --validate config/targets.schema.json --environment json-schema-draft-07 2>&1
if (-Not $LastExitCode -eq 0)
	{ exit $LastExitCode }

Write-Output "Validate layouts.json ..."
jsonlint config/layouts.json -q  2>&1
if (-Not $LastExitCode -eq 0)
	{ exit $LastExitCode }

Write-Output "Validate layout-renderers.json ..."
jsonlint config/layout-renderers.json -q  2>&1
if (-Not $LastExitCode -eq 0)
	{ exit $LastExitCode }

Write-Output "JSON Validation done"