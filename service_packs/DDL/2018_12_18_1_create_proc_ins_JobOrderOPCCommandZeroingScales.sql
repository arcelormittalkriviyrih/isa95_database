IF OBJECT_ID ('dbo.ins_JobOrderOPCCommandZeroingScales',N'P') IS NOT NULL
  DROP PROCEDURE dbo.ins_JobOrderOPCCommandZeroingScales;
GO

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
	 @Device nvarchar(500)
	,@ZeroingTag nvarchar(500)
	,@CommandRule nvarchar(500)
declare @D table ([Value] nvarchar(100));
declare @C table ([Value] nvarchar(100));
	
if not exists (select [ID] from [dbo].[v_AvailableWeighbridges] where [ID] = @ScalesID)
  THROW 60001, N'Invalid ScalesID or you have no rights to zeroing this Scales', 1;

select 
	 @Device = dbo.get_EquipmentPropertyValue(@ScalesID,N'OPC_DEVICE_NAME')
	,@ZeroingTag = dbo.get_EquipmentPropertyValue(@ScalesID,N'ZEROING_TAG')
	,@CommandRule = dbo.get_EquipmentPropertyValue(@ScalesID,N'ZEROING_COMMAND')

if @Device is null OR @CommandRule is null
  THROW 60001, N'No zeroing command for this Scales', 1;

if(charindex(',', @Device) = 0) -- check if array 
begin
	insert @D([Value])
	select @Device as [value]
end
else
begin
	select @Device = replace(@Device, '[', '<root><row value=')
	select @Device = replace(@Device, ']', '/></root>')
	select @Device = replace(@Device, ',', '/><row value=')
	select @Device = replace(@Device, '''', '"')
	
	declare @xml xml
	select @xml = cast(@Device as xml)
	
	insert @D([Value])
	select T.row.value('@value', 'nvarchar(50)') as [value]
	from @xml.nodes('/root/row') T([row])
	where @xml.exist('/root/row')=1
end   

if(charindex(',', @CommandRule) = 0) -- check if array 
begin
	insert @C([Value])
	select @CommandRule as [value]
end
else
begin
	select @CommandRule = replace(@CommandRule, '[', '<root><row value=')
	select @CommandRule = replace(@CommandRule, ']', '/></root>')
	select @CommandRule = replace(@CommandRule, ',', '/><row value=')
	select @CommandRule = replace(@CommandRule, '''', '"')

	declare @xml1 xml
	select @xml1 = cast(@CommandRule as xml)
	
	insert @C([Value])
	select T.row.value('@value', 'nvarchar(50)') as [value]
	from @xml1.nodes('/root/row') T([row])
	where @xml1.exist('/root/row')=1
end 

  
insert into [dbo].[JobOrder] 
	([Description]
	,[WorkType]
	,[StartTime]
	,[Command]
	,[CommandRule]
	,[DispatchStatus])
select 
	  N'Zeroing Weighbridge'			as [Description]
	 ,N'KEPCommands'					as [WorkType]
	 ,CURRENT_TIMESTAMP					as [StartTime]
	 ,a.[Value] + N'.' + @ZeroingTag	as [Command]
	 ,b.[Value]							as [CommandRule]
	 ,N'ToSend'							as [DispatchStatus]
from @D a
join @C b
on 1=1

END;
