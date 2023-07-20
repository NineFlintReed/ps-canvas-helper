
Set-StrictMode -Version 'Latest'
$ErrorActionPreference = 'Stop' # Stop|Inquire|Continue|Suspend|SilentlyContinue


. "$PSScriptRoot/Private/Helpers.ps1"


(Get-ChildItem "$PSScriptRoot/Commands").ForEach({. "$_"})


Update-FormatData -PrependPath "$PSScriptRoot/Types/Types.format.ps1xml"


Set-Alias -Name canvas -Value Invoke-CanvasRequest -Force








