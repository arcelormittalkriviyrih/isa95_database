IF OBJECT_ID ('dbo.get_JSON2XML',N'FN') IS NOT NULL
   DROP FUNCTION dbo.get_JSON2XML;
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
	Function: get_JSON2XML
	Функция преобразования JSON-строки в XML-формат

	Parameters:

		Json - строка в формате JSON

*/

CREATE FUNCTION [dbo].[get_JSON2XML](
    @Json    varchar(max)
)
RETURNS xml
AS

BEGIN;
    DECLARE @output varchar(max), @key varchar(max), @value varchar(max),
        @recursion_counter int, @offset int, @nested bit, @array bit,
        @tab char(1)=CHAR(9), @cr char(1)=CHAR(13), @lf char(1)=CHAR(10);

    --- Clean up the JSON syntax by removing line breaks and tabs and
    --- trimming the results of leading and trailing spaces:
    SET @Json=LTRIM(RTRIM(
        REPLACE(REPLACE(REPLACE(@Json, @cr, ''), @lf, ''), @tab, '')));

    --- Sanity check: If this is not valid JSON syntax, exit here.
    IF (LEFT(@Json, 1)!='{' OR RIGHT(@Json, 1)!='}')
        RETURN '';

    --- Because the first and last characters will, by definition, be
    --- curly brackets, we can remove them here, and trim the result.
    SET @Json=LTRIM(RTRIM(SUBSTRING(@Json, 2, LEN(@Json)-2)));

    SELECT @output='';
    WHILE (@Json!='') BEGIN;

        --- Look for the first key which should start with a quote.
        IF (LEFT(@Json, 1)!='"')
            RETURN 'Expected quote (start of key name). Found "'+
                LEFT(@Json, 1)+'"';

        --- .. and end with the next quote (that isn't escaped with
        --- and backslash).
        SET @key=SUBSTRING(@Json, 2,
            PATINDEX('%[^\\]"%', SUBSTRING(@Json, 2, LEN(@Json))+' "'));

        --- Truncate @Json with the length of the key.
        SET @Json=LTRIM(SUBSTRING(@Json, LEN(@key)+3, LEN(@Json)));

        --- The next character should be a colon.
        IF (LEFT(@Json, 1)!=':')
            RETURN 'Expected ":" after key name, found "'+
                LEFT(@Json, 1)+'"!';

        --- Truncate @Json to skip past the colon:
        SET @Json=LTRIM(SUBSTRING(@Json, 2, LEN(@Json)));

        --- If the next character is an angle bracket, this is an array.
        IF (LEFT(@Json, 1)='[')
            SELECT @array=1, @Json=LTRIM(SUBSTRING(@Json, 2, LEN(@Json)));

        IF (@array IS NULL) SET @array=0;
        WHILE (@array IS NOT NULL) BEGIN;

            SELECT @value=NULL, @nested=0;
            --- The first character of the remainder of @Json indicates
            --- what type of value this is.

            --- Set @value, depending on what type of value we're looking at:
            ---
            --- 1. A new JSON object:
            ---    To be sent recursively back into the parser:
            IF (@value IS NULL AND LEFT(@Json, 1)='{') BEGIN;
                SELECT @recursion_counter=1, @offset=1;
                WHILE (@recursion_counter!=0 AND @offset<LEN(@Json)) BEGIN;
                    SET @offset=@offset+
                        PATINDEX('%[{}]%', SUBSTRING(@Json, @offset+1,
                            LEN(@Json)));
                    SET @recursion_counter=@recursion_counter+
                        (CASE SUBSTRING(@Json, @offset, 1)
                            WHEN '{' THEN 1
                            WHEN '}' THEN -1 END);
                END;

                SET @value=CAST(
                    dbo.get_JSON2XML(LEFT(@Json, @offset))
                        AS varchar(max));
                SET @Json=SUBSTRING(@Json, @offset+1, LEN(@Json));
                SET @nested=1;
            END

            --- 2a. Blank text (quoted)
            IF (@value IS NULL AND LEFT(@Json, 2)='""')
                SELECT @value='', @Json=LTRIM(SUBSTRING(@Json, 3,
                    LEN(@Json)));

            --- 2b. Other text (quoted, but not blank)
            IF (@value IS NULL AND LEFT(@Json, 1)='"') BEGIN;
                SET @value=SUBSTRING(@Json, 2,
                    PATINDEX('%[^\\]"%',
                        SUBSTRING(@Json, 2, LEN(@Json))+' "'));
                SET @Json=LTRIM(
                    SUBSTRING(@Json, LEN(@value)+3, LEN(@Json)));
            END;

            --- 3. Blank (not quoted)
            IF (@value IS NULL AND LEFT(@Json, 1)=',')
                SET @value='';

            --- 4. Or unescaped numbers or text.
            IF (@value IS NULL) BEGIN;
                SET @value=LEFT(@Json,
                    PATINDEX('%[,}]%', REPLACE(@Json, ']', '}')+'}')-1);
                SET @Json=SUBSTRING(@Json, LEN(@value)+1, LEN(@Json));
            END;

            --- Append @key and @value to @output:
            SET @output=@output+@lf+@cr+
                REPLICATE(@tab, @@NESTLEVEL-1)+
                '<'+@key+'>'+
                    ISNULL(REPLACE(
                        REPLACE(@value, '\"', '"'), '\\', '\'), '')+
                    (CASE WHEN @nested=1
                        THEN @lf+@cr+REPLICATE(@tab, @@NESTLEVEL-1)
                        ELSE ''
                    END)+
                '</'+@key+'>';

            --- And again, error checks:
            ---
            --- 1. If these are multiple values, the next character
            ---    should be a comma:
            IF (@array=0 AND @Json!='' AND LEFT(@Json, 1)!=',')
                RETURN @output+'Expected "," after value, found "'+
                    LEFT(@Json, 1)+'"!';

            --- 2. .. or, if this is an array, the next character
            --- should be a comma or a closing angle bracket:
            IF (@array=1 AND LEFT(@Json, 1) NOT IN (',', ']'))
                RETURN @output+'In array, expected "]" or "," after '+
                    'value, found "'+LEFT(@Json, 1)+'"!';

            --- If this is where the array is closed (i.e. if it's a
            --- closing angle bracket)..
            IF (@array=1 AND LEFT(@Json, 1)=']') BEGIN;
                SET @array=NULL;
                SET @Json=LTRIM(SUBSTRING(@Json, 2, LEN(@Json)));

                --- After a closed array, there should be a comma:
                IF (LEFT(@Json, 1) NOT IN ('', ',')) BEGIN
                    RETURN 'Closed array, expected ","!';
                END;
            END;

            SET @Json=LTRIM(SUBSTRING(@Json, 2, LEN(@Json)+1));
            IF (@array=0) SET @array=NULL;

        END;
    END;

    --- Return the output:
    RETURN CAST(@output AS xml);
END;

GO