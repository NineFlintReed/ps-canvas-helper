Set-StrictMode -Version 'Latest'

function Remove-CanvasEnrollment {
    [CmdletBinding()]
    Param(
        [Parameter(ValueFromPipeline, DontShow, ParameterSetName = 'PipedEnrollment')]
        [CanvasEnrollment]$PipedEnrollment,

        [Parameter(ParameterSetName = 'EnrollmentId')]
        [Int]$EnrollmentId,

        [Switch]$Delete
    )
    process
    {
        $enrollment = switch($PSCmdlet.ParameterSetName) {
            'EnrollmentId'    { Get-CanvasEnrollment -EnrollmentId $EnrollmentId }
            'PipedEnrollment' { $PipedEnrollment                                 }
        }

        if($enrollment.state -eq 'deleted') {
            $enrollment
        } else {
            $result = delete_enrollment $enrollment.course_id $enrollment.enrollment_id
            [CanvasEnrollment]::new($result)
        }      
    }
}