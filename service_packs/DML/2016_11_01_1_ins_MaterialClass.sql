SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

  INSERT INTO [MaterialClass] ( [Description], [Code])
  VALUES (N'Вес нетто Дебет', N'Neto Debit'),
         (N'Вес нетто Кредит', 'Neto Kredit'),
         (N'Вес брутто', N'Gross'),
         (N'Отправитель', N'Sender'),
         (N'Получатель', N'Receiver')
GO