USE [KRR-PA-ISA95_PRODUCTION]  
GO  

SET ANSI_NULLS ON  
GO  
  
SET QUOTED_IDENTIFIER ON  
GO  

SET ANSI_PADDING ON  
GO  

IF OBJECT_ID (N'CostTypes', N'U') IS NULL  
begin 


create table CostTypes (
       ID int not null,
       Description nvarchar(50) null,
       RelType nvarchar (50) null,
       Currency nvarchar (50) null
       CONSTRAINT PK_CostTypes PRIMARY KEY CLUSTERED (ID) 
       WITH (PAD_INDEX=OFF, STATISTICS_NORECOMPUTE = OFF,IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) 
ON [PRIMARY]
) 
ON [PRIMARY]

end
go

IF OBJECT_ID (N'CostList', N'U') IS NULL  
begin
create table CostList (
       ID int not null,
       Description nvarchar(50) null,
       CostTypesID int null,
       Bdate datetime null, 
       Edate datetime null 
       CONSTRAINT PK_CostList PRIMARY KEY CLUSTERED (ID) 
       WITH (PAD_INDEX=OFF, STATISTICS_NORECOMPUTE = OFF,IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) 
ON [PRIMARY]
) 
ON [PRIMARY]
end
go

IF OBJECT_ID (N'CostItems', N'U') IS NULL  
begin
create table CostItems (
       ID int not null,
       Description nvarchar(50) null,
       CostListID int null,
       RelID int null, 
       Value int null 
       CONSTRAINT PK_CostItems PRIMARY KEY CLUSTERED (ID) 
       WITH (PAD_INDEX=OFF, STATISTICS_NORECOMPUTE = OFF,IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) 
ON [PRIMARY]
) 
ON [PRIMARY]
end
go


alter table CostList 
WITH CHECK ADD CONSTRAINT FK_CostList_CostTypes FOREIGN KEY(CostTypesID)  
REFERENCES CostTypes (ID)
go  

alter table CostItems 
WITH CHECK ADD CONSTRAINT FK_CostItems_CostList FOREIGN KEY(CostListID)  
REFERENCES CostList (ID)
go