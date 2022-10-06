CREATE PROCEDURE [ControlFramework].[GetWorkerAuthDetails]
	(
	@ExecutionId UNIQUEIDENTIFIER,
	@StageId INT,
	@PipelineId INT
	)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @TenId UNIQUEIDENTIFIER
	DECLARE @SubId UNIQUEIDENTIFIER

	DECLARE @OrchestratorName NVARCHAR(200)
	DECLARE @OrchestratorType CHAR(3)
	DECLARE @OrchestratorResourceGroupName NVARCHAR(200)
	DECLARE @PipelineName NVARCHAR(200)

	SELECT 
		@PipelineName = [PipelineName],
		@OrchestratorName = [OrchestratorName],
		@OrchestratorType = [OrchestratorType],
		@OrchestratorResourceGroupName = [OrchestratorResourceGroupName]
	FROM 
		[ControlFramework].[CurrentExecution]
	WHERE 
		[LocalExecutionId] = @ExecutionId
		AND [StageId] = @StageId
		AND [PipelineId] = @PipelineId;
		
		WITH cte AS
				(
				SELECT DISTINCT
					D.[TenantId],
					D.[SubscriptionId]
				FROM
					[ControlFramework].[Pipelines] P
					INNER JOIN [ControlFramework].[Orchestrators] D
						ON P.[OrchestratorId] = D.[OrchestratorId]
				WHERE
					P.[PipelineName] = @PipelineName
					AND D.[OrchestratorName] = @OrchestratorName
					AND D.[OrchestratorType] = @OrchestratorType
				)
			SELECT TOP 1
				@TenId = [TenantId],
				@SubId = [SubscriptionId]
			FROM
				cte
	SELECT
		@TenId AS TenantId,
		@SubId AS SubscriptionId,
		@OrchestratorName AS OrchestratorName,
		@OrchestratorType AS OrchestratorType,
		@OrchestratorResourceGroupName AS OrchestratorResourceGroupName
END;

GO

