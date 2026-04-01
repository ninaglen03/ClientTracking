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
	Private Button1 As Button   ' Back to Login
End Sub

Sub Activity_Create(FirstTime As Boolean)
	Activity.LoadLayout("tlmessage")
End Sub

Sub Activity_Resume
End Sub

Sub Activity_Pause (UserClosed As Boolean)
End Sub

Private Sub Button1_Click
	StartActivity(Main)   ' Change Main if your login activity has different name
	Activity.Finish
End Sub