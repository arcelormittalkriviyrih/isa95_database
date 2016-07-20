IF OBJECT_ID ('dbo.DelFiles',N'TR') IS NOT NULL
   DROP TRIGGER [dbo].[DelFiles];
GO

CREATE TRIGGER [dbo].[DelFiles] ON [dbo].[Files]
AFTER DELETE
AS
BEGIN

   SET NOCOUNT ON;

   DECLARE @PreviewID int;

   SELECT @PreviewID=[PreviewID]
   FROM DELETED;

   DELETE FROM [dbo].[Files]
   WHERE [ID]=@PreviewID;

END
GO