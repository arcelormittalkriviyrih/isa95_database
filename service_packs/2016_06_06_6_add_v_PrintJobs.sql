SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO

IF OBJECT_ID('dbo.v_PrintJobs', N'V') IS NOT NULL
    DROP VIEW [dbo].[v_PrintJobs];
GO

CREATE VIEW [dbo].[v_PrintJobs]
AS
     SELECT ID,
            DispatchStatus
     FROM dbo.JobOrder
     WHERE WorkType = N'Print';
GO

IF OBJECT_ID('dbo.v_PrintJobParameters', N'V') IS NOT NULL
    DROP VIEW [dbo].[v_PrintJobParameters];
GO

CREATE VIEW [dbo].[v_PrintJobParameters]
AS
     SELECT p.ID,
            p.[Value],
            p.JobOrder AS JobOrderID,
            pt.[Value] Property
     FROM Parameter p,
          PropertyTypes pt
     WHERE pt.ID = p.PropertyType
     UNION
     SELECT er.ID,
            er.EquipmentID,
            er.JobOrderID,
            'PrinterID' AS Property
     FROM OpEquipmentRequirement er;
GO

INSERT INTO [dbo].[PropertyTypes]([Value],[Description]) VALUES (N'MaterialLotID',N'ID бирки');
GO

IF OBJECT_ID('dbo.v_EquipmentProperty', N'V') IS NOT NULL
    DROP VIEW [dbo].[v_EquipmentProperty];
GO

CREATE VIEW [dbo].[v_EquipmentProperty]
AS
     SELECT ep.ID,
            ep.[Value],
            ep.EquipmentID,
            ecp.[Description],
            ecp.[Value] Property
     FROM dbo.EquipmentProperty ep,
          dbo.EquipmentClassProperty ecp
     WHERE ecp.ID = ep.ClassPropertyID;
GO


