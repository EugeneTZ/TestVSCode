CREATE PROCEDURE [ControlFramework].[SetLogPipelineRunning]
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
		[StartDateTime] = CASE WHEN [StartDateTime] IS NULL THEN GETUTCDATE() ELSE [StartDateTime] END,
		[PipelineStatus] = 'Running'
	WHERE
		[LocalExecutionId] = @ExecutionId
		AND [StageId] = @StageId
		AND [PipelineId] = @PipelineId
		AND [ConfigId] = @ConfigId
END;

GO

