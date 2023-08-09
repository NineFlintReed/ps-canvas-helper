function Set-CanvasItemLockState {
    [CmdletBinding()]
    Param(
        [Parameter(ValueFromPipeline)]
        $PipedInput,

        [Nullable[Int]]$CourseId,

        [String]$ItemType,

        [Nullable[Int]]$ItemId,

        [Parameter(Mandatory)][Bool]$Lock
    )
    process
    {
        try
        {
            $params = @{ }

            # if object was piped
            if($null -ne $PipedInput)
            {
                switch($PipedInput.GetType()) {
                    ([CanvasAssignment])
                    {
                        $conflicting_params = ('CourseId','ItemType','ItemId').Where({ $PSBoundParameters.ContainsKey($_) }) -join ','
                        if($conflicting_params) {
                            throw [ArgumentException]::new("Parameters conflict with piped object: $conflicting_params")
                        }

                        $params['CourseId'] = $PipedInput.course_id
                        $params['ItemType'] = 'Assignment'
                        $params['ItemId'] = $PipedInput.assignment_id
                    }
                    ([CanvasCourse])
                    {
                        $conflicting_params = ('CourseId').Where({ $PSBoundParameters.ContainsKey($_) }) -join ','
                        if($conflicting_params) {
                            throw [ArgumentException]::new("Parameters conflict with piped object: $conflicting_params")
                        }

                        $params['CourseId'] = $PipedInput.course_id
                        $params['ItemType'] = $ItemType
                        $params['ItemId'] = $ItemId
                    }
                    default
                    {
                        throw "Unrecognised pipeline type '$_'"
                    }
                }
            }
            else
            {
                $params['CourseId'] = $CourseId
                $params['ItemType'] = $ItemType
                $params['ItemId'] = $ItemId
            }
            
            # check we have all required parameters
            if(-not $params['CourseId']) { throw [ArgumentException]::new("Required parameter missing", "CourseId") }
            if(-not $params['ItemType']) { throw [ArgumentException]::new("Required parameter missing", "ItemType") }
            if(-not $params['ItemId'])   { throw [ArgumentException]::new("Required parameter missing", "ItemId")   }

            
            $item_type_mapping = @{
                Assignment = 'assignment'
                Page = 'wiki_page'
                Discussion = 'discussion_topic'
            }
            $request_params = @{
                Method = 'PUT'
                Endpoint = "/api/v1/courses/$($params.CourseId)/blueprint_templates/default/restrict_item"
                Body = @{
                    content_type = $item_type_mapping[$params.ItemType]
                    content_id = $params.ItemId
                    restricted = $Lock
                }
            }
            Invoke-CanvasRequest @request_params
        }
        catch
        {
            $PSCmdlet.ThrowTerminatingError($_)
        }
    }
}