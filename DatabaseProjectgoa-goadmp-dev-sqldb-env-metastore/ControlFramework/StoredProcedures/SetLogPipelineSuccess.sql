CREATE PROCEDURE [ControlFramework].[SetLogPipelineSuccess]
	(
	@ExecutionId UNIQUEIDENTIFIER,
	@StageId INT,
	@PipelineId INT,
	@ConfigId INT
	)
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE
		[ControlFramework].[CurrentExecution]
	SET
		--case for clean up runs
		[EndDateTime] = CASE WHEN [EndDateTime] IS NULL THEN GETUTCDATE() ELSE [EndDateTime] END,
		[PipelineStatus] = 'Success'
	WHERE
		[LocalExecutionId] = @ExecutionId
		AND [StageId] = @StageId
		AND [PipelineId] = @PipelineId
		AND [ConfigId] = @ConfigId

	--persist unknown pipeline records to long term log
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
		'The pipeline run succeeded.',
		1
	FROM
		[ControlFramework].[CurrentExecution]
	WHERE
		[PipelineStatus] = 'Success'
		AND [StageId] = @StageId
		AND [PipelineId] = @PipelineId
		AND [ConfigId] = @ConfigId;

--3/7/22: persist successful pipeline runs to job level metadata
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
		'The pipeline run succeeded.',
		GETDATE(),
		GETDATE(),
		SYSTEM_USER
	FROM
		[ControlFramework].[CurrentExecution]
	WHERE
		[PipelineStatus] = 'Success'
		AND [StageId] = @StageId
		AND [PipelineId] = @PipelineId
		AND [ConfigId] = @ConfigId;
*/
END;

/****** Object:  StoredProcedure [ControlFramework].[SetLogPipelineUnknown]    Script Date: 2022/04/29 12:22:20 PM ******/
SET ANSI_NULLS ON

GO

