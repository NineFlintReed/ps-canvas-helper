Set-StrictMode -Version 'Latest'
$ErrorActionPreference = 'Stop' # Stop|Inquire|Continue|Suspend|SilentlyContinue


. "$PSScriptRoot/Private/Helpers.ps1"


(Get-ChildItem "$PSScriptRoot/Commands").ForEach({. "$_"})
$global:CANVAS_ENROLLMENT_TERMS = Get-CanvasTerm | Sort-Object 'Name'

Update-FormatData -PrependPath "$PSScriptRoot/Types/Types.format.ps1xml"


Set-Alias -Name canvas -Value Invoke-CanvasRequest -Force










