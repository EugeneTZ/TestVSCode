CREATE PROCEDURE [ControlFramework].[SetLogStagePreparing]
	(
	@ExecutionId UNIQUEIDENTIFIER,
	@StageId INT
	)
AS
BEGIN
	SET NOCOUNT ON;
	
	UPDATE
		[ControlFramework].[CurrentExecution]
	SET
		[PipelineStatus] = 'Preparing'
	WHERE
		[LocalExecutionId] = @ExecutionId
		AND [StageId] = @StageId
		AND [StartDateTime] IS NULL
		AND [IsBlocked] <> 1;
END;

GO

