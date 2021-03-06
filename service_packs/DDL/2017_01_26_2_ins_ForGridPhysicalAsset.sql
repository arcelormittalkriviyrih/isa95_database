SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID ('dbo.ins_ForGridPhysicalAsset',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_ForGridPhysicalAsset;
GO

CREATE PROCEDURE [dbo].[ins_ForGridPhysicalAsset]
	@ID int,
	@Description nvarchar(50),
	@FixedAssetID int,
	@PAClassID int = 1,	
	@PhysicalAssetClassID int
AS
BEGIN

IF @FixedAssetID < 1 
BEGIN
    set @FixedAssetID = null;
END

insert into PhysicalAsset(
				Description,
				FixedAssetID,
				PhysicalAssetClassID) 
	    values (
				@Description,
				@FixedAssetID, 
				@PhysicalAssetClassID)
end

 