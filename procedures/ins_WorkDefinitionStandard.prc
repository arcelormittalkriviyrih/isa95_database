--------------------------------------------------------------
-- Процедура ins_WorkDefinitionStandard
IF OBJECT_ID ('dbo.ins_WorkDefinitionStandard',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_WorkDefinitionStandard;
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ins_WorkDefinitionStandard]
@EquipmentID    INT,
@COMM_ORDER     NVARCHAR(50),
@PROD_ORDER     NVARCHAR(50),
@CONTRACT_NO    NVARCHAR(50) = NULL,
@DIRECTION      NVARCHAR(50) = NULL,
@SIZE           NVARCHAR(50) = NULL,
@LENGTH         NVARCHAR(50) = NULL,
@TOLERANCE      NVARCHAR(50) = NULL,
@CLASS          NVARCHAR(50) = NULL,
@STEEL_CLASS    NVARCHAR(50) = NULL,
@MELT_NO        NVARCHAR(50) = NULL,
@PART_NO        NVARCHAR(50) = NULL,
@MIN_ROD        NVARCHAR(50) = NULL,
@BUYER_ORDER_NO NVARCHAR(50) = NULL,
@BRIGADE_NO     NVARCHAR(50) = NULL,
@PROD_DATE      NVARCHAR(50) = NULL,
@UTVK           NVARCHAR(50) = NULL,
@LEAVE_NO       NVARCHAR(50) = NULL,
@MATERIAL_NO    NVARCHAR(50) = NULL,
@BUNT_DIA       NVARCHAR(50) = NULL,
@BUNT_NO        NVARCHAR(50) = NULL,
@PRODUCT        NVARCHAR(50) = NULL,
@STANDARD       NVARCHAR(50) = NULL,
@CHEM_ANALYSIS  NVARCHAR(50) = NULL,
@TEMPLATE       INT          = NULL
AS
BEGIN

EXEC [dbo].[ins_WorkDefinition] @WorkType       = N'Standard',
                                @EquipmentID    = @EquipmentID,
                                @COMM_ORDER     = @COMM_ORDER,
                                @PROD_ORDER     = @PROD_ORDER,
                                @CONTRACT_NO    = @CONTRACT_NO,
                                @DIRECTION      = @DIRECTION,
                                @SIZE           = @SIZE,
                                @LENGTH         = @LENGTH,
                                @TOLERANCE      = @TOLERANCE,
                                @CLASS          = @CLASS,
                                @STEEL_CLASS    = @STEEL_CLASS,
                                @MELT_NO        = @MELT_NO,
                                @PART_NO        = @PART_NO,
                                @MIN_ROD        = @MIN_ROD,
                                @BUYER_ORDER_NO = @BUYER_ORDER_NO,
                                @BRIGADE_NO     = @BRIGADE_NO,
                                @PROD_DATE      = @PROD_DATE,
                                @UTVK           = @UTVK,
                                @LEAVE_NO       = @LEAVE_NO,
                                @MATERIAL_NO    = @MATERIAL_NO,
                                @BUNT_DIA       = @BUNT_DIA,
                                @BUNT_NO        = @BUNT_NO,
                                @PRODUCT        = @PRODUCT,
                                @STANDARD       = @STANDARD,
                                @CHEM_ANALYSIS  = @CHEM_ANALYSIS,
                                @TEMPLATE       = @TEMPLATE;

END;
GO

