SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID ('dbo.v_KP4_ScrapReceiver',N'V') IS NOT NULL
  DROP VIEW dbo.v_KP4_ScrapReceiver;
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE VIEW [dbo].[v_KP4_ScrapReceiver]
AS
SELECT        ID, [Description] as Name
FROM          [dbo].[Equipment]
WHERE        (ID IN (112,113))




GO