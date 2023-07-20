Set-StrictMode -Version 'Latest'

class CanvasCourse {
    [Nullable[Int]]$id
    [String]$name
    [Nullable[Int]]$account_id
    [String]$uuid
    [Nullable[DateTime]]$start_at
    [Nullable[Int]]$grading_standard_id
    [Nullable[Bool]]$is_public
    [Nullable[DateTime]]$created_at
    [String]$course_code
    [String]$default_view
    [Nullable[Int]]$root_account_id
    [Nullable[Int]]$enrollment_term_id
    [String]$license
    [String]$grade_passback_setting
    [Nullable[DateTime]]$end_at
    [Nullable[Bool]]$public_syllabus
    [Nullable[Bool]]$public_syllabus_to_auth
    [Nullable[Int]]$storage_quota_mb
    [Nullable[Bool]]$is_public_to_auth_users
    [Nullable[Bool]]$homeroom_course
    [String]$course_color
    [String]$friendly_name
    [Nullable[Bool]]$hide_final_grades
    [Nullable[Bool]]$apply_assignment_group_weights
    [String]$time_zone
    [Nullable[Bool]]$blueprint
    [Nullable[Bool]]$template
    [String]$sis_course_id
    [Nullable[Int]]$sis_import_id
    [String]$integration_id
    [String]$workflow_state
    [Nullable[Bool]]$restrict_enrollments_to_course_dates

    [Nullable[Bool]]$concluded

    CanvasCourse([Collections.IDictionary]$Object) {
        $this.id                                   = $Object['id']
        $this.name                                 = $Object['name']
        $this.account_id                           = $Object['account_id']
        $this.uuid                                 = $Object['uuid']
        $this.start_at                             = $Object['start_at']
        $this.grading_standard_id                  = $Object['grading_standard_id']
        $this.is_public                            = $Object['is_public']
        $this.created_at                           = $Object['created_at']
        $this.course_code                          = $Object['course_code']
        $this.default_view                         = $Object['default_view']
        $this.root_account_id                      = $Object['root_account_id']
        $this.enrollment_term_id                   = $Object['enrollment_term_id']
        $this.license                              = $Object['license']
        $this.grade_passback_setting               = $Object['grade_passback_setting']
        $this.end_at                               = $Object['end_at']
        $this.public_syllabus                      = $Object['public_syllabus']
        $this.public_syllabus_to_auth              = $Object['public_syllabus_to_auth']
        $this.storage_quota_mb                     = $Object['storage_quota_mb']
        $this.is_public_to_auth_users              = $Object['is_public_to_auth_users']
        $this.homeroom_course                      = $Object['homeroom_course']
        $this.course_color                         = $Object['course_color']
        $this.friendly_name                        = $Object['friendly_name']
        $this.hide_final_grades                    = $Object['hide_final_grades']
        $this.apply_assignment_group_weights       = $Object['apply_assignment_group_weights']
        $this.time_zone                            = $Object['time_zone']
        $this.blueprint                            = $Object['blueprint']
        $this.template                             = $Object['template']
        $this.sis_course_id                        = $Object['sis_course_id']
        $this.sis_import_id                        = $Object['sis_import_id']
        $this.integration_id                       = $Object['integration_id']
        $this.workflow_state                       = $Object['workflow_state']
        $this.restrict_enrollments_to_course_dates = $Object['restrict_enrollments_to_course_dates']
        $this.concluded                            = $Object['concluded']
    }
}


Update-TypeData -TypeName 'CanvasCourse' -MemberType 'AliasProperty' -MemberName 'course_id' -Value 'id' -Force
Update-TypeData -TypeName 'CanvasCourse' -MemberType 'AliasProperty' -MemberName 'term_id' -Value 'enrollment_term_id' -Force

