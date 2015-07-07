ECHO OFF

FOR /f "tokens=*" %%i in ('DIR /a:d /b D:\mssql_db\*abc* D:\mssql_db\*xyz*') DO (
    ECHO %%i
    rmdir /s /q "D:\mssql_db\%%i"
)
