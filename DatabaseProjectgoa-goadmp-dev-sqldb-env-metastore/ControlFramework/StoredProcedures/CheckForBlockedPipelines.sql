CREATE PROCEDURE [ControlFramework].[CheckForBlockedPipelines]
	(
	@ExecutionId UNIQUEIDENTIFIER,
	@StageId INT
	)
AS
BEGIN
	SET NOCOUNT ON;

	IF ([ControlFramework].[GetPropertyValueInternal]('FailureHandling')) = 'None'
		BEGIN
			--do nothing allow processing to carry on regardless
			RETURN 0;
		END;
		
	ELSE IF ([ControlFramework].[GetPropertyValueInternal]('FailureHandling')) = 'Simple'
		BEGIN
			IF EXISTS
				(
				SELECT 
					*
				FROM 
					[ControlFramework].[CurrentExecution]
				WHERE 
					[LocalExecutionId] = @ExecutionId
					AND [StageId] = @StageId
					AND [IsBlocked] = 1
				)
				BEGIN		
					UPDATE
						[ControlFramework].[BatchExecution]
					SET
						[EndDateTime] = GETUTCDATE(),
						[BatchStatus] = 'Stopped'
					WHERE
						[ExecutionId] = @ExecutionId;
					
					--Saves the infant pipeline and activities being called throwing the exception at this level.
					RAISERROR('All pipelines are blocked. Stopping processing.',16,1); 
					--If not thrown here, the proc [ControlFramework].[UpdateExecutionLog] would eventually throw an exception.
					RETURN 0;
				END			
		END;
	ELSE
		BEGIN
			RAISERROR('Unknown failure handling state.',16,1);
			RETURN 0;
		END;
END;

GO

