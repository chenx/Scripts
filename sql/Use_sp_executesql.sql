-- Examples of using sp_executesql with output parameters.

-- Two scenarios: 1) execute a query, 2) execute a stored procedure.
-- See [1] http://support.microsoft.com/kb/262499

-- Example 1.

DECLARE @SQLString NVARCHAR(500)
DECLARE @ParmDefinition NVARCHAR(500)
DECLARE @IntVariable INT
DECLARE @Lastlname varchar(30)
SET @SQLString = N'SELECT @LastlnameOUT = max(lname)
                   FROM pubs.dbo.employee WHERE job_lvl = @level'
SET @ParmDefinition = N'@level tinyint,
                        @LastlnameOUT varchar(30) OUTPUT'
SET @IntVariable = 35
EXECUTE sp_executesql
@SQLString,
@ParmDefinition,
@level = @IntVariable,
@LastlnameOUT=@Lastlname OUTPUT
SELECT @Lastlname

GO
 

-- Example 2.

CREATE PROCEDURE Myproc
    @parm varchar(10),
    @parm1OUT varchar(30) OUTPUT,
    @parm2OUT varchar(30) OUTPUT
    AS
      SELECT @parm1OUT='parm 1' + @parm
     SELECT @parm2OUT='parm 2' + @parm
GO
DECLARE @SQLString NVARCHAR(500)
DECLARE @ParmDefinition NVARCHAR(500)
DECLARE @parmIN VARCHAR(10)
DECLARE @parmRET1 VARCHAR(30)
DECLARE @parmRET2 VARCHAR(30)
SET @parmIN=' returned'
SET @SQLString=N'EXEC Myproc @parm,
                             @parm1OUT OUTPUT, @parm2OUT OUTPUT'
SET @ParmDefinition=N'@parm varchar(10),
                      @parm1OUT varchar(30) OUTPUT,
                      @parm2OUT varchar(30) OUTPUT'

EXECUTE sp_executesql
    @SQLString,
    @ParmDefinition,
    @parm=@parmIN,
    @parm1OUT=@parmRET1 OUTPUT,@parm2OUT=@parmRET2 OUTPUT

SELECT @parmRET1 AS "parameter 1", @parmRET2 AS "parameter 2"
go
drop procedure Myproc


