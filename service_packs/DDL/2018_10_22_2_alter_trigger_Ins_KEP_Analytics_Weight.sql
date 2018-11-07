SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID ('dbo.Ins_KEP_Analytics_Weight',N'TR') IS NOT NULL
	DROP TRIGGER [dbo].[Ins_KEP_Analytics_Weight]
GO

CREATE TRIGGER [dbo].[Ins_KEP_Analytics_Weight] ON [dbo].[KEP_Analytics_Weight]
FOR INSERT
AS
BEGIN

	DELETE kep
	FROM [dbo].[KEP_Analytics_Weight] kep
	INNER JOIN 
	inserted i
	ON i.[ID_Scales] = kep.[ID_Scales]

	set IDENTITY_INSERT [dbo].[KEP_Analytics_Weight] ON

	insert into [dbo].[KEP_Analytics_Weight](
		   [ID]
		  ,[ID_Scales]
		  ,[DT]
		  ,[Lafet]
		  ,[Wagon]
		  ,[Weight]
		  ,[Weight_platform_1]
		  ,[Weight_platform_2]
		  ,[L_bias_weight]
		  ,[H_bias_weight]
		  ,[Weight_OK]
		  --,[Tara_OK]
		  ,[trace_sensor_1]
		  ,[trace_sensor_2]
		  ,[trace_sensor_3]
		  ,[trace_sensor_4]
		  ,[trace_sensor_5]
		  ,[trace_sensor_6]
		  ,[trace_sensor_7]
		  ,[trace_sensor_8]
		  ,[load_sensor_1]
		  ,[load_sensor_2]
		  ,[load_sensor_3]
		  ,[load_sensor_4]
		  ,[load_sensor_5]
		  ,[load_sensor_6]
		  ,[load_sensor_7]
		  ,[load_sensor_8]
		  ,[WeightStabilized_1]
		  ,[WeightStabilized_2]
	)
	select 
		   [ID]
		  ,[ID_Scales]
		  ,[DT]
		  ,[Lafet]
		  ,[Wagon]
		  ,[Weight]
		  ,[Weight_platform_1]
		  ,[Weight_platform_2]
		  ,[L_bias_weight]
		  ,[H_bias_weight]
		  ,[Weight_OK]
		  --,[Tara_OK]
		  ,[trace_sensor_1]
		  ,[trace_sensor_2]
		  ,[trace_sensor_3]
		  ,[trace_sensor_4]
		  ,[trace_sensor_5]
		  ,[trace_sensor_6]
		  ,[trace_sensor_7]
		  ,[trace_sensor_8]
		  ,[load_sensor_1]
		  ,[load_sensor_2]
		  ,[load_sensor_3]
		  ,[load_sensor_4]
		  ,[load_sensor_5]
		  ,[load_sensor_6]
		  ,[load_sensor_7]
		  ,[load_sensor_8]
		  ,[WeightStabilized_1]
		  ,[WeightStabilized_2]
	from inserted

	set IDENTITY_INSERT [dbo].[KEP_Analytics_Weight] OFF

END
GO