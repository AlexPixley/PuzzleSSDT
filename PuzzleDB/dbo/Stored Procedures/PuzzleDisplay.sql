/*=========================================================================================
== Purpose: Display puzzle grid where 1 represents an open space and 0 represents closed.
== 
== History:
== 2018-12-01 ap: Created procedure
== 
== Note:
== 
== Test:
== EXEC dbo.PuzzleDisplay @PuzzleId = 1
=========================================================================================*/

CREATE PROCEDURE dbo.PuzzleDisplay @PuzzleId INT
AS
BEGIN

    DECLARE @SQLStatement NVARCHAR(MAX)= N'';
    DECLARE @PivotAcross NVARCHAR(MAX)= N'';
    DECLARE @PivotedColumns NVARCHAR(MAX)= N'';

    --Generate PIVOT list
    SELECT @PivotAcross = @PivotAcross + ', [' + COALESCE(CONVERT(VARCHAR,Across), '') + ']' FROM (SELECT DISTINCT Across FROM dbo.PuzzleData WHERE PuzzleId = @PuzzleId) DT;
    SELECT @PivotAcross = LTRIM(STUFF(@PivotAcross, 1, 1, '')); --Remove leading comma and space

    --Generate column names to be put in SELECT list
    SELECT @PivotedColumns = @PivotedColumns+', ['+CONVERT(VARCHAR, Across)+']' FROM ( SELECT DISTINCT Across FROM dbo.PuzzleData WHERE PuzzleId = @PuzzleId ) DT;
    SELECT @PivotedColumns = LTRIM(STUFF(@PivotedColumns, 1, 1, '')); --Remove leading comma and space

    --Generate dynamic PIVOT query
    SET @SQLStatement = N'SELECT '+@PivotedColumns+'FROM ( SELECT DOWN, ACROSS, IsOpen = CONVERT(TINYINT,IsOpen) FROM dbo.PuzzleData WHERE PuzzleId = '+CONVERT(VARCHAR, @PuzzleId)+' ) AS Source PIVOT ( MAX(IsOpen) FOR Across IN ('+@PivotAcross+') ) AS PVT ORDER BY Down';

    --Execute dynamic PIVOT query
    EXEC (@SQLStatement);
END;
GO
