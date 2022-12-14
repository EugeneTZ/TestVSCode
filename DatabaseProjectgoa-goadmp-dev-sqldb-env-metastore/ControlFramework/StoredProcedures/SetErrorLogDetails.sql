CREATE PROCEDURE [ControlFramework].[SetErrorLogDetails]
	(
	@LocalExecutionId UNIQUEIDENTIFIER,
	@PipelineId int,
	@ConfigId int,
	@PipelineName [nvarchar](200),
	@JsonErrorDetails VARCHAR(MAX)
	)
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO [ControlFramework].[ErrorLog]
		(
		[LocalExecutionId],
		[PipelineRunId],
		[ActivityRunId],
		[PipelineId],
		[ConfigId],
		[PipelineName],
		[ActivityName],
		[ActivityType],
		[ErrorCode],
		[ErrorType],
		[ErrorMessage],
		[ActivityRunStart],
		[ActivityRunEnd],
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
		Base.[RunId],
		ErrorDetail.[ActivityRunId],
		@PipelineId,
		@ConfigId,
		@PipelineName,
		ErrorDetail.[ActivityName],
		ErrorDetail.[ActivityType],
		ErrorDetail.[ErrorCode],
		ErrorDetail.[ErrorType],
		ErrorDetail.[ErrorMessage],
		CAST(LEFT(ErrorDetail.[ActivityRunStart], LEN(ErrorDetail.[ActivityRunStart])-6) AS DATETIME),
		CAST(LEFT(ErrorDetail.[ActivityRunEnd], LEN(ErrorDetail.[ActivityRunEnd])-6) AS DATETIME),
		ce.[SourceSchema],
		ce.[SourceTable],
		ce.[SourceSQL],
		ce.[SourceContainer],
		ce.[SourceFolder],
		ce.[SourceFileName],
		ce.[SourceURL],
		ce.[SourceConnectionURL],
		ce.[SourceConnectionSecret],
		ce.[DestinationSchema],
		ce.[DestinationTable],
		ce.[DestinationContainer],
		ce.[DestinationFolder],
		ce.[DestinationFileName],
		ce.[DestinationURL],
		ce.[DestinationConnectionURL],
		ce.[DestinationConnectionSecret],
		ce.[DestinationExternalDataSource],
		ce.[DestinationExternalLocation],
		ce.[SynapseSchema],
		ce.[SynapseTable],
		ce.[SynapseScript],
		ce.[SynapseConnectionURL],
		ce.[SynapseConnectionSecret],
		ce.[Script],
		ce.[JsonRoot],
		ce.[rdps],
		ce.[run],
		ce.[hour],
		ce.[dim_reference_time],
		ce.[time],
		ce.[subsetx],
		ce.[subsety],
		ce.[format],
		ce.[APIURL],
		ce.[APILoginURL],
		ce.[DataBricksURL],
		ce.[DataBricksResourceID],
		ce.[SparkClusterVersion],
		ce.[SparkClusterNodeType],
		ce.[SparkPythonVersion],
		ce.[NoteBookPath],
		ce.[ConcurrentNotebooks],
		ce.[RunDate],
		ce.[ExcludeInGeneral],
		ce.[JobDescription],
		ce.[ProjectName],
		ce.[JobVersion],
		ce.[LoadType],
		ce.[WatermarkColumn],
		ce.[WatermarkValue],
		ce.[Frequency],
		ce.[SecurityClassification],
		ce.[ExecutionMachine],
		ce.[DataOwnerId],
		ce.[SourceSystem],
		ce.[SourceAssetName],
		ce.[SourceDataZone],
		ce.[TargetSystem],
		ce.[TargetAssetID],
		ce.[TargetAssetName],
		ce.[TargetDataZone],
		ce.[ExecutionUserId],
		ce.[ProcessorMessage],
		ce.[RecordCount]
	FROM 
		OPENJSON(@JsonErrorDetails) WITH
			( 
			[RunId] UNIQUEIDENTIFIER,
			[Errors] NVARCHAR(MAX) AS JSON
			) AS Base
		CROSS APPLY OPENJSON (Base.[Errors]) WITH
			(
			[ActivityRunId] UNIQUEIDENTIFIER,
			[ActivityName] VARCHAR(100),
			[ActivityType] VARCHAR(100),
			[ErrorCode] VARCHAR(100),
			[ErrorType] VARCHAR(100),
			[ErrorMessage] VARCHAR(MAX),
			[ActivityRunStart] VARCHAR(100),
			[ActivityRunEnd] VARCHAR(100)
			) AS ErrorDetail
		INNER JOIN [ControlFramework].[CurrentExecution] ce
			ON @LocalExecutionId = ce.[LocalExecutionId]
				AND @PipelineId = ce.[PipelineId]
				AND @ConfigId = ce.[ConfigId]
END;

GO

