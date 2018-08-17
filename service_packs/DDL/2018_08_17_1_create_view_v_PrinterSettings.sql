
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
		 Tbl.Col.value('../@EquipmentID', 'int')						as [EquipmentID]
		,Tbl.Col.value('@PRINTER_NO', 'nvarchar(100)')					as [PRINTER_NO]
		,Tbl.Col.value('@PAPER_SIZE', 'nvarchar(100)')					as [PAPER_SIZE]
		,Tbl.Col.value('@PAPER_ORIENTATION_LANDSCAPE', 'nvarchar(100)') as [PAPER_ORIENTATION_LANDSCAPE]
		,Tbl.Col.value('@COPIES', 'smallint')							as [COPIES]
	from (
		select
			convert(xml, N'<A EquipmentID="'+cast([EquipmentID] as nvarchar)+N'">'+replace(replace(replace(replace(replace(replace([Value],'[',''),']',''),':','='),',',' '),'{','<row '),'}','></row>')+N'</A>') as [xml]
		from [dbo].[v_EquipmentProperty] vEP
		where [Property] = N'PRINTER_SETTINGS' --and [EquipmentID] = @quip_id 
	) as CTE cross apply [xml].nodes('//row') Tbl(Col)
) 


select
	 CTE1.[EquipmentID]
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
		 [PRINTER_NO]
		,[PRINTER_NAME]
		,[PRINTER_IP]
		,[PAPER_SIZE]
		,[PAPER_ORIENTATION_LANDSCAPE]
		,[COPIES]
	from (
		select
			 vEP1.[Value]		as [PRINTER_NO]
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