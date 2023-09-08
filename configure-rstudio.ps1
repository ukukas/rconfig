$registryKey = "HKLM:\SOFTWARE\R-core\R"
$installPath = (Get-ItemProperty $registryKey -Name "InstallPath").InstallPath
$exePath = (Join-Path $installPath "bin\x64\Rterm.exe").Replace("\", "\\")

$settingsContent = @"
{
    "platform": {
		"windows": {
			"rBinDir": "",
			"preferR64": true,
			"rExecutablePath": $exePath"
		}
	},
}
"@

Get-ChildItem (Join-Path $env:SystemDrive "Users") -Force -Directory `
-Exclude "All Users","Default User","Public" | ForEach-Object {
    $settingsDir = Join-Path $_.FullName "AppData\Roaming\RStudio"
    New-Item -ItemType Directory -Force -Path $settingsDir
    $settingsFile = Join-Path $settingsDir "settings.json"
    New-Item -ItemType File -Force -Path $settingsFile -Value $settingsContent
}
