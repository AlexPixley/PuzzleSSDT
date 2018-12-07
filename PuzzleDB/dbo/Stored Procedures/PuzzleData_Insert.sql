/*=========================================================================================
== Purpose: 
== 
== History:
== 2018-04-01 ap: Created procedure
== 
== Note:
== 
== Test:
== EXEC dbo.PuzzleData_Insert @PuzzleID = 2, @Across = 6, @Down = 6
=========================================================================================*/

CREATE PROCEDURE [dbo].[PuzzleData_Insert] @PuzzleID INT,
                                           @Across   SMALLINT,
                                           @Down     SMALLINT
AS
BEGIN

    IF OBJECT_ID('tempdb..#Character_Position') IS NOT NULL
        DROP TABLE #Character_Position;

    CREATE TABLE #Character_Position
        (PuzzleID  INT,
         Character_Location SMALLINT IDENTITY(1, 1) PRIMARY KEY CLUSTERED ,
         Across     SMALLINT,
         Down     SMALLINT
        );

    DECLARE @A SMALLINT= 1,
            @D SMALLINT= 1;

    WHILE @A <= @Across
      AND @D <= @Down
        BEGIN

            INSERT INTO #Character_Position
            SELECT PuzzleID = @PuzzleID,
                   Across = @A,
                   Down = @D;

            IF @D = @Down
                BEGIN
                    SET @D = 1;
                    SET @A = @A + 1;
                END;
            ELSE
                BEGIN
                    SET @D = @D + 1;
                END;
        END;

        INSERT INTO dbo.PuzzleData
            (PuzzleId,
             Character_Location,
             Across,
             Down
            )
        SELECT PuzzleID,
               Character_Location,
               Across,
               Down
        FROM   #Character_Position
        ORDER BY Character_Location;
END;
GO
