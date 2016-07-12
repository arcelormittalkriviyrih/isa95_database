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

   INSERT OPENQUERY ([KRR-SQL23-ZPP],'SELECT AUFNR,MATNR,DATE_P,N_BIR,NSMEN,NBRIG,PARTY,BUNT,MAS,PLAVK,OLD_BIR,AUART,EO,N_ORDER,DT,EO_OLD,REZIM FROM ZPP.ZPP_WEIGHT_PROKAT')
   VALUES ((SELECT t.[Value] FROM @tblProperty t WHERE t.[Description]=N'COMM_ORDER'), --AUFNR
           (SELECT t.[Value] FROM @tblProperty t WHERE t.[Description]=N'MATERIAL_NO'), --MATNR
           (SELECT CONVERT(DATE,t.[Value],104) FROM @tblProperty t WHERE t.[Description]=N'PROD_DATE' AND ISDATE(t.[Value])=1), --DATE_P
            CAST(SUBSTRING(@FactoryNumber,9,12) AS NUMERIC(10,0)), --N_BIR
           (SELECT CAST(t.[Value] AS NUMERIC(10,0)) FROM @tblProperty t WHERE t.[Description]=N'CHANGE_NO' AND ISNUMERIC(t.[Value])=1), --NSMEN
           (SELECT CAST(t.[Value] AS NUMERIC(10,0)) FROM @tblProperty t WHERE t.[Description]=N'BRIGADE_NO' AND ISNUMERIC(t.[Value])=1), --NBRIG
           (SELECT t.[Value] FROM @tblProperty t WHERE [Description]=N'PART_NO'), --PARTY
           (SELECT CAST(t.[Value] AS NUMERIC(10,0)) FROM @tblProperty t WHERE t.[Description]=N'BUNT_NO' AND ISNUMERIC(t.[Value])=1), --BUNT
            @Quantity, --MAS
           (SELECT t.[Value] FROM @tblProperty t WHERE t.[Description]=N'MELT_NO'), --PLAVK
            @Status, --OLD_BIR
           (SELECT t.[Value] FROM @tblProperty t WHERE t.[Description]=N'MILL_ID'), --AUART
            @FactoryNumber, --EO
           (SELECT CAST(t.[Value] AS NUMERIC(9,0)) FROM @tblProperty t WHERE t.[Description]=N'LEAVE_NO' AND ISNUMERIC(t.[Value])=1), --N_ORDER,
           (SELECT CONVERT(DATETIME,t.[Value],121) FROM @tblProperty t WHERE t.[Description]=N'MEASURE_TIME' AND ISDATE(t.[Value])=1), --DT,
           (SELECT TOP 1 mm.[FactoryNumber]
            FROM [dbo].[MaterialLotLinks] ml INNER JOIN [dbo].[MaterialLot] mm ON (mm.[ID]=ml.[MaterialLot1])
            WHERE (ml.[MaterialLot2]=@MaterialLotID)), --EO_OLD,
           (SELECT CAST(t.[Value] AS NUMERIC) FROM @tblProperty t WHERE t.[Description]=N'AUTO_MANU_VALUE' AND ISNUMERIC(t.[Value])=1) --REZIM
          );

END;
GO

