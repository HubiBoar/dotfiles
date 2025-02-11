$WorkingDir = Convert-Path .
$Config = "$WorkingDir\config.yaml"
echo $Config
setx GLAZEWM_CONFIG_PATH $Config
