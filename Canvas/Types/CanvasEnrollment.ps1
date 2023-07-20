Set-StrictMode -Version 'Latest'

class CanvasEnrollment {
	[Nullable[Int]]$id
	[Nullable[Int]]$user_id
	[Nullable[Int]]$course_id
	[String]$type
	[Nullable[DateTime]]$created_at
	[Nullable[DateTime]]$updated_at
	[Nullable[Int]]$associated_user_id
	[Nullable[DateTime]]$start_at
	[Nullable[DateTime]]$end_at
	[Nullable[Int]]$course_section_id
	[Nullable[Int]]$root_account_id
	[Bool]$limit_privileges_to_course_section
	[String]$enrollment_state
	[String]$role
	[Nullable[Int]]$role_id
	[Nullable[DateTime]]$last_activity_at
	[Nullable[DateTime]]$last_attended_at
	[Nullable[Int]]$total_activity_time
	[String]$sis_import_id
	[String]$sis_account_id
	[String]$sis_course_id
	[String]$course_integration_id
	[String]$sis_section_id
	[String]$section_integration_id
	[String]$sis_user_id
	[String]$html_url

	CanvasEnrollment([Collections.IDictionary]$Object) {
		$this.id                                 = $Object['id']
		$this.user_id                            = $Object['user_id']
		$this.course_id                          = $Object['course_id']
		$this.type                               = $Object['type']
		$this.created_at                         = $Object['created_at']
		$this.updated_at                         = $Object['updated_at']
		$this.associated_user_id                 = $Object['associated_user_id']
		$this.start_at                           = $Object['start_at']
		$this.end_at                             = $Object['end_at']
		$this.course_section_id                  = $Object['course_section_id']
		$this.root_account_id                    = $Object['root_account_id']
		$this.limit_privileges_to_course_section = $Object['limit_privileges_to_course_section']
		$this.enrollment_state                   = $Object['enrollment_state']
		$this.role                               = $Object['role']
		$this.role_id                            = $Object['role_id']
		$this.last_activity_at                   = $Object['last_activity_at']
		$this.last_attended_at                   = $Object['last_attended_at']
		$this.total_activity_time                = $Object['total_activity_time']
		$this.sis_import_id                      = $Object['sis_import_id']
		$this.sis_account_id                     = $Object['sis_account_id']
		$this.sis_course_id                      = $Object['sis_course_id']
		$this.course_integration_id              = $Object['course_integration_id']
		$this.sis_section_id                     = $Object['sis_section_id']
		$this.section_integration_id             = $Object['section_integration_id']
		$this.sis_user_id                        = $Object['sis_user_id']
		$this.html_url                           = $Object['html_url']
    }
}

Update-TypeData -TypeName 'CanvasEnrollment' -MemberType 'AliasProperty' -MemberName 'enrollment_id' -Value 'id' -Force
Update-TypeData -TypeName 'CanvasEnrollment' -MemberType 'AliasProperty' -MemberName 'section_id' -Value 'course_section_id' -Force
Update-TypeData -TypeName 'CanvasEnrollment' -MemberType 'AliasProperty' -MemberName 'state' -Value 'enrollment_state' -Force


#Update-TypeData -TypeName 'CanvasEnrollment' -DefaultDisplayPropertySet 'enrollment_id','user_id','course_id','type','section_id','state' -Force



