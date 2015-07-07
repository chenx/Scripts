::
:: usage: restart.bat <service name>
:: Note quotation marks can be used if the service name contains space.
::
:: This batch script restarts a windows service (given as a parameter of the batch file).
:: It does this by:
:: 1) issue a stop command;
:: 2) check the status of the service, go back to 1) if it is not stopped yet;
:: 3) when the service has been stopped, restart it.
::
:: Note: the provided service MUST exist, otherwise it will get into an infinite loop.
::
:: References:
:: [1] http://serverfault.com/questions/25081/how-do-i-restart-a-windows-service-from-a-script
:: [2] http://boards.straightdope.com/sdmb/showthread.php?t=458812
:: [3] http://www.robvanderwoude.com/errorlevel.php
::
::

@ECHO OFF

if [%1]==[] goto end

:stop
sc stop %1

rem cause a ~2 seconds sleep before checking the service state
ping 127.0.0.1 -n 2 -w 1000 > nul

sc query %1 | find /I "STATE" | find "STOPPED"

if errorlevel 1 goto :stop
goto :start

:start
sc start %1

:end
