declare CUR cursor for
    SELECT name
    FROM master..sysdatabases
    where name like 'ABC_%'

declare @db varchar(50)
declare @msg varchar(200)

open CUR

fetch next from CUR into @db
while @@FETCH_STATUS = 0
begin
    set @msg = 'detach ' + @db
    raiserror (@msg, 0, 1) with nowait
   
    exec sp_detach_db @db, 'true'
   
    fetch next from CUR into @db
end

close CUR
deallocate CUR
