SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

IF OBJECT_ID('dbo.del_Equipment', N'P') IS NOT NULL
    DROP PROCEDURE dbo.del_Equipment; 

IF OBJECT_ID('dbo.del_EquipmentClass', N'P') IS NOT NULL
    DROP PROCEDURE dbo.del_EquipmentClass; 

IF OBJECT_ID('dbo.del_EquipmentClassProperty', N'P') IS NOT NULL
    DROP PROCEDURE dbo.del_EquipmentClassProperty;

IF OBJECT_ID('dbo.del_EquipmentProperty', N'P') IS NOT NULL
    DROP PROCEDURE dbo.del_EquipmentProperty;

IF OBJECT_ID('dbo.del_EquipmentRequirement', N'P') IS NOT NULL
    DROP PROCEDURE dbo.del_EquipmentRequirement;

IF OBJECT_ID('dbo.del_Files', N'P') IS NOT NULL
    DROP PROCEDURE dbo.del_Files;

IF OBJECT_ID('dbo.del_MaterialActual', N'P') IS NOT NULL
    DROP PROCEDURE dbo.del_MaterialActual;

IF OBJECT_ID('dbo.del_MaterialClass', N'P') IS NOT NULL
    DROP PROCEDURE dbo.del_MaterialClass;

IF OBJECT_ID('dbo.del_MaterialDefinition', N'P') IS NOT NULL
    DROP PROCEDURE dbo.del_MaterialDefinition;

IF OBJECT_ID('dbo.del_MaterialDefinitionProperty', N'P') IS NOT NULL
    DROP PROCEDURE dbo.del_MaterialDefinitionProperty;

IF OBJECT_ID('dbo.del_MaterialLot', N'P') IS NOT NULL
    DROP PROCEDURE dbo.del_MaterialLot;

IF OBJECT_ID('dbo.del_MaterialLotProperty', N'P') IS NOT NULL
    DROP PROCEDURE dbo.del_MaterialLotProperty;

IF OBJECT_ID('dbo.del_ProcessSegment', N'P') IS NOT NULL
    DROP PROCEDURE dbo.del_ProcessSegment;

IF OBJECT_ID('dbo.del_ProductionParameter', N'P') IS NOT NULL
    DROP PROCEDURE dbo.del_ProductionParameter;

IF OBJECT_ID('dbo.del_ProductionRequest', N'P') IS NOT NULL
    DROP PROCEDURE dbo.del_ProductionRequest;

IF OBJECT_ID('dbo.del_ProductionResponse', N'P') IS NOT NULL
    DROP PROCEDURE dbo.del_ProductionResponse;

IF OBJECT_ID('dbo.del_ProductSegment', N'P') IS NOT NULL
    DROP PROCEDURE dbo.del_ProductSegment;

IF OBJECT_ID('dbo.del_PropertyTypes', N'P') IS NOT NULL
    DROP PROCEDURE dbo.del_PropertyTypes;

IF OBJECT_ID('dbo.del_SegmentRequirement', N'P') IS NOT NULL
    DROP PROCEDURE dbo.del_SegmentRequirement;

IF OBJECT_ID('dbo.del_SegmentResponse', N'P') IS NOT NULL
    DROP PROCEDURE dbo.del_SegmentResponse;

IF OBJECT_ID('dbo.ins_Equipment', N'P') IS NOT NULL
    DROP PROCEDURE dbo.ins_Equipment;

IF OBJECT_ID('dbo.ins_EquipmentClass', N'P') IS NOT NULL
    DROP PROCEDURE dbo.ins_EquipmentClass;

IF OBJECT_ID('dbo.ins_EquipmentClassProperty', N'P') IS NOT NULL
    DROP PROCEDURE dbo.ins_EquipmentClassProperty;

IF OBJECT_ID('dbo.ins_EquipmentProperty', N'P') IS NOT NULL
    DROP PROCEDURE dbo.ins_EquipmentProperty;

IF OBJECT_ID('dbo.ins_EquipmentRequirement', N'P') IS NOT NULL
    DROP PROCEDURE dbo.ins_EquipmentRequirement;

IF OBJECT_ID('dbo.ins_Files', N'P') IS NOT NULL
    DROP PROCEDURE dbo.ins_Files;

IF OBJECT_ID('dbo.ins_MaterialActual', N'P') IS NOT NULL
    DROP PROCEDURE dbo.ins_MaterialActual;

IF OBJECT_ID('dbo.ins_MaterialClass', N'P') IS NOT NULL
    DROP PROCEDURE dbo.ins_MaterialClass;

IF OBJECT_ID('dbo.ins_MaterialDefinition', N'P') IS NOT NULL
    DROP PROCEDURE dbo.ins_MaterialDefinition;

IF OBJECT_ID('dbo.ins_MaterialDefinitionProperty', N'P') IS NOT NULL
    DROP PROCEDURE dbo.ins_MaterialDefinitionProperty;

IF OBJECT_ID('dbo.ins_MaterialLot', N'P') IS NOT NULL
    DROP PROCEDURE dbo.ins_MaterialLot;

IF OBJECT_ID('dbo.ins_MaterialLotByController', N'P') IS NOT NULL
    DROP PROCEDURE dbo.ins_MaterialLotByController;

IF OBJECT_ID('dbo.ins_MaterialLotProperty', N'P') IS NOT NULL
    DROP PROCEDURE dbo.ins_MaterialLotProperty;

IF OBJECT_ID('dbo.ins_ProcessSegment', N'P') IS NOT NULL
    DROP PROCEDURE dbo.ins_ProcessSegment;

IF OBJECT_ID('dbo.ins_ProductionParameter', N'P') IS NOT NULL
    DROP PROCEDURE dbo.ins_ProductionParameter;

IF OBJECT_ID('dbo.ins_ProductionRequest', N'P') IS NOT NULL
    DROP PROCEDURE dbo.ins_ProductionRequest;

IF OBJECT_ID('dbo.ins_ProductionResponse', N'P') IS NOT NULL
    DROP PROCEDURE dbo.ins_ProductionResponse;

IF OBJECT_ID('dbo.ins_ProductSegment', N'P') IS NOT NULL
    DROP PROCEDURE dbo.ins_ProductSegment;

IF OBJECT_ID('dbo.ins_PropertyTypes', N'P') IS NOT NULL
    DROP PROCEDURE dbo.ins_PropertyTypes;

IF OBJECT_ID('dbo.ins_SegmentRequirement', N'P') IS NOT NULL
    DROP PROCEDURE dbo.ins_SegmentRequirement;

IF OBJECT_ID('dbo.ins_SegmentResponse', N'P') IS NOT NULL
    DROP PROCEDURE dbo.ins_SegmentResponse;

IF OBJECT_ID('dbo.test_proc', N'P') IS NOT NULL
    DROP PROCEDURE dbo.test_proc;

IF OBJECT_ID('dbo.upd_Equipment', N'P') IS NOT NULL
    DROP PROCEDURE dbo.upd_Equipment;

IF OBJECT_ID('dbo.upd_EquipmentClass', N'P') IS NOT NULL
    DROP PROCEDURE dbo.upd_EquipmentClass;

IF OBJECT_ID('dbo.upd_EquipmentClassProperty', N'P') IS NOT NULL
    DROP PROCEDURE dbo.upd_EquipmentClassProperty;

IF OBJECT_ID('dbo.upd_EquipmentProperty', N'P') IS NOT NULL
    DROP PROCEDURE dbo.upd_EquipmentProperty;

IF OBJECT_ID('dbo.upd_EquipmentRequirement', N'P') IS NOT NULL
    DROP PROCEDURE dbo.upd_EquipmentRequirement;

IF OBJECT_ID('dbo.upd_Files', N'P') IS NOT NULL
    DROP PROCEDURE dbo.upd_Files;

IF OBJECT_ID('dbo.upd_MaterialActual', N'P') IS NOT NULL
    DROP PROCEDURE dbo.upd_MaterialActual;

IF OBJECT_ID('dbo.upd_MaterialClass', N'P') IS NOT NULL
    DROP PROCEDURE dbo.upd_MaterialClass;

IF OBJECT_ID('dbo.upd_MaterialDefinition', N'P') IS NOT NULL
    DROP PROCEDURE dbo.upd_MaterialDefinition;

IF OBJECT_ID('dbo.upd_MaterialDefinitionProperty', N'P') IS NOT NULL
    DROP PROCEDURE dbo.upd_MaterialDefinitionProperty;

IF OBJECT_ID('dbo.upd_MaterialLot', N'P') IS NOT NULL
    DROP PROCEDURE dbo.upd_MaterialLot;

IF OBJECT_ID('dbo.upd_MaterialLotProperty', N'P') IS NOT NULL
    DROP PROCEDURE dbo.upd_MaterialLotProperty;

IF OBJECT_ID('dbo.upd_ProcessSegment', N'P') IS NOT NULL
    DROP PROCEDURE dbo.upd_ProcessSegment;

IF OBJECT_ID('dbo.upd_ProductionParameter', N'P') IS NOT NULL
    DROP PROCEDURE dbo.upd_ProductionParameter;

IF OBJECT_ID('dbo.upd_ProductionRequest', N'P') IS NOT NULL
    DROP PROCEDURE dbo.upd_ProductionRequest;

IF OBJECT_ID('dbo.upd_ProductionResponse', N'P') IS NOT NULL
    DROP PROCEDURE dbo.upd_ProductionResponse;

IF OBJECT_ID('dbo.upd_ProductSegment', N'P') IS NOT NULL
    DROP PROCEDURE dbo.upd_ProductSegment;

IF OBJECT_ID('dbo.upd_PropertyTypes', N'P') IS NOT NULL
    DROP PROCEDURE dbo.upd_PropertyTypes;

IF OBJECT_ID('dbo.upd_SegmentRequirement', N'P') IS NOT NULL
    DROP PROCEDURE dbo.upd_SegmentRequirement;

IF OBJECT_ID('dbo.upd_SegmentResponse', N'P') IS NOT NULL
    DROP PROCEDURE dbo.upd_SegmentResponse;

IF OBJECT_ID('dbo.get_MaterialLot', N'TF') IS NOT NULL
    DROP FUNCTION dbo.get_MaterialLot;

IF OBJECT_ID('dbo.get_MaterialLotProperty', N'TF') IS NOT NULL
    DROP FUNCTION dbo.get_MaterialLotProperty;

IF OBJECT_ID('dbo.get_ProcessSegment', N'TF') IS NOT NULL
    DROP FUNCTION dbo.get_ProcessSegment;

IF OBJECT_ID('dbo.get_ProductionParameter', N'TF') IS NOT NULL
    DROP FUNCTION dbo.get_ProductionParameter;

IF OBJECT_ID('dbo.get_ProductionRequest', N'TF') IS NOT NULL
    DROP FUNCTION dbo.get_ProductionRequest;

IF OBJECT_ID('dbo.get_ProductionResponse', N'TF') IS NOT NULL
    DROP FUNCTION dbo.get_ProductionResponse;

IF OBJECT_ID('dbo.get_ProductSegment', N'TF') IS NOT NULL
    DROP FUNCTION dbo.get_ProductSegment;

IF OBJECT_ID('dbo.get_PropertyTypes', N'TF') IS NOT NULL
    DROP FUNCTION dbo.get_PropertyTypes;

IF OBJECT_ID('dbo.get_SegmentRequirement', N'TF') IS NOT NULL
    DROP FUNCTION dbo.get_SegmentRequirement;

IF OBJECT_ID('dbo.get_SegmentResponse', N'TF') IS NOT NULL
    DROP FUNCTION dbo.get_SegmentResponse;

IF OBJECT_ID('dbo.ins_TEMP', N'TF') IS NOT NULL
    DROP FUNCTION dbo.ins_TEMP;

IF OBJECT_ID('dbo.get_Equipment', N'TF') IS NOT NULL
    DROP FUNCTION dbo.get_Equipment;

IF OBJECT_ID('dbo.get_EquipmentClass', N'TF') IS NOT NULL
    DROP FUNCTION dbo.get_EquipmentClass;

IF OBJECT_ID('dbo.get_EquipmentClassProperty', N'TF') IS NOT NULL
    DROP FUNCTION dbo.get_EquipmentClassProperty;

IF OBJECT_ID('dbo.get_EquipmentProperty', N'TF') IS NOT NULL
    DROP FUNCTION dbo.get_EquipmentProperty;

IF OBJECT_ID('dbo.get_EquipmentRequirement', N'TF') IS NOT NULL
    DROP FUNCTION dbo.get_EquipmentRequirement;

IF OBJECT_ID('dbo.get_Files', N'TF') IS NOT NULL
    DROP FUNCTION dbo.get_Files;

IF OBJECT_ID('dbo.get_MaterialActual', N'TF') IS NOT NULL
    DROP FUNCTION dbo.get_MaterialActual;

IF OBJECT_ID('dbo.get_MaterialClass', N'TF') IS NOT NULL
    DROP FUNCTION dbo.get_MaterialClass;

IF OBJECT_ID('dbo.get_MaterialDefinition', N'TF') IS NOT NULL
    DROP FUNCTION dbo.get_MaterialDefinition;

IF OBJECT_ID('dbo.get_MaterialDefinitionProperty', N'TF') IS NOT NULL
    DROP FUNCTION dbo.get_MaterialDefinitionProperty;