CREATE TABLE [ControlFramework].[Parameters] (
    [ConfigID]                      INT             IDENTITY (1, 1) NOT NULL,
    [PipelineId]                    INT             NOT NULL,
    [PipelineName]                  AS              ([ControlFramework].[GetPipelineName]([PipelineId])),
    [SourceSchema]                  VARCHAR (100)   NULL,
    [SourceTable]                   VARCHAR (MAX)   NULL,
    [SourceContainer]               VARCHAR (100)   NULL,
    [SourceFolder]                  VARCHAR (100)   NULL,
    [SourceFileName]                VARCHAR (100)   NULL,
    [SourceURL]                     VARCHAR (100)   NULL,
    [SourceConnectionURL]           VARCHAR (100)   NULL,
    [SourceConnectionSecret]        VARCHAR (100)   NULL,
    [SourceSystem]                  VARCHAR (50)    NULL,
    [SourceAssetName]               VARCHAR (MAX)   NULL,
    [SourceDataZone]                VARCHAR (50)    NULL,
    [SourceSQL]                     VARCHAR (MAX)   NULL,
    [DestinationSchema]             VARCHAR (100)   NULL,
    [DestinationTable]              VARCHAR (100)   NULL,
    [DestinationContainer]          VARCHAR (100)   NULL,
    [DestinationFolder]             VARCHAR (100)   NULL,
    [DestinationFileName]           VARCHAR (100)   NULL,
    [DestinationURL]                VARCHAR (100)   NULL,
    [DestinationConnectionURL]      VARCHAR (100)   NULL,
    [DestinationConnectionSecret]   VARCHAR (100)   NULL,
    [DestinationExternalDataSource] AS              (([DestinationContainer]+'_')+replace(replace(replace(Trim([DestinationURL]),'http://',''),'https://',''),'.','_')),
    [DestinationExternalLocation]   AS              ((Trim([DestinationURL])+case when [DestinationURL] IS NOT NULL AND right(Trim([DestinationURL]),(1))<>'/' then '/' else '' end)+[DestinationContainer]),
    [SynapseSchema]                 VARCHAR (100)   NULL,
    [SynapseTable]                  VARCHAR (100)   NULL,
    [SynapseConnectionURL]          VARCHAR (100)   NULL,
    [SynapseConnectionSecret]       VARCHAR (100)   NULL,
    [SynapseScript]                 AS              (case when [ControlFramework].[GetPipelineDestinationIsSynapse]([PipelineId])>(0) then (((((((((((((((((((((((((((((((((('IF NOT EXISTS (SELECT * FROM sys.database_scoped_credentials) 
	CREATE DATABASE SCOPED CREDENTIAL SynapseIdentity WITH IDENTITY = ''Managed Identity'';

IF NOT EXISTS (SELECT * FROM sys.external_file_formats WHERE name = ''SynapseParquetFormat'') 
	CREATE EXTERNAL FILE FORMAT [SynapseParquetFormat] WITH ( FORMAT_TYPE = PARQUET); 

IF NOT EXISTS (SELECT * FROM sys.external_data_sources WHERE name = '''+[DestinationContainer])+'_')+replace(replace(replace(Trim([DestinationURL]),'http://',''),'https://',''),'.','_'))+''') 
	CREATE EXTERNAL DATA SOURCE [')+[DestinationContainer])+'_')+replace(replace(replace(Trim([DestinationURL]),'http://',''),'https://',''),'.','_'))+'] 
	WITH (LOCATION   = ''')+Trim([DestinationURL]))+case when [DestinationURL] IS NOT NULL AND right(Trim([DestinationURL]),(1))<>'/' then '/' else '' end)+[DestinationContainer])+''',CREDENTIAL = SynapseIdentity );

IF SCHEMA_ID(''')+[SynapseSchema])+''') IS NULL 
	EXEC (''CREATE SCHEMA [')+[SynapseSchema])+']'')

IF EXISTS (SELECT * FROM sys.external_tables WHERE OBJECT_ID=OBJECT_ID(''[')+[SynapseSchema])+'].[')+[SynapseTable])+']'')) 
	DROP EXTERNAL TABLE [')+[SynapseSchema])+'].[')+[SynapseTable])+'];

CREATE EXTERNAL TABLE [')+[SynapseSchema])+'].[')+[SynapseTable])+'] (
	#COLUMN_DEFINITIONS#
	)
	WITH (LOCATION = ''')+[DestinationFolder])+[DestinationFileName])+'''
	,DATA_SOURCE = [')+[DestinationContainer])+'_')+replace(replace(replace(Trim([DestinationURL]),'http://',''),'https://',''),'.','_'))+']
	,FILE_FORMAT = [SynapseParquetFormat]
	);
select ADF_Lookup_Result=1;'  end),
    [Script]                        VARCHAR (MAX)   NULL,
    [JsonRoot]                      VARCHAR (1000)  NULL,
    [JsonKeys]                      VARCHAR (1000)  NULL,
    [rdps]                          VARCHAR (1000)  NULL,
    [run]                           VARCHAR (1000)  NULL,
    [hour]                          VARCHAR (1000)  NULL,
    [dim_reference_time]            DATETIME        NULL,
    [time]                          DATETIME        NULL,
    [subsetx]                       VARCHAR (1000)  NULL,
    [subsety]                       VARCHAR (1000)  NULL,
    [format]                        VARCHAR (1000)  NULL,
    [APIURL]                        VARCHAR (250)   NULL,
    [APILoginURL]                   VARCHAR (250)   NULL,
    [APIBody]                       NVARCHAR (1000) NULL,
    [DataBricksURL]                 NVARCHAR (250)  NULL,
    [DataBricksResourceID]          NVARCHAR (500)  NULL,
    [DataBricksClusterID]           NVARCHAR (250)  NULL,
    [PostAPI]                       NVARCHAR (1000) NULL,
    [SparkClusterVersion]           NVARCHAR (50)   NULL,
    [SparkClusterNodeType]          NVARCHAR (50)   NULL,
    [SparkPythonVersion]            NVARCHAR (50)   NULL,
    [NoteBookPath]                  NVARCHAR (250)  NULL,
    [ConcurrentNotebooks]           NVARCHAR (10)   NULL,
    [RunDate]                       NVARCHAR (50)   NULL,
    [SendNotification]              BIT             NULL,
    [DataFactoryName]               VARCHAR (100)   NULL,
    [ExcludeInGeneral]              BIT             CONSTRAINT [DF_Parameters_ExcludeInGeneral] DEFAULT ((0)) NOT NULL,
    [JobDescription]                VARCHAR (1000)  CONSTRAINT [DF_Parameters_JobDescription] DEFAULT ('Default Job Description') NOT NULL,
    [ProjectName]                   VARCHAR (50)    CONSTRAINT [DF_Parameters_ProjectName] DEFAULT ('DMP') NULL,
    [JobVersion]                    VARCHAR (15)    CONSTRAINT [DF_Parameters_JobVersion] DEFAULT ('1.0') NULL,
    [LoadType]                      VARCHAR (125)   NULL,
    [WatermarkColumn]               VARCHAR (1000)  NULL,
    [WatermarkValue]                VARCHAR (1000)  NULL,
    [Frequency]                     VARCHAR (50)    CONSTRAINT [DF_Parameters_Frequency] DEFAULT ('DAILY') NOT NULL,
    [SecurityClassification]        VARCHAR (50)    CONSTRAINT [DF_Parameters_SecurityClassification] DEFAULT ('PUBLIC') NULL,
    [ExecutionMachine]              VARCHAR (125)   NULL,
    [DataOwnerId]                   VARCHAR (255)   NULL,
    [TargetSystem]                  VARCHAR (50)    NULL,
    [TargetAssetName]               VARCHAR (1000)  NULL,
    [TargetDataZone]                VARCHAR (50)    NULL,
    [TargetAssetID]                 NVARCHAR (200)  NULL,
    [AuditCreated]                  DATETIME        CONSTRAINT [DF_Parameters_AuditCreated] DEFAULT (getdate()) NOT NULL,
    [AuditCreatedBy]                VARCHAR (125)   CONSTRAINT [DF_Parameters_AuditCreatedBy] DEFAULT (suser_sname()) NOT NULL,
    [AuditUpdated]                  DATETIME        NULL,
    [AuditUpdatedBy]                VARCHAR (125)   NULL,
    CONSTRAINT [pk_ConfigADF] PRIMARY KEY CLUSTERED ([ConfigID] ASC),
    CONSTRAINT [FK_Parameters_Pipelines] FOREIGN KEY ([PipelineId]) REFERENCES [ControlFramework].[Pipelines] ([PipelineId]) ON UPDATE CASCADE
);


GO


CREATE TRIGGER [ControlFramework].[UpdateParameters]
	ON [ControlFramework].[Parameters]
	AFTER UPDATE
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE [ControlFramework].[Parameters]
	   SET [AuditUpdated] = GETDATE(), [AuditUpdatedBy] = SYSTEM_USER
	 WHERE [ConfigID] IN (SELECT DISTINCT [ConfigID] FROM inserted);

	INSERT INTO [ControlFramework].[ParametersHistory]  
	(
		 [ConfigID]
		,[PipelineId]
		,[PipelineName]
		,[SourceSchema]
		,[SourceTable]
		,[SourceSQL]
		,[SourceContainer]
		,[SourceFolder]
		,[SourceFileName]
		,[SourceURL]
		,[SourceConnectionURL]
		,[SourceConnectionSecret]
		,[DestinationSchema]
		,[DestinationTable]
		,[DestinationContainer]
		,[DestinationFolder]
		,[DestinationFileName]
		,[DestinationURL]
		,[DestinationConnectionURL]
		,[DestinationConnectionSecret]
		,[DestinationExternalDataSource]
		,[DestinationExternalLocation]
		,[SynapseSchema]
		,[SynapseTable]
		,[SynapseScript]
		,[SynapseConnectionURL]
		,[SynapseConnectionSecret]
		,[Script]
		,[JsonRoot]
		,[JsonKeys]
		,[rdps]
		,[run]
		,[hour]
		,[dim_reference_time]
		,[time]
		,[subsetx]
		,[subsety]
		,[format]
		,[APIURL]
		,[APILoginURL]
		,[APIBody]
		,[DataBricksURL]
		,[DataBricksResourceID]
		,[DataBricksClusterID]
		,[PostAPI]
		,[SparkClusterVersion]
		,[SparkClusterNodeType]
		,[SparkPythonVersion]
		,[NoteBookPath]
		,[ConcurrentNotebooks]
		,[RunDate]
		,[SendNotification]
		,[DataFactoryName]
		,[ExcludeInGeneral]
		,[JobDescription]
		,[ProjectName]
		,[JobVersion]
		,[LoadType]
		,[WatermarkColumn]
		,[WatermarkValue]
		,[Frequency]
		,[SecurityClassification]
		,[ExecutionMachine]
		,[DataOwnerId]
		,[SourceSystem]
		,[SourceAssetName]
		,[SourceDataZone]
		,[TargetSystem]
		,[TargetAssetID]
		,[TargetAssetName]
		,[TargetDataZone]
		,[AuditCreated]
		,[AuditCreatedBy]
		,[AuditUpdated]
		,[AuditUpdatedBy]
	)
	SELECT 
		 [ConfigID]
		,[PipelineId]
		,[PipelineName]
		,[SourceSchema]
		,[SourceTable]
		,[SourceSQL]
		,[SourceContainer]
		,[SourceFolder]
		,[SourceFileName]
		,[SourceURL]
		,[SourceConnectionURL]
		,[SourceConnectionSecret]
		,[DestinationSchema]
		,[DestinationTable]
		,[DestinationContainer]
		,[DestinationFolder]
		,[DestinationFileName]
		,[DestinationURL]
		,[DestinationConnectionURL]
		,[DestinationConnectionSecret]
		,[DestinationExternalDataSource]
		,[DestinationExternalLocation]
		,[SynapseSchema]
		,[SynapseTable]
		,[SynapseScript]
		,[SynapseConnectionURL]
		,[SynapseConnectionSecret]
		,[Script]
		,[JsonRoot]
		,[JsonKeys]
		,[rdps]
		,[run]
		,[hour]
		,[dim_reference_time]
		,[time]
		,[subsetx]
		,[subsety]
		,[format]
		,[APIURL]
		,[APILoginURL]
		,[APIBody]
		,[DataBricksURL]
		,[DataBricksResourceID]
		,[DataBricksClusterID]
		,[PostAPI]
		,[SparkClusterVersion]
		,[SparkClusterNodeType]
		,[SparkPythonVersion]
		,[NoteBookPath]
		,[ConcurrentNotebooks]
		,[RunDate]
		,[SendNotification]
		,[DataFactoryName]
		,[ExcludeInGeneral]
		,[JobDescription]
		,[ProjectName]
		,[JobVersion]
		,[LoadType]
		,[WatermarkColumn]
		,[WatermarkValue]
		,[Frequency]
		,[SecurityClassification]
		,[ExecutionMachine]
		,[DataOwnerId]
		,[SourceSystem]
		,[SourceAssetName]
		,[SourceDataZone]
		,[TargetSystem]
		,[TargetAssetID]
		,[TargetAssetName]
		,[TargetDataZone]
		,[AuditCreated]
		,[AuditCreatedBy]
		,GETDATE()
		,SYSTEM_USER
	FROM deleted;

	SET NOCOUNT OFF;
	
END
;

GO


CREATE TRIGGER [ControlFramework].[DeleteParameters]
	ON [ControlFramework].[Parameters]
	AFTER DELETE
AS
	BEGIN
	SET NOCOUNT ON;

	INSERT INTO [ControlFramework].[ParametersHistory]  
	(
		 [ConfigID]
		,[PipelineId]
		,[PipelineName]
		,[SourceSchema]
		,[SourceTable]
		,[SourceSQL]
		,[SourceContainer]
		,[SourceFolder]
		,[SourceFileName]
		,[SourceURL]
		,[SourceConnectionURL]
		,[SourceConnectionSecret]
		,[DestinationSchema]
		,[DestinationTable]
		,[DestinationContainer]
		,[DestinationFolder]
		,[DestinationFileName]
		,[DestinationURL]
		,[DestinationConnectionURL]
		,[DestinationConnectionSecret]
		,[DestinationExternalDataSource]
		,[DestinationExternalLocation]
		,[SynapseSchema]
		,[SynapseTable]
		,[SynapseScript]
		,[SynapseConnectionURL]
		,[SynapseConnectionSecret]
		,[Script]
		,[JsonRoot]
		,[JsonKeys]
		,[rdps]
		,[run]
		,[hour]
		,[dim_reference_time]
		,[time]
		,[subsetx]
		,[subsety]
		,[format]
		,[APIURL]
		,[APILoginURL]
		,[APIBody]
		,[DataBricksURL]
		,[DataBricksResourceID]
		,[DataBricksClusterID]
		,[PostAPI]
		,[SparkClusterVersion]
		,[SparkClusterNodeType]
		,[SparkPythonVersion]
		,[NoteBookPath]
		,[ConcurrentNotebooks]
		,[RunDate]
		,[SendNotification]
		,[DataFactoryName]
		,[ExcludeInGeneral]
		,[JobDescription]
		,[ProjectName]
		,[JobVersion]
		,[LoadType]
		,[WatermarkColumn]
		,[WatermarkValue]
		,[Frequency]
		,[SecurityClassification]
		,[ExecutionMachine]
		,[DataOwnerId]
		,[SourceSystem]
		,[SourceAssetName]
		,[SourceDataZone]
		,[TargetSystem]
		,[TargetAssetID]
		,[TargetAssetName]
		,[TargetDataZone]
		,[AuditCreated]
		,[AuditCreatedBy]
		,[AuditUpdated]
		,[AuditUpdatedBy]
	)
	SELECT 
		 [ConfigID]
		,[PipelineId]
		,[PipelineName]
		,[SourceSchema]
		,[SourceTable]
		,[SourceSQL]
		,[SourceContainer]
		,[SourceFolder]
		,[SourceFileName]
		,[SourceURL]
		,[SourceConnectionURL]
		,[SourceConnectionSecret]
		,[DestinationSchema]
		,[DestinationTable]
		,[DestinationContainer]
		,[DestinationFolder]
		,[DestinationFileName]
		,[DestinationURL]
		,[DestinationConnectionURL]
		,[DestinationConnectionSecret]
		,[DestinationExternalDataSource]
		,[DestinationExternalLocation]
		,[SynapseSchema]
		,[SynapseTable]
		,[SynapseScript]
		,[SynapseConnectionURL]
		,[SynapseConnectionSecret]
		,[Script]
		,[JsonRoot]
		,[JsonKeys]
		,[rdps]
		,[run]
		,[hour]
		,[dim_reference_time]
		,[time]
		,[subsetx]
		,[subsety]
		,[format]
		,[APIURL]
		,[APILoginURL]
		,[APIBody]
		,[DataBricksURL]
		,[DataBricksResourceID]
		,[DataBricksClusterID]
		,[PostAPI]
		,[SparkClusterVersion]
		,[SparkClusterNodeType]
		,[SparkPythonVersion]
		,[NoteBookPath]
		,[ConcurrentNotebooks]
		,[RunDate]
		,[SendNotification]
		,[DataFactoryName]
		,[ExcludeInGeneral]
		,[JobDescription]
		,[ProjectName]
		,[JobVersion]
		,[LoadType]
		,[WatermarkColumn]
		,[WatermarkValue]
		,[Frequency]
		,[SecurityClassification]
		,[ExecutionMachine]
		,[DataOwnerId]
		,[SourceSystem]
		,[SourceAssetName]
		,[SourceDataZone]
		,[TargetSystem]
		,[TargetAssetID]
		,[TargetAssetName]
		,[TargetDataZone]
		,[AuditCreated]
		,[AuditCreatedBy]
		,GETDATE()
		,SYSTEM_USER
	FROM deleted;

	SET NOCOUNT OFF;
END

GO

