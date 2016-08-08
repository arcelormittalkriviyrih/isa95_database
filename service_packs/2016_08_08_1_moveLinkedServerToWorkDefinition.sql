SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

DECLARE @WorkDefinitionID int;

IF NOT EXISTS
(
	SELECT NULL
	FROM [dbo].[WorkDefinition]
	WHERE [WorkType] = N'SAPExport'
)
BEGIN
   SET @WorkDefinitionID=NEXT VALUE FOR [dbo].[gen_WorkDefinition];
   INSERT INTO [dbo].[WorkDefinition] ([ID],[WorkType],[PublishedDate], Parameter) VALUES (@WorkDefinitionID,N'SAPExport',CURRENT_TIMESTAMP, N'[KRR-SQL23-ZPP]');
END;

SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID ('dbo.ins_JobOrderSAPExport',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_JobOrderSAPExport;
GO
--------------------------------------------------------------

/*
	Procedure: ins_JobOrderSAPExport
	Используется для создания задания на отправку бирки в САП.

	Parameters:

		MaterialLotID  - MaterialLot ID,
		WorkRequestID  - WorkRequest ID

	
*/
CREATE PROCEDURE [dbo].[ins_JobOrderSAPExport]
@MaterialLotID   INT,
@WorkRequestID   INT = NULL
AS
BEGIN

   DECLARE @JobOrderID    INT,
           @err_message   NVARCHAR(255),
		   @LinkedServer  NVARCHAR(50);

   SET @LinkedServer=(SELECT top 1 Parameter from WorkDefinition where WORKType='SAPExport' order by ID desc);

   SET @JobOrderID=NEXT VALUE FOR [dbo].[gen_JobOrder];
   INSERT INTO [dbo].[JobOrder] ([ID],[WorkType],[DispatchStatus],[StartTime],[WorkRequest],CommandRule)
   VALUES (@JobOrderID,N'SAPExport',N'TODO',CURRENT_TIMESTAMP,@WorkRequestID,@LinkedServer);
 
   INSERT INTO [dbo].[Parameter] ([Value],[JobOrder],[PropertyType])
   SELECT @MaterialLotID,@JobOrderID,pt.[ID]
   FROM [dbo].[PropertyTypes] pt
   WHERE pt.[Value]=N'MaterialLotID';

END;

GO


--------------------------------------------------------------
-- Процедура ins_ExportMaterialLotToSAP
IF OBJECT_ID ('dbo.ins_ExportMaterialLotToSAP',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_ExportMaterialLotToSAP;
GO

SET QUOTED_IDENTIFIER ON
GO
/*
	Procedure: ins_ExportMaterialLotToSAP
	Отправляет информацию о напечатанной бирке в SAP.

	Parameters:

      MaterialLotID - MaterialLot ID.
*/
CREATE PROCEDURE [dbo].[ins_ExportMaterialLotToSAP]
@MaterialLotID INT,
@LinkedServer NVARCHAR(50)
AS
BEGIN

   SET NOCOUNT ON;

   --BEGIN TRY

      IF @MaterialLotID IS NULL
         RETURN;

      DECLARE @FactoryNumber NVARCHAR(250),
              @Quantity      INT,
              @Status        NVARCHAR(250);

      DECLARE @tblProperty   TABLE(ID          INT,
                                   Description NVARCHAR(50),
                                   Value       NVARCHAR(50));

      SELECT @FactoryNumber=[FactoryNumber],
             @Quantity=[Quantity],
             @Status=[Status]
      FROM [dbo].[MaterialLot]
      WHERE [ID]=@MaterialLotID;

      IF ISNULL(@Quantity,0)=0
         RETURN;

      INSERT @tblProperty
      SELECT mlp.PropertyType,pt.[Value],mlp.[Value]
      FROM [dbo].[MaterialLotProperty] mlp INNER JOIN [dbo].[PropertyTypes] pt ON (pt.ID = mlp.PropertyType)
      WHERE MaterialLotID=@MaterialLotID;

      SET XACT_ABORT ON;

      CREATE TABLE #ZPP_WEIGHT_PROKAT (AUFNR    NVARCHAR(50),
                                       MATNR    NVARCHAR(50),
                                       DATE_P   DATE,
                                       N_BIR    NUMERIC(10,0),
                                       NSMEN    NUMERIC(10,0),
                                       NBRIG    NUMERIC(10,0),
                                       PARTY    NVARCHAR(50),
                                       BUNT     NUMERIC(10,0),
                                       MAS      INT,
                                       PLAVK    NVARCHAR(50),
                                       OLD_BIR  NVARCHAR(250),
                                       AUART    NVARCHAR(50),
                                       EO       NVARCHAR(250),
                                       N_ORDER  NVARCHAR(50),
                                       DT       DATETIME,
                                       EO_OLD   NVARCHAR(250),
                                       REZIM    NUMERIC);

      INSERT INTO #ZPP_WEIGHT_PROKAT
      SELECT (SELECT t.[Value] FROM @tblProperty t WHERE t.[Description]=N'PROD_ORDER'), --AUFNR
             (SELECT t.[Value] FROM @tblProperty t WHERE t.[Description]=N'MATERIAL_NO' AND EXISTS (SELECT NULL FROM @tblProperty tt WHERE tt.[Description]=N'NEMERA' AND UPPER(tt.[Value])=N'TRUE')), --MATNR
             (SELECT CONVERT(DATE,t.[Value],104) FROM @tblProperty t WHERE t.[Description]=N'PROD_DATE' AND ISDATE(t.[Value])=1), --DATE_P
              CAST(SUBSTRING(@FactoryNumber,9,12) AS NUMERIC(10,0)), --N_BIR
             (SELECT CAST(t.[Value] AS NUMERIC(10,0)) FROM @tblProperty t WHERE t.[Description]=N'CHANGE_NO' AND ISNUMERIC(t.[Value])=1), --NSMEN
             (SELECT CAST(t.[Value] AS NUMERIC(10,0)) FROM @tblProperty t WHERE t.[Description]=N'BRIGADE_NO' AND ISNUMERIC(t.[Value])=1), --NBRIG
             (SELECT t.[Value] FROM @tblProperty t WHERE [Description]=N'PART_NO'), --PARTY
             isnull((SELECT CAST(t.[Value] AS NUMERIC(10,0)) FROM @tblProperty t WHERE t.[Description]=N'BUNT_NO' AND ISNUMERIC(t.[Value])=1),0), --BUNT
              @Quantity, --MAS
             (SELECT t.[Value] FROM @tblProperty t WHERE t.[Description]=N'MELT_NO'), --PLAVK
              @Status, --OLD_BIR
             (SELECT t.[Value] FROM @tblProperty t WHERE t.[Description]=N'MILL_ID'), --AUART
              @FactoryNumber, --EO
              ISNULL((SELECT CAST(t.[Value] AS NUMERIC(10,0)) FROM @tblProperty t WHERE t.[Description]=N'LEAVE_NO' AND ISNUMERIC(t.[Value])=1),0), --N_ORDER,
             (SELECT CONVERT(DATETIME,t.[Value],121) FROM @tblProperty t WHERE t.[Description]=N'MEASURE_TIME' AND ISDATE(t.[Value])=1), --DT,
              ISNULL((CASE @Status
                      WHEN '1' THEN 0 
                      ELSE (SELECT TOP 1 mm.[FactoryNumber]
                            FROM [dbo].[MaterialLotLinks] ml INNER JOIN [dbo].[MaterialLot] mm ON (mm.[ID]=ml.[MaterialLot1])
                            WHERE (ml.[MaterialLot2]=@MaterialLotID))
                      END),0), --EO_OLD,
             (SELECT ABS(CAST(t.[Value] AS NUMERIC)-1) FROM @tblProperty t WHERE t.[Description]=N'AUTO_MANU_VALUE' AND ISNUMERIC(t.[Value])=1); --REZIM

      DECLARE @OPENQUERY    NVARCHAR(4000);


      SET @OPENQUERY = 'INSERT OPENQUERY ('+ @LinkedServer + ',''SELECT AUFNR,MATNR,DATE_P,N_BIR,NSMEN,NBRIG,PARTY,BUNT,MAS,PLAVK,OLD_BIR,AUART,EO,N_ORDER,DT,EO_OLD,REZIM FROM ZPP.ZPP_WEIGHT_PROKAT'') '+
                       '(AUFNR,MATNR,DATE_P,N_BIR,NSMEN,NBRIG,PARTY,BUNT,MAS,PLAVK,OLD_BIR,AUART,EO,N_ORDER,DT,EO_OLD,REZIM) (SELECT * FROM #ZPP_WEIGHT_PROKAT)';
      EXEC (@OPENQUERY);

      DROP TABLE #ZPP_WEIGHT_PROKAT;
   --END TRY

   --BEGIN CATCH

   --  EXEC [dbo].[ins_ErrorLog];

   --END CATCH

END;
GO

SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID ('dbo.exec_SAPExport',N'P') IS NOT NULL
   DROP PROCEDURE dbo.exec_SAPExport;
GO
--------------------------------------------------------------
/*
	Procedure: exec_SAPExport
	Используется для выполнения экспорта бирок в САП.
*/

CREATE PROCEDURE [dbo].[exec_SAPExport]
AS
BEGIN

	DECLARE @MaterialLotID int, @JobOrderID int, @LinkedServer NVARCHAR(50);


	DECLARE selMaterialLots CURSOR
	FOR SELECT p.[Value], o.ID, o.CommandRule
		FROM [dbo].JobOrder AS o, [dbo].[Parameter] AS p, [dbo].[PropertyTypes] AS pt
		WHERE o.ID = p.JobOrder AND 
			  p.PropertyType = pt.ID AND 
			  pt.[Value] = N'MaterialLotID' AND 
			  o.WorkType = N'SAPExport' AND
			  o.DispatchStatus = N'TODO';
	OPEN selMaterialLots;
	FETCH NEXT FROM selMaterialLots INTO @MaterialLotID, @JobOrderID, @LinkedServer;
	WHILE @@FETCH_STATUS = 0
	BEGIN
		BEGIN TRY
			EXEC DBO.[ins_ExportMaterialLotToSAP] @MaterialLotID = @MaterialLotID, @LinkedServer = @LinkedServer;
			update [dbo].JobOrder set DispatchStatus=N'Done',EndTime=CURRENT_TIMESTAMP where id=@JobOrderID;
		END TRY
		BEGIN CATCH

			EXEC [dbo].[ins_ErrorLog];
		END CATCH;

		FETCH NEXT FROM selMaterialLots INTO @MaterialLotID, @JobOrderID;
	END;
	CLOSE selMaterialLots;
	DEALLOCATE selMaterialLots;
END;

GO



 
