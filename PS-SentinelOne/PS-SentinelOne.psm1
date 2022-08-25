# Get a list of the included scripts and import them
$ModulePath = Split-Path $MyInvocation.MyCommand.Path -Parent
$Public  = @( Get-ChildItem -Path $ModulePath\Public\*.ps1 -ErrorAction SilentlyContinue )
$Private = @( Get-ChildItem -Path $ModulePath\Private\*.ps1 -ErrorAction SilentlyContinue )
Foreach ($Import in @($Public + $Private)) {
	Try {
		. $Import.FullName
	} Catch {
		Write-Error -Message "Failed to import function $($Import.FullName): $_"
	}
}
Export-ModuleMember -Function $Public.Basename

# Setup
Add-Type -AssemblyName System.Web
Set-Variable -Name PSSentinelOne -Value @{ ConfPath = [System.IO.Path]::Combine([Environment]::GetFolderPath("LocalApplicationData"),"PS-SentinelOne","config.json") } -Scope Script