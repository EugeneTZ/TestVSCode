CREATE PROCEDURE [ControlFramework].[GetPipelinesInStage]
	(
	@ExecutionId UNIQUEIDENTIFIER,
	@StageId INT
	)
AS
BEGIN
	SET NOCOUNT ON;

	SELECT 
		[PipelineId],
		[ConfigId]
	FROM 
		[ControlFramework].[CurrentExecution]
	WHERE 
		[LocalExecutionId] = @ExecutionId
		AND [StageId] = @StageId
		AND ISNULL([PipelineStatus],'') <> 'Success'
		AND [IsBlocked] <> 1
	ORDER BY
		[PipelineId]  ASC, [ConfigId] ASC;
END;

GO

