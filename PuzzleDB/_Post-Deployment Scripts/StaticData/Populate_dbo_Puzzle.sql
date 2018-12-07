
SET IDENTITY_INSERT [dbo].[Puzzle] ON
GO

MERGE [dbo].[Puzzle] TGT
USING (VALUES 
    (1, N'CHRISTMAS CROSSWORD PUZZLE PRINTABLE', 15, 15)
  , (2, N'SHAKESPEARE', 21, 20)
) SRC ([PuzzleId], [PuzzleDescription], [Across], [Down]) ON [SRC].[PuzzleID] = [TGT].[PuzzleID]
WHEN NOT MATCHED BY TARGET THEN
    INSERT
        (      [PuzzleId],       [PuzzleDescription],       [Across],       [Down])
    VALUES
        ([SRC].[PuzzleId], [SRC].[PuzzleDescription], [SRC].[Across], [SRC].[Down])
WHEN MATCHED THEN
    UPDATE
    SET [PuzzleId] = [SRC].[PuzzleId]
      , [PuzzleDescription] = [SRC].[PuzzleDescription]
      , [Across] = [SRC].[Across]
      , [Down] = [SRC].[Down]
;
GO

SET IDENTITY_INSERT [dbo].[Puzzle] OFF
GO
