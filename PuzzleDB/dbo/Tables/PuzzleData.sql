CREATE TABLE [dbo].[PuzzleData] (
    [PuzzleId]           INT      NOT NULL,
    [Character_Location] SMALLINT NOT NULL,
    [Across]             SMALLINT NOT NULL,
    [Down]               SMALLINT NOT NULL,
    [IsOpen]             BIT      CONSTRAINT [DF_Puzzle_IsOpen] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_PuzzleData] PRIMARY KEY CLUSTERED ([PuzzleId] ASC, [Character_Location] ASC),
    CONSTRAINT [FK_PuzzleData_Puzzle] FOREIGN KEY ([PuzzleId]) REFERENCES [dbo].[Puzzle] ([PuzzleId])
);
GO
