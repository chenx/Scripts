REM A DOS batch file to dump all tables/views in a MSSQL database.
REM 
REM To dump just one table T_data from a database DB, use:
REM echo dump table T_data ..
REM sqlcmd -E -S localhost -d DB -Q "set nocount on; set ansi_warnings off; select * from T_data;" -o output/T_data.txt -s "," -W
REM
REM See more details at: http://homeofcox-cs.blogspot.com/2014/03/dos-batch-file-to-dump-all-tablesviews.html

@ECHO OFF
REM This script dumps all tables in the given database in CSV format.
REM Author: X.C. 3/6/2014
CLS

set db=Northwind
set mode=%1

IF NOT "%mode%" == "all" set mode=test

echo -----------------------------------------------------------------
echo This script dumps all tables in the given database in CSV format.
echo Author: X.C. 3/6/2014
echo.
echo Usage: dump_csv.bat [mode]
echo   If mode = all, the entire tables are dumped.
echo   If mode = test, only first row of each table is dumped.
echo -----------------------------------------------------------------
echo.
echo Mode: %mode%
echo Database: %db%
echo.
echo ==Tables to dump==

FOR /F "skip=2" %%G IN ('sqlcmd -E -S localhost -d %db% -Q "set nocount on; set ansi_warnings off; select TABLE_NAME from INFORMATION_SCHEMA.TABLES order by table_name;"') DO Echo %%GG

echo.
choice /m "Do you want to continue "
if errorlevel 2 goto Lexit

echo.

IF "%mode%" == "test" (
  FOR /F "skip=2" %%G IN ('sqlcmd -E -S localhost -d %db% -Q "set nocount on; set ansi_nulls on; set ansi_warnings on; select TABLE_NAME from INFORMATION_SCHEMA.TABLES order by table_name;"') DO (
    echo dump table %%G ..
    sqlcmd -E -S localhost -d %db% -Q "set nocount on; set ansi_warnings off; select top 1 * from %%G;" -o output/%%G.txt -s "," -W
  )
)

IF "%mode%" == "all" (
  FOR /F "skip=2" %%G IN ('sqlcmd -E -S localhost -d %db% -Q "set nocount on; set ansi_nulls on; set ansi_warnings on; select TABLE_NAME from INFORMATION_SCHEMA.TABLES order by table_name;"') DO (
    echo dump table %%G ..
    sqlcmd -E -S localhost -d %db% -Q "set nocount on; set ansi_warnings off; select * from %%G;" -o output/%%G.txt -s "," -W
  )
)

:Lexit
echo.
pause


REM Note 1: If do "set ansi_nulls off; set ansi_warnings off", then view information cannot be retrieved.
REM Note 2: To obtain table values only, use: where TABLE_TYPE = 'BASE TABLE'
REM             To obtain view values only, use: where TABLE_TYPE = 'VIEW'
