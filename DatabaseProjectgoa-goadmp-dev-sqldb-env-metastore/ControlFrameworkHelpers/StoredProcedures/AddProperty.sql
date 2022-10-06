CREATE PROCEDURE [ControlFrameworkHelpers].[AddProperty]
	(
	@PropertyName VARCHAR(128),
	@PropertyValue NVARCHAR(MAX),
	@Description NVARCHAR(MAX) = NULL
	)
AS
BEGIN
	
	SET NOCOUNT ON;

	--defensive check (If property has been been previously terminated, then make it active)

	IF EXISTS
		(
		SELECT * FROM [ControlFramework].[Properties] WHERE [PropertyName] = @PropertyName AND [ValidTo] IS NOT NULL
		)
		AND NOT EXISTS
		(
		SELECT * FROM [ControlFramework].[Properties] WHERE [PropertyName] = @PropertyName AND [ValidTo] IS NULL
		)
		BEGIN
			WITH lastValue AS
				(
				SELECT
					[PropertyId],
					ROW_NUMBER() OVER (PARTITION BY [PropertyName] ORDER BY [ValidTo] ASC) AS Rn
				FROM
					[ControlFramework].[Properties]
				WHERE
					[PropertyName] = @PropertyName
				)
			--reset property if valid to date has been incorrectly set
			UPDATE
				prop
			SET
				[ValidTo] = NULL
			FROM
				[ControlFramework].[Properties] prop
				INNER JOIN lastValue
					ON prop.[PropertyId] = lastValue.[PropertyId]
			WHERE
				lastValue.[Rn] = 1
		END
	

	--upsert property 

	/* 2022/07/21 - This code was failing with the addition of triggers
	;WITH sourceTable AS
		(
		SELECT
			@PropertyName AS PropertyName,
			@PropertyValue AS PropertyValue,
			@Description AS [Description],
			GETUTCDATE() AS StartEndDate
		)

	--insert new version of existing property from MERGE OUTPUT


	INSERT INTO [ControlFramework].[Properties]
		(
		[PropertyName],
		[PropertyValue],
		[Description],
		[ValidFrom]
		)

	SELECT
		[PropertyName],
		[PropertyValue],
		[Description],
		GETUTCDATE()
	FROM
		(
		MERGE INTO
			[ControlFramework].[Properties] targetTable
		USING
			sourceTable
				ON sourceTable.[PropertyName] = targetTable.[PropertyName]	
		--set valid to date on existing property
		WHEN MATCHED AND [ValidTo] IS NULL THEN 
			UPDATE
			SET
				targetTable.[ValidTo] = sourceTable.[StartEndDate]
		--add new property
		WHEN NOT MATCHED BY TARGET THEN
			INSERT
				(
				[PropertyName],
				[PropertyValue],
				[Description],
				[ValidFrom]
				)
			VALUES
				(
				sourceTable.[PropertyName],
				sourceTable.[PropertyValue],
				sourceTable.[Description],
				sourceTable.[StartEndDate]
				)
			--for new entry of existing record
			OUTPUT
				$action AS [Action],
				sourceTable.*
			) AS MergeOutput
		WHERE
			MergeOutput.[Action] = 'UPDATE';
	*/

	-- 2022/07/21 this code replaces above upsert

	IF NOT EXISTS (SELECT * FROM [ControlFramework].Properties WHERE PropertyName = @PropertyName)
		INSERT [ControlFramework].[Properties]
			(PropertyName
			,PropertyValue
			,Description
			,ValidFrom)
		VALUES
			(@PropertyName
			,@PropertyValue
			,@Description
			,GETUTCDATE())
	ELSE 
		UPDATE [ControlFramework].[Properties]
		   SET PropertyValue = @PropertyValue,
		       Description = @Description
		 WHERE PropertyName = @PropertyName
		   AND ValidTo IS NULL;
END;

GO

