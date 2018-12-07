/*=========================================================================================
== Purpose: 
== 
== History:
== 2018-04-01 ap: Created procedure
== 
== Note:
== 
== Test:
== EXEC dbo.Puzzle_Insert @PuzzleDescription = 'Test', @Across = 11, @Down = 11
=========================================================================================*/

CREATE PROCEDURE [dbo].[Puzzle_Insert] @PuzzleDescription VARCHAR(50),
                                       @Across            TINYINT,
                                       @Down              TINYINT,
                                       @PuzzleScope       INT = NULL OUTPUT
AS
BEGIN

    INSERT INTO dbo.Puzzle
        (PuzzleDescription,
         Across,
         Down
        )
    VALUES
        (@PuzzleDescription,
         @Across,
         @Down
        );

    SET @PuzzleScope = SCOPE_IDENTITY();
END;
GO
