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

	Private Panel2 As Panel

	Private svTasks As ScrollView
	Private TaskItems As List
End Sub

Sub Activity_Create(FirstTime As Boolean)
	Activity.LoadLayout("todo")

	ResetNavColors
	lblToDo.TextColor = Colors.Blue

	InitPanel2UI
	LoadTasksFromState
	RenderTaskList
End Sub

Sub Activity_Resume
	LoadTasksFromState
	RenderTaskList
End Sub

Sub Activity_Pause (UserClosed As Boolean)
End Sub

Private Sub InitPanel2UI
	Panel2.RemoveAllViews

	svTasks.Initialize(0)
	svTasks.Color = Colors.Transparent

	Dim pad As Int = 8dip
	Panel2.AddView(svTasks, pad, pad, Panel2.Width - (pad * 2), Panel2.Height - (pad * 2))
End Sub

Private Sub LoadTasksFromState
	TaskItems.Initialize

	Dim src As List = AppState.GetTaskEvents
	If src.IsInitialized And src.Size > 0 Then
		For i = 0 To src.Size - 1
			Dim m As Map = src.Get(i)
			Dim c As Map
			c.Initialize
			c.Put("project_id", GetMapInt(m, "project_id", 0))
			c.Put("task_index", GetMapInt(m, "task_index", i + 1))
			c.Put("task_name", GetMapString(m, "task_name", "Task"))
			c.Put("status", NormalizeStatus(GetMapString(m, "status", "Pending")))
			c.Put("due_ticks", GetMapLong(m, "due_ticks", DateTime.Now))
			TaskItems.Add(c)
		Next
	Else
		AddFallbackTasks
	End If
End Sub

Private Sub AddFallbackTasks
	Dim names() As String = Array As String("Wire signup flow", "Design dashboard", "Project detail UI", "Connect API")
	Dim statuses() As String = Array As String("Success", "Pending", "In progress", "Delayed")
	Dim daysFromNow() As Int = Array As Int(2, 4, 6, 8)

	For i = 0 To names.Length - 1
		Dim m As Map
		m.Initialize
		m.Put("project_id", 1)
		m.Put("task_index", i + 1)
		m.Put("task_name", names(i))
		m.Put("status", statuses(i))
		m.Put("due_ticks", DateTime.Now + (daysFromNow(i) * DateTime.TicksPerDay))
		TaskItems.Add(m)
	Next

	AppState.SetTaskEvents(TaskItems)
End Sub

Private Sub RenderTaskList
	svTasks.Panel.RemoveAllViews

	Dim y As Int = 2dip

	Dim title As Label
	title.Initialize("")
	title.Text = "Activities"
	title.TextSize = 18
	title.TextColor = Colors.Black
	svTasks.Panel.AddView(title, 4dip, y, svTasks.Width - 8dip, 32dip)
	y = y + 38dip

	For i = 0 To TaskItems.Size - 1
		Dim task As Map = TaskItems.Get(i)

		Dim row As Panel
		row.Initialize("")
		row.Color = Colors.White
		svTasks.Panel.AddView(row, 0, y, svTasks.Width, 76dip)

		Dim lblTask As Label
		lblTask.Initialize("")
		lblTask.Text = GetMapString(task, "task_name", "Task")
		lblTask.TextColor = Colors.RGB(70, 70, 70)
		lblTask.TextSize = 15
		row.AddView(lblTask, 8dip, 8dip, row.Width - 120dip, 24dip)

		Dim lblDue As Label
		lblDue.Initialize("")
		lblDue.Text = "Due: " & FormatDate(GetMapLong(task, "due_ticks", DateTime.Now))
		lblDue.TextColor = Colors.Gray
		lblDue.TextSize = 12
		row.AddView(lblDue, 8dip, 34dip, row.Width - 120dip, 20dip)

		Dim lblStatus As Label
		lblStatus.Initialize("lblStatusDyn")
		lblStatus.Tag = i
		lblStatus.Text = NormalizeStatus(GetMapString(task, "status", "Pending"))
		lblStatus.TextColor = StatusColor(lblStatus.Text)
		lblStatus.TextSize = 14
		lblStatus.Gravity = Gravity.RIGHT + Gravity.CENTER_VERTICAL
		row.AddView(lblStatus, row.Width - 110dip, 20dip, 100dip, 24dip)

		Dim divider As Panel
		divider.Initialize("")
		divider.Color = Colors.RGB(235, 235, 235)
		svTasks.Panel.AddView(divider, 0, y + 76dip, svTasks.Width, 1dip)

		y = y + 84dip
	Next

	If TaskItems.Size = 0 Then
		Dim emptyLbl As Label
		emptyLbl.Initialize("")
		emptyLbl.Text = "No activities yet."
		emptyLbl.TextColor = Colors.Gray
		emptyLbl.TextSize = 15
		svTasks.Panel.AddView(emptyLbl, 4dip, y, svTasks.Width - 8dip, 24dip)
		y = y + 30dip
	End If

	svTasks.Panel.Height = Max(y + 8dip, svTasks.Height + 1dip)
End Sub

Private Sub lblStatusDyn_Click
	Dim lbl As Label = Sender
	Dim idx As Int = lbl.Tag
	If idx < 0 Or idx >= TaskItems.Size Then Return

	Dim t As Map = TaskItems.Get(idx)
	Dim newStatus As String = NextStatus(NormalizeStatus(GetMapString(t, "status", "Pending")))
	t.Put("status", newStatus)
	TaskItems.Set(idx, t)

	AppState.SetTaskEvents(TaskItems)
	RenderTaskList
End Sub

Private Sub NextStatus(currentStatus As String) As String
	Select currentStatus
		Case "Pending"
			Return "In progress"
		Case "In progress"
			Return "Success"
		Case "Success"
			Return "Delayed"
		Case Else
			Return "Pending"
	End Select
End Sub

Private Sub NormalizeStatus(v As String) As String
	Dim s As String = v.Trim.ToLowerCase
	Select s
		Case "success", "done"
			Return "Success"
		Case "pending", "todo", "to do"
			Return "Pending"
		Case "delayed"
			Return "Delayed"
		Case "in progress", "doing"
			Return "In progress"
		Case Else
			Return "Pending"
	End Select
End Sub

Private Sub StatusColor(status As String) As Int
	Select status
		Case "Success"
			Return Colors.RGB(46, 170, 85)
		Case "Pending"
			Return Colors.RGB(240, 170, 0)
		Case "Delayed"
			Return Colors.RGB(244, 67, 54)
		Case "In progress"
			Return Colors.RGB(33, 120, 255)
		Case Else
			Return Colors.Gray
	End Select
End Sub

Private Sub FormatDate(t As Long) As String
	Return DateTime.GetYear(t) & "-" & Pad2(DateTime.GetMonth(t)) & "-" & Pad2(DateTime.GetDayOfMonth(t))
End Sub

Private Sub Pad2(v As Int) As String
	If v < 10 Then Return "0" & v
	Return v
End Sub

Private Sub GetMapString(m As Map, key As String, defaultValue As String) As String
	If m.ContainsKey(key) Then Return "" & m.Get(key)
	Return defaultValue
End Sub

Private Sub GetMapInt(m As Map, key As String, defaultValue As Int) As Int
	If m.ContainsKey(key) = False Then Return defaultValue
	Try
		Return m.Get(key)
	Catch
		Return defaultValue
	End Try
End Sub

Private Sub GetMapLong(m As Map, key As String, defaultValue As Long) As Long
	If m.ContainsKey(key) = False Then Return defaultValue
	Try
		Return m.Get(key)
	Catch
		Return defaultValue
	End Try
End Sub

Private Sub lblDashboard_Click
	StartActivity(dashboard)
End Sub

Private Sub lblCalendar_Click
	StartActivity(calendar)
End Sub

Private Sub lblNotifs_Click
	StartActivity(notifs)
End Sub

Private Sub lblToDo_Click
End Sub

Sub ResetNavColors
	If lblDashboard.IsInitialized Then lblDashboard.TextColor = Colors.Gray
	If lblCalendar.IsInitialized Then lblCalendar.TextColor = Colors.Gray
	If lblToDo.IsInitialized Then lblToDo.TextColor = Colors.Gray
	If lblNotifs.IsInitialized Then lblNotifs.TextColor = Colors.Gray
End Sub