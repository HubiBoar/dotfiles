$WorkingDir = Convert-Path .
$Config = "$WorkingDir\config.yaml"

echo $Config

winget install GlazeWM --accept-package-agreements   --accept-source-agreements

setx GLAZEWM_CONFIG_PATH $Config
