IF OBJECT_ID ('dbo.InsJobOrder',N'TR') IS NOT NULL
   DROP TRIGGER [dbo].[InsJobOrder];
GO

--------------------------------------------------------------
-- Процедура ins_ExportMaterialLotToSAP
IF OBJECT_ID ('dbo.ins_ExportMaterialLotToSAP',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_ExportMaterialLotToSAP;
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ins_ExportMaterialLotToSAP]
@MaterialLotID INT
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

      DECLARE @OPENQUERY    NVARCHAR(4000),
              @LinkedServer NVARCHAR(4000);

      SET @LinkedServer='[KRR-SQL23-ZPP]';
      IF @@SERVERNAME='KRR-SQL-PACLX02\PACLX02'
         SET @LinkedServer='[KRR-SQL24-ZPP]';

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

--------------------------------------------------------------
-- Процедура ins_JobOrderToPrint
IF OBJECT_ID ('dbo.ins_JobOrderToPrint',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_JobOrderToPrint;
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ins_JobOrderToPrint]
@EquipmentID     INT,
@MaterialLotID   INT,
@Command         NVARCHAR(50),
@CommandRule     NVARCHAR(50) = NULL,
@WorkRequestID   INT = NULL

AS
BEGIN

   DECLARE @JobOrderID    INT,
           @err_message   NVARCHAR(255);

   IF NOT EXISTS (SELECT NULL 
                  FROM [dbo].[Equipment] eq INNER JOIN [dbo].[EquipmentClass] eqc ON (eqc.[ID] = eq.[EquipmentClassID] AND eqc.[Code]=N'PRINTER')
                  WHERE eq.[ID]=@EquipmentID)
      BEGIN
         SET @err_message = N'Equipment ID=[' + CAST(@EquipmentID AS NVARCHAR) + N'] is not a PRINTER';
         THROW 60010, @err_message, 1;
      END;

   SET @JobOrderID=NEXT VALUE FOR [dbo].[gen_JobOrder];
   INSERT INTO [dbo].[JobOrder] ([ID],[WorkType],[DispatchStatus],[StartTime],[Command],[CommandRule],[WorkRequest])
   VALUES (@JobOrderID,N'Print',N'ToPrint',CURRENT_TIMESTAMP,@Command,@CommandRule,@WorkRequestID);

	 INSERT INTO [dbo].[OpEquipmentRequirement] ([EquipmentClassID],[EquipmentID],[JobOrderID])
   SELECT eq.[EquipmentClassID],eq.[ID],@JobOrderID
   FROM [dbo].[Equipment] eq
   WHERE [ID]=@EquipmentID;

   INSERT INTO [dbo].[Parameter] ([Value],[JobOrder],[PropertyType])
   SELECT @MaterialLotID,@JobOrderID,pt.[ID]
   FROM [dbo].[PropertyTypes] pt
   WHERE pt.[Value]=N'MaterialLotID';

   IF @Command=N'Print'
      EXEC DBO.[ins_ExportMaterialLotToSAP] @MaterialLotID=@MaterialLotID;

END;
GO

--------------------------------------------------------------
-- Процедура ins_MaterialLotByEquipment
IF OBJECT_ID ('dbo.ins_MaterialLotByEquipment',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_MaterialLotByEquipment;
GO

SET QUOTED_IDENTIFIER ON
GO

--------------------------------------------------------------
-- Используется для тестовой печати и для ручной печати с вводом кол-ва
CREATE PROCEDURE [dbo].[ins_MaterialLotByEquipment]
@EquipmentID   INT,
@Quantity      INT = NULL
AS
BEGIN

DECLARE @MaterialLotID    INT,
        @WorkDefinitionID INT,
        @AUTO_MANU_VALUE [NVARCHAR](50),
        @FactoryNumber   [NVARCHAR](12),
        @PrinterID       [NVARCHAR](50),
        @Status          [NVARCHAR](250),
	    @JobOrderID      INT,
        @WorkType	     [NVARCHAR](50);

SET @Status=N'0';
SET @AUTO_MANU_VALUE=N'0';
SET @WorkType = [dbo].[get_CurrentWorkType](@EquipmentID);
SET @JobOrderID=dbo.get_EquipmentPropertyValue(@EquipmentID,N'JOB_ORDER_ID');

IF @Quantity IS NOT NULL
   BEGIN
      SET @Status=[dbo].[get_MaterialLotStatusByWorkType](@WorkType);
      SET @AUTO_MANU_VALUE=N'1';
      SET @Quantity=dbo.get_RoundedWeightByEquipment(@Quantity,@EquipmentID);
   END;

IF @WorkType IN (N'Sort',N'Reject')	     
    SET @FactoryNumber=[dbo].[get_JobOrderPropertyValue](@JobOrderID,N'FACTORY_NUMBER');	   
ELSE 
    SET @FactoryNumber=[dbo].[get_GenMaterialLotNumber](@EquipmentID,NEXT VALUE FOR dbo.gen_MaterialLotNumber);

if @WorkType IN (N'Separate')
	begin
		DECLARE @LinkFactoryNumber   [NVARCHAR](12);
        SET @LinkFactoryNumber=[dbo].[get_GenMaterialLotNumber](@EquipmentID,NEXT VALUE FOR dbo.gen_MaterialLotNumber);
        SET @FactoryNumber=[dbo].[get_JobOrderPropertyValue](@JobOrderID,N'FACTORY_NUMBER');
        EXEC [dbo].[ins_MaterialLotWithLinks] @FactoryNumber       = @FactoryNumber,
                                                  @Status              = @Status,
                                                  @Quantity            = @Quantity,
                                                  @LinkFactoryNumber   = @LinkFactoryNumber,
                                                  @MaterialLotID	     = @MaterialLotID OUTPUT;
	end
else
	EXEC [dbo].[ins_MaterialLot] @FactoryNumber = @FactoryNumber,
                             @Status        = @Status,
                             @Quantity      = @Quantity,
                             @MaterialLotID = @MaterialLotID OUTPUT;

SET @WorkDefinitionID=dbo.get_EquipmentPropertyValue(@EquipmentID,N'WORK_DEFINITION_ID');

IF @WorkDefinitionID IS NOT NULL
   BEGIN
      DECLARE @MEASURE_TIME NVARCHAR(50),
              @MILL_ID      NVARCHAR(50),
              @NEMERA       NVARCHAR(50);
      SET @MEASURE_TIME=CONVERT(NVARCHAR,CURRENT_TIMESTAMP,121);
      SET @MILL_ID=[dbo].[get_EquipmentPropertyValue]([dbo].[get_ParentEquipmentIDByClass](@EquipmentID,N'MILL'),N'MILL_ID');      
      SET @NEMERA=[dbo].[get_JobOrderPropertyValue](@JobOrderID,N'NEMERA');
      
	 EXEC [dbo].[ins_MaterialLotPropertyByWorkDefinition] @WorkDefinitionID = @WorkDefinitionID,
                                                           @MaterialLotID    = @MaterialLotID,
                                                           @MEASURE_TIME     = @MEASURE_TIME,
                                                           @AUTO_MANU_VALUE  = @AUTO_MANU_VALUE,
                                                           @MILL_ID          = @MILL_ID,
                                                           @NEMERA           = @NEMERA;

      SET @PrinterID = [dbo].[get_EquipmentPropertyValue](@EquipmentID,N'USED_PRINTER');
      EXEC [dbo].[ins_JobOrderPrintLabel] @PrinterID     = @PrinterID,
                                          @MaterialLotID = @MaterialLotID,
                                          @Command       = N'Print';
   END;

IF @WorkType = N'Separate'
    EXEC [dbo].[set_DecreasePacksLeft] @EquipmentID=@EquipmentID;
IF @WorkType IN (N'Sort',N'Reject')
    EXEC dbo.set_StandardMode @EquipmentID=@EquipmentID; 

END;
GO
