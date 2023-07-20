Set-StrictMode -Version 'Latest'






function get_getcourse_runner {
    Param($parameter_set, $parameters)
    $script_table = @{
        get_single_course = {
            Param($params)
            Invoke-CanvasRequest 'GET' "/api/v1/courses/$($params.identifier)" $params.query
        }
        get_user_courses = {
            Param($params)
            if($params.filters) {
                Invoke-CanvasRequest 'GET' "/api/v1/users/$($params.identifier)/courses" $params.query |
                ForEach-Object {
                    $course = $_
                    $fail = $false
                    $params.filters.ForEach({
                        if(-not $course.Where($_)) {
                            $fail = $true
                        }
                    })
                    if(-not $fail) {
                        return $course
                    }
                }
            } else {
                Invoke-CanvasRequest 'GET' "/api/v1/users/$($params.identifier)/courses" $params.query
            }
        }
        get_account_courses = {
            Param($params)
            Invoke-CanvasRequest 'GET' "/api/v1/accounts/$($params.identifier)/courses" $params.query
        }
    }
    # returns tuple (for destructuring) of 
    # $endpoint_type, $implementing_script, $identifier
    switch($parameter_set) {
        #                    type       implementing script                identifier
        'All'             { ('account', $script_table.get_account_courses, 1)                                            }
        'CourseId'        { ('course' , $script_table.get_single_course  , $parameters.CourseId)                         }
        'UserId'          { ('user'   , $script_table.get_user_courses   , $parameters.UserId)                           }
        'AccountId'       { ('account', $script_table.get_account_courses, $parameters.AccountId)                        }
        'CourseSisId'     { ('course' , $script_table.get_single_course  , "sis_course_id:$($parameters.CourseSisId)")   }
        'UserSisId'       { ('user'   , $script_table.get_user_courses   , "sis_user_id:$($parameters.UserSisId)")       }
        'AccountSisId'    { ('account', $script_table.get_account_courses, "sis_account_id:$($parameters.AccountSisId)") }
        'PipedUser'       { ('user'   , $script_table.get_user_courses   , $parameters.PipedUser.user_id)                }
        'PipedAccount'    { ('account', $script_table.get_account_courses, $parameters.PipedAccount.account_id)          }
        'PipedEnrollment' { ('course' , $script_table.get_single_course  , $parameters.PipedEnrollment.course_id)        }
        'PipedSection'    { ('course' , $script_table.get_single_course  , $parameters.PipedSection.course_id)           }      
        default {
            Write-Error "Could not find handler for parameter set '$parameter_set'" -ErrorAction Stop
        }
    }
}


function Get-CanvasCourse {
    [CmdletBinding(DefaultParameterSetName='All')]
    [OutputType([CanvasCourse], ParameterSetName = ('CourseId','CourseSisId','PipedEnrollment','PipedSection'))]
    [OutputType([CanvasCourse[]], ParameterSetName = ('All','PipedAccount','PipedUser','UserId','UserSisId','AccountId','AccountSisId'))]
    Param(
        [Parameter(ValueFromPipeline, DontShow, ParameterSetName = 'PipedUser')]
        [CanvasUser]$PipedUser,
        [Parameter(ValueFromPipeline, DontShow, ParameterSetName = 'PipedAccount')]
        [CanvasAccount]$PipedAccount,
        [Parameter(ValueFromPipeline, DontShow, ParameterSetName = 'PipedEnrollment')]
        [CanvasEnrollment]$PipedEnrollment,
        [Parameter(ValueFromPipeline, DontShow, ParameterSetName = 'PipedSection')]
        [CanvasSection]$PipedSection,

        [Parameter(ParameterSetName = 'CourseId')]
        [Int]$CourseId,

        [Parameter(ParameterSetName = 'CourseSisId')]
        [ValidateNotNullOrEmpty()]
		[String]$CourseSisId,

        [Parameter(ParameterSetName = 'UserId')]
        [Int]$UserId,
        [Parameter(ParameterSetName = 'UserSisId')]
        [ValidateNotNullOrEmpty()]
        [String]$UserSisId,

        [Parameter(ParameterSetName = 'AccountId')]
        [Int]$AccountId,
        [Parameter(ParameterSetName = 'AccountSisId')]
        [ValidateNotNullOrEmpty()]
        [String]$AccountSisId,

        [Parameter(ParameterSetName = 'PipedUser')]
        [Parameter(ParameterSetName = 'PipedAccount')]        
        [Parameter(ParameterSetName = 'AccountId')]
        [Parameter(ParameterSetName = 'AccountSisId')]
        [Parameter(ParameterSetName = 'UserId')]
        [Parameter(ParameterSetName = 'UserSisId')]
        [Parameter(ParameterSetName = 'All')]
        [Int]$TermId,

        [Parameter(ParameterSetName = 'PipedUser')]
        [Parameter(ParameterSetName = 'PipedAccount')]        
        [Parameter(ParameterSetName = 'AccountId')]
        [Parameter(ParameterSetName = 'AccountSisId')]
        [Parameter(ParameterSetName = 'UserId')]
        [Parameter(ParameterSetName = 'UserSisId')]
        [Parameter(ParameterSetName = 'All')]
        [ValidateLength(3, 99)]
        [String]$Search,

        [Parameter(ParameterSetName = 'PipedUser')]
        [Parameter(ParameterSetName = 'PipedAccount')]        
        [Parameter(ParameterSetName = 'TermId')]
        [Parameter(ParameterSetName = 'TermSisId')]
        [Parameter(ParameterSetName = 'AccountId')]
        [Parameter(ParameterSetName = 'AccountSisId')]
        [Parameter(ParameterSetName = 'UserId')]
        [Parameter(ParameterSetName = 'UserSisId')]
        [Parameter(ParameterSetName = 'All')]
        [ValidateSet('Published','Unpublished','All')]
        [String]$State = 'All',


        [Parameter(ParameterSetName = 'PipedUser')]
        [Parameter(ParameterSetName = 'PipedAccount')]
        [Parameter(ParameterSetName = 'TermId')]
        [Parameter(ParameterSetName = 'TermSisId')]
        [Parameter(ParameterSetName = 'AccountId')]
        [Parameter(ParameterSetName = 'AccountSisId')]
        [Parameter(ParameterSetName = 'UserId')]
        [Parameter(ParameterSetName = 'UserSisId')]
        [Parameter(ParameterSetName = 'All')]
        [ValidateSet('Current','Concluded','All')]
        [String]$Completion = 'Current',

        [Parameter(ParameterSetName = 'PipedUser')]
        [Parameter(ParameterSetName = 'PipedAccount')]
        [Parameter(ParameterSetName = 'TermId')]
        [Parameter(ParameterSetName = 'TermSisId')]
        [Parameter(ParameterSetName = 'AccountId')]
        [Parameter(ParameterSetName = 'AccountSisId')]
        [Parameter(ParameterSetName = 'UserId')]
        [Parameter(ParameterSetName = 'UserSisId')]
        [Parameter(ParameterSetName = 'All')]
        [ValidateSet('Blueprint','Normal','All')]
        [String]$CourseType = 'All'
    )
    process
    {

        # parameters for the implementing scriptblock
        $params = @{
            identifier = $null
            query = @{
                include = @('concluded')
            }
            # fallback for /api/v1/users/:user_id/courses due to limited server-side filtering
            filters = @()
        }
        
        # return the object id, the scriptblock to run, and the type of endpoint (user/course/account)
        ($endpoint_type, $script, $params.identifier) = get_getcourse_runner $PSCmdlet.ParameterSetName $PSBoundParameters

        if($endpoint_type -eq 'account') {
            switch($Completion) {
                'Current'   { $params.query['completed'] = $false }
                'Concluded' { $params.query['completed'] = $true }
                'All'       { <# not present gets both #> }
            }
            switch($CourseType) {
                'Blueprint' { $params.query['blueprint'] = $true }
                'Normal'    { $params.query['blueprint'] = $false }
                'All'       { <# not present gets both #>}
            }
            switch($State) {
                'Published'   { $params.query['published'] = $true }
                'Unpublished' { $params.query['published'] = $false }
                'All'         { <# no filter#> }
            }

            if($PSBoundParameters.ContainsKey('TermId')) {
                $params.query['enrollment_term_id'] = $TermId
            }

            if($PSBoundParameters.ContainsKey('Search')) {
                $params.query['search_term'] = $Search
            }

        } elseif($endpoint_type -eq 'user') {
            switch($Completion) {
                'Current'   { $params.filters += { $_.concluded -eq $false } }
                'Concluded' { $params.filters += { $_.concluded -eq $true } }
                'All'       { <# no filter #> }
            }
            switch($CourseType) {
                'Blueprint' { $params.filters += { $_.blueprint -eq $true } }
                'Normal'    { $params.filters += { $_.blueprint -eq $false } }
                'All'       { <# no filter #>}
            }
            switch($State) {
                'Published'   { $params.filters += { $_.workflow_state -eq 'available' } }
                'Unpublished' { $params.filters += { $_.workflow_state -eq 'unpublished' } }
                'All'         { <# no filter#> }                
            }

            if($PSBoundParameters.ContainsKey('TermId')) {
                $params.filters += { $_.enrollment_term_id -eq $TermId }
            }

            if($PSBoundParameters.ContainsKey('Search')) {
                $params.filters += {
                    $str = "$($_['course_code'])`n$($_['name'])`n$($_['sis_id'])".ToLower()
                    $str.Contains($Search.ToLower())
                }
            }

        }
        
        & $script $params |
        ForEach-Object {
            [CanvasCourse]::new($_)
        }
    }
}