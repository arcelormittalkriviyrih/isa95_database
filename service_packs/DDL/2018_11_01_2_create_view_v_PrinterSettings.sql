
IF OBJECT_ID ('dbo.v_PrinterSettings',N'V') IS NOT NULL
  DROP VIEW [dbo].[v_PrinterSettings];
GO

/*
   View: v_PrinterSettings
   Возвращает настройки принтеров
*/
create view [dbo].[v_PrinterSettings]
as

with CTE1 as (
	-- get printers settings for equipment --
	select
		 [EquipmentID]
		,Col.query('PRINTER_NO').value('.', 'nvarchar(100)') AS [PRINTER_NO]
		,Col.query('PAPER_SIZE').value('.', 'nvarchar(100)') AS [PAPER_SIZE]
		,Col.query('PAPER_ORIENTATION_LANDSCAPE').value('.', 'nvarchar(100)') AS [PAPER_ORIENTATION_LANDSCAPE]
		,Col.query('COPIES').value('.', 'nvarchar(100)') AS [COPIES]
	from (
	select
		[EquipmentID],
		dbo.get_JSON2XML('{"ROW": ' + [Value] + '}') as [XML]
	from [dbo].[v_EquipmentProperty] vEP

	where [Property] = N'PRINTER_SETTINGS'
	) as CTE cross apply [xml].nodes('ROW') Tbl(Col)
) 


select
	 DPS.[ID]
	,CTE1.[EquipmentID]
	,CTE1.[PRINTER_NO]
	,DPS.[PRINTER_NAME]
	,DPS.[PRINTER_IP]
	,isnull(CTE1.[PAPER_SIZE], DPS.[PAPER_SIZE]) as [PAPER_SIZE]
	,isnull(CTE1.[PAPER_ORIENTATION_LANDSCAPE], DPS.[PAPER_ORIENTATION_LANDSCAPE]) as [PAPER_ORIENTATION_LANDSCAPE]
	,isnull(CTE1.[COPIES], DPS.[COPIES]) as [COPIES]
from [dbo].[v_EquipmentProperty] vEP
join  CTE1
on CTE1.[PRINTER_NO] = vEP.[Value] and vEP.[Property] = N'USED_PRINTER'-- and vEP.[EquipmentID] = @quip_id
join (
	-- Default printer settings --
	select
		 [ID]
		,[PRINTER_NO]
		,[PRINTER_NAME]
		,[PRINTER_IP]
		,[PAPER_SIZE]
		,[PAPER_ORIENTATION_LANDSCAPE]
		,[COPIES]
	from (
		select
			 vEP1.[EquipmentID]	as [ID]
			,vEP1.[Value]		as [PRINTER_NO]
			,vEP2.[Property]
			,vEP2.[Value]
		from [dbo].[v_EquipmentProperty] vEP1
		join [dbo].[v_EquipmentProperty] vEP2
		on vEP1.[EquipmentID] = vEP2.[EquipmentID] and vEP1.[Property] = N'PRINTER_NO') as T
	pivot (min([Value]) for [Property] in ([PRINTER_NAME], [PRINTER_IP], [PAPER_SIZE], [PAPER_ORIENTATION_LANDSCAPE], [COPIES])) as pvt
) as DPS
on CTE1.[PRINTER_NO] = DPS.[PRINTER_NO]
--where  vEP.[EquipmentID] = @quip_id
  
GO