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
	Private Label10 As Label
	Private Label11 As Label
	Private Label3 As Label
	Private Label4 As Label
	Private Label5 As Label
	Private Label6 As Label
	Private Label7 As Label
	Private Label8 As Label
	Private Label9 As Label
	Private Panel1 As Panel
	Private Panel2 As Panel
	Private Panel5 As Panel
End Sub

Sub Activity_Create(FirstTime As Boolean)
	Activity.LoadLayout("notifs")

	ResetNavColors
	lblNotifs.TextColor = Colors.Blue
End Sub

Sub Activity_Resume

End Sub

Sub Activity_Pause (UserClosed As Boolean)

End Sub

Private Sub lblDashboard_Click
	StartActivity(dashboard)
End Sub

Private Sub lblCalendar_Click
	StartActivity(calendar)
End Sub

Private Sub lblToDo_Click
	StartActivity(todo)
End Sub

Sub ResetNavColors
	lblDashboard.TextColor = Colors.Gray
	lblCalendar.TextColor = Colors.Gray
	lblToDo.TextColor = Colors.Gray
	lblNotifs.TextColor = Colors.Gray
End Sub