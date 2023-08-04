Set-StrictMode -Version Latest

# https://canvas.instructure.com/doc/api/enrollments.html#method.enrollments_api.create
# `limit_privileges_to_course_section`
#   if true, only allow the user to see and interact with users in same section
# `self_enrolled`
#   if true, allows student to drop the course 
# `notify`
#   if true, a notification will be sent to the enrolled user

function Add-CanvasEnrollment {
    [CmdletBinding()]
    [OutputType([CanvasEnrollment])]
    Param(
        [Parameter(ValueFromPipeline, DontShow)]
        [Parameter(ParameterSetName='PipedCourse_Role')]
        [Parameter(ParameterSetName='PipedCourse_RoleId')]
        [CanvasCourse]$PipedCourse,

        [Parameter(ValueFromPipeline, DontShow)]
        [Parameter(ParameterSetName='PipedUser_CourseId_Role')]
        [Parameter(ParameterSetName='PipedUser_SectionId_Role')]
        [Parameter(ParameterSetName='PipedUser_CourseId_RoleId')]
        [Parameter(ParameterSetName='PipedUser_SectionId_RoleId')]
        [CanvasUser]$PipedUser,

        [Parameter(ParameterSetName='PipedCourse_Role')]
        [Parameter(ParameterSetName='PipedCourse_RoleId')]
        [Parameter(ParameterSetName='UserId_CourseId_Role')]
        [Parameter(ParameterSetName='UserId_SectionId_Role')]
        [Parameter(ParameterSetName='UserId_CourseId_RoleId')]
        [Parameter(ParameterSetName='UserId_SectionId_RoleId')]
        [Int]$UserId,

        [Parameter(ParameterSetName='PipedUser_CourseId_Role')]
        [Parameter(ParameterSetName='PipedUser_CourseId_RoleId')]
        [Parameter(ParameterSetName='UserId_CourseId_RoleId')]
        [Parameter(ParameterSetName='UserId_CourseId_Role')]
        [Int]$CourseId,

        [Parameter(ParameterSetName='PipedUser_SectionId_Role')]
        [Parameter(ParameterSetName='PipedUser_SectionId_RoleId')]
        [Parameter(ParameterSetName='UserId_SectionId_Role')]
        [Parameter(ParameterSetName='UserId_SectionId_RoleId')]
        [Int]$SectionId,

        [Parameter(ParameterSetName='PipedUser_CourseId_Role')]
        [Parameter(ParameterSetName='PipedUser_SectionId_Role')]
        [Parameter(ParameterSetName='PipedCourse_Role')]
        [Parameter(ParameterSetName='UserId_CourseId_Role')]
        [Parameter(ParameterSetName='UserId_SectionId_Role')]
        [ValidateSet('Student','Teacher','Ta','Observer','Designer')]
        [String]$Role,

        [Parameter(ParameterSetName='PipedUser_CourseId_RoleId')]
        [Parameter(ParameterSetName='PipedUser_SectionId_RoleId')]
        [Parameter(ParameterSetName='PipedCourse_RoleId')]
        [Parameter(ParameterSetName='UserId_CourseId_RoleId')]
        [Parameter(ParameterSetName='UserId_SectionId_RoleId')]
        [Int]$RoleId,

        [ValidateSet('Active','Invited','Inactive')]
        [String]$State
    )
    
    process
    {
        ($user_id, $enrollment, $uri) = switch($PSCmdlet.ParameterSetName) {
            'PipedUser_CourseId_RoleId'  {( $PipedUser.user_id, @{ role_id = $RoleId }          , "/api/v1/courses/$CourseId/enrollments"                 )}
            'PipedUser_CourseId_Role'    {( $PipedUser.user_id, @{ type = $Role + 'Enrollment' }, "/api/v1/courses/$CourseId/enrollments"                 )}
            'PipedUser_SectionId_RoleId' {( $PipedUser.user_id, @{ role_id = $RoleId }          , "/api/v1/sections/$SectionId/enrollments"               )}
            'PipedUser_SectionId_Role'   {( $PipedUser.user_id, @{ type = $Role + 'Enrollment' }, "/api/v1/sections/$SectionId/enrollments"               )}
            'UserId_CourseId_RoleId'     {( $UserId           , @{ role_id = $RoleId }          , "/api/v1/courses/$CourseId/enrollments"                 )}
            'UserId_SectionId_RoleId'    {( $UserId           , @{ role_id = $RoleId }          , "/api/v1/sections/$SectionId/enrollments"               )}
            'PipedCourse_RoleId'         {( $UserId           , @{ role_id = $RoleId }          , "/api/v1/courses/$($PipedCourse.course_id)/enrollments" )}
            'UserId_CourseId_Role'       {( $UserId           , @{ type = $Role + 'Enrollment' }, "/api/v1/courses/$CourseId/enrollments"                 )}
            'UserId_SectionId_Role'      {( $UserId           , @{ type = $Role + 'Enrollment' }, "/api/v1/sections/$SectionId/enrollments"               )}
            'PipedCourse_Role'           {( $UserId           , @{ type = $Role + 'Enrollment' }, "/api/v1/courses/$($PipedCourse.course_id)/enrollments" )}
            default {
                throw "No handler found for parameter set $_"
            }
        }

        $enrollment['enrollment_state'] = switch($PSBoundParameters.ContainsKey('State')) {
            $true  { $State.ToLower() }
            $false { 'active'         }
        }

        $enrollment['user_id'] = $user_id

        $result = Invoke-CanvasRequest 'POST' $uri @{enrollment = $enrollment}
        [CanvasEnrollment]::new($result)
    }
}