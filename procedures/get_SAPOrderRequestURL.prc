SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID ('dbo.get_SAPOrderRequestURL',N'P') IS NOT NULL
   DROP PROCEDURE dbo.get_SAPOrderRequestURL;
GO
--------------------------------------------------------------
-- Используется для генерации URL для обращения к SAP сервису для получения информации о заказе
CREATE PROCEDURE [dbo].[get_SAPOrderRequestURL](
	   @PROD_ORDER [nvarchar](50), @URL nvarchar(1000) OUTPUT)
WITH ENCRYPTION
AS
BEGIN
	DECLARE @SAP_SERVICE_URL nvarchar(500), @SAP_SERVICE_LOGIN nvarchar(50), @SAP_SERVICE_PASS nvarchar(50);
	SET @SAP_SERVICE_URL =
	(
		SELECT p.[Value]
		FROM JobOrder AS o, [Parameter] AS p, dbo.PropertyTypes AS pt
		WHERE WorkType = 'SAPOrderRequest' AND 
			  p.JobOrder = o.ID AND 
			  pt.ID = p.PropertyType AND 
			  pt.[Value] = N'SAP_SERVICE_URL'
	);
	SET @SAP_SERVICE_LOGIN =
	(
		SELECT DECRYPTBYPASSPHRASE(N'arcelor', p.[Value])
		FROM JobOrder AS o, [Parameter] AS p, dbo.PropertyTypes AS pt
		WHERE WorkType = 'SAPOrderRequest' AND 
			  p.JobOrder = o.ID AND 
			  pt.ID = p.PropertyType AND 
			  pt.[Value] = N'SAP_SERVICE_LOGIN'
	);
	SET @SAP_SERVICE_PASS =
	(
		SELECT DECRYPTBYPASSPHRASE(N'arcelor', p.[Value])
		FROM JobOrder AS o, [Parameter] AS p, dbo.PropertyTypes AS pt
		WHERE WorkType = 'SAPOrderRequest' AND 
			  p.JobOrder = o.ID AND 
			  pt.ID = p.PropertyType AND 
			  pt.[Value] = N'SAP_SERVICE_PASS'
	);

	--https://krrzdmm1.europe.mittalco.com:50001/XMII/Runner?Transaction=DataTransferToPrintLabelSystem/SAP/GetSelesOrderInformation.trx
	--&SLS_ORDR=&OutputParameter=RSLT&XacuteLoginName=&XacuteLoginPassword=&Content-Type=text/xml

	SET @URL = @SAP_SERVICE_URL+N'&SLS_ORDR='+@PROD_ORDER+N'&OutputParameter=RSLT&XacuteLoginName='+@SAP_SERVICE_LOGIN+N'&XacuteLoginPassword='+@SAP_SERVICE_PASS+N'&Content-Type=text/xml';

END;