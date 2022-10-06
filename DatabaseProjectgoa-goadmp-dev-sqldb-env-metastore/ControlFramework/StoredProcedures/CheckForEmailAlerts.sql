CREATE PROCEDURE [ControlFramework].[CheckForEmailAlerts]
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @SendAlerts BIT
	DECLARE @AlertingEnabled BIT

	--get property
	SELECT
		@AlertingEnabled = [ControlFramework].[GetPropertyValueInternal]('UseEmailAlerting');

	--based on global property
	IF (@AlertingEnabled = 1)
		BEGIN
			SET @SendAlerts = 1;
		END;
	ELSE
		BEGIN
			SET @SendAlerts = 0;
		END;
	
	SELECT @SendAlerts AS SendAlerts
END;

GO

