--------------------------------------------------------------
-- Процедура upd_GlobalOption
IF OBJECT_ID ('dbo.upd_GlobalOption',N'P') IS NOT NULL
   DROP PROCEDURE dbo.upd_GlobalOption;
GO

SET QUOTED_IDENTIFIER ON
GO
/*
	Procedure: upd_GlobalOption
	Процедура изменения значение глобальных опций.

	Parameters:
		OptionCode    - Код опции,
		OptionValue   - Значение опции
		
*/
CREATE PROCEDURE [dbo].[upd_GlobalOption]
@OptionCode      NVARCHAR(50),
@OptionValue     NVARCHAR(255)
AS
BEGIN
   DECLARE @ID            INT,
           @err_message   NVARCHAR(255);

   IF @OptionCode IS NULL
      THROW 60001, N'OptionCode param required', 1;

   SELECT @ID=o.[ID]
   FROM [dbo].[GlobalOptions] o
   WHERE o.[OptionCode]=@OptionCode;

    IF @ID IS NULL
      BEGIN
         SET @err_message = N'Global option with code=['+@OptionCode+N'] not found';
         THROW 60010, @err_message, 1;
      END;

   UPDATE [dbo].[GlobalOptions]
   SET [OptionValue]=@OptionValue
   WHERE [ID]=@ID;
  
END;
GO
