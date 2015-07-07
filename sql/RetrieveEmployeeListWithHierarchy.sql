--
-- This script solves the problem:
-- Given an Employee table, each rows has empID, mgrID, firstName, lastName,
-- return all the managers in hierarchy for a given employee.
-- This is easy, but can also be extended to something of medium complexity.
-- 
-- This T-SQL script demonostrates:
-- +  create/drop stored procedure
-- +  declare table and variable
-- +  while loop
-- +* assign parameter in dynamically constructed query
-- +  stored procedure returns variable or table
-- + convert data type
-- + execute stored procedure in t-sql
-- 
-- @execute from command line: sqlcmd -S localhost -d test -i getList.sql
--   -s: server, -d: database, -i: input file
--
-- @Author: HomeTom
-- @Created on: 3/15/2013
-- @Last modified: 3/15/2013
--
-- See:
-- http://homeofcox-cs.blogspot.com/2013/03/this-t-sql-script-demonostrates.html
-- http://homeofcox-cs.blogspot.com/2013/03/t-sql-ii.html
--

--if object_id('dbo.getList') is not null
--    drop procedure dbo.getList
--go

--create procedure getList
--  @ID varchar,
--  @EID int output
--as
begin

SET NOCOUNT ON;

declare @tbl table (
    empID varchar,
    name  varchar(50)
)

declare @empID varchar --= 5
declare @mgrID varchar
declare @name varchar(100)
declare @cond int = 1
declare @query nvarchar(512)

set @empID = 5 --@ID

while @cond = 1
BEGIN
    --print @empID
    -- CONVERT(varchar, @empID)

    IF NOT EXISTS (select empID from Employee WHERE empID = @empID) BREAK

    set @query = 'select @name = firstname + '' '' + lastname from Employee WHERE empID = ' + @empID
    exec sp_executesql @query, N'@name varchar(100) output',  @name = @name output
    insert into @tbl (empID, name) values (@empID, @name)
   
    -- get manager's empID.
    set @query = 'select @empID = mgrID from Employee WHERE empID = ' + @empID
    exec sp_executesql @query, N'@empID varchar output',  @empID = @empID output
    if @empID is null set @cond = 0
END

select * from @tbl

--select @EID = -999

end
go


-------------------
-- execute getList
-------------------

--USE [test]
--GO

--DECLARE    @return_value int,
--        @EID int

--SELECT    @EID = 1

--EXEC    @return_value = [dbo].[getList]
--EXEC    [dbo].[getList]
--        @ID = N'1',
--        @EID = @EID OUTPUT

--SELECT    @EID as N'@EID'
--select @EID

--SELECT    'Return Value' = @return_value

--GO

-------------------
-- Table Employee
-------------------

-- CREATE TABLE [dbo].[Employee](
--     [empID] [int] NOT NULL,
--     [mgrID] [int] NULL,
--     [firstName] [varchar](50) NULL,
--     [lastName] [varchar](50) NULL,
--  CONSTRAINT [PK_Employee] PRIMARY KEY CLUSTERED
-- (
--     [empID] ASC
-- )WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
-- ) ON [PRIMARY]
