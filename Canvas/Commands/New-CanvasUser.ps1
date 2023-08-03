Set-StrictMode -Version 'Latest'

function New-CanvasUser {
    [CmdletBinding()]
    [OutputType([CanvasUser])]
    Param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [String]$Name,
        
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [String]$UserSisId,
        
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [String]$LoginId
    )

    $params = @{
        Method = 'POST'
        Endpoint = '/api/v1/accounts/1/users'
        Body = @{
            user = @{
                name = $Name
                terms_of_use = $true
                skip_registration = $true
            }
            pseudonym = @{
                unique_id = $LoginId
                send_confirmation = $false
                sis_user_id = $UserSisId
            }
            communication_channel = @{
                skip_confirmation = $true
                type = 'email'
            }
            force_validations = $true
            enable_sis_reactivation = $true
        }
    }
    try
    {
        $user = Invoke-CanvasRequest @params
        return Get-CanvasUser -UserId $user.id
    }
    catch
    {
        $PSCmdlet.ThrowTerminatingError($_)
    }
}