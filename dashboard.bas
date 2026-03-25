B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Activity
Version=13.4
@EndOfDesignText@
#Region  Activity Attributes 
	#FullScreen: False
	#IncludeTitle: False
#End Region

Sub Process_Globals
	'These global variables will be declared once when the application starts.
	'These variables can be accessed from all modules.

End Sub

Sub Globals
	'These global variables will be redeclared each time the activity is created.
	'These variables can only be accessed from this module.

    Private lblDashboard As Label
    Private lblCalendar As Label
    Private lblToDo As Label
    Private lblNotifs As Label
	Private lblProfile As Label
	Private Label11 As Label
	Private Label12 As Label
	Private Label13 As Label
	Private Label14 As Label
	Private Label15 As Label
	Private Label16 As Label
	Private Label17 As Label
	Private Label18 As Label
	Private Label19 As Label
	Private Label20 As Label
	Private Label21 As Label
	Private Label22 As Label
	Private Label23 As Label
	Private Label3 As Label
	Private Label4 As Label
	Private Label5 As Label

	Private Label9 As Label
	Private Panel1 As Panel
	Private Panel2 As Panel
	Private Panel3 As Panel
	Private Panel4 As Panel
	Private Panel5 As Panel
	Private Panel6 As Panel
	Private Panel7 As Panel
	Private ProgressBar1 As ProgressBar
	Private ProgressBar2 As ProgressBar
	Private ProgressBar3 As ProgressBar
	Private ProgressBar4 As ProgressBar
End Sub

Sub Activity_Create(FirstTime As Boolean)
	Activity.LoadLayout("dashboard")

	ResetNavColors
	lblDashboard.TextColor = Colors.Blue
End Sub

Sub Activity_Resume

End Sub

Sub Activity_Pause (UserClosed As Boolean)

End Sub

Private Sub Label8_Click
	
End Sub

Private Sub Label7_Click
	
End Sub

Private Sub Button1_Click

End Sub

Private Sub Label10_Click
	
End Sub

Private Sub Label1_Click
	
End Sub

Private Sub lblCalendar_Click
	StartActivity(calendar)
End Sub

Private Sub lblToDo_Click
	StartActivity(todo)
End Sub

Private Sub lblNotifs_Click
	StartActivity(notifs)
End Sub

Private Sub lblProfile_Click
    StartActivity(profile)
	'Drawer.LeftOpen = True
End Sub

Sub ResetNavColors
	lblDashboard.TextColor = Colors.Gray
	lblCalendar.TextColor = Colors.Gray
	lblToDo.TextColor = Colors.Gray
	lblNotifs.TextColor = Colors.Gray
End Sub

Private Sub Panel3_Click
	StartActivity(project)
End Sub