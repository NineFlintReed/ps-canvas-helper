# ps-canvas-helper
A Powershell module to assist in administering a Canvas LMS

Basic Powershell script module written for Powershell Core. _Should_ be cross platform, but have only tested on Windows.

Relies on the environment variables ```CANVAS_APIROOT``` and ```CANVAS_APIKEY``` to be set to work.

Currently available commands:

- Add-CanvasEnrollment
- Disable-CanvasEnrollment
- Enable-CanvasEnrollment
- Get-CanvasEnrollment
- Remove-CanvasEnrollment
- Get-CanvasAccount
- Get-CanvasCourse
- Set-CanvasCourse
- Get-CanvasRole
- Get-CanvasSection
- Get-CanvasTerm
- Get-CanvasUser
- New-CanvasUser
- Invoke-CanvasRequest

## Basic usage

Most of the Get-* functions can run standalone
```Powershell
# get all CURRENT non-deleted courses in the Canvas instance
Get-CanvasCourse

# or if you want to pull courses which have either been manually concluded or are in a previous term
Get-CanvasCourse -Completion Concluded

# can also get directly from id or sis_id, which ignores completion since it assumes you know what you're doing
Get-CanvasCourse -CourseId 5000
```

Most functions are designed to be work with the pipeline in a hopefully intuitive way.
This allows some interactions like the below, which will get the users associated with any course output by ```Get-CanvasCourse```
```Powershell
# get all users in a course
Get-CanvasCourse -CourseId 6969 | Get-CanvasUser

# don't know why you'd want this, but to get all the the courses of all of the users in a course
Get-CanvasCourse -CourseId 6969 | Get-CanvasUser | Get-CanvasCourse
```
```Powershell
# get enrollment information for a user
Get-CanvasUser -UserId 420 | Get-CanvasEnrollment
# OR
Get-CanvasEnrollments -UserId 420
```
Can also use various filters, using server-side query params when available and falling back to client-side when not.
E.g. get all of the student enrollments in all the non-blueprint courses in with term_id 164 in which some_teacher is a member.
```Powershell
Get-CanvasUser -Search 'some_teacher@school.com'
| Get-CanvasCourse -TermId 164 -CourseType Normal -State Published
| Get-CanvasEnrollment -Role Student
```

More practically, say you have a prac student starting at your school and you need to add them to all of their supervising teachers courses
```Powershell
$teacher = Get-CanvasUser -Search 'janedo@school.com'
$prac_student = Get-CanvasUser -Search 'johnsmith@school.com'
$teacher
| Get-CanvasCourse -CourseType Normal # aka not a blueprint
| Add-CanvasEnrollment -UserId $prac_student.id -Role Ta -State Invited
```

















































