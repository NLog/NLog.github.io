npm install jsonlint -g

Write-Host "Validate targets.json ..."
jsonlint config/targets.json -q  2>&1

Write-Host "Validate layouts.json ..."
jsonlint config/layouts.json -q  2>&1

Write-Host "Validate layout-renderers.json ..."
jsonlint config/layout-renderers.json -q  2>&1

Write-Host "JSON Validation done"