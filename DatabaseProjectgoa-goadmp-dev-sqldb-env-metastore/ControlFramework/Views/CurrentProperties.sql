CREATE VIEW [ControlFramework].[CurrentProperties]
AS

SELECT
	[PropertyName],
	[PropertyValue]
FROM
	[ControlFramework].[Properties]
WHERE
	[ValidTo] IS NULL;

GO

