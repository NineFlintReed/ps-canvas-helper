Set-StrictMode -Version 'Latest'

class CanvasTerm {
	[Nullable[Int]]$id
	[String]$sis_term_id
	[Nullable[Int]]$sis_import_id
	[String]$name
	[Nullable[DateTime]]$start_at
	[Nullable[DateTime]]$end_at
	[String]$workflow_state

    CanvasTerm([Collections.IDictionary]$Object) {
        $this.id             = $Object['id']
        $this.sis_term_id    = $Object['sis_term_id']
        $this.sis_import_id  = $Object['sis_import_id']
        $this.name           = $Object['name']
        $this.start_at       = $Object['start_at']
        $this.end_at         = $Object['end_at']
        $this.workflow_state = $Object['workflow_state']
    }
}

Update-TypeData -TypeName 'CanvasTerm' -MemberType 'AliasProperty' -MemberName 'term_id' -Value 'id' -Force