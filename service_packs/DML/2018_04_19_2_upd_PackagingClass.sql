/* rename Packaging Class */
UPDATE  [dbo].[PackagingClass] 
SET [Description] = case [Description]
						when N'Полувагон' then N'Полувагон УЗ'
						when N'Цистерна' then N'Цистерна УЗ'
						else [Description]
					end