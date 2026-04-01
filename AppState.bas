B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=StaticCode
Version=13.4
@EndOfDesignText@
Sub Process_Globals
	Public TaskEvents As List
End Sub

Public Sub EnsureInit
	If TaskEvents.IsInitialized = False Then
		TaskEvents.Initialize
	End If
End Sub

Public Sub SetTaskEvents(EventsList As List)
	EnsureInit
	TaskEvents.Clear
	For i = 0 To EventsList.Size - 1
		TaskEvents.Add(EventsList.Get(i))
	Next
End Sub

Public Sub GetTaskEvents As List
	EnsureInit
	Return TaskEvents
End Sub