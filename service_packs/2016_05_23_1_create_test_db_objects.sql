if OBJECT_ID ('dbo.TestChild',N'U') IS NOT NULL
   DROP table [dbo].[TestChild];
GO

IF OBJECT_ID ('dbo.TestParent',N'U') IS NOT NULL
   DROP table [dbo].[TestParent];
GO

CREATE TABLE [dbo].[TestParent](
	[ID] [int] IDENTITY(1,1) NOT NULL,
[f_nvarchar] [nvarchar](50) NULL,
[f_datetimeoffset] [datetimeoffset](7) NULL,
[f_date] [date] NULL,
[f_real] [real] NULL,
[f_bit] [bit] NULL,
 CONSTRAINT [PK_TestParent] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


if OBJECT_ID ('dbo.gen_TestChildSeq',N'SO') IS NOT NULL
   DROP sequence [dbo].[gen_TestChildSeq];
GO

CREATE SEQUENCE [dbo].[gen_TestChildSeq] 
GO

if OBJECT_ID ('dbo.TestChild',N'U') IS NOT NULL
   DROP table [dbo].[TestChild];
GO

CREATE TABLE [dbo].[TestChild] (
	[ID] [int] NOT NULL,
[f_nvarchar] [nvarchar](50) NULL,
[f_datetimeoffset] [datetimeoffset](7) NULL,
[f_date] [date] NULL,
[f_real] [real] NULL,
[f_bit] [bit] NULL,
[TestParentID] [int] null,
 CONSTRAINT [PK_TestChild] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[TestChild] ADD  DEFAULT (NEXT VALUE FOR [dbo].[gen_TestChildSeq]) FOR [ID]
GO

ALTER TABLE [dbo].[TestChild]  WITH CHECK ADD  CONSTRAINT [FK_TestChild_TestParent] FOREIGN KEY([TestParentID])
REFERENCES [dbo].[TestParent] ([ID])
GO

ALTER TABLE [dbo].[TestChild] CHECK CONSTRAINT [FK_TestChild_TestParent]
GO


if OBJECT_ID ('dbo.v_TestView',N'V') IS NOT NULL
   DROP view [dbo].[v_TestView];
GO

CREATE VIEW [dbo].[v_TestView]
AS
select c.ID, c.f_bit,c.f_date,c.f_datetimeoffset,c.f_nvarchar,c.f_real,
p.f_bit as p_bit, p.f_date as p_date, p.f_datetimeoffset as p_datetimeoffset, p.f_nvarchar as p_nvarchar, p.f_real as p_real
from 
[dbo].[TestChild] as c,
[dbo].[TestParent] as p
where p.ID=c.TestParentID

go

if OBJECT_ID ('dbo.ins_TestParent',N'P') IS NOT NULL
   DROP PROCEDURE [dbo].[ins_TestParent];
GO

CREATE PROCEDURE [dbo].[ins_TestParent]
  
@f_nvarchar nvarchar(50),
@f_datetimeoffset datetimeoffset(7),
@f_date date,
@f_real real,
@f_bit bit 
AS
BEGIN

 

INSERT INTO [dbo].[TestParent]
           ([f_nvarchar]
           ,[f_datetimeoffset]
           ,[f_date]
           ,[f_real]
           ,[f_bit])
     VALUES
           (@f_nvarchar,
            @f_datetimeoffset,
            @f_date,
            @f_real,
            @f_bit);

 

END;

GO


