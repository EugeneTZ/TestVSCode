



CREATE VIEW [metadata].[v_ConfigADFMSSQLToParquet_LURP] AS 
SELECT DISTINCT TOP 100 PERCENT 
ConfigId,DataFactoryName,ExcludeInGeneral
,sourceSchema				
,sourceTable				
,sourceConnectionSecret		
,destinationContainer		
,destinationFolder			
,destinationFileName
,destinationURL
,destinationConnectionSecret

,synapseConnectionSecret
,synapseSchema
,synapseTable
,synapseScript

FROM metadata.ConfigADF
WHERE configType =3 /* 3=MSSQL to Parquet,  */
--AND sourceSchema='Staging'
AND DataFactoryName like '%df-env-lurp'
ORDER BY sourceConnectionSecret,sourceSchema, sourceTable

GO

