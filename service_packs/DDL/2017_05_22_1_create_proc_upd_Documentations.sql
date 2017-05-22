
IF OBJECT_ID ('dbo.upd_Documentations',N'P') IS NOT NULL
  DROP PROCEDURE dbo.upd_Documentations;
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


create PROCEDURE [dbo].[upd_Documentations]
   @DocumentationsID int,
   @Status nvarchar(20)
AS
BEGIN
	IF @DocumentationsID IS NULL
    THROW 60001, N'DocumentationsID param required', 1;

	UPDATE [dbo].[Documentations]
	SET  
		[Status]	= @Status, 
		[EndTime]	= getdate()
	WHERE  ID = @DocumentationsID
          
END

GO