select d.name, f.name, f.filename
from sysaltfiles f
inner join sysdatabases d
on (f.dbid = d.dbid)
where d.name = 'master'
order by 1,2

/* after this you can attach the database using the files. */

create database [master] on
(filename=N'C:\Program Files\Microsoft SQL Server\MSSQL10.MSSQLSERVER\MSSQL\DATA\master.mdf'),
(filename=N'C:\Program Files\Microsoft SQL Server\MSSQL10.MSSQLSERVER\MSSQL\DATA\mastlog.ldf')
for attach
