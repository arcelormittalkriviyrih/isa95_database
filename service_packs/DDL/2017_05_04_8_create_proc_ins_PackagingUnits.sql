
IF OBJECT_ID ('dbo.ins_PackagingUnits',N'P') IS NOT NULL
  DROP PROCEDURE dbo.ins_PackagingUnits;
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE [dbo].[ins_PackagingUnits] 
   @WagonNumber		nvarchar(20),		-- Wagon Number
   @PackagingClass	int,				-- Wagon Type
   @PackagingUnitsID int OUTPUT			-- returned value

AS
BEGIN

IF (isnull(@WagonNumber, '') = '')
	THROW 60001, N'WagonNumber param required', 1;
IF @PackagingClass IS NULL
	THROW 60001, N'PackagingClass param required', 1;
IF not exists (select ID from [PackagingClass] where ID = @PackagingClass)
	THROW 60001, N'PackagingClassID doesnt exist', 1;

set @PackagingUnitsID = null

--declare @PackagingUnitsID int

SELECT @PackagingUnitsID = [ID]
FROM [PackagingUnits] 
WHERE [Description] = @WagonNumber and [PackagingClassID] = @PackagingClass 

if (@PackagingUnitsID is null)
BEGIN

	SELECT @PackagingUnitsID = NEXT VALUE FOR [dbo].[gen_PackagingUnits];

	INSERT INTO [dbo].[PackagingUnits](
		 [ID]
		,[Description]
		,[PackagingClassID]) 
	VALUES(
		 @PackagingUnitsID
		,@WagonNumber
		,@PackagingClass)

END

--select @PackagingUnitsID as [PackagingUnitsID]

END

GO