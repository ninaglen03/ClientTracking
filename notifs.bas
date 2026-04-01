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

	Private Panel2 As Panel   'Main notifications box from your layout

	Private svNotifs As ScrollView
	Private NotificationItems As List
End Sub

Sub Activity_Create(FirstTime As Boolean)
	Activity.LoadLayout("notifs")

	ResetNavColors
	lblNotifs.TextColor = Colors.Blue

	InitDynamicNotifUI
	LoadNotifications
	RenderNotifications
End Sub

Sub Activity_Resume
	LoadNotifications
	RenderNotifications
End Sub

Sub Activity_Pause (UserClosed As Boolean)
End Sub

Private Sub InitDynamicNotifUI
	If Panel2.IsInitialized = False Then
		ToastMessageShow("Panel2 is missing in layout.", False)
		Return
	End If

	Panel2.RemoveAllViews

	svNotifs.Initialize(0)
	svNotifs.Color = Colors.Transparent

	Dim pad As Int = 8dip
	Panel2.AddView(svNotifs, pad, pad, Panel2.Width - (pad * 2), Panel2.Height - (pad * 2))
End Sub

Private Sub LoadNotifications
	NotificationItems.Initialize

	'Build notifications dynamically from AppState tasks.
	Dim tasks As List = AppState.GetTaskEvents
	If tasks.IsInitialized And tasks.Size > 0 Then
		For i = 0 To tasks.Size - 1
			Dim t As Map = tasks.Get(i)

			Dim taskName As String = GetMapString(t, "task_name", "Task")
			Dim status As String = NormalizeStatus(GetMapString(t, "status", "Pending"))
			Dim dueTicks As Long = GetMapLong(t, "due_ticks", DateTime.Now)

			Dim n As Map
			n.Initialize
			n.Put("date_ticks", dueTicks)
			n.Put("title", taskName)
			n.Put("message", BuildNotifMessage(taskName, status, dueTicks))
			n.Put("status", status)
			NotificationItems.Add(n)
		Next
	Else
		AddFallbackNotifications
	End If
End Sub

Private Sub AddFallbackNotifications
	Dim d0 As Long = DateTime.Now
	Dim d1 As Long = DateTime.Now + DateTime.TicksPerDay
	Dim d2 As Long = DateTime.Now + (2 * DateTime.TicksPerDay)

	AddNotification(d0, "Wire signup flow", "Task is pending review.", "Pending")
	AddNotification(d1, "Design dashboard", "Task is in progress.", "In progress")
	AddNotification(d2, "Connect API", "Task was delayed.", "Delayed")
End Sub

Private Sub AddNotification(dateTicks As Long, title As String, message As String, status As String)
	Dim n As Map
	n.Initialize
	n.Put("date_ticks", dateTicks)
	n.Put("title", title)
	n.Put("message", message)
	n.Put("status", NormalizeStatus(status))
	NotificationItems.Add(n)
End Sub

Private Sub BuildNotifMessage(taskName As String, status As String, dueTicks As Long) As String
	Dim dueText As String = FormatDate(dueTicks)

	Select status
		Case "Success"
			Return taskName & " marked success. Due " & dueText & "."
		Case "Pending"
			Return taskName & " is pending. Due " & dueText & "."
		Case "Delayed"
			Return taskName & " is delayed. Due " & dueText & "."
		Case "In progress"
			Return taskName & " is in progress. Due " & dueText & "."
		Case Else
			Return taskName & " updated. Due " & dueText & "."
	End Select
End Sub

Private Sub RenderNotifications
	If svNotifs.IsInitialized = False Then Return

	svNotifs.Panel.RemoveAllViews

	Dim y As Int = 4dip
	Dim lastDateHeader As String = ""

	If NotificationItems.Size = 0 Then
		Dim emptyLbl As Label
		emptyLbl.Initialize("")
		emptyLbl.Text = "No notifications yet."
		emptyLbl.TextSize = 16
		emptyLbl.TextColor = Colors.Gray
		svNotifs.Panel.AddView(emptyLbl, 6dip, y, svNotifs.Width - 12dip, 26dip)
		y = y + 32dip
	Else
		For i = 0 To NotificationItems.Size - 1
			Dim n As Map = NotificationItems.Get(i)
			Dim dt As Long = GetMapLong(n, "date_ticks", DateTime.Now)
			Dim dateHeader As String = HeaderDate(dt)

			If dateHeader <> lastDateHeader Then
				Dim lblDate As Label
				lblDate.Initialize("")
				lblDate.Text = dateHeader
				lblDate.TextSize = 16
				lblDate.TextColor = Colors.RGB(90, 90, 90)
				svNotifs.Panel.AddView(lblDate, 2dip, y, svNotifs.Width - 4dip, 24dip)
				y = y + 28dip
				lastDateHeader = dateHeader
			End If

			Dim card As Panel
			card.Initialize("")
			card.Color = Colors.White
			svNotifs.Panel.AddView(card, 0, y, svNotifs.Width, 68dip)

			Dim lblTitle As Label
			lblTitle.Initialize("")
			lblTitle.Text = GetMapString(n, "title", "Notification")
			lblTitle.TextSize = 15
			lblTitle.TextColor = Colors.RGB(65, 65, 65)
			card.AddView(lblTitle, 10dip, 8dip, card.Width - 110dip, 22dip)

			Dim lblMsg As Label
			lblMsg.Initialize("")
			lblMsg.Text = GetMapString(n, "message", "")
			lblMsg.TextSize = 12
			lblMsg.TextColor = Colors.Gray
			card.AddView(lblMsg, 10dip, 30dip, card.Width - 110dip, 28dip)

			Dim lblStatus As Label
			lblStatus.Initialize("")
			lblStatus.Text = NormalizeStatus(GetMapString(n, "status", "Pending"))
			lblStatus.TextSize = 13
			lblStatus.TextColor = StatusColor(lblStatus.Text)
			lblStatus.Gravity = Gravity.RIGHT + Gravity.CENTER_VERTICAL
			card.AddView(lblStatus, card.Width - 100dip, 20dip, 90dip, 22dip)

			Dim divider As Panel
			divider.Initialize("")
			divider.Color = Colors.RGB(236, 236, 236)
			svNotifs.Panel.AddView(divider, 0, y + 68dip, svNotifs.Width, 1dip)

			y = y + 76dip
		Next
	End If

	svNotifs.Panel.Height = Max(y + 8dip, svNotifs.Height + 1dip)
End Sub

Private Sub HeaderDate(t As Long) As String
	Return DateTime.GetYear(t) & "-" & Pad2(DateTime.GetMonth(t)) & "-" & Pad2(DateTime.GetDayOfMonth(t))
End Sub

Private Sub FormatDate(t As Long) As String
	Return DateTime.GetYear(t) & "-" & Pad2(DateTime.GetMonth(t)) & "-" & Pad2(DateTime.GetDayOfMonth(t))
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

Private Sub GetMapString(m As Map, key As String, defaultValue As String) As String
	If m.ContainsKey(key) Then Return "" & m.Get(key)
	Return defaultValue
End Sub

Private Sub GetMapLong(m As Map, key As String, defaultValue As Long) As Long
	If m.ContainsKey(key) = False Then Return defaultValue
	Try
		Return m.Get(key)
	Catch
		Return defaultValue
	End Try
End Sub

Private Sub GetMapInt(m As Map, key As String, defaultValue As Int) As Int
	If m.ContainsKey(key) = False Then Return defaultValue
	Try
		Return m.Get(key)
	Catch
		Return defaultValue
	End Try
End Sub

Private Sub Pad2(v As Int) As String
	If v < 10 Then Return "0" & v
	Return v
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

Private Sub lblNotifs_Click
End Sub

Sub ResetNavColors
	If lblDashboard.IsInitialized Then lblDashboard.TextColor = Colors.Gray
	If lblCalendar.IsInitialized Then lblCalendar.TextColor = Colors.Gray
	If lblToDo.IsInitialized Then lblToDo.TextColor = Colors.Gray
	If lblNotifs.IsInitialized Then lblNotifs.TextColor = Colors.Gray
End Sub