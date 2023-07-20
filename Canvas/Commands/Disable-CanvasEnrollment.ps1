Set-StrictMode -Version 'Latest'

function Disable-CanvasEnrollment {
    [CmdletBinding()]
    [OutputType([CanvasEnrollment])]
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

        if($enrollment.state -eq 'deleted') {
            throw "Unable to disable deleted enrollment $($enrollment.id)"
        }

        if($enrollment.state -eq 'inactive') {
            $enrollment
        } else {
            $result = deactivate_enrollment $enrollment.course_id $enrollment.enrollment_id
            [CanvasEnrollment]::new($result)
        }
    }
}