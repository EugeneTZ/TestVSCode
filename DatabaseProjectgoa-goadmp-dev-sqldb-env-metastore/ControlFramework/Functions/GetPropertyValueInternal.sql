CREATE FUNCTION [ControlFramework].[GetPropertyValueInternal]
	(
	@PropertyName VARCHAR(128)
	)
RETURNS NVARCHAR(MAX)
AS
BEGIN
	DECLARE @PropertyValue NVARCHAR(MAX)

	SELECT
		@PropertyValue = ISNULL([PropertyValue],'')
	FROM
		[ControlFramework].[CurrentProperties]
	WHERE
		[PropertyName] = @PropertyName

    RETURN @PropertyValue
END;

GO

