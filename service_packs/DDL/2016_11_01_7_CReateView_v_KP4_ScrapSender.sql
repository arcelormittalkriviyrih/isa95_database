SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID ('dbo.v_KP4_ScrapSender',N'V') IS NOT NULL
  DROP VIEW dbo.v_KP4_ScrapSender;
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE VIEW [dbo].[v_KP4_ScrapSender]
AS
SELECT        ID, [Description] as Name
FROM          [dbo].[Equipment]
WHERE        (ID IN (148,149,231,273,298))



GO