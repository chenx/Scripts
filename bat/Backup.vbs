REM Batch file backup_mystuff.bat:


echo off
REM
REM This script backs up files.
REM Files listed in %exclude_list% are excluded.
REM
REM Reference: http://www.ahuka.com/backup/backup3.html
REM By: XC
REM Created on: 12/5/2009
REM Last modified: 12/5/2009
REM
echo.
echo == Back Up Files ==
echo.

REM
REM Use this, and !var! after assignment.
REM Otherwise the input value will be buffered until next execution.
REM
SETLOCAL ENABLEDELAYEDEXPANSION

set "dstDir=mystuff_%date:~10,4%-%date:~4,2%-%date:~7,2%"
set srcDir=D:\wwwroot\mystuff
set exclude_list=mystuff_exclude_list.txt

if EXIST %dstDir% (
  (set USRINPUT=)
  set /P USRINPUT=Delete existing directory %dstDir% [y/n]: 
  REM echo Your input was: !USRINPUT!

  if  "!USRINPUT!" == "y" goto:go_on
  if  "!USRINPUT!" == "Y" goto:go_on
  REM If input is not 'y' or 'Y', exit.
  goto:EOF 

:go_on
  echo Delete existing directory %dstDir%...
  rmdir /S /Q %dstDir%
)

echo.Copy files from %srcDir% to %dstDir%, please wait...
echo.

mkdir %str%
xcopy /E /V /Y /Q /EXCLUDE:%exclude_list% %srcDir%\* %dstDir%\. 
echo.


REM And example mystuff_exclude_list.txt file:
REM 
REM D:\wwwroot\mystuff\download
REM D:\wwwroot\mystuff\aspnet_client
