CREATE PROCEDURE [ControlFramework].[SetLogPipelineFailed]
	(
	@ExecutionId UNIQUEIDENTIFIER,
	@StageId INT,
	@PipelineId INT,
	@ConfigId INT,
	@RunId UNIQUEIDENTIFIER = NULL
	)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @ErrorDetail VARCHAR(500)

	--mark specific failure pipeline
	UPDATE
		[ControlFramework].[CurrentExecution]
	SET
		[PipelineStatus] = 'Failed'
	WHERE
		[LocalExecutionId] = @ExecutionId
		AND [StageId] = @StageId
		AND [PipelineId] = @PipelineId
		AND [ConfigId] = @ConfigId

	--persist failed pipeline records to long term log
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
		[PipelineRunId],
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
		[PipelineStatus],
		[EndDateTime],
		[PipelineRunId],
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
		SYSTEM_USER,
		'The pipeline run failed. Please see [ControlFramework].[ErrorLog] for details.',
		1
	FROM
		[ControlFramework].[CurrentExecution]
	WHERE
		[LocalExecutionId] = @ExecutionId
		AND [PipelineStatus] = 'Failed'
		AND [StageId] = @StageId
		AND [PipelineId] = @PipelineId
		AND [ConfigId] = @ConfigId;
	
	--3/7/22: persist failed pipeline records to job level metadata
/*
--2022/04/29: job level metadata now stored exclusively in CurrentExecution (DMP task 1081)
	INSERT INTO [dbo].[ADFJobProcessor]
		(
		 [JobName],
		 [DataFactoryName],
		 [PipelineRunID],
	     [JobDescription],
         [ProjectName],
         [JobVersion],
         [ExecutionMachine],
         [ExecutionUserId],
         [LoadType],
         [Status],
         [ExecutionStartTime],
         [ExecutionEndTime],
         [DataOwnerId],
         [SourceSystem],
         [SourceAssetName],
         [SourceDataZone],
         [TargetSystem],
         [TargetAssetID],
         [TargetAssetName],
         [TargetDataZone],
         [Frequency],
         [SecurityClassification],
         [RecordCount],
         [ProcessorMessage],
         [AuditCreated],
         [AuditUpdated],
         [AuditCreatedBy]
		)
	SELECT
		[PipelineName],
		[DataFactoryName],
		[PipelineRunId],
		[JobDescription],
		[ProjectName],
		[JobVersion],
		[ExecutionMachine],
		SYSTEM_USER,
		[LoadType],
		[PipelineStatus],
		[StartDateTime],
		[EndDateTime],
		[DataOwnerId],
		[SourceSystem],
		[SourceAssetName],
		[SourceDataZone],
		[TargetSystem],
		[TargetAssetID],
		[TargetAssetName],
		[TargetDataZone],
		[Frequency],
		[SecurityClassification],
		1,
		'The pipeline run failed. Please see [ControlFramework].[ErrorLog] for details.',
		GETDATE(),
		GETDATE(),
		SYSTEM_USER
	FROM
		[ControlFramework].[CurrentExecution]
	WHERE
		[LocalExecutionId] = @ExecutionId
		AND [PipelineStatus] = 'Failed'
		AND [StageId] = @StageId
		AND [PipelineId] = @PipelineId
		AND [ConfigId] = @ConfigId;
*/
	IF ([ControlFramework].[GetPropertyValueInternal]('FailureHandling')) = 'None'
		BEGIN
			--do nothing allow processing to carry on regardless
			RETURN 0;
		END;
		
	ELSE IF ([ControlFramework].[GetPropertyValueInternal]('FailureHandling')) = 'Simple'
		BEGIN
			--flag all downstream stages as blocked
			UPDATE
				[ControlFramework].[CurrentExecution]
			SET
				[PipelineStatus] = 'Blocked',
				[IsBlocked] = 1
			WHERE
				[LocalExecutionId] = @ExecutionId
				AND [StageId] > @StageId
			
			--raise error to stop processing
			IF @RunId IS NOT NULL
				BEGIN
					SET @ErrorDetail = 'Pipeline execution failed. Check Run ID: ' + CAST(@RunId AS CHAR(36)) + ' in ADF monitoring for details.'
				END;
			ELSE
				BEGIN
					SET @ErrorDetail = 'Pipeline execution failed. See ADF monitoring for details.'
				END;

			--update batch if applicable
			IF ([ControlFramework].[GetPropertyValueInternal]('UseExecutionBatches')) = '1'
				BEGIN
					UPDATE
						[ControlFramework].[BatchExecution]
					SET
						[BatchStatus] = 'Stopping'
					WHERE
						[ExecutionId] = @ExecutionId
						AND [BatchStatus] = 'Running';
				END;

			RAISERROR(@ErrorDetail,16,1);
			RETURN 0;
		END;
	ELSE
		BEGIN
			RAISERROR('Unknown failure handling state.',16,1);
			RETURN 0;
		END;
END;

/****** Object:  StoredProcedure [ControlFramework].[SetLogPipelineSuccess]    Script Date: 2022/04/29 12:21:45 PM ******/
SET ANSI_NULLS ON

GO

