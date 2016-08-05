--------------------------------------------------------------
-- Процедура ins_MaterialLotWithLinks
IF OBJECT_ID ('dbo.ins_MaterialLotWithLinks',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_MaterialLotWithLinks;
GO

SET QUOTED_IDENTIFIER ON
GO
/*
	Procedure: ins_MaterialLotWithLinks
	Создаёт новый  и запись в таблице связи бирок.

	Parameters:

		FactoryNumber     - Номер бирки,
		Status            - Статус,
		Quantity          - Вес,
		LinkType          - Тип связки,
		LinkFactoryNumber - Номер новой бирки,
		MaterialLotID     - MaterialLot ID OUTPUT

	
*/
CREATE PROCEDURE [dbo].[ins_MaterialLotWithLinks]
@FactoryNumber       NVARCHAR(250),
@Status              NVARCHAR(250),
@Quantity            INT = NULL,
@LinkType            INT = 1,
@LinkFactoryNumber   NVARCHAR(250) = NULL,
@MaterialLotID       INT OUTPUT
AS
BEGIN

  DECLARE @LastMaterialLotID INT,
          @LastQuantity      INT,
          @err_message       NVARCHAR(255);

   SELECT @LastMaterialLotID=ml.[ID],
          @LastQuantity=ml.[Quantity]
   FROM (SELECT ml.[ID],
                ml.[Quantity],
                ROW_NUMBER() OVER (PARTITION BY ml.[FactoryNumber] ORDER BY ml.[CreateTime] DESC, ml.[ID] DESC) RowNumber
         FROM [dbo].[MaterialLot] ml
         WHERE ml.[FactoryNumber]=@FactoryNumber) ml
   WHERE ml.RowNumber=1;

   IF @LastMaterialLotID IS NULL
      BEGIN
         SET @err_message = N'By FactoryNumber [' + @FactoryNumber + N'] MaterialLot not found';
         THROW 60010, @err_message, 1;
      END;

   SET @MaterialLotID=NEXT VALUE FOR [dbo].[gen_MaterialLot];
   INSERT INTO [dbo].[MaterialLot] ([ID],[FactoryNumber],[Status],[Quantity])
   VALUES (@MaterialLotID,ISNULL(@LinkFactoryNumber,@FactoryNumber),@Status,ISNULL(@Quantity,@LastQuantity));

   INSERT INTO [dbo].[MaterialLotLinks] ([MaterialLot1],[MaterialLot2],[LinkType])
   VALUES (@LastMaterialLotID,@MaterialLotID,@LinkType);

END;
GO
