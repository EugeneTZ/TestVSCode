CREATE PROCEDURE [ControlFramework].[UpdateExecutionLog]
	(
	@PerformErrorCheck BIT = 1,
	@ExecutionId UNIQUEIDENTIFIER = NULL
	)
AS
BEGIN
	
	--EXEC [ControlFramework].[UpdateErrorLog]

	SET NOCOUNT ON;
		
	DECLARE @AllCount INT
	DECLARE @SuccessCount INT

	IF([ControlFramework].[GetPropertyValueInternal]('UseExecutionBatches')) = '0'
	BEGIN
		IF @PerformErrorCheck = 1
		BEGIN
			--Check current execution
			SELECT @AllCount = COUNT(0) FROM [ControlFramework].[CurrentExecution]
			SELECT @SuccessCount = COUNT(0) FROM [ControlFramework].[CurrentExecution] WHERE [PipelineStatus] = 'Success'

			IF @AllCount <> @SuccessCount
			BEGIN
				RAISERROR('Framework execution complete but not all Worker pipelines succeeded. See the [ControlFramework].[CurrentExecution] table for details',16,1);
				RETURN 0;
			END;

		END;

		DELETE FROM [ControlFramework].[CurrentExecution];
	END
	ELSE IF ([ControlFramework].[GetPropertyValueInternal]('UseExecutionBatches')) = '1'
		BEGIN
			IF @PerformErrorCheck = 1
			BEGIN
				--Check current execution
				SELECT 
					@AllCount = COUNT(0) 
				FROM 
					[ControlFramework].[CurrentExecution] 
				WHERE 
					[LocalExecutionId] = @ExecutionId;
				
				SELECT 
					@SuccessCount = COUNT(0) 
				FROM 
					[ControlFramework].[CurrentExecution] 
				WHERE 
					[LocalExecutionId] = @ExecutionId 
					AND [PipelineStatus] = 'Success';

				IF @AllCount <> @SuccessCount
				BEGIN
					UPDATE
						[ControlFramework].[BatchExecution]
					SET
						[BatchStatus] = 'Stopped',
						[EndDateTime] = GETUTCDATE()
					WHERE
						[ExecutionId] = @ExecutionId;

					RAISERROR('Framework execution complete for batch but not all Worker pipelines succeeded. See the [ControlFramework].[CurrentExecution] table for details',16,1);
					RETURN 0;
				END;
				ELSE
				BEGIN
					UPDATE
						[ControlFramework].[BatchExecution]
					SET
						[BatchStatus] = 'Success',
						[EndDateTime] = GETUTCDATE()
					WHERE
						[ExecutionId] = @ExecutionId;
				END;
			END; --end check

			--Do this if no error raised and when called by the execution wrapper (OverideRestart = 1).

			DELETE FROM
				[ControlFramework].[CurrentExecution]
			WHERE
				[LocalExecutionId] = @ExecutionId;
		END;
END;

GO

