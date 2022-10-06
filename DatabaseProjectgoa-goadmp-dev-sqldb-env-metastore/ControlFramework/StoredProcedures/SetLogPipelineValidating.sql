CREATE PROCEDURE [ControlFramework].[SetLogPipelineValidating]
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
		[PipelineStatus] = 'Validating'
	WHERE
		[LocalExecutionId] = @ExecutionId
		AND [StageId] = @StageId
		AND [PipelineId] = @PipelineId
		AND [ConfigId] = @ConfigId
END;

GO

