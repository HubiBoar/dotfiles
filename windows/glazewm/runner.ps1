Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass

$WorkingDir = Convert-Path .
$Config = "$WorkingDir\config.yaml"

echo $Config

[Environment]::SetEnvironmentVariable("GLAZEWM_CONFIG_PATH", $Config, "User")

$env:GLAZEWM_CONFIG_PATH = $Config

winget install GlazeWM --accept-package-agreements   --accept-source-agreements
