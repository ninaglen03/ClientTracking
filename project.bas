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
	Private lblBack As Label

	Private Label1 As Label
	Private Label2 As Label
	Private Label3 As Label
	Private Label4 As Label
	Private Label5 As Label
	Private Label6 As Label
	Private Label7 As Label
	Private Label8 As Label
	Private Label9 As Label
	Private Label11 As Label
	Private Label14 As Label
	Private Label15 As Label

	'Status dropdowns (right side)
	Private Label10 As Spinner
	Private Label12 As Spinner
	Private Label13 As Spinner
	Private Label16 As Spinner

	'Status text labels (before each dropdown)
	Private Label17 As Label
	Private Label18 As Label
	Private Label19 As Label
	Private Label20 As Label

	Private Panel1 As Panel
	Private Panel2 As Panel
	Private Panel3 As Panel
	Private Panel4 As Panel
	Private Panel5 As Panel
	Private Panel6 As Panel
	Private Panel7 As Panel
	Private Panel8 As Panel
	Private Panel9 As Panel
	Private ProgressBar1 As ProgressBar

	Private CurrentProjectId As Int = 1
	Private TaskStatuses(4) As String
	Private TaskNames(4) As String
	Private TaskDueDays(4) As Int

	Private StatusOptions As List
	Private IsBindingUI As Boolean
End Sub

Sub Activity_Create(FirstTime As Boolean)
	Activity.LoadLayout("project")
	SetupStatusDropdowns
	InitializeTaskState
	LoadProject(CurrentProjectId)
End Sub

Sub Activity_Resume
End Sub

Sub Activity_Pause (UserClosed As Boolean)
End Sub

'Called by dashboard: CallSub2(project, "SetProjectId", projectId)
Public Sub SetProjectId(ProjectId As Int)
	CurrentProjectId = ProjectId
	If Activity.IsInitialized Then
		LoadProject(CurrentProjectId)
	End If
End Sub

Private Sub SetupStatusDropdowns
	StatusOptions.Initialize
	StatusOptions.AddAll(Array As String("Success", "Pending", "Delayed", "In progress"))

	Label10.Clear : Label10.AddAll(StatusOptions)
	Label12.Clear : Label12.AddAll(StatusOptions)
	Label13.Clear : Label13.AddAll(StatusOptions)
	Label16.Clear : Label16.AddAll(StatusOptions)
End Sub

Private Sub InitializeTaskState
	For i = 0 To 3
		TaskStatuses(i) = "Pending"
		TaskNames(i) = "Mini Task"
		TaskDueDays(i) = 0
	Next
End Sub

Private Sub LoadProject(ProjectId As Int)
	Select ProjectId
		Case 1
			ApplyProjectData( _
                "Executioner Mobile App", _
                "Build sign up, dashboard, project details, and status tracking.", _
                Array As String("Wire signup flow", "Design dashboard cards", "Project detail UI", "Connect API"), _
                Array As Int(2, 4, 6, 8), _
                Array As String("Success", "In progress", "Pending", "Pending"))

		Case 2
			ApplyProjectData( _
                "Calendar Module", _
                "Create event lists, reminders, and due-date views.", _
                Array As String("Monthly view", "Event editor", "Reminder trigger", "Sync tasks"), _
                Array As Int(1, 3, 5, 7), _
                Array As String("In progress", "Pending", "Pending", "Pending"))

		Case 3
			ApplyProjectData( _
                "To-Do Module", _
                "Implement task creation, filtering, and quick status updates.", _
                Array As String("Task CRUD", "Filter chips", "Priorities", "Search"), _
                Array As Int(2, 2, 4, 5), _
                Array As String("Success", "Success", "In progress", "Pending"))

		Case 4
			ApplyProjectData( _
                "Notifications Module", _
                "Deliver reminders and project update alerts.", _
                Array As String("Push setup", "In-app center", "Unread badges", "Mute settings"), _
                Array As Int(3, 4, 6, 9), _
                Array As String("Pending", "Delayed", "In progress", "Pending"))

		Case Else
			ApplyProjectData( _
                "Project " & ProjectId, _
                "No description yet.", _
                Array As String("Mini Task 1", "Mini Task 2", "Mini Task 3", "Mini Task 4"), _
                Array As Int(0, 0, 0, 0), _
                Array As String("Pending", "Pending", "Pending", "Pending"))
	End Select

	RefreshUI
End Sub

Private Sub ApplyProjectData(Title As String, Desc As String, Names() As String, Due() As Int, Statuses() As String)
	Label1.Text = Title
	Label2.Text = Desc

	For i = 0 To 3
		TaskNames(i) = Names(i)
		TaskDueDays(i) = Due(i)
		TaskStatuses(i) = NormalizeStatus(Statuses(i))
	Next
End Sub

Private Sub RefreshUI
	IsBindingUI = True

	'Task names
	Label3.Text = TaskNames(0)
	Label5.Text = TaskNames(1)
	Label6.Text = TaskNames(2)
	Label15.Text = TaskNames(3)

	'Due text
	Label7.Text = BuildDueText(TaskDueDays(0))
	Label8.Text = BuildDueText(TaskDueDays(1))
	Label9.Text = BuildDueText(TaskDueDays(2))
	Label14.Text = BuildDueText(TaskDueDays(3))

	'Dropdown selected values
	SetSpinnerStatus(Label10, TaskStatuses(0))
	SetSpinnerStatus(Label12, TaskStatuses(1))
	SetSpinnerStatus(Label13, TaskStatuses(2))
	SetSpinnerStatus(Label16, TaskStatuses(3))

	'Status text before dropdowns
	SetStatusTextLabel(Label17, TaskStatuses(0))
	SetStatusTextLabel(Label18, TaskStatuses(1))
	SetStatusTextLabel(Label19, TaskStatuses(2))
	SetStatusTextLabel(Label20, TaskStatuses(3))

	IsBindingUI = False
	UpdateProgress
End Sub

Private Sub BuildDueText(Days As Int) As String
	If Days <= 0 Then Return "No deadline"
	Return "Due in " & Days & " days"
End Sub

Private Sub NormalizeStatus(StatusValue As String) As String
	Dim s As String = StatusValue.Trim.ToLowerCase
	Select s
		Case "success", "done"
			Return "Success"
		Case "in progress", "doing"
			Return "In progress"
		Case "delayed"
			Return "Delayed"
		Case Else
			Return "Pending"
	End Select
End Sub

Private Sub SetSpinnerStatus(spn As Spinner, StatusValue As String)
	Dim target As String = NormalizeStatus(StatusValue)
	For i = 0 To StatusOptions.Size - 1
		If StatusOptions.Get(i) = target Then
			spn.SelectedIndex = i
			Exit
		End If
	Next
End Sub

Private Sub SetStatusTextLabel(lbl As Label, StatusValue As String)
	Dim s As String = NormalizeStatus(StatusValue)
	lbl.Text = s
	ApplyStatusTextColor(lbl, s)
End Sub

Private Sub ApplyStatusTextColor(lbl As Label, StatusValue As String)
	Select StatusValue
		Case "Success"
			lbl.TextColor = Colors.RGB(46, 125, 50)
		Case "Pending"
			lbl.TextColor = Colors.RGB(240, 170, 0)
		Case "Delayed"
			lbl.TextColor = Colors.RGB(244, 67, 54)
		Case "In progress"
			lbl.TextColor = Colors.RGB(33, 120, 255)
		Case Else
			lbl.TextColor = Colors.Gray
	End Select
End Sub

Private Sub UpdateProgress
	Dim successCount As Int = 0
	For i = 0 To 3
		If NormalizeStatus(TaskStatuses(i)) = "Success" Then successCount = successCount + 1
	Next

	Dim percent As Int = Round((successCount / 4) * 100)
	ProgressBar1.Progress = percent
	Label4.Text = percent & "%"
End Sub

Private Sub OnStatusChanged(TaskIndex As Int, Value As Object)
	If IsBindingUI Then Return

	TaskStatuses(TaskIndex) = NormalizeStatus(Value)

	Select TaskIndex
		Case 0
			SetStatusTextLabel(Label17, TaskStatuses(TaskIndex))
		Case 1
			SetStatusTextLabel(Label18, TaskStatuses(TaskIndex))
		Case 2
			SetStatusTextLabel(Label19, TaskStatuses(TaskIndex))
		Case 3
			SetStatusTextLabel(Label20, TaskStatuses(TaskIndex))
	End Select

	UpdateProgress
End Sub

Private Sub Label10_ItemClick (Position As Int, Value As Object)
	OnStatusChanged(0, Value)
End Sub

Private Sub Label12_ItemClick (Position As Int, Value As Object)
	OnStatusChanged(1, Value)
End Sub

Private Sub Label13_ItemClick (Position As Int, Value As Object)
	OnStatusChanged(2, Value)
End Sub

Private Sub Label16_ItemClick (Position As Int, Value As Object)
	OnStatusChanged(3, Value)
End Sub

Private Sub lblBack_Click
	Activity.Finish
End Sub