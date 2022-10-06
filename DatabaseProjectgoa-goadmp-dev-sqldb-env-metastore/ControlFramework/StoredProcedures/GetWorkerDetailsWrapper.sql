CREATE PROCEDURE [ControlFramework].[GetWorkerDetailsWrapper]
	(
	@ExecutionId UNIQUEIDENTIFIER,
	@StageId INT,
	@PipelineId INT
	)
AS
BEGIN
	/*
	Created this proc just to reduce and refactor the number of pipeline activity 
	calls needed due to the Microsoft enforced limit of 40 activities per pipeline.
	*/
	SET NOCOUNT ON;

	DECLARE @WorkerAuthDetails TABLE
		(
		[orchestratortenantId] UNIQUEIDENTIFIER NULL,
		[orchestratorSubscriptionId] UNIQUEIDENTIFIER NULL,
		[orchestratorName] NVARCHAR(200) NULL,
		[orchestratorType] CHAR(3) NULL,
		[orchestratorResourceGroupName] NVARCHAR(200) NULL
		)

	DECLARE @WorkerDetails TABLE
		(
		[subscriptionId] UNIQUEIDENTIFIER NULL,
		[resourceGroupName] NVARCHAR(200) NULL,
		[dataFactoryName] NVARCHAR(200) NULL,
		[pipelineName] NVARCHAR(200) NULL
		)

	--get work auth details
	INSERT INTO @WorkerAuthDetails
		(
		[orchestratortenantId],
		[orchestratorSubscriptionId],
		[orchestratorName],
		[orchestratorType],
		[orchestratorResourceGroupName]
		)
	EXEC [ControlFramework].[GetWorkerAuthDetails]
		@ExecutionId = @ExecutionId,
		@StageId = @StageId,
		@PipelineId = @PipelineId;

	--get main worker details
	INSERT INTO @WorkerDetails
		(
		[pipelineName],
		[dataFactoryName],
		[resourceGroupName],
		[subscriptionId]
		)
	EXEC [ControlFramework].[GetWorkerPipelineDetails]
		@ExecutionId = @ExecutionId,
		@StageId = @StageId,
		@PipelineId = @PipelineId;		
	
	--return all details
	SELECT  
		ad.[orchestratorTenantId],	
		ad.[orchestratorSubscriptionId],
		ad.[orchestratorResourceGroupName],
		ad.[orchestratorName],
		ad.[orchestratorType],
		d.[subscriptionId],
		d.[resourceGroupName],
		d.[dataFactoryName],
		d.[pipelineName]
	FROM 
		@WorkerDetails d 
		CROSS JOIN @WorkerAuthDetails ad;
END;

GO

