CREATE PROCEDURE [ControlFramework].[CheckPreviousExecution]
	(
	@BatchName VARCHAR(255) = NULL
	)
AS
BEGIN
	SET NOCOUNT ON;
	/*
	Check A: - Are there any Running pipelines that need to be cleaned up?
	*/

	DECLARE @BatchId UNIQUEIDENTIFIER
	DECLARE @LocalExecutionId UNIQUEIDENTIFIER

	--Check A:
	IF ([ControlFramework].[GetPropertyValueInternal]('UseExecutionBatches')) = '0'
		BEGIN
			IF EXISTS
				(
				SELECT 
					1 
				FROM 
					[ControlFramework].[CurrentExecution] 
				WHERE 
					[PipelineStatus] NOT IN ('Success','Failed','Blocked', 'Cancelled') 
					AND [PipelineRunId] IS NOT NULL
				)
				BEGIN
					--return pipelines details that require a clean up
					SELECT 
						[OrchestratorResourceGroupName],
						[OrchestratorType],
						[OrchestratorName],
						[SubscriptionId],
						[ResourceGroupName],
						[DataFactoryName],
						[PipelineName],
						[PipelineRunId],
						[LocalExecutionId],
						[StageId],
						[PipelineId],
						[ConfigId]
					FROM 
						[ControlFramework].[CurrentExecution]
					WHERE 
						[PipelineStatus] NOT IN ('Success','Failed','Blocked','Cancelled') 
						AND [PipelineRunId] IS NOT NULL
				END;
			ELSE
				GOTO LookUpReturnEmptyResult;
		END
	ELSE IF ([ControlFramework].[GetPropertyValueInternal]('UseExecutionBatches')) = '1'
		BEGIN
			IF @BatchName IS NULL
				BEGIN
					RAISERROR('A NULL batch name cannot be passed when the UseExecutionBatches property is set to 1 (true).',16,1);
					RETURN 0;
				END
			
			IF EXISTS
				(
				SELECT 
					1 
				FROM 
					[ControlFramework].[CurrentExecution] ce
					INNER JOIN [ControlFramework].[BatchExecution] be
						ON ce.[LocalExecutionId] = be.[ExecutionId]
					INNER JOIN [ControlFramework].[Batches] b
						ON be.[BatchId] = b.[BatchId]
				WHERE 
					b.[BatchName] = @BatchName
					AND ce.[PipelineStatus] NOT IN ('Success','Failed','Blocked','Cancelled') 
					AND ce.[PipelineRunId] IS NOT NULL
				)
				BEGIN
					--return pipelines details that require a clean up
					SELECT 
						ce.[OrchestratorResourceGroupName],
						ce.[OrchestratorType],
						ce.[OrchestratorName],
						ce.[SubscriptionId],
						ce.[ResourceGroupName],
						ce.[DataFactoryName],
						ce.[PipelineName],
						ce.[PipelineRunId],
						ce.[LocalExecutionId],
						ce.[StageId],
						ce.[PipelineId],
						ce.[ConfigId]
					FROM 
						[ControlFramework].[CurrentExecution] ce
						INNER JOIN [ControlFramework].[BatchExecution] be
							ON ce.[LocalExecutionId] = be.[ExecutionId]
						INNER JOIN [ControlFramework].[Batches] b
							ON be.[BatchId] = b.[BatchId]
					WHERE 
						b.[BatchName] = @BatchName
						AND ce.[PipelineStatus] NOT IN ('Success','Failed','Blocked','Cancelled') 
						AND ce.[PipelineRunId] IS NOT NULL
				END;
			ELSE
				GOTO LookUpReturnEmptyResult;
		END
	
	LookUpReturnEmptyResult:
	--lookup activity must return something, even if just an empty dataset
	SELECT 
		NULL AS OrchestratorResourceGroupName,
		NULL AS OrchestratorType,
		NULL AS OrchestratorName,
		NULL AS SubscriptionId,
		NULL AS ResourceGroupName,
		NULL AS DataFactoryName,
		NULL AS PipelineName,
		NULL AS PipelineRunId,
		NULL AS LocalExecutionId,
		NULL AS StageId,
		NULL AS PipelineId,
		NULL AS ConfigId
	FROM
		[ControlFramework].[CurrentExecution]
	WHERE
		1 = 2; --ensure no results
END;

GO

