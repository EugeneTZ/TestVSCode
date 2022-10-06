


CREATE VIEW [metadata].[v_ConfigADFAzSqlToParquet_LURP] AS 
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
WHERE configType =1 /* 1=AZSQL to Parquet,  */
--AND synapseTable='ReferralAgency'
AND DataFactoryName like '%df-env-lurp'
ORDER BY sourceConnectionSecret,sourceSchema, sourceTable

GO

