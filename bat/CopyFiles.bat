REM The batch script below can be used to automate file copy. 
REM You need to modify it to adapt to your needs.
REM By: X. Chen
REM Created On: 7/6/2015

echo off
echo Copy script

REM Source machines.
set SERVERS[0]=machine1
set SERVERS[1]=machine2
set SERVERS[2]=machine3

REM Source folder pattern.
set PATTERN=Folder_Pattern
 
REM Target location root.
set ROOT=machine_target_root
set VERBOSE=1

set "x=0"

:SymLoop

if defined SERVERS[%x%] (
  REM call echo %%SERVERS[%x%]%%
  call set SERVER=%%SERVERS[%x%]%%
  echo %SERVER%

  REM Create target folder.
  mkdir %ROOT%\%SERVER%

  FOR /f "tokens=*" %%i in ('DIR /a:d /b \\%SERVER%\%PATTERN%') DO (
      if VERBOSE=1 (
          ECHO Copy from \\%SERVER%\%%i\* to %ROOT%\%SERVER%\%%i\
      )
      xcopy \\%SERVER%\%%i\* %ROOT%\%SERVER%\%%i\
  )

  set /a "x+=1"
  GOTO :SymLoop
)

:END
