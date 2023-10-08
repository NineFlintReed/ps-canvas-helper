# todo fix this properly, needs pipeline input and more input validation
function Remove-CanvasAssignment {
    Param(
        [Parameter(Mandatory)]
        [Int]$CourseId,
        [Parameter(Mandatory)]
        [Int]$AssignmentId
    )

    $result = canvas DELETE "/api/v1/courses/$CourseId/assignments/$AssignmentId"

    return [CanvasAssignment]::new($result)
}