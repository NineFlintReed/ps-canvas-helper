function Lock-CanvasItem {
    [CmdletBinding()]
    Param(
        [Parameter(ValueFromPipeline)]
        $PipedInput,

        [Nullable[Int]]$CourseId,

        [ValidateSet('Assignment','Page','Discussion')]
        [String]$ItemType,

        [Nullable[Int]]$ItemId
    )
    process
    {
        try
        {
            Set-CanvasItemLockState @PSBoundParameters -Lock $true
        }
        catch
        {
            $PSCmdlet.ThrowTerminatingError($_)
        }
    }
}