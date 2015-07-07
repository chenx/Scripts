Here are some vbscript code examples.

--Table of contents--
1. Send email
2. Get computer name
3. Connect to database and execute query
4. Restart a windows service
5. Use of a log file
--

1. Send email

Sub sendEmail(ByRef text)
  Dim objMessage
  Set objMessage = CreateObject("CDO.Message")
  objMessage.Subject = "..."
  objMessage.From = "..."
  objMessage.To = "...@..."
  objMessage.TextBody = "...text..."

  objMessage.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/sendusing")=2 
  objMessage.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/smtpserver") = "..." 
  objMessage.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/smtpserverport") =25 
  objMessage.Configuration.Fields.Update

  objMessage.Send
End Sub

2. Get computer name

Dim objShell, strComputer
Set objShell = CreateObject("WScript.Shell")
strComputer = objShell.ExpandEnvironmentStrings( "%COMPUTERNAME%" )
Set objShell = nothing

3. Connect to database and execute query

Option Explicit

on error resume next
Set objShell = CreateObject("WScript.Shell")

Set objConnection = CreateObject("ADODB.Connection")
objConnection.Open "Provider=SQLOLEDB.1;Data Source=localhost;Initial Catalog=<db>","<username>","<password>"

if err.number <> 0 then
    WScript.Echo "error " & hex(err.number) & ": " & err.description 
else
    WScript.Echo "value = " & getVal()
    objConnection.close
end if
on error goto 0

Set objConnection = Nothing

Set objShell = nothing
WScript.Quit(0)

Function getVal()
    Dim sql, strWatchFile
    sql = "select val from table"
    set strWatchFile = objConnection.Execute( sql )
    if err.number <> 0 then
        WScript.Echo hex(err.number) & vbcrlf & err.description 
        getVal = -1
        Exit Function
    else
        getVal = strWatchFile(0).value
        strWatchFile.close
    end if
    set strWatchFile=nothing
End Function

4. Restart a windows service (by calling the batch file below)

objShell.Run "restart.bat ""<service name>""", 0, true

The three parameters are:
  1) string: shell command, a batch file in this case (plus its parameter).
  2) int: 1 - show window, 0 - hide window.
  3) boolean: true - wait until the shell command ends, false - do not wait.

5. Use of a log file

Dim objFileSystem, objLogFile, logFileName, useLog

useLog = True
logFileName = "C:\mylog.log"
Set objShell = CreateObject("WScript.Shell")

openLog()
writeLog("hello world")
closeLog()

Set objShell = nothing
WScript.Quit(0)

Sub openLog()
  If NOT useLog Then Exit Sub
  Const OPEN_FILE_FOR_APPENDING = 8
  Set objFileSystem = CreateObject("Scripting.fileSystemObject")
  If NOT objFileSystem.FileExists(logFileName) Then
    Set objLogFile = objFileSystem.CreateTextFile(logFileName, TRUE)
  Else
    Set objLogFile = objFileSystem.OpenTextFile(logFileName, OPEN_FILE_FOR_APPENDING)
  End If
End Sub

Sub writeLog(txt)
  WScript.Echo txt
  If useLog Then objLogFile.WriteLine(date & " " & time & ": " & txt)
End Sub

Sub closeLog()
  If NOT useLog Then Exit Sub
  objLogFile.Close
  Set objLogFile = Nothing
  Set objFileSystem = Nothing
End Sub

