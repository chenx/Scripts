  REM A DOS Batch file to get the number of rows in all the tables and views in a MSSQL database.
  
  @echo off

  set db=Northwind

  FOR /F "skip=2" %%G IN ('sqlcmd -E -S localhost -d %db% -Q "set nocount on; set ansi_warnings off; select TABLE_NAME from INFORMATION_SCHEMA.TABLES order by table_name;"') DO (
    REM echo dump table %%G ..
    FOR /F "skip=2" %%X IN ('sqlcmd -E -S localhost -d %db% -Q "set nocount on; set ansi_nulls on; set ansi_warnings on; select count(*) from %%G;"  -s "," -W') DO (
        echo [%%G]: %%X
    )
  )
