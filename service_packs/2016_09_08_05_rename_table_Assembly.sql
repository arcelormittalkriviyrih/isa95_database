exec sp_rename MaterialAssembliesClass, MaterialClassAssemblies
go

exec sp_rename MaterialAssembliesDefinition, MaterialDefinitionAssemblies
go

exec sp_rename MaterialAssembliesLot, MaterialLotAssemblies
go

exec sp_rename PackagingAssembliesClass, PackagingClassAssemblies
go

exec sp_rename PackagingAssembliesDefinition, PackagingDefinitionAssemblies
go

exec sp_rename PackagingAssembliesUnits, PackagingUnitsAssemblies
go
