CREATE PROCEDURE [ControlFrameworkTesting].[CleanUpMetadata]
AS
BEGIN
	EXEC [ControlFrameworkHelpers].[DeleteMetadataWithIntegrity];
	EXEC [ControlFrameworkHelpers].[DeleteMetadataWithoutIntegrity];
END;

GO

