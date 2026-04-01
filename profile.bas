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
	'Existing views from your profile layout
	Private Label1 As Label          'hamburger button (three lines)
	Private Panel1 As Panel

	'Drawer views
	Private pnlDrawer As Panel
	Private pnlOverlay As Panel
	Private pnlEdge As Panel

	'Drawer state
	Private DrawerOpen As Boolean
	Private DrawerWidth As Int

	'Drag state
	Private IsDragging As Boolean
	Private DragStartRawX As Float
	Private DrawerStartLeft As Int
End Sub

Sub Activity_Create(FirstTime As Boolean)
	Activity.LoadLayout("profile")
	SetupDrawer
End Sub

Sub Activity_Resume
End Sub

Sub Activity_Pause (UserClosed As Boolean)
End Sub

Private Sub SetupDrawer
	DrawerOpen = False
	DrawerWidth = 280dip
	If DrawerWidth > 80%x Then DrawerWidth = 80%x

	'Overlay
	pnlOverlay.Initialize("pnlOverlay")
	pnlOverlay.Color = 0x00000000
	pnlOverlay.Visible = False
	Activity.AddView(pnlOverlay, 0, 0, 100%x, 100%y)

	'Drawer panel (starts hidden at left)
	pnlDrawer.Initialize("pnlDrawer")
	pnlDrawer.Color = Colors.White
	Activity.AddView(pnlDrawer, -DrawerWidth, 0, DrawerWidth, 100%y)

	'Left-edge swipe zone
	pnlEdge.Initialize("pnlEdge")
	pnlEdge.Color = Colors.Transparent
	Activity.AddView(pnlEdge, 0, 0, 18dip, 100%y)

	'Drawer menu items
	Dim topPos As Int = 40dip
	Dim itemH As Int = 48dip

	AddDrawerItem("miDash", "Dashboard", topPos, itemH)
	AddDrawerItem("miCal", "Calendar", topPos + itemH, itemH)
	AddDrawerItem("miTodo", "To Do", topPos + itemH * 2, itemH)
	AddDrawerItem("miNotifs", "Notifications", topPos + itemH * 3, itemH)
	Dim miProfile As Label = AddDrawerItem("miProfile", "Profile", topPos + itemH * 4, itemH)

	'Highlight current screen
	miProfile.TextColor = Colors.RGB(40, 90, 220)
End Sub

Private Sub AddDrawerItem(EventName As String, TextValue As String, TopValue As Int, HeightValue As Int) As Label
	Dim lbl As Label
	lbl.Initialize(EventName)
	lbl.Text = "   " & TextValue
	lbl.TextSize = 16
	lbl.Gravity = Gravity.CENTER_VERTICAL
	lbl.Color = Colors.White
	lbl.TextColor = Colors.Black
	pnlDrawer.AddView(lbl, 0, TopValue, DrawerWidth, HeightValue)

	Dim divider As Panel
	divider.Initialize("")
	divider.Color = 0xFFEFEFEF
	pnlDrawer.AddView(divider, 12dip, TopValue + HeightValue - 1dip, DrawerWidth - 24dip, 1dip)

	Return lbl
End Sub

Private Sub Label1_Click
	If DrawerOpen Then
		CloseDrawer
	Else
		OpenDrawer
	End If
End Sub

Private Sub OpenDrawer
	DrawerOpen = True
	pnlOverlay.Visible = True
	pnlOverlay.BringToFront
	pnlDrawer.BringToFront
	pnlEdge.BringToFront
	pnlDrawer.SetLayoutAnimated(220, 0, 0, DrawerWidth, 100%y)
	UpdateOverlayFromLeft(0)
End Sub

Private Sub CloseDrawer
	DrawerOpen = False
	pnlDrawer.SetLayoutAnimated(220, -DrawerWidth, 0, DrawerWidth, 100%y)
	UpdateOverlayFromLeft(-DrawerWidth)
	pnlOverlay.Visible = False
End Sub

Private Sub UpdateOverlayFromLeft(CurrentLeft As Int)
	Dim openRatio As Float = 1 - (Abs(CurrentLeft) / DrawerWidth)
	If openRatio < 0 Then openRatio = 0
	If openRatio > 1 Then openRatio = 1
	Dim alpha As Int = Round(openRatio * 170)
	pnlOverlay.Color = Bit.Or(Bit.ShiftLeft(alpha, 24), Colors.Black)
End Sub

Private Sub EndDrag
	IsDragging = False
	If pnlDrawer.Left > -DrawerWidth / 2 Then
		OpenDrawer
	Else
		CloseDrawer
	End If
End Sub

Private Sub pnlOverlay_Click
	If DrawerOpen Then CloseDrawer
End Sub

'Swipe from left edge to open
Private Sub pnlEdge_Touch (Action As Int, X As Float, Y As Float)
	Dim a As Int = Bit.And(Action, 0xFF)

	Select a
		Case Activity.ACTION_DOWN
			If DrawerOpen = False Then
				IsDragging = True
				DragStartRawX = X
				DrawerStartLeft = pnlDrawer.Left
				pnlOverlay.Visible = True
				pnlOverlay.BringToFront
				pnlDrawer.BringToFront
				pnlEdge.BringToFront
			End If

		Case Activity.ACTION_MOVE
			If IsDragging Then
				Dim newLeft As Int = DrawerStartLeft + (X - DragStartRawX)
				If newLeft > 0 Then newLeft = 0
				If newLeft < -DrawerWidth Then newLeft = -DrawerWidth
				pnlDrawer.Left = newLeft
				UpdateOverlayFromLeft(newLeft)
			End If

		Case Activity.ACTION_UP
			If IsDragging Then EndDrag
	End Select
End Sub

'Swipe on drawer to close
Private Sub pnlDrawer_Touch (Action As Int, X As Float, Y As Float)
	Dim a As Int = Bit.And(Action, 0xFF)

	Select a
		Case Activity.ACTION_DOWN
			IsDragging = True
			DragStartRawX = X
			DrawerStartLeft = pnlDrawer.Left

		Case Activity.ACTION_MOVE
			If IsDragging Then
				Dim newLeft As Int = DrawerStartLeft + (X - DragStartRawX)
				If newLeft > 0 Then newLeft = 0
				If newLeft < -DrawerWidth Then newLeft = -DrawerWidth
				pnlDrawer.Left = newLeft
				UpdateOverlayFromLeft(newLeft)
			End If

		Case Activity.ACTION_UP
			If IsDragging Then EndDrag
	End Select
End Sub

Private Sub miDash_Click
	CloseDrawer
	StartActivity(dashboard)
End Sub

Private Sub miCal_Click
	CloseDrawer
	StartActivity(calendar)
End Sub

Private Sub miTodo_Click
	CloseDrawer
	StartActivity(todo)
End Sub

Private Sub miNotifs_Click
	CloseDrawer
	StartActivity(notifs)
End Sub

Private Sub miProfile_Click
	CloseDrawer
	'Already on profile
End Sub