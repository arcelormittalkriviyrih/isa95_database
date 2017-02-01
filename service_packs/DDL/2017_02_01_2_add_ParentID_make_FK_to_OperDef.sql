USE [KRR-PA-ISA95_PRODUCTION]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

  -- add row [ParentID] to [OperationsDefinition] 
  -- making row [ParentID] as FK to [id]

	IF OBJECT_ID ('[ISA95_OPERATION_DEFINITION].[OperationsDefinition]') IS NOT NULL
		BEGIN

		ALTER TABLE [ISA95_OPERATION_DEFINITION].[OperationsDefinition]
		ADD [ParentID] [int] NULL

		ALTER TABLE [ISA95_OPERATION_DEFINITION].[OperationsDefinition] 
		WITH CHECK ADD  CONSTRAINT [FK_ParentID] FOREIGN KEY([ParentID])
		REFERENCES [ISA95_OPERATION_DEFINITION].[OperationsDefinition]  ([ID])

		END


