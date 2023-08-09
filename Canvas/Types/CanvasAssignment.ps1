
class CanvasAssignment {
    [Nullable[Int]]$allowed_attempts
    [Nullable[Int]]$annotatable_attachment_id
    [Nullable[Bool]]$anonymize_students
    [Nullable[Bool]]$anonymous_grading
    [Nullable[Bool]]$anonymous_instructor_annotations
    [Nullable[Bool]]$anonymous_peer_reviews
    [String]$assignment_group_id
    [Nullable[Bool]]$automatic_peer_reviews
    [Nullable[Bool]]$can_duplicate
    [String]$course_id
    [Nullable[Datetime]]$created_at
    [String]$description
    [Nullable[DateTime]]$due_at
    [Nullable[Bool]]$due_date_required
    [Nullable[Int]]$final_grader_id
    [Nullable[Bool]]$graded_submissions_exist
    [Nullable[Bool]]$graders_anonymous_to_graders
    [Nullable[Bool]]$grader_comments_visible_to_graders
    [Nullable[Int]]$grader_count
    [Nullable[Bool]]$grader_names_visible_to_final_grader
    [Nullable[Bool]]$grade_group_students_individually
    [Nullable[Int]]$grading_standard_id
    [String]$grading_type
    [Nullable[Int]]$group_category_id
    [Nullable[Bool]]$has_overrides
    [Nullable[Bool]]$has_submitted_submissions
    [Nullable[Bool]]$hide_in_gradebook
    [String]$html_url
    [Nullable[Int]]$id
    [Nullable[Bool]]$important_dates
    [Nullable[Int]]$integration_id
    [Nullable[Bool]]$intra_group_peer_reviews
    [Nullable[Bool]]$in_closed_grading_period
    [Nullable[Bool]]$is_master_course_master_content
    [Nullable[Bool]]$is_quiz_assignment
    [Nullable[Bool]]$locked_for_user
    [Nullable[DateTime]]$lock_at
    [String]$lti_context_id
    [Nullable[Int]]$max_name_length
    [Nullable[Bool]]$moderated_grading
    [Nullable[Bool]]$muted
    [String]$name
    [Nullable[Int]]$needs_grading_count
    [Nullable[Bool]]$omit_from_final_grade
    [Nullable[Bool]]$only_visible_to_overrides
    [Nullable[Int]]$original_assignment_id
    [String]$original_assignment_name
    [Nullable[Int]]$original_course_id
    [Nullable[Int]]$original_lti_resource_link_id
    [Nullable[Int]]$original_quiz_id
    [Nullable[Bool]]$peer_reviews
    [Nullable[Double]]$points_possible
    [Nullable[Int]]$position
    [Nullable[Bool]]$post_manually
    [Nullable[Bool]]$post_to_sis
    [Nullable[Bool]]$published
    [Nullable[Bool]]$require_lockdown_browser
    [Nullable[Bool]]$restricted_by_master_course
    [Nullable[Bool]]$restrict_quantitative_data
    [String]$secure_params
    [String]$sis_assignment_id
    [String]$submissions_download_url
    [Nullable[DateTime]]$unlock_at
    [Nullable[Bool]]$unpublishable
    [Nullable[Datetime]]$updated_at
    [String]$workflow_state

    CanvasAssignment([Collections.IDictionary]$Object) {
        $this.allowed_attempts                     = $Object['allowed_attempts']
        $this.annotatable_attachment_id            = $Object['annotatable_attachment_id']
        $this.anonymize_students                   = $Object['anonymize_students']
        $this.anonymous_grading                    = $Object['anonymous_grading']
        $this.anonymous_instructor_annotations     = $Object['anonymous_instructor_annotations']
        $this.anonymous_peer_reviews               = $Object['anonymous_peer_reviews']
        $this.assignment_group_id                  = $Object['assignment_group_id']
        $this.automatic_peer_reviews               = $Object['automatic_peer_reviews']
        $this.can_duplicate                        = $Object['can_duplicate']
        $this.course_id                            = $Object['course_id']
        $this.created_at                           = $Object['created_at']
        $this.description                          = $Object['description']
        $this.due_at                               = $Object['due_at']
        $this.due_date_required                    = $Object['due_date_required']
        $this.final_grader_id                      = $Object['final_grader_id']
        $this.graded_submissions_exist             = $Object['graded_submissions_exist']
        $this.graders_anonymous_to_graders         = $Object['graders_anonymous_to_graders']
        $this.grader_comments_visible_to_graders   = $Object['grader_comments_visible_to_graders']
        $this.grader_count                         = $Object['grader_count']
        $this.grader_names_visible_to_final_grader = $Object['grader_names_visible_to_final_grader']
        $this.grade_group_students_individually    = $Object['grade_group_students_individually']
        $this.grading_standard_id                  = $Object['grading_standard_id']
        $this.grading_type                         = $Object['grading_type']
        $this.group_category_id                    = $Object['group_category_id']
        $this.has_overrides                        = $Object['has_overrides']
        $this.has_submitted_submissions            = $Object['has_submitted_submissions']
        $this.hide_in_gradebook                    = $Object['hide_in_gradebook']
        $this.html_url                             = $Object['html_url']
        $this.id                                   = $Object['id']
        $this.important_dates                      = $Object['important_dates']
        $this.integration_id                       = $Object['integration_id']
        $this.intra_group_peer_reviews             = $Object['intra_group_peer_reviews']
        $this.in_closed_grading_period             = $Object['in_closed_grading_period']
        $this.is_master_course_master_content      = $Object['is_master_course_master_content']
        $this.is_quiz_assignment                   = $Object['is_quiz_assignment']
        $this.locked_for_user                      = $Object['locked_for_user']
        $this.lock_at                              = $Object['lock_at']
        $this.lti_context_id                       = $Object['lti_context_id']
        $this.max_name_length                      = $Object['max_name_length']
        $this.moderated_grading                    = $Object['moderated_grading']
        $this.muted                                = $Object['muted']
        $this.name                                 = $Object['name']
        $this.needs_grading_count                  = $Object['needs_grading_count']
        $this.omit_from_final_grade                = $Object['omit_from_final_grade']
        $this.only_visible_to_overrides            = $Object['only_visible_to_overrides']
        $this.original_assignment_id               = $Object['original_assignment_id']
        $this.original_assignment_name             = $Object['original_assignment_name']
        $this.original_course_id                   = $Object['original_course_id']
        $this.original_lti_resource_link_id        = $Object['original_lti_resource_link_id']
        $this.original_quiz_id                     = $Object['original_quiz_id']
        $this.peer_reviews                         = $Object['peer_reviews']
        $this.points_possible                      = $Object['points_possible']
        $this.position                             = $Object['position']
        $this.post_manually                        = $Object['post_manually']
        $this.post_to_sis                          = $Object['post_to_sis']
        $this.published                            = $Object['published']
        $this.require_lockdown_browser             = $Object['require_lockdown_browser']
        $this.restricted_by_master_course          = $Object['restricted_by_master_course']
        $this.restrict_quantitative_data           = $Object['restrict_quantitative_data']
        $this.secure_params                        = $Object['secure_params']
        $this.sis_assignment_id                    = $Object['sis_assignment_id']
        $this.submissions_download_url             = $Object['submissions_download_url']
        $this.unlock_at                            = $Object['unlock_at']
        $this.unpublishable                        = $Object['unpublishable']
        $this.updated_at                           = $Object['updated_at']
        $this.workflow_state                       = $Object['workflow_state']
    }
}


Update-TypeData -TypeName 'CanvasAssignment' -MemberType 'AliasProperty' -MemberName 'assignment_id' -Value 'id' -Force



