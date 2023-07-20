Set-StrictMode -Version 'Latest'

class CanvasUser {
    [Nullable[Int]]$id
    [String]$name
    [Nullable[DateTime]]$created_at
    [String]$sortable_name
    [String]$short_name
    [String]$sis_user_id
    [String]$integration_id
    [Nullable[Int]]$sis_import_id
    [String]$login_id
    
    CanvasUser([Collections.IDictionary]$Object) {
        $this.id             = $Object['id']
        $this.name           = $Object['name']
        $this.created_at     = $Object['created_at']
        $this.sortable_name  = $Object['sortable_name']
        $this.short_name     = $Object['short_name']
        $this.sis_user_id    = $Object['sis_user_id']
        $this.integration_id = $Object['integration_id']
        $this.sis_import_id  = $Object['sis_import_id']
        $this.login_id       = $Object['login_id']
    }
}

Update-TypeData -TypeName 'CanvasUser' -MemberType 'AliasProperty' -MemberName 'user_id' -Value 'id' -Force
