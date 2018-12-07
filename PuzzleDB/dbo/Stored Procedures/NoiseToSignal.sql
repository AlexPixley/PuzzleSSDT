/*=========================================================================================
== Purpose: 
== 
== History:
== 2018-11-19 ap: Created procedure
== 2018-11-29 ap: Standardized comment
== 
== Note:
== 
== Test:
== EXEC dbo.SignalToNoise @PuzzleId = 1,
==                        @NoiseToSignal = 'HMVTPJOCIERJNTMOAEHLEHRFZNTTTGWNNAEGPDJNJIOBZLXESIBDNUIGTSEALKESNWHSQONBMDTBIWUEEHWEGOFYHHENWCTIPAWRQFFHTADOCIQHKZMRXLORUIRHULCSBTGUYSWTSLPFEVFDMJLSMKPIOEELFGQKISWPEEODOWPVZRDPKQTJOBTFKRXKKHEAQFOURHKPRRHPNTYHNYSAAEREILXYPDFJS'
==                        @Signal = NULL
=========================================================================================*/

CREATE PROCEDURE dbo.NoiseToSignal @PuzzleId      INT, 
                                   @NoiseToSignal NVARCHAR(MAX), 
                                   @Signal        NVARCHAR(MAX) = NULL OUTPUT
AS
BEGIN

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

    SET @Count = @MaxAcross * @MaxDown;

    IF OBJECT_ID('tempdb.dbo.#NoiseToSignal') IS NOT NULL
        BEGIN
            DROP TABLE #NoiseToSignal;
        END;

    CREATE TABLE #NoiseToSignal
        (PositionID INT NOT NULL IDENTITY(1, 1) PRIMARY KEY CLUSTERED , 
         Across     INT NOT NULL, 
         Down       INT NOT NULL, 
         IsOpen     BIT NOT NULL, 
         [Char]     NCHAR(1) NULL
        )
        ON [PRIMARY];

    INSERT INTO #NoiseToSignal
        (Across, 
         Down, 
         IsOpen
        )
    SELECT Across, 
           Down, 
            IsOpen
    FROM   dbo.PuzzleData
    WHERE  PuzzleId = @PuzzleId;

    -- Set parameters for nested loop
    SET @Position = 1;
    SET @Across = 1;
    SET @Down = 1;

    -- Nested loop
    WHILE @Position <= @Count
        BEGIN
            WHILE @Down <= @MaxDown
                BEGIN
                    WHILE @Across <= @MaxAcross
                        BEGIN
                            UPDATE #NoiseToSignal
                            SET    [Char] = ( SELECT SUBSTRING(@NoiseToSignal, @Position, 1) )
                            WHERE  Down = @Down
                                   AND Across = @Across;

                            SET @Across = @Across + 1;
                            SET @Position = @Position + 1;
                        END;

                        SET @Down = @Down + 1;
                        SET @Across = 1;
                END;
        END;

    -- Reset @Position for loop to build @Signal
    SET @Position = 1; -- reset
    SET @Signal = '';

    -- Loop to build @Signal
    WHILE @Position <= @Count
        BEGIN
            SELECT @Signal = @Signal + [Char]
            FROM   #NoiseToSignal
            WHERE  IsOpen = 1
                   AND PositionID = @Position;

            SET @Position = @Position + 1;
        END;

    SELECT @Signal;
END;
GO
