Set-StrictMode -Version 'Latest'



function get_getterm_runner {
    Param($parameter_set, $parameters)
    $script_table = @{
        get_single_term = {
            Param($params)
            Invoke-CanvasRequest 'GET' "/api/v1/accounts/1/terms/$($params.identifier)" $params.query
        }
        get_account_terms = {
            Param($params)
            Invoke-CanvasRequest 'GET' "/api/v1/accounts/$($params.identifier)/terms" $params.query |
            Select-Object -ExpandProperty 'enrollment_terms'
        }
    }
    switch($parameter_set) {
        #                type       implementing script              identifier
        'All'         { ('account', $script_table.get_account_terms, 1)                                      }
        'TermId'      { ('term'   , $script_table.get_single_term  , $parameters.TermId)                     }
        'TermSisId'   { ('term'   , $script_table.get_single_term  , "sis_term_id:$($parameters.TermSisId)") }
        'PipedCourse' { ('course' , $script_table.get_single_term  , $parameters.PipedCourse.term_id)        }    
        default {
            Write-Error "Could not find handler for parameter set '$parameter_set'" -ErrorAction Stop
        }
    }
}

function Get-CanvasTerm {
    [CmdletBinding(DefaultParameterSetName = 'All')]
    [OutputType([CanvasTerm], ParameterSetName = ('CourseId','CourseSisId','TermId','TermSisId','PipedCourse'))]
    [OutputType([CanvasTerm[]], ParameterSetName = ('All'))]
    Param(
        [Parameter(ValueFromPipeline, DontShow, ParameterSetName = 'PipedCourse')]
        [CanvasCourse]$PipedCourse,

        [Parameter(ParameterSetName = 'TermId')]
        [Int]$TermId,
        [Parameter(ParameterSetName = 'TermSisId')]
        [ValidateNotNullOrEmpty()]
        [String]$TermSisId,

        [Parameter(ParameterSetName = 'CourseId')]
        [Int]$CourseId,
        [Parameter(ParameterSetName = 'CourseSisId')]
        [ValidateNotNullOrEmpty()]
        [String]$CourseSisId
    )
    process
    {
        $params = @{
            identifier = $null
            query = @{}
            filters = @()
        }
        
        ($endpoint_type, $script, $params.identifier) = get_getterm_runner $PSCmdlet.ParameterSetName $PSBoundParameters

        & $script $params |
        ForEach-Object {
            [CanvasTerm]::new($_)
        }
    }
}




<# tests
&{
    function objeq {
        Param($o1, $o2)
        return ($o1.psobject.Properties|Out-String) -eq ($o2.psobject.Properties|Out-String)
    }

    4,5,6 |
    Get-CanvasTerm | sort id |
    sv g1

    [pscustomobject]@{term_id=4;other='abc'},
    [pscustomobject]@{term_id=5;other='abc'},
    [pscustomobject]@{term_id=6;other='abc'} |
    Get-CanvasTerm | sort id |
    sv g2

    4,5,6 |
    %{ Get-CanvasTerm -TermId $_ } | sort id |
    sv g3

    '2018 Secondary Year 12',
    '2018 Secondary Year 7 - 11',
    '2018 Junior' |
    %{ Get-CanvasTerm -TermName $_ } | sort id |
    sv g4

    76,472,673 |
    %{ Get-CanvasTerm -TermSisId $_ } | sort id |
    sv g5

    Get-CanvasTerm | where id -in 4,5,6 | sort id |
    sv g6

    objeq $g1[0] $g2[0]
    objeq $g1[0] $g3[0]
    objeq $g1[0] $g4[0]
    objeq $g1[0] $g5[0]
    objeq $g1[0] $g6[0]

    objeq $g1[1] $g2[1]
    objeq $g1[1] $g3[1]
    objeq $g1[1] $g4[1]
    objeq $g1[1] $g5[1]
    objeq $g1[1] $g6[1]

    objeq $g1[2] $g2[2]
    objeq $g1[2] $g3[2]
    objeq $g1[2] $g4[2]
    objeq $g1[2] $g5[2]
    objeq $g1[2] $g6[2]

}
#>