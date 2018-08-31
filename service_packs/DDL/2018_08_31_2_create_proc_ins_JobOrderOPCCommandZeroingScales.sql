SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
	Procedure: ins_JobOrderOPCCommandZeroingScales
	Процедура отправки команды обнуления весов на контроллер.

	Parameters:

		ScalesID - ID весов

*/

create PROCEDURE [dbo].[ins_JobOrderOPCCommandZeroingScales]
	@ScalesID int
AS
BEGIN

declare 
	@Command     NVARCHAR(250),
	@CommandRule NVARCHAR(50);

if not exists (select [ID] from [dbo].[v_AvailableWeighbridges] where [ID] = @ScalesID)
  THROW 60001, N'Invalid ScalesID or you have no rights to zeroing this Scales', 1;

select @Command = dbo.get_EquipmentPropertyValue(@ScalesID,N'OPC_DEVICE_NAME') + N'.' + dbo.get_EquipmentPropertyValue(@ScalesID,N'ZEROING_TAG');
select @CommandRule = dbo.get_EquipmentPropertyValue(@ScalesID,N'ZEROING_COMMAND');

if @Command is null OR @CommandRule is null
  THROW 60001, N'No zeroing command for this Scales', 1;

insert into [dbo].[JobOrder] 
	([Description]
	,[WorkType]
	,[StartTime]
	,[Command]
	,[CommandRule]
	,[DispatchStatus])
select 
	  N'Zeroing Weighbridge'	as [Description]
	 ,N'KEPCommands'			as [WorkType]
	 ,CURRENT_TIMESTAMP			as [StartTime]
	 ,@Command					as [Command]
	 ,@CommandRule				as [CommandRule]
	 ,N'ToSend'					as [DispatchStatus]

END;
