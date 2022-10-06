CREATE TABLE [ControlFramework].[ExecutionLog] (
    [LogId]                         INT              IDENTITY (1, 1) NOT NULL,
    [LocalExecutionId]              UNIQUEIDENTIFIER NOT NULL,
    [StageId]                       INT              NOT NULL,
    [PipelineId]                    INT              NOT NULL,
    [ConfigId]                      INT              NULL,
    [CallingOrchestratorName]       NVARCHAR (200)   CONSTRAINT [DF_ExecutionLog_CallingOrchestratorName] DEFAULT ('Unknown') NOT NULL,
    [OrchestratorResourceGroupName] NVARCHAR (200)   CONSTRAINT [DF_ExecutionLog_OrchestratorResourceGroupName] DEFAULT ('Unknown') NOT NULL,
    [OrchestratorType]              CHAR (3)         CONSTRAINT [DF_ExecutionLog_OrchestratorType] DEFAULT ('N/A') NOT NULL,
    [OrchestratorName]              NVARCHAR (200)   CONSTRAINT [DF_ExecutionLog_OrchestratorName] DEFAULT ('Unknown') NOT NULL,
    [PipelineName]                  NVARCHAR (200)   NOT NULL,
    [StartDateTime]                 DATETIME         NULL,
    [PipelineStatus]                NVARCHAR (200)   NULL,
    [EndDateTime]                   DATETIME         NULL,
    [PipelineRunId]                 UNIQUEIDENTIFIER NULL,
    [SubscriptionId]                NVARCHAR (200)   NULL,
    [ResourceGroupName]             NVARCHAR (200)   NULL,
    [DataFactoryName]               NVARCHAR (200)   NULL,
    [SourceSchema]                  VARCHAR (100)    NULL,
    [SourceTable]                   VARCHAR (MAX)    NULL,
    [SourceSQL]                     VARCHAR (MAX)    NULL,
    [SourceContainer]               VARCHAR (100)    NULL,
    [SourceFolder]                  VARCHAR (100)    NULL,
    [SourceFileName]                VARCHAR (100)    NULL,
    [SourceURL]                     VARCHAR (100)    NULL,
    [SourceConnectionURL]           VARCHAR (100)    NULL,
    [SourceConnectionSecret]        VARCHAR (100)    NULL,
    [DestinationSchema]             VARCHAR (100)    NULL,
    [DestinationTable]              VARCHAR (100)    NULL,
    [DestinationContainer]          VARCHAR (100)    NULL,
    [DestinationFolder]             VARCHAR (100)    NULL,
    [DestinationFileName]           VARCHAR (100)    NULL,
    [DestinationURL]                VARCHAR (100)    NULL,
    [DestinationConnectionURL]      VARCHAR (100)    NULL,
    [DestinationConnectionSecret]   VARCHAR (100)    NULL,
    [DestinationExternalDataSource] VARCHAR (MAX)    NULL,
    [DestinationExternalLocation]   VARCHAR (MAX)    NULL,
    [SynapseSchema]                 VARCHAR (100)    NULL,
    [SynapseTable]                  VARCHAR (100)    NULL,
    [SynapseScript]                 VARCHAR (MAX)    NULL,
    [SynapseConnectionURL]          VARCHAR (100)    NULL,
    [SynapseConnectionSecret]       VARCHAR (100)    NULL,
    [Script]                        VARCHAR (MAX)    NULL,
    [JsonRoot]                      VARCHAR (1000)   NULL,
    [rdps]                          VARCHAR (1000)   NULL,
    [run]                           VARCHAR (1000)   NULL,
    [hour]                          VARCHAR (1000)   NULL,
    [dim_reference_time]            DATETIME         NULL,
    [time]                          DATETIME         NULL,
    [subsetx]                       VARCHAR (1000)   NULL,
    [subsety]                       VARCHAR (1000)   NULL,
    [format]                        VARCHAR (1000)   NULL,
    [APIURL]                        VARCHAR (250)    NULL,
    [APILoginURL]                   VARCHAR (250)    NULL,
    [DataBricksURL]                 NVARCHAR (250)   NULL,
    [DataBricksResourceID]          NVARCHAR (500)   NULL,
    [SparkClusterVersion]           NVARCHAR (50)    NULL,
    [SparkClusterNodeType]          NVARCHAR (50)    NULL,
    [SparkPythonVersion]            NVARCHAR (50)    NULL,
    [NoteBookPath]                  NVARCHAR (250)   NULL,
    [ConcurrentNotebooks]           NVARCHAR (10)    NULL,
    [RunDate]                       NVARCHAR (50)    NULL,
    [ExcludeInGeneral]              BIT              NOT NULL,
    [JobDescription]                VARCHAR (1000)   NOT NULL,
    [ProjectName]                   VARCHAR (50)     NULL,
    [JobVersion]                    VARCHAR (15)     NULL,
    [LoadType]                      VARCHAR (125)    NULL,
    [WatermarkColumn]               VARCHAR (1000)   NULL,
    [WatermarkValue]                VARCHAR (1000)   NULL,
    [Frequency]                     VARCHAR (50)     NOT NULL,
    [SecurityClassification]        VARCHAR (50)     NULL,
    [ExecutionMachine]              VARCHAR (125)    NULL,
    [DataOwnerId]                   VARCHAR (255)    NULL,
    [SourceSystem]                  VARCHAR (50)     NULL,
    [SourceAssetName]               VARCHAR (MAX)    NULL,
    [SourceDataZone]                VARCHAR (50)     NULL,
    [TargetSystem]                  VARCHAR (50)     NULL,
    [TargetAssetName]               VARCHAR (1000)   NULL,
    [TargetDataZone]                VARCHAR (50)     NULL,
    [TargetAssetID]                 NVARCHAR (200)   NULL,
    [ExecutionUserId]               VARCHAR (125)    NULL,
    [ProcessorMessage]              VARCHAR (MAX)    NULL,
    [RecordCount]                   INT              NULL,
    [AuditCreated]                  DATETIME         CONSTRAINT [DF_ExecutionLog_AuditCreated] DEFAULT (getdate()) NOT NULL,
    [AuditCreatedBy]                VARCHAR (125)    CONSTRAINT [DF_ExecutionLog_AuditCreatedBy] DEFAULT (suser_sname()) NOT NULL,
    [AuditUpdated]                  DATETIME         NULL,
    [AuditUpdatedBy]                VARCHAR (125)    NULL,
    CONSTRAINT [PK_ExecutionLog] PRIMARY KEY CLUSTERED ([LogId] ASC)
);


GO



CREATE TRIGGER [ControlFramework].[DeleteExecutionLog]
	ON [ControlFramework].[ExecutionLog]
	AFTER DELETE
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO [ControlFramework].[ExecutionLogHistory]  
		([LogId]
		,[LocalExecutionId]
		,[StageId]
		,[PipelineId]
		,[ConfigId]
		,[CallingOrchestratorName]
		,[OrchestratorResourceGroupName]
		,[OrchestratorType]
		,[OrchestratorName]
		,[PipelineName]
		,[StartDateTime]
		,[PipelineStatus]
		,[EndDateTime]
		,[PipelineRunId]
		,[SubscriptionId]
		,[ResourceGroupName]
		,[DataFactoryName]
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
		,[DataBricksURL]
		,[DataBricksResourceID]
		,[SparkClusterVersion]
		,[SparkClusterNodeType]
		,[SparkPythonVersion]
		,[NoteBookPath]
		,[ConcurrentNotebooks]
		,[RunDate]
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
		,[TargetAssetName]
		,[TargetDataZone]
		,[TargetAssetID]
		,[ExecutionUserId]
		,[ProcessorMessage]
		,[RecordCount]
		,[AuditCreated]
		,[AuditCreatedBy]
		,[AuditUpdated]
		,[AuditUpdatedBy])
	SELECT 
		 [LogId]
		,[LocalExecutionId]
		,[StageId]
		,[PipelineId]
		,[ConfigId]
		,[CallingOrchestratorName]
		,[OrchestratorResourceGroupName]
		,[OrchestratorType]
		,[OrchestratorName]
		,[PipelineName]
		,[StartDateTime]
		,[PipelineStatus]
		,[EndDateTime]
		,[PipelineRunId]
		,[SubscriptionId]
		,[ResourceGroupName]
		,[DataFactoryName]
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
		,[DataBricksURL]
		,[DataBricksResourceID]
		,[SparkClusterVersion]
		,[SparkClusterNodeType]
		,[SparkPythonVersion]
		,[NoteBookPath]
		,[ConcurrentNotebooks]
		,[RunDate]
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
		,[TargetAssetName]
		,[TargetDataZone]
		,[TargetAssetID]
		,[ExecutionUserId]
		,[ProcessorMessage]
		,[RecordCount]
		,[AuditCreated]
		,[AuditCreatedBy]
		,GETDATE()
		,SYSTEM_USER
	FROM deleted;

	SET NOCOUNT OFF;
END

GO



CREATE TRIGGER [ControlFramework].[Update_ExecutionLog]
	ON [ControlFramework].[ExecutionLog]
	AFTER UPDATE
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE [ControlFramework].[ExecutionLog]
	SET [AuditUpdated] = GETDATE(), [AuditUpdatedBy] = SYSTEM_USER
	WHERE LogId IN (SELECT DISTINCT LogId  FROM inserted);

	INSERT INTO [ControlFramework].[ExecutionLogHistory]  
		([LogId]
		,[LocalExecutionId]
		,[StageId]
		,[PipelineId]
		,[ConfigId]
		,[CallingOrchestratorName]
		,[OrchestratorResourceGroupName]
		,[OrchestratorType]
		,[OrchestratorName]
		,[PipelineName]
		,[StartDateTime]
		,[PipelineStatus]
		,[EndDateTime]
		,[PipelineRunId]
		,[SubscriptionId]
		,[ResourceGroupName]
		,[DataFactoryName]
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
		,[DataBricksURL]
		,[DataBricksResourceID]
		,[SparkClusterVersion]
		,[SparkClusterNodeType]
		,[SparkPythonVersion]
		,[NoteBookPath]
		,[ConcurrentNotebooks]
		,[RunDate]
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
		,[TargetAssetName]
		,[TargetDataZone]
		,[TargetAssetID]
		,[ExecutionUserId]
		,[ProcessorMessage]
		,[RecordCount]
		,[AuditCreated]
		,[AuditCreatedBy]
		,[AuditUpdated]
		,[AuditUpdatedBy])
	SELECT 
		 [LogId]
		,[LocalExecutionId]
		,[StageId]
		,[PipelineId]
		,[ConfigId]
		,[CallingOrchestratorName]
		,[OrchestratorResourceGroupName]
		,[OrchestratorType]
		,[OrchestratorName]
		,[PipelineName]
		,[StartDateTime]
		,[PipelineStatus]
		,[EndDateTime]
		,[PipelineRunId]
		,[SubscriptionId]
		,[ResourceGroupName]
		,[DataFactoryName]
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
		,[DataBricksURL]
		,[DataBricksResourceID]
		,[SparkClusterVersion]
		,[SparkClusterNodeType]
		,[SparkPythonVersion]
		,[NoteBookPath]
		,[ConcurrentNotebooks]
		,[RunDate]
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
		,[TargetAssetName]
		,[TargetDataZone]
		,[TargetAssetID]
		,[ExecutionUserId]
		,[ProcessorMessage]
		,[RecordCount]
		,[AuditCreated]
		,[AuditCreatedBy]
		,GETDATE()
		,SYSTEM_USER
	FROM deleted;

	SET NOCOUNT OFF;
END;

GO

