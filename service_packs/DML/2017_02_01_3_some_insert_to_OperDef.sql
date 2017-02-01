

 USE [KRR-PA-ISA95_PRODUCTION] 
 GO 
 SET NOCOUNT ON 
 GO 
 SET QUOTED_IDENTIFIER ON 
 GO 

   insert into [ISA95_OPERATION_DEFINITION].[OperationsDefinition]
  ([ID] , [Description], [OperationsType])  values
  (1 , N'Производство Агломерата' , N'Production'),  (2 , N'Производство Кокса', N'Production')
  ,(3 , N'Производство Чугуна' , N'Production')  ,(4 , N'Производство Стали' , N'Production')
  ,(5 , N'Производство Проката', N'Production'), (6 , N'Производство Кислорода' , N'Production')
  ,(7 , N'Переработка Лома', N'Production'),  (8 , N'Транспортные операции', N'Production')
  GO
