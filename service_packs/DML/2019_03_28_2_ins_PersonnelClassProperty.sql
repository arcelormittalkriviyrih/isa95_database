SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO
SET NOCOUNT ON
GO


--insert PersonnelClassProperty


 		merge [dbo].[PersonnelClassProperty] as trg 
		using
		(
		select distinct
				 N'Только просмотр'				as [Description]
				,N'VIEW_ONLY'			as [Value]
				,isnull(PC.ID, PP.[PersonnelClassID])	as [PersonnelClassID]
			from (values  (N'Весовщик')	) as T([PersonnelClassDescription])
			left join [PersonnelClass] PC --MC
			on T.[PersonnelClassDescription] = PC.[Description]
			left join [dbo].[Person] PP --MD
			on PP.[Description] = T.[PersonnelClassDescription]
		where isnull(PC.ID, PP.[PersonnelClassID]) is not null) as t2
		on (trg.[PersonnelClassID]=t2.[PersonnelClassID] and trg.[Description]=t2.[Description] and trg.[Value]=t2.[Value] )
		WHEN NOT MATCHED THEN
		INSERT   ([Description] , [Value] ,[PersonnelClassID]) VALUES (t2.[Description], t2.[Value], t2.[PersonnelClassID]);


		merge [dbo].[PersonnelClassProperty] as trg 
		using
		(
		select distinct
				 N'Удаленная печать'				as [Description]
				,N'REMOTE_PRINT'			as [Value]
				,isnull(PC.ID, PP.[PersonnelClassID])	as [PersonnelClassID]
			from (values  (N'Весовщик')	) as T([PersonnelClassDescription])
			left join [PersonnelClass] PC --MC
			on T.[PersonnelClassDescription] = PC.[Description]
			left join [dbo].[Person] PP --MD
			on PP.[Description] = T.[PersonnelClassDescription]
		where isnull(PC.ID, PP.[PersonnelClassID]) is not null) as t2
		on (trg.[PersonnelClassID]=t2.[PersonnelClassID] and trg.[Description]=t2.[Description] and trg.[Value]=t2.[Value] )
		WHEN NOT MATCHED THEN
		INSERT   ([Description] , [Value] ,[PersonnelClassID]) VALUES (t2.[Description], t2.[Value], t2.[PersonnelClassID]);

GO