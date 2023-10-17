

# GET /api/v1/courses/:course_id/assignments/:id 
# GET /api/v1/courses/:course_id/assignments 
# GET /api/v1/users/:user_id/courses/:course_id/assignments 
# GET /api/v1/courses/:course_id/assignment_groups/:assignment_group_id/assignments 

function Get-CanvasAssignment {
    [CmdletBinding(DefaultParameterSetName = 'CourseId')]
    Param(
        [Parameter(ValueFromPipeline, DontShow, ParameterSetName = 'PipedCourse')]
        [CanvasCourse]$PipedCourse,

        [Parameter(ParameterSetName = 'CourseId_AssignmentId')]    
        [Parameter(ParameterSetName = 'CourseId')]
        [Int]$CourseId,

        [Parameter(ParameterSetName = 'CourseId_AssignmentId')]
        [Int]$AssignmentId
    )

    process
    {
        $endpoint = switch($PSCmdlet.ParameterSetName) {
            'CourseId'              { "/api/v1/courses/$CourseId/assignments"               }
            'CourseId_AssignmentId' { "/api/v1/courses/$CourseId/assignments/$AssignmentId" }
            'PipedCourse'           { "/api/v1/courses/$($PipedCourse.id)/assignments" }
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
}






