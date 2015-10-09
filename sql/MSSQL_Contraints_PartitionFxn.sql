-- From: http://www.sqlusa.com/bestpractices2005/listcheckconstraints/
SELECT   TABLE_NAME,
         COLUMN_NAME,
         CHECK_CLAUSE,
         cc.CONSTRAINT_SCHEMA,
         cc.CONSTRAINT_NAME
FROM     INFORMATION_SCHEMA.CHECK_CONSTRAINTS cc
         INNER JOIN INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE c
           ON cc.CONSTRAINT_NAME = c.CONSTRAINT_NAME
ORDER BY CONSTRAINT_SCHEMA,
         TABLE_NAME,
         COLUMN_NAME
GO

-- See: https://msdn.microsoft.com/en-us/library/ms187381.aspx
select * from sys.partition_functions 

-- Partition schema and Partition Function can be found in:
-- OE - Databases - [your db] - Storage - Partition functions or schemes.
