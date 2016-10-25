USE [KRR-PA-ISA95_PRODUCTION]
GO

/* Добавление классов материалов для справочника материалов, который будет использоваться при процессах взвешивания и транспортирования материалов между контрагентами. Использование сквозной нумерации при добавлении новой информации в справочники - в разработке*/


declare @a as integer

set @a=1
while 1=1
begin
IF EXISTS (SELECT * FROM MaterialClass WHERE Description=N'металлоизделия') break
IF NOT EXISTS (SELECT * FROM MaterialClass WHERE ID=@a)
INSERT INTO MaterialClass
           ([ID]
           ,[Description]
		   ,[ParentID])
     VALUES
           ( @a
           , N'металлоизделия'
		   , @a)
Set @a=@a+1
End

set @a=1
while 1=1
begin
IF EXISTS (SELECT * FROM MaterialClass WHERE Description=N'Чугун') break
IF NOT EXISTS (SELECT * FROM MaterialClass WHERE ID=@a)
INSERT INTO MaterialClass
           ([ID]
           ,[Description]
		   ,[ParentID])
     VALUES
           ( @a
           , N'Чугун'
		   , (Select ID FROM MaterialClass WHERE Description=N'металлоизделия'))
Set @a=@a+1
End

set @a=1
while 1=1
begin
IF EXISTS (SELECT * FROM MaterialClass WHERE Description=N'Заготовка') break
IF NOT EXISTS (SELECT * FROM MaterialClass WHERE ID=@a)
INSERT INTO MaterialClass
           ([ID]
           ,[Description]
		   ,[ParentID])
     VALUES
           ( @a
           , N'Заготовка'
		   , (Select ID FROM MaterialClass WHERE Description=N'металлоизделия'))
Set @a=@a+1
End

set @a=1		
while 1=1
begin
IF EXISTS (SELECT * FROM MaterialClass WHERE Description=N'Арматура') break
IF NOT EXISTS (SELECT * FROM MaterialClass WHERE ID=@a)
INSERT INTO MaterialClass
           ([ID]
           ,[Description]
		   ,[ParentID])
     VALUES
           ( @a
           , N'Арматура'
		   , (Select ID FROM MaterialClass WHERE Description=N'металлоизделия'))
Set @a=@a+1
End

set @a=1
while 1=1
begin
IF EXISTS (SELECT * FROM MaterialClass WHERE Description=N'Заготовка непрерывно литая') break
IF NOT EXISTS (SELECT * FROM MaterialClass WHERE ID=@a)
INSERT INTO MaterialClass
           ([ID]
           ,[Description]
		   ,[ParentID])
     VALUES
           ( @a
           , N'Заготовка непрерывно литая'
		   , (Select ID FROM MaterialClass WHERE Description=N'металлоизделия'))
Set @a=@a+1
End

set @a=1
while 1=1
begin
IF EXISTS (SELECT * FROM MaterialClass WHERE Description=N'Катанка') break
IF NOT EXISTS (SELECT * FROM MaterialClass WHERE ID=@a)
INSERT INTO MaterialClass
           ([ID]
           ,[Description]
		   ,[ParentID])
     VALUES
           ( @a
           , N'Катанка'
		   , (Select ID FROM MaterialClass WHERE Description=N'металлоизделия'))
Set @a=@a+1
End

while 1=1
begin
IF EXISTS (SELECT * FROM MaterialClass WHERE Description=N'Квадрат') break
IF NOT EXISTS (SELECT * FROM MaterialClass WHERE ID=@a)
INSERT INTO MaterialClass
           ([ID]
           ,[Description]
		   ,[ParentID])
     VALUES
           ( @a
           , N'Квадрат'
		   , (Select ID FROM MaterialClass WHERE Description=N'металлоизделия'))
Set @a=@a+1
End

set @a=1
while 1=1
begin
IF EXISTS (SELECT * FROM MaterialClass WHERE Description=N'Круг') break
IF NOT EXISTS (SELECT * FROM MaterialClass WHERE ID=@a)
INSERT INTO MaterialClass
           ([ID]
           ,[Description]
		   ,[ParentID])
     VALUES
           ( @a
           , N'Круг'
		   , (Select ID FROM MaterialClass WHERE Description=N'металлоизделия'))
Set @a=@a+1
End

set @a=1
while 1=1
begin
IF EXISTS (SELECT * FROM MaterialClass WHERE Description=N'Наборы из сорт и фасонных проф.') break
IF NOT EXISTS (SELECT * FROM MaterialClass WHERE ID=@a)
INSERT INTO MaterialClass
           ([ID]
           ,[Description]
		   ,[ParentID])
     VALUES
           ( @a
           , N'Наборы из сорт и фасонных проф.'
		   , (Select ID FROM MaterialClass WHERE Description=N'металлоизделия'))
Set @a=@a+1
End

set @a=1
while 1=1
begin
IF EXISTS (SELECT * FROM MaterialClass WHERE Description=N'Полоса') break
IF NOT EXISTS (SELECT * FROM MaterialClass WHERE ID=@a)
INSERT INTO MaterialClass
           ([ID]
           ,[Description]
		   ,[ParentID])
     VALUES
           ( @a
           , N'Полоса'
		   , (Select ID FROM MaterialClass WHERE Description=N'металлоизделия'))
Set @a=@a+1
End

set @a=1
while 1=1
begin
IF EXISTS (SELECT * FROM MaterialClass WHERE Description=N'Проволока') break
IF NOT EXISTS (SELECT * FROM MaterialClass WHERE ID=@a)
INSERT INTO MaterialClass
           ([ID]
           ,[Description]
		   ,[ParentID])
     VALUES
           ( @a
           , N'Проволока'
		   , (Select ID FROM MaterialClass WHERE Description=N'металлоизделия'))
Set @a=@a+1
End

set @a=1
while 1=1
begin
IF EXISTS (SELECT * FROM MaterialClass WHERE Description=N'Уголок') break
IF NOT EXISTS (SELECT * FROM MaterialClass WHERE ID=@a)
INSERT INTO MaterialClass
           ([ID]
           ,[Description]
		   ,[ParentID])
     VALUES
           ( @a
           , N'Уголок'
		   , (Select ID FROM MaterialClass WHERE Description=N'металлоизделия'))
Set @a=@a+1
End
	
GO
