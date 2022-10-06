CREATE PROCEDURE [ControlFrameworkHelpers].[DeleteMetadataWithIntegrity]
AS
BEGIN
	/*
	DELETE ORDER IMPORTANT FOR REFERENTIAL INTEGRITY
	*/

	--BatchExecution
	IF OBJECT_ID(N'[ControlFramework].[BatchExecution]') IS NOT NULL 
		BEGIN
			DELETE FROM [ControlFramework].[BatchExecution];
		END;

	--CurrentExecution
	IF OBJECT_ID(N'[ControlFramework].[CurrentExecution]') IS NOT NULL 
		BEGIN
			DELETE FROM [ControlFramework].[CurrentExecution];
		END;

	--ExecutionLog
	IF OBJECT_ID(N'[ControlFramework].[ExecutionLog]') IS NOT NULL 
		BEGIN
			DELETE FROM [ControlFramework].[ExecutionLog];
		END

	--ErrorLog
	IF OBJECT_ID(N'[ControlFramework].[ExecutionLog]') IS NOT NULL 
		BEGIN
			DELETE FROM [ControlFramework].[ErrorLog];
		END

	--Batches
	IF OBJECT_ID(N'[ControlFramework].[Batches]') IS NOT NULL 
		BEGIN
			DELETE FROM [ControlFramework].[Batches];
		END;

	--Recipients
	IF OBJECT_ID(N'[ControlFramework].[Recipients]') IS NOT NULL 
		BEGIN
			DELETE FROM [ControlFramework].[Recipients];
			DBCC CHECKIDENT ('[ControlFramework].[Recipients]', RESEED, 0);
		END;

	--Properties
	IF OBJECT_ID(N'[ControlFramework].[Properties]') IS NOT NULL 
		BEGIN
			DELETE FROM [ControlFramework].[Properties];
			DBCC CHECKIDENT ('[ControlFramework].[Properties]', RESEED, 0);
		END;
		
	--Pipelines
	IF OBJECT_ID(N'[ControlFramework].[Pipelines]') IS NOT NULL 
		BEGIN
			DELETE FROM [ControlFramework].[Pipelines];
			DBCC CHECKIDENT ('[ControlFramework].[Pipelines]', RESEED, 0);
		END;

	--Orchestrators
	IF OBJECT_ID(N'[ControlFramework].[Orchestrators]') IS NOT NULL 
		BEGIN
			DELETE FROM [ControlFramework].[Orchestrators];
			DBCC CHECKIDENT ('[ControlFramework].[Orchestrators]', RESEED, 0);
		END;

	--Stages
	IF OBJECT_ID(N'[ControlFramework].[Stages]') IS NOT NULL 
		BEGIN
			DELETE FROM [ControlFramework].[Stages];
			DBCC CHECKIDENT ('[ControlFramework].[Stages]', RESEED, 0);
		END;

END;

GO

