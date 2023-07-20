Set-StrictMode -Version 'Latest'

function get_getsection_runner {
    Param($parameter_set, $parameters)
    $script_table = @{
        get_single_section = {
            Param($params)
            Invoke-CanvasRequest 'GET' "/api/v1/sections/$($params.identifier)" $params.query
        }
        get_course_sections = {
            Param($params)
            Invoke-CanvasRequest 'GET' "/api/v1/courses/$($params.identifier)/sections" $params.query
        }
    }
    switch($parameter_set) {
        #                     type       implementing script              identifier
        'SectionId'        { ('section', $script_table.get_single_section  , $parameters.SectionId)                        }
        'SectionSisId'     { ('section', $script_table.get_single_section  , "sis_section_id:$($parameters.SectionSisId)") }
        'CourseId'         { ('course' , $script_table.get_course_sections , $parameters.CourseId)                         }
        'CourseSisId'      { ('course' , $script_table.get_course_sections , "sis_course_id:$($parameters.CourseSisId)")   }
        'PipedCourse'      { ('course' , $script_table.get_course_sections , $parameters.PipedCourse.course_id)            }    
        default {
            Write-Error "Could not find handler for parameter set '$parameter_set'" -ErrorAction Stop
        }
    }
}

function Get-CanvasSection {
    [CmdletBinding()]
    [OutputType([CanvasSection], ParameterSetName = ('SectionId','SectionSisId','Pipeline'))]
    [OutputType([CanvasSection[]], ParameterSetName = ('CourseId','CourseSisId','Pipeline'))]
    Param(
        [Parameter(ValueFromPipeline, DontShow, ParameterSetName = 'PipedCourse')]
        [CanvasCourse]$PipedCourse,

        [Parameter(ParameterSetName = 'SectionId')]
        [Int]$SectionId,
        [Parameter(ParameterSetName = 'SectionSisId')]
        [ValidateNotNullOrEmpty()]
        [String]$SectionSisId,

        [Parameter(ParameterSetName = 'CourseId')]
        [Int]$CourseId,
        [Parameter(ParameterSetName = 'CourseSisId')]
        [ValidateNotNullOrEmpty()]
        [String]$CourseSisId
    )
    process
    {
        $params = @{
            identifier = $null
            query = @{}
            filters = @()
        }
        
        ($endpoint_type, $script, $params.identifier) = get_getsection_runner $PSCmdlet.ParameterSetName $PSBoundParameters

        & $script $params |
        ForEach-Object {
            [CanvasSection]::new($_)
        }
    }
}