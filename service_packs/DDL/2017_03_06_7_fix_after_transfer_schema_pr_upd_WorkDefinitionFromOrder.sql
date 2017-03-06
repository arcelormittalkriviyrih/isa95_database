
IF OBJECT_ID (N'dbo.upd_WorkDefinitionFromOrder', N'P') IS NOT NULL
   DROP PROCEDURE [dbo].[upd_WorkDefinitionFromOrder];
GO   
   
/*
	Procedure: upd_WorkDefinitionFromOrder
	Процедура обновления WorkDefinition с заказа Маркетолога.

	Parameters:

		EquipmentID    - ID весов,
		COMM_ORDER     - Коммерческий заказ.
	
*/
CREATE PROCEDURE [dbo].[upd_WorkDefinitionFromOrder]
@EquipmentID    INT,
@COMM_ORDER     NVARCHAR(250)
AS
BEGIN

	DECLARE @WorkDefinitionID int, @OpSegmentRequirementID int, @err_message nvarchar(255);

	IF @COMM_ORDER IS NULL
		BEGIN 
			THROW 60001, N'Параметр "Коммерческий заказ" обязательный', 1;
		END
	ELSE
	BEGIN
		IF @EquipmentID IS NULL
			BEGIN 
				THROW 60001, N'EquipmentID param required', 1
			END;
	END;

	BEGIN TRY
		SELECT CAST(@COMM_ORDER AS numeric(11, 0));
	END TRY
	BEGIN CATCH
		THROW 60001, N'Параметр "Коммерческий заказ" должен быть числом', 1;
	END CATCH;

	--get Order ID by COMM_ORDER
	SELECT @OpSegmentRequirementID = sp.OpSegmentRequirement
	FROM SegmentParameter AS sp, PropertyTypes AS pt
	WHERE pt.ID = sp.PropertyType AND 
		  pt.Value = 'COMM_ORDER' AND 
		  sp.value = @COMM_ORDER;

	--Get WorkDefinitionID by COMM_ORDER
	SELECT @WorkDefinitionID = pso.WorkDefinitionID
	FROM [dbo].[v_ParameterSpecification_Order] AS pso
	WHERE pso.[Value] = @COMM_ORDER AND 
		  pso.[EquipmentID] = @EquipmentID;

	IF @WorkDefinitionID IS NULL
	BEGIN
		SET @err_message = N'WorkDefinition ['+CAST(@COMM_ORDER AS nvarchar)+N'] not found';
		THROW 60010, @err_message, 1;
	END;

	--Delete existing parameters from WorkDefinition
	DELETE FROM [dbo].[ParameterSpecification]
	WHERE [WorkDefinitionID] = @WorkDefinitionID;

	--Insert parameters from Order to WorkDefinition
	INSERT INTO [dbo].[ParameterSpecification]( [Value], [WorkDefinitionID], [PropertyType] )
		   SELECT sp.[Value], @WorkDefinitionID, sp.PropertyType
		   FROM dbo.SegmentParameter AS sp
		   WHERE sp.OpSegmentRequirement = @OpSegmentRequirementID;


END;

GO
