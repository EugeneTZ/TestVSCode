CREATE PROCEDURE [ControlFramework].[CheckMetadataIntegrity]
	(
	@DebugMode BIT = 0,
	@BatchName VARCHAR(255) = NULL
	)
AS
BEGIN
	SET NOCOUNT ON;
	
	/*
	Check 1 - Are there execution stages enabled in the metadata?
	Check 2 - Are there pipelines enabled in the metadata?
	Check 3 - Is there a current OverideRestart property available?
	Check 4 - Is there a current PipelineStatusCheckDuration property available?
	Check 5 - Is there a current UseEmailAlerting property available?
	Check 6 - Is there a current EmailAlertLogicAppHttpTrigger property available?
	Check 7 - Is there a current EmailAlertBodyTemplate property available?
	Check 8 - Is there a current FailureHandling property available?
	Check 9 - Does the FailureHandling property have a valid value?
	Check 10 - Is there a current UseExecutionBatches property available?
	Check 11 - Is there a current PreviousPipelineRunsQueryRange property available?

	--Batch execution checks:
	Check 12 - If using batch executions, is the requested batch name enabled?
	Check 13 - Have batch executions been enabled after a none batch execution run?

	Check 14 - Has the execution failed due to an invalid pipeline name? If so, attend to update this before the next run.
	Check 15 - Is there more than one framework orchestrator set?
	Check 16 - Has a framework orchestrator been set for any orchestrators?
	*/

	DECLARE @BatchId UNIQUEIDENTIFIER
	DECLARE @ErrorDetails VARCHAR(500)
	DECLARE @MetadataIntegrityIssues TABLE
		(
		[CheckNumber] INT NOT NULL,
		[IssuesFound] VARCHAR(MAX) NOT NULL
		)

	/*
	Checks:
	*/

	--Check 1:
	IF NOT EXISTS
		(
		SELECT 1 FROM [ControlFramework].[Stages] WHERE [Enabled] = 1
		)
		BEGIN
			INSERT INTO @MetadataIntegrityIssues
			VALUES
				( 
				1,
				'No execution stages are enabled within the metadatabase. Orchestrator has nothing to run.'
				)
		END;

	--Check 2:
	IF NOT EXISTS
		(
		SELECT 1 FROM [ControlFramework].[Pipelines] WHERE [Enabled] = 1
		)
		BEGIN
			INSERT INTO @MetadataIntegrityIssues
			VALUES
				( 
				2,
				'No execution pipelines are enabled within the metadatabase. Orchestrator has nothing to run.'
				)
		END;

	--Check 3:
		IF NOT EXISTS
		(
		SELECT * FROM [ControlFramework].[CurrentProperties] WHERE [PropertyName] = 'OverideRestart'
		)
		BEGIN
			INSERT INTO @MetadataIntegrityIssues
			VALUES
				( 
				5,
				'A current OverideRestart value is missing from the properties table.'
				)		
		END;

	--Check 4:
	IF NOT EXISTS
		(
		SELECT * FROM [ControlFramework].[CurrentProperties] WHERE [PropertyName] = 'PipelineStatusCheckDuration'
		)
		BEGIN
			INSERT INTO @MetadataIntegrityIssues
			VALUES
				( 
				6,
				'A current PipelineStatusCheckDuration value is missing from the properties table.'
				)		
		END;

	--Check 5:
	IF NOT EXISTS
		(
		SELECT * FROM [ControlFramework].[CurrentProperties] WHERE [PropertyName] = 'UseEmailAlerting'
		)
		BEGIN
			INSERT INTO @MetadataIntegrityIssues
			VALUES
				( 
				7,
				'A current UseEmailAlerting value is missing from the properties table.'
				)		
		END;

	--Check 6:
	IF NOT EXISTS
		(
		SELECT * FROM [ControlFramework].[CurrentProperties] WHERE [PropertyName] = 'EmailAlertLogicAppHttpTrigger'
		)
		BEGIN
			INSERT INTO @MetadataIntegrityIssues
			VALUES
				( 
				8,
				'A current EmailAlertLogicAppHttpTrigger value is missing from the properties table.'
				)		
		END;

	--Check 7:
	IF (
		SELECT
			[PropertyValue]
		FROM
			[ControlFramework].[CurrentProperties]
		WHERE
			[PropertyName] = 'UseEmailAlerting'
		) = 1
		BEGIN
			IF NOT EXISTS
				(
				SELECT * FROM [ControlFramework].[CurrentProperties] WHERE [PropertyName] = 'EmailAlertBodyTemplate'
				)
				BEGIN
					INSERT INTO @MetadataIntegrityIssues
					VALUES
						( 
						9,
						'A current EmailAlertBodyTemplate value is missing from the properties table.'
						)		
				END;
		END;

	--Check 8:
	IF NOT EXISTS
		(
		SELECT * FROM [ControlFramework].[CurrentProperties] WHERE [PropertyName] = 'FailureHandling'
		)
		BEGIN
			INSERT INTO @MetadataIntegrityIssues
			VALUES
				( 
				11,
				'A current FailureHandling value is missing from the properties table.'
				)		
		END;

	--Check 9:
	IF NOT EXISTS
		(
		SELECT 
			*
		FROM
			[ControlFramework].[CurrentProperties] 
		WHERE 
			[PropertyName] = 'FailureHandling' 
			AND [PropertyValue] IN ('None','Simple')
		)
		BEGIN
			INSERT INTO @MetadataIntegrityIssues
			VALUES
				( 
				12,
				'The property FailureHandling does not have a supported value.'
				)	
		END;
	
	--Check 10:
	IF NOT EXISTS
		(
		SELECT * FROM [ControlFramework].[CurrentProperties] WHERE [PropertyName] = 'UseExecutionBatches'
		)
		BEGIN
			INSERT INTO @MetadataIntegrityIssues
			VALUES
				( 
				14,
				'A current UseExecutionBatches value is missing from the properties table.'
				)		
		END;
		
	--Check 11:
	IF NOT EXISTS
		(
		SELECT * FROM [ControlFramework].[CurrentProperties] WHERE [PropertyName] = 'PreviousPipelineRunsQueryRange'
		)
		BEGIN
			INSERT INTO @MetadataIntegrityIssues
			VALUES
				( 
				15,
				'A current PreviousPipelineRunsQueryRange value is missing from the properties table.'
				)		
		END;

	--batch execution checks
	IF ([ControlFramework].[GetPropertyValueInternal]('UseExecutionBatches')) = '1'
		BEGIN			
			IF @BatchName IS NULL
				BEGIN
					RAISERROR('A NULL batch name cannot be passed when the UseExecutionBatches property is set to 1 (true).',16,1);
					RETURN 0;
				END

			SELECT 
				@BatchId = [BatchId]
			FROM
				[ControlFramework].[Batches]
			WHERE
				[BatchName] = @BatchName;

			--Check 12:
			IF EXISTS
				(
				SELECT 1 FROM [ControlFramework].[Batches] WHERE [BatchId] = @BatchId AND [Enabled] = 0
				)
				BEGIN
					INSERT INTO @MetadataIntegrityIssues
					VALUES
						( 
						16,
						'The requested execution batch is currently disabled. Enable the batch before proceeding.'
						)
				END;

			--Check 13:
			IF EXISTS
				(
				SELECT
					*
				FROM
					[ControlFramework].[CurrentExecution] c
					LEFT OUTER JOIN [ControlFramework].[BatchExecution] b
						ON c.[LocalExecutionId] = b.[ExecutionId]
				WHERE
					b.[ExecutionId] IS NULL
				)
				BEGIN
					INSERT INTO @MetadataIntegrityIssues
					VALUES
						( 
						18,
						'Execution records exist in the [ControlFramework].[CurrentExecution] table that do not have a record in [ControlFramework].[BatchExecution] table. Has batch excutions been enabed after an incomplete none batch run?'
						)
				END;			
		END; --end batch checks
	
	--Check 14: 
	IF EXISTS
		(
		SELECT 1 FROM [ControlFramework].[CurrentExecution] WHERE [PipelineStatus] = 'InvalidPipelineNameError'
		)
		BEGIN
			UPDATE
				ce
			SET
				ce.[PipelineName] = p.[PipelineName]
			FROM
				[ControlFramework].[CurrentExecution] ce
				INNER JOIN [ControlFramework].[Pipelines] p
					ON ce.[PipelineId] = p.[PipelineId]
						AND ce.[StageId] = p.[StageId]
			WHERE
				ce.[PipelineStatus] = 'InvalidPipelineNameError'
		END;
	
	--Check 15:
	IF (SELECT COUNT(0) FROM [ControlFramework].[Orchestrators] WHERE [IsFrameworkOrchestrator] = 1) > 1
	BEGIN
		INSERT INTO @MetadataIntegrityIssues
		VALUES
			( 
			20,
			'There is more than one FrameworkOrchestrator set in the table [ControlFramework].[Orchestrators]. Only one is supported.'
			)		
	END

	--Check 16:
	IF NOT EXISTS
		(
		SELECT 1 FROM [ControlFramework].[Orchestrators] WHERE [IsFrameworkOrchestrator] = 1
		)
		BEGIN
			INSERT INTO @MetadataIntegrityIssues
			VALUES
				( 
				21,
				'A FrameworkOrchestrator has not been set in the table [ControlFramework].[Orchestrators]. Only one is supported.'
				)		
		END

	/*
	Integrity Checks Outcome:
	*/
	
	--throw runtime error if checks fail
	IF EXISTS
		(
		SELECT * FROM @MetadataIntegrityIssues
		)
		AND @DebugMode = 0
		BEGIN
			SET @ErrorDetails = 'Metadata integrity checks failed. Run EXEC [ControlFramework].[CheckMetadataIntegrity] @DebugMode = 1; for details.'

			RAISERROR(@ErrorDetails, 16, 1);
			RETURN 0;
		END;

	--report issues when in debug mode
	IF @DebugMode = 1
	BEGIN
		IF NOT EXISTS
			(
			SELECT * FROM @MetadataIntegrityIssues
			)
			BEGIN
				PRINT 'No data integrity issues found in metadata.'
				RETURN 0;
			END
		ELSE		
			BEGIN
				SELECT * FROM @MetadataIntegrityIssues;
			END;
	END;
END;

GO

