CREATE     VIEW [metadata].[v_ConfigADFSynapsetoParquet_WLIC] AS 
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
AND DataFactoryName like '%env-wlic-df'

GO

