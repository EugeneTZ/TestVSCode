CREATE PROCEDURE [ControlFramework].[SetLogPipelineLastStatusCheck]
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
		[LastStatusCheckDateTime] = GETUTCDATE()
	WHERE
		[LocalExecutionId] = @ExecutionId
		AND [StageId] = @StageId
		AND [PipelineId] = @PipelineId
		AND [ConfigId] = @ConfigId
END;

GO

