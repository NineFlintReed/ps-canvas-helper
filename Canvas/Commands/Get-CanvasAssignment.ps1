
function Get-CanvasAssignment {
    [CmdletBinding(DefaultParameterSetName='Course')]
    Param(
        [Parameter(ParameterSetName='Course')]
        [Int]$CourseId,

        [Parameter(ParameterSetName='Course')]
        [Parameter(ParameterSetName='Single')]
        [Int]$AssignmentId
    )

    
    $endpoint = switch($PSCmdlet.ParameterSetName) {
        'Course' { "/api/v1/courses/$CourseId/assignments"               }
        'Single' { "/api/v1/courses/$CourseId/assignments/$AssignmentId" }
        default {
            throw
        }
    }
    

    $params = @{
        Method = 'GET'
        Endpoint = $endpoint
    }

    Invoke-CanvasRequest @params |
    ForEach-Object {
        [CanvasAssignment]::new($_)
    }

}



