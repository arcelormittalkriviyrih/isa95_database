
IF OBJECT_ID ('dbo.ins_OperationsAcceptence',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_OperationsAcceptence;
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--@F_number - идентификационный номер устройсва 
--@Op_Type - тип операции обслуживания



CREATE PROCEDURE ins_OperationsAcceptence
	@F_number int,
	@Op_Type nvarchar(50)	
	
AS
BEGIN
insert into OperationsResponse (
				Description,
				OperationsType,
				StartTime 
				)
      
					values (
							(select Description from OperationsDefinition where OperationsType = @Op_Type),
							@Op_Type, GETDATE()
							)
			 	
insert into WorkResponse (
				Description,
				WorkType,
				StartTime
				) 
					values (
							(select Description from WorkDefinition where OperationsDefinitionID = 
										(select ID from OperationsDefinition where OperationsType = @Op_Type)),
							@Op_Type, GETDATE()
							)

insert into JobResponse (
				Description,
				WorkType,
				StartTime,
				WorkResponse
				)
					values (
							(select Description from WorkflowSpecificationNode where WorkDefinition = 1),
							@Op_Type, GETDATE(),
							(select ID from WorkResponse where ID=1)
							)
END;
