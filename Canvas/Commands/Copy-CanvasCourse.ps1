# todo add option to wait until complete (poll returned obj)
# todo add more options for WHAT to copy
function Copy-CanvasCourse {
    Param(
        [ValidateRange(1,999999)]
        [Nullable[Int]]$SourceCourseId,
        
        [ValidateRange(1,999999)]
        [Nullable[Int]]$DestinationCourseId
    )

    $params = @{
        Endpoint = "/api/v1/courses/$DestinationCourseId/content_migrations"
        Body = @{
            migration_type = 'course_copy_importer'
            settings = @{
                source_course_id = $SourceCourseId
                import_blueprint_settings = $true
                remove_dates = $true
            }
        }
    }
    
    canvas post @params

}