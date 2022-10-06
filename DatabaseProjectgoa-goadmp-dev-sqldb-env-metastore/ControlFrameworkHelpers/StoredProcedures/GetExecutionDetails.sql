CREATE PROCEDURE [ControlFrameworkHelpers].[GetExecutionDetails]
	(
	@LocalExecutionId UNIQUEIDENTIFIER = NULL
	)
AS
BEGIN

	--Get last execution ID
	IF @LocalExecutionId IS NULL
	BEGIN
		WITH maxLog AS
			(
			SELECT
				MAX([LogId]) AS MaxLogId
			FROM
				[ControlFramework].[ExecutionLog]
			)
		SELECT
			@LocalExecutionId = el1.[LocalExecutionId]
		FROM
			[ControlFramework].[ExecutionLog] el1
			INNER JOIN maxLog
				ON maxLog.[MaxLogId] = el1.[LogId];
	END;

	--Execution Summary
	SELECT
		CAST(el2.[StageId] AS VARCHAR(5)) + ' - ' + stgs.[StageName] AS Stage,
		COUNT(0) AS RecordCount,
		DATEDIFF(MINUTE, MIN(el2.[StartDateTime]), MAX(el2.[EndDateTime])) DurationMinutes
	FROM
		[ControlFramework].[ExecutionLog] el2
		INNER JOIN [ControlFramework].[Stages] stgs
			ON el2.[StageId] = stgs.[StageId]
	WHERE
		el2.[LocalExecutionId] = @LocalExecutionId
	GROUP BY
		CAST(el2.[StageId] AS VARCHAR(5)) + ' - ' + stgs.[StageName]
	ORDER BY
		CAST(el2.[StageId] AS VARCHAR(5)) + ' - ' + stgs.[StageName];

	--Full execution details
	SELECT
		el3.[LogId],
		el3.[LocalExecutionId],
		el3.[OrchestratorType],
		el3.[OrchestratorName],
		el3.[StageId],
		stgs.[StageName],
		el3.[PipelineId],
		el3.[PipelineName],
		el3.[StartDateTime],
		el3.[EndDateTime],
		ISNULL(DATEDIFF(MINUTE, el3.[StartDateTime], el3.[EndDateTime]),0) AS DurationMinutes,
		el3.[PipelineStatus],
		el3.[PipelineRunId],
		errLog.[ActivityRunId],
		errLog.[ActivityName],
		errLog.[ActivityType],
		errLog.[ErrorCode],
		errLog.[ErrorType],
		errLog.[ErrorMessage],
		el3.[SourceSchema],
		el3.[SourceTable],
		el3.[SourceSQL],
		el3.[SourceContainer],
		el3.[SourceFolder],
		el3.[SourceFileName],
		el3.[SourceURL],
		el3.[SourceConnectionURL],
		el3.[SourceConnectionSecret],
		el3.[DestinationSchema],
		el3.[DestinationTable],
		el3.[DestinationContainer],
		el3.[DestinationFolder],
		el3.[DestinationFileName],
		el3.[DestinationURL],
		el3.[DestinationConnectionURL],
		el3.[DestinationConnectionSecret],
		el3.[DestinationExternalDataSource],
		el3.[DestinationExternalLocation],
		el3.[SynapseSchema],
		el3.[SynapseTable],
		el3.[SynapseScript],
		el3.[SynapseConnectionURL],
		el3.[SynapseConnectionSecret],
		el3.[Script],		
		el3.[JsonRoot],
		el3.[rdps],
		el3.[run],
		el3.[hour],
		el3.[dim_reference_time],
		el3.[time],
		el3.[subsetx],
		el3.[subsety],
		el3.[format],
		el3.[APIURL],
		el3.[APILoginURL],
		el3.[DataBricksURL],
		el3.[DataBricksResourceID],
		el3.[SparkClusterVersion],
		el3.[SparkClusterNodeType],
		el3.[SparkPythonVersion],
		el3.[NoteBookPath],
		el3.[ConcurrentNotebooks],
		el3.[RunDate],
		el3.[ExcludeInGeneral],
		el3.[JobDescription],
		el3.[ProjectName],
		el3.[JobVersion],
		el3.[LoadType],
		el3.[WatermarkColumn],
		el3.[WatermarkValue],
		el3.[Frequency],
		el3.[SecurityClassification],
		el3.[ExecutionMachine],
		el3.[DataOwnerId],
		el3.[SourceSystem],
		el3.[SourceAssetName],
		el3.[SourceDataZone],
		el3.[TargetSystem],
		el3.[TargetAssetName],
		el3.[TargetDataZone]
	FROM 
		[ControlFramework].[ExecutionLog] el3
		LEFT OUTER JOIN [ControlFramework].[ErrorLog] errLog
			ON el3.[LocalExecutionId] = errLog.[LocalExecutionId]
				AND el3.[PipelineRunId] = errLog.[PipelineRunId]
		INNER JOIN [ControlFramework].[Stages] stgs
			ON el3.[StageId] = stgs.[StageId]
	WHERE
		el3.[LocalExecutionId] = @LocalExecutionId
	ORDER BY
		el3.[PipelineId],
		el3.[StartDateTime];
END;

GO

