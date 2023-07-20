Set-StrictMode -Version 'Latest'
function Enable-CanvasEnrollment {
    [CmdletBinding()]
    Param(
        [Parameter(ValueFromPipeline, DontShow, ParameterSetName = 'PipedEnrollment')]
        [CanvasEnrollment]$PipedEnrollment,

        [Parameter(ParameterSetName = 'EnrollmentId')]
        [Int]$EnrollmentId
    )
    process
    {
        $enrollment = switch($PSCmdlet.ParameterSetName) {
            'EnrollmentId'    { Get-CanvasEnrollment -EnrollmentId $EnrollmentId }
            'PipedEnrollment' { $PipedEnrollment                                 }
        }

        if($enrollment.state -in 'deleted','completed') {
            throw "Enrollment $($enrollment.id) is not marked as inactive. Can only enable inactive enrollments."
        }

        if($enrollment.state -eq 'active') {
            $enrollment
        } else {
            $result = reactivate_enrollment $enrollment.course_id $enrollment.enrollment_id
            [CanvasEnrollment]::new($result)
        }
    }
}


