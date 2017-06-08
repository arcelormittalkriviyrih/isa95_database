
IF OBJECT_ID ('dbo.ins_CreateWeightsheet',N'P') IS NOT NULL
  DROP PROCEDURE dbo.ins_CreateWeightsheet;
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

create PROCEDURE [dbo].[ins_CreateWeightsheet]
	 @WeightSheetNumber nvarchar(4)
	,@DocumentationsClassID int
	,@ScalesID int
	,@PersonName nvarchar(100)
	,@SenderID int
	,@ReceiverID int
	,@DocumentationID int OUTPUT

as
begin 

if(@PersonName is null)
	THROW 60001, N'Person does not exists', 1;
if(@WeightSheetNumber is null)
	THROW 60001, N'WeightSheetNumber param required', 1;
if(@ScalesID is null)
	THROW 60001, N'ScalesID param required', 1;
if(@SenderID is null)
	THROW 60001, N'SenderID param required', 1;
if(@ReceiverID is null)
	THROW 60001, N'ReceiverID param required', 1;
if(@DocumentationsClassID is null)
	THROW 60001, N'DocumentationsClassID param required', 1;

declare @PersonID int
select @PersonID = [PersonID] from [dbo].[PersonProperty] where UPPER([Value]) = UPPER(@PersonName)

if(@PersonID is null)
	THROW 60001, N'Person does not exists', 1;

	BEGIN TRANSACTION ins_CreateWeightsheet;
	BEGIN TRY 

	SET @DocumentationID = NEXT VALUE FOR [dbo].[gen_Documentations];

	insert into [dbo].[Documentations]
		([ID]
		,[Description]
		,[Status]
		,[DocumentationsClassID]
		,[StartTime]
		,[EndTime])
	select 
		 @DocumentationID
		,N'WeightSheet #'+@WeightSheetNumber
		,N'active'
		,@DocumentationsClassID
		,getdate()
		,null


	insert into [dbo].[DocumentationsProperty]
		([Description]
		,[Value]
		,[DocumentationsID]
		,[ValueTime]
		,[DocumentationsClassPropertyID])
	SELECT
		 DCP.[Description]
		,T1.[Value]
		,@DocumentationID
		,getdate()
		,DCP.[ID]
	FROM [dbo].[DocumentationsClassProperty] DCP
	join
	(values
		(N'Номер отвесной',		@WeightSheetNumber),
		(N'Весовщик',			cast(@PersonID as nvarchar)),
		(N'Весы',				cast(@ScalesID as nvarchar)),
		(N'Цех отправления',	cast(@SenderID as nvarchar)),
		(N'Цех получения',		cast(@ReceiverID as nvarchar))
	) as T1 ([Description], [Value])
	on DCP.[Description] = T1.[Description]
	where DCP.[DocumentationsClassID] = @DocumentationsClassID 


	COMMIT TRANSACTION  ins_CreateWeightsheet; 
	END TRY
		
	BEGIN CATCH
		ROLLBACK TRANSACTION ins_CreateWeightsheet;
		THROW 60020,'Error transaction ins_CreateWeightsheet',1;	
	END CATCH


end



GO