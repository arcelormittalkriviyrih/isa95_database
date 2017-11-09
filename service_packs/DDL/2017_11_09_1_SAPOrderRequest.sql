SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID ('dbo.v_SAPOrderRequest', 'V') IS NOT NULL
	DROP VIEW dbo.[v_SAPOrderRequest];
GO
 
CREATE VIEW [dbo].[v_SAPOrderRequest]
AS
SELECT p.ID,
       pt. [Value] PropertyType,
       case
         WHEN pt.[Value] = N'SAP_SERVICE_LOGIN' THEN
          DECRYPTBYPASSPHRASE(N'arcelor', p.[Value])
         WHEN pt.[Value] = N'SAP_SERVICE_PASS' and p. [Value] IS NOT NULL THEN
          'hidden_password'
         ELSE
          p.[Value]
       END as [ Value ]
  FROM JobOrder o, [Parameter] p, dbo.PropertyTypes pt
 WHERE WorkType = 'SAPOrderRequest'
   AND p.JobOrder = o.ID
   AND pt.ID = p.PropertyType;
GO