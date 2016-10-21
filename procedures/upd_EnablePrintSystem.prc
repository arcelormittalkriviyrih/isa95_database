--------------------------------------------------------------
-- Процедура upd_EnablePrintSystem
IF OBJECT_ID ('dbo.upd_EnablePrintSystem',N'P') IS NOT NULL
   DROP PROCEDURE dbo.upd_EnablePrintSystem;
GO

SET QUOTED_IDENTIFIER ON
GO
/*
	Procedure: upd_EnablePrintSystem
	Процедура включения/выключения системы печети бирок.

	Parameters:
		Enabled    - Система включена
		
*/
CREATE PROCEDURE [dbo].[upd_EnablePrintSystem]
@Enabled      bit
AS
BEGIN
   DECLARE @ID            INT,
           @err_message   NVARCHAR(255);

   IF @Enabled IS NULL
      THROW 60001, N'Enabled param required', 1;

   IF @Enabled=1
         EXEC dbo.upd_GlobalOption
              @OptionCode = N'PRINT_SYSTEM_ENABLED',
              @OptionValue = N'true';
  ELSE 
      EXEC dbo.upd_GlobalOption
              @OptionCode = N'PRINT_SYSTEM_ENABLED',
              @OptionValue = N'false';

  
END;
GO
