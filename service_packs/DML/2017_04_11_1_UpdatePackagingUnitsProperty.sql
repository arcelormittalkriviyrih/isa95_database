  Update [PackagingUnitsProperty]
   SET [ValueTime]=pp.Value
  FROM [PackagingUnitsProperty]  left join [PackagingUnitsProperty] pp
  on [PackagingUnitsProperty].PackagingUnitsID=pp.PackagingUnitsID and   pp.Description=N'Время тарирования'
  WHERE [PackagingUnitsProperty].Description=N'Вес тары';

 Update [PackagingUnitsProperty] set [PackagingUnitsProperty]=0;
 
 DELETE  FROM [dbo].[PackagingUnitsProperty] WHERE [Description]=N'Тара';
 DELETE  FROM [dbo].[PackagingUnitsProperty] WHERE [Description]=N'Время тарирования';
