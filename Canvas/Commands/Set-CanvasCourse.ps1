function Set-CanvasCourse {
    Param(
        [Parameter(ValueFromPipeline, DontShow)]
        [Parameter(ParameterSetName='PipedCourse')]
        [CanvasCourse]$PipedCourse,

        [Parameter(ParameterSetName='CourseId')]
        [Int]$CourseId,

        [String]$AccountId,

        [String]$Name,

        [String]$CourseCode,

        [String]$CourseSisId,

        [Bool]$Blueprint

    )
    process
    {
        $course = switch($PSCmdlet.ParameterSetName) {
            'CourseId'    { Get-CanvasCourse -CourseId $CourseId }
            'PipedCourse' { $PipedCourse                         }
        }
        
        $config = @{}

        switch($PSBoundParameters.Keys) {
            'Name'        { $config['name'] = $Name                 }
            'AccountId'   { $config['account_id'] = $AccountId      }
            'CourseCode'  { $config['course_code'] = $CourseCode    }
            'CourseSisId' { $config['sis_course_id'] = $CourseSisId }
            'Blueprint'   { $config['blueprint'] = $Blueprint       }
            #default { "unrecognised $_" }
        }

        $uri = "/api/v1/courses/$($course.id)"
        $params = @{
            course = $config
        }
        
        $result = Invoke-CanvasRequest 'PUT' $uri $params
        [CanvasCourse]::new($result)
    }
}