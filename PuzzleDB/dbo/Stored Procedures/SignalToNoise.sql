/*=========================================================================================
== Purpose: 
== 
== History:
== 2018-11-15 ap: Created procedure
== 2018-11-29 ap: Standardized comment
== 
== Note:
== 
== Test:
== EXEC dbo.SignalToNoise @PuzzleId = 1,
==                        @Signal = 'How beauteous mankind is! O brave new world / That has such people in''t!', 
==                        @SignalToNoise = NULL
=========================================================================================*/

CREATE PROCEDURE dbo.SignalToNoise @PuzzleId      INT, 
                                   @Signal        NVARCHAR(MAX), 
                                   @SignalToNoise NVARCHAR(MAX) = NULL OUTPUT
AS
BEGIN

    DECLARE @StringLength INT;
    DECLARE @Noise VARCHAR(MAX);
    DECLARE @Position INT;
    DECLARE @Count INT;
    DECLARE @Across INT;
    DECLARE @Down INT;
    DECLARE @MaxAcross INT;
    DECLARE @MaxDown INT;

    SELECT @MaxAcross = Across, 
           @MaxDown = Down
    FROM   dbo.Puzzle
    WHERE  PuzzleId = @PuzzleId;

    SET @StringLength = @MaxAcross * @MaxDown;

    IF OBJECT_ID('tempdb.dbo.#SignalToNoise') IS NOT NULL
        BEGIN
            DROP TABLE #SignalToNoise;
        END;

    CREATE TABLE #SignalToNoise
        (PositionID INT NOT NULL IDENTITY(1, 1) PRIMARY KEY CLUSTERED , 
         Across     INT NOT NULL, 
         Down       INT NOT NULL, 
         IsOpen     BIT NOT NULL, 
         [Char]     NCHAR(1) NULL
        )
        ON [PRIMARY];

    INSERT INTO #SignalToNoise
        (Across, 
         Down, 
         IsOpen
        )
    SELECT Across, 
           Down, 
           IsOpen
    FROM   dbo.PuzzleData
    WHERE  PuzzleId = @PuzzleId;

    EXEC dbo.GenerateNoise @StringLength, 
                           @Noise OUT;

    SET @Position = 1;

    -- Loop the loop
    WHILE @Position <= @StringLength
        BEGIN
            UPDATE #SignalToNoise
            SET    [Char] = SUBSTRING(@Noise, @Position, 1)
            WHERE  PositionID = @Position;

            SET @Position = @Position + 1;
        END;

    SELECT @Signal = dbo.SeekingALPHA ( @Signal );

    SET @StringLength = LEN(@Signal);
    SET @Position = 0;
    SET @Count = 1;

    -- Loop the loop
    WHILE @Count <= @StringLength
        BEGIN
            SELECT TOP 1 @Position = PositionID
            FROM   #SignalToNoise
            WHERE  IsOpen = 1
                   AND PositionID >= @Position
            ORDER BY PositionID;

            UPDATE #SignalToNoise
            SET    [Char] = SUBSTRING(@Signal, @Count, 1)
            WHERE  PositionID = @Position;

            SET @Position = @Position + 1;
            SET @Count = @Count + 1;
        END;

    SET @Count = @MaxAcross * @MaxDown;
    SET @SignalToNoise = '';
    SET @Position = 1;
    SET @Across = 1;
    SET @Down = 1;

    -- Loop the loop
        WHILE @Position <= @Count
            BEGIN
                WHILE @Down <= @MaxDown
                    BEGIN
                        WHILE @Across <= @MaxAcross
                            BEGIN
                                SELECT @SignalToNoise = @SignalToNoise + Char
                                FROM   #SignalToNoise
                                WHERE  Down = @Down
                                       AND Across = @Across;

                                SET @Across = @Across + 1;
                                SET @Position = @Position + 1;
                            END;

                            SET @Across = 1;
                            SET @Down = @Down + 1;
                    END;
            END;

    SELECT @SignalToNoise;

END;
GO
