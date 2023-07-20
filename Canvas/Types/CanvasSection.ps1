class CanvasSection {
	[Nullable[Int]]$id                 
	[Nullable[Int]]$course_id          
	[String]$name                      
	[Nullable[DateTime]]$start_at      
	[Nullable[DateTime]]$end_at        
	[Nullable[DateTime]]$created_at    
	[Nullable[Int]]$nonxlist_course_id 
	[String]$sis_section_id            
	[String]$sis_course_id             
	[String]$integration_id            
	[String]$sis_import_id             

	CanvasSection([Collections.IDictionary]$Object) {
		$this.id = $Object['id']
		$this.course_id = $Object['course_id']
		$this.name = $Object['name']
		$this.start_at = $Object['start_at']
		$this.end_at = $Object['end_at']
		$this.created_at = $Object['created_at']
		$this.nonxlist_course_id = $Object['nonxlist_course_id']
		$this.sis_section_id = $Object['sis_section_id']
		$this.sis_course_id = $Object['sis_course_id']
		$this.integration_id = $Object['integration_id']
		$this.sis_import_id = $Object['sis_import_id']
	}
}

Update-TypeData -TypeName 'CanvasSection' -MemberType 'AliasProperty' -MemberName 'section_id' -Value 'id' -Force




