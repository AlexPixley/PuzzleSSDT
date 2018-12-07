CREATE TABLE [dbo].[Puzzle] (
    [PuzzleId]          INT          IDENTITY (1, 1) NOT NULL,
    [PuzzleDescription] VARCHAR (50) NOT NULL,
    [Across]            SMALLINT     NOT NULL,
    [Down]              SMALLINT     NOT NULL,
    CONSTRAINT [PK_Puzzle] PRIMARY KEY CLUSTERED ([PuzzleId] ASC)
);
GO
