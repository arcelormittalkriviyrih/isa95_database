SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
IF OBJECT_ID('dbo.gen_ErrorLog', N'SO') IS NULL CREATE SEQUENCE dbo.gen_ErrorLog
                                                     AS INT
                                                     START WITH 1
                                                     INCREMENT BY 1
                                                     NO CACHE;
GO
CREATE TABLE dbo.ErrorLog
(ID            INT PRIMARY KEY,
 ERROR_DATE    DATETIMEOFFSET NOT NULL,
 ERROR_DETAILS NVARCHAR(2000) NULL,
 ERROR_MESSAGE NVARCHAR(2000) NULL
);
GO
ALTER TABLE dbo.ErrorLog
ADD DEFAULT(NEXT VALUE FOR dbo.gen_ErrorLog) FOR ID;
GO
ALTER TABLE dbo.ErrorLog
ADD DEFAULT(CURRENT_TIMESTAMP) FOR ERROR_DATE;
GO