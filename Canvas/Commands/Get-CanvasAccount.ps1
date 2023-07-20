
Set-StrictMode -Version 'Latest'


function get_getaccount_runner {
    Param($parameter_set, $parameters)
    $script_table = @{
        get_all_accounts = {
            Param($params)
            Invoke-CanvasRequest 'GET' "/api/v1/manageable_accounts"
        }
        get_single_account = {
            Param($params)
            Invoke-CanvasRequest 'GET' "/api/v1/accounts/$($params.identifier)"
        }
    }
    switch($parameter_set) {
        #                type        implementing script             identifier
        'All'          { ('account', $script_table.get_all_accounts, 1)                                              }
        'AccountId'    { ('account', $script_table.get_single_account, $parameters.AccountId)                        }
        'AccountSisId' { ('account', $script_table.get_single_account, "sis_account_id:$($parameters.AccountSisId)") }
        'PipedCourse'  { ('account', $script_table.get_single_account, $parameters.PipedCourse.account_id)           }
        default {
            Write-Error "Could not find handler for parameter set '$parameter_set'" -ErrorAction Stop
        }
    }
}

function Get-CanvasAccount {
    [CmdletBinding(DefaultParameterSetName = 'All')]
    [OutputType([CanvasAccount], ParameterSetName = ('AccountId','AccountSisId','PipedCourse'))]
    [OutputType([CanvasAccount[]], ParameterSetName = ('All'))]
    Param(
        [Parameter(ValueFromPipeline, DontShow, ParameterSetName = 'PipedCourse')]
        [CanvasCourse]$PipedCourse,

        [Parameter(ParameterSetName = 'AccountId')]
        [Int]$AccountId,
        [Parameter(ParameterSetName = 'AccountSisId')]
        [ValidateNotNullOrEmpty()]
        [String]$AccountSisId
    )
    process
    {
        $params = @{
            identifier = $null
            query = @{}
            filters = @()
        }
        
        ($endpoint_type, $script, $params.identifier) = get_getaccount_runner $PSCmdlet.ParameterSetName $PSBoundParameters

        & $script $params |
        ForEach-Object {
            [CanvasAccount]::new($_)
        }
    }
}