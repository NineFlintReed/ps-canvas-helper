

function get_getuser_runner {
    Param($parameter_set, $parameters)
    $script_table = @{
        get_single_user = {
            Param($params)
            Invoke-CanvasRequest 'GET' "/api/v1/users/$($params.identifier)" $params.query
        }
        get_course_users = {
            Param($params)
            Invoke-CanvasRequest 'GET' "/api/v1/courses/$($params.identifier)/users" $params.query
        }
        get_account_users = {
            Param($params)
            Invoke-CanvasRequest 'GET' "/api/v1/accounts/$($params.identifier)/users" $params.query
        }
    }
    switch($parameter_set) {
        #                     type       implementing script              identifier
        'All'              { ('account', $script_table.get_account_users, 1)                                          }
        'UserId'           { ('user'   , $script_table.get_single_user  , $parameters.UserId)                         }
        'UserSisId'        { ('user'   , $script_table.get_single_user  , "sis_user_id:$($parameters.UserSisId)")     }
        'CourseId'         { ('course' , $script_table.get_course_users , $parameters.CourseId)                       }
        'CourseSisId'      { ('course' , $script_table.get_course_users , "sis_course_id:$($parameters.CourseSisId)") }
        'PipedCourse'      { ('course' , $script_table.get_course_users , $parameters.PipedCourse.course_id)          }
        #'AccountId'       { ('account', $script_table.get_account_courses, $parameters.AccountId)                        }
        #'AccountSisId'    { ('account', $script_table.get_account_courses, "sis_account_id:$($parameters.AccountSisId)") }
        #'PipedAccount'    { ('account', $script_table.get_account_courses, $parameters.PipedAccount.account_id)          }
        'PipedEnrollment'  { ('user'   , $script_table.get_single_user  , $parameters.PipedEnrollment.user_id)        }
        #'PipedSection'     { ('course' , $script_table.get_course_users  , $parameters.PipedSection.course_id)           }      
        default {
            Write-Error "Could not find handler for parameter set '$parameter_set'" -ErrorAction Stop
        }
    }
}


function Get-CanvasUser {
    [CmdletBinding(DefaultParameterSetName='All')]
    #[OutputType([CanvasCourse], ParameterSetName = ('CourseId','CourseSisId','Pipeline'))]
    #[OutputType([CanvasCourse[]], ParameterSetName = ('All','Pipeline','UserId','UserSisId','AccountId','AccountSisId'))]
    Param(
        [Parameter(ValueFromPipeline, DontShow, ParameterSetName = 'PipedCourse')]
        [CanvasCourse]$PipedCourse,
        #[Parameter(ValueFromPipeline, DontShow, ParameterSetName = 'PipedAccount')]
        #[CanvasAccount]$PipedAccount,
        [Parameter(ValueFromPipeline, DontShow, ParameterSetName = 'PipedEnrollment')]
        [CanvasEnrollment]$PipedEnrollment,
        #[Parameter(ValueFromPipeline, DontShow, ParameterSetName = 'PipedSection')]
        #[CanvasSection]$PipedSection,

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

        [Parameter(ParameterSetName = 'CourseId')]
        [Parameter(ParameterSetName = 'CourseSisId')]
        [Parameter(ParameterSetName = 'PipedCourse')]
        [Parameter(ParameterSetName = 'All')]
        [ValidateLength(3, 99)]
        [String]$Search,

        [Parameter(ParameterSetName = 'CourseId')]
        [Parameter(ParameterSetName = 'CourseSisId')]
        [Parameter(ParameterSetName = 'PipedCourse')]
        [ValidateSet('Teacher','Student','TA','Observer','Designer')]
        [String[]]$Role,

        [Parameter(ParameterSetName = 'CourseId')]
        [Parameter(ParameterSetName = 'CourseSisId')]
        [Parameter(ParameterSetName = 'PipedCourse')]
        [ValidateSet('Active','Invited','Rejected','Completed','Inactive')]
        [String[]]$State
    )
    process
    {
        $params = @{
            identifier = $null
            query = @{}
            filters = @()
        }
        
        ($endpoint_type, $script, $params.identifier) = get_getuser_runner $PSCmdlet.ParameterSetName $PSBoundParameters

        if($endpoint_type -in 'course','account') {
            if($PSBoundParameters.ContainsKey('Search')) {
                $params.query['search_term'] = $Search
            }
        }
        
        if($endpoint_type -eq 'course') {
            if($PSBoundParameters.ContainsKey('Role')) {
                $params.query['enrollment_type'] = $Role.ForEach({$_.ToLower()})
            }
            if($PSBoundParameters.ContainsKey('State')) {
                $params.query['enrollment_state'] = $State.ForEach({$_.ToLower()})
            }
        }

        & $script $params |
        ForEach-Object {
            [CanvasUser]::new($_)
        }
    }
}