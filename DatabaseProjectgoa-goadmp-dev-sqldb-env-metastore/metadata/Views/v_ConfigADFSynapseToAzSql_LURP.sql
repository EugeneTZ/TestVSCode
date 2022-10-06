



CREATE VIEW [metadata].[v_ConfigADFSynapseToAzSql_LURP] AS 
SELECT DISTINCT TOP 100 PERCENT 
ConfigId,DataFactoryName,ExcludeInGeneral
,sourceSQL 				
,sourceConnectionSecret		
,destinationSchema		
,destinationTable			
,destinationConnectionSecret
FROM metadata.ConfigADF
WHERE configType =4 /* 4=Synapse to Azure SQL */
AND DataFactoryName like '%df-env-lurp'
ORDER BY sourceConnectionSecret,sourceSQL

GO

