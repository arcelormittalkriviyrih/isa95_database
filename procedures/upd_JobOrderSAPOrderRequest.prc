SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID ('dbo.upd_JobOrderSAPOrderRequest',N'P') IS NOT NULL
   DROP PROCEDURE dbo.upd_JobOrderSAPOrderRequest;
GO
/*
	Procedure: upd_JobOrderSAPOrderRequest
	Процедура изменения параметров запроса в SAP.

	Parameters:
		ServiceURL - Service URL,
		Login	   - Логин,
		Password   - Пароль.

		
*/

CREATE PROCEDURE [dbo].[upd_JobOrderSAPOrderRequest]
@ServiceURL NVARCHAR(1000),
@Login		NVARCHAR(250),
@Password   NVARCHAR(250)
WITH ENCRYPTION 
AS
BEGIN
   DECLARE @JobOrderID            INT,
		  @SAP_SERVICE_URL	  INT,
		  @SAP_SERVICE_PASS	  INT,
		  @SAP_SERVICE_LOGIN  INT;

   IF @ServiceURL IS NULL
      THROW 60001, N'ServiceURL param required', 1;
   ELSE IF @Login IS NULL
      THROW 60001, N'Login param required', 1;
   ELSE IF @Password IS NULL
      THROW 60001, N'Password param required', 1;

   SET @JobOrderID = (SELECT max(ID) from JobOrder where WorkType=N'SAPOrderRequest');

   IF @JobOrderID IS NULL
	   BEGIN
		   SET @JobOrderID=NEXT VALUE FOR [dbo].[gen_JobOrder];
		   INSERT INTO [dbo].[JobOrder] ([ID],[WorkType])
		   VALUES (@JobOrderID,N'SAPOrderRequest');
	   END

    SET @SAP_SERVICE_URL = (SELECT ID from dbo.PropertyTypes where [Value]=N'SAP_SERVICE_URL');
    SET @SAP_SERVICE_LOGIN = (SELECT ID from dbo.PropertyTypes where [Value]=N'SAP_SERVICE_LOGIN');
    SET @SAP_SERVICE_PASS = (SELECT ID from dbo.PropertyTypes where [Value]=N'SAP_SERVICE_PASS');

	MERGE [dbo].[Parameter] p
		USING
		(
			SELECT @ServiceURL AS vValue, @JobOrderID AS vJobOrder, @SAP_SERVICE_URL AS vPropertyType
			/*UNION
			SELECT @Login, @JobOrderID, @SAP_SERVICE_LOGIN
			UNION
			SELECT @Password, @JobOrderID, @SAP_SERVICE_PASS*/
			UNION
			SELECT cast(ENCRYPTBYPASSPHRASE(N'arcelor', @Login) as nvarchar), @JobOrderID, @SAP_SERVICE_LOGIN
			UNION
			SELECT cast(ENCRYPTBYPASSPHRASE(N'arcelor', @Password) as nvarchar), @JobOrderID, @SAP_SERVICE_PASS
		) val
		ON( p.JobOrder = val.vJobOrder AND 
			p.PropertyType = val.vPropertyType
		  )
		WHEN MATCHED
			  THEN UPDATE SET p.[Value] = val.vValue
		WHEN NOT MATCHED
			  THEN INSERT([Value], JobOrder, [PropertyType]) VALUES( val.vValue, val.vJobOrder, val.vPropertyType );

END;


GO


