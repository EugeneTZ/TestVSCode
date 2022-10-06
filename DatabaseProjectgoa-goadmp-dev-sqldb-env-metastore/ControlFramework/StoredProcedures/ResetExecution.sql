CREATE PROCEDURE [ControlFramework].[ResetExecution]
	(
	@LocalExecutionId UNIQUEIDENTIFIER = NULL
	)
AS
BEGIN 
	SET NOCOUNT	ON;

	IF([ControlFramework].[GetPropertyValueInternal]('UseExecutionBatches')) = '0'
		BEGIN
			--capture any pipelines that might be in an unexpected state
			INSERT INTO [ControlFramework].[ExecutionLog]
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
				[StartDateTime],
				[PipelineStatus],
				[EndDateTime],
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
				[StartDateTime],
				'Unknown',
				[EndDateTime],
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
			FROM
				[ControlFramework].[CurrentExecution]
			WHERE
				--these are predicted states
				[PipelineStatus] NOT IN
					(
					'Success',
					'Failed',
					'Blocked',
					'Cancelled'
					);
		
			--reset status ready for next attempt
			UPDATE
				[ControlFramework].[CurrentExecution]
			SET
				[StartDateTime] = NULL,
				[EndDateTime] = NULL,
				[PipelineStatus] = NULL,
				[LastStatusCheckDateTime] = NULL,
				[PipelineRunId] = NULL,
				[IsBlocked] = 0
			WHERE
				ISNULL([PipelineStatus],'') <> 'Success'
				OR [IsBlocked] = 1;
	
			--return current execution id
			SELECT DISTINCT
				[LocalExecutionId] AS ExecutionId
			FROM
				[ControlFramework].[CurrentExecution];
		END
	ELSE IF ([ControlFramework].[GetPropertyValueInternal]('UseExecutionBatches')) = '1'
		BEGIN
			--capture any pipelines that might be in an unexpected state
			INSERT INTO [ControlFramework].[ExecutionLog]
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
				[StartDateTime],
				[PipelineStatus],
				[EndDateTime],
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
				[StartDateTime],
				'Unknown',
				[EndDateTime],
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
			FROM
				[ControlFramework].[CurrentExecution]
			WHERE
				[LocalExecutionId] = @LocalExecutionId
				--these are predicted states
				AND [PipelineStatus] NOT IN
					(
					'Success',
					'Failed',
					'Blocked',
					'Cancelled'
					);
		
			--reset status ready for next attempt
			UPDATE
				[ControlFramework].[CurrentExecution]
			SET
				[StartDateTime] = NULL,
				[EndDateTime] = NULL,
				[PipelineStatus] = NULL,
				[LastStatusCheckDateTime] = NULL,
				[PipelineRunId] = NULL,
				[IsBlocked] = 0
			WHERE
				[LocalExecutionId] = @LocalExecutionId
				AND ISNULL([PipelineStatus],'') <> 'Success'
				OR [IsBlocked] = 1;
				
			UPDATE
				[ControlFramework].[BatchExecution]
			SET
				[EndDateTime] = NULL,
				[BatchStatus] = 'Running'
			WHERE
				[ExecutionId] = @LocalExecutionId;

			SELECT 
				@LocalExecutionId AS ExecutionId
		END;
END;

/****** Object:  StoredProcedure [ControlFramework].[SetErrorLogDetails]    Script Date: 2022/04/29 4:20:51 PM ******/
SET ANSI_NULLS ON

GO

