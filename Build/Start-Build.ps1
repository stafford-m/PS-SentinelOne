param(
	$Task = 'Default'
)

# dependencies
Get-PackageProvider -Name NuGet -ForceBootstrap | Out-Null
If (-not (Get-Module -ListAvailable PSDepend)) {
	& (Resolve-Path "$PSScriptRoot\helpers\Install-PSDepend.ps1")
}
Import-Module PSDepend
Invoke-PSDepend -Path "$PSScriptRoot\build.requirements.psd1" -Install -Import -Force | Out-Null

Set-BuildEnvironment -Force

Invoke-psake $PSScriptRoot\psake.ps1 -taskList $Task -nologo
exit ( [int]( -not $psake.build_success ) )