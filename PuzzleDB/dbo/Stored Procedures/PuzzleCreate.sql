/*=========================================================================================
== Purpose: 
== 
== History:
== 2018-04-01 ap: Created procedure
== 2018-11-29 ap: Standardized comment
== 
== Note:
== 
== Test:
== EXEC dbo.PuzzleCreate @PuzzleDescription = 'Test', @Across = 11, @Down = 11
=========================================================================================*/

CREATE PROCEDURE [dbo].[PuzzleCreate] @PuzzleDescription VARCHAR(50),
                                      @Across           TINYINT,
                                      @Down           TINYINT
AS
BEGIN

    SET XACT_ABORT ON;

    BEGIN TRANSACTION;
    DECLARE @PuzzleID INT;

    EXEC dbo.Puzzle_Insert @PuzzleDescription,
                           @Across,
                           @Down,
                           @PuzzleID OUT;

    SELECT @PuzzleID;

    EXEC dbo.PuzzleData_Insert @PuzzleID,
                               @Across,
                               @Down;

    COMMIT TRANSACTION;
END;
GO
