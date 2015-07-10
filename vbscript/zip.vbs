'
' http://superuser.com/questions/110991/can-you-zip-a-file-from-command-prompt
' http://www.rondebruin.nl/windowsxpzip.htm
' http://msdn.microsoft.com/en-us/library/windows/desktop/bb787866%28v=vs.85%29.aspx
'
Dim objArgs, InputFolder, ZipFile, objShell, source, ct

Set objArgs = WScript.Arguments 
InputFolder = objArgs(0) 
ZipFile = objArgs(1) 
CreateObject("Scripting.FileSystemObject").CreateTextFile(ZipFile, True).Write "PK" & Chr(5) & Chr(6) & String(18, vbNullChar) 
Set objShell = CreateObject("Shell.Application") 
Set source = objShell.NameSpace(InputFolder).Items 

' 4 - Do not display a progress dialog box.
objShell.NameSpace(ZipFile).CopyHere source, 4 

'Keep script waiting until Compressing is done
ct = 0
Do Until objShell.Namespace(ZipFile).items.Count = objShell.NameSpace(InputFolder).items.count
   WScript.sleep 1000
   ct = ct + 1
Loop

WScript.Echo "Zip used " & ct & " seconds."

Set source = nothing
Set objShell = nothing
WScript.Quit(0)
