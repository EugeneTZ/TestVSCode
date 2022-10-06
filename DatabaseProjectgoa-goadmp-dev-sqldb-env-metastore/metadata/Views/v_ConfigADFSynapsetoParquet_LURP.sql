



CREATE     VIEW [metadata].[v_ConfigADFSynapsetoParquet_LURP] AS 
SELECT  TOP 100 PERCENT 
/* Source Synapse*/
ConfigId,DataFactoryName,ExcludeInGeneral
,sourceSQL 
,sourceConnectionSecret		

/* Parquet file*/
,destinationContainer		
,destinationFolder			
,destinationFileName
,destinationURL
,destinationConnectionSecret

/* Synapse CETAS for Parquet files*/
,synapseConnectionSecret = ISNULL(synapseConnectionSecret,'')
,synapseSchema
,synapseTable
,synapseScript 


FROM metadata.ConfigADF
WHERE configType =2 /* 2=Synapse to Parquet,  */
AND DataFactoryName like '%df-env-lurp'
-- AND (sourceTable LIKE '%v_ReservationApplications%'OR sourceTable LIKE '%v_ReservationApprovals%')
--AND synapseTable LIKE '%category%'
--ORDER BY sourceConnectionSecret,sourceSchema, sourceTable

GO

