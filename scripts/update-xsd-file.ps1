# Update XSD from latest NLog.Schema package

$start_time = Get-Date

# Download latest package as zip for Expand-Archive
$url = "https://www.nuget.org/api/v2/package/NLog.Schema/"
$output = "$env:TEMP\NLog.Schema.zip" 
Invoke-WebRequest -Uri $url -OutFile $output

# Unzip
$output2 = "$env:TEMP\NLog.Schema\"
Expand-Archive $output -DestinationPath $output2 -force

# Copy file
copy-item "$output2\content\NLog.xsd" "..\schemas\NLog.xsd"

Write-Host "Done. Time taken: $((Get-Date).Subtract($start_time).Seconds) second(s)"   -ForegroundColor Green
