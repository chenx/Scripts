-- Example 3. Note the use of: 1) cursor, 2) fetch, 3) raiserror to print without wait.

DECLARE @tbl varchar(20)

DECLARE c CURSOR FOR SELECT empID FROM test.dbo.Employee
OPEN c

FETCH NEXT FROM c INTO @tbl
WHILE @@FETCH_STATUS = 0
BEGIN
    --print @tbl
    RAISERROR(@tbl, 0, 1) WITH NOWAIT
    FETCH NEXT FROM c INTO @tbl
END

CLOSE c
DEALLOCATE c
