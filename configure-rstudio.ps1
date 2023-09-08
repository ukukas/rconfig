#Requires -RunAsAdministrator

$registryKey = "HKLM:\SOFTWARE\R-core\R"
$installPath = (Get-ItemProperty $registryKey -Name "InstallPath").InstallPath
$exePath = (Join-Path $installPath "bin\x64\Rterm.exe").Replace("\", "\\")

$configContent = @"
{
    "platform": {
		"windows": {
			"rBinDir": "",
			"preferR64": true,
			"rExecutablePath": "$exePath"
		}
	}
}
"@

Get-ChildItem (Join-Path $env:SystemDrive "Users") -Force -Directory `
-Exclude "All Users","Default User","Public" | ForEach-Object {
    $configDir = Join-Path $_.FullName "AppData\Roaming\RStudio"
    New-Item -ItemType Directory -Force -Path $configDir
    $configFile = Join-Path $configDir "config.json"
    New-Item -ItemType File -Force -Path $configFile -Value $configContent
}
