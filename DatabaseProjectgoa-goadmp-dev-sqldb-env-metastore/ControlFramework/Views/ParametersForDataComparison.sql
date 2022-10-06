
CREATE VIEW [ControlFramework].[ParametersForDataComparison] WITH SCHEMABINDING
AS
SELECT  convert(varchar(50), CASE WHEN PL.PipelineName = 'PL_Synapse_to_Parquet_CF' THEN 'PL_Synapse_to_Parquet_cf' ELSE PL.PipelineName END)  AS PipelineName
--        ,[ControlFramework].[GetPipelineName_EM] (P.PipelineId) AS PipelineName2
		,CASE B.BatchName 
			WHEN 'Lurp-Daily'   THEN 'LURP-CONV-D' 
		    WHEN 'Daily'        THEN 'LURP-FND-D' 
			WHEN 'LURP-OneTime' THEN 'LURP-Excel-1T' 
			WHEN 'LURP-OneTime' THEN 'LURP-Excel-1T' 
			WHEN 'LURP-SNOW-D'  THEN 'LURP-SNOW-TRUSTED-D'
			ELSE B.BatchName 
		 END AS PipelineBatchName
		,S.StageName AS PipelineStageName 

		,ControlFramework.GetResourceName(P.[DataFactoryName]) AS PipelineDataFactory
		,ControlFramework.GetResourceName(PL.[ResourceGroupName]) AS PipelineResourceGroup

		,convert(varchar(255), SourceAssetName) AS [SourceAssetName]
		,[SourceSchema], [SourceTable], [SourceContainer], [SourceFolder], [SourceFileName]
--		,[SourceURL]
        ,ControlFramework.GetResourceName(P.[SourceURL]) AS SourceURLAlias
--		,SourceConnectionURL
        ,ControlFramework.GetResourceName(P.SourceConnectionURL) AS SourceConnectionURLAlias
--		,SourceConnectionSecret
        ,ControlFramework.GetResourceName(P.SourceConnectionSecret) AS SourceConnectionSecretAlias

		,[SourceDataZone], [SourceSQL]
--		,SourceSystem
        ,ControlFramework.GetResourceName(P.SourceSystem) AS SourceSystemAlias

		,[DestinationSchema], [DestinationTable], [DestinationContainer], [DestinationFolder], [DestinationFileName]
        ,ControlFramework.GetResourceName(P.DestinationURL) AS DestinationURLAlias
        ,ControlFramework.GetResourceName(P.DestinationConnectionURL) AS DestinationConnectionURLAlias
        ,ControlFramework.GetResourceName(P.DestinationConnectionSecret) AS DestinationConnectionSecretAlias
        ,[SynapseSchema], [SynapseTable]
        ,ControlFramework.GetResourceName(P.SynapseConnectionURL) AS SynapseConnectionURLAlias
        ,ControlFramework.GetResourceName(P.SynapseConnectionSecret) AS SynapseConnectionSecretAlias
		,ControlFramework.GetResourceName([Script]) AS ScriptALias
		,JsonRoot, [rdps], [run], [hour], [dim_reference_time], [time], [subsetx], [subsety], [format], [APIURL], [APILoginURL]		
		,ControlFramework.GetResourceName([APIBody]) AS APIBodyAlias
		,ControlFramework.GetResourceName([DataBricksURL]) AS DataBricksURLAlias
		,ControlFramework.GetResourceName([DataBricksResourceID]) AS DataBricksResourceIDAlias
		,ControlFramework.GetResourceName([DataBricksClusterID]) AS DataBricksClusterIDAlias
		,ControlFramework.GetResourceName([PostAPI]) AS PostAPIAlias
		,[SparkClusterVersion], [SparkClusterNodeType], [SparkPythonVersion]
		,ControlFramework.GetResourceName(P.[NoteBookPath]) AS NoteBookPathAlias
		,[ConcurrentNotebooks]
		,[RunDate], [SendNotification], [ExcludeInGeneral], [JobDescription], [ProjectName], [JobVersion], [LoadType], [WatermarkColumn], [WatermarkValue], [Frequency], [SecurityClassification]
		,[ExecutionMachine], [DataOwnerId]
        ,ControlFramework.GetResourceName(P.TargetSystem) AS TargetSystemAlias
		,[TargetAssetName], [TargetDataZone], [TargetAssetID]

    FROM [ControlFramework].Parameters AS P
	JOIN [ControlFramework].[Pipelines] PL ON PL.PipelineId = P.PipelineId
	JOIN [ControlFramework].Batches AS B ON  B.BatchId = PL.BatchId
	JOIN [ControlFramework].Stages AS S ON  S.StageId = PL.StageId

GO

