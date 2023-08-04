Set-StrictMode -Version 'Latest'
# testing
class CanvasAccount {
    [Nullable[Int]]$id
    [String]$name
    [String]$workflow_state
    [Nullable[Int]]$parent_account_id
    [Nullable[Int]]$root_account_id
    [String]$uuid
    [Nullable[Int]]$default_storage_quota_mb
    [Nullable[Int]]$default_user_storage_quota_mb
    [Nullable[Int]]$default_group_storage_quota_mb
    [String]$default_time_zone
    [String]$sis_account_id
    [String]$sis_import_id
    [Nullable[Int]]$integration_id
    [Nullable[Int]]$course_template_id

    CanvasAccount([Collections.IDictionary]$Object) {
        $this.id                             = $Object['id']
        $this.name                           = $Object['name']
        $this.workflow_state                 = $Object['workflow_state']
        $this.parent_account_id              = $Object['parent_account_id']
        $this.root_account_id                = $Object['root_account_id']
        $this.uuid                           = $Object['uuid']
        $this.default_storage_quota_mb       = $Object['default_storage_quota_mb']
        $this.default_user_storage_quota_mb  = $Object['default_user_storage_quota_mb']
        $this.default_group_storage_quota_mb = $Object['default_group_storage_quota_mb']
        $this.default_time_zone              = $Object['default_time_zone']
        $this.sis_account_id                 = $Object['sis_account_id']
        $this.sis_import_id                  = $Object['sis_import_id']
        $this.integration_id                 = $Object['integration_id']
        $this.course_template_id             = $Object['course_template_id']
    }
}


Update-TypeData -TypeName 'CanvasAccount' -MemberType 'AliasProperty' -MemberName 'account_id' -Value 'id' -Force



