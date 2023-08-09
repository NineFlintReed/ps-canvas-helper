function Unlock-CanvasItem {
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
            Set-CanvasItemLockState @PSBoundParameters -Lock $false
        }
        catch
        {
            $PSCmdlet.ThrowTerminatingError($_)
        }
    }
}