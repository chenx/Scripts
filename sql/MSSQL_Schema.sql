-- Obtain metadata of objects of a database can add lots of flexibility. This can be obtained in the following ways:

-- 1) INFORMATION_SCHEMA
-- e.g.:
select table_name as Name FROM INFORMATION_SCHEMA.Tables where TABLE_TYPE ='VIEW'

-- 2) sysobjects
-- e.g.:
SELECT name FROM sysobjects WHERE xtype = 'U' -- Tables
SELECT name FROM sysobjects WHERE xtype = 'V' -- Views
SELECT name FROM sysobjects WHERE xtype = 'P' -- Stored Procedures 
