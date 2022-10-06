CREATE PROCEDURE [ControlFramework].[SetLogPipelineRunId]
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

	UPDATE
		[ControlFramework].[CurrentExecution]
	SET
		[PipelineRunId] = LOWER(@RunId)
	WHERE
		[LocalExecutionId] = @ExecutionId
		AND [StageId] = @StageId
		AND [PipelineId] = @PipelineId
		AND [ConfigId] = @ConfigId
END;

GO

