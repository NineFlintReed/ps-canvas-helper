function Get-CanvasCourse_Single {
    [CmdletBinding()]
    Param(
        $CourseId,
        $Completion, # ignored
        $CourseType, # ignored
        $State, # ignored
        $TermId, # ignored
        $Search # ignored
    )
    $CourseId = $CourseId -creplace '^sis:','sis_course_id:' 
    $params = @{
        Method = 'GET'
        Endpoint = "/api/v1/accounts/1/courses/$CourseId"
        Body = @{ 
            include = @('concluded')
        }
    }
    Invoke-CanvasRequest @params |
    ForEach-Object {
        [CanvasCourse]::new($_)
    }
}



function Get-CanvasCourse_User {
    [CmdletBinding()]
    Param(
        $UserId,
        $Completion,
        $CourseType,
        $State,
        $TermId,
        $Search
    )
    $UserId = $UserId -creplace '^sis:','sis_user_id:' 

    $params = @{
        Method = 'GET'
        Endpoint = "/api/v1/users/$UserId/courses"
        Body = @{
            include = @('concluded')
        }
    }


    [ScriptBlock[]]$filters = Invoke-Command -NoNewScope {
        switch($PSBoundParameters.Keys) {
            'Completion' {
                switch($Completion) {
                    'Current' {
                        $params.Body['enrollment_state'] = 'active'
                        {$args.concluded -eq $false}
                    }
                    'Concluded' {
                        $params.Body['enrollment_state'] = 'completed'
                        {$args.concluded -eq $true}
                    }
                }
            }
            'CourseType' {
                switch($CourseType) {
                    'Class' {{$args.blueprint -eq $false}}
                    'Blueprint' {{$args.blueprint -eq $true}}
                }
            }        
            'State' {
                switch($State) {
                    'Published' {
                        $params.Body['state'] = @('available')
                    }
                    'Unpublished' { 
                        $params.Body['state'] = @('unpublished')
                    }
                    'Deleted' {
                        $params.Body['state'] = @('deleted')
                    }
                }
            }
            'TermId' {
                $TermId = $TermId -replace '^sis:','sis_course_id:'
                {$args.enrollment_term_id -eq $TermId}
            }
            'Search' {
                {"$($args.course_code)`n$($args.name)`n$($args.sis_course_id)".ToLower().Contains($Search.ToLower())}
            }
        }
    }

    
    Invoke-CanvasRequest @params |
    ForEach-Object {
        foreach($f in $filters) {
            if(-not (& $f $_)) {
                return
            }
        }
        return $_
    } |
    ForEach-Object {
        [CanvasCourse]::new($_)
    }
}

function Get-CanvasCourse_Account {
    [CmdletBinding()]
    Param(
        $AccountId,
        $Completion,
        $CourseType,
        $State,
        $TermId,
        $Search
    )

    if(-not $AccountId) {
        $AccountId = 1
    } 
    $AccountId = $AccountId -creplace '^sis:','sis_course_id:'

    $params = @{
        Method = 'GET'
        Endpoint = "/api/v1/accounts/$AccountId/courses"
        Body = @{
            include = @('concluded')
        }
    }

    $filters = Invoke-Command -NoNewScope {
        switch($PSBoundParameters.Keys) {
            'Completion' {
                switch($Completion) {
                    'Current' {@{completed = $false}}
                    'Concluded' {@{completed = $true}}
                }
            }
            'CourseType' {
                switch($CourseType) {
                    'Class' {@{blueprint = $false}}
                    'Blueprint' {@{blueprint = $true}}
                }
            }
            'State' {
                switch($State) {
                    'Published' {@{published = $true}}
                    'Unpublished' {@{published = $false}}
                    'Deleted' {@{state = 'deleted'}}
                }
            }
            'TermId' {
                $TermId = $TermId -replace '^sis:','sis_course_id:' 
                @{enrollment_term_id = $TermId}
            }
            'Search' {@{search_term = $Search}}
        }
    }
    
    foreach($f in $filters) {
        $params.Body += $f
    }

    Invoke-CanvasRequest @params |
    ForEach-Object {
        [CanvasCourse]::new($_)
    }
}











function Get-CanvasCourse {
    [CmdletBinding(DefaultParameterSetName='AccountId')]
    [OutputType([CanvasCourse],ParameterSetName=('PipedCourse','CourseId','PipedEnrollment','PipedSection'))]
    [OutputType([CanvasCourse[]],ParameterSetName=('AccountId','PipedAccount','UserId','PipedUser'))]
    Param(
        [Parameter(Mandatory,DontShow,ValueFromPipeline,ParameterSetName='PipedUser')]
        [CanvasUser]$PipedUser,
        [Parameter(Mandatory,DontShow,ValueFromPipeline,ParameterSetName='PipedAccount')]
        [CanvasAccount]$PipedAccount,
        [Parameter(Mandatory,DontShow,ValueFromPipeline,ParameterSetName='PipedCourse')]
        [CanvasCourse]$PipedCourse,
        [Parameter(Mandatory,DontShow,ValueFromPipeline,ParameterSetName='PipedEnrollment')]
        [CanvasEnrollment]$PipedEnrollment,
        [Parameter(Mandatory,DontShow,ValueFromPipeline,ParameterSetName='PipedSection')]
        [CanvasSection]$PipedSection,

        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory,ParameterSetName='UserId')]
        [String]$UserId,

        [ValidateNotNullOrEmpty()]
        [Parameter(ParameterSetName='AccountId')]
        [String]$AccountId,

        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory,ParameterSetName='CourseId')]
        [String]$CourseId,

        [Parameter(ParameterSetName='PipedUser')]
        [Parameter(ParameterSetName='PipedAccount')]
        [Parameter(ParameterSetName='UserId')]
        [Parameter(ParameterSetName='AccountId')]
        [String]$TermId,

        [ValidateSet('Current','Concluded')]
        [String]$Completion,
        
        [ValidateSet('Blueprint','Class')]
        [String]$CourseType,

        [ValidateSet('Published','Unpublished','Deleted')]
        [String]$State,

        [ValidateLength(3,99)]
        [Parameter(ParameterSetName='PipedUser')]
        [Parameter(ParameterSetName='PipedAccount')]
        [Parameter(ParameterSetName='UserId')]
        [Parameter(Position=0,ParameterSetName='AccountId')]
        [String]$Search
    )
    
    process
    {
        $params = [HashTable]::new($PSBoundParameters)

        foreach($set in 'PipedUser','PipedAccount','PipedCourse','PipedEnrollment','PipedSection','PipedTerm') {
            $params.Remove($set)
        }
        $runner = Invoke-Command -NoNewScope -InputObject $PSItem {
            switch($PSCmdlet.ParameterSetName) {
                'PipedUser' {
                    $params['UserId'] = $input.user_id
                    return ${Function:Get-CanvasCourse_User}
                }
                'PipedAccount' {
                    $params['AccountId'] = $input.account_id
                    return ${Function:Get-CanvasCourse_Account}
                }
                'PipedCourse' {
                    $params['CourseId'] = $input.course_id
                    return ${Function:Get-CanvasCourse_Single}
                }
                'PipedEnrollment' {
                    $params['CourseId'] = $input.course_id
                    return ${Function:Get-CanvasCourse_Single}
                }
                'PipedSection' {
                    $params['CourseId'] = $input.course_id
                    return ${Function:Get-CanvasCourse_Single}
                }
                'UserId' {
                    return ${Function:Get-CanvasCourse_User}
                }
                'AccountId' {              
                    return ${Function:Get-CanvasCourse_Account}
                }
                'CourseId' {
                    return ${Function:Get-CanvasCourse_Single}
                }
                default { 
                    return ${Function:Get-CanvasCourse_Account}
                }
            }
        }
        & $runner @params
    }
}