@{
RootModule = 'RootModule.psm1'
ModuleVersion = '0.0.1'
CompatiblePSEditions = @('Core')
GUID = 'a0ec828e-a778-41d9-96ce-401842bf231a'
Author = 'Tom Cousins'
CompanyName = ''
Copyright = '(c) Tom Cousins. All rights reserved.'
Description = 'A collection of utilities for managing the Canvas Learning Management System.'
PowerShellVersion = '7.3'
RequiredModules = @()

ScriptsToProcess = @(
    './Types/CanvasAccount.ps1'
    './Types/CanvasTerm.ps1'
    './Types/CanvasCourse.ps1'
    './Types/CanvasUser.ps1'
    './Types/CanvasEnrollment.ps1'
    './Types/CanvasSection.ps1'
    './Types/CanvasAssignment.ps1'
)

FunctionsToExport = @(
    'Invoke-CanvasRequest'
    'Get-CanvasAccount'
    'Get-CanvasTerm'
    'Get-CanvasCourse'
    'Set-CanvasCourse'
    'Get-CanvasUser'
    'New-CanvasUser'
    'Get-CanvasSection'
    'Get-CanvasEnrollment'
    'Add-CanvasEnrollment'
    'Disable-CanvasEnrollment'
    'Enable-CanvasEnrollment'
    'Remove-CanvasEnrollment'
    'Get-CanvasRole'
    'Get-CanvasAssignment'
)
CmdletsToExport = @()
VariablesToExport = '*'
AliasesToExport = @(
    'canvas'
)

PrivateData = @{
    PSData = @{}
}

}

