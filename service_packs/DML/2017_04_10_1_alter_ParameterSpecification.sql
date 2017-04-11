 SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
BEGIN TRANSACTION;

UPDATE [dbo].[ParameterSpecification] 
SET [Value]=1
WHERE PropertyType=dbo.[get_PropertyTypeIdByValue](N'BUNT_NO')
  and WorkDefinitionID IN (SELECT ep.[Value] 
                              FROM [dbo].EquipmentProperty ep 
                                   INNER JOIN [dbo].[EquipmentClassProperty] ecp ON ecp.ID=ep.ClassPropertyID 
                              WHERE dbo.get_EquipmentPropertyValue(ep.EquipmentID,N'SCALES_TYPE') IN (N'BUNT')
                                AND ecp.Value IN (N'WORK_DEFINITION_ID',N'STANDARD_WORK_DEFINITION_ID'));

COMMIT;
GO