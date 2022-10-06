
CREATE     VIEW [metadata].[v_ConfigADFOracletoParquet_WMTT] AS
SELECT  TOP 100 PERCENT
/* Source Synapse*/
SUBSTRING(sourceTable, charindex('.', sourceTable, 7) + 1, LEN(sourceTable)) as OracleTable, *
FROM metadata.ConfigADF
WHERE configType = 6
	AND DataFactoryName = 'goa-goadmp-dev-env-wmtt-df'

GO

