IF NOT EXISTS(SELECT NULL
              FROM information_schema.columns
              WHERE table_name = 'Files'
                AND column_name = 'MIMEType')
   ALTER TABLE [dbo].[Files] ADD [MIMEType] [nvarchar](255) NULL
GO

IF OBJECT_ID ('dbo.InsUpdFiles',N'TR') IS NOT NULL
   DROP TRIGGER [dbo].[InsUpdFiles];
GO

CREATE TRIGGER [dbo].[InsUpdFiles] ON [dbo].[Files]
AFTER INSERT, UPDATE
AS
BEGIN

   SET NOCOUNT ON;

   DECLARE @ID int,
           @FileName VARCHAR(255),
           @FileExt  VARCHAR(10),
           @MIMEType VARCHAR(255);

   SELECT @ID=[ID],@FileName=REVERSE([FileName])
   FROM INSERTED;

   SET @FileExt = LOWER(REVERSE(SUBSTRING(@FileName,1,CHARINDEX('.',@FileName))));

   SELECT @MIMEType = mt.MIMEType
   FROM dbo.MIMEType mt
   WHERE mt.Extension=@FileExt;

   UPDATE [dbo].[Files]
   SET MIMEType = @MIMEType
   WHERE [ID]=@ID;

END
GO
