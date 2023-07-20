Set-StrictMode -Version 'Latest'

function get_getenrollment_runner {
    Param($parameter_set, $parameters)
    $script_table = @{
        #get_single_section = {
        #    Param($params)
        #    Invoke-CanvasRequest 'GET' "/api/v1/sections/$($params.identifier)" $params.query
        #}
        get_single_enrollment = {
            Param($params)
            Invoke-CanvasRequest 'GET' "/api/v1/accounts/1/enrollments/$($params.identifier)" $params.query
        }
        get_course_enrollments = {
            Param($params)
            Invoke-CanvasRequest 'GET' "/api/v1/courses/$($params.identifier)/enrollments" $params.query
        }
        get_user_enrollments = {
            Param($params)
            Invoke-CanvasRequest 'GET' "/api/v1/users/$($params.identifier)/enrollments" $params.query
        }
        get_section_enrollments = {
            Param($params)
            Invoke-CanvasRequest 'GET' "/api/v1/sections/$($params.identifier)/enrollments" $params.query
        }
    }
    switch($parameter_set) {
        #                 type          implementing script                    identifier
        'EnrollmentId' { ('enrollment', $script_table.get_single_enrollment  , $parameters.EnrollmentId)                    }
        'UserId'       { ('user'      , $script_table.get_user_enrollments   , $parameters.UserId)                          }
        'UserSisId'    { ('user'      , $script_table.get_user_enrollments   , "sis_section_id:$($parameters.UserSisId)")   }
        'PipedUser'    { ('user'      , $script_table.get_user_enrollments   , $parameters.PipedUser.user_id)               }
        'CourseId'     { ('course'    , $script_table.get_course_enrollments , $parameters.CourseId)                        }
        'CourseSisId'  { ('course'    , $script_table.get_course_enrollments , "sis_course_id:$($parameters.CourseSisId)")  }
        'PipedCourse'  { ('course'    , $script_table.get_course_enrollments , $parameters.PipedCourse.course_id)           }    
        'SectionId'    { ('section'   , $script_table.get_section_enrollments, $parameters.SectionId)                       }
        'SectionSisId' { ('section'   , $script_table.get_section_enrollments, "sis_course_id:$($parameters.SectionSisId)") }
        'PipedSection' { ('section'      , $script_table.get_section_enrollments, $parameters.PipedSection.section_id)         }  
        default {
            Write-Error "Could not find handler for parameter set '$parameter_set'" -ErrorAction Stop
        }
    }
}

function Get-CanvasEnrollment {
    [CmdletBinding()]
    [OutputType([CanvasEnrollment], ParameterSetName = 'EnrollmentId')]
    [OutputType([CanvasEnrollment[]], ParameterSetName = ('PipedCourse','PipedUser','PipedSection','SectionId','SectionSisId','UserId','UserSisId','CourseId','CourseSisId'))]
    Param(
        [Parameter(ValueFromPipeline, DontShow, ParameterSetName = 'PipedCourse')]
        [CanvasCourse]$PipedCourse,
        [Parameter(ValueFromPipeline, DontShow, ParameterSetName = 'PipedUser')]
        [CanvasUser]$PipedUser,
        [Parameter(ValueFromPipeline, DontShow, ParameterSetName = 'PipedSection')]
        [CanvasSection]$PipedSection,

        [Parameter(ParameterSetName = 'EnrollmentId')]
        [Int]$EnrollmentId,

        [Parameter(ParameterSetName = 'SectionId')]
        [Int]$SectionId,
        [Parameter(ParameterSetName = 'SectionSisId')]
        [ValidateNotNullOrEmpty()]
        [String]$SectionSisId,

        [Parameter(ParameterSetName = 'UserId')]
        [Int]$UserId,
        [Parameter(ParameterSetName = 'UserSisId')]
        [ValidateNotNullOrEmpty()]
        [String]$UserSisId,

        [Parameter(ParameterSetName = 'CourseId')]
        [Int]$CourseId,
        [Parameter(ParameterSetName = 'CourseSisId')]
        [ValidateNotNullOrEmpty()]
        [String]$CourseSisId,

        [Parameter(ParameterSetName = 'PipedCourse')]
        [Parameter(ParameterSetName = 'PipedUser')]
        [Parameter(ParameterSetName = 'PipedSection')]
        [Parameter(ParameterSetName = 'SectionId')]
        [Parameter(ParameterSetName = 'SectionSisId')]
        [Parameter(ParameterSetName = 'UserId')]
        [Parameter(ParameterSetName = 'UserSisId')]
        [Parameter(ParameterSetName = 'CourseId')]
        [Parameter(ParameterSetName = 'CourseSisId')]
        [ValidateSet('Student','Teacher','Ta','Designer','Observer')]
        [String[]]$Role,

        [Parameter(ParameterSetName = 'PipedCourse')]
        [Parameter(ParameterSetName = 'PipedUser')]
        [Parameter(ParameterSetName = 'PipedSection')]
        [Parameter(ParameterSetName = 'SectionId')]
        [Parameter(ParameterSetName = 'SectionSisId')]
        [Parameter(ParameterSetName = 'UserId')]
        [Parameter(ParameterSetName = 'UserSisId')]
        [Parameter(ParameterSetName = 'CourseId')]
        [Parameter(ParameterSetName = 'CourseSisId')]
        [ValidateSet('Active','Invited','Deleted','Rejected','Completed','Inactive')]
        [String[]]$State = @('Active','Invited')
    )
    process
    {
        $params = @{
            identifier = $null
            query = @{}
            filters = @()
        }
        
        ($endpoint_type, $script, $params.identifier) = get_getenrollment_runner $PSCmdlet.ParameterSetName $PSBoundParameters

        if($endpoint_type -ne 'enrollment') {
            if($PSBoundParameters.ContainsKey('Role')) {
                $params.query['role'] = @($Role.ForEach({$_ + 'Enrollment'}))
            }
            if($PSBoundParameters.ContainsKey('State')) {
                $params.query['state'] = @($State.ForEach({$_.ToLower()}))
            }
        }

        & $script $params |
        ForEach-Object {
            [CanvasEnrollment]::new($_)
        }
    }
}