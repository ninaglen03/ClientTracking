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
	Private Button1 As Button            ' Verify your Account
	Private EditText1 As EditText        ' First Name
	Private EditText2 As EditText        ' Last Name
	Private EditText3 As EditText        ' Email
	Private EditText4 As EditText        ' Password
End Sub

Sub Activity_Create(FirstTime As Boolean)
	Activity.LoadLayout("tlsignup")
End Sub

Sub Activity_Resume
End Sub

Sub Activity_Pause (UserClosed As Boolean)
End Sub

Private Sub Button1_Click
	Dim firstName As String = EditText1.Text.Trim
	Dim lastName As String = EditText2.Text.Trim
	Dim email As String = EditText3.Text.Trim
	Dim password As String = EditText4.Text

	If firstName = "" Or lastName = "" Or email = "" Or password = "" Then
		ToastMessageShow("Please fill in all fields.", False)
		Return
	End If

	If password.Length < 6 Then
		ToastMessageShow("Password must be at least 6 characters.", False)
		Return
	End If

	Dim fullName As String = firstName & " " & lastName

	Button1.Enabled = False
	ProgressDialogShow("Submitting lead application...")

	Dim postData As String
	postData = "name=" & UrlEncode(fullName) & _
               "&email=" & UrlEncode(email) & _
               "&password=" & UrlEncode(password)

	Dim j As HttpJob
	j.Initialize("lead_signup", Me)
	j.PostString("http://192.168.8.177:8001/Executioner/lead_signup.php", postData)
	j.GetRequest.SetContentType("application/x-www-form-urlencoded")
End Sub

Sub JobDone(Job As HttpJob)
	ProgressDialogHide
	Button1.Enabled = True

	If Job.JobName = "lead_signup" Then
		If Job.Success Then
			Dim res As String = Job.GetString.Trim.ToLowerCase

			Select res
				Case "success"
					StartActivity(tlmessage)
					Activity.Finish

				Case "exists"
					ToastMessageShow("Name or email already exists.", False)

				Case "weak"
					ToastMessageShow("Password is too weak (minimum 6 characters).", False)

				Case Else
					ToastMessageShow("Submission failed: " & res, False)
			End Select
		Else
			ToastMessageShow("Network error: " & Job.ErrorMessage, True)
		End If
	End If

	Job.Release
End Sub

Private Sub UrlEncode(s As String) As String
	Dim su As StringUtils
	Return su.EncodeUrl(s, "UTF8")
End Sub