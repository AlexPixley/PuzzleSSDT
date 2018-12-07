/*=========================================================================================
== Purpose: Input a string, strip out non-alphabetic characters and return cleaned string in uppercase
== 
== History:
== 2018-11-14 ap: Created function
== 
== Note:
== 
== Test:
== SELECT dbo.SeekingALPHA ( 'How beauteous mankind is! O brave new world / That has such people in''t!' );
=========================================================================================*/

CREATE FUNCTION dbo.SeekingALPHA
    ( @Working NVARCHAR(MAX) )
    RETURNS NVARCHAR(MAX)
AS
BEGIN

    DECLARE @ALPHA AS VARCHAR(50);
    SET @ALPHA = '%[^A-Z]%';
    SET @Working = UPPER(@Working);

    WHILE PATINDEX(@ALPHA, @Working) > 0
        BEGIN
            SET @Working = STUFF(@Working, PATINDEX(@ALPHA, @Working), 1, '');
        END

    RETURN @Working;

END;
GO
