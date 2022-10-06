
CREATE PROCEDURE [ControlFramework].[CreateNewExecution]
	(
	@CallingOrchestratorName NVARCHAR(200),
	@LocalExecutionId UNIQUEIDENTIFIER = NULL
	)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @BatchId UNIQUEIDENTIFIER;

	IF([ControlFramework].[GetPropertyValueInternal]('UseExecutionBatches')) = '0'
		BEGIN
			SET @LocalExecutionId = NEWID();

			DELETE FROM [ControlFramework].[CurrentExecution];

			--defensive check
			IF NOT EXISTS
				(
				SELECT
					1
				FROM
					[ControlFramework].[Pipelines] p
					INNER JOIN [ControlFramework].[Parameters] params
						ON p.[PipelineId] = params.[PipelineId]
					INNER JOIN [ControlFramework].[Stages] s
						ON p.[StageId] = s.[StageId]
					INNER JOIN [ControlFramework].[Orchestrators] d
						ON p.[OrchestratorId] = d.[OrchestratorId]
				WHERE
					p.[Enabled] = 1
					AND s.[Enabled] = 1
					AND params.[ExcludeInGeneral] = 0
				)
				BEGIN
					RAISERROR('Requested execution run does not contain any enabled stages/pipelines.',16,1);
					RETURN 0;
				END;
				
			INSERT INTO [ControlFramework].[CurrentExecution]
				(
				[LocalExecutionId],
				[StageId],
				[PipelineId],
				[ConfigId],
				[CallingOrchestratorName],
				[OrchestratorResourceGroupName],
				[OrchestratorType],
				[OrchestratorName],
				[SubscriptionId],
				[ResourceGroupName],
				[DataFactoryName],
				[PipelineName],
				[SourceSchema],
				[SourceTable],
				[SourceSQL],
				[SourceContainer],
				[SourceFolder],
				[SourceFileName],
				[SourceURL],
				[SourceConnectionURL],
				[SourceConnectionSecret],
				[DestinationSchema],
				[DestinationTable],
				[DestinationContainer],
				[DestinationFolder],
				[DestinationFileName],
				[DestinationURL],
				[DestinationConnectionURL],
				[DestinationConnectionSecret],
				[DestinationExternalDataSource],
				[DestinationExternalLocation],
				[SynapseSchema],
				[SynapseTable],
				[SynapseScript],
				[SynapseConnectionURL],
				[SynapseConnectionSecret],
				[Script],
				[JsonRoot],
				[rdps],
				[run],
				[hour],
				[dim_reference_time],
				[time],
				[subsetx],
				[subsety],
				[format],
				[APIURL],
				[APILoginURL],
				[DataBricksURL],
				[DataBricksResourceID],
				[SparkClusterVersion],
				[SparkClusterNodeType],
				[SparkPythonVersion],
				[NoteBookPath],
				[ConcurrentNotebooks],
				[RunDate],
				[ExcludeInGeneral],
				[JobDescription],
				[ProjectName],
				[JobVersion],
				[LoadType],
				[WatermarkColumn],
				[WatermarkValue],
				[Frequency],
				[SecurityClassification],
				[ExecutionMachine],
				[DataOwnerId],
				[SourceSystem],
				[SourceAssetName],
				[SourceDataZone],
				[TargetSystem],
				[TargetAssetID],
				[TargetAssetName],
				[TargetDataZone],
				[ExecutionUserId],
				[ProcessorMessage],
				[RecordCount]
				)
			SELECT
				@LocalExecutionId,
				p.[StageId],
				p.[PipelineId],
				params.[ConfigId],
				@CallingOrchestratorName,
				d.[OrchestratorResourceGroupName],
				d.[OrchestratorType],
				d.[OrchestratorName],
				p.[SubscriptionId],
				p.[ResourceGroupName],
				p.[DataFactoryName],
				p.[PipelineName],
				params.[SourceSchema],
				params.[SourceTable],
				params.[SourceSQL],
				params.[SourceContainer],
				params.[SourceFolder],
				params.[SourceFileName],
				params.[SourceURL],
				params.[SourceConnectionURL],
				params.[SourceConnectionSecret],
				params.[DestinationSchema],
				params.[DestinationTable],
				params.[DestinationContainer],
				params.[DestinationFolder],
				params.[DestinationFileName],
				params.[DestinationURL],
				params.[DestinationConnectionURL],
				params.[DestinationConnectionSecret],
				params.[DestinationExternalDataSource],
				params.[DestinationExternalLocation],
				params.[SynapseSchema],
				params.[SynapseTable],
				params.[SynapseScript],
				params.[SynapseConnectionURL],
				params.[SynapseConnectionSecret],
				params.[Script],
				params.[JsonRoot],
				params.[rdps],
				params.[run],
				params.[hour],
				params.[dim_reference_time],
				params.[time],
				params.[subsetx],
				params.[subsety],
				params.[format],
				params.[APIURL],
				params.[APILoginURL],
				params.[DataBricksURL],
				params.[DataBricksResourceID],
				params.[SparkClusterVersion],
				params.[SparkClusterNodeType],
				params.[SparkPythonVersion],
				params.[NoteBookPath],
				params.[ConcurrentNotebooks],
				params.[RunDate],
				params.[ExcludeInGeneral],
				params.[JobDescription],
				params.[ProjectName],
				params.[JobVersion],
				params.[LoadType],
				params.[WatermarkColumn],
				params.[WatermarkValue],
				params.[Frequency],
				params.[SecurityClassification],
				params.[ExecutionMachine],
				params.[DataOwnerId],
				params.[SourceSystem],
				params.[SourceAssetName],
				params.[SourceDataZone],
				params.[TargetSystem],
				params.[TargetAssetID],
				params.[TargetAssetName],
				params.[TargetDataZone],
				SYSTEM_USER,
				'Start Execution (UseExecutionBatches = 0)',
				1
			FROM
				[ControlFramework].[Pipelines] p
				INNER JOIN [ControlFramework].[Parameters] params
					ON p.[PipelineId] = params.[PipelineId]
				INNER JOIN [ControlFramework].[Stages] s
					ON p.[StageId] = s.[StageId]
				INNER JOIN [ControlFramework].[Orchestrators] d
					ON p.[OrchestratorId] = d.[OrchestratorId]
			WHERE
				p.[Enabled] = 1
				AND s.[Enabled] = 1
				AND params.[ExcludeInGeneral] = 0;
				
			SELECT
				@LocalExecutionId AS ExecutionId;
		END
	ELSE IF ([ControlFramework].[GetPropertyValueInternal]('UseExecutionBatches')) = '1'
		BEGIN
			DELETE FROM 
				[ControlFramework].[CurrentExecution]
			WHERE
				[LocalExecutionId] = @LocalExecutionId;

			SELECT
				@BatchId = [BatchId]
			FROM
				[ControlFramework].[BatchExecution]
			WHERE
				[ExecutionId] = @LocalExecutionId;
			
			--defensive check
			IF NOT EXISTS
				(
				SELECT
					1
				FROM
					[ControlFramework].[Pipelines] p
					INNER JOIN [ControlFramework].[Parameters] params
						ON p.[PipelineId] = params.[PipelineId]
					INNER JOIN [ControlFramework].[Stages] s
						ON p.[StageId] = s.[StageId]
					INNER JOIN [ControlFramework].[Orchestrators] d
						ON p.[OrchestratorId] = d.[OrchestratorId]
				WHERE
					p.[BatchId] = @BatchId
					AND p.[Enabled] = 1
					AND s.[Enabled] = 1
					AND params.[ExcludeInGeneral] = 0
				)
				BEGIN
					RAISERROR('Requested execution run does not contain any enabled stages/pipelines.',16,1);
					RETURN 0;
				END;

			INSERT INTO [ControlFramework].[CurrentExecution]
				(
				[LocalExecutionId],
				[StageId],
				[PipelineId],
				[ConfigId],
				[CallingOrchestratorName],
				[OrchestratorResourceGroupName],
				[OrchestratorType],
				[OrchestratorName],
				[SubscriptionId],
				[ResourceGroupName],
				[DataFactoryName],
				[PipelineName],
				[SourceSchema],
				[SourceTable],
				[SourceSQL],
				[SourceContainer],
				[SourceFolder],
				[SourceFileName],
				[SourceURL],
				[SourceConnectionURL],
				[SourceConnectionSecret],
				[DestinationSchema],
				[DestinationTable],
				[DestinationContainer],
				[DestinationFolder],
				[DestinationFileName],
				[DestinationURL],
				[DestinationConnectionURL],
				[DestinationConnectionSecret],
				[DestinationExternalDataSource],
				[DestinationExternalLocation],
				[SynapseSchema],
				[SynapseTable],
				[SynapseScript],
				[SynapseConnectionURL],
				[SynapseConnectionSecret],
				[Script],
				[JsonRoot],
				[rdps],
				[run],
				[hour],
				[dim_reference_time],
				[time],
				[subsetx],
				[subsety],
				[format],
				[APIURL],
				[APILoginURL],
				[DataBricksURL],
				[DataBricksResourceID],
				[SparkClusterVersion],
				[SparkClusterNodeType],
				[SparkPythonVersion],
				[NoteBookPath],
				[ConcurrentNotebooks],
				[RunDate],
				[ExcludeInGeneral],
				[JobDescription],
				[ProjectName],
				[JobVersion],
				[LoadType],
				[WatermarkColumn],
				[WatermarkValue],
				[Frequency],
				[SecurityClassification],
				[ExecutionMachine],
				[DataOwnerId],
				[SourceSystem],
				[SourceAssetName],
				[SourceDataZone],
				[TargetSystem],
				[TargetAssetID],
				[TargetAssetName],
				[TargetDataZone],
				[ExecutionUserId],
				[ProcessorMessage],
				[RecordCount]
				)
			SELECT
				@LocalExecutionId,
				p.[StageId],
				p.[PipelineId],
				params.[ConfigId],
				@CallingOrchestratorName,
				d.[OrchestratorResourceGroupName],
				d.[OrchestratorType],
				d.[OrchestratorName],
				p.[SubscriptionId],
				p.[ResourceGroupName],
				p.[DataFactoryName],
				p.[PipelineName],
				params.[SourceSchema],
				params.[SourceTable],
				params.[SourceSQL],
				params.[SourceContainer],
				params.[SourceFolder],
				params.[SourceFileName],
				params.[SourceURL],
				params.[SourceConnectionURL],
				params.[SourceConnectionSecret],
				params.[DestinationSchema],
				params.[DestinationTable],
				params.[DestinationContainer],
				params.[DestinationFolder],
				params.[DestinationFileName],
				params.[DestinationURL],
				params.[DestinationConnectionURL],
				params.[DestinationConnectionSecret],
				params.[DestinationExternalDataSource],
				params.[DestinationExternalLocation],
				params.[SynapseSchema],
				params.[SynapseTable],
				params.[SynapseScript],
				params.[SynapseConnectionURL],
				params.[SynapseConnectionSecret],
				params.[Script],
				params.[JsonRoot],
				params.[rdps],
				params.[run],
				params.[hour],
				params.[dim_reference_time],
				params.[time],
				params.[subsetx],
				params.[subsety],
				params.[format],
				params.[APIURL],
				params.[APILoginURL],
				params.[DataBricksURL],
				params.[DataBricksResourceID],
				params.[SparkClusterVersion],
				params.[SparkClusterNodeType],
				params.[SparkPythonVersion],
				params.[NoteBookPath],
				params.[ConcurrentNotebooks],
				params.[RunDate],
				params.[ExcludeInGeneral],
				params.[JobDescription],
				params.[ProjectName],
				params.[JobVersion],
				params.[LoadType],
				params.[WatermarkColumn],
				params.[WatermarkValue],
				params.[Frequency],
				params.[SecurityClassification],
				params.[ExecutionMachine],
				params.[DataOwnerId],
				params.[SourceSystem],
				params.[SourceAssetName],
				params.[SourceDataZone],
				params.[TargetSystem],
				params.[TargetAssetID],
				params.[TargetAssetName],
				params.[TargetDataZone],
				SYSTEM_USER,
				'Start Execution (UseExecutionBatches = 1)',
				1
			FROM
				[ControlFramework].[Pipelines] p
				INNER JOIN [ControlFramework].[Parameters] params
					ON p.[PipelineId] = params.[PipelineId]
				INNER JOIN [ControlFramework].[Stages] s
					ON p.[StageId] = s.[StageId]
				INNER JOIN [ControlFramework].[Orchestrators] d
					ON p.[OrchestratorId] = d.[OrchestratorId]
			WHERE
				p.[BatchId] = @BatchId
				AND p.[Enabled] = 1
				AND s.[Enabled] = 1
				AND params.[ExcludeInGeneral] = 0;
				
			SELECT
				@LocalExecutionId AS ExecutionId;
		END;

	ALTER INDEX [IDX_GetPipelinesInStage] ON [ControlFramework].[CurrentExecution]
	REBUILD;
END;


/****** Object:  StoredProcedure [ControlFramework].[ResetExecution]    Script Date: 2022/04/29 4:18:03 PM ******/
SET ANSI_NULLS ON

GO

