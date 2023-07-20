
function Get-CanvasRole {
    [CmdletBinding()]
    Param()
    
    Invoke-CanvasRequest 'GET' "/api/v1/accounts/1/roles"
    | %{[pscustomobject]$_}
    | where is_account_role -eq $false
    | select role,label,id,workflow_state
}