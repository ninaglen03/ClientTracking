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
End Sub

Sub Globals
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
	InitDashboard
End Sub

Sub Activity_Resume
	HighlightNav("dashboard")
End Sub

Sub Activity_Pause (UserClosed As Boolean)
End Sub

Private Sub InitDashboard
	'Set project progress values (replace with server values later)
	SetProjectProgress(ProgressBar1, Label12, 50)
	SetProjectProgress(ProgressBar2, Label21, 30)
	SetProjectProgress(ProgressBar3, Label22, 80)
	SetProjectProgress(ProgressBar4, Label23, 65)

	'Tag panels with project ids so one handler pattern can be reused
	Panel3.Tag = 1
	Panel4.Tag = 2
	Panel6.Tag = 3
	Panel7.Tag = 4

	HighlightNav("dashboard")
End Sub

Private Sub SetProjectProgress(pb As ProgressBar, percentLabel As Label, value As Int)
	If value < 0 Then value = 0
	If value > 100 Then value = 100
	pb.Progress = value
	percentLabel.Text = value & "%"
End Sub

Private Sub HighlightNav(active As String)
	ResetNavColors
	Select active.ToLowerCase
		Case "dashboard"
			lblDashboard.TextColor = Colors.Blue
		Case "calendar"
			lblCalendar.TextColor = Colors.Blue
		Case "todo"
			lblToDo.TextColor = Colors.Blue
		Case "notifs"
			lblNotifs.TextColor = Colors.Blue
		Case "profile"
			lblProfile.TextColor = Colors.Blue
	End Select
End Sub

Sub ResetNavColors
	lblDashboard.TextColor = Colors.Gray
	lblCalendar.TextColor = Colors.Gray
	lblToDo.TextColor = Colors.Gray
	lblNotifs.TextColor = Colors.Gray
	lblProfile.TextColor = Colors.Gray
End Sub

'Bottom nav clicks
Private Sub lblDashboard_Click
	HighlightNav("dashboard")
End Sub

Private Sub lblCalendar_Click
	HighlightNav("calendar")
	StartActivity(calendar)
End Sub

Private Sub lblToDo_Click
	HighlightNav("todo")
	StartActivity(todo)
End Sub

Private Sub lblNotifs_Click
	HighlightNav("notifs")
	StartActivity(notifs)
End Sub

Private Sub lblProfile_Click
	HighlightNav("profile")
	StartActivity(profile)
End Sub

'Project card clicks
Private Sub Panel3_Click
	OpenProject(Panel3.Tag)
End Sub

Private Sub Panel4_Click
	OpenProject(Panel4.Tag)
End Sub

Private Sub Panel6_Click
	OpenProject(Panel6.Tag)
End Sub

Private Sub Panel7_Click
	OpenProject(Panel7.Tag)
End Sub

Private Sub OpenProject(projectId As Int)
	StartActivity(project)
	CallSub2(project, "SetProjectId", projectId)
End Sub

'Optional placeholders for currently empty click subs
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