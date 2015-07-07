/**
 * To bulk insert data from generated dump files, use the command below. 
 * Note the "FIRSTROW" is 1-based and not 0-based. In the dump file, the 
 * first row will be column names, the second row is separator line "----", 
 * so data starts from the 3rd line.
 */

USE [DB]
GO

BULK INSERT [T_data]
    FROM 'C:\\output\\T_data.txt'
    WITH
    (
        FIRSTROW = 3,
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '0x0a'
    )
GO
