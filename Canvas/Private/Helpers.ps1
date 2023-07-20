
function debug {
    $func = (Get-PSCallStack)[1] # parent
    [pscustomobject]@{
        Function = $func.FunctionName
        BoundParameters = $func.GetFrameVariables().PSBoundParameters.Value
        #ParameterSetName = $func.GetFrameVariables().PSCmdlet.Value.ParameterSetName
        Locals = $func.GetFrameVariables().GetEnumerator().Where({
            $_.Key -notin 'input','PSCmdlet','PSBoundParameters','MyInvocation','PSScriptRoot','PSCommandPath'
        }).Value | select Name,Value
        #Cmdlet = $func.GetFrameVariables().PSCmdlet
    } |  
    ConvertTo-Json -Depth 5 |
    Write-Debug -debug
}










function canvas_get {
    Param (
        [String]$Endpoint,
        [HashTable]$Body
    )

    $params = @{
        Method = 'GET'
        Uri = $env:CANVAS_APIROOT + $Endpoint
        Headers = @{
            Accept = 'application/json+canvas-string-ids'
            Authorization = 'Bearer ' + $env:CANVAS_APIKEY
        }
    }

    $query_parameters = &{
        if($Body -and $Body.Keys.Count -gt 0) {
            $Body.GetEnumerator().ForEach({
                if($_.Value -is [Array]) {
                    $values = $_.Value
                    $key = $_.Key
                    $values.GetEnumerator().ForEach({
                        "$key[]=$_"
                    })
                } else {
                    "$($_.Key)=$($_.Value)"
                }
            })
        } else {
            $null
        }
    }
    
    if($query_parameters) {
        $params.Uri += '?' + ($query_parameters -join '&')
    }

    do {
        Write-Debug "Sending GET request to: $($params.Uri)"       
        $response = Invoke-WebRequest @params
        $response.Content | ConvertFrom-Json -Depth 10 -AsHashtable | Write-Output
        $params.Uri = $response.RelationLink['next']
    } while($params.Uri)
}


function canvas_put {
    Param (
        [String]$Endpoint,
        [HashTable]$Body
    )
    $params = @{
        Method = 'PUT'       
        Uri = $env:CANVAS_APIROOT + $Endpoint
        Headers = @{
            Accept = 'application/json+canvas-string-ids'
            Authorization = 'Bearer ' + $env:CANVAS_APIKEY
        }
        ContentType = 'application/json'
    }

    if($Body -and $Body.Keys.Count -gt 0) {
        $params['Body'] = $Body | ConvertTo-Json -Depth 10
    }

    Write-Debug "Sending PUT request to: $($params.Uri)"

    $response = Invoke-WebRequest @params
    $response.Content | ConvertFrom-Json -Depth 10 -AsHashtable | Write-Output
}


function canvas_delete {
    Param (
        [String]$Endpoint,
        [HashTable]$Body
    )
    $params = @{
        Method = 'DELETE'       
        Uri = $env:CANVAS_APIROOT + $Endpoint
        Headers = @{
            Accept = 'application/json+canvas-string-ids'
            Authorization = 'Bearer ' + $env:CANVAS_APIKEY
        }
    }

    $query_parameters = &{
        if($Body -and $Body.Keys.Count -gt 0) {
            $Body.GetEnumerator().ForEach({
                if($_.Value -is [Array]) {
                    $values = $_.Value
                    $key = $_.Key
                    $values.GetEnumerator().ForEach({
                        "$key[]=$_"
                    })
                } else {
                    "$($_.Key)=$($_.Value)"
                }
            })
        } else {
            $null
        }
    }
    
    if($query_parameters) {
        $params.Uri += '?' + ($query_parameters -join '&')
    }

    Write-Debug "Sending DELETE request to: $($params.Uri)"

    $response = Invoke-WebRequest @params
    $response.Content | ConvertFrom-Json -Depth 10 -AsHashtable | Write-Output
}



function canvas_post {
    Param (
        [String]$Endpoint,
        [HashTable]$Body
    )
    $params = @{
        Method = 'POST'       
        Uri = $env:CANVAS_APIROOT + $Endpoint
        Headers = @{
            Accept = 'application/json+canvas-string-ids'
            Authorization = 'Bearer ' + $env:CANVAS_APIKEY
        }
        ContentType = 'application/json'
    }

    if($Body -and $Body.Keys.Count -gt 0) {
        $params['Body'] = $Body | ConvertTo-Json -Depth 10
    }

    Write-Debug "Sending POST request to: $($params.Uri)"

    $response = Invoke-WebRequest @params
    $response.Content | ConvertFrom-Json -Depth 10 -AsHashtable | Write-Output
}



function Invoke-CanvasRequest {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)]
        [ValidateSet('GET','POST','PUT','DELETE')]
        [String]$Method,

        [Parameter(Mandatory)]
        [String]$Endpoint,

        [HashTable]$Body
    )

    try
    {
        switch($Method) {
            'GET'    { canvas_get    $Endpoint $Body }
            'PUT'    { canvas_put    $Endpoint $Body }
            'POST'   { canvas_post   $Endpoint $Body }
            'DELETE' { canvas_delete $Endpoint $Body }
            default {
                throw "$Method not implemented"
            }
        }
    }
    catch
    {
        $PSCmdlet.ThrowTerminatingError($_)
    }
}












function deactivate_enrollment {
    Param($course_id, $enrollment_id)
    Invoke-CanvasRequest 'DELETE' "/api/v1/courses/$course_id/enrollments/$enrollment_id" @{
        task = 'deactivate'
    }
}
function conclude_enrollment {
    Param($course_id, $enrollment_id)
    Invoke-CanvasRequest 'DELETE' "/api/v1/courses/$course_id/enrollments/$enrollment_id" @{
        task = 'conclude'
    }
}
function delete_enrollment {
    Param($course_id, $enrollment_id)
    Invoke-CanvasRequest 'DELETE' "/api/v1/courses/$course_id/enrollments/$enrollment_id" @{
        task = 'delete'
    }
}
function reactivate_enrollment {
    Param($course_id, $enrollment_id)
    Invoke-CanvasRequest 'PUT' "/api/v1/courses/$course_id/enrollments/$enrollment_id/reactivate"
}





