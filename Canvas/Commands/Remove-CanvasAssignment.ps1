function Remove-CanvasAssignment {
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    [OutputType([CanvasAssignment])]
    Param(
        [Parameter(ValueFromPipeline, DontShow, ParameterSetName = 'PipedAssignment')]
        [CanvasAssignment]$PipedAssignment,

        [Parameter(Mandatory, ParameterSetName = 'Default')]
        [Int]$CourseId,
        
        [Parameter(Mandatory, ParameterSetName = 'Default')]
        [Int]$AssignmentId
    )

    process
    {
        $course_id, $assignment_id = switch($PSCmdlet.ParameterSetName) {
            'Default' { ($CourseId,$AssignmentId) }
            'PipedAssignment' { ($PipedAssignment.course_id,$PipedAssignment.id) }
        }

        $result = canvas DELETE "/api/v1/courses/$course_id/assignments/$AssignmentId"
    
        Write-Output [CanvasAssignment]::new($result)
    }
}
