USE [B2MML-BatchML-TEST]
GO
/****** Object:  Table [dbo].[AlarmData]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AlarmData](
	[ID] [int] NOT NULL,
	[AlarmEvent] [nvarchar](50) NOT NULL,
	[AlarmType] [nvarchar](50) NOT NULL,
	[AlarmLink] [nvarchar](50) NOT NULL,
	[Priority] [nvarchar](50) NOT NULL,
	[Event] [int] NULL,
 CONSTRAINT [PK_AlarmData] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ApprovalHistory]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ApprovalHistory](
	[ID] [int] NOT NULL,
	[Finalapprovaldate] [nvarchar](50) NULL,
	[Version] [nvarchar](50) NULL,
	[Description] [nvarchar](50) NULL,
	[Header] [int] NULL,
 CONSTRAINT [PK_ApprovalHistory] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[BatchEquipmentRequirement]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BatchEquipmentRequirement](
	[ID] [int] NOT NULL,
	[Description] [nvarchar](50) NOT NULL,
	[MasterRecipe] [int] NULL,
	[ControlRecipe] [int] NULL,
	[RecipeElement] [int] NULL,
 CONSTRAINT [PK_BatchEquipmentRequirement] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[BatchInformation]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BatchInformation](
	[ID] [int] NOT NULL,
	[Description] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_BatchInformation] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[BatchList]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BatchList](
	[ID] [int] NOT NULL,
	[Description] [nvarchar](50) NOT NULL,
	[BatchInformation] [int] NULL,
 CONSTRAINT [PK_BatchList_1] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[BatchListEntry]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BatchListEntry](
	[ID] [int] NOT NULL,
	[Description] [nvarchar](50) NULL,
	[BatchListEntryType] [int] NULL,
	[Status] [nvarchar](50) NULL,
	[Mode] [nvarchar](50) NULL,
	[ExternalID] [int] NULL,
	[RecipeID] [int] NULL,
	[RecipeVersion] [nvarchar](50) NULL,
	[BatchID] [int] NULL,
	[LotID] [int] NULL,
	[CampaingID] [nvarchar](50) NULL,
	[ProductID] [int] NULL,
	[OrderID] [nvarchar](50) NULL,
	[StartCondition] [nvarchar](50) NULL,
	[RequestedStartTime] [datetimeoffset] NULL,
	[ActualStartTime] [datetimeoffset] NULL,
	[RequestedEndTime] [datetimeoffset] NULL,
	[ActualEndTime] [datetimeoffset] NULL,
	[BatchPriority] [nvarchar](50) NULL,
	[RequestedBatchSize] [nvarchar](50) NULL,
	[ActualBatchSize] [nvarchar](50) NULL,
	[UnitOfMeasure] [nvarchar](50) NULL,
	[Note] [nvarchar](50) NULL,
	[EquipmentID] [int] NULL,
	[EquipmentClassID] [int] NULL,
	[ActualEquipmentID] [int] NULL,
	[BatchListEntry] [int] NULL,
	[BatchList] [int] NULL,
 CONSTRAINT [PK_BatchListEntry] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[BatchOtherInformation]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BatchOtherInformation](
	[ID] [int] NOT NULL,
	[BatchValue] [nvarchar](50) NULL,
	[Description] [nvarchar](50) NULL,
	[MasterRecipe] [int] NULL,
	[ControlRecipe] [int] NULL,
	[RecipeElement] [int] NULL,
 CONSTRAINT [PK_BatchOtherInformation] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[BatchParameter]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BatchParameter](
	[ID] [int] NOT NULL,
	[Description] [nvarchar](50) NULL,
	[ParameterType] [nvarchar](50) NULL,
	[ParameterSubType] [nvarchar](50) NULL,
	[Value] [nvarchar](50) NULL,
	[Scaled] [nvarchar](50) NULL,
	[ScaleReference] [nvarchar](50) NULL,
	[Parameter] [int] NULL,
	[BatchListEntry] [int] NULL,
	[Formula] [int] NULL,
	[RecipeElement] [int] NULL,
 CONSTRAINT [PK_BatchParameter] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[BatchProductionRecord]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BatchProductionRecord](
	[ID] [int] NOT NULL,
	[BatchProductionRecordEntry] [int] NOT NULL,
	[EquipmentScope] [int] NOT NULL,
	[PublishedDate] [datetimeoffset] NOT NULL,
	[CreationDate] [datetimeoffset] NOT NULL,
	[BatchID] [nvarchar](50) NOT NULL,
	[BatchProductionRecordSpec] [nvarchar](50) NOT NULL,
	[CampaginID] [nvarchar](50) NOT NULL,
	[ChangeIndication] [nvarchar](50) NOT NULL,
	[Delimiter] [nvarchar](50) NOT NULL,
	[EquipmentID] [int] NOT NULL,
	[ExpirationDate] [datetimeoffset] NOT NULL,
	[Language] [nvarchar](50) NOT NULL,
	[LastChangedDate] [nvarchar](50) NOT NULL,
	[LotID] [int] NOT NULL,
	[MaterialDefinitionID] [int] NOT NULL,
	[PhysicalAssetID] [int] NOT NULL,
	[RecordStatus] [nvarchar](50) NOT NULL,
	[Version] [nvarchar](50) NOT NULL,
	[ChangeHistory] [int] NOT NULL,
	[Comments] [int] NOT NULL,
	[ControlRecipes] [int] NOT NULL,
	[DataSets] [int] NOT NULL,
	[Events] [int] NOT NULL,
	[MasterRecipes] [int] NOT NULL,
	[PersonnelIdentification] [int] NOT NULL,
	[OperationsDefinitions] [int] NOT NULL,
	[OperationsPerformances] [int] NOT NULL,
	[OperationsScedules] [int] NOT NULL,
	[ProductDefinitions] [int] NOT NULL,
	[ProductionPerformances] [int] NOT NULL,
	[ProductionScedules] [int] NOT NULL,
	[RecipeElements] [int] NOT NULL,
	[ResourceQualifications] [int] NOT NULL,
	[Samples] [int] NOT NULL,
	[WorkDirectives] [int] NOT NULL,
	[WorkMasters] [int] NOT NULL,
	[WorkPerformances] [int] NOT NULL,
	[WorkScedules] [int] NOT NULL,
	[BatchProductionRecord] [int] NOT NULL,
 CONSTRAINT [PK_BatchProductionRecord] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[BatchProductionRecordEntry]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BatchProductionRecordEntry](
	[EntryID] [int] NOT NULL,
	[ObjectType] [nvarchar](50) NOT NULL,
	[TimeStamp] [datetimeoffset] NOT NULL,
	[ExternalReference] [nvarchar](50) NOT NULL,
	[Description] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_BatchProductionRecordEntry] PRIMARY KEY CLUSTERED 
(
	[EntryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[BatchSize]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BatchSize](
	[Nominal] [nvarchar](50) NOT NULL,
	[Min] [nvarchar](50) NULL,
	[Max] [nvarchar](50) NULL,
	[ScaleReference] [nvarchar](50) NULL,
	[ScaledSize] [nvarchar](50) NULL,
	[UnitOfMeasure] [nvarchar](50) NULL,
 CONSTRAINT [PK_BatchSize] PRIMARY KEY CLUSTERED 
(
	[Nominal] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[BatchValue]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BatchValue](
	[ValueString] [nvarchar](50) NOT NULL,
	[DataInterpretation] [nvarchar](50) NULL,
	[DataType] [nvarchar](50) NULL,
	[UnitOfMeasure] [nvarchar](50) NULL,
 CONSTRAINT [PK_BatchValue] PRIMARY KEY CLUSTERED 
(
	[ValueString] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Change]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Change](
	[ID] [int] NOT NULL,
	[BatchProductionRecordEntry] [int] NULL,
	[RecordReference] [nvarchar](50) NULL,
	[PrechangeData] [nvarchar](50) NULL,
	[Reason] [nvarchar](50) NULL,
 CONSTRAINT [PK_Change] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ClassInstanceAssociation]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ClassInstanceAssociation](
	[ID] [int] NOT NULL,
	[ClassEquipmentID] [int] NOT NULL,
	[MemberEquipmentID] [int] NOT NULL,
	[Description] [nvarchar](50) NULL,
	[EquipmentElement] [int] NULL,
 CONSTRAINT [PK_ClassInstanceAssociation] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Comment]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Comment](
	[ID] [int] NOT NULL,
	[BatchProductionRecordEntry] [int] NOT NULL,
	[RecordReference] [nvarchar](50) NOT NULL,
	[CommentText] [nvarchar](50) NOT NULL,
	[PersonID] [int] NOT NULL,
 CONSTRAINT [PK_Comment] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Constraint]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Constraint](
	[ID] [int] NOT NULL,
	[Condition] [nvarchar](50) NULL,
	[EquipmentRequirement] [int] NULL,
 CONSTRAINT [PK_Constraint] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ConsumableActual]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ConsumableActual](
	[ID] [int] NOT NULL,
	[MaterialClassID] [int] NULL,
	[MaterialDefinitionID] [int] NULL,
	[Description] [nvarchar](50) NULL,
	[Location] [nvarchar](50) NULL,
	[HierarchyScope] [int] NULL,
	[Quantity] [int] NULL,
	[RequiredByRequestedSegmentResponse] [nvarchar](50) NULL,
	[SegmentResponseID] [int] NOT NULL,
 CONSTRAINT [PK_ConsumableActual] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ConsumableActualProperty]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ConsumableActualProperty](
	[ID] [int] NOT NULL,
	[Description] [nvarchar](50) NULL,
	[Value] [nvarchar](50) NULL,
	[Quantity] [int] NULL,
	[RequiredByRequestedSegmentResponse] [nvarchar](50) NULL,
	[ConsumableActual] [int] NULL,
 CONSTRAINT [PK_ConsumableActualProperty] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ConsumableExpectedRequirement]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ConsumableExpectedRequirement](
	[ID] [int] NOT NULL,
	[MaterialClassID] [int] NULL,
	[MaterialDefinitionID] [int] NULL,
	[Description] [nvarchar](50) NULL,
	[Location] [nvarchar](50) NULL,
	[HierarchyScope] [int] NULL,
	[Quantity] [int] NULL,
	[RequiredByRequestedSegmentResponce] [nvarchar](50) NULL,
	[SegmentRequirementID] [int] NOT NULL,
 CONSTRAINT [PK_ConsumableExpectedRequirement] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ConsumableExpectedRequirementProperty]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ConsumableExpectedRequirementProperty](
	[ID] [int] NOT NULL,
	[Description] [nvarchar](50) NULL,
	[Value] [nvarchar](50) NULL,
	[Quantity] [int] NULL,
	[ConsumableExpectedRequirement] [int] NULL,
 CONSTRAINT [PK_ConsumableExpectedRequirementProperty] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ControlRecipe]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ControlRecipe](
	[ID] [int] NOT NULL,
	[Verscion] [nvarchar](50) NULL,
	[VersionDate] [datetimeoffset] NULL,
	[Description] [nvarchar](50) NULL,
	[BatchID] [nvarchar](50) NULL,
	[Header] [int] NULL,
	[Formula] [int] NULL,
	[ProcedureLogic] [int] NULL,
	[BatchInformation] [int] NULL,
 CONSTRAINT [PK_ControlRecipe] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ControlRecipeRecord]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ControlRecipeRecord](
	[ID] [int] NOT NULL,
	[BatchProductionRecordEntry] [int] NOT NULL,
	[ControlRecipe] [int] NOT NULL,
 CONSTRAINT [PK_ControlRecipeRecord] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[DataSet]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DataSet](
	[ID] [int] NOT NULL,
	[BatchProductionRecordEntry] [int] NOT NULL,
	[TrendSystemReference] [nvarchar](50) NOT NULL,
	[StartTime] [datetimeoffset] NOT NULL,
	[EndTime] [datetimeoffset] NOT NULL,
	[TimeSpecification] [int] NOT NULL,
	[DelimitedDataBlock] [int] NULL,
 CONSTRAINT [PK_DataSet] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[DataValue]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DataValue](
	[ID] [int] NOT NULL,
	[TagIndex] [nvarchar](50) NULL,
	[Value] [nvarchar](50) NULL,
	[Quality] [nvarchar](50) NULL,
	[OrderedData] [int] NULL,
 CONSTRAINT [PK_DataValue] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[DelimitedDataBlock]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DelimitedDataBlock](
	[ID] [int] NOT NULL,
	[TagDelimiter] [nvarchar](50) NULL,
	[OrderDelimiter] [nvarchar](50) NULL,
	[DelimitedData] [nvarchar](50) NULL,
 CONSTRAINT [PK_DelimitedDataBlock] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[DirectedLink]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DirectedLink](
	[ID] [int] NOT NULL,
	[Description] [nvarchar](50) NULL,
	[FromID] [int] NULL,
	[ToID] [int] NULL,
	[ProcessElement] [int] NULL,
 CONSTRAINT [PK_DirectedLink] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Enumeration]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Enumeration](
	[ID] [int] NOT NULL,
	[EnumerationSetID] [int] NULL,
	[EnumerationNumber] [nvarchar](50) NULL,
	[EnumerationString] [nvarchar](50) NULL,
	[Description] [nvarchar](50) NULL,
 CONSTRAINT [PK_Enumeration] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[EnumerationSet]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EnumerationSet](
	[ID] [int] NOT NULL,
	[Description] [nvarchar](50) NULL,
	[BatchInformation] [int] NULL,
	[BatchValue] [nvarchar](50) NULL,
 CONSTRAINT [PK_EnumerationSet] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Equipment]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Equipment](
	[ID] [int] NOT NULL,
	[Description] [nvarchar](50) NULL,
	[Location] [nvarchar](50) NULL,
	[HierarchyScope] [int] NULL,
	[EquipmentLevel] [nvarchar](50) NULL,
	[Equipment] [int] NULL,
	[EquipmentClassID] [int] NULL,
 CONSTRAINT [PK_Equipment] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[EquipmentActual]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EquipmentActual](
	[ID] [int] NOT NULL,
	[EquipmentClassID] [int] NULL,
	[EquipmentID] [int] NULL,
	[Description] [nvarchar](50) NULL,
	[Location] [nvarchar](50) NULL,
	[HierarchyScope] [int] NULL,
	[Quantity] [int] NULL,
	[RequiredByRequestedSegmentResponse] [nvarchar](50) NULL,
	[SegmentResponseID] [int] NOT NULL,
 CONSTRAINT [PK_EquipmentActual] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[EquipmentActualProperty]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EquipmentActualProperty](
	[ID] [int] NOT NULL,
	[Description] [nvarchar](50) NULL,
	[Value] [nvarchar](50) NULL,
	[Quantity] [int] NULL,
	[RequiredByRequestedSegmentResponse] [nvarchar](50) NULL,
	[EquipmentActual] [int] NULL,
	[OpEquipmentActual] [int] NULL,
 CONSTRAINT [PK_EquipmentActualProperty] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[EquipmentAssetMapping]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EquipmentAssetMapping](
	[EquipmentID] [int] NOT NULL,
	[PhysicalAssetID] [int] NOT NULL,
	[StartTime] [datetimeoffset] NULL,
	[EndTime] [datetimeoffset] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[EquipmentCapability]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EquipmentCapability](
	[ID] [int] NOT NULL,
	[EquipmentClassID] [int] NULL,
	[EquipmentID] [int] NULL,
	[Description] [nvarchar](50) NULL,
	[CapabilityType] [nvarchar](50) NOT NULL,
	[Reason] [nvarchar](50) NULL,
	[EquipmentElementLevel] [nvarchar](50) NULL,
	[StartTime] [datetimeoffset] NULL,
	[EndTime] [datetimeoffset] NULL,
	[Location] [nvarchar](50) NULL,
	[HierarchyScope] [int] NULL,
	[Quantity] [int] NULL,
	[ProductionCapabilityID] [int] NULL,
	[ProcessSegmentCapabilityID] [int] NULL,
 CONSTRAINT [PK_EquipmentCapability] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[EquipmentCapabilityProperty]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EquipmentCapabilityProperty](
	[ID] [int] NOT NULL,
	[Description] [nvarchar](50) NULL,
	[Value] [nvarchar](50) NULL,
	[Quantity] [int] NULL,
	[EquipmentCapability] [int] NULL,
	[OpEquipmentCapability] [int] NULL,
 CONSTRAINT [PK_EquipmentCapabilityProperty] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[EquipmentCapabilityTestSpecification]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EquipmentCapabilityTestSpecification](
	[Name] [nvarchar](50) NOT NULL,
	[Description] [nvarchar](50) NULL,
	[Version] [nvarchar](50) NULL,
	[Location] [nvarchar](50) NULL,
	[HierarchyScope] [int] NULL,
 CONSTRAINT [PK_EquipmentCapabilityTestSpecification] PRIMARY KEY CLUSTERED 
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[EquipmentClass]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EquipmentClass](
	[ID] [int] NOT NULL,
	[ParentID] [int] NULL,
	[Description] [nvarchar](50) NULL,
	[Location] [nvarchar](50) NULL,
	[HierarchyScope] [int] NULL,
	[EquipmentLevel] [nvarchar](50) NULL,
 CONSTRAINT [PK_EquipmentClass] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[EquipmentClassProperty]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EquipmentClassProperty](
	[ID] [int] NOT NULL,
	[Description] [nvarchar](50) NULL,
	[Value] [nvarchar](50) NULL,
	[EquipmentClassProperty] [int] NULL,
	[EquipmentCapabilityTestSpecification] [nvarchar](50) NULL,
	[EquipmentClassID] [int] NULL,
 CONSTRAINT [PK_EquipmentClassProperty] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[EquipmentConnection]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EquipmentConnection](
	[ID] [int] NOT NULL,
	[Description] [nvarchar](50) NULL,
	[ConnectionType] [nvarchar](50) NOT NULL,
	[FromEquipmentID] [int] NULL,
	[ToEquipmentID] [int] NULL,
	[EquipmentElement] [int] NULL,
 CONSTRAINT [PK_EquipmentConnection] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[EquipmentElement]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EquipmentElement](
	[ID] [int] NOT NULL,
	[Description] [nvarchar](50) NULL,
	[EquipmentElementType] [nvarchar](50) NOT NULL,
	[EquipmentElementLevel] [nvarchar](50) NOT NULL,
	[EquipmentElement] [int] NOT NULL,
	[EquipmentElementID] [int] NOT NULL,
	[BatchInformation] [int] NULL,
 CONSTRAINT [PK_EquipmentElement] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[EquipmentElementProperty]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EquipmentElementProperty](
	[ID] [int] NOT NULL,
	[Description] [nvarchar](50) NULL,
	[Value] [nvarchar](50) NULL,
	[Property] [int] NULL,
	[EquipmentElement] [int] NULL,
 CONSTRAINT [PK_EquipmentElementProperty] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[EquipmentInformation]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EquipmentInformation](
	[ID] [int] NOT NULL,
	[Description] [nvarchar](50) NULL,
	[Location] [nvarchar](50) NULL,
	[HierarchyScope] [int] NULL,
	[PublishedDate] [nvarchar](50) NULL,
	[Equipment] [int] NULL,
	[EquipmentClassID] [int] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[EquipmentProoceduralElement]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EquipmentProoceduralElement](
	[ID] [int] NOT NULL,
	[Description] [nvarchar](50) NULL,
	[EquipmentProceduralElementType] [int] NOT NULL,
	[EquipmentProoceduralElementClass] [int] NULL,
	[Parameter] [nvarchar](50) NULL,
	[EquipmentElement] [int] NULL,
 CONSTRAINT [PK_EquipmentProoceduralElement] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[EquipmentProoceduralElementClass]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EquipmentProoceduralElementClass](
	[ID] [int] NOT NULL,
	[Description] [nvarchar](50) NULL,
	[EquipmentProoceduralElementType] [int] NOT NULL,
	[Paramenter] [nvarchar](50) NULL,
	[EquipmentElement] [int] NULL,
 CONSTRAINT [PK_EquipmentProoceduralElementClass] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[EquipmentProperty]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EquipmentProperty](
	[ID] [int] NOT NULL,
	[Description] [nvarchar](50) NULL,
	[Value] [nvarchar](50) NULL,
	[EquipmentProperty] [int] NULL,
	[EquipmentCapabilityTestSpecification] [nvarchar](50) NULL,
	[TestResult] [nvarchar](50) NULL,
	[EquipmentID] [int] NULL,
	[ClassPropertyID] [int] NULL,
 CONSTRAINT [PK_EquipmentProperty] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[EquipmentRequirement]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EquipmentRequirement](
	[ID] [int] NOT NULL,
	[EquipmentClassID] [int] NULL,
	[EquipmentID] [int] NOT NULL,
	[Description] [nvarchar](50) NULL,
	[Location] [nvarchar](50) NULL,
	[HierarchyScope] [int] NULL,
	[Quantity] [int] NULL,
	[RequiredByRequestedSegmentResponce] [nvarchar](50) NULL,
	[SegmentRequirementID] [int] NOT NULL,
 CONSTRAINT [PK_EquipmentRequirement] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[EquipmentRequirementProperty]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EquipmentRequirementProperty](
	[ID] [int] NOT NULL,
	[Description] [nvarchar](50) NULL,
	[Value] [nvarchar](50) NULL,
	[Quantity] [int] NULL,
	[EquipmentRequirement] [int] NULL,
	[OpEquipmentRequirement] [int] NULL,
 CONSTRAINT [PK_EquipmentRequirementProperty] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[EquipmentSegmentSpecification]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EquipmentSegmentSpecification](
	[ID] [int] NOT NULL,
	[EquipmentClassID] [int] NULL,
	[EquipmentID] [int] NULL,
	[Description] [nvarchar](50) NULL,
	[EquipmentUse] [nvarchar](50) NULL,
	[Quantity] [int] NULL,
	[ProcessSegmentID] [int] NOT NULL,
 CONSTRAINT [PK_EquipmentSegmentSpecification] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[EquipmentSegmentSpecificationProperty]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EquipmentSegmentSpecificationProperty](
	[ID] [nvarchar](50) NOT NULL,
	[Description] [nvarchar](50) NULL,
	[Value] [nvarchar](50) NULL,
	[Quantity] [int] NULL,
	[EquipmentSegmentSpecification] [int] NULL,
 CONSTRAINT [PK_EquipmentSegmentSpecificationProperty] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[EquipmentSpecification]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EquipmentSpecification](
	[ID] [int] NOT NULL,
	[EquipmentClassID] [int] NULL,
	[EquipmentID] [int] NULL,
	[Description] [nvarchar](50) NULL,
	[Quantity] [int] NULL,
	[ProductSegmentID] [int] NULL,
 CONSTRAINT [PK_EquipmentSpecification] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[EquipmentSpecificationProperty]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EquipmentSpecificationProperty](
	[ID] [int] NOT NULL,
	[Description] [nvarchar](50) NULL,
	[Value] [nvarchar](50) NULL,
	[Quantity] [int] NULL,
	[EquipmentSpecification] [int] NULL,
	[OpEquipmentSpecification] [int] NULL,
 CONSTRAINT [PK_EquipmentSpecificationProperty] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Event]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Event](
	[ID] [int] NOT NULL,
	[BatchProductionRecordEntry] [int] NULL,
	[EventType] [nvarchar](50) NULL,
	[EventSubType] [nvarchar](50) NULL,
	[EquipmentID] [int] NULL,
	[Value] [nvarchar](50) NULL,
	[PreviousValue] [nvarchar](50) NULL,
	[MessageText] [nvarchar](50) NULL,
	[PersonID] [int] NULL,
	[ComputerID] [int] NULL,
	[PhysicalAssetID] [int] NULL,
	[ProceduralElementReference] [nvarchar](50) NULL,
	[Category] [nvarchar](50) NULL,
	[AssociatedEventID] [int] NULL,
 CONSTRAINT [PK_Event] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Formula]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Formula](
	[ID] [int] NOT NULL,
	[Description] [nvarchar](50) NULL,
 CONSTRAINT [PK_Formula] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[FromID]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FromID](
	[ID] [int] NOT NULL,
	[FromIDValue] [int] NOT NULL,
	[FromType] [nvarchar](50) NOT NULL,
	[IDScope] [nvarchar](50) NOT NULL,
	[Link] [int] NULL,
 CONSTRAINT [PK_FromID_1] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[GRecipe]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GRecipe](
	[ID] [int] NOT NULL,
	[Description] [nvarchar](50) NULL,
	[GRecipeType] [nvarchar](50) NULL,
	[LifeCycleState] [nvarchar](50) NULL,
	[Header] [int] NULL,
	[Formula] [int] NULL,
	[ProcessProcedure] [nvarchar](50) NULL,
	[GRecipeInformation] [int] NULL,
 CONSTRAINT [PK_GRecipe] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[GRecipeFormula]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GRecipeFormula](
	[ID] [int] NOT NULL,
	[Description] [nvarchar](50) NULL,
	[ProcessInput] [nvarchar](50) NULL,
	[ProcessOutput] [nvarchar](50) NULL,
	[ProcessIntermediates] [nvarchar](50) NULL,
 CONSTRAINT [PK_GRecipeFormula] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[GRecipeHeader]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GRecipeHeader](
	[ID] [int] NOT NULL,
	[Description] [nvarchar](50) NULL,
	[DerivedFromID] [nvarchar](50) NULL,
	[EffectiveDate] [datetimeoffset] NULL,
	[ExpirationDate] [datetimeoffset] NULL,
 CONSTRAINT [PK_GRecipeHeader] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[GRecipeInformation]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GRecipeInformation](
	[ID] [int] NOT NULL,
	[Description] [nvarchar](50) NULL,
	[Location] [nvarchar](50) NULL,
	[PublishedDate] [datetimeoffset] NULL,
 CONSTRAINT [PK_GRecipeInformation] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[GRecipeMaterial]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GRecipeMaterial](
	[ID] [int] NOT NULL,
	[Description] [nvarchar](50) NULL,
	[MaterialID] [int] NULL,
	[Order] [nvarchar](50) NULL,
	[Amount] [nvarchar](50) NULL,
	[GRecipeMaterials] [int] NULL,
 CONSTRAINT [PK_GRecipeMaterial] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[GRecipeMaterials]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GRecipeMaterials](
	[ID] [int] NOT NULL,
	[Description] [nvarchar](50) NULL,
 CONSTRAINT [PK_GRecipeMaterials] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[GRecipeProductInformation]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GRecipeProductInformation](
	[ProductID] [int] NOT NULL,
	[Description] [nvarchar](50) NULL,
	[ProductName] [nvarchar](50) NULL,
	[BatchSize] [nvarchar](50) NULL,
	[GRecipeHeader] [int] NULL,
 CONSTRAINT [PK_GRecipeProductInformation] PRIMARY KEY CLUSTERED 
(
	[ProductID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Header]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Header](
	[ID] [int] NOT NULL,
	[EffectiveDate] [datetimeoffset] NULL,
	[ExpirationDate] [datetimeoffset] NULL,
	[ProductID] [int] NOT NULL,
	[ProductName] [nvarchar](50) NULL,
	[BatchSize] [nvarchar](50) NULL,
	[ActualProductProduced] [nvarchar](50) NULL,
	[Status] [nvarchar](50) NULL,
 CONSTRAINT [PK_Header] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[HeaderProperty]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HeaderProperty](
	[HeaderID] [int] NOT NULL,
	[Description] [nvarchar](50) NULL,
	[Value] [nvarchar](50) NULL,
 CONSTRAINT [PK_HeaderProperty] PRIMARY KEY CLUSTERED 
(
	[HeaderID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[HierarchyScope]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HierarchyScope](
	[HID] [int] NOT NULL,
	[ParentHID] [int] NULL,
	[ID] [int] NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_HierarchyScope] PRIMARY KEY CLUSTERED 
(
	[HID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Individualapproval]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Individualapproval](
	[ID] [int] NOT NULL,
	[ApprovedBy] [nvarchar](50) NULL,
	[ApprovalDate] [datetimeoffset] NULL,
	[Description] [nvarchar](50) NULL,
	[ApprovalHistory] [int] NULL,
 CONSTRAINT [PK_Individualapproval] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[JobList]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[JobList](
	[ID] [int] NOT NULL,
	[Description] [nvarchar](50) NULL,
	[HierarchyScope] [int] NULL,
	[Workype] [nvarchar](50) NULL,
	[StartTime] [datetimeoffset] NULL,
	[EndTime] [datetimeoffset] NULL,
 CONSTRAINT [PK_JobList] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[JobOrder]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[JobOrder](
	[ID] [int] NOT NULL,
	[Description] [nvarchar](50) NULL,
	[HierarchyScope] [int] NULL,
	[WorkType] [nvarchar](50) NULL,
	[WorkMasterID] [int] NOT NULL,
	[WorkMasterVersion] [nvarchar](50) NULL,
	[StartTime] [datetimeoffset] NULL,
	[EndTime] [datetimeoffset] NULL,
	[Priority] [nvarchar](50) NULL,
	[Command] [nvarchar](50) NULL,
	[CommandRule] [nvarchar](50) NULL,
	[DispatchStatus] [nvarchar](50) NULL,
	[WorkRequest] [int] NULL,
	[JobList] [int] NULL,
 CONSTRAINT [PK_JobOrder] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[JobResponse]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[JobResponse](
	[ID] [int] NOT NULL,
	[Description] [nvarchar](50) NULL,
	[HierarchyScope] [int] NULL,
	[WorkType] [nvarchar](50) NULL,
	[JobOrderID] [int] NULL,
	[WorkDirectiveID] [int] NULL,
	[WorkDirectiveVersion] [nvarchar](50) NULL,
	[StartTime] [datetimeoffset] NULL,
	[EndTime] [datetimeoffset] NULL,
	[JobState] [nvarchar](50) NULL,
	[JobResponse] [int] NULL,
	[WorkResponse] [int] NULL,
 CONSTRAINT [PK_JobResponse] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[JobResponsetData]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[JobResponsetData](
	[ID] [int] NOT NULL,
	[Description] [nvarchar](50) NULL,
	[Value] [nvarchar](50) NULL,
	[RequiredByRequestedSegment] [nvarchar](50) NULL,
	[JobResponse] [int] NULL,
 CONSTRAINT [PK_JobResponsetData] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[KPIDefinition]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[KPIDefinition](
	[ID] [int] NOT NULL,
	[Description] [nvarchar](max) NULL,
	[Name] [nvarchar](50) NULL,
	[Scope] [int] NULL,
	[Formula] [nvarchar](50) NULL,
	[UnitOfMeasure] [nvarchar](50) NULL,
	[Range] [nvarchar](50) NULL,
	[Trend] [nvarchar](50) NULL,
	[Timing] [nvarchar](50) NULL,
	[Audience] [nvarchar](50) NULL,
	[ProductionMethodology] [nvarchar](50) NULL,
	[EffectModel] [nvarchar](50) NULL,
	[Notes] [nvarchar](50) NULL,
 CONSTRAINT [PK_KPIDefinition] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[KPIDefinitionProperty]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[KPIDefinitionProperty](
	[ID] [int] NOT NULL,
	[Description] [nvarchar](50) NULL,
	[Value] [nvarchar](50) NULL,
	[KPIDefinitionID] [int] NULL,
 CONSTRAINT [PK_KPIDefinitionProperty] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[KPIDefinitionTimeRange]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[KPIDefinitionTimeRange](
	[ID] [int] NOT NULL,
	[StartTime] [datetimeoffset] NULL,
	[EndTime] [datetimeoffset] NULL,
	[Recurrence] [nvarchar](50) NULL,
	[Duration] [nvarchar](50) NULL,
	[KPIDefinitionID] [int] NULL,
 CONSTRAINT [PK_KPIDefinitionTimeRange] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[KPIInstance]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[KPIInstance](
	[ID] [int] NOT NULL,
	[Description] [nvarchar](max) NULL,
	[Name] [nvarchar](50) NULL,
	[Scope] [int] NULL,
	[Formula] [nvarchar](50) NULL,
	[UnitOfMeasure] [nvarchar](50) NULL,
	[Trend] [nvarchar](50) NULL,
	[Timing] [nvarchar](50) NULL,
	[Audience] [nvarchar](50) NULL,
	[ProductionMethodology] [nvarchar](50) NULL,
	[EffectModel] [nvarchar](50) NULL,
	[Notes] [nvarchar](50) NULL,
	[KPIDefinitionID] [int] NULL,
 CONSTRAINT [PK_KPIInstance] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[KPIInstanceProperty]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[KPIInstanceProperty](
	[ID] [int] NOT NULL,
	[Description] [nvarchar](50) NULL,
	[Value] [nvarchar](50) NULL,
	[KPIInstanceID] [int] NULL,
 CONSTRAINT [PK_KPIInstanceProperty] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[KPIInstanceRange]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[KPIInstanceRange](
	[ID] [int] NOT NULL,
	[Description] [nvarchar](50) NULL,
	[LowerLimit] [nvarchar](50) NULL,
	[UpperLimit] [nvarchar](50) NULL,
	[KPIInstanceID] [int] NULL,
 CONSTRAINT [PK_KPIInstanceRange] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[KPIInstanceResourceReference]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[KPIInstanceResourceReference](
	[ID] [int] NOT NULL,
	[Description] [nvarchar](50) NULL,
	[ResourceType] [nvarchar](50) NULL,
	[ResourceID] [int] NULL,
	[KPIInstanceID] [int] NULL,
 CONSTRAINT [PK_KPIInstanceResourceReference] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[KPIInstanceTimeRange]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[KPIInstanceTimeRange](
	[ID] [int] NOT NULL,
	[StartTime] [datetimeoffset] NULL,
	[EndTime] [datetimeoffset] NULL,
	[Recurrence] [nvarchar](50) NULL,
	[Duration] [nvarchar](50) NULL,
	[KPIInstanceID] [int] NULL,
 CONSTRAINT [PK_KPIInstanceTimeRange] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[KPIValue]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[KPIValue](
	[ID] [int] NOT NULL,
	[Description] [nvarchar](50) NULL,
	[Name] [nvarchar](50) NULL,
	[Value] [nvarchar](50) NULL,
	[UnitOfMeasure] [nvarchar](50) NULL,
	[KPIInstanceID] [int] NULL,
 CONSTRAINT [PK_KPIValue] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[KPIValueProperty]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[KPIValueProperty](
	[ID] [int] NOT NULL,
	[Description] [nvarchar](50) NULL,
	[Value] [nvarchar](50) NULL,
	[KPIValueID] [int] NULL,
 CONSTRAINT [PK_KPIValueProperty] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[KPIValueTimeRange]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[KPIValueTimeRange](
	[ID] [int] NOT NULL,
	[StartTime] [datetimeoffset] NULL,
	[EndTime] [datetimeoffset] NULL,
	[Recurrence] [nvarchar](50) NULL,
	[Duration] [nvarchar](50) NULL,
	[KPIValueID] [int] NULL,
 CONSTRAINT [PK_KPIValueTimeRange] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Link]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Link](
	[ID] [int] NOT NULL,
	[LinkType] [nvarchar](50) NOT NULL,
	[Depiction] [nvarchar](50) NOT NULL,
	[EvaluationOrder] [nvarchar](50) NULL,
	[Description] [nvarchar](50) NULL,
	[ProcedureLogic] [int] NULL,
 CONSTRAINT [PK_Link] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ListHeader]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ListHeader](
	[ID] [int] NOT NULL,
	[Version] [nvarchar](50) NULL,
	[Description] [nvarchar](50) NULL,
	[Origin] [nvarchar](50) NULL,
	[CreateDate] [datetimeoffset] NULL,
	[BatchList] [int] NULL,
	[BatchInformation] [int] NULL,
 CONSTRAINT [PK_ListHeader] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ManufacturingBill]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ManufacturingBill](
	[ID] [int] NOT NULL,
	[Description] [nvarchar](50) NULL,
	[MaterialClassID] [int] NULL,
	[MaterialDefinitionID] [int] NULL,
	[Quantity] [int] NULL,
	[AssemblyManufacturingBill] [int] NULL,
	[AssemblyType] [nvarchar](50) NULL,
	[AssemblyRelationship] [nvarchar](50) NULL,
	[BillOfMaterialID] [nvarchar](50) NULL,
	[ProductDefinition] [int] NULL,
 CONSTRAINT [PK_ManufacturingBill] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MarerialClassTR]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MarerialClassTR](
	[id] [int] NOT NULL,
	[Description] [nvarchar](50) NULL,
	[AssemblyClassID] [int] NULL,
	[AssemblyType] [nvarchar](50) NULL,
	[AssemblyRelationship] [nvarchar](50) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MasterRecipe]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MasterRecipe](
	[ID] [int] NOT NULL,
	[Version] [nvarchar](50) NULL,
	[VersionDate] [datetimeoffset] NULL,
	[Description] [nvarchar](50) NULL,
	[Header] [int] NULL,
	[Formula] [int] NULL,
	[ProcedureLogic] [int] NULL,
	[BatchInformation] [int] NULL,
 CONSTRAINT [PK_MasterRecipe] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MasterRecipeRecord]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MasterRecipeRecord](
	[ID] [int] NOT NULL,
	[BatchProductionRecordEntry] [int] NOT NULL,
	[MasterRecipe] [int] NOT NULL,
 CONSTRAINT [PK_MasterRecipeRecord] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MaterialActual]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MaterialActual](
	[ID] [int] NOT NULL,
	[MaterialClassID] [int] NULL,
	[MaterialDefinitionID] [int] NULL,
	[MaterialLotID] [int] NULL,
	[MaterialSubLotID] [int] NULL,
	[Description] [nvarchar](50) NULL,
	[Location] [nvarchar](50) NULL,
	[HierarchyScope] [int] NULL,
	[MaterialUse] [nvarchar](50) NULL,
	[Quantity] [int] NULL,
	[AssemblyType] [nvarchar](50) NULL,
	[AssemblyActual] [int] NULL,
	[AssemblyRelationship] [nvarchar](50) NULL,
	[RequiredByRequestedSegmentResponse] [nvarchar](50) NULL,
	[SegmentResponseID] [int] NOT NULL,
 CONSTRAINT [PK_MaterialActual] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MaterialActualProperty]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MaterialActualProperty](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Description] [nvarchar](50) NULL,
	[Value] [nvarchar](50) NULL,
	[Quantity] [int] NULL,
	[RequiredByRequestedSegmentResponse] [nvarchar](50) NULL,
	[MaterialActual] [int] NULL,
	[OpMaterialActual] [int] NULL,
 CONSTRAINT [PK_MaterialActualProperty] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MaterialCapability]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MaterialCapability](
	[ID] [int] NOT NULL,
	[MaterialClassID] [int] NULL,
	[MaterialDefinitionID] [int] NULL,
	[MaterialLotID] [int] NULL,
	[MaterialSubLotID] [int] NULL,
	[Description] [nvarchar](50) NULL,
	[CapabilityType] [nvarchar](50) NOT NULL,
	[Reason] [nvarchar](50) NULL,
	[EquipmentElementLevel] [nvarchar](50) NULL,
	[MaterialUse] [nvarchar](50) NULL,
	[StartTime] [datetimeoffset] NULL,
	[EndTime] [datetimeoffset] NULL,
	[Location] [nvarchar](50) NULL,
	[HierarchyScope] [int] NULL,
	[Quantity] [int] NULL,
	[AssemblyCapability] [int] NULL,
	[AssemblyType] [nvarchar](50) NULL,
	[AssemblyRealationship] [nvarchar](50) NULL,
	[ProcessSegmentCapabilityID] [int] NULL,
	[ProductionCapability] [int] NULL,
 CONSTRAINT [PK_MaterialCapability] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MaterialCapabilityProperty]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MaterialCapabilityProperty](
	[ID] [int] NOT NULL,
	[Description] [nvarchar](50) NULL,
	[Value] [nvarchar](50) NULL,
	[Quantity] [int] NULL,
	[MaterialUse] [nvarchar](50) NULL,
	[MaterialCapabilityID] [int] NULL,
	[OpMaterialCapabilityID] [int] NULL,
 CONSTRAINT [PK_MaterialCapabilityProperty] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MaterialClass]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MaterialClass](
	[ID] [int] NOT NULL,
	[ParentID] [int] NULL,
	[Description] [nvarchar](50) NULL,
 CONSTRAINT [PK_MaterialClass] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MaterialClassAssemblies]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MaterialClassAssemblies](
	[MaterialClassID] [int] NOT NULL,
	[AssemblyClassID] [int] NOT NULL,
	[AssemblyType] [nvarchar](50) NULL,
	[AssemblyRelationship] [nvarchar](50) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MaterialClassLinks]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MaterialClassLinks](
	[MaterialClassID1] [int] NOT NULL,
	[MaterialClassID2] [int] NOT NULL,
	[LinkType] [int] NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MaterialClassProperty]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MaterialClassProperty](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Description] [nvarchar](50) NULL,
	[Value] [nvarchar](50) NULL,
	[MaterialClassProperty] [int] NULL,
	[MaterialTestSpecificationID] [nvarchar](50) NULL,
	[MaterialClassID] [int] NULL,
	[PropertyType] [int] NULL,
 CONSTRAINT [PK_MaterialClassProperty] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MaterialConsumedActual]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MaterialConsumedActual](
	[ID] [int] NOT NULL,
	[MaterialClassID] [int] NULL,
	[MaterialDefinitionID] [int] NULL,
	[MaterialLotID] [int] NULL,
	[MaterialSubLotID] [int] NULL,
	[Description] [nvarchar](50) NULL,
	[Location] [nvarchar](50) NULL,
	[HierarchyScope] [int] NULL,
	[Quantity] [int] NULL,
	[RequiredByRequestedSegmentResponse] [nvarchar](50) NULL,
	[SegmentResponseID] [int] NOT NULL,
 CONSTRAINT [PK_MaterialConsumedActual] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MaterialConsumedActualProperty]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MaterialConsumedActualProperty](
	[ID] [int] NOT NULL,
	[Description] [nvarchar](50) NULL,
	[Value] [nvarchar](50) NULL,
	[Quantity] [int] NULL,
	[RequiredByRequestedSegmentResponse] [nvarchar](50) NULL,
	[MaterialConsumedActual] [int] NULL,
 CONSTRAINT [PK_MaterialConsumedActualProperty] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MaterialConsumedRequirement]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MaterialConsumedRequirement](
	[ID] [int] NOT NULL,
	[MaterialClassID] [int] NULL,
	[MaterialDefinitionID] [int] NULL,
	[MaterialLotID] [int] NULL,
	[MaterialSubLotID] [int] NULL,
	[Description] [nvarchar](50) NULL,
	[Location] [nvarchar](50) NULL,
	[HierarchyScope] [int] NULL,
	[Quantity] [int] NULL,
	[RequiredByRequestedSegmentResponce] [nvarchar](50) NULL,
	[SegmentRequirementID] [int] NOT NULL,
 CONSTRAINT [PK_MaterialConsumedRequirement] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MaterialConsumedRequirementProperty]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MaterialConsumedRequirementProperty](
	[ID] [int] NOT NULL,
	[Description] [nvarchar](50) NULL,
	[Value] [nvarchar](50) NULL,
	[Quantity] [int] NULL,
	[MaterialConsumedRequirement] [int] NULL,
 CONSTRAINT [PK_MaterialConsumedRequirementProperty] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MaterialDefinition]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MaterialDefinition](
	[ID] [int] NOT NULL,
	[Description] [nvarchar](50) NULL,
	[Location] [nvarchar](50) NULL,
	[HierarchyScope] [int] NULL,
	[MaterialClassID] [int] NULL,
 CONSTRAINT [PK_MaterialDefinition_1] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MaterialDefinitionAssemblies]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MaterialDefinitionAssemblies](
	[MaterialDefinitionID] [int] NOT NULL,
	[AssemblyDefinitionID] [int] NOT NULL,
	[AssemblyType] [nvarchar](50) NULL,
	[AssemblyRelationship] [nvarchar](50) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MaterialDefinitionLinks]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MaterialDefinitionLinks](
	[MaterialDefinition1] [int] NOT NULL,
	[MaterialDefinition2] [int] NOT NULL,
	[LinkType] [int] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MaterialDefinitionProperty]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MaterialDefinitionProperty](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Description] [nvarchar](50) NULL,
	[Value] [nvarchar](50) NULL,
	[MaterialDefinitionProperty] [int] NULL,
	[MaterialTestSpecificationID] [nvarchar](50) NULL,
	[MaterialDefinitionID] [int] NULL,
	[ClassPropertyID] [int] NULL,
	[PropertyType] [int] NULL,
 CONSTRAINT [PK_MaterialDefinitionProperty] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MaterialInformation]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MaterialInformation](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Description] [nvarchar](50) NULL,
	[Location] [nvarchar](50) NULL,
	[HierarchyScope] [int] NULL,
	[PublishedDate] [nvarchar](50) NULL,
	[MaterialClassID] [int] NULL,
	[MaterialDefinition] [int] NULL,
	[MaterialLot] [int] NULL,
	[MaterialSubLot] [int] NULL,
 CONSTRAINT [PK_MaterialInformation] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MaterialLinkTypes]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MaterialLinkTypes](
	[ID] [int] NOT NULL,
	[Description] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_MaterialLinkTypes] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MaterialLot]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MaterialLot](
	[ID] [int] NOT NULL,
	[FactoryNumber] [nvarchar](250) NULL,
	[MaterialDefinitionID] [int] NULL,
	[Description] [nvarchar](250) NULL,
	[Status] [nvarchar](250) NULL,
	[StorageLocation] [nvarchar](250) NULL,
	[Quantity] [int] NULL,
	[Location] [nvarchar](250) NULL,
	[AssemblyLotID] [int] NULL,
	[AssemblyType] [nvarchar](250) NULL,
	[AssemblyRelationship] [nvarchar](250) NULL,
 CONSTRAINT [PK_MaterialLot] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MaterialLotLinks]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MaterialLotLinks](
	[MaterialLot1] [int] NOT NULL,
	[MaterialLot2] [int] NOT NULL,
	[LinkType] [int] NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MaterialLotProperty]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MaterialLotProperty](
	[ID] [int] NOT NULL,
	[Description] [nvarchar](50) NULL,
	[Value] [nvarchar](50) NULL,
	[MaterialLotProperty] [int] NULL,
	[MaterialTestSpecificationID] [nvarchar](50) NULL,
	[TestResult] [nvarchar](50) NULL,
	[MaterialLotID] [int] NULL,
	[MaterialSubLotID] [int] NULL,
	[DefinitionPropertyID] [int] NULL,
	[PropertyType] [int] NULL,
 CONSTRAINT [PK_MaterialLotProperty] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MaterialProducedActual]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MaterialProducedActual](
	[ID] [int] NOT NULL,
	[MaterialClassID] [int] NULL,
	[MaterialDefinitionID] [int] NULL,
	[MaterialLotID] [int] NULL,
	[MaterialSubLotID] [int] NULL,
	[Description] [nvarchar](50) NULL,
	[Location] [nvarchar](50) NULL,
	[HierarchyScope] [int] NULL,
	[Quantity] [int] NULL,
	[RequiredByRequestedSegmentResponse] [nvarchar](50) NULL,
	[SegmentResponseID] [int] NOT NULL,
 CONSTRAINT [PK_MaterialProducedActual] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MaterialProducedActualProperty]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MaterialProducedActualProperty](
	[ID] [int] NOT NULL,
	[Description] [nvarchar](50) NULL,
	[Value] [nvarchar](50) NULL,
	[Quantity] [int] NULL,
	[RequiredByRequestedSegmentResponse] [nvarchar](50) NULL,
	[MaterialProducedActual] [int] NULL,
 CONSTRAINT [PK_MaterialProducedActualProperty] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MaterialProducedRequirement]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MaterialProducedRequirement](
	[ID] [int] NOT NULL,
	[MaterialClassID] [int] NULL,
	[MaterialDefinitionID] [int] NULL,
	[MaterialLotID] [int] NULL,
	[MaterialSubLotID] [int] NULL,
	[Description] [nvarchar](50) NULL,
	[Location] [nvarchar](50) NULL,
	[HierarchyScope] [int] NULL,
	[Quantity] [int] NULL,
	[RequiredByRequestedSegmentResponce] [nvarchar](50) NULL,
	[SegmentRequirementID] [int] NOT NULL,
 CONSTRAINT [PK_MaterialProducedRequirement] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MaterialProducedRequirementProperty]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MaterialProducedRequirementProperty](
	[ID] [int] NOT NULL,
	[Description] [nvarchar](50) NULL,
	[Value] [nvarchar](50) NULL,
	[Quantity] [int] NULL,
	[MaterialProducedRequirement] [int] NULL,
 CONSTRAINT [PK_MaterialProducedRequirementProperty] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MaterialRequirement]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MaterialRequirement](
	[ID] [int] NOT NULL,
	[MaterialClassID] [int] NULL,
	[MaterialDefinitionID] [int] NULL,
	[MaterialLotID] [int] NULL,
	[MaterialSubLotID] [int] NULL,
	[Description] [nvarchar](50) NULL,
	[Location] [nvarchar](50) NULL,
	[HierarchyScope] [int] NULL,
	[MaterialUse] [nvarchar](50) NULL,
	[Quantity] [int] NULL,
	[AssemblyRequirement] [int] NULL,
	[AssemblyType] [nvarchar](50) NULL,
	[AssemblyRelationship] [nvarchar](50) NULL,
	[RequiredByRequestedSegmentResponce] [nvarchar](50) NULL,
	[SegmentRequirementID] [int] NOT NULL,
 CONSTRAINT [PK_MaterialRequirement] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MaterialRequirementProperty]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MaterialRequirementProperty](
	[ID] [int] NOT NULL,
	[Description] [nvarchar](50) NULL,
	[Value] [nvarchar](50) NULL,
	[Quantity] [int] NULL,
	[MaterialRequirement] [int] NULL,
	[OpMaterialRequirement] [int] NULL,
 CONSTRAINT [PK_MaterialRequirementProperty] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MaterialSegmentSpecificationProperty]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MaterialSegmentSpecificationProperty](
	[ID] [int] NOT NULL,
	[Description] [nvarchar](50) NULL,
	[Value] [nvarchar](50) NULL,
	[Quantity] [int] NULL,
	[MaterialSegmentSpecification] [int] NULL,
 CONSTRAINT [PK_MaterialSegmentSpecificationProperty] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MaterialSegmentSpecificftion]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MaterialSegmentSpecificftion](
	[ID] [int] NOT NULL,
	[MaterialClassID] [int] NULL,
	[MaterialDefinitionID] [int] NULL,
	[Description] [nvarchar](50) NULL,
	[AssemblyType] [nvarchar](50) NULL,
	[AssemblyRelationship] [nvarchar](50) NULL,
	[AssemblySpecificationID] [int] NULL,
	[MaterialUse] [nvarchar](50) NULL,
	[Quantity] [int] NULL,
	[ProccesSegmentID] [int] NULL,
 CONSTRAINT [PK_MaterialSegmentSpecificftion] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MaterialSpecification]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MaterialSpecification](
	[ID] [int] NOT NULL,
	[MaterialClassID] [int] NULL,
	[MaterialDefinitionID] [int] NULL,
	[Description] [nvarchar](50) NULL,
	[MaterialUse] [nvarchar](50) NULL,
	[Quantity] [int] NULL,
	[AssemblySpecification] [int] NULL,
	[AssemblyType] [nvarchar](50) NULL,
	[AssemblyRelationship] [nvarchar](50) NULL,
	[ProductSegmentID] [int] NULL,
 CONSTRAINT [PK_MaterialSpecification] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MaterialSpecificationProperty]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MaterialSpecificationProperty](
	[ID] [int] NOT NULL,
	[Description] [nvarchar](50) NULL,
	[Value] [nvarchar](50) NULL,
	[Quantity] [int] NULL,
	[MaterialSpecification] [int] NULL,
	[OpMaterialSpecification] [int] NULL,
 CONSTRAINT [PK_MaterialSpecificationProperty] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MaterialSubLot]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MaterialSubLot](
	[ID] [int] NOT NULL,
	[Description] [nvarchar](50) NULL,
	[Location] [nvarchar](50) NULL,
	[HierarchyScope] [int] NULL,
	[Status] [nvarchar](50) NULL,
	[StorageLocation] [nvarchar](50) NULL,
	[Quantity] [int] NULL,
	[MaterialLotID] [int] NULL,
	[AssemblyLotID] [int] NULL,
	[AssemblySubLotID] [int] NULL,
	[AssemblyType] [nvarchar](50) NULL,
	[AssemblyReleationship] [nvarchar](50) NULL,
 CONSTRAINT [PK_MateriaSubLot] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MaterialSubLotLinks]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MaterialSubLotLinks](
	[MateriaSubLot1] [int] NOT NULL,
	[MateriaSubLot2] [int] NOT NULL,
	[LinkType] [int] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MaterialTestSpecification]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MaterialTestSpecification](
	[Name] [nvarchar](50) NOT NULL,
	[Description] [nvarchar](50) NULL,
	[Version] [nvarchar](50) NULL,
	[Location] [nvarchar](50) NULL,
	[HierarchyScope] [int] NULL,
 CONSTRAINT [PK_MaterialTestSpecification] PRIMARY KEY CLUSTERED 
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ModificationLog]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ModificationLog](
	[ID] [int] NOT NULL,
	[ModifiedDate] [datetimeoffset] NULL,
	[Description] [nvarchar](50) NULL,
	[Author] [nvarchar](50) NULL,
	[ListHeader] [int] NULL,
	[Header] [int] NULL,
 CONSTRAINT [PK_ModificationLog] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[OpEquipmentActual]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OpEquipmentActual](
	[ID] [int] NOT NULL,
	[EquipmentClassID] [int] NOT NULL,
	[EquipmentID] [int] NULL,
	[Description] [nvarchar](50) NULL,
	[EquipmentUse] [nvarchar](50) NULL,
	[Quantity] [int] NOT NULL,
	[HierarchyScope] [nvarchar](50) NULL,
	[RequiredByRequestedSegment] [nvarchar](50) NULL,
	[JobResponseID] [int] NULL,
	[SegmentResponseID] [int] NULL,
 CONSTRAINT [PK_OpEquipmentActual] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[OpEquipmentCapability]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OpEquipmentCapability](
	[ID] [int] NOT NULL,
	[EquipmentClassID] [int] NULL,
	[EquipmentID] [int] NULL,
	[Description] [nvarchar](50) NULL,
	[CapabilityType] [nvarchar](50) NULL,
	[Reason] [nvarchar](50) NULL,
	[ConfidenceFactor] [nvarchar](50) NULL,
	[HierarchyScope] [int] NULL,
	[EquipmentUse] [nvarchar](50) NULL,
	[StartTime] [datetimeoffset] NULL,
	[EndTime] [datetimeoffset] NULL,
	[Quantity] [int] NULL,
	[OperationCapabilityID] [int] NULL,
	[WorkCapabilityID] [int] NULL,
	[WorkMasterCapabilityID] [int] NULL,
	[ProcessSegmentCapabilityID] [int] NULL,
 CONSTRAINT [PK_OpEquipmentCapability] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[OpEquipmentRequirement]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OpEquipmentRequirement](
	[ID] [int] NOT NULL,
	[EquipmentClassID] [int] NOT NULL,
	[EquipmentID] [int] NOT NULL,
	[Description] [nvarchar](50) NULL,
	[EquipmentUse] [nvarchar](50) NULL,
	[Quantity] [int] NULL,
	[HierarchyScope] [int] NULL,
	[EquipmentLevel] [nvarchar](50) NULL,
	[RequiredByRequestedSegment] [nvarchar](50) NULL,
	[JobOrderID] [int] NULL,
	[SegmenRequirementID] [int] NULL,
 CONSTRAINT [PK_OpEquipmentRequirement] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[OpEquipmentSpecification]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OpEquipmentSpecification](
	[ID] [int] NOT NULL,
	[EquipmentClassID] [int] NULL,
	[EquipmentID] [int] NULL,
	[Description] [nvarchar](50) NULL,
	[EquipmentUse] [nvarchar](50) NULL,
	[Quantity] [int] NULL,
	[OperationSegmentID] [int] NOT NULL,
	[WorkDefinition] [int] NULL,
 CONSTRAINT [PK_OpEquipmentSpecification] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[OperationsCapability]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OperationsCapability](
	[ID] [int] NOT NULL,
	[Description] [nvarchar](50) NULL,
	[HierarchyScope] [int] NULL,
	[CapabilityType] [nvarchar](50) NULL,
	[Reason] [nvarchar](50) NULL,
	[ConfidenceFactor] [nvarchar](50) NULL,
	[StartTime] [datetimeoffset] NULL,
	[EndTime] [datetimeoffset] NULL,
	[PublishedDate] [datetimeoffset] NULL,
	[OperationsCapabilityInformation] [int] NULL,
 CONSTRAINT [PK_OperationsCapability] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[OperationsCapabilityInformation]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OperationsCapabilityInformation](
	[ID] [int] NOT NULL,
	[Description] [nvarchar](50) NULL,
	[HierarchyScope] [nvarchar](50) NULL,
	[PublishedDate] [datetimeoffset] NULL,
 CONSTRAINT [PK_OperationsCapabilityInformation] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[OperationsDefinition]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OperationsDefinition](
	[ID] [int] NOT NULL,
	[Version] [nvarchar](50) NULL,
	[Description] [nvarchar](50) NULL,
	[HierarchyScope] [int] NULL,
	[OperationsType] [nvarchar](50) NULL,
	[PublishedDate] [datetimeoffset] NULL,
	[BillOfMaterialsID] [nvarchar](50) NULL,
	[BillOfResourcesID] [nvarchar](50) NULL,
	[OperationsResponse] [int] NULL,
	[OpSegmentResponse] [int] NULL,
	[OperationsDefinitionInformation] [int] NULL,
 CONSTRAINT [PK_OperationsDefinition] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[OperationsDefinitionInformation]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OperationsDefinitionInformation](
	[ID] [int] NOT NULL,
	[Description] [nvarchar](50) NULL,
	[HierarchyScope] [int] NULL,
	[PublishedDate] [date] NULL,
 CONSTRAINT [PK_OperationsDefinitionInformation] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[OperationsDefinitionRecord]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OperationsDefinitionRecord](
	[ID] [int] NOT NULL,
	[BatchProductionRecordEntry] [int] NOT NULL,
	[OperationsDefinition] [int] NOT NULL,
 CONSTRAINT [PK_OperationsDefinitionRecord] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[OperationsMaterialBill]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OperationsMaterialBill](
	[ID] [int] NOT NULL,
	[Description] [nvarchar](50) NULL,
	[OperationsDefinition] [int] NULL,
 CONSTRAINT [PK_OperationsMaterialBill] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[OperationsMaterialBillItem]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OperationsMaterialBillItem](
	[ID] [int] NOT NULL,
	[Description] [nvarchar](50) NULL,
	[MaterialClassID] [int] NULL,
	[MaterialDefinitionID] [int] NULL,
	[UseType] [nvarchar](50) NULL,
	[AssemblyBillOfMaterialItem] [int] NULL,
	[AssemblyType] [nvarchar](50) NULL,
	[AssemblyRelationship] [nvarchar](50) NULL,
	[MaterialSpecificationID] [int] NULL,
	[Quantity] [int] NULL,
	[OperationsMaterialBill] [int] NULL,
 CONSTRAINT [PK_OperationsMaterialBillItem] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[OperationsPerfomance]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OperationsPerfomance](
	[ID] [int] NOT NULL,
	[Description] [nvarchar](50) NULL,
	[HierarchyScope] [int] NULL,
	[OperationsType] [nvarchar](50) NULL,
	[OperationsScheduleID] [int] NULL,
	[StartTime] [datetimeoffset] NULL,
	[EndTime] [datetimeoffset] NULL,
	[PerformanceState] [nvarchar](50) NULL,
	[PublishedDate] [nvarchar](50) NULL,
 CONSTRAINT [PK_OperationsPerfomance] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[OperationsPerformanceRecord]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OperationsPerformanceRecord](
	[ID] [int] NOT NULL,
	[BatchProductionRecordEntry] [int] NOT NULL,
	[OperationsPerformance] [int] NOT NULL,
 CONSTRAINT [PK_OperationsPerformanceRecord] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[OperationsRequest]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OperationsRequest](
	[ID] [int] NOT NULL,
	[Description] [nvarchar](50) NULL,
	[HierarchyScope] [int] NULL,
	[OperationsType] [nvarchar](50) NULL,
	[StartTime] [datetimeoffset] NULL,
	[EndTime] [datetimeoffset] NULL,
	[Priority] [nvarchar](50) NULL,
	[OperationsDefinitionID] [int] NULL,
	[RequestState] [nvarchar](50) NULL,
	[OperationsSchedule] [int] NULL,
	[OperationsResponse] [int] NULL,
 CONSTRAINT [PK_OperationsRequest] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[OperationsResponse]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OperationsResponse](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Description] [nvarchar](50) NULL,
	[HierarchyScope] [int] NULL,
	[OperationsType] [nvarchar](50) NULL,
	[StartTime] [datetimeoffset] NULL,
	[EndTime] [datetimeoffset] NULL,
	[ResponseState] [nvarchar](50) NULL,
	[OperationsPerfomance] [int] NULL,
 CONSTRAINT [PK_OperationsResponse] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[OperationsScedule]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OperationsScedule](
	[ID] [int] NOT NULL,
	[Description] [nvarchar](50) NULL,
	[HierarchyScope] [int] NULL,
	[OperationsType] [nvarchar](50) NULL,
	[StartTime] [datetimeoffset] NULL,
	[EndTime] [datetimeoffset] NULL,
	[SheduleState] [nvarchar](50) NULL,
	[PublishedDate] [nvarchar](50) NULL,
 CONSTRAINT [PK_OperationsScedule] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[OperationsSceduleRecord]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OperationsSceduleRecord](
	[ID] [int] NOT NULL,
	[BatchProductionRecordEntry] [int] NOT NULL,
	[OperationsScedule] [int] NOT NULL,
 CONSTRAINT [PK_OperationsSceduleRecord] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[OperationsSegment]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OperationsSegment](
	[ID] [int] NOT NULL,
	[Description] [nvarchar](50) NULL,
	[OperationsType] [nvarchar](50) NULL,
	[HierarchyScope] [int] NULL,
	[Duration] [nvarchar](50) NULL,
	[SegmentDependency] [nvarchar](50) NULL,
	[OperationsSegment] [int] NULL,
	[OperationsDefinitionID] [int] NULL,
 CONSTRAINT [PK_OperationsSegment] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[OpMaterialActual]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OpMaterialActual](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[MaterialClassID] [int] NULL,
	[MaterialDefinitionID] [int] NOT NULL,
	[MaterialLotID] [int] NOT NULL,
	[MaterialSubLotID] [int] NULL,
	[Description] [nvarchar](50) NULL,
	[MaterialUse] [nvarchar](50) NULL,
	[StorageLocation] [nvarchar](50) NULL,
	[Quantity] [int] NULL,
	[AssemblyActual] [int] NULL,
	[AssemblyType] [nvarchar](50) NULL,
	[AssemblyRelationship] [nvarchar](50) NULL,
	[HierarchyScope] [int] NULL,
	[RequiredByRequestedSegment] [nvarchar](50) NULL,
	[SegmentResponseID] [int] NULL,
	[JobResponseID] [int] NULL,
 CONSTRAINT [PK_OpMaterialActual] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[OpMaterialCapability]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OpMaterialCapability](
	[ID] [int] NOT NULL,
	[MaterialClassID] [int] NULL,
	[MaterialDefinitionID] [int] NULL,
	[MaterialLotID] [int] NULL,
	[MaterialSubLotID] [int] NULL,
	[Description] [nvarchar](50) NULL,
	[CapabilityType] [nvarchar](50) NULL,
	[Reason] [nvarchar](50) NULL,
	[ConfidenceFactor] [nvarchar](50) NULL,
	[HierarchyScope] [int] NULL,
	[MaterialUse] [nvarchar](50) NULL,
	[StartTime] [datetimeoffset] NULL,
	[EndTime] [datetimeoffset] NULL,
	[AssemblyCapability] [int] NULL,
	[AssemblyType] [nvarchar](50) NULL,
	[AssemblyRelationship] [nvarchar](50) NULL,
	[Quantity] [int] NULL,
	[OperationCapabilityID] [int] NULL,
	[ProcessSegmentCapabilityID] [int] NULL,
	[WorkCapabilityID] [int] NULL,
	[WorkMasterCapabilityID] [int] NULL,
 CONSTRAINT [PK_OpMaterialCapability] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[OpMaterialRequirement]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OpMaterialRequirement](
	[ID] [int] NOT NULL,
	[MaterialClassID] [int] NOT NULL,
	[MaterialDefinitionID] [int] NOT NULL,
	[MaterialLotID] [int] NOT NULL,
	[MaterialSubLotID] [int] NOT NULL,
	[Description] [nvarchar](50) NULL,
	[MaterialUse] [nvarchar](50) NULL,
	[StorageLocation] [nvarchar](50) NULL,
	[Quantity] [nvarchar](50) NULL,
	[AssemblyRequirement] [int] NULL,
	[AssemblyType] [nvarchar](50) NULL,
	[AssemblyRelationship] [nvarchar](50) NULL,
	[HierarchyScope] [nvarchar](50) NULL,
	[RequiredByRequestedSeqment] [nvarchar](50) NULL,
	[JobOrderID] [int] NULL,
	[SegmenRequirementID] [int] NULL,
 CONSTRAINT [PK_OpMaterialRequirement] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[OpMaterialSpecification]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OpMaterialSpecification](
	[ID] [int] NOT NULL,
	[MaterialClassID] [int] NULL,
	[MaterialDefinitionID] [int] NULL,
	[Description] [nvarchar](50) NULL,
	[MaterialUse] [nvarchar](50) NULL,
	[Quantity] [int] NULL,
	[AssemblySpecification] [int] NULL,
	[AssemblyType] [nvarchar](50) NULL,
	[AssemblyRelationship] [nvarchar](50) NULL,
	[OperationsSegment] [int] NULL,
	[WorkDefinition] [int] NULL,
 CONSTRAINT [PK_OpMaterialSpecification] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[OpPersonnelActual]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OpPersonnelActual](
	[ID] [int] NOT NULL,
	[PersonnelClassID] [int] NOT NULL,
	[PersonID] [int] NOT NULL,
	[Description] [nvarchar](50) NULL,
	[PersonnelUse] [nvarchar](50) NULL,
	[Quantity] [int] NULL,
	[HierarchyScope] [int] NULL,
	[PersonnelActualProperty] [int] NULL,
	[RequiredByRequestedSegment] [nvarchar](50) NULL,
	[SegmentResponseID] [int] NULL,
	[JobResponseID] [int] NULL,
 CONSTRAINT [PK_OpPersonnelActual] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[OpPersonnelCapability]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OpPersonnelCapability](
	[ID] [int] NOT NULL,
	[PersonnelClassID] [int] NULL,
	[PersonID] [int] NULL,
	[Description] [nvarchar](50) NULL,
	[CapabilityType] [nvarchar](50) NULL,
	[Reason] [nvarchar](50) NULL,
	[ConfidenceFactor] [nvarchar](50) NULL,
	[HierarchyScope] [int] NULL,
	[PersonnelUse] [nvarchar](50) NULL,
	[StartTime] [datetimeoffset] NULL,
	[EndTime] [datetimeoffset] NULL,
	[Quantity] [int] NULL,
	[OperationCapabilityID] [int] NULL,
	[ProcessSegmentCapabilityID] [int] NULL,
	[WorkCapabilityID] [int] NULL,
	[WorkMasterCapabilityID] [int] NULL,
 CONSTRAINT [PK_OpPersonnelCapability] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[OpPersonnelRequirement]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OpPersonnelRequirement](
	[ID] [int] NOT NULL,
	[PersonnelClassID] [int] NOT NULL,
	[PersonID] [int] NOT NULL,
	[Description] [nvarchar](50) NULL,
	[PersonnelUse] [nvarchar](50) NULL,
	[Quantity] [int] NULL,
	[HierarchyScope] [int] NULL,
	[RequiredByRequestedSegment] [nvarchar](50) NULL,
	[JobOrderID] [int] NULL,
	[SegmenRequirementID] [int] NULL,
 CONSTRAINT [PK_OpPersonnelRequirement] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[OpPersonnelSpecification]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OpPersonnelSpecification](
	[ID] [int] NOT NULL,
	[PersonnelClassID] [int] NULL,
	[PersonID] [int] NULL,
	[Description] [nvarchar](50) NULL,
	[PersonnelUse] [nvarchar](50) NULL,
	[Quantity] [int] NULL,
	[OperationSegmentID] [int] NOT NULL,
	[WorkDefinition] [int] NULL,
 CONSTRAINT [PK_OpPersonnelSpecification] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[OpPhysicalAssetActual]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OpPhysicalAssetActual](
	[ID] [int] NOT NULL,
	[PhysicalAssetClassID] [int] NOT NULL,
	[PhysicalAssetID] [int] NOT NULL,
	[Description] [nvarchar](50) NULL,
	[Quantity] [int] NULL,
	[HierarchyScope] [int] NULL,
	[RequiredByRequestedSegment] [nvarchar](50) NULL,
	[JobResponseID] [int] NULL,
	[SegmentResponseID] [int] NULL,
 CONSTRAINT [PK_OpPhysicalAssetActual] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[OpPhysicalAssetCapability]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OpPhysicalAssetCapability](
	[ID] [int] NOT NULL,
	[PhysicalAssetClassID] [int] NULL,
	[PhysicalAssetID] [int] NULL,
	[Description] [nvarchar](50) NULL,
	[CapabilityType] [nvarchar](50) NULL,
	[Reason] [nvarchar](50) NULL,
	[ConfidenceFactor] [nvarchar](50) NULL,
	[HierarchyScope] [int] NULL,
	[PhysicalAssetUse] [nvarchar](50) NULL,
	[StartTime] [datetimeoffset] NULL,
	[EndTime] [datetimeoffset] NULL,
	[Quantity] [int] NULL,
	[ProcessSegmentCapabilityID] [int] NULL,
	[OperationCapabilityID] [int] NULL,
	[WorkCapabilityID] [int] NULL,
	[WorkMasterCapabilityID] [int] NULL,
 CONSTRAINT [PK_OpPhysicalAssetCapability] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[OpPhysicalAssetRequirement]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OpPhysicalAssetRequirement](
	[ID] [int] NOT NULL,
	[PhysicalAssetClassID] [int] NOT NULL,
	[PhysicalAssetID] [int] NOT NULL,
	[Description] [nvarchar](50) NULL,
	[PhysicalAssetUse] [nvarchar](50) NULL,
	[Quantity] [int] NULL,
	[HierarchyScope] [int] NULL,
	[EquipmentLevel] [nvarchar](50) NULL,
	[RequiredByRequestedSegment] [nvarchar](50) NULL,
	[SegmenRequirementID] [int] NULL,
	[JobOrderID] [int] NULL,
 CONSTRAINT [PK_OpPhysicalAssetRequirement] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[OpPhysicalAssetSpecification]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OpPhysicalAssetSpecification](
	[ID] [int] NOT NULL,
	[PhysicalAssetClassID] [int] NULL,
	[PhysicalAssetID] [int] NULL,
	[Description] [nvarchar](50) NULL,
	[PhysicalAssetUse] [nvarchar](50) NULL,
	[Quantity] [int] NULL,
	[OperationSegmentID] [int] NOT NULL,
	[WorkDefinition] [int] NULL,
 CONSTRAINT [PK_OpPhysicalAssetSpecification] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[OpProcessSegmentCapability]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OpProcessSegmentCapability](
	[ID] [int] NOT NULL,
	[Description] [nvarchar](50) NULL,
	[CapabilityType] [nvarchar](50) NOT NULL,
	[Reason] [nvarchar](50) NULL,
	[HierarchyScope] [int] NULL,
	[EquipmentElementLevel] [nvarchar](50) NULL,
	[StartTime] [datetimeoffset] NULL,
	[EndTime] [datetimeoffset] NULL,
	[ProcessSegmentCapability] [int] NULL,
	[OpetationCapability] [int] NULL,
 CONSTRAINT [PK_OpProcessSegmentCapability] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[OpSegmentData]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OpSegmentData](
	[ID] [int] NOT NULL,
	[Description] [nvarchar](50) NULL,
	[Value] [nvarchar](50) NULL,
	[SegmentData] [nvarchar](50) NULL,
	[RequiredByRequestedSegment] [nvarchar](50) NULL,
	[OpSegmentResponse] [int] NULL,
	[JobResponseData] [int] NULL,
 CONSTRAINT [PK_OpSegmentData] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[OpSegmentRequirement]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OpSegmentRequirement](
	[ID] [int] NOT NULL,
	[Description] [nvarchar](50) NULL,
	[HierarchyScope] [int] NULL,
	[OperationsType] [nvarchar](50) NULL,
	[ProcessSegmentID] [int] NULL,
	[EarliestStartTime] [datetimeoffset] NULL,
	[LatestEndTime] [datetimeoffset] NULL,
	[Duration] [nvarchar](50) NULL,
	[OperationsDefinitionID] [int] NULL,
	[SegmentState] [nvarchar](50) NULL,
	[SegmentRequirement] [int] NULL,
	[RequiredByrequestedSegment] [nvarchar](50) NULL,
	[OperationsRequest] [int] NULL,
 CONSTRAINT [PK_OpSegmentRequirement] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[OpSegmentResponse]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OpSegmentResponse](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Description] [nvarchar](50) NULL,
	[HierarchyScope] [int] NULL,
	[OperationsType] [nvarchar](50) NULL,
	[ActualStartTime] [datetimeoffset] NULL,
	[ActualEndTime] [datetimeoffset] NULL,
	[SegmentState] [nvarchar](50) NULL,
	[SegmentResponse] [int] NULL,
	[RequiredByRequestedSegment] [nvarchar](50) NULL,
	[OperationsResponse] [int] NULL,
	[OperationsRequested] [int] NULL,
 CONSTRAINT [PK_OpSegmentResponse] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[OrderedData]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrderedData](
	[ID] [int] NOT NULL,
	[OrderIndex] [nvarchar](50) NULL,
	[TimeValue] [datetimeoffset] NULL,
	[DataSet] [int] NULL,
 CONSTRAINT [PK_OrderedData] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[OtherInformation]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OtherInformation](
	[OtherInfoID] [int] NOT NULL,
	[Description] [nvarchar](50) NULL,
	[OtherValue] [nvarchar](50) NULL,
	[GRecipe] [int] NULL,
	[ProcessElement] [int] NULL,
 CONSTRAINT [PK_OtherInformation] PRIMARY KEY CLUSTERED 
(
	[OtherInfoID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Parameter]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Parameter](
	[ID] [int] NOT NULL,
	[Value] [nvarchar](50) NULL,
	[Description] [nvarchar](50) NULL,
	[Parameter] [int] NULL,
	[JobOrder] [int] NULL,
 CONSTRAINT [PK_Parameter] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Person]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Person](
	[ID] [int] NOT NULL,
	[Description] [nvarchar](50) NULL,
	[Location] [nvarchar](50) NULL,
	[HierarchyScope] [int] NULL,
	[PersonName] [nvarchar](50) NULL,
	[PersonnelClassID] [int] NULL,
	[PersonnelInformation] [int] NULL,
 CONSTRAINT [PK_Person] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

/****** Object:  Table [dbo].[PersonnelActual]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PersonnelActual](
	[ID] [int] NOT NULL,
	[PersonnelClassID] [int] NULL,
	[PersonID] [int] NULL,
	[Description] [nvarchar](50) NULL,
	[Location] [nvarchar](50) NULL,
	[HierarchyScope] [int] NULL,
	[Quantity] [int] NULL,
	[RequiredByRequestedSegmentResponse] [nvarchar](50) NULL,
	[SegmentResponseID] [int] NOT NULL,
 CONSTRAINT [PK_PersonnelActual] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PersonnelActualProperty]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PersonnelActualProperty](
	[ID] [int] NOT NULL,
	[Description] [nvarchar](50) NULL,
	[Value] [nvarchar](50) NULL,
	[Quantity] [int] NULL,
	[RequiredByRequestedSegmentResponse] [nvarchar](50) NULL,
	[PersonnelActual] [int] NULL,
	[OpPersonnelActual] [int] NULL,
 CONSTRAINT [PK_PersonnelActualProperty] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PersonnelCapability]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PersonnelCapability](
	[ID] [int] NOT NULL,
	[PersonnelClassID] [int] NULL,
	[PersonID] [int] NULL,
	[Description] [nvarchar](50) NULL,
	[CapabilityType] [nvarchar](50) NOT NULL,
	[Reason] [nvarchar](50) NULL,
	[EquipmentElementLevel] [nvarchar](50) NULL,
	[StartTime] [datetimeoffset] NULL,
	[EndTime] [datetimeoffset] NULL,
	[Location] [nvarchar](50) NULL,
	[HierarchyScope] [int] NULL,
	[Quantity] [int] NULL,
	[ProductionCapabilityID] [int] NULL,
	[ProcessSegmentCapabilityID] [int] NULL,
 CONSTRAINT [PK_PersonnelCapability] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PersonnelCapabilityProperty]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PersonnelCapabilityProperty](
	[ID] [int] NOT NULL,
	[Description] [nvarchar](50) NULL,
	[Value] [nvarchar](50) NULL,
	[Quantity] [int] NULL,
	[PersonnelCapabilityID] [int] NULL,
	[OpPersonnelCapabilityID] [int] NULL,
 CONSTRAINT [PK_PersonnelCapabilityProperty] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PersonnelClass]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PersonnelClass](
	[ID] [int] NOT NULL,
	[ParentID] [int] NULL,
	[Description] [nvarchar](50) NULL,
	[Location] [nvarchar](50) NULL,
	[HierarchyScope] [int] NULL,
	[PersonnelInformation] [int] NULL,
 CONSTRAINT [PK_PersonnelClass] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PersonnelClassProperty]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PersonnelClassProperty](
	[ID] [int] NOT NULL,
	[Description] [nvarchar](50) NULL,
	[Value] [nvarchar](50) NULL,
	[PersonnelClassProperty] [int] NULL,
	[QualificationTestSpecificationID] [int] NULL,
	[PersonnelClassID] [int] NULL,
 CONSTRAINT [PK_PersonnelClassProperty] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PersonnelIdentificationManifest]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PersonnelIdentificationManifest](
	[ID] [int] NOT NULL,
	[BatchProductionRecordEntry] [int] NULL,
	[RecordReference] [nvarchar](50) NULL,
	[Name] [int] NULL,
	[ChangeInformation] [nvarchar](50) NULL,
	[Reason] [nvarchar](50) NULL,
 CONSTRAINT [PK_PersonnelIdentificationManifest] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PersonnelInformation]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PersonnelInformation](
	[ID] [int] NOT NULL,
	[Description] [nvarchar](50) NULL,
	[Location] [nvarchar](50) NULL,
	[HierarchyScope] [int] NULL,
	[PublishedDate] [nvarchar](50) NULL,
 CONSTRAINT [PK_PersonnelInformation] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PersonnelRequirement]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PersonnelRequirement](
	[ID] [int] NOT NULL,
	[PersonnelClassID] [int] NULL,
	[PersonID] [int] NULL,
	[Description] [nvarchar](50) NULL,
	[Location] [nvarchar](50) NULL,
	[HierarchyScope] [int] NULL,
	[Quantity] [int] NULL,
	[RequiredByRequestedSegmentResponce] [nvarchar](50) NULL,
	[SegmentRequirementID] [int] NOT NULL,
 CONSTRAINT [PK_PersonnelRequirement] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PersonnelRequirementProperty]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PersonnelRequirementProperty](
	[ID] [int] NOT NULL,
	[Description] [nvarchar](50) NULL,
	[Value] [nvarchar](50) NULL,
	[Quantity] [int] NULL,
	[PersonnelRequirement] [int] NULL,
	[OpPersonnelRequirement] [int] NULL,
 CONSTRAINT [PK_PersonnelRequirementProperty] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PersonnelSegmentSpecification]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PersonnelSegmentSpecification](
	[ID] [int] NOT NULL,
	[PersonnelClassID] [int] NULL,
	[PersonID] [int] NULL,
	[Description] [nvarchar](50) NULL,
	[PersonnelUse] [nvarchar](50) NULL,
	[Quantity] [int] NULL,
	[ProcessSegmentID] [int] NOT NULL,
 CONSTRAINT [PK_PersonnelSegmentSpecification] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PersonnelSegmentSpecificationProperty]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PersonnelSegmentSpecificationProperty](
	[ID] [nvarchar](50) NOT NULL,
	[Description] [nvarchar](50) NULL,
	[Value] [nvarchar](50) NULL,
	[Quantity] [int] NULL,
	[PersonnelSegmentSpecification] [int] NULL,
 CONSTRAINT [PK_PersonnelSegmentSpecificationProperty] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PersonnelSpecification]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PersonnelSpecification](
	[ID] [int] NOT NULL,
	[PersonnelClassID] [int] NULL,
	[PersonID] [int] NULL,
	[Description] [nvarchar](50) NULL,
	[Quantity] [int] NULL,
	[ProductSegmentID] [int] NULL,
 CONSTRAINT [PK_PersonnelSpecification] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PersonnelSpecificationProperty]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PersonnelSpecificationProperty](
	[ID] [nvarchar](50) NOT NULL,
	[Description] [nvarchar](50) NULL,
	[Value] [nvarchar](50) NULL,
	[Quantity] [int] NULL,
	[PersonelSpecification] [int] NULL,
	[OpPersonelSpecification] [int] NULL,
 CONSTRAINT [PK_PersonnelSpecificationProperty] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PersonProperty]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PersonProperty](
	[ID] [int] NOT NULL,
	[Description] [nvarchar](50) NULL,
	[Value] [nvarchar](50) NULL,
	[PersonProperty] [int] NULL,
	[QualificationTestSpecificationID] [int] NULL,
	[PersonID] [int] NULL,
	[ClassPropertyID] [int] NULL,
 CONSTRAINT [PK_PersonProperty] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PhysicalAsset]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PhysicalAsset](
	[ID] [int] NOT NULL,
	[Description] [nvarchar](50) NULL,
	[HierarchyScope] [nvarchar](50) NULL,
	[PhysicalLocation] [nvarchar](50) NULL,
	[FixedAssetID] [int] NULL,
	[VendorID] [nvarchar](50) NULL,
	[EquipmentLevel] [nvarchar](50) NULL,
	[PhysicalAsset] [int] NULL,
	[PhysicalAssetClassID] [int] NULL,
 CONSTRAINT [PK_PhysicalAsset] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PhysicalAssetActual]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PhysicalAssetActual](
	[ID] [int] NOT NULL,
	[PhysicalAssetClassID] [int] NULL,
	[PhysicalAssetID] [int] NULL,
	[Description] [nvarchar](50) NULL,
	[Location] [nvarchar](50) NULL,
	[HierarchyScope] [int] NULL,
	[Quantity] [int] NULL,
	[RequiredByRequestedSegmentResponse] [nvarchar](50) NULL,
	[SegmentResponseID] [int] NOT NULL,
 CONSTRAINT [PK_PhysicalAssetActual] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PhysicalAssetActualProperty]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PhysicalAssetActualProperty](
	[ID] [int] NOT NULL,
	[Description] [nvarchar](50) NULL,
	[Value] [nvarchar](50) NULL,
	[Quantity] [int] NULL,
	[RequiredByRequestedSegmentResponse] [nvarchar](50) NULL,
	[PhysicalAssetActual] [int] NULL,
	[OpPhysicalAssetActual] [int] NULL,
 CONSTRAINT [PK_PhysicalAssetActualProperty] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PhysicalAssetCapability]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PhysicalAssetCapability](
	[ID] [int] NOT NULL,
	[PhysicalAssetClassID] [int] NULL,
	[PhysicalAssetID] [int] NULL,
	[Description] [nvarchar](50) NULL,
	[CapabilityType] [nvarchar](50) NOT NULL,
	[Reason] [nvarchar](50) NULL,
	[EquipmentElementLevel] [nvarchar](50) NULL,
	[StartTime] [datetimeoffset] NULL,
	[EndTime] [datetimeoffset] NULL,
	[Location] [nvarchar](50) NULL,
	[HierarchyScope] [int] NULL,
	[Quantity] [int] NULL,
	[PruductionCapabilityID] [int] NULL,
 CONSTRAINT [PK_PhysicalAssetCapability] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PhysicalAssetCapabilityProperty]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PhysicalAssetCapabilityProperty](
	[ID] [int] NOT NULL,
	[Description] [nvarchar](50) NULL,
	[Value] [nvarchar](50) NULL,
	[Quantity] [int] NULL,
	[PhysicalAssetCapability] [int] NULL,
	[OpPhysicalAssetCapability] [int] NULL,
 CONSTRAINT [PK_PhysicalAssetCapabilityProperty] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PhysicalAssetCapabilityTestSpesification]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PhysicalAssetCapabilityTestSpesification](
	[Name] [nvarchar](50) NOT NULL,
	[Description] [nvarchar](50) NULL,
	[Version] [nvarchar](50) NULL,
	[HierarchyScope] [int] NULL,
 CONSTRAINT [PK_PhysicalAssetCapabilityTestSpesification] PRIMARY KEY CLUSTERED 
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PhysicalAssetClass]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PhysicalAssetClass](
	[ID] [int] NOT NULL,
	[ParentID] [int] NULL,
	[Description] [nvarchar](50) NULL,
	[HierarchyScope] [int] NULL,
	[Manufacturer] [nvarchar](50) NULL,
 CONSTRAINT [PK_PhysicalAssetClass] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PhysicalAssetClassProperty]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PhysicalAssetClassProperty](
	[ID] [int] NOT NULL,
	[Description] [nvarchar](50) NULL,
	[Value] [nvarchar](50) NULL,
	[PhysicalAssetClassProperty] [int] NULL,
	[PhysicalAssetCapabilityTestSpecification] [nvarchar](50) NULL,
	[PhysicalAssetClassID] [int] NULL,
 CONSTRAINT [PK_PhysicalAssetClassProperty] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PhysicalAssetInformation]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PhysicalAssetInformation](
	[ID] [int] NULL,
	[Description] [nvarchar](50) NULL,
	[HierarchyScope] [int] NULL,
	[PublishedDate] [nvarchar](50) NULL,
	[PhysicalAsset] [int] NULL,
	[PhysicalAssetClassID] [int] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PhysicalAssetProperty]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PhysicalAssetProperty](
	[ID] [int] NOT NULL,
	[Description] [nvarchar](50) NULL,
	[Value] [nvarchar](50) NULL,
	[PhysicalAssetProperty] [int] NULL,
	[PhysicalAssetCapabilityTestSpecification] [nvarchar](50) NULL,
	[TestResult] [nvarchar](50) NULL,
	[PhysicalAssetID] [int] NULL,
	[ClassPropertyID] [int] NULL,
 CONSTRAINT [PK_PhysicalAssetProperty] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PhysicalAssetRequirement]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PhysicalAssetRequirement](
	[ID] [int] NOT NULL,
	[PhysicalAssetClassID] [int] NULL,
	[PhysicalAssetID] [int] NULL,
	[Description] [nvarchar](50) NULL,
	[Location] [nvarchar](50) NULL,
	[HierarchyScope] [int] NULL,
	[Quantity] [int] NULL,
	[RequiredByRequestedSegmentResponce] [nvarchar](50) NULL,
	[SegmentRequirementID] [int] NOT NULL,
 CONSTRAINT [PK_PhysicalAssetRequirement] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PhysicalAssetRequirementProperty]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PhysicalAssetRequirementProperty](
	[ID] [int] NOT NULL,
	[Description] [nvarchar](50) NULL,
	[Value] [nvarchar](50) NULL,
	[Quantity] [int] NULL,
	[PhysicalAssetRequirement] [int] NULL,
	[OpPhysicalAssetRequirement] [int] NULL,
 CONSTRAINT [PK_PhysicalAssetRequirementProperty] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PhysicalAssetSegmentSpecification]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PhysicalAssetSegmentSpecification](
	[ID] [int] NOT NULL,
	[PhysicalAssetClassID] [int] NULL,
	[PhysicalAssetID] [int] NULL,
	[Description] [nvarchar](50) NULL,
	[PhysicalAssetUse] [nvarchar](50) NULL,
	[Quantity] [int] NULL,
	[ProcessSegmentID] [int] NOT NULL,
 CONSTRAINT [PK_PhysicalAssetSegmentSpecification] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PhysicalAssetSegmentSpecificationProperty]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PhysicalAssetSegmentSpecificationProperty](
	[ID] [int] NOT NULL,
	[Description] [nvarchar](50) NULL,
	[Value] [nvarchar](50) NULL,
	[Quantity] [int] NULL,
	[PhysicalAssetSegmentSpecification] [int] NULL,
 CONSTRAINT [PK_PhysicalAssetSegmentSpecificationProperty] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PhysicalAssetSpecification]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PhysicalAssetSpecification](
	[ID] [int] NOT NULL,
	[PhysicalAssetClassID] [int] NULL,
	[PhysicalAssetID] [int] NULL,
	[Description] [nvarchar](50) NULL,
	[Quantity] [int] NULL,
	[ProductSegmentID] [int] NULL,
 CONSTRAINT [PK_PhysicalAssetSpecification] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PhysicalAssetSpecificationProperty]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PhysicalAssetSpecificationProperty](
	[ID] [int] NOT NULL,
	[Description] [nvarchar](50) NULL,
	[Value] [nvarchar](50) NULL,
	[Quantity] [int] NULL,
	[PhysicalAssetSpecification] [int] NULL,
	[OpPhysicalAssetSpecification] [int] NULL,
 CONSTRAINT [PK_PhysicalAssetSpecificationProperty] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ProcedureChartElement]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProcedureChartElement](
	[ID] [int] NOT NULL,
	[Label] [nvarchar](50) NULL,
	[Description] [nvarchar](50) NULL,
	[ProcedureChartElement] [int] NULL,
	[ProcessElement] [int] NULL,
 CONSTRAINT [PK_ProcedureChartElement] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ProcedureLogic]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProcedureLogic](
	[ID] [int] NOT NULL,
	[Description] [nvarchar](50) NULL,
 CONSTRAINT [PK_ProcedureLogic] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ProcessElement]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProcessElement](
	[ID] [int] NOT NULL,
	[Description] [nvarchar](50) NULL,
	[ProcessElementType] [nvarchar](50) NULL,
	[LifeCycleState] [nvarchar](50) NULL,
	[SequenceOrder] [nvarchar](50) NULL,
	[SequencePath] [nvarchar](50) NULL,
	[Materials] [int] NULL,
	[ProcessElement] [int] NULL,
	[ProcessElementLibrary] [int] NULL,
 CONSTRAINT [PK_ProcessElement] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ProcessElementLibrary]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProcessElementLibrary](
	[ID] [int] NOT NULL,
	[Description] [nvarchar](50) NULL,
	[Location] [nvarchar](50) NULL,
	[PublishedDate] [datetimeoffset] NULL,
 CONSTRAINT [PK_ProcessElementLibrary] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ProcessElementParameter]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProcessElementParameter](
	[ID] [int] NOT NULL,
	[Description] [nvarchar](50) NULL,
	[ProcessElementParameter] [int] NULL,
	[Value] [nvarchar](50) NULL,
	[ProcessElement] [int] NULL,
	[GRecipeFormula] [int] NULL,
 CONSTRAINT [PK_ProcessElementParameter] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ProcessSegment]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProcessSegment](
	[ID] [int] NOT NULL,
	[Description] [nvarchar](50) NULL,
	[OperationsType] [nvarchar](50) NULL,
	[Location] [nvarchar](50) NULL,
	[HierarchyScope] [int] NULL,
	[PublishedDate] [datetimeoffset] NULL,
	[Duration] [nvarchar](50) NULL,
	[SegmentDependency] [nvarchar](50) NULL,
	[ProcessSegment] [int] NULL,
	[SegmentResponse] [int] NULL,
	[OperationsSegment] [int] NULL,
	[ProductDefinition] [int] NULL,
	[OpProcessSegmentCapability] [int] NULL,
	[ProcessSegmentInformation] [int] NULL,
	[OpSegmentResponse] [int] NULL,
	[ProductSegmentID] [int] NULL,
 CONSTRAINT [PK_ProcessSegment] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ProcessSegmentCapability]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProcessSegmentCapability](
	[ID] [int] NOT NULL,
	[Description] [nvarchar](50) NULL,
	[ProcessSegmentID] [int] NULL,
	[CapabilityType] [nvarchar](50) NOT NULL,
	[Reason] [nvarchar](50) NULL,
	[Location] [nvarchar](50) NULL,
	[HierarchyScope] [int] NULL,
	[EquipmentElementLevel] [nvarchar](50) NULL,
	[StartTime] [datetimeoffset] NULL,
	[EndTime] [datetimeoffset] NULL,
	[ProcessSegmentCapability] [int] NULL,
	[ProductionCapabilityID] [int] NULL,
 CONSTRAINT [PK_ProcessSegmentCapability] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ProcessSegmentInformation]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProcessSegmentInformation](
	[ID] [int] NOT NULL,
	[Description] [nvarchar](50) NULL,
	[Location] [nvarchar](50) NULL,
	[HierarchyScope] [int] NULL,
	[PublishedDate] [datetimeoffset] NULL,
 CONSTRAINT [PK_ProcessSegmentInformation] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ProductDefinition]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProductDefinition](
	[ID] [int] NOT NULL,
	[Version] [nvarchar](50) NULL,
	[Description] [nvarchar](50) NULL,
	[Location] [nvarchar](50) NULL,
	[HierarchyScope] [int] NULL,
	[PublishedDate] [datetimeoffset] NULL,
	[ProductProductionRule] [int] NULL,
	[BillOfMaterialsID] [nvarchar](50) NULL,
	[BillOfResourcesID] [nvarchar](50) NULL,
	[ProductInformation] [int] NULL,
 CONSTRAINT [PK_ProductDefinition] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ProductDefinitionRecord]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProductDefinitionRecord](
	[BatchProductionRecordEntry] [int] NOT NULL,
	[ProductDefinition] [int] NOT NULL,
	[ID] [int] NOT NULL,
 CONSTRAINT [PK_ProductDefinitionRecord] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ProductInformation]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProductInformation](
	[ID] [int] NOT NULL,
	[Description] [nvarchar](50) NULL,
	[Location] [nvarchar](50) NULL,
	[HierarchyScope] [int] NULL,
	[PublishedDate] [datetimeoffset] NULL,
 CONSTRAINT [PK_ProductInformation] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ProductionCapability]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProductionCapability](
	[ID] [int] NOT NULL,
	[Description] [nvarchar](50) NULL,
	[Location] [nvarchar](50) NULL,
	[HierarchyScope] [int] NULL,
	[PublishedDate] [datetimeoffset] NOT NULL,
	[CapabilityType] [nvarchar](50) NOT NULL,
	[Reason] [nvarchar](50) NULL,
	[EquipmentElementLevel] [nvarchar](50) NULL,
	[StartTime] [datetimeoffset] NULL,
	[EndTime] [datetimeoffset] NULL,
 CONSTRAINT [PK_ProductionCapability] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ProductionData]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProductionData](
	[ID] [int] NOT NULL,
	[Description] [nvarchar](50) NULL,
	[Value] [nvarchar](50) NULL,
	[RequiredByRequestedSegmentResponse] [nvarchar](50) NULL,
	[ProductionData] [int] NULL,
	[SegmentResponse] [int] NULL,
 CONSTRAINT [PK_ProductionData] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ProductionParameter]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProductionParameter](
	[ID] [int] NOT NULL,
	[ProductSegmentID] [int] NULL,
	[ProcessSegmentID] [int] NULL,
	[Parameter] [nvarchar](50) NULL,
 CONSTRAINT [PK_ProductionParameter] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ProductionPerformance]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProductionPerformance](
	[ID] [int] NOT NULL,
	[Description] [nvarchar](50) NULL,
	[Location] [nvarchar](50) NULL,
	[HierarchyScope] [int] NULL,
	[PublishedDate] [datetimeoffset] NULL,
	[ProductionScheduleID] [int] NULL,
	[StartTime] [datetimeoffset] NULL,
	[EndTime] [datetimeoffset] NULL,
	[EquipmentElementLevel] [nvarchar](50) NULL,
	[PerformanceState] [nvarchar](50) NULL,
 CONSTRAINT [PK_ProductionPerformance] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ProductionPerformanceRecord]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProductionPerformanceRecord](
	[ID] [int] NOT NULL,
	[BatchProductionRecordEntry] [int] NOT NULL,
	[ProductionPerformance] [int] NOT NULL,
 CONSTRAINT [PK_ProductionPerformanceRecord] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ProductionRequest]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProductionRequest](
	[ID] [int] NOT NULL,
	[Description] [nvarchar](50) NOT NULL,
	[Location] [nvarchar](50) NOT NULL,
	[HierarchyScope] [int] NOT NULL,
	[StartTime] [datetimeoffset] NOT NULL,
	[EndTime] [datetimeoffset] NOT NULL,
	[Priority] [nvarchar](50) NOT NULL,
	[RequestState] [nvarchar](50) NOT NULL,
	[ProductionSchedule] [int] NULL,
 CONSTRAINT [PK_ProductionRequest] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ProductionResponse]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProductionResponse](
	[ID] [int] NOT NULL,
	[ProductionRequestID] [int] NOT NULL,
	[Location] [nvarchar](50) NOT NULL,
	[HierarchyScope] [int] NOT NULL,
	[StartTime] [datetimeoffset] NOT NULL,
	[EndTime] [datetimeoffset] NOT NULL,
	[ResponseState] [nvarchar](50) NOT NULL,
	[ProductionPerfomance] [int] NULL,
 CONSTRAINT [PK_ProductionResponse] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ProductionScedule]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProductionScedule](
	[ID] [int] NOT NULL,
	[Description] [nvarchar](50) NULL,
	[Location] [nvarchar](50) NULL,
	[HierarchyScope] [int] NULL,
	[PublishedDate] [nvarchar](50) NULL,
	[StartTime] [datetimeoffset] NULL,
	[EndTime] [datetimeoffset] NULL,
	[EquipmentElementLevel] [nvarchar](50) NULL,
	[SceduleState] [nvarchar](50) NULL,
 CONSTRAINT [PK_ProductionScedule] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ProductionSceduleRecord]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProductionSceduleRecord](
	[ID] [int] NOT NULL,
	[BatchProductionRecordEntry] [int] NOT NULL,
	[ProductionScedule] [int] NOT NULL,
 CONSTRAINT [PK_ProductionSceduleRecord] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ProductProductionRuleIDGroup]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProductProductionRuleIDGroup](
	[ProductProductionRuleID] [int] NOT NULL,
	[Version] [nvarchar](50) NULL,
	[ProductionRequest] [int] NULL,
	[ProductionResponse] [int] NULL,
 CONSTRAINT [PK_ProductProductionRuleIDGroup] PRIMARY KEY CLUSTERED 
(
	[ProductProductionRuleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ProductSegment]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProductSegment](
	[ID] [int] NOT NULL,
	[Description] [nvarchar](50) NULL,
	[Duration] [nvarchar](50) NULL,
	[SegmentDependency] [nvarchar](50) NULL,
	[ProductSegment] [int] NULL,
	[SegmentResponse] [int] NULL,
	[ProductDefinition] [int] NULL,
 CONSTRAINT [PK_ProductSegment] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PropertyTypes]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PropertyTypes](
	[ID] [int] NOT NULL,
	[Value] [nvarchar](50) NULL,
	[Description] [nvarchar](50) NULL,
 CONSTRAINT [PK_PropertyTypes] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[QualificationTestSpecification]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[QualificationTestSpecification](
	[ID] [int] NOT NULL,
	[Description] [nvarchar](50) NULL,
	[Version] [nvarchar](50) NULL,
	[Location] [nvarchar](50) NULL,
	[HierarchyScope] [int] NULL,
 CONSTRAINT [PK_QualificationTestSpecification] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[RecipeBuildingBlock]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RecipeBuildingBlock](
	[ID] [int] NOT NULL,
	[Description] [nvarchar](50) NOT NULL,
	[BatchInformation] [int] NULL,
 CONSTRAINT [PK_RecipeBuildingBlock] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[RecipeElement]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RecipeElement](
	[ID] [int] NOT NULL,
	[Version] [nvarchar](50) NULL,
	[VersionDate] [datetimeoffset] NULL,
	[Description] [nvarchar](50) NULL,
	[RecipeElementType] [nvarchar](50) NOT NULL,
	[BuildingBlockElementID] [int] NULL,
	[BuildingBlockElementVersion] [nvarchar](50) NULL,
	[ActualEquipmentID] [nvarchar](50) NULL,
	[Header] [int] NULL,
	[ProcedureLogic] [int] NULL,
	[RecipeElement] [int] NULL,
	[MasterRecipe] [int] NULL,
	[ControlRecipe] [int] NULL,
 CONSTRAINT [PK_RecipeElement] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[RecipeElementRecord]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RecipeElementRecord](
	[ID] [int] NOT NULL,
	[BatchProductionRecordEntry] [int] NOT NULL,
	[RecipeElement] [int] NOT NULL,
 CONSTRAINT [PK_RecipeElementRecord] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ResourceConstraint]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ResourceConstraint](
	[ConstraintID] [int] NOT NULL,
	[Description] [nvarchar](50) NULL,
	[ConstraintType] [nvarchar](50) NULL,
	[LifeCycleState] [nvarchar](50) NULL,
	[Range] [nvarchar](50) NULL,
	[GRecipe] [int] NULL,
	[ProcessElement] [int] NULL,
	[ResourceConstraintLibrary] [int] NULL,
 CONSTRAINT [PK_ResourceConstraint] PRIMARY KEY CLUSTERED 
(
	[ConstraintID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ResourceConstraintLibrary]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ResourceConstraintLibrary](
	[ID] [int] NOT NULL,
	[Description] [nvarchar](50) NULL,
	[Location] [nvarchar](50) NULL,
	[PublishedDate] [datetimeoffset] NULL,
 CONSTRAINT [PK_ResourceConstraintLibrary] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ResourceConstraintProperty]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ResourceConstraintProperty](
	[ID] [int] NOT NULL,
	[Description] [nvarchar](50) NULL,
	[Value] [nvarchar](50) NULL,
	[ResourceConstraint] [int] NULL,
 CONSTRAINT [PK_ResourceConstraintProperty] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ResourceNetworkConnection]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ResourceNetworkConnection](
	[ID] [int] NOT NULL,
	[Description] [nvarchar](50) NULL,
	[ResourceNetworkConnectionID] [int] NULL,
	[FromResourceReference] [int] NOT NULL,
	[ToResourceReference] [int] NOT NULL,
	[ConnectionProperty] [nvarchar](50) NULL,
	[ResourceRelationshipNetwork] [int] NULL,
 CONSTRAINT [PK_ResourceNetworkConnection] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ResourceNetworkConnectionInformation]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ResourceNetworkConnectionInformation](
	[ID] [int] NOT NULL,
	[Description] [nvarchar](50) NULL,
	[HierarchyScope] [int] NULL,
 CONSTRAINT [PK_ResourceNetworkConnectionInformation] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ResourceNetworkConnectionType]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ResourceNetworkConnectionType](
	[ID] [int] NOT NULL,
	[Description] [nvarchar](50) NULL,
	[ResourceNetworkConnectionID] [int] NULL,
	[ConnectionProperty] [nvarchar](50) NULL,
	[ResourceNetworkConnectionInformation] [int] NULL,
 CONSTRAINT [PK_ResourceNetworkConnectionType] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ResourceProperty]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ResourceProperty](
	[ID] [int] NOT NULL,
	[Description] [nvarchar](50) NULL,
	[Value] [nvarchar](50) NULL,
	[ResourceReference] [int] NULL,
 CONSTRAINT [PK_ResourceProperty] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ResourceQualificationsManifest]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ResourceQualificationsManifest](
	[ID] [int] NOT NULL,
	[BatchProductionRecordEntry] [int] NULL,
	[RecordReference] [nvarchar](50) NULL,
	[ResourceID] [nvarchar](50) NULL,
	[ResourceUse] [nvarchar](50) NULL,
	[ResourceType] [nvarchar](50) NULL,
	[QualificationStatus] [nvarchar](50) NULL,
	[EffectiveTimeStamp] [nvarchar](50) NULL,
	[ExpirationTimeStamp] [nvarchar](50) NULL,
 CONSTRAINT [PK_ResourceQualificationsManifest] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ResourceReference]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ResourceReference](
	[ID] [int] NOT NULL,
	[ResourceID] [nvarchar](50) NULL,
	[ResourceType] [nvarchar](50) NULL,
 CONSTRAINT [PK_ResourceReference] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ResourceRelationshipNetwork]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ResourceRelationshipNetwork](
	[ID] [int] NOT NULL,
	[Description] [nvarchar](50) NULL,
	[HierarchyScope] [int] NULL,
	[RelationshipType] [nvarchar](50) NULL,
	[RelationshipForm] [nvarchar](50) NULL,
	[PublishedDate] [nvarchar](50) NULL,
 CONSTRAINT [PK_ResourceRelationshipNetwork] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Sample]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Sample](
	[ID] [int] NOT NULL,
	[BatchProductionRecordEntry] [int] NULL,
	[SampleSourceID] [int] NULL,
	[SampleSize] [nvarchar](50) NULL,
	[SampleType] [nvarchar](50) NULL,
	[SamplePullReason] [nvarchar](50) NULL,
	[SampleExpiration] [nvarchar](50) NULL,
	[EquipmentID] [int] NULL,
	[PhysicalAssetID] [int] NULL,
	[ProceduralElementReference] [nvarchar](50) NULL,
	[SOPReference] [nvarchar](50) NULL,
 CONSTRAINT [PK_Sample] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SampleTest]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SampleTest](
	[ID] [int] NOT NULL,
	[BatchProductionRecordEntry] [int] NULL,
	[TestCode] [nvarchar](50) NULL,
	[TestName] [nvarchar](50) NULL,
	[Sample] [int] NULL,
 CONSTRAINT [PK_SampleTest] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SampleTestResult]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SampleTestResult](
	[ID] [int] NOT NULL,
	[BatchProductionRecordEntry] [int] NULL,
	[TestDisposition] [nvarchar](50) NULL,
	[EquipmentID] [int] NULL,
	[PhysicalAssetID] [int] NULL,
	[AnalysisUsed] [nvarchar](50) NULL,
	[Expiration] [nvarchar](50) NULL,
	[Results] [nvarchar](50) NULL,
	[ExpectedResults] [nvarchar](50) NULL,
	[SampleTest] [int] NULL,
 CONSTRAINT [PK_SampleTestResult] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SegmentParameter]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SegmentParameter](
	[ID] [int] NOT NULL,
	[Value] [nvarchar](50) NULL,
	[Description] [nvarchar](50) NULL,
	[Parameter] [int] NULL,
	[OperationsSegment] [int] NULL,
	[OpSegmentRequirement] [int] NULL,
 CONSTRAINT [PK_SegmentParameter] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SegmentRequirement]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SegmentRequirement](
	[ID] [int] NOT NULL,
	[ProductSegmentID] [int] NULL,
	[ProcessSegmentID] [int] NULL,
	[Description] [nvarchar](50) NULL,
	[Location] [nvarchar](50) NULL,
	[HierarchyScope] [int] NULL,
	[EarliestStartTime] [datetimeoffset] NULL,
	[LatestEndTime] [datetimeoffset] NULL,
	[Duration] [nvarchar](50) NULL,
	[ProductionParameter] [int] NULL,
	[SegmentRequirement] [int] NULL,
	[RequiredByRequestedSegmentResponce] [nvarchar](50) NULL,
	[SeqmentState] [nvarchar](50) NULL,
	[ProductionRequest] [int] NULL,
 CONSTRAINT [PK_SegmentRequirement] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SegmentResponse]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SegmentResponse](
	[ID] [int] NOT NULL,
	[Description] [nvarchar](50) NULL,
	[Location] [nvarchar](50) NULL,
	[HierarchyScope] [int] NULL,
	[ActualStartTime] [datetimeoffset] NULL,
	[ActualEndTime] [datetimeoffset] NULL,
	[SegmentResponse] [int] NULL,
	[RequiredByRequestedSegmentResponse] [nvarchar](50) NULL,
	[SegmentState] [nvarchar](50) NULL,
	[ProductionRequest] [int] NULL,
	[ProductionResponse] [int] NULL,
 CONSTRAINT [PK_SegmentResponse] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Step]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Step](
	[ID] [int] NOT NULL,
	[RecipeElementID] [int] NOT NULL,
	[RecipeElementVersion] [nvarchar](50) NOT NULL,
	[Description] [nvarchar](50) NULL,
	[ProcedureLogic] [int] NOT NULL,
 CONSTRAINT [PK_Step] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SupportedAction]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SupportedAction](
	[ID] [int] NOT NULL,
	[releaseID] [nvarchar](50) NOT NULL,
	[versionID] [nvarchar](50) NULL,
	[Description] [nvarchar](50) NULL,
	[TransactionVerb] [nvarchar](50) NOT NULL,
	[TransactionNoun] [nvarchar](50) NOT NULL,
	[InformationUser] [nvarchar](50) NULL,
	[InformationProvider] [nvarchar](50) NULL,
	[InformationSender] [nvarchar](50) NULL,
	[InformationReceiver] [nvarchar](50) NULL,
	[ObjectWidcarSupported] [nvarchar](50) NULL,
	[PropertyWidcarSupported] [nvarchar](50) NULL,
	[TransactionProfile] [int] NULL,
 CONSTRAINT [PK_SupportedAction] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[TagSpecification]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TagSpecification](
	[TagIndex] [int] NOT NULL,
	[DataType] [nvarchar](50) NULL,
	[UnitOfMeasure] [nvarchar](50) NULL,
	[DataSource] [nvarchar](50) NULL,
	[Alias] [nvarchar](50) NULL,
	[Description] [nvarchar](50) NULL,
	[EquipmentID] [int] NULL,
	[PhysicalAssetID] [int] NULL,
	[ProceduralElementReference] [nvarchar](50) NULL,
	[Deadband] [nvarchar](50) NULL,
	[SignificantDigits] [nvarchar](50) NULL,
	[DataCompression] [nvarchar](50) NULL,
	[SamplingType] [nvarchar](50) NULL,
	[DataSet] [int] NULL,
 CONSTRAINT [PK_TagSpecification] PRIMARY KEY CLUSTERED 
(
	[TagIndex] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[TimeSpecification]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TimeSpecification](
	[ID] [int] NOT NULL,
	[Relative] [nvarchar](50) NULL,
	[OffsetTime] [datetimeoffset] NULL,
	[OffsetTimeFormat] [datetimeoffset] NULL,
 CONSTRAINT [PK_TimeSpecification] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ToID]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ToID](
	[ID] [int] NOT NULL,
	[ToIDValue] [int] NOT NULL,
	[ToType] [nvarchar](50) NOT NULL,
	[IDScope] [nvarchar](50) NOT NULL,
	[Link] [int] NULL,
 CONSTRAINT [PK_ToID] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[TransactionProfile]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TransactionProfile](
	[ID] [int] NOT NULL,
	[releaseID] [nvarchar](50) NOT NULL,
	[versionID] [nvarchar](50) NULL,
	[Description] [nvarchar](50) NULL,
	[HierarchyScope] [int] NULL,
	[PublishedScope] [nvarchar](50) NULL,
	[PublishedDate] [datetimeoffset] NULL,
 CONSTRAINT [PK_TransactionProfile] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Transition]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Transition](
	[ID] [int] NOT NULL,
	[Condition] [nvarchar](50) NOT NULL,
	[ConditionAnnotation] [nvarchar](50) NULL,
	[Description] [nvarchar](50) NULL,
	[ProcedureLogic] [int] NULL,
 CONSTRAINT [PK_Transition] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[UserAttribute]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserAttribute](
	[AttributeID] [int] NOT NULL,
	[Description] [nvarchar](50) NOT NULL,
	[Value] [nvarchar](50) NOT NULL,
	[Event] [int] NULL,
 CONSTRAINT [PK_UserAttribute] PRIMARY KEY CLUSTERED 
(
	[AttributeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Value]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Value](
	[ValueString] [nvarchar](50) NOT NULL,
	[DataType] [nvarchar](50) NOT NULL,
	[UntiOfMeasure] [nvarchar](50) NOT NULL,
	[Key] [nvarchar](50) NULL,
 CONSTRAINT [PK_Value] PRIMARY KEY CLUSTERED 
(
	[ValueString] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[WorkAlert]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WorkAlert](
	[ID] [int] NOT NULL,
	[MessageText] [nvarchar](50) NULL,
	[HierarchyScope] [int] NULL,
	[TimeStamp] [nvarchar](50) NULL,
	[Priority] [nvarchar](50) NULL,
	[Category] [nvarchar](50) NULL,
	[WorkAlertInformation] [int] NULL,
 CONSTRAINT [PK_WorkAlert] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[WorkAlertDefinition]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WorkAlertDefinition](
	[ID] [int] NOT NULL,
	[Description] [nvarchar](50) NULL,
	[HierarchyScope] [int] NULL,
	[Priority] [nvarchar](50) NULL,
	[Category] [nvarchar](50) NULL,
	[WorkAlertInformation] [int] NULL,
 CONSTRAINT [PK_WorkAlertDefinition] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[WorkAlertInformation]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WorkAlertInformation](
	[ID] [int] NOT NULL,
	[Description] [nvarchar](50) NULL,
	[HierarchyScope] [int] NULL,
	[PublishedDate] [datetimeoffset] NULL,
 CONSTRAINT [PK_WorkAlertInformation] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[WorkAlertProperty]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WorkAlertProperty](
	[ID] [int] NOT NULL,
	[Description] [nvarchar](50) NULL,
	[Value] [nvarchar](50) NULL,
	[WorAlert] [int] NULL,
	[WorAlertDefinition] [int] NULL,
 CONSTRAINT [PK_WorkAlertProperty] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[WorkCapability]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WorkCapability](
	[ID] [int] NOT NULL,
	[Description] [nvarchar](50) NULL,
	[HierarchyScope] [int] NULL,
	[CapabilityType] [nvarchar](50) NULL,
	[Reason] [nvarchar](50) NULL,
	[ConfidenceFactor] [nvarchar](50) NULL,
	[StartTime] [datetimeoffset] NOT NULL,
	[EndTime] [datetimeoffset] NULL,
	[PublishedDate] [nvarchar](50) NULL,
	[WorkCapabilityInformation] [int] NULL,
 CONSTRAINT [PK_WorkCapability] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[WorkCapabilityInformation]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WorkCapabilityInformation](
	[ID] [int] NOT NULL,
	[Description] [nvarchar](50) NULL,
	[HierarchyScope] [int] NULL,
	[PublishedDate] [datetimeoffset] NULL,
 CONSTRAINT [PK_WorkCapabilityInformation] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[WorkDefinition]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WorkDefinition](
	[ID] [int] NOT NULL,
	[Version] [nvarchar](50) NULL,
	[Description] [nvarchar](50) NULL,
	[HierarchyScope] [nvarchar](50) NULL,
	[WorkType] [nvarchar](50) NULL,
	[Duration] [datetimeoffset] NULL,
	[PublishedDate] [datetimeoffset] NULL,
	[OperationsDefinitionID] [int] NULL,
	[Parameter] [nvarchar](50) NULL,
 CONSTRAINT [PK_WorkDefinition] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[WorkDefinitionInformation]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WorkDefinitionInformation](
	[ID] [int] NOT NULL,
	[Description] [nvarchar](50) NULL,
	[HierarchyScope] [int] NULL,
	[PublishedDate] [datetimeoffset] NULL,
 CONSTRAINT [PK_WorkDefinitionInformation] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[WorkDirective]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WorkDirective](
	[WorkMasterID] [int] NOT NULL,
	[WorkDirective] [int] NOT NULL,
	[WorkDefinitionInformation] [int] NULL,
	[WorkDefinitionID] [int] NOT NULL,
 CONSTRAINT [PK_WorkDirective] PRIMARY KEY CLUSTERED 
(
	[WorkDirective] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[WorkDirectiveRecord]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WorkDirectiveRecord](
	[ID] [int] NOT NULL,
	[BatchProductionRecordEntry] [int] NOT NULL,
	[WorkDirective] [int] NOT NULL,
 CONSTRAINT [PK_WorkDirectiveRecord] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[WorkflowSpecification]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WorkflowSpecification](
	[ID] [int] NOT NULL,
	[Version] [nvarchar](50) NULL,
	[Description] [nvarchar](50) NULL,
	[WorkflowSpecificationInformation] [int] NULL,
 CONSTRAINT [PK_WorkflowSpecification] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[WorkflowSpecificationConnection]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WorkflowSpecificationConnection](
	[ID] [int] NOT NULL,
	[Description] [nvarchar](50) NULL,
	[ConnectionType] [int] NOT NULL,
	[FromNodeID] [nvarchar](50) NULL,
	[ToNodeID] [nvarchar](50) NULL,
	[WorkflowSpecification] [int] NULL,
 CONSTRAINT [PK_WorkflowSpecificationConnection] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[WorkflowSpecificationConnectionType]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WorkflowSpecificationConnectionType](
	[ID] [int] NOT NULL,
	[Description] [nvarchar](50) NULL,
	[WorkflowSpecificationType] [int] NULL,
 CONSTRAINT [PK_WorkflowSpecificationConnectionType] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[WorkflowSpecificationInformation]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WorkflowSpecificationInformation](
	[ID] [int] NOT NULL,
	[Description] [nvarchar](50) NULL,
	[HierarchyScope] [int] NULL,
	[PublishedDate] [datetimeoffset] NULL,
 CONSTRAINT [PK_WorkflowSpecificationInformation] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[WorkflowSpecificationNode]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WorkflowSpecificationNode](
	[ID] [int] NOT NULL,
	[Description] [nvarchar](50) NULL,
	[NodeType] [int] NOT NULL,
	[WorkflowSpecification] [int] NULL,
	[WorkDefinition] [int] NULL,
 CONSTRAINT [PK_WorkflowSpecificationNode] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[WorkflowSpecificationNodeType]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WorkflowSpecificationNodeType](
	[ID] [int] NOT NULL,
	[Description] [nvarchar](50) NULL,
	[WorkflowSpecificationType] [int] NULL,
 CONSTRAINT [PK_WorkflowSpecificationNodeType] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[WorkflowSpecificationProperty]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WorkflowSpecificationProperty](
	[ID] [int] NOT NULL,
	[Description] [nvarchar](50) NULL,
	[PropertyType] [nvarchar](50) NULL,
	[Value] [nvarchar](50) NULL,
	[Property] [int] NULL,
	[WorkflowSpecificationNode] [int] NULL,
	[WorkflowSpecificationNodeType] [int] NULL,
	[WorkflowSpecificationConnection] [int] NULL,
	[WorkflowSpecificationConnectionType] [int] NULL,
 CONSTRAINT [PK_WorkflowSpecificationProperty] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[WorkflowSpecificationType]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WorkflowSpecificationType](
	[ID] [int] NOT NULL,
	[Version] [nvarchar](50) NULL,
	[Description] [nvarchar](50) NULL,
	[WorkflowSpecificationInformation] [int] NULL,
 CONSTRAINT [PK_WorkflowSpecificationType] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[WorkMaster]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WorkMaster](
	[WorkMaster] [int] NOT NULL,
	[WorkDefinitionInformation] [int] NULL,
	[WorkDefinitionID] [int] NOT NULL,
 CONSTRAINT [PK_WorkMaster] PRIMARY KEY CLUSTERED 
(
	[WorkMaster] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[WorkMasterCapability]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WorkMasterCapability](
	[ID] [int] NOT NULL,
	[Description] [nvarchar](50) NULL,
	[WorkMasterID] [int] NULL,
	[CapabilityType] [nvarchar](50) NOT NULL,
	[Reason] [nvarchar](50) NULL,
	[HierarchyScope] [int] NULL,
	[StartTime] [datetimeoffset] NULL,
	[EndTime] [datetimeoffset] NULL,
	[WorkCapability] [int] NULL,
 CONSTRAINT [PK_WorkMasterCapability] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[WorkMasterRecord]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WorkMasterRecord](
	[ID] [int] NOT NULL,
	[BatchProductionRecordEntry] [int] NOT NULL,
	[WorkMaster] [int] NOT NULL,
 CONSTRAINT [PK_WorkMasterRecord] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[WorkPerformance]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WorkPerformance](
	[ID] [int] NOT NULL,
	[Description] [nvarchar](50) NULL,
	[HierarchyScope] [int] NULL,
	[WorkType] [nvarchar](50) NULL,
	[WorkScheduleID] [int] NULL,
	[StartTime] [datetimeoffset] NULL,
	[EndTime] [datetimeoffset] NULL,
	[WorkState] [nvarchar](50) NULL,
	[PublishedDate] [nvarchar](50) NULL,
 CONSTRAINT [PK_WorkPerformance] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[WorkPerformanceRecord]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WorkPerformanceRecord](
	[ID] [int] NOT NULL,
	[BatchProductionRecordEntry] [int] NOT NULL,
	[WorkPerformance] [int] NOT NULL,
 CONSTRAINT [PK_WorkPerformanceRecord] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[WorkRequest]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WorkRequest](
	[ID] [int] NOT NULL,
	[Description] [nvarchar](50) NULL,
	[HierarchyScope] [int] NULL,
	[Workype] [nvarchar](50) NULL,
	[StartTime] [datetimeoffset] NULL,
	[EndTime] [datetimeoffset] NULL,
	[Priority] [nvarchar](50) NULL,
	[WorkRequest] [int] NULL,
	[WorkSchedule] [int] NULL,
 CONSTRAINT [PK_WorkRequest] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[WorkResponse]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WorkResponse](
	[ID] [int] NOT NULL,
	[Description] [nvarchar](50) NULL,
	[HierarchyScope] [int] NULL,
	[WorkType] [nvarchar](50) NULL,
	[WorkRequestID] [int] NULL,
	[StartTime] [datetimeoffset] NULL,
	[EndTime] [datetimeoffset] NULL,
	[ResponseState] [nvarchar](50) NULL,
	[WorkPerfomence] [int] NULL,
 CONSTRAINT [PK_WorkResponse] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[WorkSceduleRecord]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WorkSceduleRecord](
	[ID] [int] NOT NULL,
	[BatchProductionRecordEntry] [int] NOT NULL,
	[WorkScedule] [int] NOT NULL,
 CONSTRAINT [PK_WorkSceduleRecord] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[WorkSchedule]    Script Date: 08.12.2015 12:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WorkSchedule](
	[ID] [int] NOT NULL,
	[Description] [nvarchar](50) NULL,
	[HierarchyScope] [int] NULL,
	[WorkType] [nvarchar](50) NULL,
	[StartTime] [datetimeoffset] NULL,
	[EndTime] [datetimeoffset] NULL,
	[ScheduleState] [nvarchar](50) NULL,
	[PublishedDate] [datetimeoffset] NULL,
	[WorkShedule] [int] NULL,
 CONSTRAINT [PK_WorkScedule] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[AlarmData]  WITH CHECK ADD  CONSTRAINT [FK_AlarmData_Event] FOREIGN KEY([Event])
REFERENCES [dbo].[Event] ([ID])
GO
ALTER TABLE [dbo].[AlarmData] CHECK CONSTRAINT [FK_AlarmData_Event]
GO
ALTER TABLE [dbo].[ApprovalHistory]  WITH CHECK ADD  CONSTRAINT [FK_ApprovalHistory_Header] FOREIGN KEY([Header])
REFERENCES [dbo].[Header] ([ID])
GO
ALTER TABLE [dbo].[ApprovalHistory] CHECK CONSTRAINT [FK_ApprovalHistory_Header]
GO
ALTER TABLE [dbo].[BatchEquipmentRequirement]  WITH CHECK ADD  CONSTRAINT [FK_BatchEquipmentRequirement_ControlRecipe] FOREIGN KEY([ControlRecipe])
REFERENCES [dbo].[ControlRecipe] ([ID])
GO
ALTER TABLE [dbo].[BatchEquipmentRequirement] CHECK CONSTRAINT [FK_BatchEquipmentRequirement_ControlRecipe]
GO
ALTER TABLE [dbo].[BatchEquipmentRequirement]  WITH CHECK ADD  CONSTRAINT [FK_BatchEquipmentRequirement_MasterRecipe] FOREIGN KEY([MasterRecipe])
REFERENCES [dbo].[MasterRecipe] ([ID])
GO
ALTER TABLE [dbo].[BatchEquipmentRequirement] CHECK CONSTRAINT [FK_BatchEquipmentRequirement_MasterRecipe]
GO
ALTER TABLE [dbo].[BatchEquipmentRequirement]  WITH CHECK ADD  CONSTRAINT [FK_BatchEquipmentRequirement_RecipeElement] FOREIGN KEY([RecipeElement])
REFERENCES [dbo].[RecipeElement] ([ID])
GO
ALTER TABLE [dbo].[BatchEquipmentRequirement] CHECK CONSTRAINT [FK_BatchEquipmentRequirement_RecipeElement]
GO
ALTER TABLE [dbo].[BatchList]  WITH CHECK ADD  CONSTRAINT [FK_BatchList_BatchInformation] FOREIGN KEY([BatchInformation])
REFERENCES [dbo].[BatchInformation] ([ID])
GO
ALTER TABLE [dbo].[BatchList] CHECK CONSTRAINT [FK_BatchList_BatchInformation]
GO
ALTER TABLE [dbo].[BatchListEntry]  WITH CHECK ADD  CONSTRAINT [FK_BatchListEntry_BatchList] FOREIGN KEY([BatchList])
REFERENCES [dbo].[BatchList] ([ID])
GO
ALTER TABLE [dbo].[BatchListEntry] CHECK CONSTRAINT [FK_BatchListEntry_BatchList]
GO
ALTER TABLE [dbo].[BatchListEntry]  WITH CHECK ADD  CONSTRAINT [FK_BatchListEntry_BatchListEntry] FOREIGN KEY([BatchListEntryType])
REFERENCES [dbo].[BatchListEntry] ([ID])
GO
ALTER TABLE [dbo].[BatchListEntry] CHECK CONSTRAINT [FK_BatchListEntry_BatchListEntry]
GO
ALTER TABLE [dbo].[BatchListEntry]  WITH CHECK ADD  CONSTRAINT [FK_BatchListEntry_Equipment] FOREIGN KEY([EquipmentID])
REFERENCES [dbo].[Equipment] ([ID])
GO
ALTER TABLE [dbo].[BatchListEntry] CHECK CONSTRAINT [FK_BatchListEntry_Equipment]
GO
ALTER TABLE [dbo].[BatchListEntry]  WITH CHECK ADD  CONSTRAINT [FK_BatchListEntry_EquipmentClass] FOREIGN KEY([EquipmentClassID])
REFERENCES [dbo].[EquipmentClass] ([ID])
GO
ALTER TABLE [dbo].[BatchListEntry] CHECK CONSTRAINT [FK_BatchListEntry_EquipmentClass]
GO
ALTER TABLE [dbo].[BatchListEntry]  WITH CHECK ADD  CONSTRAINT [FK_BatchListEntry_GRecipe] FOREIGN KEY([RecipeID])
REFERENCES [dbo].[GRecipe] ([ID])
GO
ALTER TABLE [dbo].[BatchListEntry] CHECK CONSTRAINT [FK_BatchListEntry_GRecipe]
GO
ALTER TABLE [dbo].[BatchListEntry]  WITH CHECK ADD  CONSTRAINT [FK_BatchListEntry_GRecipeProductInformation] FOREIGN KEY([ProductID])
REFERENCES [dbo].[GRecipeProductInformation] ([ProductID])
GO
ALTER TABLE [dbo].[BatchListEntry] CHECK CONSTRAINT [FK_BatchListEntry_GRecipeProductInformation]
GO
ALTER TABLE [dbo].[BatchOtherInformation]  WITH CHECK ADD  CONSTRAINT [FK_BatchOtherInformation_BatchValue] FOREIGN KEY([BatchValue])
REFERENCES [dbo].[BatchValue] ([ValueString])
GO
ALTER TABLE [dbo].[BatchOtherInformation] CHECK CONSTRAINT [FK_BatchOtherInformation_BatchValue]
GO
ALTER TABLE [dbo].[BatchOtherInformation]  WITH CHECK ADD  CONSTRAINT [FK_BatchOtherInformation_ControlRecipe] FOREIGN KEY([ControlRecipe])
REFERENCES [dbo].[ControlRecipe] ([ID])
GO
ALTER TABLE [dbo].[BatchOtherInformation] CHECK CONSTRAINT [FK_BatchOtherInformation_ControlRecipe]
GO
ALTER TABLE [dbo].[BatchOtherInformation]  WITH CHECK ADD  CONSTRAINT [FK_BatchOtherInformation_MasterRecipe] FOREIGN KEY([MasterRecipe])
REFERENCES [dbo].[MasterRecipe] ([ID])
GO
ALTER TABLE [dbo].[BatchOtherInformation] CHECK CONSTRAINT [FK_BatchOtherInformation_MasterRecipe]
GO
ALTER TABLE [dbo].[BatchOtherInformation]  WITH CHECK ADD  CONSTRAINT [FK_BatchOtherInformation_RecipeElement] FOREIGN KEY([RecipeElement])
REFERENCES [dbo].[RecipeElement] ([ID])
GO
ALTER TABLE [dbo].[BatchOtherInformation] CHECK CONSTRAINT [FK_BatchOtherInformation_RecipeElement]
GO
ALTER TABLE [dbo].[BatchParameter]  WITH CHECK ADD  CONSTRAINT [FK_BatchParameter_BatchListEntry] FOREIGN KEY([BatchListEntry])
REFERENCES [dbo].[BatchListEntry] ([ID])
GO
ALTER TABLE [dbo].[BatchParameter] CHECK CONSTRAINT [FK_BatchParameter_BatchListEntry]
GO
ALTER TABLE [dbo].[BatchParameter]  WITH CHECK ADD  CONSTRAINT [FK_BatchParameter_BatchParameter] FOREIGN KEY([Parameter])
REFERENCES [dbo].[BatchParameter] ([ID])
GO
ALTER TABLE [dbo].[BatchParameter] CHECK CONSTRAINT [FK_BatchParameter_BatchParameter]
GO
ALTER TABLE [dbo].[BatchParameter]  WITH CHECK ADD  CONSTRAINT [FK_BatchParameter_BatchValue] FOREIGN KEY([Value])
REFERENCES [dbo].[BatchValue] ([ValueString])
GO
ALTER TABLE [dbo].[BatchParameter] CHECK CONSTRAINT [FK_BatchParameter_BatchValue]
GO
ALTER TABLE [dbo].[BatchParameter]  WITH CHECK ADD  CONSTRAINT [FK_BatchParameter_Formula] FOREIGN KEY([Formula])
REFERENCES [dbo].[Formula] ([ID])
GO
ALTER TABLE [dbo].[BatchParameter] CHECK CONSTRAINT [FK_BatchParameter_Formula]
GO
ALTER TABLE [dbo].[BatchParameter]  WITH CHECK ADD  CONSTRAINT [FK_BatchParameter_RecipeElement] FOREIGN KEY([RecipeElement])
REFERENCES [dbo].[RecipeElement] ([ID])
GO
ALTER TABLE [dbo].[BatchParameter] CHECK CONSTRAINT [FK_BatchParameter_RecipeElement]
GO
ALTER TABLE [dbo].[BatchProductionRecord]  WITH CHECK ADD  CONSTRAINT [FK_BatchProductionRecord_BatchProductionRecord] FOREIGN KEY([BatchProductionRecord])
REFERENCES [dbo].[BatchProductionRecord] ([ID])
GO
ALTER TABLE [dbo].[BatchProductionRecord] CHECK CONSTRAINT [FK_BatchProductionRecord_BatchProductionRecord]
GO
ALTER TABLE [dbo].[BatchProductionRecord]  WITH CHECK ADD  CONSTRAINT [FK_BatchProductionRecord_BatchProductionRecordEntry] FOREIGN KEY([BatchProductionRecordEntry])
REFERENCES [dbo].[BatchProductionRecordEntry] ([EntryID])
GO
ALTER TABLE [dbo].[BatchProductionRecord] CHECK CONSTRAINT [FK_BatchProductionRecord_BatchProductionRecordEntry]
GO
ALTER TABLE [dbo].[BatchProductionRecord]  WITH CHECK ADD  CONSTRAINT [FK_BatchProductionRecord_Change] FOREIGN KEY([ChangeHistory])
REFERENCES [dbo].[Change] ([ID])
GO
ALTER TABLE [dbo].[BatchProductionRecord] CHECK CONSTRAINT [FK_BatchProductionRecord_Change]
GO
ALTER TABLE [dbo].[BatchProductionRecord]  WITH CHECK ADD  CONSTRAINT [FK_BatchProductionRecord_Comment] FOREIGN KEY([Comments])
REFERENCES [dbo].[Comment] ([ID])
GO
ALTER TABLE [dbo].[BatchProductionRecord] CHECK CONSTRAINT [FK_BatchProductionRecord_Comment]
GO
ALTER TABLE [dbo].[BatchProductionRecord]  WITH CHECK ADD  CONSTRAINT [FK_BatchProductionRecord_ControlRecipeRecord] FOREIGN KEY([ControlRecipes])
REFERENCES [dbo].[ControlRecipeRecord] ([ID])
GO
ALTER TABLE [dbo].[BatchProductionRecord] CHECK CONSTRAINT [FK_BatchProductionRecord_ControlRecipeRecord]
GO
ALTER TABLE [dbo].[BatchProductionRecord]  WITH CHECK ADD  CONSTRAINT [FK_BatchProductionRecord_DataSet] FOREIGN KEY([DataSets])
REFERENCES [dbo].[DataSet] ([ID])
GO
ALTER TABLE [dbo].[BatchProductionRecord] CHECK CONSTRAINT [FK_BatchProductionRecord_DataSet]
GO
ALTER TABLE [dbo].[BatchProductionRecord]  WITH CHECK ADD  CONSTRAINT [FK_BatchProductionRecord_Equipment] FOREIGN KEY([EquipmentID])
REFERENCES [dbo].[Equipment] ([ID])
GO
ALTER TABLE [dbo].[BatchProductionRecord] CHECK CONSTRAINT [FK_BatchProductionRecord_Equipment]
GO
ALTER TABLE [dbo].[BatchProductionRecord]  WITH CHECK ADD  CONSTRAINT [FK_BatchProductionRecord_Event] FOREIGN KEY([Events])
REFERENCES [dbo].[Event] ([ID])
GO
ALTER TABLE [dbo].[BatchProductionRecord] CHECK CONSTRAINT [FK_BatchProductionRecord_Event]
GO
ALTER TABLE [dbo].[BatchProductionRecord]  WITH CHECK ADD  CONSTRAINT [FK_BatchProductionRecord_MasterRecipeRecord] FOREIGN KEY([MasterRecipes])
REFERENCES [dbo].[MasterRecipeRecord] ([ID])
GO
ALTER TABLE [dbo].[BatchProductionRecord] CHECK CONSTRAINT [FK_BatchProductionRecord_MasterRecipeRecord]
GO
ALTER TABLE [dbo].[BatchProductionRecord]  WITH CHECK ADD  CONSTRAINT [FK_BatchProductionRecord_MaterialDefinition] FOREIGN KEY([MaterialDefinitionID])
REFERENCES [dbo].[MaterialDefinition] ([ID])
GO
ALTER TABLE [dbo].[BatchProductionRecord] CHECK CONSTRAINT [FK_BatchProductionRecord_MaterialDefinition]
GO
ALTER TABLE [dbo].[BatchProductionRecord]  WITH CHECK ADD  CONSTRAINT [FK_BatchProductionRecord_MaterialLot] FOREIGN KEY([LotID])
REFERENCES [dbo].[MaterialLot] ([ID])
GO
ALTER TABLE [dbo].[BatchProductionRecord] CHECK CONSTRAINT [FK_BatchProductionRecord_MaterialLot]
GO
ALTER TABLE [dbo].[BatchProductionRecord]  WITH CHECK ADD  CONSTRAINT [FK_BatchProductionRecord_OperationsDefinitionRecord] FOREIGN KEY([OperationsDefinitions])
REFERENCES [dbo].[OperationsDefinitionRecord] ([ID])
GO
ALTER TABLE [dbo].[BatchProductionRecord] CHECK CONSTRAINT [FK_BatchProductionRecord_OperationsDefinitionRecord]
GO
ALTER TABLE [dbo].[BatchProductionRecord]  WITH CHECK ADD  CONSTRAINT [FK_BatchProductionRecord_OperationsPerformanceRecord] FOREIGN KEY([OperationsPerformances])
REFERENCES [dbo].[OperationsPerformanceRecord] ([ID])
GO
ALTER TABLE [dbo].[BatchProductionRecord] CHECK CONSTRAINT [FK_BatchProductionRecord_OperationsPerformanceRecord]
GO
ALTER TABLE [dbo].[BatchProductionRecord]  WITH CHECK ADD  CONSTRAINT [FK_BatchProductionRecord_OperationsSceduleRecord] FOREIGN KEY([OperationsScedules])
REFERENCES [dbo].[OperationsSceduleRecord] ([ID])
GO
ALTER TABLE [dbo].[BatchProductionRecord] CHECK CONSTRAINT [FK_BatchProductionRecord_OperationsSceduleRecord]
GO
ALTER TABLE [dbo].[BatchProductionRecord]  WITH CHECK ADD  CONSTRAINT [FK_BatchProductionRecord_PersonnelIdentificationManifest] FOREIGN KEY([PersonnelIdentification])
REFERENCES [dbo].[PersonnelIdentificationManifest] ([ID])
GO
ALTER TABLE [dbo].[BatchProductionRecord] CHECK CONSTRAINT [FK_BatchProductionRecord_PersonnelIdentificationManifest]
GO
ALTER TABLE [dbo].[BatchProductionRecord]  WITH CHECK ADD  CONSTRAINT [FK_BatchProductionRecord_PhysicalAsset] FOREIGN KEY([PhysicalAssetID])
REFERENCES [dbo].[PhysicalAsset] ([ID])
GO
ALTER TABLE [dbo].[BatchProductionRecord] CHECK CONSTRAINT [FK_BatchProductionRecord_PhysicalAsset]
GO
ALTER TABLE [dbo].[BatchProductionRecord]  WITH CHECK ADD  CONSTRAINT [FK_BatchProductionRecord_ProductDefinitionRecord] FOREIGN KEY([ProductDefinitions])
REFERENCES [dbo].[ProductDefinitionRecord] ([ID])
GO
ALTER TABLE [dbo].[BatchProductionRecord] CHECK CONSTRAINT [FK_BatchProductionRecord_ProductDefinitionRecord]
GO
ALTER TABLE [dbo].[BatchProductionRecord]  WITH CHECK ADD  CONSTRAINT [FK_BatchProductionRecord_ProductionPerformanceRecord] FOREIGN KEY([ProductionPerformances])
REFERENCES [dbo].[ProductionPerformanceRecord] ([ID])
GO
ALTER TABLE [dbo].[BatchProductionRecord] CHECK CONSTRAINT [FK_BatchProductionRecord_ProductionPerformanceRecord]
GO
ALTER TABLE [dbo].[BatchProductionRecord]  WITH CHECK ADD  CONSTRAINT [FK_BatchProductionRecord_ProductionSceduleRecord] FOREIGN KEY([ProductionScedules])
REFERENCES [dbo].[ProductionSceduleRecord] ([ID])
GO
ALTER TABLE [dbo].[BatchProductionRecord] CHECK CONSTRAINT [FK_BatchProductionRecord_ProductionSceduleRecord]
GO
ALTER TABLE [dbo].[BatchProductionRecord]  WITH CHECK ADD  CONSTRAINT [FK_BatchProductionRecord_RecipeElementRecord] FOREIGN KEY([RecipeElements])
REFERENCES [dbo].[RecipeElementRecord] ([ID])
GO
ALTER TABLE [dbo].[BatchProductionRecord] CHECK CONSTRAINT [FK_BatchProductionRecord_RecipeElementRecord]
GO
ALTER TABLE [dbo].[BatchProductionRecord]  WITH CHECK ADD  CONSTRAINT [FK_BatchProductionRecord_ResourceQualificationsManifest] FOREIGN KEY([ResourceQualifications])
REFERENCES [dbo].[ResourceQualificationsManifest] ([ID])
GO
ALTER TABLE [dbo].[BatchProductionRecord] CHECK CONSTRAINT [FK_BatchProductionRecord_ResourceQualificationsManifest]
GO
ALTER TABLE [dbo].[BatchProductionRecord]  WITH CHECK ADD  CONSTRAINT [FK_BatchProductionRecord_Sample] FOREIGN KEY([Samples])
REFERENCES [dbo].[Sample] ([ID])
GO
ALTER TABLE [dbo].[BatchProductionRecord] CHECK CONSTRAINT [FK_BatchProductionRecord_Sample]
GO
ALTER TABLE [dbo].[BatchProductionRecord]  WITH CHECK ADD  CONSTRAINT [FK_BatchProductionRecord_WorkDirectiveRecord] FOREIGN KEY([WorkDirectives])
REFERENCES [dbo].[WorkDirectiveRecord] ([ID])
GO
ALTER TABLE [dbo].[BatchProductionRecord] CHECK CONSTRAINT [FK_BatchProductionRecord_WorkDirectiveRecord]
GO
ALTER TABLE [dbo].[BatchProductionRecord]  WITH CHECK ADD  CONSTRAINT [FK_BatchProductionRecord_WorkMasterRecord] FOREIGN KEY([WorkMasters])
REFERENCES [dbo].[WorkMasterRecord] ([ID])
GO
ALTER TABLE [dbo].[BatchProductionRecord] CHECK CONSTRAINT [FK_BatchProductionRecord_WorkMasterRecord]
GO
ALTER TABLE [dbo].[BatchProductionRecord]  WITH CHECK ADD  CONSTRAINT [FK_BatchProductionRecord_WorkPerformanceRecord] FOREIGN KEY([WorkPerformances])
REFERENCES [dbo].[WorkPerformanceRecord] ([ID])
GO
ALTER TABLE [dbo].[BatchProductionRecord] CHECK CONSTRAINT [FK_BatchProductionRecord_WorkPerformanceRecord]
GO
ALTER TABLE [dbo].[BatchProductionRecord]  WITH CHECK ADD  CONSTRAINT [FK_BatchProductionRecord_WorkSceduleRecord] FOREIGN KEY([WorkScedules])
REFERENCES [dbo].[WorkSceduleRecord] ([ID])
GO
ALTER TABLE [dbo].[BatchProductionRecord] CHECK CONSTRAINT [FK_BatchProductionRecord_WorkSceduleRecord]
GO
ALTER TABLE [dbo].[Change]  WITH CHECK ADD  CONSTRAINT [FK_Change_BatchProductionRecordEntry] FOREIGN KEY([BatchProductionRecordEntry])
REFERENCES [dbo].[BatchProductionRecordEntry] ([EntryID])
GO
ALTER TABLE [dbo].[Change] CHECK CONSTRAINT [FK_Change_BatchProductionRecordEntry]
GO
ALTER TABLE [dbo].[ClassInstanceAssociation]  WITH CHECK ADD  CONSTRAINT [FK_ClassInstanceAssociation_EquipmentElement] FOREIGN KEY([EquipmentElement])
REFERENCES [dbo].[EquipmentElement] ([ID])
GO
ALTER TABLE [dbo].[ClassInstanceAssociation] CHECK CONSTRAINT [FK_ClassInstanceAssociation_EquipmentElement]
GO
ALTER TABLE [dbo].[ClassInstanceAssociation]  WITH CHECK ADD  CONSTRAINT [FK_ClassInstanceAssociation_EquipmentProoceduralElement] FOREIGN KEY([MemberEquipmentID])
REFERENCES [dbo].[EquipmentProoceduralElement] ([ID])
GO
ALTER TABLE [dbo].[ClassInstanceAssociation] CHECK CONSTRAINT [FK_ClassInstanceAssociation_EquipmentProoceduralElement]
GO
ALTER TABLE [dbo].[ClassInstanceAssociation]  WITH CHECK ADD  CONSTRAINT [FK_ClassInstanceAssociation_EquipmentProoceduralElementClass] FOREIGN KEY([ClassEquipmentID])
REFERENCES [dbo].[EquipmentProoceduralElementClass] ([ID])
GO
ALTER TABLE [dbo].[ClassInstanceAssociation] CHECK CONSTRAINT [FK_ClassInstanceAssociation_EquipmentProoceduralElementClass]
GO
ALTER TABLE [dbo].[Comment]  WITH CHECK ADD  CONSTRAINT [FK_Comment_BatchProductionRecordEntry] FOREIGN KEY([BatchProductionRecordEntry])
REFERENCES [dbo].[BatchProductionRecordEntry] ([EntryID])
GO
ALTER TABLE [dbo].[Comment] CHECK CONSTRAINT [FK_Comment_BatchProductionRecordEntry]
GO
ALTER TABLE [dbo].[Comment]  WITH CHECK ADD  CONSTRAINT [FK_Comment_Person] FOREIGN KEY([PersonID])
REFERENCES [dbo].[Person] ([ID])
GO
ALTER TABLE [dbo].[Comment] CHECK CONSTRAINT [FK_Comment_Person]
GO
ALTER TABLE [dbo].[Constraint]  WITH CHECK ADD  CONSTRAINT [FK_Constraint_EquipmentRequirement] FOREIGN KEY([EquipmentRequirement])
REFERENCES [dbo].[BatchEquipmentRequirement] ([ID])
GO
ALTER TABLE [dbo].[Constraint] CHECK CONSTRAINT [FK_Constraint_EquipmentRequirement]
GO
ALTER TABLE [dbo].[ConsumableActual]  WITH CHECK ADD  CONSTRAINT [FK_ConsumableActual_MaterialClass] FOREIGN KEY([MaterialClassID])
REFERENCES [dbo].[MaterialClass] ([ID])
GO
ALTER TABLE [dbo].[ConsumableActual] CHECK CONSTRAINT [FK_ConsumableActual_MaterialClass]
GO
ALTER TABLE [dbo].[ConsumableActual]  WITH CHECK ADD  CONSTRAINT [FK_ConsumableActual_MaterialDefinition] FOREIGN KEY([MaterialDefinitionID])
REFERENCES [dbo].[MaterialDefinition] ([ID])
GO
ALTER TABLE [dbo].[ConsumableActual] CHECK CONSTRAINT [FK_ConsumableActual_MaterialDefinition]
GO
ALTER TABLE [dbo].[ConsumableActual]  WITH CHECK ADD  CONSTRAINT [FK_ConsumableActual_SegmentResponse] FOREIGN KEY([SegmentResponseID])
REFERENCES [dbo].[SegmentResponse] ([ID])
GO
ALTER TABLE [dbo].[ConsumableActual] CHECK CONSTRAINT [FK_ConsumableActual_SegmentResponse]
GO
ALTER TABLE [dbo].[ConsumableActualProperty]  WITH CHECK ADD  CONSTRAINT [FK_ConsumableActualProperty_ConsumableActual] FOREIGN KEY([ConsumableActual])
REFERENCES [dbo].[ConsumableActual] ([ID])
GO
ALTER TABLE [dbo].[ConsumableActualProperty] CHECK CONSTRAINT [FK_ConsumableActualProperty_ConsumableActual]
GO
ALTER TABLE [dbo].[ConsumableExpectedRequirement]  WITH CHECK ADD  CONSTRAINT [FK_ConsumableExpectedRequirement_MaterialClass] FOREIGN KEY([MaterialClassID])
REFERENCES [dbo].[MaterialClass] ([ID])
GO
ALTER TABLE [dbo].[ConsumableExpectedRequirement] CHECK CONSTRAINT [FK_ConsumableExpectedRequirement_MaterialClass]
GO
ALTER TABLE [dbo].[ConsumableExpectedRequirement]  WITH CHECK ADD  CONSTRAINT [FK_ConsumableExpectedRequirement_MaterialDefinition] FOREIGN KEY([MaterialDefinitionID])
REFERENCES [dbo].[MaterialDefinition] ([ID])
GO
ALTER TABLE [dbo].[ConsumableExpectedRequirement] CHECK CONSTRAINT [FK_ConsumableExpectedRequirement_MaterialDefinition]
GO
ALTER TABLE [dbo].[ConsumableExpectedRequirement]  WITH CHECK ADD  CONSTRAINT [FK_ConsumableExpectedRequirement_SegmentRequirement] FOREIGN KEY([SegmentRequirementID])
REFERENCES [dbo].[SegmentRequirement] ([ID])
GO
ALTER TABLE [dbo].[ConsumableExpectedRequirement] CHECK CONSTRAINT [FK_ConsumableExpectedRequirement_SegmentRequirement]
GO
ALTER TABLE [dbo].[ConsumableExpectedRequirementProperty]  WITH CHECK ADD  CONSTRAINT [FK_ConsumableExpectedRequirementProperty_ConsumableExpectedRequirement] FOREIGN KEY([ConsumableExpectedRequirement])
REFERENCES [dbo].[ConsumableExpectedRequirement] ([ID])
GO
ALTER TABLE [dbo].[ConsumableExpectedRequirementProperty] CHECK CONSTRAINT [FK_ConsumableExpectedRequirementProperty_ConsumableExpectedRequirement]
GO
ALTER TABLE [dbo].[ControlRecipe]  WITH CHECK ADD  CONSTRAINT [FK_ControlRecipe_BatchInformation] FOREIGN KEY([BatchInformation])
REFERENCES [dbo].[BatchInformation] ([ID])
GO
ALTER TABLE [dbo].[ControlRecipe] CHECK CONSTRAINT [FK_ControlRecipe_BatchInformation]
GO
ALTER TABLE [dbo].[ControlRecipe]  WITH CHECK ADD  CONSTRAINT [FK_ControlRecipe_Formula] FOREIGN KEY([Formula])
REFERENCES [dbo].[Formula] ([ID])
GO
ALTER TABLE [dbo].[ControlRecipe] CHECK CONSTRAINT [FK_ControlRecipe_Formula]
GO
ALTER TABLE [dbo].[ControlRecipe]  WITH CHECK ADD  CONSTRAINT [FK_ControlRecipe_Header] FOREIGN KEY([Header])
REFERENCES [dbo].[Header] ([ID])
GO
ALTER TABLE [dbo].[ControlRecipe] CHECK CONSTRAINT [FK_ControlRecipe_Header]
GO
ALTER TABLE [dbo].[ControlRecipe]  WITH CHECK ADD  CONSTRAINT [FK_ControlRecipe_ProcedureLogic] FOREIGN KEY([ProcedureLogic])
REFERENCES [dbo].[ProcedureLogic] ([ID])
GO
ALTER TABLE [dbo].[ControlRecipe] CHECK CONSTRAINT [FK_ControlRecipe_ProcedureLogic]
GO
ALTER TABLE [dbo].[ControlRecipeRecord]  WITH CHECK ADD  CONSTRAINT [FK_ControlRecipeRecord_BatchProductionRecordEntry] FOREIGN KEY([BatchProductionRecordEntry])
REFERENCES [dbo].[BatchProductionRecordEntry] ([EntryID])
GO
ALTER TABLE [dbo].[ControlRecipeRecord] CHECK CONSTRAINT [FK_ControlRecipeRecord_BatchProductionRecordEntry]
GO
ALTER TABLE [dbo].[ControlRecipeRecord]  WITH CHECK ADD  CONSTRAINT [FK_ControlRecipeRecord_ControlRecipe] FOREIGN KEY([ControlRecipe])
REFERENCES [dbo].[ControlRecipe] ([ID])
GO
ALTER TABLE [dbo].[ControlRecipeRecord] CHECK CONSTRAINT [FK_ControlRecipeRecord_ControlRecipe]
GO
ALTER TABLE [dbo].[DataSet]  WITH CHECK ADD  CONSTRAINT [FK_DataSet_BatchProductionRecordEntry] FOREIGN KEY([BatchProductionRecordEntry])
REFERENCES [dbo].[BatchProductionRecordEntry] ([EntryID])
GO
ALTER TABLE [dbo].[DataSet] CHECK CONSTRAINT [FK_DataSet_BatchProductionRecordEntry]
GO
ALTER TABLE [dbo].[DataSet]  WITH CHECK ADD  CONSTRAINT [FK_DataSet_DelimitedDataBlock] FOREIGN KEY([DelimitedDataBlock])
REFERENCES [dbo].[DelimitedDataBlock] ([ID])
GO
ALTER TABLE [dbo].[DataSet] CHECK CONSTRAINT [FK_DataSet_DelimitedDataBlock]
GO
ALTER TABLE [dbo].[DataSet]  WITH CHECK ADD  CONSTRAINT [FK_DataSet_TimeSpecification] FOREIGN KEY([TimeSpecification])
REFERENCES [dbo].[TimeSpecification] ([ID])
GO
ALTER TABLE [dbo].[DataSet] CHECK CONSTRAINT [FK_DataSet_TimeSpecification]
GO
ALTER TABLE [dbo].[DataValue]  WITH CHECK ADD  CONSTRAINT [FK_DataValue_OrderedData] FOREIGN KEY([OrderedData])
REFERENCES [dbo].[OrderedData] ([ID])
GO
ALTER TABLE [dbo].[DataValue] CHECK CONSTRAINT [FK_DataValue_OrderedData]
GO
ALTER TABLE [dbo].[DirectedLink]  WITH CHECK ADD  CONSTRAINT [FK_DirectedLink_FromID] FOREIGN KEY([FromID])
REFERENCES [dbo].[FromID] ([ID])
GO
ALTER TABLE [dbo].[DirectedLink] CHECK CONSTRAINT [FK_DirectedLink_FromID]
GO
ALTER TABLE [dbo].[DirectedLink]  WITH CHECK ADD  CONSTRAINT [FK_DirectedLink_ProcessElement] FOREIGN KEY([ProcessElement])
REFERENCES [dbo].[ProcessElement] ([ID])
GO
ALTER TABLE [dbo].[DirectedLink] CHECK CONSTRAINT [FK_DirectedLink_ProcessElement]
GO
ALTER TABLE [dbo].[DirectedLink]  WITH CHECK ADD  CONSTRAINT [FK_DirectedLink_ToID] FOREIGN KEY([ToID])
REFERENCES [dbo].[ToID] ([ID])
GO
ALTER TABLE [dbo].[DirectedLink] CHECK CONSTRAINT [FK_DirectedLink_ToID]
GO
ALTER TABLE [dbo].[Enumeration]  WITH CHECK ADD  CONSTRAINT [FK_Enumeration_EnumerationSet] FOREIGN KEY([EnumerationSetID])
REFERENCES [dbo].[EnumerationSet] ([ID])
GO
ALTER TABLE [dbo].[Enumeration] CHECK CONSTRAINT [FK_Enumeration_EnumerationSet]
GO
ALTER TABLE [dbo].[EnumerationSet]  WITH CHECK ADD  CONSTRAINT [FK_EnumerationSet_BatchInformation] FOREIGN KEY([BatchInformation])
REFERENCES [dbo].[BatchInformation] ([ID])
GO
ALTER TABLE [dbo].[EnumerationSet] CHECK CONSTRAINT [FK_EnumerationSet_BatchInformation]
GO
ALTER TABLE [dbo].[EnumerationSet]  WITH CHECK ADD  CONSTRAINT [FK_EnumerationSet_BatchValue] FOREIGN KEY([BatchValue])
REFERENCES [dbo].[BatchValue] ([ValueString])
GO
ALTER TABLE [dbo].[EnumerationSet] CHECK CONSTRAINT [FK_EnumerationSet_BatchValue]
GO
ALTER TABLE [dbo].[Equipment]  WITH CHECK ADD  CONSTRAINT [FK_Equipment_Equipment1] FOREIGN KEY([Equipment])
REFERENCES [dbo].[Equipment] ([ID])
GO
ALTER TABLE [dbo].[Equipment] CHECK CONSTRAINT [FK_Equipment_Equipment1]
GO
ALTER TABLE [dbo].[Equipment]  WITH CHECK ADD  CONSTRAINT [FK_Equipment_EquipmentClass] FOREIGN KEY([EquipmentClassID])
REFERENCES [dbo].[EquipmentClass] ([ID])
GO
ALTER TABLE [dbo].[Equipment] CHECK CONSTRAINT [FK_Equipment_EquipmentClass]
GO
ALTER TABLE [dbo].[EquipmentActual]  WITH CHECK ADD  CONSTRAINT [FK_EquipmentActual_Equipment] FOREIGN KEY([EquipmentID])
REFERENCES [dbo].[Equipment] ([ID])
GO
ALTER TABLE [dbo].[EquipmentActual] CHECK CONSTRAINT [FK_EquipmentActual_Equipment]
GO
ALTER TABLE [dbo].[EquipmentActual]  WITH CHECK ADD  CONSTRAINT [FK_EquipmentActual_EquipmentClass] FOREIGN KEY([EquipmentClassID])
REFERENCES [dbo].[EquipmentClass] ([ID])
GO
ALTER TABLE [dbo].[EquipmentActual] CHECK CONSTRAINT [FK_EquipmentActual_EquipmentClass]
GO
ALTER TABLE [dbo].[EquipmentActual]  WITH CHECK ADD  CONSTRAINT [FK_EquipmentActual_SegmentResponse] FOREIGN KEY([SegmentResponseID])
REFERENCES [dbo].[SegmentResponse] ([ID])
GO
ALTER TABLE [dbo].[EquipmentActual] CHECK CONSTRAINT [FK_EquipmentActual_SegmentResponse]
GO
ALTER TABLE [dbo].[EquipmentActualProperty]  WITH CHECK ADD  CONSTRAINT [FK_EquipmentActualProperty_EquipmentActual] FOREIGN KEY([EquipmentActual])
REFERENCES [dbo].[EquipmentActual] ([ID])
GO
ALTER TABLE [dbo].[EquipmentActualProperty] CHECK CONSTRAINT [FK_EquipmentActualProperty_EquipmentActual]
GO
ALTER TABLE [dbo].[EquipmentActualProperty]  WITH CHECK ADD  CONSTRAINT [FK_EquipmentActualProperty_OpEquipmentActual] FOREIGN KEY([OpEquipmentActual])
REFERENCES [dbo].[OpEquipmentActual] ([ID])
GO
ALTER TABLE [dbo].[EquipmentActualProperty] CHECK CONSTRAINT [FK_EquipmentActualProperty_OpEquipmentActual]
GO
ALTER TABLE [dbo].[EquipmentAssetMapping]  WITH CHECK ADD  CONSTRAINT [FK_EquipmentAssetMapping_Equipment] FOREIGN KEY([EquipmentID])
REFERENCES [dbo].[Equipment] ([ID])
GO
ALTER TABLE [dbo].[EquipmentAssetMapping] CHECK CONSTRAINT [FK_EquipmentAssetMapping_Equipment]
GO
ALTER TABLE [dbo].[EquipmentAssetMapping]  WITH CHECK ADD  CONSTRAINT [FK_EquipmentAssetMapping_PhysicalAsset] FOREIGN KEY([PhysicalAssetID])
REFERENCES [dbo].[PhysicalAsset] ([ID])
GO
ALTER TABLE [dbo].[EquipmentAssetMapping] CHECK CONSTRAINT [FK_EquipmentAssetMapping_PhysicalAsset]
GO
ALTER TABLE [dbo].[EquipmentCapability]  WITH CHECK ADD  CONSTRAINT [FK_EquipmentCapability_Equipment] FOREIGN KEY([EquipmentID])
REFERENCES [dbo].[Equipment] ([ID])
GO
ALTER TABLE [dbo].[EquipmentCapability] CHECK CONSTRAINT [FK_EquipmentCapability_Equipment]
GO
ALTER TABLE [dbo].[EquipmentCapability]  WITH CHECK ADD  CONSTRAINT [FK_EquipmentCapability_EquipmentClass] FOREIGN KEY([EquipmentClassID])
REFERENCES [dbo].[EquipmentClass] ([ID])
GO
ALTER TABLE [dbo].[EquipmentCapability] CHECK CONSTRAINT [FK_EquipmentCapability_EquipmentClass]
GO
ALTER TABLE [dbo].[EquipmentCapability]  WITH CHECK ADD  CONSTRAINT [FK_EquipmentCapability_ProcessSegmentCapability] FOREIGN KEY([ProcessSegmentCapabilityID])
REFERENCES [dbo].[ProcessSegmentCapability] ([ID])
GO
ALTER TABLE [dbo].[EquipmentCapability] CHECK CONSTRAINT [FK_EquipmentCapability_ProcessSegmentCapability]
GO
ALTER TABLE [dbo].[EquipmentCapability]  WITH CHECK ADD  CONSTRAINT [FK_EquipmentCapability_ProductionCapability] FOREIGN KEY([ProductionCapabilityID])
REFERENCES [dbo].[ProductionCapability] ([ID])
GO
ALTER TABLE [dbo].[EquipmentCapability] CHECK CONSTRAINT [FK_EquipmentCapability_ProductionCapability]
GO
ALTER TABLE [dbo].[EquipmentCapabilityProperty]  WITH CHECK ADD  CONSTRAINT [FK_EquipmentCapabilityProperty_EquipmentCapability] FOREIGN KEY([EquipmentCapability])
REFERENCES [dbo].[EquipmentCapability] ([ID])
GO
ALTER TABLE [dbo].[EquipmentCapabilityProperty] CHECK CONSTRAINT [FK_EquipmentCapabilityProperty_EquipmentCapability]
GO
ALTER TABLE [dbo].[EquipmentCapabilityProperty]  WITH CHECK ADD  CONSTRAINT [FK_EquipmentCapabilityProperty_OpEquipmentCapability] FOREIGN KEY([OpEquipmentCapability])
REFERENCES [dbo].[OpEquipmentCapability] ([ID])
GO
ALTER TABLE [dbo].[EquipmentCapabilityProperty] CHECK CONSTRAINT [FK_EquipmentCapabilityProperty_OpEquipmentCapability]
GO
ALTER TABLE [dbo].[EquipmentClass]  WITH CHECK ADD  CONSTRAINT [FK_EquipmentClassID_EquipmentClassParentID] FOREIGN KEY([ParentID])
REFERENCES [dbo].[EquipmentClass] ([ID])
GO
ALTER TABLE [dbo].[EquipmentClass] CHECK CONSTRAINT [FK_EquipmentClassID_EquipmentClassParentID]
GO
ALTER TABLE [dbo].[EquipmentClassProperty]  WITH CHECK ADD  CONSTRAINT [FK_EquipmentClassProperty_EquipmentCapabilityTestSpecification] FOREIGN KEY([EquipmentCapabilityTestSpecification])
REFERENCES [dbo].[EquipmentCapabilityTestSpecification] ([Name])
GO
ALTER TABLE [dbo].[EquipmentClassProperty] CHECK CONSTRAINT [FK_EquipmentClassProperty_EquipmentCapabilityTestSpecification]
GO
ALTER TABLE [dbo].[EquipmentClassProperty]  WITH CHECK ADD  CONSTRAINT [FK_EquipmentClassProperty_EquipmentClass] FOREIGN KEY([EquipmentClassID])
REFERENCES [dbo].[EquipmentClass] ([ID])
GO
ALTER TABLE [dbo].[EquipmentClassProperty] CHECK CONSTRAINT [FK_EquipmentClassProperty_EquipmentClass]
GO
ALTER TABLE [dbo].[EquipmentClassProperty]  WITH CHECK ADD  CONSTRAINT [FK_EquipmentClassProperty_EquipmentClassProperty1] FOREIGN KEY([EquipmentClassProperty])
REFERENCES [dbo].[EquipmentClassProperty] ([ID])
GO
ALTER TABLE [dbo].[EquipmentClassProperty] CHECK CONSTRAINT [FK_EquipmentClassProperty_EquipmentClassProperty1]
GO
ALTER TABLE [dbo].[EquipmentConnection]  WITH CHECK ADD  CONSTRAINT [FK_EquipmentConnection_EquipmentElement] FOREIGN KEY([EquipmentElement])
REFERENCES [dbo].[EquipmentElement] ([ID])
GO
ALTER TABLE [dbo].[EquipmentConnection] CHECK CONSTRAINT [FK_EquipmentConnection_EquipmentElement]
GO
ALTER TABLE [dbo].[EquipmentElement]  WITH CHECK ADD  CONSTRAINT [FK_EquipmentElement_BatchInformation] FOREIGN KEY([BatchInformation])
REFERENCES [dbo].[BatchInformation] ([ID])
GO
ALTER TABLE [dbo].[EquipmentElement] CHECK CONSTRAINT [FK_EquipmentElement_BatchInformation]
GO
ALTER TABLE [dbo].[EquipmentElement]  WITH CHECK ADD  CONSTRAINT [FK_EquipmentElement_Equipment] FOREIGN KEY([EquipmentElementID])
REFERENCES [dbo].[Equipment] ([ID])
GO
ALTER TABLE [dbo].[EquipmentElement] CHECK CONSTRAINT [FK_EquipmentElement_Equipment]
GO
ALTER TABLE [dbo].[EquipmentElement]  WITH CHECK ADD  CONSTRAINT [FK_EquipmentElement_EquipmentElement] FOREIGN KEY([EquipmentElement])
REFERENCES [dbo].[EquipmentElement] ([ID])
GO
ALTER TABLE [dbo].[EquipmentElement] CHECK CONSTRAINT [FK_EquipmentElement_EquipmentElement]
GO
ALTER TABLE [dbo].[EquipmentElementProperty]  WITH CHECK ADD  CONSTRAINT [FK_EquipmentElementProperty_EquipmentElement] FOREIGN KEY([EquipmentElement])
REFERENCES [dbo].[EquipmentElement] ([ID])
GO
ALTER TABLE [dbo].[EquipmentElementProperty] CHECK CONSTRAINT [FK_EquipmentElementProperty_EquipmentElement]
GO
ALTER TABLE [dbo].[EquipmentElementProperty]  WITH CHECK ADD  CONSTRAINT [FK_EquipmentElementProperty_EquipmentElementProperty] FOREIGN KEY([Property])
REFERENCES [dbo].[EquipmentElementProperty] ([ID])
GO
ALTER TABLE [dbo].[EquipmentElementProperty] CHECK CONSTRAINT [FK_EquipmentElementProperty_EquipmentElementProperty]
GO
ALTER TABLE [dbo].[EquipmentElementProperty]  WITH CHECK ADD  CONSTRAINT [FK_EquipmentElementProperty_Value] FOREIGN KEY([Value])
REFERENCES [dbo].[Value] ([ValueString])
GO
ALTER TABLE [dbo].[EquipmentElementProperty] CHECK CONSTRAINT [FK_EquipmentElementProperty_Value]
GO
ALTER TABLE [dbo].[EquipmentInformation]  WITH CHECK ADD  CONSTRAINT [FK_EquipmentInformation_Equipment] FOREIGN KEY([Equipment])
REFERENCES [dbo].[Equipment] ([ID])
GO
ALTER TABLE [dbo].[EquipmentInformation] CHECK CONSTRAINT [FK_EquipmentInformation_Equipment]
GO
ALTER TABLE [dbo].[EquipmentInformation]  WITH CHECK ADD  CONSTRAINT [FK_EquipmentInformation_EquipmentClass] FOREIGN KEY([EquipmentClassID])
REFERENCES [dbo].[EquipmentClass] ([ID])
GO
ALTER TABLE [dbo].[EquipmentInformation] CHECK CONSTRAINT [FK_EquipmentInformation_EquipmentClass]
GO
ALTER TABLE [dbo].[EquipmentProoceduralElement]  WITH CHECK ADD  CONSTRAINT [FK_EquipmentProoceduralElement_EquipmentElement] FOREIGN KEY([EquipmentElement])
REFERENCES [dbo].[EquipmentElement] ([ID])
GO
ALTER TABLE [dbo].[EquipmentProoceduralElement] CHECK CONSTRAINT [FK_EquipmentProoceduralElement_EquipmentElement]
GO
ALTER TABLE [dbo].[EquipmentProoceduralElement]  WITH CHECK ADD  CONSTRAINT [FK_EquipmentProoceduralElement_EquipmentProoceduralElement] FOREIGN KEY([EquipmentProceduralElementType])
REFERENCES [dbo].[EquipmentProoceduralElement] ([ID])
GO
ALTER TABLE [dbo].[EquipmentProoceduralElement] CHECK CONSTRAINT [FK_EquipmentProoceduralElement_EquipmentProoceduralElement]
GO
ALTER TABLE [dbo].[EquipmentProoceduralElement]  WITH CHECK ADD  CONSTRAINT [FK_EquipmentProoceduralElement_EquipmentProoceduralElementClass] FOREIGN KEY([EquipmentProoceduralElementClass])
REFERENCES [dbo].[EquipmentProoceduralElementClass] ([ID])
GO
ALTER TABLE [dbo].[EquipmentProoceduralElement] CHECK CONSTRAINT [FK_EquipmentProoceduralElement_EquipmentProoceduralElementClass]
GO
ALTER TABLE [dbo].[EquipmentProoceduralElementClass]  WITH CHECK ADD  CONSTRAINT [FK_EquipmentProoceduralElementClass_EquipmentElement] FOREIGN KEY([EquipmentElement])
REFERENCES [dbo].[EquipmentElement] ([ID])
GO
ALTER TABLE [dbo].[EquipmentProoceduralElementClass] CHECK CONSTRAINT [FK_EquipmentProoceduralElementClass_EquipmentElement]
GO
ALTER TABLE [dbo].[EquipmentProperty]  WITH CHECK ADD  CONSTRAINT [FK_EquipmentProperty_Equipment] FOREIGN KEY([EquipmentID])
REFERENCES [dbo].[Equipment] ([ID])
GO
ALTER TABLE [dbo].[EquipmentProperty] CHECK CONSTRAINT [FK_EquipmentProperty_Equipment]
GO
ALTER TABLE [dbo].[EquipmentProperty]  WITH CHECK ADD  CONSTRAINT [FK_EquipmentProperty_EquipmentCapabilityTestSpecification] FOREIGN KEY([EquipmentCapabilityTestSpecification])
REFERENCES [dbo].[EquipmentCapabilityTestSpecification] ([Name])
GO
ALTER TABLE [dbo].[EquipmentProperty] CHECK CONSTRAINT [FK_EquipmentProperty_EquipmentCapabilityTestSpecification]
GO
ALTER TABLE [dbo].[EquipmentProperty]  WITH CHECK ADD  CONSTRAINT [FK_EquipmentProperty_EquipmentClassProperty] FOREIGN KEY([ClassPropertyID])
REFERENCES [dbo].[EquipmentClassProperty] ([ID])
GO
ALTER TABLE [dbo].[EquipmentProperty] CHECK CONSTRAINT [FK_EquipmentProperty_EquipmentClassProperty]
GO
ALTER TABLE [dbo].[EquipmentProperty]  WITH CHECK ADD  CONSTRAINT [FK_EquipmentProperty_EquipmentProperty] FOREIGN KEY([EquipmentProperty])
REFERENCES [dbo].[EquipmentProperty] ([ID])
GO
ALTER TABLE [dbo].[EquipmentProperty] CHECK CONSTRAINT [FK_EquipmentProperty_EquipmentProperty]
GO
ALTER TABLE [dbo].[EquipmentRequirement]  WITH CHECK ADD  CONSTRAINT [FK_EquipmentRequirement_Equipment] FOREIGN KEY([EquipmentID])
REFERENCES [dbo].[Equipment] ([ID])
GO
ALTER TABLE [dbo].[EquipmentRequirement] CHECK CONSTRAINT [FK_EquipmentRequirement_Equipment]
GO
ALTER TABLE [dbo].[EquipmentRequirement]  WITH CHECK ADD  CONSTRAINT [FK_EquipmentRequirement_EquipmentClass] FOREIGN KEY([EquipmentClassID])
REFERENCES [dbo].[EquipmentClass] ([ID])
GO
ALTER TABLE [dbo].[EquipmentRequirement] CHECK CONSTRAINT [FK_EquipmentRequirement_EquipmentClass]
GO
ALTER TABLE [dbo].[EquipmentRequirement]  WITH CHECK ADD  CONSTRAINT [FK_EquipmentRequirement_SegmentRequirement] FOREIGN KEY([SegmentRequirementID])
REFERENCES [dbo].[SegmentRequirement] ([ID])
GO
ALTER TABLE [dbo].[EquipmentRequirement] CHECK CONSTRAINT [FK_EquipmentRequirement_SegmentRequirement]
GO
ALTER TABLE [dbo].[EquipmentRequirementProperty]  WITH CHECK ADD  CONSTRAINT [FK_EquipmentRequirementProperty_EquipmentRequirement] FOREIGN KEY([EquipmentRequirement])
REFERENCES [dbo].[EquipmentRequirement] ([ID])
GO
ALTER TABLE [dbo].[EquipmentRequirementProperty] CHECK CONSTRAINT [FK_EquipmentRequirementProperty_EquipmentRequirement]
GO
ALTER TABLE [dbo].[EquipmentRequirementProperty]  WITH CHECK ADD  CONSTRAINT [FK_EquipmentRequirementProperty_OpEquipmentRequirement] FOREIGN KEY([OpEquipmentRequirement])
REFERENCES [dbo].[OpEquipmentRequirement] ([ID])
GO
ALTER TABLE [dbo].[EquipmentRequirementProperty] CHECK CONSTRAINT [FK_EquipmentRequirementProperty_OpEquipmentRequirement]
GO
ALTER TABLE [dbo].[EquipmentSegmentSpecification]  WITH CHECK ADD  CONSTRAINT [FK_EquipmentSegmentSpecification_Equipment] FOREIGN KEY([EquipmentID])
REFERENCES [dbo].[Equipment] ([ID])
GO
ALTER TABLE [dbo].[EquipmentSegmentSpecification] CHECK CONSTRAINT [FK_EquipmentSegmentSpecification_Equipment]
GO
ALTER TABLE [dbo].[EquipmentSegmentSpecification]  WITH CHECK ADD  CONSTRAINT [FK_EquipmentSegmentSpecification_EquipmentClass] FOREIGN KEY([EquipmentClassID])
REFERENCES [dbo].[EquipmentClass] ([ID])
GO
ALTER TABLE [dbo].[EquipmentSegmentSpecification] CHECK CONSTRAINT [FK_EquipmentSegmentSpecification_EquipmentClass]
GO
ALTER TABLE [dbo].[EquipmentSegmentSpecification]  WITH CHECK ADD  CONSTRAINT [FK_EquipmentSegmentSpecification_ProcessSegment] FOREIGN KEY([ProcessSegmentID])
REFERENCES [dbo].[ProcessSegment] ([ID])
GO
ALTER TABLE [dbo].[EquipmentSegmentSpecification] CHECK CONSTRAINT [FK_EquipmentSegmentSpecification_ProcessSegment]
GO
ALTER TABLE [dbo].[EquipmentSegmentSpecificationProperty]  WITH CHECK ADD  CONSTRAINT [FK_EquipmentSegmentSpecificationProperty_EquipmentSegmentSpecification] FOREIGN KEY([EquipmentSegmentSpecification])
REFERENCES [dbo].[EquipmentSegmentSpecification] ([ID])
GO
ALTER TABLE [dbo].[EquipmentSegmentSpecificationProperty] CHECK CONSTRAINT [FK_EquipmentSegmentSpecificationProperty_EquipmentSegmentSpecification]
GO
ALTER TABLE [dbo].[EquipmentSpecification]  WITH CHECK ADD  CONSTRAINT [FK_EquipmentSpecification_Equipment] FOREIGN KEY([EquipmentID])
REFERENCES [dbo].[Equipment] ([ID])
GO
ALTER TABLE [dbo].[EquipmentSpecification] CHECK CONSTRAINT [FK_EquipmentSpecification_Equipment]
GO
ALTER TABLE [dbo].[EquipmentSpecification]  WITH CHECK ADD  CONSTRAINT [FK_EquipmentSpecification_EquipmentClass] FOREIGN KEY([EquipmentClassID])
REFERENCES [dbo].[EquipmentClass] ([ID])
GO
ALTER TABLE [dbo].[EquipmentSpecification] CHECK CONSTRAINT [FK_EquipmentSpecification_EquipmentClass]
GO
ALTER TABLE [dbo].[EquipmentSpecification]  WITH CHECK ADD  CONSTRAINT [FK_EquipmentSpecification_ProductSegment] FOREIGN KEY([ProductSegmentID])
REFERENCES [dbo].[ProductSegment] ([ID])
GO
ALTER TABLE [dbo].[EquipmentSpecification] CHECK CONSTRAINT [FK_EquipmentSpecification_ProductSegment]
GO
ALTER TABLE [dbo].[EquipmentSpecificationProperty]  WITH CHECK ADD  CONSTRAINT [FK_EquipmentSpecificationProperty_EquipmentSpecification] FOREIGN KEY([EquipmentSpecification])
REFERENCES [dbo].[EquipmentSpecification] ([ID])
GO
ALTER TABLE [dbo].[EquipmentSpecificationProperty] CHECK CONSTRAINT [FK_EquipmentSpecificationProperty_EquipmentSpecification]
GO
ALTER TABLE [dbo].[EquipmentSpecificationProperty]  WITH CHECK ADD  CONSTRAINT [FK_EquipmentSpecificationProperty_OpEquipmentSpecification] FOREIGN KEY([OpEquipmentSpecification])
REFERENCES [dbo].[OpEquipmentSpecification] ([ID])
GO
ALTER TABLE [dbo].[EquipmentSpecificationProperty] CHECK CONSTRAINT [FK_EquipmentSpecificationProperty_OpEquipmentSpecification]
GO
ALTER TABLE [dbo].[Event]  WITH CHECK ADD  CONSTRAINT [FK_Event_BatchProductionRecordEntry] FOREIGN KEY([BatchProductionRecordEntry])
REFERENCES [dbo].[BatchProductionRecordEntry] ([EntryID])
GO
ALTER TABLE [dbo].[Event] CHECK CONSTRAINT [FK_Event_BatchProductionRecordEntry]
GO
ALTER TABLE [dbo].[Event]  WITH CHECK ADD  CONSTRAINT [FK_Event_Equipment] FOREIGN KEY([EquipmentID])
REFERENCES [dbo].[Equipment] ([ID])
GO
ALTER TABLE [dbo].[Event] CHECK CONSTRAINT [FK_Event_Equipment]
GO
ALTER TABLE [dbo].[Event]  WITH CHECK ADD  CONSTRAINT [FK_Event_Event] FOREIGN KEY([AssociatedEventID])
REFERENCES [dbo].[Event] ([ID])
GO
ALTER TABLE [dbo].[Event] CHECK CONSTRAINT [FK_Event_Event]
GO
ALTER TABLE [dbo].[Event]  WITH CHECK ADD  CONSTRAINT [FK_Event_Person] FOREIGN KEY([PersonID])
REFERENCES [dbo].[Person] ([ID])
GO
ALTER TABLE [dbo].[Event] CHECK CONSTRAINT [FK_Event_Person]
GO
ALTER TABLE [dbo].[Event]  WITH CHECK ADD  CONSTRAINT [FK_Event_PhysicalAsset] FOREIGN KEY([PhysicalAssetID])
REFERENCES [dbo].[PhysicalAsset] ([ID])
GO
ALTER TABLE [dbo].[Event] CHECK CONSTRAINT [FK_Event_PhysicalAsset]
GO
ALTER TABLE [dbo].[FromID]  WITH CHECK ADD  CONSTRAINT [FK_FromID_Link] FOREIGN KEY([Link])
REFERENCES [dbo].[Link] ([ID])
GO
ALTER TABLE [dbo].[FromID] CHECK CONSTRAINT [FK_FromID_Link]
GO
ALTER TABLE [dbo].[GRecipe]  WITH CHECK ADD  CONSTRAINT [FK_GRecipe_GRecipeFormula] FOREIGN KEY([Formula])
REFERENCES [dbo].[GRecipeFormula] ([ID])
GO
ALTER TABLE [dbo].[GRecipe] CHECK CONSTRAINT [FK_GRecipe_GRecipeFormula]
GO
ALTER TABLE [dbo].[GRecipe]  WITH CHECK ADD  CONSTRAINT [FK_GRecipe_GRecipeHeader] FOREIGN KEY([Header])
REFERENCES [dbo].[GRecipeHeader] ([ID])
GO
ALTER TABLE [dbo].[GRecipe] CHECK CONSTRAINT [FK_GRecipe_GRecipeHeader]
GO
ALTER TABLE [dbo].[GRecipe]  WITH CHECK ADD  CONSTRAINT [FK_GRecipe_GRecipeInformation] FOREIGN KEY([GRecipeInformation])
REFERENCES [dbo].[GRecipeInformation] ([ID])
GO
ALTER TABLE [dbo].[GRecipe] CHECK CONSTRAINT [FK_GRecipe_GRecipeInformation]
GO
ALTER TABLE [dbo].[GRecipeMaterial]  WITH CHECK ADD  CONSTRAINT [FK_GRecipeMaterial_GRecipeMaterials] FOREIGN KEY([GRecipeMaterials])
REFERENCES [dbo].[GRecipeMaterials] ([ID])
GO
ALTER TABLE [dbo].[GRecipeMaterial] CHECK CONSTRAINT [FK_GRecipeMaterial_GRecipeMaterials]
GO
ALTER TABLE [dbo].[GRecipeMaterial]  WITH CHECK ADD  CONSTRAINT [FK_GRecipeMaterial_MaterialDefinition] FOREIGN KEY([MaterialID])
REFERENCES [dbo].[MaterialDefinition] ([ID])
GO
ALTER TABLE [dbo].[GRecipeMaterial] CHECK CONSTRAINT [FK_GRecipeMaterial_MaterialDefinition]
GO
ALTER TABLE [dbo].[GRecipeProductInformation]  WITH CHECK ADD  CONSTRAINT [FK_GRecipeProductInformation_BatchSize] FOREIGN KEY([BatchSize])
REFERENCES [dbo].[BatchSize] ([Nominal])
GO
ALTER TABLE [dbo].[GRecipeProductInformation] CHECK CONSTRAINT [FK_GRecipeProductInformation_BatchSize]
GO
ALTER TABLE [dbo].[GRecipeProductInformation]  WITH CHECK ADD  CONSTRAINT [FK_GRecipeProductInformation_GRecipeHeader] FOREIGN KEY([GRecipeHeader])
REFERENCES [dbo].[GRecipeHeader] ([ID])
GO
ALTER TABLE [dbo].[GRecipeProductInformation] CHECK CONSTRAINT [FK_GRecipeProductInformation_GRecipeHeader]
GO
ALTER TABLE [dbo].[Header]  WITH CHECK ADD  CONSTRAINT [FK_Header_BatchSize] FOREIGN KEY([BatchSize])
REFERENCES [dbo].[BatchSize] ([Nominal])
GO
ALTER TABLE [dbo].[Header] CHECK CONSTRAINT [FK_Header_BatchSize]
GO
ALTER TABLE [dbo].[Header]  WITH CHECK ADD  CONSTRAINT [FK_Header_GRecipeProductInformation] FOREIGN KEY([ProductID])
REFERENCES [dbo].[GRecipeProductInformation] ([ProductID])
GO
ALTER TABLE [dbo].[Header] CHECK CONSTRAINT [FK_Header_GRecipeProductInformation]
GO
ALTER TABLE [dbo].[HeaderProperty]  WITH CHECK ADD  CONSTRAINT [FK_HeaderProperty_GRecipeHeader] FOREIGN KEY([HeaderID])
REFERENCES [dbo].[GRecipeHeader] ([ID])
GO
ALTER TABLE [dbo].[HeaderProperty] CHECK CONSTRAINT [FK_HeaderProperty_GRecipeHeader]
GO
ALTER TABLE [dbo].[HeaderProperty]  WITH CHECK ADD  CONSTRAINT [FK_HeaderProperty_Value] FOREIGN KEY([Value])
REFERENCES [dbo].[Value] ([ValueString])
GO
ALTER TABLE [dbo].[HeaderProperty] CHECK CONSTRAINT [FK_HeaderProperty_Value]
GO
ALTER TABLE [dbo].[HierarchyScope]  WITH CHECK ADD  CONSTRAINT [FK_HierarchyScopeHID_HierarchyScopeParentHID] FOREIGN KEY([ParentHID])
REFERENCES [dbo].[HierarchyScope] ([HID])
GO
ALTER TABLE [dbo].[HierarchyScope] CHECK CONSTRAINT [FK_HierarchyScopeHID_HierarchyScopeParentHID]
GO
ALTER TABLE [dbo].[Individualapproval]  WITH CHECK ADD  CONSTRAINT [FK_Individualapproval_ApprovalHistory] FOREIGN KEY([ApprovalHistory])
REFERENCES [dbo].[ApprovalHistory] ([ID])
GO
ALTER TABLE [dbo].[Individualapproval] CHECK CONSTRAINT [FK_Individualapproval_ApprovalHistory]
GO
ALTER TABLE [dbo].[JobOrder]  WITH CHECK ADD  CONSTRAINT [FK_JobOrder_JobList] FOREIGN KEY([JobList])
REFERENCES [dbo].[JobList] ([ID])
GO
ALTER TABLE [dbo].[JobOrder] CHECK CONSTRAINT [FK_JobOrder_JobList]
GO
ALTER TABLE [dbo].[JobOrder]  WITH CHECK ADD  CONSTRAINT [FK_JobOrder_WorkMaster] FOREIGN KEY([WorkMasterID])
REFERENCES [dbo].[WorkMaster] ([WorkMaster])
GO
ALTER TABLE [dbo].[JobOrder] CHECK CONSTRAINT [FK_JobOrder_WorkMaster]
GO
ALTER TABLE [dbo].[JobOrder]  WITH CHECK ADD  CONSTRAINT [FK_JobOrder_WorkRequest] FOREIGN KEY([WorkRequest])
REFERENCES [dbo].[WorkRequest] ([ID])
GO
ALTER TABLE [dbo].[JobOrder] CHECK CONSTRAINT [FK_JobOrder_WorkRequest]
GO
ALTER TABLE [dbo].[JobResponse]  WITH CHECK ADD  CONSTRAINT [FK_JobResponse_JobOrder] FOREIGN KEY([JobOrderID])
REFERENCES [dbo].[JobOrder] ([ID])
GO
ALTER TABLE [dbo].[JobResponse] CHECK CONSTRAINT [FK_JobResponse_JobOrder]
GO
ALTER TABLE [dbo].[JobResponse]  WITH CHECK ADD  CONSTRAINT [FK_JobResponse_JobResponse] FOREIGN KEY([JobResponse])
REFERENCES [dbo].[JobResponse] ([ID])
GO
ALTER TABLE [dbo].[JobResponse] CHECK CONSTRAINT [FK_JobResponse_JobResponse]
GO
ALTER TABLE [dbo].[JobResponse]  WITH CHECK ADD  CONSTRAINT [FK_JobResponse_WorkDirective] FOREIGN KEY([WorkDirectiveID])
REFERENCES [dbo].[WorkDirective] ([WorkDirective])
GO
ALTER TABLE [dbo].[JobResponse] CHECK CONSTRAINT [FK_JobResponse_WorkDirective]
GO
ALTER TABLE [dbo].[JobResponse]  WITH CHECK ADD  CONSTRAINT [FK_JobResponse_WorkResponse] FOREIGN KEY([WorkResponse])
REFERENCES [dbo].[WorkResponse] ([ID])
GO
ALTER TABLE [dbo].[JobResponse] CHECK CONSTRAINT [FK_JobResponse_WorkResponse]
GO
ALTER TABLE [dbo].[JobResponsetData]  WITH CHECK ADD  CONSTRAINT [FK_JobResponsetData_JobResponse] FOREIGN KEY([JobResponse])
REFERENCES [dbo].[JobResponse] ([ID])
GO
ALTER TABLE [dbo].[JobResponsetData] CHECK CONSTRAINT [FK_JobResponsetData_JobResponse]
GO
ALTER TABLE [dbo].[KPIDefinitionProperty]  WITH CHECK ADD  CONSTRAINT [FK_KPIDefinitionProperty_KPIDefinition] FOREIGN KEY([KPIDefinitionID])
REFERENCES [dbo].[KPIDefinition] ([ID])
GO
ALTER TABLE [dbo].[KPIDefinitionProperty] CHECK CONSTRAINT [FK_KPIDefinitionProperty_KPIDefinition]
GO
ALTER TABLE [dbo].[KPIDefinitionTimeRange]  WITH CHECK ADD  CONSTRAINT [FK_KPIDefinitionTimeRange_KPIDefinition] FOREIGN KEY([KPIDefinitionID])
REFERENCES [dbo].[KPIDefinition] ([ID])
GO
ALTER TABLE [dbo].[KPIDefinitionTimeRange] CHECK CONSTRAINT [FK_KPIDefinitionTimeRange_KPIDefinition]
GO
ALTER TABLE [dbo].[KPIInstance]  WITH CHECK ADD  CONSTRAINT [FK_KPIInstance_KPIDefinition] FOREIGN KEY([KPIDefinitionID])
REFERENCES [dbo].[KPIDefinition] ([ID])
GO
ALTER TABLE [dbo].[KPIInstance] CHECK CONSTRAINT [FK_KPIInstance_KPIDefinition]
GO
ALTER TABLE [dbo].[KPIInstanceProperty]  WITH CHECK ADD  CONSTRAINT [FK_KPIInstanceProperty_KPIInstance] FOREIGN KEY([KPIInstanceID])
REFERENCES [dbo].[KPIInstance] ([ID])
GO
ALTER TABLE [dbo].[KPIInstanceProperty] CHECK CONSTRAINT [FK_KPIInstanceProperty_KPIInstance]
GO
ALTER TABLE [dbo].[KPIInstanceRange]  WITH CHECK ADD  CONSTRAINT [FK_KPIInstanceRange_KPIInstanceRange] FOREIGN KEY([KPIInstanceID])
REFERENCES [dbo].[KPIInstance] ([ID])
GO
ALTER TABLE [dbo].[KPIInstanceRange] CHECK CONSTRAINT [FK_KPIInstanceRange_KPIInstanceRange]
GO
ALTER TABLE [dbo].[KPIInstanceResourceReference]  WITH CHECK ADD  CONSTRAINT [FK_KPIInstanceResourceReference_KPIInstance] FOREIGN KEY([KPIInstanceID])
REFERENCES [dbo].[KPIInstance] ([ID])
GO
ALTER TABLE [dbo].[KPIInstanceResourceReference] CHECK CONSTRAINT [FK_KPIInstanceResourceReference_KPIInstance]
GO
ALTER TABLE [dbo].[KPIInstanceTimeRange]  WITH CHECK ADD  CONSTRAINT [FK_KPIInstanceTimeRange_KPIInstance] FOREIGN KEY([KPIInstanceID])
REFERENCES [dbo].[KPIInstance] ([ID])
GO
ALTER TABLE [dbo].[KPIInstanceTimeRange] CHECK CONSTRAINT [FK_KPIInstanceTimeRange_KPIInstance]
GO
ALTER TABLE [dbo].[KPIValue]  WITH CHECK ADD  CONSTRAINT [FK_KPIValue_KPIInstance] FOREIGN KEY([KPIInstanceID])
REFERENCES [dbo].[KPIInstance] ([ID])
GO
ALTER TABLE [dbo].[KPIValue] CHECK CONSTRAINT [FK_KPIValue_KPIInstance]
GO
ALTER TABLE [dbo].[KPIValueProperty]  WITH CHECK ADD  CONSTRAINT [FK_KPIValueProperty_KPIValue] FOREIGN KEY([KPIValueID])
REFERENCES [dbo].[KPIValue] ([ID])
GO
ALTER TABLE [dbo].[KPIValueProperty] CHECK CONSTRAINT [FK_KPIValueProperty_KPIValue]
GO
ALTER TABLE [dbo].[KPIValueTimeRange]  WITH CHECK ADD  CONSTRAINT [FK_KPIValueTimeRange_KPIValue] FOREIGN KEY([KPIValueID])
REFERENCES [dbo].[KPIValue] ([ID])
GO
ALTER TABLE [dbo].[KPIValueTimeRange] CHECK CONSTRAINT [FK_KPIValueTimeRange_KPIValue]
GO
ALTER TABLE [dbo].[Link]  WITH CHECK ADD  CONSTRAINT [FK_Link_ProcedureLogic] FOREIGN KEY([ProcedureLogic])
REFERENCES [dbo].[ProcedureLogic] ([ID])
GO
ALTER TABLE [dbo].[Link] CHECK CONSTRAINT [FK_Link_ProcedureLogic]
GO
ALTER TABLE [dbo].[ListHeader]  WITH CHECK ADD  CONSTRAINT [FK_ListHeader_BatchInformation] FOREIGN KEY([BatchInformation])
REFERENCES [dbo].[BatchInformation] ([ID])
GO
ALTER TABLE [dbo].[ListHeader] CHECK CONSTRAINT [FK_ListHeader_BatchInformation]
GO
ALTER TABLE [dbo].[ListHeader]  WITH CHECK ADD  CONSTRAINT [FK_ListHeader_BatchList] FOREIGN KEY([BatchList])
REFERENCES [dbo].[BatchList] ([ID])
GO
ALTER TABLE [dbo].[ListHeader] CHECK CONSTRAINT [FK_ListHeader_BatchList]
GO
ALTER TABLE [dbo].[ManufacturingBill]  WITH CHECK ADD  CONSTRAINT [FK_ManufacturingBill_ManufacturingBill] FOREIGN KEY([AssemblyManufacturingBill])
REFERENCES [dbo].[ManufacturingBill] ([ID])
GO
ALTER TABLE [dbo].[ManufacturingBill] CHECK CONSTRAINT [FK_ManufacturingBill_ManufacturingBill]
GO
ALTER TABLE [dbo].[ManufacturingBill]  WITH CHECK ADD  CONSTRAINT [FK_ManufacturingBill_MaterialClass] FOREIGN KEY([MaterialClassID])
REFERENCES [dbo].[MaterialClass] ([ID])
GO
ALTER TABLE [dbo].[ManufacturingBill] CHECK CONSTRAINT [FK_ManufacturingBill_MaterialClass]
GO
ALTER TABLE [dbo].[ManufacturingBill]  WITH CHECK ADD  CONSTRAINT [FK_ManufacturingBill_MaterialDefinition] FOREIGN KEY([MaterialDefinitionID])
REFERENCES [dbo].[MaterialDefinition] ([ID])
GO
ALTER TABLE [dbo].[ManufacturingBill] CHECK CONSTRAINT [FK_ManufacturingBill_MaterialDefinition]
GO
ALTER TABLE [dbo].[ManufacturingBill]  WITH CHECK ADD  CONSTRAINT [FK_ManufacturingBill_ProductDefinition] FOREIGN KEY([ProductDefinition])
REFERENCES [dbo].[ProductDefinition] ([ID])
GO
ALTER TABLE [dbo].[ManufacturingBill] CHECK CONSTRAINT [FK_ManufacturingBill_ProductDefinition]
GO
ALTER TABLE [dbo].[MasterRecipe]  WITH CHECK ADD  CONSTRAINT [FK_MasterRecipe_BatchInformation] FOREIGN KEY([BatchInformation])
REFERENCES [dbo].[BatchInformation] ([ID])
GO
ALTER TABLE [dbo].[MasterRecipe] CHECK CONSTRAINT [FK_MasterRecipe_BatchInformation]
GO
ALTER TABLE [dbo].[MasterRecipe]  WITH CHECK ADD  CONSTRAINT [FK_MasterRecipe_Formula] FOREIGN KEY([Formula])
REFERENCES [dbo].[Formula] ([ID])
GO
ALTER TABLE [dbo].[MasterRecipe] CHECK CONSTRAINT [FK_MasterRecipe_Formula]
GO
ALTER TABLE [dbo].[MasterRecipe]  WITH CHECK ADD  CONSTRAINT [FK_MasterRecipe_Header] FOREIGN KEY([Header])
REFERENCES [dbo].[Header] ([ID])
GO
ALTER TABLE [dbo].[MasterRecipe] CHECK CONSTRAINT [FK_MasterRecipe_Header]
GO
ALTER TABLE [dbo].[MasterRecipe]  WITH CHECK ADD  CONSTRAINT [FK_MasterRecipe_ProcedureLogic] FOREIGN KEY([ProcedureLogic])
REFERENCES [dbo].[ProcedureLogic] ([ID])
GO
ALTER TABLE [dbo].[MasterRecipe] CHECK CONSTRAINT [FK_MasterRecipe_ProcedureLogic]
GO
ALTER TABLE [dbo].[MasterRecipeRecord]  WITH CHECK ADD  CONSTRAINT [FK_MasterRecipeRecord_BatchProductionRecordEntry] FOREIGN KEY([BatchProductionRecordEntry])
REFERENCES [dbo].[BatchProductionRecordEntry] ([EntryID])
GO
ALTER TABLE [dbo].[MasterRecipeRecord] CHECK CONSTRAINT [FK_MasterRecipeRecord_BatchProductionRecordEntry]
GO
ALTER TABLE [dbo].[MasterRecipeRecord]  WITH CHECK ADD  CONSTRAINT [FK_MasterRecipeRecord_MasterRecipe] FOREIGN KEY([MasterRecipe])
REFERENCES [dbo].[MasterRecipe] ([ID])
GO
ALTER TABLE [dbo].[MasterRecipeRecord] CHECK CONSTRAINT [FK_MasterRecipeRecord_MasterRecipe]
GO
ALTER TABLE [dbo].[MaterialActual]  WITH CHECK ADD  CONSTRAINT [FK_MaterialActual_MaterialActual] FOREIGN KEY([AssemblyActual])
REFERENCES [dbo].[MaterialActual] ([ID])
GO
ALTER TABLE [dbo].[MaterialActual] CHECK CONSTRAINT [FK_MaterialActual_MaterialActual]
GO
ALTER TABLE [dbo].[MaterialActual]  WITH CHECK ADD  CONSTRAINT [FK_MaterialActual_MaterialClass] FOREIGN KEY([MaterialClassID])
REFERENCES [dbo].[MaterialClass] ([ID])
GO
ALTER TABLE [dbo].[MaterialActual] CHECK CONSTRAINT [FK_MaterialActual_MaterialClass]
GO
ALTER TABLE [dbo].[MaterialActual]  WITH CHECK ADD  CONSTRAINT [FK_MaterialActual_MaterialDefinition] FOREIGN KEY([MaterialDefinitionID])
REFERENCES [dbo].[MaterialDefinition] ([ID])
GO
ALTER TABLE [dbo].[MaterialActual] CHECK CONSTRAINT [FK_MaterialActual_MaterialDefinition]
GO
ALTER TABLE [dbo].[MaterialActual]  WITH CHECK ADD  CONSTRAINT [FK_MaterialActual_MaterialLot] FOREIGN KEY([MaterialLotID])
REFERENCES [dbo].[MaterialLot] ([ID])
GO
ALTER TABLE [dbo].[MaterialActual] CHECK CONSTRAINT [FK_MaterialActual_MaterialLot]
GO
ALTER TABLE [dbo].[MaterialActual]  WITH CHECK ADD  CONSTRAINT [FK_MaterialActual_MateriaSubLot] FOREIGN KEY([MaterialSubLotID])
REFERENCES [dbo].[MaterialSubLot] ([ID])
GO
ALTER TABLE [dbo].[MaterialActual] CHECK CONSTRAINT [FK_MaterialActual_MateriaSubLot]
GO
ALTER TABLE [dbo].[MaterialActual]  WITH CHECK ADD  CONSTRAINT [FK_MaterialActual_SegmentResponse] FOREIGN KEY([SegmentResponseID])
REFERENCES [dbo].[SegmentResponse] ([ID])
GO
ALTER TABLE [dbo].[MaterialActual] CHECK CONSTRAINT [FK_MaterialActual_SegmentResponse]
GO
ALTER TABLE [dbo].[MaterialActualProperty]  WITH CHECK ADD  CONSTRAINT [FK_MaterialActualProperty_MaterialActual] FOREIGN KEY([MaterialActual])
REFERENCES [dbo].[MaterialActual] ([ID])
GO
ALTER TABLE [dbo].[MaterialActualProperty] CHECK CONSTRAINT [FK_MaterialActualProperty_MaterialActual]
GO
ALTER TABLE [dbo].[MaterialActualProperty]  WITH CHECK ADD  CONSTRAINT [FK_MaterialActualProperty_OpMaterialActual] FOREIGN KEY([OpMaterialActual])
REFERENCES [dbo].[OpMaterialActual] ([ID])
GO
ALTER TABLE [dbo].[MaterialActualProperty] CHECK CONSTRAINT [FK_MaterialActualProperty_OpMaterialActual]
GO
ALTER TABLE [dbo].[MaterialCapability]  WITH CHECK ADD  CONSTRAINT [FK_MaterialCapability_MaterialCapability] FOREIGN KEY([AssemblyCapability])
REFERENCES [dbo].[MaterialCapability] ([ID])
GO
ALTER TABLE [dbo].[MaterialCapability] CHECK CONSTRAINT [FK_MaterialCapability_MaterialCapability]
GO
ALTER TABLE [dbo].[MaterialCapability]  WITH CHECK ADD  CONSTRAINT [FK_MaterialCapability_MaterialClass] FOREIGN KEY([MaterialClassID])
REFERENCES [dbo].[MaterialClass] ([ID])
GO
ALTER TABLE [dbo].[MaterialCapability] CHECK CONSTRAINT [FK_MaterialCapability_MaterialClass]
GO
ALTER TABLE [dbo].[MaterialCapability]  WITH CHECK ADD  CONSTRAINT [FK_MaterialCapability_MaterialDefinition] FOREIGN KEY([MaterialDefinitionID])
REFERENCES [dbo].[MaterialDefinition] ([ID])
GO
ALTER TABLE [dbo].[MaterialCapability] CHECK CONSTRAINT [FK_MaterialCapability_MaterialDefinition]
GO
ALTER TABLE [dbo].[MaterialCapability]  WITH CHECK ADD  CONSTRAINT [FK_MaterialCapability_MaterialLot] FOREIGN KEY([MaterialLotID])
REFERENCES [dbo].[MaterialLot] ([ID])
GO
ALTER TABLE [dbo].[MaterialCapability] CHECK CONSTRAINT [FK_MaterialCapability_MaterialLot]
GO
ALTER TABLE [dbo].[MaterialCapability]  WITH CHECK ADD  CONSTRAINT [FK_MaterialCapability_MateriaSubLot] FOREIGN KEY([MaterialSubLotID])
REFERENCES [dbo].[MaterialSubLot] ([ID])
GO
ALTER TABLE [dbo].[MaterialCapability] CHECK CONSTRAINT [FK_MaterialCapability_MateriaSubLot]
GO
ALTER TABLE [dbo].[MaterialCapability]  WITH CHECK ADD  CONSTRAINT [FK_MaterialCapability_ProcessSegmentCapability] FOREIGN KEY([ProcessSegmentCapabilityID])
REFERENCES [dbo].[ProcessSegmentCapability] ([ID])
GO
ALTER TABLE [dbo].[MaterialCapability] CHECK CONSTRAINT [FK_MaterialCapability_ProcessSegmentCapability]
GO
ALTER TABLE [dbo].[MaterialCapability]  WITH CHECK ADD  CONSTRAINT [FK_MaterialCapability_ProductionCapability] FOREIGN KEY([ProductionCapability])
REFERENCES [dbo].[ProductionCapability] ([ID])
GO
ALTER TABLE [dbo].[MaterialCapability] CHECK CONSTRAINT [FK_MaterialCapability_ProductionCapability]
GO
ALTER TABLE [dbo].[MaterialCapabilityProperty]  WITH CHECK ADD  CONSTRAINT [FK_MaterialCapabilityProperty_MaterialCapability] FOREIGN KEY([MaterialCapabilityID])
REFERENCES [dbo].[MaterialCapability] ([ID])
GO
ALTER TABLE [dbo].[MaterialCapabilityProperty] CHECK CONSTRAINT [FK_MaterialCapabilityProperty_MaterialCapability]
GO
ALTER TABLE [dbo].[MaterialCapabilityProperty]  WITH CHECK ADD  CONSTRAINT [FK_MaterialCapabilityProperty_OpMaterialCapability] FOREIGN KEY([OpMaterialCapabilityID])
REFERENCES [dbo].[OpMaterialCapability] ([ID])
GO
ALTER TABLE [dbo].[MaterialCapabilityProperty] CHECK CONSTRAINT [FK_MaterialCapabilityProperty_OpMaterialCapability]
GO
ALTER TABLE [dbo].[MaterialClass]  WITH CHECK ADD  CONSTRAINT [FK_MaterialClassID_MaterialClassParentID] FOREIGN KEY([ParentID])
REFERENCES [dbo].[MaterialClass] ([ID])
GO
ALTER TABLE [dbo].[MaterialClass] CHECK CONSTRAINT [FK_MaterialClassID_MaterialClassParentID]
GO
ALTER TABLE [dbo].[MaterialClassAssemblies]  WITH CHECK ADD  CONSTRAINT [FK_AssemblyClass_MaterialClass] FOREIGN KEY([MaterialClassID])
REFERENCES [dbo].[MaterialClass] ([ID])
GO
ALTER TABLE [dbo].[MaterialClassAssemblies] CHECK CONSTRAINT [FK_AssemblyClass_MaterialClass]
GO
ALTER TABLE [dbo].[MaterialClassAssemblies]  WITH CHECK ADD  CONSTRAINT [FK_AssemblyClass_MaterialClass1] FOREIGN KEY([AssemblyClassID])
REFERENCES [dbo].[MaterialClass] ([ID])
GO
ALTER TABLE [dbo].[MaterialClassAssemblies] CHECK CONSTRAINT [FK_AssemblyClass_MaterialClass1]
GO
ALTER TABLE [dbo].[MaterialClassLinks]  WITH CHECK ADD  CONSTRAINT [FK_MaterialClassLinks_MaterialClass] FOREIGN KEY([MaterialClassID1])
REFERENCES [dbo].[MaterialClass] ([ID])
GO
ALTER TABLE [dbo].[MaterialClassLinks] CHECK CONSTRAINT [FK_MaterialClassLinks_MaterialClass]
GO
ALTER TABLE [dbo].[MaterialClassLinks]  WITH CHECK ADD  CONSTRAINT [FK_MaterialClassLinks_MaterialClass1] FOREIGN KEY([MaterialClassID2])
REFERENCES [dbo].[MaterialClass] ([ID])
GO
ALTER TABLE [dbo].[MaterialClassLinks] CHECK CONSTRAINT [FK_MaterialClassLinks_MaterialClass1]
GO
ALTER TABLE [dbo].[MaterialClassLinks]  WITH CHECK ADD  CONSTRAINT [FK_MaterialClassLinks_MaterialLinkTypes] FOREIGN KEY([LinkType])
REFERENCES [dbo].[MaterialLinkTypes] ([ID])
GO
ALTER TABLE [dbo].[MaterialClassLinks] CHECK CONSTRAINT [FK_MaterialClassLinks_MaterialLinkTypes]
GO
ALTER TABLE [dbo].[MaterialClassProperty]  WITH CHECK ADD  CONSTRAINT [FK_MaterialClassProperty_MaterialClass] FOREIGN KEY([MaterialClassID])
REFERENCES [dbo].[MaterialClass] ([ID])
GO
ALTER TABLE [dbo].[MaterialClassProperty] CHECK CONSTRAINT [FK_MaterialClassProperty_MaterialClass]
GO
ALTER TABLE [dbo].[MaterialClassProperty]  WITH CHECK ADD  CONSTRAINT [FK_MaterialClassProperty_MaterialClassProperty1] FOREIGN KEY([MaterialClassProperty])
REFERENCES [dbo].[MaterialClassProperty] ([ID])
GO
ALTER TABLE [dbo].[MaterialClassProperty] CHECK CONSTRAINT [FK_MaterialClassProperty_MaterialClassProperty1]
GO
ALTER TABLE [dbo].[MaterialClassProperty]  WITH CHECK ADD  CONSTRAINT [FK_MaterialClassProperty_MaterialTestSpecification1] FOREIGN KEY([MaterialTestSpecificationID])
REFERENCES [dbo].[MaterialTestSpecification] ([Name])
GO
ALTER TABLE [dbo].[MaterialClassProperty] CHECK CONSTRAINT [FK_MaterialClassProperty_MaterialTestSpecification1]
GO
ALTER TABLE [dbo].[MaterialClassProperty]  WITH CHECK ADD  CONSTRAINT [FK_MaterialClassProperty_PropertyTypes] FOREIGN KEY([PropertyType])
REFERENCES [dbo].[PropertyTypes] ([ID])
GO
ALTER TABLE [dbo].[MaterialClassProperty] CHECK CONSTRAINT [FK_MaterialClassProperty_PropertyTypes]
GO
ALTER TABLE [dbo].[MaterialConsumedActual]  WITH CHECK ADD  CONSTRAINT [FK_MaterialConsumedActual_MaterialClass] FOREIGN KEY([MaterialClassID])
REFERENCES [dbo].[MaterialClass] ([ID])
GO
ALTER TABLE [dbo].[MaterialConsumedActual] CHECK CONSTRAINT [FK_MaterialConsumedActual_MaterialClass]
GO
ALTER TABLE [dbo].[MaterialConsumedActual]  WITH CHECK ADD  CONSTRAINT [FK_MaterialConsumedActual_MaterialDefinition] FOREIGN KEY([MaterialDefinitionID])
REFERENCES [dbo].[MaterialDefinition] ([ID])
GO
ALTER TABLE [dbo].[MaterialConsumedActual] CHECK CONSTRAINT [FK_MaterialConsumedActual_MaterialDefinition]
GO
ALTER TABLE [dbo].[MaterialConsumedActual]  WITH CHECK ADD  CONSTRAINT [FK_MaterialConsumedActual_MaterialLot] FOREIGN KEY([MaterialLotID])
REFERENCES [dbo].[MaterialLot] ([ID])
GO
ALTER TABLE [dbo].[MaterialConsumedActual] CHECK CONSTRAINT [FK_MaterialConsumedActual_MaterialLot]
GO
ALTER TABLE [dbo].[MaterialConsumedActual]  WITH CHECK ADD  CONSTRAINT [FK_MaterialConsumedActual_MateriaSubLot] FOREIGN KEY([MaterialSubLotID])
REFERENCES [dbo].[MaterialSubLot] ([ID])
GO
ALTER TABLE [dbo].[MaterialConsumedActual] CHECK CONSTRAINT [FK_MaterialConsumedActual_MateriaSubLot]
GO
ALTER TABLE [dbo].[MaterialConsumedActual]  WITH CHECK ADD  CONSTRAINT [FK_MaterialConsumedActual_SegmentResponse] FOREIGN KEY([SegmentResponseID])
REFERENCES [dbo].[SegmentResponse] ([ID])
GO
ALTER TABLE [dbo].[MaterialConsumedActual] CHECK CONSTRAINT [FK_MaterialConsumedActual_SegmentResponse]
GO
ALTER TABLE [dbo].[MaterialConsumedActualProperty]  WITH CHECK ADD  CONSTRAINT [FK_MaterialConsumedActualProperty_MaterialConsumedActual] FOREIGN KEY([MaterialConsumedActual])
REFERENCES [dbo].[MaterialConsumedActual] ([ID])
GO
ALTER TABLE [dbo].[MaterialConsumedActualProperty] CHECK CONSTRAINT [FK_MaterialConsumedActualProperty_MaterialConsumedActual]
GO
ALTER TABLE [dbo].[MaterialConsumedRequirement]  WITH CHECK ADD  CONSTRAINT [FK_MaterialConsumedRequirement_MaterialClass] FOREIGN KEY([MaterialClassID])
REFERENCES [dbo].[MaterialClass] ([ID])
GO
ALTER TABLE [dbo].[MaterialConsumedRequirement] CHECK CONSTRAINT [FK_MaterialConsumedRequirement_MaterialClass]
GO
ALTER TABLE [dbo].[MaterialConsumedRequirement]  WITH CHECK ADD  CONSTRAINT [FK_MaterialConsumedRequirement_MaterialDefinition] FOREIGN KEY([MaterialDefinitionID])
REFERENCES [dbo].[MaterialDefinition] ([ID])
GO
ALTER TABLE [dbo].[MaterialConsumedRequirement] CHECK CONSTRAINT [FK_MaterialConsumedRequirement_MaterialDefinition]
GO
ALTER TABLE [dbo].[MaterialConsumedRequirement]  WITH CHECK ADD  CONSTRAINT [FK_MaterialConsumedRequirement_MaterialLot] FOREIGN KEY([MaterialLotID])
REFERENCES [dbo].[MaterialLot] ([ID])
GO
ALTER TABLE [dbo].[MaterialConsumedRequirement] CHECK CONSTRAINT [FK_MaterialConsumedRequirement_MaterialLot]
GO
ALTER TABLE [dbo].[MaterialConsumedRequirement]  WITH CHECK ADD  CONSTRAINT [FK_MaterialConsumedRequirement_MateriaSubLot] FOREIGN KEY([MaterialSubLotID])
REFERENCES [dbo].[MaterialSubLot] ([ID])
GO
ALTER TABLE [dbo].[MaterialConsumedRequirement] CHECK CONSTRAINT [FK_MaterialConsumedRequirement_MateriaSubLot]
GO
ALTER TABLE [dbo].[MaterialConsumedRequirement]  WITH CHECK ADD  CONSTRAINT [FK_MaterialConsumedRequirement_SegmentRequirement] FOREIGN KEY([SegmentRequirementID])
REFERENCES [dbo].[SegmentRequirement] ([ID])
GO
ALTER TABLE [dbo].[MaterialConsumedRequirement] CHECK CONSTRAINT [FK_MaterialConsumedRequirement_SegmentRequirement]
GO
ALTER TABLE [dbo].[MaterialConsumedRequirementProperty]  WITH CHECK ADD  CONSTRAINT [FK_MaterialConsumedRequirementProperty_MaterialConsumedRequirement] FOREIGN KEY([MaterialConsumedRequirement])
REFERENCES [dbo].[MaterialConsumedRequirement] ([ID])
GO
ALTER TABLE [dbo].[MaterialConsumedRequirementProperty] CHECK CONSTRAINT [FK_MaterialConsumedRequirementProperty_MaterialConsumedRequirement]
GO
ALTER TABLE [dbo].[MaterialDefinition]  WITH CHECK ADD  CONSTRAINT [FK_MaterialDefinition_MaterialClass] FOREIGN KEY([MaterialClassID])
REFERENCES [dbo].[MaterialClass] ([ID])
GO
ALTER TABLE [dbo].[MaterialDefinition] CHECK CONSTRAINT [FK_MaterialDefinition_MaterialClass]
GO
ALTER TABLE [dbo].[MaterialDefinitionAssemblies]  WITH CHECK ADD  CONSTRAINT [FK_AssemblyDefinition_MaterialDefinition2] FOREIGN KEY([MaterialDefinitionID])
REFERENCES [dbo].[MaterialDefinition] ([ID])
GO
ALTER TABLE [dbo].[MaterialDefinitionAssemblies] CHECK CONSTRAINT [FK_AssemblyDefinition_MaterialDefinition2]
GO
ALTER TABLE [dbo].[MaterialDefinitionAssemblies]  WITH CHECK ADD  CONSTRAINT [FK_AssemblyDefinition_MaterialDefinition3] FOREIGN KEY([AssemblyDefinitionID])
REFERENCES [dbo].[MaterialDefinition] ([ID])
GO
ALTER TABLE [dbo].[MaterialDefinitionAssemblies] CHECK CONSTRAINT [FK_AssemblyDefinition_MaterialDefinition3]
GO
ALTER TABLE [dbo].[MaterialDefinitionLinks]  WITH CHECK ADD  CONSTRAINT [FK_MaterialDefinitionLinks_MaterialDefinition] FOREIGN KEY([MaterialDefinition1])
REFERENCES [dbo].[MaterialDefinition] ([ID])
GO
ALTER TABLE [dbo].[MaterialDefinitionLinks] CHECK CONSTRAINT [FK_MaterialDefinitionLinks_MaterialDefinition]
GO
ALTER TABLE [dbo].[MaterialDefinitionLinks]  WITH CHECK ADD  CONSTRAINT [FK_MaterialDefinitionLinks_MaterialDefinition1] FOREIGN KEY([MaterialDefinition2])
REFERENCES [dbo].[MaterialDefinition] ([ID])
GO
ALTER TABLE [dbo].[MaterialDefinitionLinks] CHECK CONSTRAINT [FK_MaterialDefinitionLinks_MaterialDefinition1]
GO
ALTER TABLE [dbo].[MaterialDefinitionLinks]  WITH CHECK ADD  CONSTRAINT [FK_MaterialDefinitionLinks_MaterialDefinition2] FOREIGN KEY([LinkType])
REFERENCES [dbo].[MaterialLinkTypes] ([ID])
GO
ALTER TABLE [dbo].[MaterialDefinitionLinks] CHECK CONSTRAINT [FK_MaterialDefinitionLinks_MaterialDefinition2]
GO
ALTER TABLE [dbo].[MaterialDefinitionProperty]  WITH CHECK ADD  CONSTRAINT [FK_MaterialDefinitionProperty_MaterialClassProperty] FOREIGN KEY([ClassPropertyID])
REFERENCES [dbo].[MaterialClassProperty] ([ID])
GO
ALTER TABLE [dbo].[MaterialDefinitionProperty] CHECK CONSTRAINT [FK_MaterialDefinitionProperty_MaterialClassProperty]
GO
ALTER TABLE [dbo].[MaterialDefinitionProperty]  WITH CHECK ADD  CONSTRAINT [FK_MaterialDefinitionProperty_MaterialDefinition] FOREIGN KEY([MaterialDefinitionID])
REFERENCES [dbo].[MaterialDefinition] ([ID])
GO
ALTER TABLE [dbo].[MaterialDefinitionProperty] CHECK CONSTRAINT [FK_MaterialDefinitionProperty_MaterialDefinition]
GO
ALTER TABLE [dbo].[MaterialDefinitionProperty]  WITH CHECK ADD  CONSTRAINT [FK_MaterialDefinitionProperty_MaterialDefinitionProperty1] FOREIGN KEY([MaterialDefinitionProperty])
REFERENCES [dbo].[MaterialDefinitionProperty] ([ID])
GO
ALTER TABLE [dbo].[MaterialDefinitionProperty] CHECK CONSTRAINT [FK_MaterialDefinitionProperty_MaterialDefinitionProperty1]
GO
ALTER TABLE [dbo].[MaterialDefinitionProperty]  WITH CHECK ADD  CONSTRAINT [FK_MaterialDefinitionProperty_MaterialTestSpecification] FOREIGN KEY([MaterialTestSpecificationID])
REFERENCES [dbo].[MaterialTestSpecification] ([Name])
GO
ALTER TABLE [dbo].[MaterialDefinitionProperty] CHECK CONSTRAINT [FK_MaterialDefinitionProperty_MaterialTestSpecification]
GO
ALTER TABLE [dbo].[MaterialDefinitionProperty]  WITH CHECK ADD  CONSTRAINT [FK_MaterialDefinitionProperty_PropertyTypes] FOREIGN KEY([PropertyType])
REFERENCES [dbo].[PropertyTypes] ([ID])
GO
ALTER TABLE [dbo].[MaterialDefinitionProperty] CHECK CONSTRAINT [FK_MaterialDefinitionProperty_PropertyTypes]
GO
ALTER TABLE [dbo].[MaterialInformation]  WITH CHECK ADD  CONSTRAINT [FK_MaterialInformation_MaterialClass] FOREIGN KEY([MaterialClassID])
REFERENCES [dbo].[MaterialClass] ([ID])
GO
ALTER TABLE [dbo].[MaterialInformation] CHECK CONSTRAINT [FK_MaterialInformation_MaterialClass]
GO
ALTER TABLE [dbo].[MaterialInformation]  WITH CHECK ADD  CONSTRAINT [FK_MaterialInformation_MaterialDefinition] FOREIGN KEY([MaterialDefinition])
REFERENCES [dbo].[MaterialDefinition] ([ID])
GO
ALTER TABLE [dbo].[MaterialInformation] CHECK CONSTRAINT [FK_MaterialInformation_MaterialDefinition]
GO
ALTER TABLE [dbo].[MaterialInformation]  WITH CHECK ADD  CONSTRAINT [FK_MaterialInformation_MaterialLot] FOREIGN KEY([MaterialLot])
REFERENCES [dbo].[MaterialLot] ([ID])
GO
ALTER TABLE [dbo].[MaterialInformation] CHECK CONSTRAINT [FK_MaterialInformation_MaterialLot]
GO
ALTER TABLE [dbo].[MaterialInformation]  WITH CHECK ADD  CONSTRAINT [FK_MaterialInformation_MateriaSubLot] FOREIGN KEY([MaterialSubLot])
REFERENCES [dbo].[MaterialSubLot] ([ID])
GO
ALTER TABLE [dbo].[MaterialInformation] CHECK CONSTRAINT [FK_MaterialInformation_MateriaSubLot]
GO
ALTER TABLE [dbo].[MaterialLot]  WITH CHECK ADD  CONSTRAINT [FK_MaterialLot_MaterialDefinition] FOREIGN KEY([MaterialDefinitionID])
REFERENCES [dbo].[MaterialDefinition] ([ID])
GO
ALTER TABLE [dbo].[MaterialLot] CHECK CONSTRAINT [FK_MaterialLot_MaterialDefinition]
GO
ALTER TABLE [dbo].[MaterialLot]  WITH CHECK ADD  CONSTRAINT [FK_MaterialLot_MaterialLot] FOREIGN KEY([AssemblyLotID])
REFERENCES [dbo].[MaterialLot] ([ID])
GO
ALTER TABLE [dbo].[MaterialLot] CHECK CONSTRAINT [FK_MaterialLot_MaterialLot]
GO
ALTER TABLE [dbo].[MaterialLotLinks]  WITH CHECK ADD  CONSTRAINT [FK_MaterialLotLinks_MaterialLinkTypes] FOREIGN KEY([LinkType])
REFERENCES [dbo].[MaterialLinkTypes] ([ID])
GO
ALTER TABLE [dbo].[MaterialLotLinks] CHECK CONSTRAINT [FK_MaterialLotLinks_MaterialLinkTypes]
GO
ALTER TABLE [dbo].[MaterialLotLinks]  WITH CHECK ADD  CONSTRAINT [FK_MaterialLotLinks_MaterialLot] FOREIGN KEY([MaterialLot1])
REFERENCES [dbo].[MaterialLot] ([ID])
GO
ALTER TABLE [dbo].[MaterialLotLinks] CHECK CONSTRAINT [FK_MaterialLotLinks_MaterialLot]
GO
ALTER TABLE [dbo].[MaterialLotLinks]  WITH CHECK ADD  CONSTRAINT [FK_MaterialLotLinks_MaterialLot1] FOREIGN KEY([MaterialLot2])
REFERENCES [dbo].[MaterialLot] ([ID])
GO
ALTER TABLE [dbo].[MaterialLotLinks] CHECK CONSTRAINT [FK_MaterialLotLinks_MaterialLot1]
GO
ALTER TABLE [dbo].[MaterialLotProperty]  WITH CHECK ADD  CONSTRAINT [FK_MaterialLotProperty_MaterialDefinitionProperty] FOREIGN KEY([DefinitionPropertyID])
REFERENCES [dbo].[MaterialDefinitionProperty] ([ID])
GO
ALTER TABLE [dbo].[MaterialLotProperty] CHECK CONSTRAINT [FK_MaterialLotProperty_MaterialDefinitionProperty]
GO
ALTER TABLE [dbo].[MaterialLotProperty]  WITH CHECK ADD  CONSTRAINT [FK_MaterialLotProperty_MaterialLot] FOREIGN KEY([MaterialLotID])
REFERENCES [dbo].[MaterialLot] ([ID])
GO
ALTER TABLE [dbo].[MaterialLotProperty] CHECK CONSTRAINT [FK_MaterialLotProperty_MaterialLot]
GO
ALTER TABLE [dbo].[MaterialLotProperty]  WITH CHECK ADD  CONSTRAINT [FK_MaterialLotProperty_MaterialLotProperty1] FOREIGN KEY([MaterialLotProperty])
REFERENCES [dbo].[MaterialLotProperty] ([ID])
GO
ALTER TABLE [dbo].[MaterialLotProperty] CHECK CONSTRAINT [FK_MaterialLotProperty_MaterialLotProperty1]
GO
ALTER TABLE [dbo].[MaterialLotProperty]  WITH CHECK ADD  CONSTRAINT [FK_MaterialLotProperty_MaterialTestSpecification] FOREIGN KEY([MaterialTestSpecificationID])
REFERENCES [dbo].[MaterialTestSpecification] ([Name])
GO
ALTER TABLE [dbo].[MaterialLotProperty] CHECK CONSTRAINT [FK_MaterialLotProperty_MaterialTestSpecification]
GO
ALTER TABLE [dbo].[MaterialLotProperty]  WITH CHECK ADD  CONSTRAINT [FK_MaterialLotProperty_MateriaSubLot] FOREIGN KEY([MaterialSubLotID])
REFERENCES [dbo].[MaterialSubLot] ([ID])
GO
ALTER TABLE [dbo].[MaterialLotProperty] CHECK CONSTRAINT [FK_MaterialLotProperty_MateriaSubLot]
GO
ALTER TABLE [dbo].[MaterialLotProperty]  WITH CHECK ADD  CONSTRAINT [FK_MaterialLotProperty_PropertyTypes] FOREIGN KEY([PropertyType])
REFERENCES [dbo].[PropertyTypes] ([ID])
GO
ALTER TABLE [dbo].[MaterialLotProperty] CHECK CONSTRAINT [FK_MaterialLotProperty_PropertyTypes]
GO
ALTER TABLE [dbo].[MaterialProducedActual]  WITH CHECK ADD  CONSTRAINT [FK_MaterialProducedActual_MaterialClass] FOREIGN KEY([MaterialClassID])
REFERENCES [dbo].[MaterialClass] ([ID])
GO
ALTER TABLE [dbo].[MaterialProducedActual] CHECK CONSTRAINT [FK_MaterialProducedActual_MaterialClass]
GO
ALTER TABLE [dbo].[MaterialProducedActual]  WITH CHECK ADD  CONSTRAINT [FK_MaterialProducedActual_MaterialDefinition] FOREIGN KEY([MaterialDefinitionID])
REFERENCES [dbo].[MaterialDefinition] ([ID])
GO
ALTER TABLE [dbo].[MaterialProducedActual] CHECK CONSTRAINT [FK_MaterialProducedActual_MaterialDefinition]
GO
ALTER TABLE [dbo].[MaterialProducedActual]  WITH CHECK ADD  CONSTRAINT [FK_MaterialProducedActual_MaterialLot] FOREIGN KEY([MaterialLotID])
REFERENCES [dbo].[MaterialLot] ([ID])
GO
ALTER TABLE [dbo].[MaterialProducedActual] CHECK CONSTRAINT [FK_MaterialProducedActual_MaterialLot]
GO
ALTER TABLE [dbo].[MaterialProducedActual]  WITH CHECK ADD  CONSTRAINT [FK_MaterialProducedActual_MateriaSubLot] FOREIGN KEY([MaterialSubLotID])
REFERENCES [dbo].[MaterialSubLot] ([ID])
GO
ALTER TABLE [dbo].[MaterialProducedActual] CHECK CONSTRAINT [FK_MaterialProducedActual_MateriaSubLot]
GO
ALTER TABLE [dbo].[MaterialProducedActual]  WITH CHECK ADD  CONSTRAINT [FK_MaterialProducedActual_SegmentResponse] FOREIGN KEY([SegmentResponseID])
REFERENCES [dbo].[SegmentResponse] ([ID])
GO
ALTER TABLE [dbo].[MaterialProducedActual] CHECK CONSTRAINT [FK_MaterialProducedActual_SegmentResponse]
GO
ALTER TABLE [dbo].[MaterialProducedActualProperty]  WITH CHECK ADD  CONSTRAINT [FK_MaterialProducedActualProperty_MaterialProducedActual] FOREIGN KEY([MaterialProducedActual])
REFERENCES [dbo].[MaterialProducedActual] ([ID])
GO
ALTER TABLE [dbo].[MaterialProducedActualProperty] CHECK CONSTRAINT [FK_MaterialProducedActualProperty_MaterialProducedActual]
GO
ALTER TABLE [dbo].[MaterialProducedRequirement]  WITH CHECK ADD  CONSTRAINT [FK_MaterialProducedRequirement_MaterialClass] FOREIGN KEY([MaterialClassID])
REFERENCES [dbo].[MaterialClass] ([ID])
GO
ALTER TABLE [dbo].[MaterialProducedRequirement] CHECK CONSTRAINT [FK_MaterialProducedRequirement_MaterialClass]
GO
ALTER TABLE [dbo].[MaterialProducedRequirement]  WITH CHECK ADD  CONSTRAINT [FK_MaterialProducedRequirement_MaterialDefinition] FOREIGN KEY([MaterialDefinitionID])
REFERENCES [dbo].[MaterialDefinition] ([ID])
GO
ALTER TABLE [dbo].[MaterialProducedRequirement] CHECK CONSTRAINT [FK_MaterialProducedRequirement_MaterialDefinition]
GO
ALTER TABLE [dbo].[MaterialProducedRequirement]  WITH CHECK ADD  CONSTRAINT [FK_MaterialProducedRequirement_MaterialLot] FOREIGN KEY([MaterialLotID])
REFERENCES [dbo].[MaterialLot] ([ID])
GO
ALTER TABLE [dbo].[MaterialProducedRequirement] CHECK CONSTRAINT [FK_MaterialProducedRequirement_MaterialLot]
GO
ALTER TABLE [dbo].[MaterialProducedRequirement]  WITH CHECK ADD  CONSTRAINT [FK_MaterialProducedRequirement_MateriaSubLot] FOREIGN KEY([MaterialSubLotID])
REFERENCES [dbo].[MaterialSubLot] ([ID])
GO
ALTER TABLE [dbo].[MaterialProducedRequirement] CHECK CONSTRAINT [FK_MaterialProducedRequirement_MateriaSubLot]
GO
ALTER TABLE [dbo].[MaterialProducedRequirement]  WITH CHECK ADD  CONSTRAINT [FK_MaterialProducedRequirement_SegmentRequirement] FOREIGN KEY([SegmentRequirementID])
REFERENCES [dbo].[SegmentRequirement] ([ID])
GO
ALTER TABLE [dbo].[MaterialProducedRequirement] CHECK CONSTRAINT [FK_MaterialProducedRequirement_SegmentRequirement]
GO
ALTER TABLE [dbo].[MaterialProducedRequirementProperty]  WITH CHECK ADD  CONSTRAINT [FK_MaterialProducedRequirementProperty_MaterialProducedRequirement] FOREIGN KEY([MaterialProducedRequirement])
REFERENCES [dbo].[MaterialProducedRequirement] ([ID])
GO
ALTER TABLE [dbo].[MaterialProducedRequirementProperty] CHECK CONSTRAINT [FK_MaterialProducedRequirementProperty_MaterialProducedRequirement]
GO
ALTER TABLE [dbo].[MaterialRequirement]  WITH CHECK ADD  CONSTRAINT [FK_MaterialRequirement_MaterialClass] FOREIGN KEY([MaterialClassID])
REFERENCES [dbo].[MaterialClass] ([ID])
GO
ALTER TABLE [dbo].[MaterialRequirement] CHECK CONSTRAINT [FK_MaterialRequirement_MaterialClass]
GO
ALTER TABLE [dbo].[MaterialRequirement]  WITH CHECK ADD  CONSTRAINT [FK_MaterialRequirement_MaterialDefinition] FOREIGN KEY([MaterialDefinitionID])
REFERENCES [dbo].[MaterialDefinition] ([ID])
GO
ALTER TABLE [dbo].[MaterialRequirement] CHECK CONSTRAINT [FK_MaterialRequirement_MaterialDefinition]
GO
ALTER TABLE [dbo].[MaterialRequirement]  WITH CHECK ADD  CONSTRAINT [FK_MaterialRequirement_MaterialLot] FOREIGN KEY([MaterialLotID])
REFERENCES [dbo].[MaterialLot] ([ID])
GO
ALTER TABLE [dbo].[MaterialRequirement] CHECK CONSTRAINT [FK_MaterialRequirement_MaterialLot]
GO
ALTER TABLE [dbo].[MaterialRequirement]  WITH CHECK ADD  CONSTRAINT [FK_MaterialRequirement_MaterialRequirement] FOREIGN KEY([AssemblyRequirement])
REFERENCES [dbo].[MaterialRequirement] ([ID])
GO
ALTER TABLE [dbo].[MaterialRequirement] CHECK CONSTRAINT [FK_MaterialRequirement_MaterialRequirement]
GO
ALTER TABLE [dbo].[MaterialRequirement]  WITH CHECK ADD  CONSTRAINT [FK_MaterialRequirement_MateriaSubLot] FOREIGN KEY([MaterialSubLotID])
REFERENCES [dbo].[MaterialSubLot] ([ID])
GO
ALTER TABLE [dbo].[MaterialRequirement] CHECK CONSTRAINT [FK_MaterialRequirement_MateriaSubLot]
GO
ALTER TABLE [dbo].[MaterialRequirement]  WITH CHECK ADD  CONSTRAINT [FK_MaterialRequirement_SegmentRequirement] FOREIGN KEY([SegmentRequirementID])
REFERENCES [dbo].[SegmentRequirement] ([ID])
GO
ALTER TABLE [dbo].[MaterialRequirement] CHECK CONSTRAINT [FK_MaterialRequirement_SegmentRequirement]
GO
ALTER TABLE [dbo].[MaterialRequirementProperty]  WITH CHECK ADD  CONSTRAINT [FK_MaterialRequirementProperty_MaterialRequirement] FOREIGN KEY([MaterialRequirement])
REFERENCES [dbo].[MaterialRequirement] ([ID])
GO
ALTER TABLE [dbo].[MaterialRequirementProperty] CHECK CONSTRAINT [FK_MaterialRequirementProperty_MaterialRequirement]
GO
ALTER TABLE [dbo].[MaterialRequirementProperty]  WITH CHECK ADD  CONSTRAINT [FK_MaterialRequirementProperty_OpMaterialRequirement] FOREIGN KEY([OpMaterialRequirement])
REFERENCES [dbo].[OpMaterialRequirement] ([ID])
GO
ALTER TABLE [dbo].[MaterialRequirementProperty] CHECK CONSTRAINT [FK_MaterialRequirementProperty_OpMaterialRequirement]
GO
ALTER TABLE [dbo].[MaterialSegmentSpecificationProperty]  WITH CHECK ADD  CONSTRAINT [FK_MaterialSegmentSpecificationProperty_MaterialSegmentSpecificftion] FOREIGN KEY([MaterialSegmentSpecification])
REFERENCES [dbo].[MaterialSegmentSpecificftion] ([ID])
GO
ALTER TABLE [dbo].[MaterialSegmentSpecificationProperty] CHECK CONSTRAINT [FK_MaterialSegmentSpecificationProperty_MaterialSegmentSpecificftion]
GO
ALTER TABLE [dbo].[MaterialSegmentSpecificftion]  WITH CHECK ADD  CONSTRAINT [FK_MaterialSegmentSpecificftion_MaterialClass] FOREIGN KEY([MaterialClassID])
REFERENCES [dbo].[MaterialClass] ([ID])
GO
ALTER TABLE [dbo].[MaterialSegmentSpecificftion] CHECK CONSTRAINT [FK_MaterialSegmentSpecificftion_MaterialClass]
GO
ALTER TABLE [dbo].[MaterialSegmentSpecificftion]  WITH CHECK ADD  CONSTRAINT [FK_MaterialSegmentSpecificftion_MaterialDefinition] FOREIGN KEY([MaterialDefinitionID])
REFERENCES [dbo].[MaterialDefinition] ([ID])
GO
ALTER TABLE [dbo].[MaterialSegmentSpecificftion] CHECK CONSTRAINT [FK_MaterialSegmentSpecificftion_MaterialDefinition]
GO
ALTER TABLE [dbo].[MaterialSegmentSpecificftion]  WITH CHECK ADD  CONSTRAINT [FK_MaterialSegmentSpecificftion_MaterialSegmentSpecificftion] FOREIGN KEY([AssemblySpecificationID])
REFERENCES [dbo].[MaterialSegmentSpecificftion] ([ID])
GO
ALTER TABLE [dbo].[MaterialSegmentSpecificftion] CHECK CONSTRAINT [FK_MaterialSegmentSpecificftion_MaterialSegmentSpecificftion]
GO
ALTER TABLE [dbo].[MaterialSegmentSpecificftion]  WITH CHECK ADD  CONSTRAINT [FK_MaterialSegmentSpecificftion_ProcessSegment] FOREIGN KEY([ProccesSegmentID])
REFERENCES [dbo].[ProcessSegment] ([ID])
GO
ALTER TABLE [dbo].[MaterialSegmentSpecificftion] CHECK CONSTRAINT [FK_MaterialSegmentSpecificftion_ProcessSegment]
GO
ALTER TABLE [dbo].[MaterialSpecification]  WITH CHECK ADD  CONSTRAINT [FK_MaterialSpecification_MaterialClass] FOREIGN KEY([MaterialClassID])
REFERENCES [dbo].[MaterialClass] ([ID])
GO
ALTER TABLE [dbo].[MaterialSpecification] CHECK CONSTRAINT [FK_MaterialSpecification_MaterialClass]
GO
ALTER TABLE [dbo].[MaterialSpecification]  WITH CHECK ADD  CONSTRAINT [FK_MaterialSpecification_MaterialDefinition] FOREIGN KEY([MaterialDefinitionID])
REFERENCES [dbo].[MaterialDefinition] ([ID])
GO
ALTER TABLE [dbo].[MaterialSpecification] CHECK CONSTRAINT [FK_MaterialSpecification_MaterialDefinition]
GO
ALTER TABLE [dbo].[MaterialSpecification]  WITH CHECK ADD  CONSTRAINT [FK_MaterialSpecification_MaterialSpecification] FOREIGN KEY([AssemblySpecification])
REFERENCES [dbo].[MaterialSpecification] ([ID])
GO
ALTER TABLE [dbo].[MaterialSpecification] CHECK CONSTRAINT [FK_MaterialSpecification_MaterialSpecification]
GO
ALTER TABLE [dbo].[MaterialSpecification]  WITH CHECK ADD  CONSTRAINT [FK_MaterialSpecification_ProductSegment] FOREIGN KEY([ProductSegmentID])
REFERENCES [dbo].[ProductSegment] ([ID])
GO
ALTER TABLE [dbo].[MaterialSpecification] CHECK CONSTRAINT [FK_MaterialSpecification_ProductSegment]
GO
ALTER TABLE [dbo].[MaterialSpecificationProperty]  WITH CHECK ADD  CONSTRAINT [FK_MaterialSpecificationProperty_MaterialSpecification] FOREIGN KEY([MaterialSpecification])
REFERENCES [dbo].[MaterialSpecification] ([ID])
GO
ALTER TABLE [dbo].[MaterialSpecificationProperty] CHECK CONSTRAINT [FK_MaterialSpecificationProperty_MaterialSpecification]
GO
ALTER TABLE [dbo].[MaterialSpecificationProperty]  WITH CHECK ADD  CONSTRAINT [FK_MaterialSpecificationProperty_OpMaterialSpecification] FOREIGN KEY([OpMaterialSpecification])
REFERENCES [dbo].[OpMaterialSpecification] ([ID])
GO
ALTER TABLE [dbo].[MaterialSpecificationProperty] CHECK CONSTRAINT [FK_MaterialSpecificationProperty_OpMaterialSpecification]
GO
ALTER TABLE [dbo].[MaterialSubLot]  WITH CHECK ADD  CONSTRAINT [FK_MateriaSubLot_MaterialLot] FOREIGN KEY([MaterialLotID])
REFERENCES [dbo].[MaterialLot] ([ID])
GO
ALTER TABLE [dbo].[MaterialSubLot] CHECK CONSTRAINT [FK_MateriaSubLot_MaterialLot]
GO
ALTER TABLE [dbo].[MaterialSubLot]  WITH CHECK ADD  CONSTRAINT [FK_MateriaSubLot_MaterialLot1] FOREIGN KEY([AssemblyLotID])
REFERENCES [dbo].[MaterialLot] ([ID])
GO
ALTER TABLE [dbo].[MaterialSubLot] CHECK CONSTRAINT [FK_MateriaSubLot_MaterialLot1]
GO
ALTER TABLE [dbo].[MaterialSubLot]  WITH CHECK ADD  CONSTRAINT [FK_MateriaSubLot_MateriaSubLot1] FOREIGN KEY([AssemblySubLotID])
REFERENCES [dbo].[MaterialSubLot] ([ID])
GO
ALTER TABLE [dbo].[MaterialSubLot] CHECK CONSTRAINT [FK_MateriaSubLot_MateriaSubLot1]
GO
ALTER TABLE [dbo].[MaterialSubLotLinks]  WITH CHECK ADD  CONSTRAINT [FK_MaterialSubLotLinks_MaterialLinkTypes] FOREIGN KEY([LinkType])
REFERENCES [dbo].[MaterialLinkTypes] ([ID])
GO
ALTER TABLE [dbo].[MaterialSubLotLinks] CHECK CONSTRAINT [FK_MaterialSubLotLinks_MaterialLinkTypes]
GO
ALTER TABLE [dbo].[MaterialSubLotLinks]  WITH CHECK ADD  CONSTRAINT [FK_MateriaSubLotLinks_MateriaSubLot] FOREIGN KEY([MateriaSubLot1])
REFERENCES [dbo].[MaterialSubLot] ([ID])
GO
ALTER TABLE [dbo].[MaterialSubLotLinks] CHECK CONSTRAINT [FK_MateriaSubLotLinks_MateriaSubLot]
GO
ALTER TABLE [dbo].[MaterialSubLotLinks]  WITH CHECK ADD  CONSTRAINT [FK_MateriaSubLotLinks_MateriaSubLot1] FOREIGN KEY([MateriaSubLot2])
REFERENCES [dbo].[MaterialSubLot] ([ID])
GO
ALTER TABLE [dbo].[MaterialSubLotLinks] CHECK CONSTRAINT [FK_MateriaSubLotLinks_MateriaSubLot1]
GO
ALTER TABLE [dbo].[ModificationLog]  WITH CHECK ADD  CONSTRAINT [FK_ModificationLog_Header] FOREIGN KEY([Header])
REFERENCES [dbo].[Header] ([ID])
GO
ALTER TABLE [dbo].[ModificationLog] CHECK CONSTRAINT [FK_ModificationLog_Header]
GO
ALTER TABLE [dbo].[ModificationLog]  WITH CHECK ADD  CONSTRAINT [FK_ModificationLog_ListHeader] FOREIGN KEY([ListHeader])
REFERENCES [dbo].[ListHeader] ([ID])
GO
ALTER TABLE [dbo].[ModificationLog] CHECK CONSTRAINT [FK_ModificationLog_ListHeader]
GO
ALTER TABLE [dbo].[OpEquipmentActual]  WITH CHECK ADD  CONSTRAINT [FK_OpEquipmentActual_Equipment] FOREIGN KEY([EquipmentID])
REFERENCES [dbo].[Equipment] ([ID])
GO
ALTER TABLE [dbo].[OpEquipmentActual] CHECK CONSTRAINT [FK_OpEquipmentActual_Equipment]
GO
ALTER TABLE [dbo].[OpEquipmentActual]  WITH CHECK ADD  CONSTRAINT [FK_OpEquipmentActual_EquipmentClass] FOREIGN KEY([EquipmentClassID])
REFERENCES [dbo].[EquipmentClass] ([ID])
GO
ALTER TABLE [dbo].[OpEquipmentActual] CHECK CONSTRAINT [FK_OpEquipmentActual_EquipmentClass]
GO
ALTER TABLE [dbo].[OpEquipmentActual]  WITH CHECK ADD  CONSTRAINT [FK_OpEquipmentActual_JobResponse] FOREIGN KEY([JobResponseID])
REFERENCES [dbo].[JobResponse] ([ID])
GO
ALTER TABLE [dbo].[OpEquipmentActual] CHECK CONSTRAINT [FK_OpEquipmentActual_JobResponse]
GO
ALTER TABLE [dbo].[OpEquipmentActual]  WITH CHECK ADD  CONSTRAINT [FK_OpEquipmentActual_SegmentResponse] FOREIGN KEY([SegmentResponseID])
REFERENCES [dbo].[OpSegmentResponse] ([ID])
GO
ALTER TABLE [dbo].[OpEquipmentActual] CHECK CONSTRAINT [FK_OpEquipmentActual_SegmentResponse]
GO
ALTER TABLE [dbo].[OpEquipmentCapability]  WITH CHECK ADD  CONSTRAINT [FK_OpEquipmentCapability_Equipment] FOREIGN KEY([EquipmentID])
REFERENCES [dbo].[Equipment] ([ID])
GO
ALTER TABLE [dbo].[OpEquipmentCapability] CHECK CONSTRAINT [FK_OpEquipmentCapability_Equipment]
GO
ALTER TABLE [dbo].[OpEquipmentCapability]  WITH CHECK ADD  CONSTRAINT [FK_OpEquipmentCapability_EquipmentClass] FOREIGN KEY([EquipmentClassID])
REFERENCES [dbo].[EquipmentClass] ([ID])
GO
ALTER TABLE [dbo].[OpEquipmentCapability] CHECK CONSTRAINT [FK_OpEquipmentCapability_EquipmentClass]
GO
ALTER TABLE [dbo].[OpEquipmentCapability]  WITH CHECK ADD  CONSTRAINT [FK_OpEquipmentCapability_OperationsCapability] FOREIGN KEY([OperationCapabilityID])
REFERENCES [dbo].[OperationsCapability] ([ID])
GO
ALTER TABLE [dbo].[OpEquipmentCapability] CHECK CONSTRAINT [FK_OpEquipmentCapability_OperationsCapability]
GO
ALTER TABLE [dbo].[OpEquipmentCapability]  WITH CHECK ADD  CONSTRAINT [FK_OpEquipmentCapability_ProcessSegmentCapability] FOREIGN KEY([ProcessSegmentCapabilityID])
REFERENCES [dbo].[OpProcessSegmentCapability] ([ID])
GO
ALTER TABLE [dbo].[OpEquipmentCapability] CHECK CONSTRAINT [FK_OpEquipmentCapability_ProcessSegmentCapability]
GO
ALTER TABLE [dbo].[OpEquipmentCapability]  WITH CHECK ADD  CONSTRAINT [FK_OpEquipmentCapability_WorkCapability] FOREIGN KEY([WorkCapabilityID])
REFERENCES [dbo].[WorkCapability] ([ID])
GO
ALTER TABLE [dbo].[OpEquipmentCapability] CHECK CONSTRAINT [FK_OpEquipmentCapability_WorkCapability]
GO
ALTER TABLE [dbo].[OpEquipmentCapability]  WITH CHECK ADD  CONSTRAINT [FK_OpEquipmentCapability_WorkMasterCapability] FOREIGN KEY([WorkMasterCapabilityID])
REFERENCES [dbo].[WorkMasterCapability] ([ID])
GO
ALTER TABLE [dbo].[OpEquipmentCapability] CHECK CONSTRAINT [FK_OpEquipmentCapability_WorkMasterCapability]
GO
ALTER TABLE [dbo].[OpEquipmentRequirement]  WITH CHECK ADD  CONSTRAINT [FK_OpEquipmentRequirement_Equipment] FOREIGN KEY([EquipmentID])
REFERENCES [dbo].[Equipment] ([ID])
GO
ALTER TABLE [dbo].[OpEquipmentRequirement] CHECK CONSTRAINT [FK_OpEquipmentRequirement_Equipment]
GO
ALTER TABLE [dbo].[OpEquipmentRequirement]  WITH CHECK ADD  CONSTRAINT [FK_OpEquipmentRequirement_EquipmentClass] FOREIGN KEY([EquipmentClassID])
REFERENCES [dbo].[EquipmentClass] ([ID])
GO
ALTER TABLE [dbo].[OpEquipmentRequirement] CHECK CONSTRAINT [FK_OpEquipmentRequirement_EquipmentClass]
GO
ALTER TABLE [dbo].[OpEquipmentRequirement]  WITH CHECK ADD  CONSTRAINT [FK_OpEquipmentRequirement_JobOrder] FOREIGN KEY([JobOrderID])
REFERENCES [dbo].[JobOrder] ([ID])
GO
ALTER TABLE [dbo].[OpEquipmentRequirement] CHECK CONSTRAINT [FK_OpEquipmentRequirement_JobOrder]
GO
ALTER TABLE [dbo].[OpEquipmentRequirement]  WITH CHECK ADD  CONSTRAINT [FK_OpEquipmentRequirement_SegmentRequirement] FOREIGN KEY([SegmenRequirementID])
REFERENCES [dbo].[OpSegmentRequirement] ([ID])
GO
ALTER TABLE [dbo].[OpEquipmentRequirement] CHECK CONSTRAINT [FK_OpEquipmentRequirement_SegmentRequirement]
GO
ALTER TABLE [dbo].[OpEquipmentSpecification]  WITH CHECK ADD  CONSTRAINT [FK_OpEquipmentSpecification_Equipment] FOREIGN KEY([EquipmentID])
REFERENCES [dbo].[Equipment] ([ID])
GO
ALTER TABLE [dbo].[OpEquipmentSpecification] CHECK CONSTRAINT [FK_OpEquipmentSpecification_Equipment]
GO
ALTER TABLE [dbo].[OpEquipmentSpecification]  WITH CHECK ADD  CONSTRAINT [FK_OpEquipmentSpecification_EquipmentClass] FOREIGN KEY([EquipmentClassID])
REFERENCES [dbo].[EquipmentClass] ([ID])
GO
ALTER TABLE [dbo].[OpEquipmentSpecification] CHECK CONSTRAINT [FK_OpEquipmentSpecification_EquipmentClass]
GO
ALTER TABLE [dbo].[OpEquipmentSpecification]  WITH CHECK ADD  CONSTRAINT [FK_OpEquipmentSpecification_OperationsSegment] FOREIGN KEY([OperationSegmentID])
REFERENCES [dbo].[OperationsSegment] ([ID])
GO
ALTER TABLE [dbo].[OpEquipmentSpecification] CHECK CONSTRAINT [FK_OpEquipmentSpecification_OperationsSegment]
GO
ALTER TABLE [dbo].[OpEquipmentSpecification]  WITH CHECK ADD  CONSTRAINT [FK_OpEquipmentSpecification_WorkDefinition] FOREIGN KEY([WorkDefinition])
REFERENCES [dbo].[WorkDefinition] ([ID])
GO
ALTER TABLE [dbo].[OpEquipmentSpecification] CHECK CONSTRAINT [FK_OpEquipmentSpecification_WorkDefinition]
GO
ALTER TABLE [dbo].[OperationsCapability]  WITH CHECK ADD  CONSTRAINT [FK_OperationsCapability_OperationsCapabilityInformation] FOREIGN KEY([OperationsCapabilityInformation])
REFERENCES [dbo].[OperationsCapabilityInformation] ([ID])
GO
ALTER TABLE [dbo].[OperationsCapability] CHECK CONSTRAINT [FK_OperationsCapability_OperationsCapabilityInformation]
GO
ALTER TABLE [dbo].[OperationsDefinition]  WITH CHECK ADD  CONSTRAINT [FK_OperationsDefinition_OperationsDefinitionInformation] FOREIGN KEY([OperationsDefinitionInformation])
REFERENCES [dbo].[OperationsDefinitionInformation] ([ID])
GO
ALTER TABLE [dbo].[OperationsDefinition] CHECK CONSTRAINT [FK_OperationsDefinition_OperationsDefinitionInformation]
GO
ALTER TABLE [dbo].[OperationsDefinition]  WITH CHECK ADD  CONSTRAINT [FK_OperationsDefinition_OperationsResponse] FOREIGN KEY([OperationsResponse])
REFERENCES [dbo].[OperationsResponse] ([ID])
GO
ALTER TABLE [dbo].[OperationsDefinition] CHECK CONSTRAINT [FK_OperationsDefinition_OperationsResponse]
GO
ALTER TABLE [dbo].[OperationsDefinition]  WITH CHECK ADD  CONSTRAINT [FK_OperationsDefinition_OpSegmentResponse] FOREIGN KEY([OpSegmentResponse])
REFERENCES [dbo].[OpSegmentResponse] ([ID])
GO
ALTER TABLE [dbo].[OperationsDefinition] CHECK CONSTRAINT [FK_OperationsDefinition_OpSegmentResponse]
GO
ALTER TABLE [dbo].[OperationsDefinitionRecord]  WITH CHECK ADD  CONSTRAINT [FK_OperationsDefinitionRecord_BatchProductionRecordEntry] FOREIGN KEY([BatchProductionRecordEntry])
REFERENCES [dbo].[BatchProductionRecordEntry] ([EntryID])
GO
ALTER TABLE [dbo].[OperationsDefinitionRecord] CHECK CONSTRAINT [FK_OperationsDefinitionRecord_BatchProductionRecordEntry]
GO
ALTER TABLE [dbo].[OperationsDefinitionRecord]  WITH CHECK ADD  CONSTRAINT [FK_OperationsDefinitionRecord_OperationsDefinition] FOREIGN KEY([OperationsDefinition])
REFERENCES [dbo].[OperationsDefinition] ([ID])
GO
ALTER TABLE [dbo].[OperationsDefinitionRecord] CHECK CONSTRAINT [FK_OperationsDefinitionRecord_OperationsDefinition]
GO
ALTER TABLE [dbo].[OperationsMaterialBill]  WITH CHECK ADD  CONSTRAINT [FK_OperationsMaterialBill_OperationsDefinition] FOREIGN KEY([OperationsDefinition])
REFERENCES [dbo].[OperationsDefinition] ([ID])
GO
ALTER TABLE [dbo].[OperationsMaterialBill] CHECK CONSTRAINT [FK_OperationsMaterialBill_OperationsDefinition]
GO
ALTER TABLE [dbo].[OperationsMaterialBillItem]  WITH CHECK ADD  CONSTRAINT [FK_OperationsMaterialBillItem_MaterialClass] FOREIGN KEY([MaterialClassID])
REFERENCES [dbo].[MaterialClass] ([ID])
GO
ALTER TABLE [dbo].[OperationsMaterialBillItem] CHECK CONSTRAINT [FK_OperationsMaterialBillItem_MaterialClass]
GO
ALTER TABLE [dbo].[OperationsMaterialBillItem]  WITH CHECK ADD  CONSTRAINT [FK_OperationsMaterialBillItem_MaterialDefinition] FOREIGN KEY([MaterialDefinitionID])
REFERENCES [dbo].[MaterialDefinition] ([ID])
GO
ALTER TABLE [dbo].[OperationsMaterialBillItem] CHECK CONSTRAINT [FK_OperationsMaterialBillItem_MaterialDefinition]
GO
ALTER TABLE [dbo].[OperationsMaterialBillItem]  WITH CHECK ADD  CONSTRAINT [FK_OperationsMaterialBillItem_OperationsMaterialBill] FOREIGN KEY([OperationsMaterialBill])
REFERENCES [dbo].[OperationsMaterialBill] ([ID])
GO
ALTER TABLE [dbo].[OperationsMaterialBillItem] CHECK CONSTRAINT [FK_OperationsMaterialBillItem_OperationsMaterialBill]
GO
ALTER TABLE [dbo].[OperationsMaterialBillItem]  WITH CHECK ADD  CONSTRAINT [FK_OperationsMaterialBillItem_OperationsMaterialBillItem] FOREIGN KEY([AssemblyBillOfMaterialItem])
REFERENCES [dbo].[OperationsMaterialBillItem] ([ID])
GO
ALTER TABLE [dbo].[OperationsMaterialBillItem] CHECK CONSTRAINT [FK_OperationsMaterialBillItem_OperationsMaterialBillItem]
GO
ALTER TABLE [dbo].[OperationsMaterialBillItem]  WITH CHECK ADD  CONSTRAINT [FK_OperationsMaterialBillItem_OpMaterialSpecification] FOREIGN KEY([MaterialSpecificationID])
REFERENCES [dbo].[OpMaterialSpecification] ([ID])
GO
ALTER TABLE [dbo].[OperationsMaterialBillItem] CHECK CONSTRAINT [FK_OperationsMaterialBillItem_OpMaterialSpecification]
GO
ALTER TABLE [dbo].[OperationsPerfomance]  WITH CHECK ADD  CONSTRAINT [FK_OperationsPerfomance_OperationsScedule] FOREIGN KEY([OperationsScheduleID])
REFERENCES [dbo].[OperationsScedule] ([ID])
GO
ALTER TABLE [dbo].[OperationsPerfomance] CHECK CONSTRAINT [FK_OperationsPerfomance_OperationsScedule]
GO
ALTER TABLE [dbo].[OperationsPerformanceRecord]  WITH CHECK ADD  CONSTRAINT [FK_OperationsPerformanceRecord_BatchProductionRecordEntry] FOREIGN KEY([BatchProductionRecordEntry])
REFERENCES [dbo].[BatchProductionRecordEntry] ([EntryID])
GO
ALTER TABLE [dbo].[OperationsPerformanceRecord] CHECK CONSTRAINT [FK_OperationsPerformanceRecord_BatchProductionRecordEntry]
GO
ALTER TABLE [dbo].[OperationsPerformanceRecord]  WITH CHECK ADD  CONSTRAINT [FK_OperationsPerformanceRecord_OperationsPerfomance] FOREIGN KEY([OperationsPerformance])
REFERENCES [dbo].[OperationsPerfomance] ([ID])
GO
ALTER TABLE [dbo].[OperationsPerformanceRecord] CHECK CONSTRAINT [FK_OperationsPerformanceRecord_OperationsPerfomance]
GO
ALTER TABLE [dbo].[OperationsRequest]  WITH CHECK ADD  CONSTRAINT [FK_OperationsRequest_OperationsDefinition] FOREIGN KEY([OperationsDefinitionID])
REFERENCES [dbo].[OperationsDefinition] ([ID])
GO
ALTER TABLE [dbo].[OperationsRequest] CHECK CONSTRAINT [FK_OperationsRequest_OperationsDefinition]
GO
ALTER TABLE [dbo].[OperationsRequest]  WITH CHECK ADD  CONSTRAINT [FK_OperationsRequest_OperationsResponse] FOREIGN KEY([OperationsResponse])
REFERENCES [dbo].[OperationsResponse] ([ID])
GO
ALTER TABLE [dbo].[OperationsRequest] CHECK CONSTRAINT [FK_OperationsRequest_OperationsResponse]
GO
ALTER TABLE [dbo].[OperationsRequest]  WITH CHECK ADD  CONSTRAINT [FK_OperationsRequest_OperationsScedule] FOREIGN KEY([OperationsSchedule])
REFERENCES [dbo].[OperationsScedule] ([ID])
GO
ALTER TABLE [dbo].[OperationsRequest] CHECK CONSTRAINT [FK_OperationsRequest_OperationsScedule]
GO
ALTER TABLE [dbo].[OperationsResponse]  WITH CHECK ADD  CONSTRAINT [FK_OperationsResponse_OperationsPerfomance] FOREIGN KEY([OperationsPerfomance])
REFERENCES [dbo].[OperationsPerfomance] ([ID])
GO
ALTER TABLE [dbo].[OperationsResponse] CHECK CONSTRAINT [FK_OperationsResponse_OperationsPerfomance]
GO
ALTER TABLE [dbo].[OperationsSceduleRecord]  WITH CHECK ADD  CONSTRAINT [FK_OperationsSceduleRecord_BatchProductionRecordEntry] FOREIGN KEY([BatchProductionRecordEntry])
REFERENCES [dbo].[BatchProductionRecordEntry] ([EntryID])
GO
ALTER TABLE [dbo].[OperationsSceduleRecord] CHECK CONSTRAINT [FK_OperationsSceduleRecord_BatchProductionRecordEntry]
GO
ALTER TABLE [dbo].[OperationsSceduleRecord]  WITH CHECK ADD  CONSTRAINT [FK_OperationsSceduleRecord_OperationsScedule] FOREIGN KEY([OperationsScedule])
REFERENCES [dbo].[OperationsScedule] ([ID])
GO
ALTER TABLE [dbo].[OperationsSceduleRecord] CHECK CONSTRAINT [FK_OperationsSceduleRecord_OperationsScedule]
GO
ALTER TABLE [dbo].[OperationsSegment]  WITH CHECK ADD  CONSTRAINT [FK_OperationsSegment_OperationsDefinition] FOREIGN KEY([OperationsDefinitionID])
REFERENCES [dbo].[OperationsDefinition] ([ID])
GO
ALTER TABLE [dbo].[OperationsSegment] CHECK CONSTRAINT [FK_OperationsSegment_OperationsDefinition]
GO
ALTER TABLE [dbo].[OperationsSegment]  WITH CHECK ADD  CONSTRAINT [FK_OperationsSegment_OperationsSegment] FOREIGN KEY([OperationsSegment])
REFERENCES [dbo].[OperationsSegment] ([ID])
GO
ALTER TABLE [dbo].[OperationsSegment] CHECK CONSTRAINT [FK_OperationsSegment_OperationsSegment]
GO
ALTER TABLE [dbo].[OpMaterialActual]  WITH CHECK ADD  CONSTRAINT [FK_OpMaterialActual_JobResponse] FOREIGN KEY([JobResponseID])
REFERENCES [dbo].[JobResponse] ([ID])
GO
ALTER TABLE [dbo].[OpMaterialActual] CHECK CONSTRAINT [FK_OpMaterialActual_JobResponse]
GO
ALTER TABLE [dbo].[OpMaterialActual]  WITH CHECK ADD  CONSTRAINT [FK_OpMaterialActual_MaterialClass] FOREIGN KEY([MaterialClassID])
REFERENCES [dbo].[MaterialClass] ([ID])
GO
ALTER TABLE [dbo].[OpMaterialActual] CHECK CONSTRAINT [FK_OpMaterialActual_MaterialClass]
GO
ALTER TABLE [dbo].[OpMaterialActual]  WITH CHECK ADD  CONSTRAINT [FK_OpMaterialActual_MaterialDefinition] FOREIGN KEY([MaterialDefinitionID])
REFERENCES [dbo].[MaterialDefinition] ([ID])
GO
ALTER TABLE [dbo].[OpMaterialActual] CHECK CONSTRAINT [FK_OpMaterialActual_MaterialDefinition]
GO
ALTER TABLE [dbo].[OpMaterialActual]  WITH CHECK ADD  CONSTRAINT [FK_OpMaterialActual_MaterialLot] FOREIGN KEY([MaterialLotID])
REFERENCES [dbo].[MaterialLot] ([ID])
GO
ALTER TABLE [dbo].[OpMaterialActual] CHECK CONSTRAINT [FK_OpMaterialActual_MaterialLot]
GO
ALTER TABLE [dbo].[OpMaterialActual]  WITH CHECK ADD  CONSTRAINT [FK_OpMaterialActual_MateriaSubLot] FOREIGN KEY([MaterialSubLotID])
REFERENCES [dbo].[MaterialSubLot] ([ID])
GO
ALTER TABLE [dbo].[OpMaterialActual] CHECK CONSTRAINT [FK_OpMaterialActual_MateriaSubLot]
GO
ALTER TABLE [dbo].[OpMaterialActual]  WITH CHECK ADD  CONSTRAINT [FK_OpMaterialActual_OpMaterialActual] FOREIGN KEY([AssemblyActual])
REFERENCES [dbo].[OpMaterialActual] ([ID])
GO
ALTER TABLE [dbo].[OpMaterialActual] CHECK CONSTRAINT [FK_OpMaterialActual_OpMaterialActual]
GO
ALTER TABLE [dbo].[OpMaterialActual]  WITH CHECK ADD  CONSTRAINT [FK_OpMaterialActual_SegmentResponse] FOREIGN KEY([SegmentResponseID])
REFERENCES [dbo].[OpSegmentResponse] ([ID])
GO
ALTER TABLE [dbo].[OpMaterialActual] CHECK CONSTRAINT [FK_OpMaterialActual_SegmentResponse]
GO
ALTER TABLE [dbo].[OpMaterialCapability]  WITH CHECK ADD  CONSTRAINT [FK_OpMaterialCapability_MaterialClass] FOREIGN KEY([MaterialClassID])
REFERENCES [dbo].[MaterialClass] ([ID])
GO
ALTER TABLE [dbo].[OpMaterialCapability] CHECK CONSTRAINT [FK_OpMaterialCapability_MaterialClass]
GO
ALTER TABLE [dbo].[OpMaterialCapability]  WITH CHECK ADD  CONSTRAINT [FK_OpMaterialCapability_MaterialDefinition] FOREIGN KEY([MaterialDefinitionID])
REFERENCES [dbo].[MaterialDefinition] ([ID])
GO
ALTER TABLE [dbo].[OpMaterialCapability] CHECK CONSTRAINT [FK_OpMaterialCapability_MaterialDefinition]
GO
ALTER TABLE [dbo].[OpMaterialCapability]  WITH CHECK ADD  CONSTRAINT [FK_OpMaterialCapability_MaterialLot] FOREIGN KEY([MaterialLotID])
REFERENCES [dbo].[MaterialLot] ([ID])
GO
ALTER TABLE [dbo].[OpMaterialCapability] CHECK CONSTRAINT [FK_OpMaterialCapability_MaterialLot]
GO
ALTER TABLE [dbo].[OpMaterialCapability]  WITH CHECK ADD  CONSTRAINT [FK_OpMaterialCapability_MateriaSubLot] FOREIGN KEY([MaterialSubLotID])
REFERENCES [dbo].[MaterialSubLot] ([ID])
GO
ALTER TABLE [dbo].[OpMaterialCapability] CHECK CONSTRAINT [FK_OpMaterialCapability_MateriaSubLot]
GO
ALTER TABLE [dbo].[OpMaterialCapability]  WITH CHECK ADD  CONSTRAINT [FK_OpMaterialCapability_OperationsCapability] FOREIGN KEY([OperationCapabilityID])
REFERENCES [dbo].[OperationsCapability] ([ID])
GO
ALTER TABLE [dbo].[OpMaterialCapability] CHECK CONSTRAINT [FK_OpMaterialCapability_OperationsCapability]
GO
ALTER TABLE [dbo].[OpMaterialCapability]  WITH CHECK ADD  CONSTRAINT [FK_OpMaterialCapability_OpMaterialCapability] FOREIGN KEY([AssemblyCapability])
REFERENCES [dbo].[OpMaterialCapability] ([ID])
GO
ALTER TABLE [dbo].[OpMaterialCapability] CHECK CONSTRAINT [FK_OpMaterialCapability_OpMaterialCapability]
GO
ALTER TABLE [dbo].[OpMaterialCapability]  WITH CHECK ADD  CONSTRAINT [FK_OpMaterialCapability_ProcessSegmentCapability] FOREIGN KEY([ProcessSegmentCapabilityID])
REFERENCES [dbo].[OpProcessSegmentCapability] ([ID])
GO
ALTER TABLE [dbo].[OpMaterialCapability] CHECK CONSTRAINT [FK_OpMaterialCapability_ProcessSegmentCapability]
GO
ALTER TABLE [dbo].[OpMaterialCapability]  WITH CHECK ADD  CONSTRAINT [FK_OpMaterialCapability_WorkCapability] FOREIGN KEY([WorkCapabilityID])
REFERENCES [dbo].[WorkCapability] ([ID])
GO
ALTER TABLE [dbo].[OpMaterialCapability] CHECK CONSTRAINT [FK_OpMaterialCapability_WorkCapability]
GO
ALTER TABLE [dbo].[OpMaterialCapability]  WITH CHECK ADD  CONSTRAINT [FK_OpMaterialCapability_WorkMasterCapability] FOREIGN KEY([WorkMasterCapabilityID])
REFERENCES [dbo].[WorkMasterCapability] ([ID])
GO
ALTER TABLE [dbo].[OpMaterialCapability] CHECK CONSTRAINT [FK_OpMaterialCapability_WorkMasterCapability]
GO
ALTER TABLE [dbo].[OpMaterialRequirement]  WITH CHECK ADD  CONSTRAINT [FK_OpMaterialRequirement_JobOrder] FOREIGN KEY([JobOrderID])
REFERENCES [dbo].[JobOrder] ([ID])
GO
ALTER TABLE [dbo].[OpMaterialRequirement] CHECK CONSTRAINT [FK_OpMaterialRequirement_JobOrder]
GO
ALTER TABLE [dbo].[OpMaterialRequirement]  WITH CHECK ADD  CONSTRAINT [FK_OpMaterialRequirement_MaterialClass] FOREIGN KEY([MaterialClassID])
REFERENCES [dbo].[MaterialClass] ([ID])
GO
ALTER TABLE [dbo].[OpMaterialRequirement] CHECK CONSTRAINT [FK_OpMaterialRequirement_MaterialClass]
GO
ALTER TABLE [dbo].[OpMaterialRequirement]  WITH CHECK ADD  CONSTRAINT [FK_OpMaterialRequirement_MaterialDefinition] FOREIGN KEY([MaterialDefinitionID])
REFERENCES [dbo].[MaterialDefinition] ([ID])
GO
ALTER TABLE [dbo].[OpMaterialRequirement] CHECK CONSTRAINT [FK_OpMaterialRequirement_MaterialDefinition]
GO
ALTER TABLE [dbo].[OpMaterialRequirement]  WITH CHECK ADD  CONSTRAINT [FK_OpMaterialRequirement_MaterialLot] FOREIGN KEY([MaterialLotID])
REFERENCES [dbo].[MaterialLot] ([ID])
GO
ALTER TABLE [dbo].[OpMaterialRequirement] CHECK CONSTRAINT [FK_OpMaterialRequirement_MaterialLot]
GO
ALTER TABLE [dbo].[OpMaterialRequirement]  WITH CHECK ADD  CONSTRAINT [FK_OpMaterialRequirement_MateriaSubLot] FOREIGN KEY([MaterialSubLotID])
REFERENCES [dbo].[MaterialSubLot] ([ID])
GO
ALTER TABLE [dbo].[OpMaterialRequirement] CHECK CONSTRAINT [FK_OpMaterialRequirement_MateriaSubLot]
GO
ALTER TABLE [dbo].[OpMaterialRequirement]  WITH CHECK ADD  CONSTRAINT [FK_OpMaterialRequirement_OpMaterialRequirement] FOREIGN KEY([AssemblyRequirement])
REFERENCES [dbo].[OpMaterialRequirement] ([ID])
GO
ALTER TABLE [dbo].[OpMaterialRequirement] CHECK CONSTRAINT [FK_OpMaterialRequirement_OpMaterialRequirement]
GO
ALTER TABLE [dbo].[OpMaterialRequirement]  WITH CHECK ADD  CONSTRAINT [FK_OpMaterialRequirement_SegmentRequirement] FOREIGN KEY([SegmenRequirementID])
REFERENCES [dbo].[OpSegmentRequirement] ([ID])
GO
ALTER TABLE [dbo].[OpMaterialRequirement] CHECK CONSTRAINT [FK_OpMaterialRequirement_SegmentRequirement]
GO
ALTER TABLE [dbo].[OpMaterialSpecification]  WITH CHECK ADD  CONSTRAINT [FK_OpMaterialSpecification_MaterialClass] FOREIGN KEY([MaterialClassID])
REFERENCES [dbo].[MaterialClass] ([ID])
GO
ALTER TABLE [dbo].[OpMaterialSpecification] CHECK CONSTRAINT [FK_OpMaterialSpecification_MaterialClass]
GO
ALTER TABLE [dbo].[OpMaterialSpecification]  WITH CHECK ADD  CONSTRAINT [FK_OpMaterialSpecification_MaterialDefinition] FOREIGN KEY([MaterialDefinitionID])
REFERENCES [dbo].[MaterialDefinition] ([ID])
GO
ALTER TABLE [dbo].[OpMaterialSpecification] CHECK CONSTRAINT [FK_OpMaterialSpecification_MaterialDefinition]
GO
ALTER TABLE [dbo].[OpMaterialSpecification]  WITH CHECK ADD  CONSTRAINT [FK_OpMaterialSpecification_OperationsSegment] FOREIGN KEY([OperationsSegment])
REFERENCES [dbo].[OperationsSegment] ([ID])
GO
ALTER TABLE [dbo].[OpMaterialSpecification] CHECK CONSTRAINT [FK_OpMaterialSpecification_OperationsSegment]
GO
ALTER TABLE [dbo].[OpMaterialSpecification]  WITH CHECK ADD  CONSTRAINT [FK_OpMaterialSpecification_OpMaterialSpecification] FOREIGN KEY([AssemblySpecification])
REFERENCES [dbo].[OpMaterialSpecification] ([ID])
GO
ALTER TABLE [dbo].[OpMaterialSpecification] CHECK CONSTRAINT [FK_OpMaterialSpecification_OpMaterialSpecification]
GO
ALTER TABLE [dbo].[OpMaterialSpecification]  WITH CHECK ADD  CONSTRAINT [FK_OpMaterialSpecification_WorkDefinition] FOREIGN KEY([WorkDefinition])
REFERENCES [dbo].[WorkDefinition] ([ID])
GO
ALTER TABLE [dbo].[OpMaterialSpecification] CHECK CONSTRAINT [FK_OpMaterialSpecification_WorkDefinition]
GO
ALTER TABLE [dbo].[OpPersonnelActual]  WITH CHECK ADD  CONSTRAINT [FK_OpPersonnelActual_JobResponse] FOREIGN KEY([JobResponseID])
REFERENCES [dbo].[JobResponse] ([ID])
GO
ALTER TABLE [dbo].[OpPersonnelActual] CHECK CONSTRAINT [FK_OpPersonnelActual_JobResponse]
GO
ALTER TABLE [dbo].[OpPersonnelActual]  WITH CHECK ADD  CONSTRAINT [FK_OpPersonnelActual_Person] FOREIGN KEY([PersonID])
REFERENCES [dbo].[Person] ([ID])
GO
ALTER TABLE [dbo].[OpPersonnelActual] CHECK CONSTRAINT [FK_OpPersonnelActual_Person]
GO
ALTER TABLE [dbo].[OpPersonnelActual]  WITH CHECK ADD  CONSTRAINT [FK_OpPersonnelActual_PersonnelClass] FOREIGN KEY([PersonnelClassID])
REFERENCES [dbo].[PersonnelClass] ([ID])
GO
ALTER TABLE [dbo].[OpPersonnelActual] CHECK CONSTRAINT [FK_OpPersonnelActual_PersonnelClass]
GO
ALTER TABLE [dbo].[OpPersonnelActual]  WITH CHECK ADD  CONSTRAINT [FK_OpPersonnelActual_SegmentResponse] FOREIGN KEY([SegmentResponseID])
REFERENCES [dbo].[OpSegmentResponse] ([ID])
GO
ALTER TABLE [dbo].[OpPersonnelActual] CHECK CONSTRAINT [FK_OpPersonnelActual_SegmentResponse]
GO
ALTER TABLE [dbo].[OpPersonnelCapability]  WITH CHECK ADD  CONSTRAINT [FK_OpPersonnelCapability_OperationsCapability] FOREIGN KEY([OperationCapabilityID])
REFERENCES [dbo].[OperationsCapability] ([ID])
GO
ALTER TABLE [dbo].[OpPersonnelCapability] CHECK CONSTRAINT [FK_OpPersonnelCapability_OperationsCapability]
GO
ALTER TABLE [dbo].[OpPersonnelCapability]  WITH CHECK ADD  CONSTRAINT [FK_OpPersonnelCapability_Person] FOREIGN KEY([PersonID])
REFERENCES [dbo].[Person] ([ID])
GO
ALTER TABLE [dbo].[OpPersonnelCapability] CHECK CONSTRAINT [FK_OpPersonnelCapability_Person]
GO
ALTER TABLE [dbo].[OpPersonnelCapability]  WITH CHECK ADD  CONSTRAINT [FK_OpPersonnelCapability_PersonnelClass] FOREIGN KEY([PersonnelClassID])
REFERENCES [dbo].[PersonnelClass] ([ID])
GO
ALTER TABLE [dbo].[OpPersonnelCapability] CHECK CONSTRAINT [FK_OpPersonnelCapability_PersonnelClass]
GO
ALTER TABLE [dbo].[OpPersonnelCapability]  WITH CHECK ADD  CONSTRAINT [FK_OpPersonnelCapability_ProcessSegmentCapability] FOREIGN KEY([ProcessSegmentCapabilityID])
REFERENCES [dbo].[OpProcessSegmentCapability] ([ID])
GO
ALTER TABLE [dbo].[OpPersonnelCapability] CHECK CONSTRAINT [FK_OpPersonnelCapability_ProcessSegmentCapability]
GO
ALTER TABLE [dbo].[OpPersonnelCapability]  WITH CHECK ADD  CONSTRAINT [FK_OpPersonnelCapability_WorkCapability] FOREIGN KEY([WorkCapabilityID])
REFERENCES [dbo].[WorkCapability] ([ID])
GO
ALTER TABLE [dbo].[OpPersonnelCapability] CHECK CONSTRAINT [FK_OpPersonnelCapability_WorkCapability]
GO
ALTER TABLE [dbo].[OpPersonnelCapability]  WITH CHECK ADD  CONSTRAINT [FK_OpPersonnelCapability_WorkMasterCapability] FOREIGN KEY([WorkMasterCapabilityID])
REFERENCES [dbo].[WorkMasterCapability] ([ID])
GO
ALTER TABLE [dbo].[OpPersonnelCapability] CHECK CONSTRAINT [FK_OpPersonnelCapability_WorkMasterCapability]
GO
ALTER TABLE [dbo].[OpPersonnelRequirement]  WITH CHECK ADD  CONSTRAINT [FK_OpPersonnelRequirement_JobOrder] FOREIGN KEY([JobOrderID])
REFERENCES [dbo].[JobOrder] ([ID])
GO
ALTER TABLE [dbo].[OpPersonnelRequirement] CHECK CONSTRAINT [FK_OpPersonnelRequirement_JobOrder]
GO
ALTER TABLE [dbo].[OpPersonnelRequirement]  WITH CHECK ADD  CONSTRAINT [FK_OpPersonnelRequirement_Person] FOREIGN KEY([PersonID])
REFERENCES [dbo].[Person] ([ID])
GO
ALTER TABLE [dbo].[OpPersonnelRequirement] CHECK CONSTRAINT [FK_OpPersonnelRequirement_Person]
GO
ALTER TABLE [dbo].[OpPersonnelRequirement]  WITH CHECK ADD  CONSTRAINT [FK_OpPersonnelRequirement_PersonnelClass] FOREIGN KEY([PersonnelClassID])
REFERENCES [dbo].[PersonnelClass] ([ID])
GO
ALTER TABLE [dbo].[OpPersonnelRequirement] CHECK CONSTRAINT [FK_OpPersonnelRequirement_PersonnelClass]
GO
ALTER TABLE [dbo].[OpPersonnelRequirement]  WITH CHECK ADD  CONSTRAINT [FK_OpPersonnelRequirement_SegmentRequirement] FOREIGN KEY([SegmenRequirementID])
REFERENCES [dbo].[OpSegmentRequirement] ([ID])
GO
ALTER TABLE [dbo].[OpPersonnelRequirement] CHECK CONSTRAINT [FK_OpPersonnelRequirement_SegmentRequirement]
GO
ALTER TABLE [dbo].[OpPersonnelSpecification]  WITH CHECK ADD  CONSTRAINT [FK_OpPersonnelSpecification_OperationsSegment] FOREIGN KEY([OperationSegmentID])
REFERENCES [dbo].[OperationsSegment] ([ID])
GO
ALTER TABLE [dbo].[OpPersonnelSpecification] CHECK CONSTRAINT [FK_OpPersonnelSpecification_OperationsSegment]
GO
ALTER TABLE [dbo].[OpPersonnelSpecification]  WITH CHECK ADD  CONSTRAINT [FK_OpPersonnelSpecification_Person] FOREIGN KEY([PersonID])
REFERENCES [dbo].[Person] ([ID])
GO
ALTER TABLE [dbo].[OpPersonnelSpecification] CHECK CONSTRAINT [FK_OpPersonnelSpecification_Person]
GO
ALTER TABLE [dbo].[OpPersonnelSpecification]  WITH CHECK ADD  CONSTRAINT [FK_OpPersonnelSpecification_PersonnelClass] FOREIGN KEY([PersonnelClassID])
REFERENCES [dbo].[PersonnelClass] ([ID])
GO
ALTER TABLE [dbo].[OpPersonnelSpecification] CHECK CONSTRAINT [FK_OpPersonnelSpecification_PersonnelClass]
GO
ALTER TABLE [dbo].[OpPersonnelSpecification]  WITH CHECK ADD  CONSTRAINT [FK_OpPersonnelSpecification_WorkDefinition] FOREIGN KEY([WorkDefinition])
REFERENCES [dbo].[WorkDefinition] ([ID])
GO
ALTER TABLE [dbo].[OpPersonnelSpecification] CHECK CONSTRAINT [FK_OpPersonnelSpecification_WorkDefinition]
GO
ALTER TABLE [dbo].[OpPhysicalAssetActual]  WITH CHECK ADD  CONSTRAINT [FK_OpPhysicalAssetActual_JobResponse] FOREIGN KEY([JobResponseID])
REFERENCES [dbo].[JobResponse] ([ID])
GO
ALTER TABLE [dbo].[OpPhysicalAssetActual] CHECK CONSTRAINT [FK_OpPhysicalAssetActual_JobResponse]
GO
ALTER TABLE [dbo].[OpPhysicalAssetActual]  WITH CHECK ADD  CONSTRAINT [FK_OpPhysicalAssetActual_OpPhysicalAssetActual] FOREIGN KEY([SegmentResponseID])
REFERENCES [dbo].[OpSegmentResponse] ([ID])
GO
ALTER TABLE [dbo].[OpPhysicalAssetActual] CHECK CONSTRAINT [FK_OpPhysicalAssetActual_OpPhysicalAssetActual]
GO
ALTER TABLE [dbo].[OpPhysicalAssetActual]  WITH CHECK ADD  CONSTRAINT [FK_OpPhysicalAssetActual_PhysicalAsset] FOREIGN KEY([PhysicalAssetID])
REFERENCES [dbo].[PhysicalAsset] ([ID])
GO
ALTER TABLE [dbo].[OpPhysicalAssetActual] CHECK CONSTRAINT [FK_OpPhysicalAssetActual_PhysicalAsset]
GO
ALTER TABLE [dbo].[OpPhysicalAssetActual]  WITH CHECK ADD  CONSTRAINT [FK_OpPhysicalAssetActual_PhysicalAssetClass] FOREIGN KEY([PhysicalAssetClassID])
REFERENCES [dbo].[PhysicalAssetClass] ([ID])
GO
ALTER TABLE [dbo].[OpPhysicalAssetActual] CHECK CONSTRAINT [FK_OpPhysicalAssetActual_PhysicalAssetClass]
GO
ALTER TABLE [dbo].[OpPhysicalAssetCapability]  WITH CHECK ADD  CONSTRAINT [FK_OpPhysicalAssetCapability_OperationsCapability] FOREIGN KEY([OperationCapabilityID])
REFERENCES [dbo].[OperationsCapability] ([ID])
GO
ALTER TABLE [dbo].[OpPhysicalAssetCapability] CHECK CONSTRAINT [FK_OpPhysicalAssetCapability_OperationsCapability]
GO
ALTER TABLE [dbo].[OpPhysicalAssetCapability]  WITH CHECK ADD  CONSTRAINT [FK_OpPhysicalAssetCapability_PhysicalAsset] FOREIGN KEY([PhysicalAssetID])
REFERENCES [dbo].[PhysicalAsset] ([ID])
GO
ALTER TABLE [dbo].[OpPhysicalAssetCapability] CHECK CONSTRAINT [FK_OpPhysicalAssetCapability_PhysicalAsset]
GO
ALTER TABLE [dbo].[OpPhysicalAssetCapability]  WITH CHECK ADD  CONSTRAINT [FK_OpPhysicalAssetCapability_PhysicalAssetClass] FOREIGN KEY([PhysicalAssetClassID])
REFERENCES [dbo].[PhysicalAssetClass] ([ID])
GO
ALTER TABLE [dbo].[OpPhysicalAssetCapability] CHECK CONSTRAINT [FK_OpPhysicalAssetCapability_PhysicalAssetClass]
GO
ALTER TABLE [dbo].[OpPhysicalAssetCapability]  WITH CHECK ADD  CONSTRAINT [FK_OpPhysicalAssetCapability_ProcessSegmentCapability] FOREIGN KEY([ProcessSegmentCapabilityID])
REFERENCES [dbo].[OpProcessSegmentCapability] ([ID])
GO
ALTER TABLE [dbo].[OpPhysicalAssetCapability] CHECK CONSTRAINT [FK_OpPhysicalAssetCapability_ProcessSegmentCapability]
GO
ALTER TABLE [dbo].[OpPhysicalAssetCapability]  WITH CHECK ADD  CONSTRAINT [FK_OpPhysicalAssetCapability_WorkCapability] FOREIGN KEY([WorkCapabilityID])
REFERENCES [dbo].[WorkCapability] ([ID])
GO
ALTER TABLE [dbo].[OpPhysicalAssetCapability] CHECK CONSTRAINT [FK_OpPhysicalAssetCapability_WorkCapability]
GO
ALTER TABLE [dbo].[OpPhysicalAssetCapability]  WITH CHECK ADD  CONSTRAINT [FK_OpPhysicalAssetCapability_WorkMasterCapability] FOREIGN KEY([WorkMasterCapabilityID])
REFERENCES [dbo].[WorkMasterCapability] ([ID])
GO
ALTER TABLE [dbo].[OpPhysicalAssetCapability] CHECK CONSTRAINT [FK_OpPhysicalAssetCapability_WorkMasterCapability]
GO
ALTER TABLE [dbo].[OpPhysicalAssetRequirement]  WITH CHECK ADD  CONSTRAINT [FK_OpPhysicalAssetRequirement_JobOrder] FOREIGN KEY([JobOrderID])
REFERENCES [dbo].[JobOrder] ([ID])
GO
ALTER TABLE [dbo].[OpPhysicalAssetRequirement] CHECK CONSTRAINT [FK_OpPhysicalAssetRequirement_JobOrder]
GO
ALTER TABLE [dbo].[OpPhysicalAssetRequirement]  WITH CHECK ADD  CONSTRAINT [FK_OpPhysicalAssetRequirement_PhysicalAsset] FOREIGN KEY([PhysicalAssetID])
REFERENCES [dbo].[PhysicalAsset] ([ID])
GO
ALTER TABLE [dbo].[OpPhysicalAssetRequirement] CHECK CONSTRAINT [FK_OpPhysicalAssetRequirement_PhysicalAsset]
GO
ALTER TABLE [dbo].[OpPhysicalAssetRequirement]  WITH CHECK ADD  CONSTRAINT [FK_OpPhysicalAssetRequirement_PhysicalAssetClass] FOREIGN KEY([PhysicalAssetClassID])
REFERENCES [dbo].[PhysicalAssetClass] ([ID])
GO
ALTER TABLE [dbo].[OpPhysicalAssetRequirement] CHECK CONSTRAINT [FK_OpPhysicalAssetRequirement_PhysicalAssetClass]
GO
ALTER TABLE [dbo].[OpPhysicalAssetRequirement]  WITH CHECK ADD  CONSTRAINT [FK_OpPhysicalAssetRequirement_SegmentRequirement] FOREIGN KEY([SegmenRequirementID])
REFERENCES [dbo].[OpSegmentRequirement] ([ID])
GO
ALTER TABLE [dbo].[OpPhysicalAssetRequirement] CHECK CONSTRAINT [FK_OpPhysicalAssetRequirement_SegmentRequirement]
GO
ALTER TABLE [dbo].[OpPhysicalAssetSpecification]  WITH CHECK ADD  CONSTRAINT [FK_OpPhysicalAssetSpecification_OperationsSegment] FOREIGN KEY([OperationSegmentID])
REFERENCES [dbo].[OperationsSegment] ([ID])
GO
ALTER TABLE [dbo].[OpPhysicalAssetSpecification] CHECK CONSTRAINT [FK_OpPhysicalAssetSpecification_OperationsSegment]
GO
ALTER TABLE [dbo].[OpPhysicalAssetSpecification]  WITH CHECK ADD  CONSTRAINT [FK_OpPhysicalAssetSpecification_PhysicalAsset] FOREIGN KEY([PhysicalAssetID])
REFERENCES [dbo].[PhysicalAsset] ([ID])
GO
ALTER TABLE [dbo].[OpPhysicalAssetSpecification] CHECK CONSTRAINT [FK_OpPhysicalAssetSpecification_PhysicalAsset]
GO
ALTER TABLE [dbo].[OpPhysicalAssetSpecification]  WITH CHECK ADD  CONSTRAINT [FK_OpPhysicalAssetSpecification_PhysicalAssetClass] FOREIGN KEY([PhysicalAssetClassID])
REFERENCES [dbo].[PhysicalAssetClass] ([ID])
GO
ALTER TABLE [dbo].[OpPhysicalAssetSpecification] CHECK CONSTRAINT [FK_OpPhysicalAssetSpecification_PhysicalAssetClass]
GO
ALTER TABLE [dbo].[OpPhysicalAssetSpecification]  WITH CHECK ADD  CONSTRAINT [FK_OpPhysicalAssetSpecification_WorkDefinition] FOREIGN KEY([WorkDefinition])
REFERENCES [dbo].[WorkDefinition] ([ID])
GO
ALTER TABLE [dbo].[OpPhysicalAssetSpecification] CHECK CONSTRAINT [FK_OpPhysicalAssetSpecification_WorkDefinition]
GO
ALTER TABLE [dbo].[OpProcessSegmentCapability]  WITH CHECK ADD  CONSTRAINT [FK_OpProcessSegmentCapability_OperationsCapability] FOREIGN KEY([OpetationCapability])
REFERENCES [dbo].[OperationsCapability] ([ID])
GO
ALTER TABLE [dbo].[OpProcessSegmentCapability] CHECK CONSTRAINT [FK_OpProcessSegmentCapability_OperationsCapability]
GO
ALTER TABLE [dbo].[OpProcessSegmentCapability]  WITH CHECK ADD  CONSTRAINT [FK_OpProcessSegmentCapability_OpProcessSegmentCapability] FOREIGN KEY([ProcessSegmentCapability])
REFERENCES [dbo].[OpProcessSegmentCapability] ([ID])
GO
ALTER TABLE [dbo].[OpProcessSegmentCapability] CHECK CONSTRAINT [FK_OpProcessSegmentCapability_OpProcessSegmentCapability]
GO
ALTER TABLE [dbo].[OpSegmentData]  WITH CHECK ADD  CONSTRAINT [FK_OpSegmentData_JobResponsetData] FOREIGN KEY([JobResponseData])
REFERENCES [dbo].[JobResponsetData] ([ID])
GO
ALTER TABLE [dbo].[OpSegmentData] CHECK CONSTRAINT [FK_OpSegmentData_JobResponsetData]
GO
ALTER TABLE [dbo].[OpSegmentData]  WITH CHECK ADD  CONSTRAINT [FK_OpSegmentData_OpSegmentResponse] FOREIGN KEY([OpSegmentResponse])
REFERENCES [dbo].[OpSegmentResponse] ([ID])
GO
ALTER TABLE [dbo].[OpSegmentData] CHECK CONSTRAINT [FK_OpSegmentData_OpSegmentResponse]
GO
ALTER TABLE [dbo].[OpSegmentRequirement]  WITH CHECK ADD  CONSTRAINT [FK_OpSegmentRequirement_OperationsDefinition] FOREIGN KEY([OperationsDefinitionID])
REFERENCES [dbo].[OperationsDefinition] ([ID])
GO
ALTER TABLE [dbo].[OpSegmentRequirement] CHECK CONSTRAINT [FK_OpSegmentRequirement_OperationsDefinition]
GO
ALTER TABLE [dbo].[OpSegmentRequirement]  WITH CHECK ADD  CONSTRAINT [FK_OpSegmentRequirement_OperationsRequest] FOREIGN KEY([OperationsRequest])
REFERENCES [dbo].[OperationsRequest] ([ID])
GO
ALTER TABLE [dbo].[OpSegmentRequirement] CHECK CONSTRAINT [FK_OpSegmentRequirement_OperationsRequest]
GO
ALTER TABLE [dbo].[OpSegmentRequirement]  WITH CHECK ADD  CONSTRAINT [FK_OpSegmentRequirement_OpSegmentRequirement] FOREIGN KEY([SegmentRequirement])
REFERENCES [dbo].[OpSegmentRequirement] ([ID])
GO
ALTER TABLE [dbo].[OpSegmentRequirement] CHECK CONSTRAINT [FK_OpSegmentRequirement_OpSegmentRequirement]
GO
ALTER TABLE [dbo].[OpSegmentRequirement]  WITH CHECK ADD  CONSTRAINT [FK_OpSegmentRequirement_ProcessSegment] FOREIGN KEY([ProcessSegmentID])
REFERENCES [dbo].[ProcessSegment] ([ID])
GO
ALTER TABLE [dbo].[OpSegmentRequirement] CHECK CONSTRAINT [FK_OpSegmentRequirement_ProcessSegment]
GO
ALTER TABLE [dbo].[OpSegmentResponse]  WITH CHECK ADD  CONSTRAINT [FK_OpSegmentResponse_OperationsRequest] FOREIGN KEY([OperationsRequested])
REFERENCES [dbo].[OperationsRequest] ([ID])
GO
ALTER TABLE [dbo].[OpSegmentResponse] CHECK CONSTRAINT [FK_OpSegmentResponse_OperationsRequest]
GO
ALTER TABLE [dbo].[OpSegmentResponse]  WITH CHECK ADD  CONSTRAINT [FK_OpSegmentResponse_OperationsResponse] FOREIGN KEY([OperationsResponse])
REFERENCES [dbo].[OperationsResponse] ([ID])
GO
ALTER TABLE [dbo].[OpSegmentResponse] CHECK CONSTRAINT [FK_OpSegmentResponse_OperationsResponse]
GO
ALTER TABLE [dbo].[OpSegmentResponse]  WITH CHECK ADD  CONSTRAINT [FK_OpSegmentResponse_OpSegmentResponse] FOREIGN KEY([SegmentResponse])
REFERENCES [dbo].[OpSegmentResponse] ([ID])
GO
ALTER TABLE [dbo].[OpSegmentResponse] CHECK CONSTRAINT [FK_OpSegmentResponse_OpSegmentResponse]
GO
ALTER TABLE [dbo].[OrderedData]  WITH CHECK ADD  CONSTRAINT [FK_OrderedData_DataSet] FOREIGN KEY([DataSet])
REFERENCES [dbo].[DataSet] ([ID])
GO
ALTER TABLE [dbo].[OrderedData] CHECK CONSTRAINT [FK_OrderedData_DataSet]
GO
ALTER TABLE [dbo].[OtherInformation]  WITH CHECK ADD  CONSTRAINT [FK_OtherInformation_GRecipe] FOREIGN KEY([GRecipe])
REFERENCES [dbo].[GRecipe] ([ID])
GO
ALTER TABLE [dbo].[OtherInformation] CHECK CONSTRAINT [FK_OtherInformation_GRecipe]
GO
ALTER TABLE [dbo].[OtherInformation]  WITH CHECK ADD  CONSTRAINT [FK_OtherInformation_ProcessElement] FOREIGN KEY([ProcessElement])
REFERENCES [dbo].[ProcessElement] ([ID])
GO
ALTER TABLE [dbo].[OtherInformation] CHECK CONSTRAINT [FK_OtherInformation_ProcessElement]
GO
ALTER TABLE [dbo].[OtherInformation]  WITH CHECK ADD  CONSTRAINT [FK_OtherInformation_Value] FOREIGN KEY([OtherValue])
REFERENCES [dbo].[Value] ([ValueString])
GO
ALTER TABLE [dbo].[OtherInformation] CHECK CONSTRAINT [FK_OtherInformation_Value]
GO
ALTER TABLE [dbo].[Parameter]  WITH CHECK ADD  CONSTRAINT [FK_Parameter_JobOrder] FOREIGN KEY([JobOrder])
REFERENCES [dbo].[JobOrder] ([ID])
GO
ALTER TABLE [dbo].[Parameter] CHECK CONSTRAINT [FK_Parameter_JobOrder]
GO
ALTER TABLE [dbo].[Parameter]  WITH CHECK ADD  CONSTRAINT [FK_Parameter_Parameter] FOREIGN KEY([Parameter])
REFERENCES [dbo].[Parameter] ([ID])
GO
ALTER TABLE [dbo].[Parameter] CHECK CONSTRAINT [FK_Parameter_Parameter]
GO
ALTER TABLE [dbo].[Person]  WITH CHECK ADD  CONSTRAINT [FK_Person_PersonnelClass] FOREIGN KEY([PersonnelClassID])
REFERENCES [dbo].[PersonnelClass] ([ID])
GO
ALTER TABLE [dbo].[Person] CHECK CONSTRAINT [FK_Person_PersonnelClass]
GO
ALTER TABLE [dbo].[Person]  WITH CHECK ADD  CONSTRAINT [FK_Person_PersonnelInformation] FOREIGN KEY([PersonnelInformation])
REFERENCES [dbo].[PersonnelInformation] ([ID])
GO
ALTER TABLE [dbo].[Person] CHECK CONSTRAINT [FK_Person_PersonnelInformation]
GO
ALTER TABLE [dbo].[PersonnelActual]  WITH CHECK ADD  CONSTRAINT [FK_PersonnelActual_Person] FOREIGN KEY([PersonID])
REFERENCES [dbo].[Person] ([ID])
GO
ALTER TABLE [dbo].[PersonnelActual] CHECK CONSTRAINT [FK_PersonnelActual_Person]
GO
ALTER TABLE [dbo].[PersonnelActual]  WITH CHECK ADD  CONSTRAINT [FK_PersonnelActual_PersonnelClass] FOREIGN KEY([PersonnelClassID])
REFERENCES [dbo].[PersonnelClass] ([ID])
GO
ALTER TABLE [dbo].[PersonnelActual] CHECK CONSTRAINT [FK_PersonnelActual_PersonnelClass]
GO
ALTER TABLE [dbo].[PersonnelActual]  WITH CHECK ADD  CONSTRAINT [FK_PersonnelActual_SegmentResponse] FOREIGN KEY([SegmentResponseID])
REFERENCES [dbo].[SegmentResponse] ([ID])
GO
ALTER TABLE [dbo].[PersonnelActual] CHECK CONSTRAINT [FK_PersonnelActual_SegmentResponse]
GO
ALTER TABLE [dbo].[PersonnelActualProperty]  WITH CHECK ADD  CONSTRAINT [FK_PersonnelActualProperty_OpPersonnelActual] FOREIGN KEY([OpPersonnelActual])
REFERENCES [dbo].[OpPersonnelActual] ([ID])
GO
ALTER TABLE [dbo].[PersonnelActualProperty] CHECK CONSTRAINT [FK_PersonnelActualProperty_OpPersonnelActual]
GO
ALTER TABLE [dbo].[PersonnelActualProperty]  WITH CHECK ADD  CONSTRAINT [FK_PersonnelActualProperty_PersonnelActual] FOREIGN KEY([PersonnelActual])
REFERENCES [dbo].[PersonnelActual] ([ID])
GO
ALTER TABLE [dbo].[PersonnelActualProperty] CHECK CONSTRAINT [FK_PersonnelActualProperty_PersonnelActual]
GO
ALTER TABLE [dbo].[PersonnelCapability]  WITH CHECK ADD  CONSTRAINT [FK_PersonnelCapability_Person] FOREIGN KEY([PersonID])
REFERENCES [dbo].[Person] ([ID])
GO
ALTER TABLE [dbo].[PersonnelCapability] CHECK CONSTRAINT [FK_PersonnelCapability_Person]
GO
ALTER TABLE [dbo].[PersonnelCapability]  WITH CHECK ADD  CONSTRAINT [FK_PersonnelCapability_PersonnelClass] FOREIGN KEY([PersonnelClassID])
REFERENCES [dbo].[PersonnelClass] ([ID])
GO
ALTER TABLE [dbo].[PersonnelCapability] CHECK CONSTRAINT [FK_PersonnelCapability_PersonnelClass]
GO
ALTER TABLE [dbo].[PersonnelCapability]  WITH CHECK ADD  CONSTRAINT [FK_PersonnelCapability_ProcessSegmentCapability] FOREIGN KEY([ProcessSegmentCapabilityID])
REFERENCES [dbo].[ProcessSegmentCapability] ([ID])
GO
ALTER TABLE [dbo].[PersonnelCapability] CHECK CONSTRAINT [FK_PersonnelCapability_ProcessSegmentCapability]
GO
ALTER TABLE [dbo].[PersonnelCapability]  WITH CHECK ADD  CONSTRAINT [FK_PersonnelCapability_ProductionCapability] FOREIGN KEY([ProductionCapabilityID])
REFERENCES [dbo].[ProductionCapability] ([ID])
GO
ALTER TABLE [dbo].[PersonnelCapability] CHECK CONSTRAINT [FK_PersonnelCapability_ProductionCapability]
GO
ALTER TABLE [dbo].[PersonnelCapabilityProperty]  WITH CHECK ADD  CONSTRAINT [FK_PersonnelCapabilityProperty_OpPersonnelCapability] FOREIGN KEY([OpPersonnelCapabilityID])
REFERENCES [dbo].[OpPersonnelCapability] ([ID])
GO
ALTER TABLE [dbo].[PersonnelCapabilityProperty] CHECK CONSTRAINT [FK_PersonnelCapabilityProperty_OpPersonnelCapability]
GO
ALTER TABLE [dbo].[PersonnelCapabilityProperty]  WITH CHECK ADD  CONSTRAINT [FK_PersonnelCapabilityProperty_PersonnelCapability] FOREIGN KEY([PersonnelCapabilityID])
REFERENCES [dbo].[PersonnelCapability] ([ID])
GO
ALTER TABLE [dbo].[PersonnelCapabilityProperty] CHECK CONSTRAINT [FK_PersonnelCapabilityProperty_PersonnelCapability]
GO
ALTER TABLE [dbo].[PersonnelClass]  WITH CHECK ADD  CONSTRAINT [FK_PersonnelClassID_PersonnelClassParentID] FOREIGN KEY([ParentID])
REFERENCES [dbo].[PersonnelClass] ([ID])
GO
ALTER TABLE [dbo].[PersonnelClass] CHECK CONSTRAINT [FK_PersonnelClassID_PersonnelClassParentID]
GO
ALTER TABLE [dbo].[PersonnelClass]  WITH CHECK ADD  CONSTRAINT [FK_PersonnelClass_PersonnelInformation] FOREIGN KEY([PersonnelInformation])
REFERENCES [dbo].[PersonnelInformation] ([ID])
GO
ALTER TABLE [dbo].[PersonnelClass] CHECK CONSTRAINT [FK_PersonnelClass_PersonnelInformation]
GO
ALTER TABLE [dbo].[PersonnelClassProperty]  WITH CHECK ADD  CONSTRAINT [FK_PersonnelClassProperty_PersonnelClass] FOREIGN KEY([PersonnelClassID])
REFERENCES [dbo].[PersonnelClass] ([ID])
GO
ALTER TABLE [dbo].[PersonnelClassProperty] CHECK CONSTRAINT [FK_PersonnelClassProperty_PersonnelClass]
GO
ALTER TABLE [dbo].[PersonnelClassProperty]  WITH CHECK ADD  CONSTRAINT [FK_PersonnelClassProperty_PersonnelClassProperty] FOREIGN KEY([PersonnelClassProperty])
REFERENCES [dbo].[PersonnelClassProperty] ([ID])
GO
ALTER TABLE [dbo].[PersonnelClassProperty] CHECK CONSTRAINT [FK_PersonnelClassProperty_PersonnelClassProperty]
GO
ALTER TABLE [dbo].[PersonnelClassProperty]  WITH CHECK ADD  CONSTRAINT [FK_PersonnelClassProperty_QualificationTestSpecification] FOREIGN KEY([QualificationTestSpecificationID])
REFERENCES [dbo].[QualificationTestSpecification] ([ID])
GO
ALTER TABLE [dbo].[PersonnelClassProperty] CHECK CONSTRAINT [FK_PersonnelClassProperty_QualificationTestSpecification]
GO
ALTER TABLE [dbo].[PersonnelIdentificationManifest]  WITH CHECK ADD  CONSTRAINT [FK_PersonnelIdentificationManifest_BatchProductionRecordEntry] FOREIGN KEY([BatchProductionRecordEntry])
REFERENCES [dbo].[BatchProductionRecordEntry] ([EntryID])
GO
ALTER TABLE [dbo].[PersonnelIdentificationManifest] CHECK CONSTRAINT [FK_PersonnelIdentificationManifest_BatchProductionRecordEntry]
GO
ALTER TABLE [dbo].[PersonnelIdentificationManifest]  WITH CHECK ADD  CONSTRAINT [FK_PersonnelIdentificationManifest_Person] FOREIGN KEY([Name])
REFERENCES [dbo].[Person] ([ID])
GO
ALTER TABLE [dbo].[PersonnelIdentificationManifest] CHECK CONSTRAINT [FK_PersonnelIdentificationManifest_Person]
GO
ALTER TABLE [dbo].[PersonnelRequirement]  WITH CHECK ADD  CONSTRAINT [FK_PersonnelRequirement_Person] FOREIGN KEY([PersonID])
REFERENCES [dbo].[Person] ([ID])
GO
ALTER TABLE [dbo].[PersonnelRequirement] CHECK CONSTRAINT [FK_PersonnelRequirement_Person]
GO
ALTER TABLE [dbo].[PersonnelRequirement]  WITH CHECK ADD  CONSTRAINT [FK_PersonnelRequirement_PersonnelClass] FOREIGN KEY([PersonnelClassID])
REFERENCES [dbo].[PersonnelClass] ([ID])
GO
ALTER TABLE [dbo].[PersonnelRequirement] CHECK CONSTRAINT [FK_PersonnelRequirement_PersonnelClass]
GO
ALTER TABLE [dbo].[PersonnelRequirement]  WITH CHECK ADD  CONSTRAINT [FK_PersonnelRequirement_SegmentRequirement] FOREIGN KEY([SegmentRequirementID])
REFERENCES [dbo].[SegmentRequirement] ([ID])
GO
ALTER TABLE [dbo].[PersonnelRequirement] CHECK CONSTRAINT [FK_PersonnelRequirement_SegmentRequirement]
GO
ALTER TABLE [dbo].[PersonnelRequirementProperty]  WITH CHECK ADD  CONSTRAINT [FK_PersonnelRequirementProperty_OpPersonnelRequirement] FOREIGN KEY([OpPersonnelRequirement])
REFERENCES [dbo].[OpPersonnelRequirement] ([ID])
GO
ALTER TABLE [dbo].[PersonnelRequirementProperty] CHECK CONSTRAINT [FK_PersonnelRequirementProperty_OpPersonnelRequirement]
GO
ALTER TABLE [dbo].[PersonnelRequirementProperty]  WITH CHECK ADD  CONSTRAINT [FK_PersonnelRequirementProperty_PersonnelRequirement] FOREIGN KEY([PersonnelRequirement])
REFERENCES [dbo].[PersonnelRequirement] ([ID])
GO
ALTER TABLE [dbo].[PersonnelRequirementProperty] CHECK CONSTRAINT [FK_PersonnelRequirementProperty_PersonnelRequirement]
GO
ALTER TABLE [dbo].[PersonnelSegmentSpecification]  WITH CHECK ADD  CONSTRAINT [FK_PersonnelSegmentSpecification_Person] FOREIGN KEY([PersonID])
REFERENCES [dbo].[Person] ([ID])
GO
ALTER TABLE [dbo].[PersonnelSegmentSpecification] CHECK CONSTRAINT [FK_PersonnelSegmentSpecification_Person]
GO
ALTER TABLE [dbo].[PersonnelSegmentSpecification]  WITH CHECK ADD  CONSTRAINT [FK_PersonnelSegmentSpecification_PersonnelClass] FOREIGN KEY([PersonnelClassID])
REFERENCES [dbo].[PersonnelClass] ([ID])
GO
ALTER TABLE [dbo].[PersonnelSegmentSpecification] CHECK CONSTRAINT [FK_PersonnelSegmentSpecification_PersonnelClass]
GO
ALTER TABLE [dbo].[PersonnelSegmentSpecification]  WITH CHECK ADD  CONSTRAINT [FK_PersonnelSegmentSpecification_ProcessSegment] FOREIGN KEY([ProcessSegmentID])
REFERENCES [dbo].[ProcessSegment] ([ID])
GO
ALTER TABLE [dbo].[PersonnelSegmentSpecification] CHECK CONSTRAINT [FK_PersonnelSegmentSpecification_ProcessSegment]
GO
ALTER TABLE [dbo].[PersonnelSegmentSpecificationProperty]  WITH CHECK ADD  CONSTRAINT [FK_PersonnelSegmentSpecificationProperty_PersonnelSegmentSpecification] FOREIGN KEY([PersonnelSegmentSpecification])
REFERENCES [dbo].[PersonnelSegmentSpecification] ([ID])
GO
ALTER TABLE [dbo].[PersonnelSegmentSpecificationProperty] CHECK CONSTRAINT [FK_PersonnelSegmentSpecificationProperty_PersonnelSegmentSpecification]
GO
ALTER TABLE [dbo].[PersonnelSpecification]  WITH CHECK ADD  CONSTRAINT [FK_PersonnelSpecification_Person] FOREIGN KEY([PersonID])
REFERENCES [dbo].[Person] ([ID])
GO
ALTER TABLE [dbo].[PersonnelSpecification] CHECK CONSTRAINT [FK_PersonnelSpecification_Person]
GO
ALTER TABLE [dbo].[PersonnelSpecification]  WITH CHECK ADD  CONSTRAINT [FK_PersonnelSpecification_PersonnelClass] FOREIGN KEY([PersonnelClassID])
REFERENCES [dbo].[PersonnelClass] ([ID])
GO
ALTER TABLE [dbo].[PersonnelSpecification] CHECK CONSTRAINT [FK_PersonnelSpecification_PersonnelClass]
GO
ALTER TABLE [dbo].[PersonnelSpecification]  WITH CHECK ADD  CONSTRAINT [FK_PersonnelSpecification_ProductSegment] FOREIGN KEY([ProductSegmentID])
REFERENCES [dbo].[ProductSegment] ([ID])
GO
ALTER TABLE [dbo].[PersonnelSpecification] CHECK CONSTRAINT [FK_PersonnelSpecification_ProductSegment]
GO
ALTER TABLE [dbo].[PersonnelSpecificationProperty]  WITH CHECK ADD  CONSTRAINT [FK_PersonnelSpecificationProperty_OpPersonnelSpecification] FOREIGN KEY([OpPersonelSpecification])
REFERENCES [dbo].[OpPersonnelSpecification] ([ID])
GO
ALTER TABLE [dbo].[PersonnelSpecificationProperty] CHECK CONSTRAINT [FK_PersonnelSpecificationProperty_OpPersonnelSpecification]
GO
ALTER TABLE [dbo].[PersonnelSpecificationProperty]  WITH CHECK ADD  CONSTRAINT [FK_PersonnelSpecificationProperty_PersonnelSpecification] FOREIGN KEY([PersonelSpecification])
REFERENCES [dbo].[PersonnelSpecification] ([ID])
GO
ALTER TABLE [dbo].[PersonnelSpecificationProperty] CHECK CONSTRAINT [FK_PersonnelSpecificationProperty_PersonnelSpecification]
GO
ALTER TABLE [dbo].[PersonProperty]  WITH CHECK ADD  CONSTRAINT [FK_PersonProperty_Person] FOREIGN KEY([PersonID])
REFERENCES [dbo].[Person] ([ID])
GO
ALTER TABLE [dbo].[PersonProperty] CHECK CONSTRAINT [FK_PersonProperty_Person]
GO
ALTER TABLE [dbo].[PersonProperty]  WITH CHECK ADD  CONSTRAINT [FK_PersonProperty_PersonnelClassProperty] FOREIGN KEY([ClassPropertyID])
REFERENCES [dbo].[PersonnelClassProperty] ([ID])
GO
ALTER TABLE [dbo].[PersonProperty] CHECK CONSTRAINT [FK_PersonProperty_PersonnelClassProperty]
GO
ALTER TABLE [dbo].[PersonProperty]  WITH CHECK ADD  CONSTRAINT [FK_PersonProperty_PersonProperty] FOREIGN KEY([PersonProperty])
REFERENCES [dbo].[PersonProperty] ([ID])
GO
ALTER TABLE [dbo].[PersonProperty] CHECK CONSTRAINT [FK_PersonProperty_PersonProperty]
GO
ALTER TABLE [dbo].[PersonProperty]  WITH CHECK ADD  CONSTRAINT [FK_PersonProperty_QualificationTestSpecification] FOREIGN KEY([QualificationTestSpecificationID])
REFERENCES [dbo].[QualificationTestSpecification] ([ID])
GO
ALTER TABLE [dbo].[PersonProperty] CHECK CONSTRAINT [FK_PersonProperty_QualificationTestSpecification]
GO
ALTER TABLE [dbo].[PhysicalAsset]  WITH CHECK ADD  CONSTRAINT [FK_PhysicalAsset_PhysicalAsset1] FOREIGN KEY([PhysicalAsset])
REFERENCES [dbo].[PhysicalAsset] ([ID])
GO
ALTER TABLE [dbo].[PhysicalAsset] CHECK CONSTRAINT [FK_PhysicalAsset_PhysicalAsset1]
GO
ALTER TABLE [dbo].[PhysicalAsset]  WITH CHECK ADD  CONSTRAINT [FK_PhysicalAsset_PhysicalAssetClass] FOREIGN KEY([PhysicalAssetClassID])
REFERENCES [dbo].[PhysicalAssetClass] ([ID])
GO
ALTER TABLE [dbo].[PhysicalAsset] CHECK CONSTRAINT [FK_PhysicalAsset_PhysicalAssetClass]
GO
ALTER TABLE [dbo].[PhysicalAssetActual]  WITH CHECK ADD  CONSTRAINT [FK_PhysicalAssetActual_PhysicalAsset] FOREIGN KEY([PhysicalAssetID])
REFERENCES [dbo].[PhysicalAsset] ([ID])
GO
ALTER TABLE [dbo].[PhysicalAssetActual] CHECK CONSTRAINT [FK_PhysicalAssetActual_PhysicalAsset]
GO
ALTER TABLE [dbo].[PhysicalAssetActual]  WITH CHECK ADD  CONSTRAINT [FK_PhysicalAssetActual_PhysicalAssetClass] FOREIGN KEY([PhysicalAssetClassID])
REFERENCES [dbo].[PhysicalAssetClass] ([ID])
GO
ALTER TABLE [dbo].[PhysicalAssetActual] CHECK CONSTRAINT [FK_PhysicalAssetActual_PhysicalAssetClass]
GO
ALTER TABLE [dbo].[PhysicalAssetActual]  WITH CHECK ADD  CONSTRAINT [FK_PhysicalAssetActual_SegmentResponse] FOREIGN KEY([SegmentResponseID])
REFERENCES [dbo].[SegmentResponse] ([ID])
GO
ALTER TABLE [dbo].[PhysicalAssetActual] CHECK CONSTRAINT [FK_PhysicalAssetActual_SegmentResponse]
GO
ALTER TABLE [dbo].[PhysicalAssetActualProperty]  WITH CHECK ADD  CONSTRAINT [FK_PhysicalAssetActualProperty_OpPhysicalAssetActual] FOREIGN KEY([OpPhysicalAssetActual])
REFERENCES [dbo].[OpPhysicalAssetActual] ([ID])
GO
ALTER TABLE [dbo].[PhysicalAssetActualProperty] CHECK CONSTRAINT [FK_PhysicalAssetActualProperty_OpPhysicalAssetActual]
GO
ALTER TABLE [dbo].[PhysicalAssetActualProperty]  WITH CHECK ADD  CONSTRAINT [FK_PhysicalAssetActualProperty_PhysicalAssetActual] FOREIGN KEY([PhysicalAssetActual])
REFERENCES [dbo].[PhysicalAssetActual] ([ID])
GO
ALTER TABLE [dbo].[PhysicalAssetActualProperty] CHECK CONSTRAINT [FK_PhysicalAssetActualProperty_PhysicalAssetActual]
GO
ALTER TABLE [dbo].[PhysicalAssetCapability]  WITH CHECK ADD  CONSTRAINT [FK_PhysicalAssetCapability_PhysicalAsset] FOREIGN KEY([PhysicalAssetID])
REFERENCES [dbo].[PhysicalAsset] ([ID])
GO
ALTER TABLE [dbo].[PhysicalAssetCapability] CHECK CONSTRAINT [FK_PhysicalAssetCapability_PhysicalAsset]
GO
ALTER TABLE [dbo].[PhysicalAssetCapability]  WITH CHECK ADD  CONSTRAINT [FK_PhysicalAssetCapability_PhysicalAssetClass] FOREIGN KEY([PhysicalAssetClassID])
REFERENCES [dbo].[PhysicalAssetClass] ([ID])
GO
ALTER TABLE [dbo].[PhysicalAssetCapability] CHECK CONSTRAINT [FK_PhysicalAssetCapability_PhysicalAssetClass]
GO
ALTER TABLE [dbo].[PhysicalAssetCapability]  WITH CHECK ADD  CONSTRAINT [FK_PhysicalAssetCapability_ProductionCapability] FOREIGN KEY([PruductionCapabilityID])
REFERENCES [dbo].[ProductionCapability] ([ID])
GO
ALTER TABLE [dbo].[PhysicalAssetCapability] CHECK CONSTRAINT [FK_PhysicalAssetCapability_ProductionCapability]
GO
ALTER TABLE [dbo].[PhysicalAssetCapabilityProperty]  WITH CHECK ADD  CONSTRAINT [FK_PhysicalAssetCapabilityProperty_OpProcessSegmentCapability] FOREIGN KEY([OpPhysicalAssetCapability])
REFERENCES [dbo].[OpPhysicalAssetCapability] ([ID])
GO
ALTER TABLE [dbo].[PhysicalAssetCapabilityProperty] CHECK CONSTRAINT [FK_PhysicalAssetCapabilityProperty_OpProcessSegmentCapability]
GO
ALTER TABLE [dbo].[PhysicalAssetCapabilityProperty]  WITH CHECK ADD  CONSTRAINT [FK_PhysicalAssetCapabilityProperty_PhysicalAssetCapability] FOREIGN KEY([PhysicalAssetCapability])
REFERENCES [dbo].[PhysicalAssetCapability] ([ID])
GO
ALTER TABLE [dbo].[PhysicalAssetCapabilityProperty] CHECK CONSTRAINT [FK_PhysicalAssetCapabilityProperty_PhysicalAssetCapability]
GO
ALTER TABLE [dbo].[PhysicalAssetClassProperty]  WITH CHECK ADD  CONSTRAINT [FK_PhysicalAssetClassProperty_PhysicalAssetCapabilityTestSpesification] FOREIGN KEY([PhysicalAssetCapabilityTestSpecification])
REFERENCES [dbo].[PhysicalAssetCapabilityTestSpesification] ([Name])
GO
ALTER TABLE [dbo].[PhysicalAssetClassProperty] CHECK CONSTRAINT [FK_PhysicalAssetClassProperty_PhysicalAssetCapabilityTestSpesification]
GO
ALTER TABLE [dbo].[PhysicalAssetClassProperty]  WITH CHECK ADD  CONSTRAINT [FK_PhysicalAssetClassProperty_PhysicalAssetClass] FOREIGN KEY([PhysicalAssetClassID])
REFERENCES [dbo].[PhysicalAssetClass] ([ID])
GO
ALTER TABLE [dbo].[PhysicalAssetClassProperty] CHECK CONSTRAINT [FK_PhysicalAssetClassProperty_PhysicalAssetClass]
GO
ALTER TABLE [dbo].[PhysicalAssetClassProperty]  WITH CHECK ADD  CONSTRAINT [FK_PhysicalAssetClassProperty_PhysicalAssetClassProperty] FOREIGN KEY([PhysicalAssetClassProperty])
REFERENCES [dbo].[PhysicalAssetClassProperty] ([ID])
GO
ALTER TABLE [dbo].[PhysicalAssetClassProperty] CHECK CONSTRAINT [FK_PhysicalAssetClassProperty_PhysicalAssetClassProperty]
GO
ALTER TABLE [dbo].[PhysicalAssetInformation]  WITH CHECK ADD  CONSTRAINT [FK_PhysicalAssetInformation_PhysicalAsset] FOREIGN KEY([PhysicalAsset])
REFERENCES [dbo].[PhysicalAsset] ([ID])
GO
ALTER TABLE [dbo].[PhysicalAssetInformation] CHECK CONSTRAINT [FK_PhysicalAssetInformation_PhysicalAsset]
GO
ALTER TABLE [dbo].[PhysicalAssetInformation]  WITH CHECK ADD  CONSTRAINT [FK_PhysicalAssetInformation_PhysicalAssetClass] FOREIGN KEY([PhysicalAssetClassID])
REFERENCES [dbo].[PhysicalAssetClass] ([ID])
GO
ALTER TABLE [dbo].[PhysicalAssetInformation] CHECK CONSTRAINT [FK_PhysicalAssetInformation_PhysicalAssetClass]
GO
ALTER TABLE [dbo].[PhysicalAssetProperty]  WITH CHECK ADD  CONSTRAINT [FK_PhysicalAssetProperty_PhysicalAsset] FOREIGN KEY([PhysicalAssetID])
REFERENCES [dbo].[PhysicalAsset] ([ID])
GO
ALTER TABLE [dbo].[PhysicalAssetProperty] CHECK CONSTRAINT [FK_PhysicalAssetProperty_PhysicalAsset]
GO
ALTER TABLE [dbo].[PhysicalAssetProperty]  WITH CHECK ADD  CONSTRAINT [FK_PhysicalAssetProperty_PhysicalAssetCapabilityTestSpesification] FOREIGN KEY([PhysicalAssetCapabilityTestSpecification])
REFERENCES [dbo].[PhysicalAssetCapabilityTestSpesification] ([Name])
GO
ALTER TABLE [dbo].[PhysicalAssetProperty] CHECK CONSTRAINT [FK_PhysicalAssetProperty_PhysicalAssetCapabilityTestSpesification]
GO
ALTER TABLE [dbo].[PhysicalAssetProperty]  WITH CHECK ADD  CONSTRAINT [FK_PhysicalAssetProperty_PhysicalAssetClassProperty] FOREIGN KEY([ClassPropertyID])
REFERENCES [dbo].[PhysicalAssetClassProperty] ([ID])
GO
ALTER TABLE [dbo].[PhysicalAssetProperty] CHECK CONSTRAINT [FK_PhysicalAssetProperty_PhysicalAssetClassProperty]
GO
ALTER TABLE [dbo].[PhysicalAssetProperty]  WITH CHECK ADD  CONSTRAINT [FK_PhysicalAssetProperty_PhysicalAssetProperty] FOREIGN KEY([PhysicalAssetProperty])
REFERENCES [dbo].[PhysicalAssetProperty] ([ID])
GO
ALTER TABLE [dbo].[PhysicalAssetProperty] CHECK CONSTRAINT [FK_PhysicalAssetProperty_PhysicalAssetProperty]
GO
ALTER TABLE [dbo].[PhysicalAssetRequirement]  WITH CHECK ADD  CONSTRAINT [FK_PhysicalAssetRequirement_PhysicalAsset] FOREIGN KEY([PhysicalAssetID])
REFERENCES [dbo].[PhysicalAsset] ([ID])
GO
ALTER TABLE [dbo].[PhysicalAssetRequirement] CHECK CONSTRAINT [FK_PhysicalAssetRequirement_PhysicalAsset]
GO
ALTER TABLE [dbo].[PhysicalAssetRequirement]  WITH CHECK ADD  CONSTRAINT [FK_PhysicalAssetRequirement_PhysicalAssetClass] FOREIGN KEY([PhysicalAssetClassID])
REFERENCES [dbo].[PhysicalAssetClass] ([ID])
GO
ALTER TABLE [dbo].[PhysicalAssetRequirement] CHECK CONSTRAINT [FK_PhysicalAssetRequirement_PhysicalAssetClass]
GO
ALTER TABLE [dbo].[PhysicalAssetRequirement]  WITH CHECK ADD  CONSTRAINT [FK_PhysicalAssetRequirement_SegmentRequirement] FOREIGN KEY([SegmentRequirementID])
REFERENCES [dbo].[SegmentRequirement] ([ID])
GO
ALTER TABLE [dbo].[PhysicalAssetRequirement] CHECK CONSTRAINT [FK_PhysicalAssetRequirement_SegmentRequirement]
GO
ALTER TABLE [dbo].[PhysicalAssetRequirementProperty]  WITH CHECK ADD  CONSTRAINT [FK_PhysicalAssetRequirementProperty_OpPhysicalAssetRequirement] FOREIGN KEY([OpPhysicalAssetRequirement])
REFERENCES [dbo].[OpPhysicalAssetRequirement] ([ID])
GO
ALTER TABLE [dbo].[PhysicalAssetRequirementProperty] CHECK CONSTRAINT [FK_PhysicalAssetRequirementProperty_OpPhysicalAssetRequirement]
GO
ALTER TABLE [dbo].[PhysicalAssetRequirementProperty]  WITH CHECK ADD  CONSTRAINT [FK_PhysicalAssetRequirementProperty_PhysicalAssetRequirement] FOREIGN KEY([PhysicalAssetRequirement])
REFERENCES [dbo].[PhysicalAssetRequirement] ([ID])
GO
ALTER TABLE [dbo].[PhysicalAssetRequirementProperty] CHECK CONSTRAINT [FK_PhysicalAssetRequirementProperty_PhysicalAssetRequirement]
GO
ALTER TABLE [dbo].[PhysicalAssetSegmentSpecification]  WITH CHECK ADD  CONSTRAINT [FK_PhysicalAssetSegmentSpecification_PhysicalAsset] FOREIGN KEY([PhysicalAssetID])
REFERENCES [dbo].[PhysicalAsset] ([ID])
GO
ALTER TABLE [dbo].[PhysicalAssetSegmentSpecification] CHECK CONSTRAINT [FK_PhysicalAssetSegmentSpecification_PhysicalAsset]
GO
ALTER TABLE [dbo].[PhysicalAssetSegmentSpecification]  WITH CHECK ADD  CONSTRAINT [FK_PhysicalAssetSegmentSpecification_PhysicalAssetClass] FOREIGN KEY([PhysicalAssetClassID])
REFERENCES [dbo].[PhysicalAssetClass] ([ID])
GO
ALTER TABLE [dbo].[PhysicalAssetSegmentSpecification] CHECK CONSTRAINT [FK_PhysicalAssetSegmentSpecification_PhysicalAssetClass]
GO
ALTER TABLE [dbo].[PhysicalAssetSegmentSpecification]  WITH CHECK ADD  CONSTRAINT [FK_PhysicalAssetSegmentSpecification_ProcessSegment] FOREIGN KEY([ProcessSegmentID])
REFERENCES [dbo].[ProcessSegment] ([ID])
GO
ALTER TABLE [dbo].[PhysicalAssetSegmentSpecification] CHECK CONSTRAINT [FK_PhysicalAssetSegmentSpecification_ProcessSegment]
GO
ALTER TABLE [dbo].[PhysicalAssetSegmentSpecificationProperty]  WITH CHECK ADD  CONSTRAINT [FK_PhysicalAssetSegmentSpecificationProperty_PhysicalAssetSegmentSpecification] FOREIGN KEY([PhysicalAssetSegmentSpecification])
REFERENCES [dbo].[PhysicalAssetSegmentSpecification] ([ID])
GO
ALTER TABLE [dbo].[PhysicalAssetSegmentSpecificationProperty] CHECK CONSTRAINT [FK_PhysicalAssetSegmentSpecificationProperty_PhysicalAssetSegmentSpecification]
GO
ALTER TABLE [dbo].[PhysicalAssetSpecification]  WITH CHECK ADD  CONSTRAINT [FK_PhysicalAssetSpecification_PhysicalAsset] FOREIGN KEY([PhysicalAssetID])
REFERENCES [dbo].[PhysicalAsset] ([ID])
GO
ALTER TABLE [dbo].[PhysicalAssetSpecification] CHECK CONSTRAINT [FK_PhysicalAssetSpecification_PhysicalAsset]
GO
ALTER TABLE [dbo].[PhysicalAssetSpecification]  WITH CHECK ADD  CONSTRAINT [FK_PhysicalAssetSpecification_PhysicalAssetClass] FOREIGN KEY([PhysicalAssetClassID])
REFERENCES [dbo].[PhysicalAssetClass] ([ID])
GO
ALTER TABLE [dbo].[PhysicalAssetSpecification] CHECK CONSTRAINT [FK_PhysicalAssetSpecification_PhysicalAssetClass]
GO
ALTER TABLE [dbo].[PhysicalAssetSpecification]  WITH CHECK ADD  CONSTRAINT [FK_PhysicalAssetSpecification_ProductSegment] FOREIGN KEY([ProductSegmentID])
REFERENCES [dbo].[ProductSegment] ([ID])
GO
ALTER TABLE [dbo].[PhysicalAssetSpecification] CHECK CONSTRAINT [FK_PhysicalAssetSpecification_ProductSegment]
GO
ALTER TABLE [dbo].[PhysicalAssetSpecificationProperty]  WITH CHECK ADD  CONSTRAINT [FK_PhysicalAssetSpecificationProperty_OpPhysicalAssetSpecification] FOREIGN KEY([OpPhysicalAssetSpecification])
REFERENCES [dbo].[OpPhysicalAssetSpecification] ([ID])
GO
ALTER TABLE [dbo].[PhysicalAssetSpecificationProperty] CHECK CONSTRAINT [FK_PhysicalAssetSpecificationProperty_OpPhysicalAssetSpecification]
GO
ALTER TABLE [dbo].[PhysicalAssetSpecificationProperty]  WITH CHECK ADD  CONSTRAINT [FK_PhysicalAssetSpecificationProperty_PhysicalAssetSpecification] FOREIGN KEY([PhysicalAssetSpecification])
REFERENCES [dbo].[PhysicalAssetSpecification] ([ID])
GO
ALTER TABLE [dbo].[PhysicalAssetSpecificationProperty] CHECK CONSTRAINT [FK_PhysicalAssetSpecificationProperty_PhysicalAssetSpecification]
GO
ALTER TABLE [dbo].[ProcedureChartElement]  WITH CHECK ADD  CONSTRAINT [FK_ProcedureChartElement_ProcedureChartElement] FOREIGN KEY([ProcedureChartElement])
REFERENCES [dbo].[ProcedureChartElement] ([ID])
GO
ALTER TABLE [dbo].[ProcedureChartElement] CHECK CONSTRAINT [FK_ProcedureChartElement_ProcedureChartElement]
GO
ALTER TABLE [dbo].[ProcedureChartElement]  WITH CHECK ADD  CONSTRAINT [FK_ProcedureChartElement_ProcessElement] FOREIGN KEY([ProcessElement])
REFERENCES [dbo].[ProcessElement] ([ID])
GO
ALTER TABLE [dbo].[ProcedureChartElement] CHECK CONSTRAINT [FK_ProcedureChartElement_ProcessElement]
GO
ALTER TABLE [dbo].[ProcessElement]  WITH CHECK ADD  CONSTRAINT [FK_ProcessElement_GRecipeMaterials] FOREIGN KEY([Materials])
REFERENCES [dbo].[GRecipeMaterials] ([ID])
GO
ALTER TABLE [dbo].[ProcessElement] CHECK CONSTRAINT [FK_ProcessElement_GRecipeMaterials]
GO
ALTER TABLE [dbo].[ProcessElement]  WITH CHECK ADD  CONSTRAINT [FK_ProcessElement_ProcessElement] FOREIGN KEY([ProcessElement])
REFERENCES [dbo].[ProcessElement] ([ID])
GO
ALTER TABLE [dbo].[ProcessElement] CHECK CONSTRAINT [FK_ProcessElement_ProcessElement]
GO
ALTER TABLE [dbo].[ProcessElement]  WITH CHECK ADD  CONSTRAINT [FK_ProcessElement_ProcessElementLibrary] FOREIGN KEY([ProcessElementLibrary])
REFERENCES [dbo].[ProcessElementLibrary] ([ID])
GO
ALTER TABLE [dbo].[ProcessElement] CHECK CONSTRAINT [FK_ProcessElement_ProcessElementLibrary]
GO
ALTER TABLE [dbo].[ProcessElementParameter]  WITH CHECK ADD  CONSTRAINT [FK_ProcessElementParameter_GRecipeFormula] FOREIGN KEY([GRecipeFormula])
REFERENCES [dbo].[GRecipeFormula] ([ID])
GO
ALTER TABLE [dbo].[ProcessElementParameter] CHECK CONSTRAINT [FK_ProcessElementParameter_GRecipeFormula]
GO
ALTER TABLE [dbo].[ProcessElementParameter]  WITH CHECK ADD  CONSTRAINT [FK_ProcessElementParameter_ProcessElement] FOREIGN KEY([ProcessElement])
REFERENCES [dbo].[ProcessElement] ([ID])
GO
ALTER TABLE [dbo].[ProcessElementParameter] CHECK CONSTRAINT [FK_ProcessElementParameter_ProcessElement]
GO
ALTER TABLE [dbo].[ProcessElementParameter]  WITH CHECK ADD  CONSTRAINT [FK_ProcessElementParameter_ProcessElementParameter] FOREIGN KEY([ProcessElementParameter])
REFERENCES [dbo].[ProcessElementParameter] ([ID])
GO
ALTER TABLE [dbo].[ProcessElementParameter] CHECK CONSTRAINT [FK_ProcessElementParameter_ProcessElementParameter]
GO
ALTER TABLE [dbo].[ProcessElementParameter]  WITH CHECK ADD  CONSTRAINT [FK_ProcessElementParameter_Value] FOREIGN KEY([Value])
REFERENCES [dbo].[Value] ([ValueString])
GO
ALTER TABLE [dbo].[ProcessElementParameter] CHECK CONSTRAINT [FK_ProcessElementParameter_Value]
GO
ALTER TABLE [dbo].[ProcessSegment]  WITH CHECK ADD  CONSTRAINT [FK_ProcessSegment_OperationsSegment] FOREIGN KEY([OperationsSegment])
REFERENCES [dbo].[OperationsSegment] ([ID])
GO
ALTER TABLE [dbo].[ProcessSegment] CHECK CONSTRAINT [FK_ProcessSegment_OperationsSegment]
GO
ALTER TABLE [dbo].[ProcessSegment]  WITH CHECK ADD  CONSTRAINT [FK_ProcessSegment_OpProcessSegmentCapability] FOREIGN KEY([OpProcessSegmentCapability])
REFERENCES [dbo].[OpProcessSegmentCapability] ([ID])
GO
ALTER TABLE [dbo].[ProcessSegment] CHECK CONSTRAINT [FK_ProcessSegment_OpProcessSegmentCapability]
GO
ALTER TABLE [dbo].[ProcessSegment]  WITH CHECK ADD  CONSTRAINT [FK_ProcessSegment_OpSegmentResponse] FOREIGN KEY([OpSegmentResponse])
REFERENCES [dbo].[OpSegmentResponse] ([ID])
GO
ALTER TABLE [dbo].[ProcessSegment] CHECK CONSTRAINT [FK_ProcessSegment_OpSegmentResponse]
GO
ALTER TABLE [dbo].[ProcessSegment]  WITH CHECK ADD  CONSTRAINT [FK_ProcessSegment_ProcessSegmentInformation] FOREIGN KEY([ProcessSegmentInformation])
REFERENCES [dbo].[ProcessSegmentInformation] ([ID])
GO
ALTER TABLE [dbo].[ProcessSegment] CHECK CONSTRAINT [FK_ProcessSegment_ProcessSegmentInformation]
GO
ALTER TABLE [dbo].[ProcessSegment]  WITH CHECK ADD  CONSTRAINT [FK_ProcessSegment_ProductDefinition] FOREIGN KEY([ProductDefinition])
REFERENCES [dbo].[ProductDefinition] ([ID])
GO
ALTER TABLE [dbo].[ProcessSegment] CHECK CONSTRAINT [FK_ProcessSegment_ProductDefinition]
GO
ALTER TABLE [dbo].[ProcessSegment]  WITH CHECK ADD  CONSTRAINT [FK_ProcessSegment_ProductSegment] FOREIGN KEY([ProductSegmentID])
REFERENCES [dbo].[ProductSegment] ([ID])
GO
ALTER TABLE [dbo].[ProcessSegment] CHECK CONSTRAINT [FK_ProcessSegment_ProductSegment]
GO
ALTER TABLE [dbo].[ProcessSegment]  WITH CHECK ADD  CONSTRAINT [FK_ProcessSegment_SegmentResponse] FOREIGN KEY([SegmentResponse])
REFERENCES [dbo].[SegmentResponse] ([ID])
GO
ALTER TABLE [dbo].[ProcessSegment] CHECK CONSTRAINT [FK_ProcessSegment_SegmentResponse]
GO
ALTER TABLE [dbo].[ProcessSegmentCapability]  WITH CHECK ADD  CONSTRAINT [FK_ProcessSegmentCapability_ProcessSegmentCapability] FOREIGN KEY([ProcessSegmentCapability])
REFERENCES [dbo].[ProcessSegmentCapability] ([ID])
GO
ALTER TABLE [dbo].[ProcessSegmentCapability] CHECK CONSTRAINT [FK_ProcessSegmentCapability_ProcessSegmentCapability]
GO
ALTER TABLE [dbo].[ProcessSegmentCapability]  WITH CHECK ADD  CONSTRAINT [FK_ProcessSegmentCapability_ProductionCapability] FOREIGN KEY([ProductionCapabilityID])
REFERENCES [dbo].[ProductionCapability] ([ID])
GO
ALTER TABLE [dbo].[ProcessSegmentCapability] CHECK CONSTRAINT [FK_ProcessSegmentCapability_ProductionCapability]
GO
ALTER TABLE [dbo].[ProductDefinition]  WITH CHECK ADD  CONSTRAINT [FK_ProductDefinition_ProductInformation] FOREIGN KEY([ProductInformation])
REFERENCES [dbo].[ProductInformation] ([ID])
GO
ALTER TABLE [dbo].[ProductDefinition] CHECK CONSTRAINT [FK_ProductDefinition_ProductInformation]
GO
ALTER TABLE [dbo].[ProductDefinition]  WITH CHECK ADD  CONSTRAINT [FK_ProductDefinition_ProductProductionRuleIDGroup] FOREIGN KEY([ProductProductionRule])
REFERENCES [dbo].[ProductProductionRuleIDGroup] ([ProductProductionRuleID])
GO
ALTER TABLE [dbo].[ProductDefinition] CHECK CONSTRAINT [FK_ProductDefinition_ProductProductionRuleIDGroup]
GO
ALTER TABLE [dbo].[ProductDefinitionRecord]  WITH CHECK ADD  CONSTRAINT [FK_ProductDefinitionRecord_BatchProductionRecordEntry] FOREIGN KEY([BatchProductionRecordEntry])
REFERENCES [dbo].[BatchProductionRecordEntry] ([EntryID])
GO
ALTER TABLE [dbo].[ProductDefinitionRecord] CHECK CONSTRAINT [FK_ProductDefinitionRecord_BatchProductionRecordEntry]
GO
ALTER TABLE [dbo].[ProductDefinitionRecord]  WITH CHECK ADD  CONSTRAINT [FK_ProductDefinitionRecord_ProductDefinition] FOREIGN KEY([ProductDefinition])
REFERENCES [dbo].[ProductDefinition] ([ID])
GO
ALTER TABLE [dbo].[ProductDefinitionRecord] CHECK CONSTRAINT [FK_ProductDefinitionRecord_ProductDefinition]
GO
ALTER TABLE [dbo].[ProductionData]  WITH CHECK ADD  CONSTRAINT [FK_ProductionData_ProductionData] FOREIGN KEY([ProductionData])
REFERENCES [dbo].[ProductionData] ([ID])
GO
ALTER TABLE [dbo].[ProductionData] CHECK CONSTRAINT [FK_ProductionData_ProductionData]
GO
ALTER TABLE [dbo].[ProductionData]  WITH CHECK ADD  CONSTRAINT [FK_ProductionData_SegmentResponse] FOREIGN KEY([SegmentResponse])
REFERENCES [dbo].[SegmentResponse] ([ID])
GO
ALTER TABLE [dbo].[ProductionData] CHECK CONSTRAINT [FK_ProductionData_SegmentResponse]
GO
ALTER TABLE [dbo].[ProductionParameter]  WITH CHECK ADD  CONSTRAINT [FK_ProductionParameter_ProcessSegment] FOREIGN KEY([ProcessSegmentID])
REFERENCES [dbo].[ProcessSegment] ([ID])
GO
ALTER TABLE [dbo].[ProductionParameter] CHECK CONSTRAINT [FK_ProductionParameter_ProcessSegment]
GO
ALTER TABLE [dbo].[ProductionParameter]  WITH CHECK ADD  CONSTRAINT [FK_ProductionParameter_ProductSegment1] FOREIGN KEY([ProductSegmentID])
REFERENCES [dbo].[ProductSegment] ([ID])
GO
ALTER TABLE [dbo].[ProductionParameter] CHECK CONSTRAINT [FK_ProductionParameter_ProductSegment1]
GO
ALTER TABLE [dbo].[ProductionPerformance]  WITH CHECK ADD  CONSTRAINT [FK_ProductionPerformance_ProductionScedule] FOREIGN KEY([ProductionScheduleID])
REFERENCES [dbo].[ProductionScedule] ([ID])
GO
ALTER TABLE [dbo].[ProductionPerformance] CHECK CONSTRAINT [FK_ProductionPerformance_ProductionScedule]
GO
ALTER TABLE [dbo].[ProductionPerformanceRecord]  WITH CHECK ADD  CONSTRAINT [FK_ProductionPerformanceRecord_BatchProductionRecordEntry] FOREIGN KEY([BatchProductionRecordEntry])
REFERENCES [dbo].[BatchProductionRecordEntry] ([EntryID])
GO
ALTER TABLE [dbo].[ProductionPerformanceRecord] CHECK CONSTRAINT [FK_ProductionPerformanceRecord_BatchProductionRecordEntry]
GO
ALTER TABLE [dbo].[ProductionPerformanceRecord]  WITH CHECK ADD  CONSTRAINT [FK_ProductionPerformanceRecord_ProductionPerformance] FOREIGN KEY([ProductionPerformance])
REFERENCES [dbo].[ProductionPerformance] ([ID])
GO
ALTER TABLE [dbo].[ProductionPerformanceRecord] CHECK CONSTRAINT [FK_ProductionPerformanceRecord_ProductionPerformance]
GO
ALTER TABLE [dbo].[ProductionRequest]  WITH CHECK ADD  CONSTRAINT [FK_ProductionRequest_ProductionScedule] FOREIGN KEY([ProductionSchedule])
REFERENCES [dbo].[ProductionScedule] ([ID])
GO
ALTER TABLE [dbo].[ProductionRequest] CHECK CONSTRAINT [FK_ProductionRequest_ProductionScedule]
GO
ALTER TABLE [dbo].[ProductionResponse]  WITH CHECK ADD  CONSTRAINT [FK_ProductionResponse_ProductionPerformance] FOREIGN KEY([ProductionPerfomance])
REFERENCES [dbo].[ProductionPerformance] ([ID])
GO
ALTER TABLE [dbo].[ProductionResponse] CHECK CONSTRAINT [FK_ProductionResponse_ProductionPerformance]
GO
ALTER TABLE [dbo].[ProductionResponse]  WITH CHECK ADD  CONSTRAINT [FK_ProductionResponse_ProductionRequest] FOREIGN KEY([ProductionRequestID])
REFERENCES [dbo].[ProductionRequest] ([ID])
GO
ALTER TABLE [dbo].[ProductionResponse] CHECK CONSTRAINT [FK_ProductionResponse_ProductionRequest]
GO
ALTER TABLE [dbo].[ProductionSceduleRecord]  WITH CHECK ADD  CONSTRAINT [FK_ProductionSceduleRecord_BatchProductionRecordEntry] FOREIGN KEY([BatchProductionRecordEntry])
REFERENCES [dbo].[BatchProductionRecordEntry] ([EntryID])
GO
ALTER TABLE [dbo].[ProductionSceduleRecord] CHECK CONSTRAINT [FK_ProductionSceduleRecord_BatchProductionRecordEntry]
GO
ALTER TABLE [dbo].[ProductionSceduleRecord]  WITH CHECK ADD  CONSTRAINT [FK_ProductionSceduleRecord_ProductionScedule] FOREIGN KEY([ProductionScedule])
REFERENCES [dbo].[ProductionScedule] ([ID])
GO
ALTER TABLE [dbo].[ProductionSceduleRecord] CHECK CONSTRAINT [FK_ProductionSceduleRecord_ProductionScedule]
GO
ALTER TABLE [dbo].[ProductProductionRuleIDGroup]  WITH CHECK ADD  CONSTRAINT [FK_ProductProductionRuleIDGroup_ProductionRequest] FOREIGN KEY([ProductionRequest])
REFERENCES [dbo].[ProductionRequest] ([ID])
GO
ALTER TABLE [dbo].[ProductProductionRuleIDGroup] CHECK CONSTRAINT [FK_ProductProductionRuleIDGroup_ProductionRequest]
GO
ALTER TABLE [dbo].[ProductProductionRuleIDGroup]  WITH CHECK ADD  CONSTRAINT [FK_ProductProductionRuleIDGroup_ProductionResponse] FOREIGN KEY([ProductionResponse])
REFERENCES [dbo].[ProductionResponse] ([ID])
GO
ALTER TABLE [dbo].[ProductProductionRuleIDGroup] CHECK CONSTRAINT [FK_ProductProductionRuleIDGroup_ProductionResponse]
GO
ALTER TABLE [dbo].[ProductSegment]  WITH CHECK ADD  CONSTRAINT [FK_ProductSegment_ProductDefinition] FOREIGN KEY([ProductDefinition])
REFERENCES [dbo].[ProductDefinition] ([ID])
GO
ALTER TABLE [dbo].[ProductSegment] CHECK CONSTRAINT [FK_ProductSegment_ProductDefinition]
GO
ALTER TABLE [dbo].[ProductSegment]  WITH CHECK ADD  CONSTRAINT [FK_ProductSegment_ProductSegment] FOREIGN KEY([ProductSegment])
REFERENCES [dbo].[ProductSegment] ([ID])
GO
ALTER TABLE [dbo].[ProductSegment] CHECK CONSTRAINT [FK_ProductSegment_ProductSegment]
GO
ALTER TABLE [dbo].[ProductSegment]  WITH CHECK ADD  CONSTRAINT [FK_ProductSegment_SegmentResponse] FOREIGN KEY([SegmentResponse])
REFERENCES [dbo].[SegmentResponse] ([ID])
GO
ALTER TABLE [dbo].[ProductSegment] CHECK CONSTRAINT [FK_ProductSegment_SegmentResponse]
GO
ALTER TABLE [dbo].[RecipeBuildingBlock]  WITH CHECK ADD  CONSTRAINT [FK_RecipeBuildingBlock_BatchInformation] FOREIGN KEY([BatchInformation])
REFERENCES [dbo].[BatchInformation] ([ID])
GO
ALTER TABLE [dbo].[RecipeBuildingBlock] CHECK CONSTRAINT [FK_RecipeBuildingBlock_BatchInformation]
GO
ALTER TABLE [dbo].[RecipeElement]  WITH CHECK ADD  CONSTRAINT [FK_RecipeElement_ControlRecipe] FOREIGN KEY([ControlRecipe])
REFERENCES [dbo].[ControlRecipe] ([ID])
GO
ALTER TABLE [dbo].[RecipeElement] CHECK CONSTRAINT [FK_RecipeElement_ControlRecipe]
GO
ALTER TABLE [dbo].[RecipeElement]  WITH CHECK ADD  CONSTRAINT [FK_RecipeElement_Header] FOREIGN KEY([Header])
REFERENCES [dbo].[Header] ([ID])
GO
ALTER TABLE [dbo].[RecipeElement] CHECK CONSTRAINT [FK_RecipeElement_Header]
GO
ALTER TABLE [dbo].[RecipeElement]  WITH CHECK ADD  CONSTRAINT [FK_RecipeElement_MasterRecipe] FOREIGN KEY([MasterRecipe])
REFERENCES [dbo].[MasterRecipe] ([ID])
GO
ALTER TABLE [dbo].[RecipeElement] CHECK CONSTRAINT [FK_RecipeElement_MasterRecipe]
GO
ALTER TABLE [dbo].[RecipeElement]  WITH CHECK ADD  CONSTRAINT [FK_RecipeElement_ProcedureLogic] FOREIGN KEY([ProcedureLogic])
REFERENCES [dbo].[ProcedureLogic] ([ID])
GO
ALTER TABLE [dbo].[RecipeElement] CHECK CONSTRAINT [FK_RecipeElement_ProcedureLogic]
GO
ALTER TABLE [dbo].[RecipeElement]  WITH CHECK ADD  CONSTRAINT [FK_RecipeElement_RecipeBuildingBlock] FOREIGN KEY([BuildingBlockElementID])
REFERENCES [dbo].[RecipeBuildingBlock] ([ID])
GO
ALTER TABLE [dbo].[RecipeElement] CHECK CONSTRAINT [FK_RecipeElement_RecipeBuildingBlock]
GO
ALTER TABLE [dbo].[RecipeElement]  WITH CHECK ADD  CONSTRAINT [FK_RecipeElement_RecipeElement] FOREIGN KEY([RecipeElement])
REFERENCES [dbo].[RecipeElement] ([ID])
GO
ALTER TABLE [dbo].[RecipeElement] CHECK CONSTRAINT [FK_RecipeElement_RecipeElement]
GO
ALTER TABLE [dbo].[RecipeElementRecord]  WITH CHECK ADD  CONSTRAINT [FK_RecipeElementRecord_BatchProductionRecordEntry] FOREIGN KEY([BatchProductionRecordEntry])
REFERENCES [dbo].[BatchProductionRecordEntry] ([EntryID])
GO
ALTER TABLE [dbo].[RecipeElementRecord] CHECK CONSTRAINT [FK_RecipeElementRecord_BatchProductionRecordEntry]
GO
ALTER TABLE [dbo].[RecipeElementRecord]  WITH CHECK ADD  CONSTRAINT [FK_RecipeElementRecord_RecipeElement] FOREIGN KEY([RecipeElement])
REFERENCES [dbo].[RecipeElement] ([ID])
GO
ALTER TABLE [dbo].[RecipeElementRecord] CHECK CONSTRAINT [FK_RecipeElementRecord_RecipeElement]
GO
ALTER TABLE [dbo].[ResourceConstraint]  WITH CHECK ADD  CONSTRAINT [FK_ResourceConstraint_GRecipe] FOREIGN KEY([GRecipe])
REFERENCES [dbo].[GRecipe] ([ID])
GO
ALTER TABLE [dbo].[ResourceConstraint] CHECK CONSTRAINT [FK_ResourceConstraint_GRecipe]
GO
ALTER TABLE [dbo].[ResourceConstraint]  WITH CHECK ADD  CONSTRAINT [FK_ResourceConstraint_ProcessElement] FOREIGN KEY([ProcessElement])
REFERENCES [dbo].[ProcessElement] ([ID])
GO
ALTER TABLE [dbo].[ResourceConstraint] CHECK CONSTRAINT [FK_ResourceConstraint_ProcessElement]
GO
ALTER TABLE [dbo].[ResourceConstraint]  WITH CHECK ADD  CONSTRAINT [FK_ResourceConstraint_ResourceConstraintLibrary] FOREIGN KEY([ResourceConstraintLibrary])
REFERENCES [dbo].[ResourceConstraintLibrary] ([ID])
GO
ALTER TABLE [dbo].[ResourceConstraint] CHECK CONSTRAINT [FK_ResourceConstraint_ResourceConstraintLibrary]
GO
ALTER TABLE [dbo].[ResourceConstraintProperty]  WITH CHECK ADD  CONSTRAINT [FK_ResourceConstraintProperty_ResourceConstraint] FOREIGN KEY([ResourceConstraint])
REFERENCES [dbo].[ResourceConstraint] ([ConstraintID])
GO
ALTER TABLE [dbo].[ResourceConstraintProperty] CHECK CONSTRAINT [FK_ResourceConstraintProperty_ResourceConstraint]
GO
ALTER TABLE [dbo].[ResourceConstraintProperty]  WITH CHECK ADD  CONSTRAINT [FK_ResourceConstraintProperty_Value] FOREIGN KEY([Value])
REFERENCES [dbo].[Value] ([ValueString])
GO
ALTER TABLE [dbo].[ResourceConstraintProperty] CHECK CONSTRAINT [FK_ResourceConstraintProperty_Value]
GO
ALTER TABLE [dbo].[ResourceNetworkConnection]  WITH CHECK ADD  CONSTRAINT [FK_ResourceNetworkConnection_ResourceNetworkConnection] FOREIGN KEY([ResourceNetworkConnectionID])
REFERENCES [dbo].[ResourceNetworkConnection] ([ID])
GO
ALTER TABLE [dbo].[ResourceNetworkConnection] CHECK CONSTRAINT [FK_ResourceNetworkConnection_ResourceNetworkConnection]
GO
ALTER TABLE [dbo].[ResourceNetworkConnection]  WITH CHECK ADD  CONSTRAINT [FK_ResourceNetworkConnection_ResourceReference] FOREIGN KEY([FromResourceReference])
REFERENCES [dbo].[ResourceReference] ([ID])
GO
ALTER TABLE [dbo].[ResourceNetworkConnection] CHECK CONSTRAINT [FK_ResourceNetworkConnection_ResourceReference]
GO
ALTER TABLE [dbo].[ResourceNetworkConnection]  WITH CHECK ADD  CONSTRAINT [FK_ResourceNetworkConnection_ResourceReference1] FOREIGN KEY([ToResourceReference])
REFERENCES [dbo].[ResourceReference] ([ID])
GO
ALTER TABLE [dbo].[ResourceNetworkConnection] CHECK CONSTRAINT [FK_ResourceNetworkConnection_ResourceReference1]
GO
ALTER TABLE [dbo].[ResourceNetworkConnection]  WITH CHECK ADD  CONSTRAINT [FK_ResourceNetworkConnection_ResourceRelationshipNetwork] FOREIGN KEY([ResourceRelationshipNetwork])
REFERENCES [dbo].[ResourceRelationshipNetwork] ([ID])
GO
ALTER TABLE [dbo].[ResourceNetworkConnection] CHECK CONSTRAINT [FK_ResourceNetworkConnection_ResourceRelationshipNetwork]
GO
ALTER TABLE [dbo].[ResourceNetworkConnectionType]  WITH CHECK ADD  CONSTRAINT [FK_ResourceNetworkConnectionType_ResourceNetworkConnection] FOREIGN KEY([ResourceNetworkConnectionID])
REFERENCES [dbo].[ResourceNetworkConnection] ([ID])
GO
ALTER TABLE [dbo].[ResourceNetworkConnectionType] CHECK CONSTRAINT [FK_ResourceNetworkConnectionType_ResourceNetworkConnection]
GO
ALTER TABLE [dbo].[ResourceNetworkConnectionType]  WITH CHECK ADD  CONSTRAINT [FK_ResourceNetworkConnectionType_ResourceNetworkConnectionInformation] FOREIGN KEY([ResourceNetworkConnectionInformation])
REFERENCES [dbo].[ResourceNetworkConnectionInformation] ([ID])
GO
ALTER TABLE [dbo].[ResourceNetworkConnectionType] CHECK CONSTRAINT [FK_ResourceNetworkConnectionType_ResourceNetworkConnectionInformation]
GO
ALTER TABLE [dbo].[ResourceProperty]  WITH CHECK ADD  CONSTRAINT [FK_ResourceProperty_ResourceReference] FOREIGN KEY([ResourceReference])
REFERENCES [dbo].[ResourceReference] ([ID])
GO
ALTER TABLE [dbo].[ResourceProperty] CHECK CONSTRAINT [FK_ResourceProperty_ResourceReference]
GO
ALTER TABLE [dbo].[ResourceQualificationsManifest]  WITH CHECK ADD  CONSTRAINT [FK_ResourceQualificationsManifest_BatchProductionRecordEntry] FOREIGN KEY([BatchProductionRecordEntry])
REFERENCES [dbo].[BatchProductionRecordEntry] ([EntryID])
GO
ALTER TABLE [dbo].[ResourceQualificationsManifest] CHECK CONSTRAINT [FK_ResourceQualificationsManifest_BatchProductionRecordEntry]
GO
ALTER TABLE [dbo].[Sample]  WITH CHECK ADD  CONSTRAINT [FK_Sample_BatchProductionRecordEntry] FOREIGN KEY([BatchProductionRecordEntry])
REFERENCES [dbo].[BatchProductionRecordEntry] ([EntryID])
GO
ALTER TABLE [dbo].[Sample] CHECK CONSTRAINT [FK_Sample_BatchProductionRecordEntry]
GO
ALTER TABLE [dbo].[Sample]  WITH CHECK ADD  CONSTRAINT [FK_Sample_Equipment] FOREIGN KEY([EquipmentID])
REFERENCES [dbo].[Equipment] ([ID])
GO
ALTER TABLE [dbo].[Sample] CHECK CONSTRAINT [FK_Sample_Equipment]
GO
ALTER TABLE [dbo].[Sample]  WITH CHECK ADD  CONSTRAINT [FK_Sample_PhysicalAsset] FOREIGN KEY([PhysicalAssetID])
REFERENCES [dbo].[PhysicalAsset] ([ID])
GO
ALTER TABLE [dbo].[Sample] CHECK CONSTRAINT [FK_Sample_PhysicalAsset]
GO
ALTER TABLE [dbo].[SampleTest]  WITH CHECK ADD  CONSTRAINT [FK_SampleTest_BatchProductionRecordEntry] FOREIGN KEY([BatchProductionRecordEntry])
REFERENCES [dbo].[BatchProductionRecordEntry] ([EntryID])
GO
ALTER TABLE [dbo].[SampleTest] CHECK CONSTRAINT [FK_SampleTest_BatchProductionRecordEntry]
GO
ALTER TABLE [dbo].[SampleTest]  WITH CHECK ADD  CONSTRAINT [FK_SampleTest_Sample] FOREIGN KEY([Sample])
REFERENCES [dbo].[Sample] ([ID])
GO
ALTER TABLE [dbo].[SampleTest] CHECK CONSTRAINT [FK_SampleTest_Sample]
GO
ALTER TABLE [dbo].[SampleTestResult]  WITH CHECK ADD  CONSTRAINT [FK_SampleTestResult_BatchProductionRecordEntry] FOREIGN KEY([BatchProductionRecordEntry])
REFERENCES [dbo].[BatchProductionRecordEntry] ([EntryID])
GO
ALTER TABLE [dbo].[SampleTestResult] CHECK CONSTRAINT [FK_SampleTestResult_BatchProductionRecordEntry]
GO
ALTER TABLE [dbo].[SampleTestResult]  WITH CHECK ADD  CONSTRAINT [FK_SampleTestResult_Equipment] FOREIGN KEY([EquipmentID])
REFERENCES [dbo].[Equipment] ([ID])
GO
ALTER TABLE [dbo].[SampleTestResult] CHECK CONSTRAINT [FK_SampleTestResult_Equipment]
GO
ALTER TABLE [dbo].[SampleTestResult]  WITH CHECK ADD  CONSTRAINT [FK_SampleTestResult_PhysicalAsset] FOREIGN KEY([PhysicalAssetID])
REFERENCES [dbo].[PhysicalAsset] ([ID])
GO
ALTER TABLE [dbo].[SampleTestResult] CHECK CONSTRAINT [FK_SampleTestResult_PhysicalAsset]
GO
ALTER TABLE [dbo].[SampleTestResult]  WITH CHECK ADD  CONSTRAINT [FK_SampleTestResult_SampleTest] FOREIGN KEY([SampleTest])
REFERENCES [dbo].[SampleTest] ([ID])
GO
ALTER TABLE [dbo].[SampleTestResult] CHECK CONSTRAINT [FK_SampleTestResult_SampleTest]
GO
ALTER TABLE [dbo].[SegmentParameter]  WITH CHECK ADD  CONSTRAINT [FK_SegmentParameter_OperationsSegment] FOREIGN KEY([OperationsSegment])
REFERENCES [dbo].[OperationsSegment] ([ID])
GO
ALTER TABLE [dbo].[SegmentParameter] CHECK CONSTRAINT [FK_SegmentParameter_OperationsSegment]
GO
ALTER TABLE [dbo].[SegmentParameter]  WITH CHECK ADD  CONSTRAINT [FK_SegmentParameter_OpSegmentRequirement] FOREIGN KEY([OpSegmentRequirement])
REFERENCES [dbo].[OpSegmentRequirement] ([ID])
GO
ALTER TABLE [dbo].[SegmentParameter] CHECK CONSTRAINT [FK_SegmentParameter_OpSegmentRequirement]
GO
ALTER TABLE [dbo].[SegmentParameter]  WITH CHECK ADD  CONSTRAINT [FK_SegmentParameter_SegmentParameter] FOREIGN KEY([Parameter])
REFERENCES [dbo].[SegmentParameter] ([ID])
GO
ALTER TABLE [dbo].[SegmentParameter] CHECK CONSTRAINT [FK_SegmentParameter_SegmentParameter]
GO
ALTER TABLE [dbo].[SegmentRequirement]  WITH CHECK ADD  CONSTRAINT [FK_SegmentRequirement_ProcessSegment] FOREIGN KEY([ProcessSegmentID])
REFERENCES [dbo].[ProcessSegment] ([ID])
GO
ALTER TABLE [dbo].[SegmentRequirement] CHECK CONSTRAINT [FK_SegmentRequirement_ProcessSegment]
GO
ALTER TABLE [dbo].[SegmentRequirement]  WITH CHECK ADD  CONSTRAINT [FK_SegmentRequirement_ProductionParameter] FOREIGN KEY([ProductionParameter])
REFERENCES [dbo].[ProductionParameter] ([ID])
GO
ALTER TABLE [dbo].[SegmentRequirement] CHECK CONSTRAINT [FK_SegmentRequirement_ProductionParameter]
GO
ALTER TABLE [dbo].[SegmentRequirement]  WITH CHECK ADD  CONSTRAINT [FK_SegmentRequirement_ProductionRequest] FOREIGN KEY([ProductionRequest])
REFERENCES [dbo].[ProductionRequest] ([ID])
GO
ALTER TABLE [dbo].[SegmentRequirement] CHECK CONSTRAINT [FK_SegmentRequirement_ProductionRequest]
GO
ALTER TABLE [dbo].[SegmentRequirement]  WITH CHECK ADD  CONSTRAINT [FK_SegmentRequirement_ProductSegment] FOREIGN KEY([ProductSegmentID])
REFERENCES [dbo].[ProductSegment] ([ID])
GO
ALTER TABLE [dbo].[SegmentRequirement] CHECK CONSTRAINT [FK_SegmentRequirement_ProductSegment]
GO
ALTER TABLE [dbo].[SegmentRequirement]  WITH CHECK ADD  CONSTRAINT [FK_SegmentRequirement_SegmentRequirement] FOREIGN KEY([SegmentRequirement])
REFERENCES [dbo].[SegmentRequirement] ([ID])
GO
ALTER TABLE [dbo].[SegmentRequirement] CHECK CONSTRAINT [FK_SegmentRequirement_SegmentRequirement]
GO
ALTER TABLE [dbo].[SegmentResponse]  WITH CHECK ADD  CONSTRAINT [FK_SegmentResponse_ProductionRequest] FOREIGN KEY([ProductionRequest])
REFERENCES [dbo].[ProductionRequest] ([ID])
GO
ALTER TABLE [dbo].[SegmentResponse] CHECK CONSTRAINT [FK_SegmentResponse_ProductionRequest]
GO
ALTER TABLE [dbo].[SegmentResponse]  WITH CHECK ADD  CONSTRAINT [FK_SegmentResponse_ProductionResponse] FOREIGN KEY([ProductionResponse])
REFERENCES [dbo].[ProductionResponse] ([ID])
GO
ALTER TABLE [dbo].[SegmentResponse] CHECK CONSTRAINT [FK_SegmentResponse_ProductionResponse]
GO
ALTER TABLE [dbo].[SegmentResponse]  WITH CHECK ADD  CONSTRAINT [FK_SegmentResponse_SegmentResponse] FOREIGN KEY([SegmentResponse])
REFERENCES [dbo].[SegmentResponse] ([ID])
GO
ALTER TABLE [dbo].[SegmentResponse] CHECK CONSTRAINT [FK_SegmentResponse_SegmentResponse]
GO
ALTER TABLE [dbo].[Step]  WITH CHECK ADD  CONSTRAINT [FK_Step_ProcedureLogic] FOREIGN KEY([ProcedureLogic])
REFERENCES [dbo].[ProcedureLogic] ([ID])
GO
ALTER TABLE [dbo].[Step] CHECK CONSTRAINT [FK_Step_ProcedureLogic]
GO
ALTER TABLE [dbo].[Step]  WITH CHECK ADD  CONSTRAINT [FK_Step_RecipeElement] FOREIGN KEY([RecipeElementID])
REFERENCES [dbo].[RecipeElement] ([ID])
GO
ALTER TABLE [dbo].[Step] CHECK CONSTRAINT [FK_Step_RecipeElement]
GO
ALTER TABLE [dbo].[SupportedAction]  WITH CHECK ADD  CONSTRAINT [FK_SupportedAction_TransactionProfile] FOREIGN KEY([TransactionProfile])
REFERENCES [dbo].[TransactionProfile] ([ID])
GO
ALTER TABLE [dbo].[SupportedAction] CHECK CONSTRAINT [FK_SupportedAction_TransactionProfile]
GO
ALTER TABLE [dbo].[TagSpecification]  WITH CHECK ADD  CONSTRAINT [FK_TagSpecification_DataSet] FOREIGN KEY([DataSet])
REFERENCES [dbo].[DataSet] ([ID])
GO
ALTER TABLE [dbo].[TagSpecification] CHECK CONSTRAINT [FK_TagSpecification_DataSet]
GO
ALTER TABLE [dbo].[TagSpecification]  WITH CHECK ADD  CONSTRAINT [FK_TagSpecification_Equipment] FOREIGN KEY([EquipmentID])
REFERENCES [dbo].[Equipment] ([ID])
GO
ALTER TABLE [dbo].[TagSpecification] CHECK CONSTRAINT [FK_TagSpecification_Equipment]
GO
ALTER TABLE [dbo].[TagSpecification]  WITH CHECK ADD  CONSTRAINT [FK_TagSpecification_PhysicalAsset] FOREIGN KEY([PhysicalAssetID])
REFERENCES [dbo].[PhysicalAsset] ([ID])
GO
ALTER TABLE [dbo].[TagSpecification] CHECK CONSTRAINT [FK_TagSpecification_PhysicalAsset]
GO
ALTER TABLE [dbo].[ToID]  WITH CHECK ADD  CONSTRAINT [FK_ToID_Link] FOREIGN KEY([Link])
REFERENCES [dbo].[Link] ([ID])
GO
ALTER TABLE [dbo].[ToID] CHECK CONSTRAINT [FK_ToID_Link]
GO
ALTER TABLE [dbo].[Transition]  WITH CHECK ADD  CONSTRAINT [FK_Transition_ProcedureLogic] FOREIGN KEY([ProcedureLogic])
REFERENCES [dbo].[ProcedureLogic] ([ID])
GO
ALTER TABLE [dbo].[Transition] CHECK CONSTRAINT [FK_Transition_ProcedureLogic]
GO
ALTER TABLE [dbo].[UserAttribute]  WITH CHECK ADD  CONSTRAINT [FK_UserAttribute_Event] FOREIGN KEY([Event])
REFERENCES [dbo].[Event] ([ID])
GO
ALTER TABLE [dbo].[UserAttribute] CHECK CONSTRAINT [FK_UserAttribute_Event]
GO
ALTER TABLE [dbo].[WorkAlert]  WITH CHECK ADD  CONSTRAINT [FK_WorkAlert_WorkAlertInformation] FOREIGN KEY([WorkAlertInformation])
REFERENCES [dbo].[WorkAlertInformation] ([ID])
GO
ALTER TABLE [dbo].[WorkAlert] CHECK CONSTRAINT [FK_WorkAlert_WorkAlertInformation]
GO
ALTER TABLE [dbo].[WorkAlertDefinition]  WITH CHECK ADD  CONSTRAINT [FK_WorkAlertDefinition_WorkAlertInformation] FOREIGN KEY([WorkAlertInformation])
REFERENCES [dbo].[WorkAlertInformation] ([ID])
GO
ALTER TABLE [dbo].[WorkAlertDefinition] CHECK CONSTRAINT [FK_WorkAlertDefinition_WorkAlertInformation]
GO
ALTER TABLE [dbo].[WorkAlertProperty]  WITH CHECK ADD  CONSTRAINT [FK_WorkAlertProperty_WorkAlert] FOREIGN KEY([WorAlert])
REFERENCES [dbo].[WorkAlert] ([ID])
GO
ALTER TABLE [dbo].[WorkAlertProperty] CHECK CONSTRAINT [FK_WorkAlertProperty_WorkAlert]
GO
ALTER TABLE [dbo].[WorkAlertProperty]  WITH CHECK ADD  CONSTRAINT [FK_WorkAlertProperty_WorkAlertDefinition] FOREIGN KEY([WorAlertDefinition])
REFERENCES [dbo].[WorkAlertDefinition] ([ID])
GO
ALTER TABLE [dbo].[WorkAlertProperty] CHECK CONSTRAINT [FK_WorkAlertProperty_WorkAlertDefinition]
GO
ALTER TABLE [dbo].[WorkCapability]  WITH CHECK ADD  CONSTRAINT [FK_WorkCapability_WorkDefinitionInformation] FOREIGN KEY([WorkCapabilityInformation])
REFERENCES [dbo].[WorkCapabilityInformation] ([ID])
GO
ALTER TABLE [dbo].[WorkCapability] CHECK CONSTRAINT [FK_WorkCapability_WorkDefinitionInformation]
GO
ALTER TABLE [dbo].[WorkDefinition]  WITH CHECK ADD  CONSTRAINT [FK_WorkDefinition_OperationsDefinition] FOREIGN KEY([OperationsDefinitionID])
REFERENCES [dbo].[OperationsDefinition] ([ID])
GO
ALTER TABLE [dbo].[WorkDefinition] CHECK CONSTRAINT [FK_WorkDefinition_OperationsDefinition]
GO
ALTER TABLE [dbo].[WorkDirective]  WITH CHECK ADD  CONSTRAINT [FK_WorkDirective_WorkDefinition] FOREIGN KEY([WorkDefinitionID])
REFERENCES [dbo].[WorkDefinition] ([ID])
GO
ALTER TABLE [dbo].[WorkDirective] CHECK CONSTRAINT [FK_WorkDirective_WorkDefinition]
GO
ALTER TABLE [dbo].[WorkDirective]  WITH CHECK ADD  CONSTRAINT [FK_WorkDirective_WorkDefinitionInformation] FOREIGN KEY([WorkDefinitionInformation])
REFERENCES [dbo].[WorkDefinitionInformation] ([ID])
GO
ALTER TABLE [dbo].[WorkDirective] CHECK CONSTRAINT [FK_WorkDirective_WorkDefinitionInformation]
GO
ALTER TABLE [dbo].[WorkDirective]  WITH CHECK ADD  CONSTRAINT [FK_WorkDirective_WorkMaster] FOREIGN KEY([WorkMasterID])
REFERENCES [dbo].[WorkMaster] ([WorkMaster])
GO
ALTER TABLE [dbo].[WorkDirective] CHECK CONSTRAINT [FK_WorkDirective_WorkMaster]
GO
ALTER TABLE [dbo].[WorkDirectiveRecord]  WITH CHECK ADD  CONSTRAINT [FK_WorkDirectiveRecord_BatchProductionRecordEntry] FOREIGN KEY([BatchProductionRecordEntry])
REFERENCES [dbo].[BatchProductionRecordEntry] ([EntryID])
GO
ALTER TABLE [dbo].[WorkDirectiveRecord] CHECK CONSTRAINT [FK_WorkDirectiveRecord_BatchProductionRecordEntry]
GO
ALTER TABLE [dbo].[WorkDirectiveRecord]  WITH CHECK ADD  CONSTRAINT [FK_WorkDirectiveRecord_WorkDirective] FOREIGN KEY([WorkDirective])
REFERENCES [dbo].[WorkDirective] ([WorkDirective])
GO
ALTER TABLE [dbo].[WorkDirectiveRecord] CHECK CONSTRAINT [FK_WorkDirectiveRecord_WorkDirective]
GO
ALTER TABLE [dbo].[WorkflowSpecification]  WITH CHECK ADD  CONSTRAINT [FK_WorkflowSpecification_WorkflowSpecificationInformation] FOREIGN KEY([WorkflowSpecificationInformation])
REFERENCES [dbo].[WorkflowSpecificationInformation] ([ID])
GO
ALTER TABLE [dbo].[WorkflowSpecification] CHECK CONSTRAINT [FK_WorkflowSpecification_WorkflowSpecificationInformation]
GO
ALTER TABLE [dbo].[WorkflowSpecificationConnection]  WITH CHECK ADD  CONSTRAINT [FK_WorkflowSpecificationConnection_WorkflowSpecification] FOREIGN KEY([WorkflowSpecification])
REFERENCES [dbo].[WorkflowSpecification] ([ID])
GO
ALTER TABLE [dbo].[WorkflowSpecificationConnection] CHECK CONSTRAINT [FK_WorkflowSpecificationConnection_WorkflowSpecification]
GO
ALTER TABLE [dbo].[WorkflowSpecificationConnection]  WITH CHECK ADD  CONSTRAINT [FK_WorkflowSpecificationConnection_WorkflowSpecificationConnectionType] FOREIGN KEY([ConnectionType])
REFERENCES [dbo].[WorkflowSpecificationConnectionType] ([ID])
GO
ALTER TABLE [dbo].[WorkflowSpecificationConnection] CHECK CONSTRAINT [FK_WorkflowSpecificationConnection_WorkflowSpecificationConnectionType]
GO
ALTER TABLE [dbo].[WorkflowSpecificationConnectionType]  WITH CHECK ADD  CONSTRAINT [FK_WorkflowSpecificationConnectionType_WorkflowSpecificationType] FOREIGN KEY([WorkflowSpecificationType])
REFERENCES [dbo].[WorkflowSpecificationType] ([ID])
GO
ALTER TABLE [dbo].[WorkflowSpecificationConnectionType] CHECK CONSTRAINT [FK_WorkflowSpecificationConnectionType_WorkflowSpecificationType]
GO
ALTER TABLE [dbo].[WorkflowSpecificationNode]  WITH CHECK ADD  CONSTRAINT [FK_WorkflowSpecificationNode_WorkDefinition] FOREIGN KEY([WorkDefinition])
REFERENCES [dbo].[WorkDefinition] ([ID])
GO
ALTER TABLE [dbo].[WorkflowSpecificationNode] CHECK CONSTRAINT [FK_WorkflowSpecificationNode_WorkDefinition]
GO
ALTER TABLE [dbo].[WorkflowSpecificationNode]  WITH CHECK ADD  CONSTRAINT [FK_WorkflowSpecificationNode_WorkflowSpecification] FOREIGN KEY([WorkflowSpecification])
REFERENCES [dbo].[WorkflowSpecification] ([ID])
GO
ALTER TABLE [dbo].[WorkflowSpecificationNode] CHECK CONSTRAINT [FK_WorkflowSpecificationNode_WorkflowSpecification]
GO
ALTER TABLE [dbo].[WorkflowSpecificationNode]  WITH CHECK ADD  CONSTRAINT [FK_WorkflowSpecificationNode_WorkflowSpecificationNodeType] FOREIGN KEY([NodeType])
REFERENCES [dbo].[WorkflowSpecificationNodeType] ([ID])
GO
ALTER TABLE [dbo].[WorkflowSpecificationNode] CHECK CONSTRAINT [FK_WorkflowSpecificationNode_WorkflowSpecificationNodeType]
GO
ALTER TABLE [dbo].[WorkflowSpecificationNodeType]  WITH CHECK ADD  CONSTRAINT [FK_WorkflowSpecificationNodeType_WorkflowSpecificationType] FOREIGN KEY([WorkflowSpecificationType])
REFERENCES [dbo].[WorkflowSpecificationType] ([ID])
GO
ALTER TABLE [dbo].[WorkflowSpecificationNodeType] CHECK CONSTRAINT [FK_WorkflowSpecificationNodeType_WorkflowSpecificationType]
GO
ALTER TABLE [dbo].[WorkflowSpecificationProperty]  WITH CHECK ADD  CONSTRAINT [FK_WorkflowSpecificationProperty_WorkflowSpecificationConnection] FOREIGN KEY([WorkflowSpecificationConnection])
REFERENCES [dbo].[WorkflowSpecificationConnection] ([ID])
GO
ALTER TABLE [dbo].[WorkflowSpecificationProperty] CHECK CONSTRAINT [FK_WorkflowSpecificationProperty_WorkflowSpecificationConnection]
GO
ALTER TABLE [dbo].[WorkflowSpecificationProperty]  WITH CHECK ADD  CONSTRAINT [FK_WorkflowSpecificationProperty_WorkflowSpecificationConnectionType] FOREIGN KEY([WorkflowSpecificationConnectionType])
REFERENCES [dbo].[WorkflowSpecificationConnectionType] ([ID])
GO
ALTER TABLE [dbo].[WorkflowSpecificationProperty] CHECK CONSTRAINT [FK_WorkflowSpecificationProperty_WorkflowSpecificationConnectionType]
GO
ALTER TABLE [dbo].[WorkflowSpecificationProperty]  WITH CHECK ADD  CONSTRAINT [FK_WorkflowSpecificationProperty_WorkflowSpecificationNode] FOREIGN KEY([WorkflowSpecificationNode])
REFERENCES [dbo].[WorkflowSpecificationNode] ([ID])
GO
ALTER TABLE [dbo].[WorkflowSpecificationProperty] CHECK CONSTRAINT [FK_WorkflowSpecificationProperty_WorkflowSpecificationNode]
GO
ALTER TABLE [dbo].[WorkflowSpecificationProperty]  WITH CHECK ADD  CONSTRAINT [FK_WorkflowSpecificationProperty_WorkflowSpecificationNodeType] FOREIGN KEY([WorkflowSpecificationNodeType])
REFERENCES [dbo].[WorkflowSpecificationNodeType] ([ID])
GO
ALTER TABLE [dbo].[WorkflowSpecificationProperty] CHECK CONSTRAINT [FK_WorkflowSpecificationProperty_WorkflowSpecificationNodeType]
GO
ALTER TABLE [dbo].[WorkflowSpecificationProperty]  WITH CHECK ADD  CONSTRAINT [FK_WorkflowSpecificationProperty_WorkflowSpecificationProperty] FOREIGN KEY([Property])
REFERENCES [dbo].[WorkflowSpecificationProperty] ([ID])
GO
ALTER TABLE [dbo].[WorkflowSpecificationProperty] CHECK CONSTRAINT [FK_WorkflowSpecificationProperty_WorkflowSpecificationProperty]
GO
ALTER TABLE [dbo].[WorkflowSpecificationType]  WITH CHECK ADD  CONSTRAINT [FK_WorkflowSpecificationType_WorkflowSpecificationInformation] FOREIGN KEY([WorkflowSpecificationInformation])
REFERENCES [dbo].[WorkflowSpecificationInformation] ([ID])
GO
ALTER TABLE [dbo].[WorkflowSpecificationType] CHECK CONSTRAINT [FK_WorkflowSpecificationType_WorkflowSpecificationInformation]
GO
ALTER TABLE [dbo].[WorkMaster]  WITH CHECK ADD  CONSTRAINT [FK_WorkMaster_WorkDefinition] FOREIGN KEY([WorkDefinitionID])
REFERENCES [dbo].[WorkDefinition] ([ID])
GO
ALTER TABLE [dbo].[WorkMaster] CHECK CONSTRAINT [FK_WorkMaster_WorkDefinition]
GO
ALTER TABLE [dbo].[WorkMaster]  WITH CHECK ADD  CONSTRAINT [FK_WorkMaster_WorkDefinitionInformation] FOREIGN KEY([WorkDefinitionInformation])
REFERENCES [dbo].[WorkDefinitionInformation] ([ID])
GO
ALTER TABLE [dbo].[WorkMaster] CHECK CONSTRAINT [FK_WorkMaster_WorkDefinitionInformation]
GO
ALTER TABLE [dbo].[WorkMasterCapability]  WITH CHECK ADD  CONSTRAINT [FK_WorkMasterCapability_WorkCapability] FOREIGN KEY([WorkCapability])
REFERENCES [dbo].[WorkCapability] ([ID])
GO
ALTER TABLE [dbo].[WorkMasterCapability] CHECK CONSTRAINT [FK_WorkMasterCapability_WorkCapability]
GO
ALTER TABLE [dbo].[WorkMasterCapability]  WITH CHECK ADD  CONSTRAINT [FK_WorkMasterCapability_WorkMaster] FOREIGN KEY([WorkMasterID])
REFERENCES [dbo].[WorkMaster] ([WorkMaster])
GO
ALTER TABLE [dbo].[WorkMasterCapability] CHECK CONSTRAINT [FK_WorkMasterCapability_WorkMaster]
GO
ALTER TABLE [dbo].[WorkMasterRecord]  WITH CHECK ADD  CONSTRAINT [FK_WorkMasterRecord_BatchProductionRecordEntry] FOREIGN KEY([BatchProductionRecordEntry])
REFERENCES [dbo].[BatchProductionRecordEntry] ([EntryID])
GO
ALTER TABLE [dbo].[WorkMasterRecord] CHECK CONSTRAINT [FK_WorkMasterRecord_BatchProductionRecordEntry]
GO
ALTER TABLE [dbo].[WorkMasterRecord]  WITH CHECK ADD  CONSTRAINT [FK_WorkMasterRecord_WorkMaster] FOREIGN KEY([WorkMaster])
REFERENCES [dbo].[WorkMaster] ([WorkMaster])
GO
ALTER TABLE [dbo].[WorkMasterRecord] CHECK CONSTRAINT [FK_WorkMasterRecord_WorkMaster]
GO
ALTER TABLE [dbo].[WorkPerformance]  WITH CHECK ADD  CONSTRAINT [FK_WorkPerformance_WorkScedule] FOREIGN KEY([WorkScheduleID])
REFERENCES [dbo].[WorkSchedule] ([ID])
GO
ALTER TABLE [dbo].[WorkPerformance] CHECK CONSTRAINT [FK_WorkPerformance_WorkScedule]
GO
ALTER TABLE [dbo].[WorkPerformanceRecord]  WITH CHECK ADD  CONSTRAINT [FK_WorkPerformanceRecord_BatchProductionRecordEntry] FOREIGN KEY([BatchProductionRecordEntry])
REFERENCES [dbo].[BatchProductionRecordEntry] ([EntryID])
GO
ALTER TABLE [dbo].[WorkPerformanceRecord] CHECK CONSTRAINT [FK_WorkPerformanceRecord_BatchProductionRecordEntry]
GO
ALTER TABLE [dbo].[WorkPerformanceRecord]  WITH CHECK ADD  CONSTRAINT [FK_WorkPerformanceRecord_WorkPerformance] FOREIGN KEY([WorkPerformance])
REFERENCES [dbo].[WorkPerformance] ([ID])
GO
ALTER TABLE [dbo].[WorkPerformanceRecord] CHECK CONSTRAINT [FK_WorkPerformanceRecord_WorkPerformance]
GO
ALTER TABLE [dbo].[WorkRequest]  WITH CHECK ADD  CONSTRAINT [FK_WorkRequest_WorkRequest] FOREIGN KEY([WorkRequest])
REFERENCES [dbo].[WorkRequest] ([ID])
GO
ALTER TABLE [dbo].[WorkRequest] CHECK CONSTRAINT [FK_WorkRequest_WorkRequest]
GO
ALTER TABLE [dbo].[WorkRequest]  WITH CHECK ADD  CONSTRAINT [FK_WorkRequest_WorkSchedule] FOREIGN KEY([WorkSchedule])
REFERENCES [dbo].[WorkSchedule] ([ID])
GO
ALTER TABLE [dbo].[WorkRequest] CHECK CONSTRAINT [FK_WorkRequest_WorkSchedule]
GO
ALTER TABLE [dbo].[WorkResponse]  WITH CHECK ADD  CONSTRAINT [FK_WorkResponse_WorkPerformance] FOREIGN KEY([WorkPerfomence])
REFERENCES [dbo].[WorkPerformance] ([ID])
GO
ALTER TABLE [dbo].[WorkResponse] CHECK CONSTRAINT [FK_WorkResponse_WorkPerformance]
GO
ALTER TABLE [dbo].[WorkResponse]  WITH CHECK ADD  CONSTRAINT [FK_WorkResponse_WorkRequest] FOREIGN KEY([WorkRequestID])
REFERENCES [dbo].[WorkRequest] ([ID])
GO
ALTER TABLE [dbo].[WorkResponse] CHECK CONSTRAINT [FK_WorkResponse_WorkRequest]
GO
ALTER TABLE [dbo].[WorkSceduleRecord]  WITH CHECK ADD  CONSTRAINT [FK_WorkSceduleRecord_BatchProductionRecordEntry] FOREIGN KEY([BatchProductionRecordEntry])
REFERENCES [dbo].[BatchProductionRecordEntry] ([EntryID])
GO
ALTER TABLE [dbo].[WorkSceduleRecord] CHECK CONSTRAINT [FK_WorkSceduleRecord_BatchProductionRecordEntry]
GO
ALTER TABLE [dbo].[WorkSceduleRecord]  WITH CHECK ADD  CONSTRAINT [FK_WorkSceduleRecord_WorkScedule] FOREIGN KEY([WorkScedule])
REFERENCES [dbo].[WorkSchedule] ([ID])
GO
ALTER TABLE [dbo].[WorkSceduleRecord] CHECK CONSTRAINT [FK_WorkSceduleRecord_WorkScedule]
GO
ALTER TABLE [dbo].[WorkSchedule]  WITH CHECK ADD  CONSTRAINT [FK_WorkScedule_WorkScedule] FOREIGN KEY([WorkShedule])
REFERENCES [dbo].[WorkSchedule] ([ID])
GO
ALTER TABLE [dbo].[WorkSchedule] CHECK CONSTRAINT [FK_WorkScedule_WorkScedule]
GO
