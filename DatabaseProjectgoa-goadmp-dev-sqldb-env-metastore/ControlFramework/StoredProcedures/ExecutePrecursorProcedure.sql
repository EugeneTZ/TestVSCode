CREATE PROCEDURE [ControlFramework].[ExecutePrecursorProcedure]
	(
		@Batch VARCHAR(255) = NULL
	)
AS
BEGIN
	DECLARE @SQL VARCHAR(MAX) 
	DECLARE @ErrorDetail NVARCHAR(MAX)

	IF OBJECT_ID([ControlFramework].[GetPropertyValueInternal]('ExecutionPrecursorProc')) IS NOT NULL
		BEGIN
			BEGIN TRY
				SET @SQL = [ControlFramework].[GetPropertyValueInternal]('ExecutionPrecursorProc');
				EXEC @SQL @BatchName = @Batch ;
			END TRY
			BEGIN CATCH
				SELECT
					@ErrorDetail = 'Precursor procedure failed with error: ' + ERROR_MESSAGE();

				RAISERROR(@ErrorDetail,16,1);
			END CATCH
		END;
	ELSE
		BEGIN
			PRINT 'Precursor object not found in database.';
		END;
END;

GO

