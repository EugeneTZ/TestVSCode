
CREATE PROCEDURE [ControlFramework].[CheckExecutionStatus]
	(
	@LocalExecutionId UNIQUEIDENTIFIER = NULL,
	@StageId INT = NULL
	)
AS
BEGIN
	SET NOCOUNT ON;

	-- Removed this because it was redundant and causing multiple rows to be returned
	/*
	IF EXISTS (
				SELECT 1 
				  FROM [ControlFramework].[CurrentExecution]
				WHERE [PipelineStatus] NOT IN ('Success', 'Failed','Cancelled', 'Blocked')
				  AND [PipelineStatus] NOT LIKE '%Error%' 
				  AND LocalExecutionId = @LocalExecutionId 
				  AND StageId = @StageId)
	BEGIN
		SELECT PropertyValue = 0;
	END
	*/

	IF @StageId IS NOT NULL
	BEGIN -- check if stage has been completed
		 IF EXISTS (
				SELECT 1 
				FROM [ControlFramework].[CurrentExecution]
				WHERE [PipelineStatus] NOT IN ('Success', 'Failed','Cancelled', 'Blocked')
				  AND [PipelineStatus] NOT LIKE '%Error%' 
				  AND LocalExecutionId = @LocalExecutionId 
				  AND StageId = @StageId)
		BEGIN
			SELECT PropertyValue = 0;
		END
		ELSE
		BEGIN
			UPDATE [ControlFramework].[Properties]
			SET PropertyValue = '1'
			WHERE PropertyName = 'CheckExecutionStatusHelper'
			AND PropertyValue <> '1'

			SELECT PropertyValue FROM [ControlFramework].[Properties] WHERE PropertyName = 'CheckExecutionStatusHelper'
		END

	END
	ELSE
	BEGIN -- check if pipelines have been completed (i.e. last stage for final check)
		IF EXISTS (
				SELECT 1 
				FROM [ControlFramework].[CurrentExecution]
				WHERE [PipelineStatus] NOT IN ('Success', 'Failed','Cancelled', 'Blocked')
				  AND [PipelineStatus] NOT LIKE '%Error%' 
				  AND LocalExecutionId = @LocalExecutionId)
		BEGIN
			SELECT PropertyValue = 0;
		END
		ELSE
		BEGIN
			UPDATE [ControlFramework].[Properties]
			SET PropertyValue = '1'
			WHERE PropertyName = 'CheckExecutionStatusHelper'
			AND PropertyValue <> '1'

			SELECT PropertyValue FROM [ControlFramework].[Properties] WHERE PropertyName = 'CheckExecutionStatusHelper'
		END

	END

END;

GO

