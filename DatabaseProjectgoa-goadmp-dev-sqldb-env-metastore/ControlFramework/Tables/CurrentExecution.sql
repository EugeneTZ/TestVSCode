CREATE TABLE [ControlFramework].[CurrentExecution] (
    [LocalExecutionId]              UNIQUEIDENTIFIER NOT NULL,
    [StageId]                       INT              NOT NULL,
    [PipelineId]                    INT              NOT NULL,
    [ConfigId]                      INT              NOT NULL,
    [CallingOrchestratorName]       NVARCHAR (200)   NOT NULL,
    [OrchestratorResourceGroupName] NVARCHAR (200)   NOT NULL,
    [OrchestratorType]              CHAR (3)         NOT NULL,
    [OrchestratorName]              NVARCHAR (200)   NOT NULL,
    [PipelineName]                  NVARCHAR (200)   NOT NULL,
    [StartDateTime]                 DATETIME         NULL,
    [PipelineStatus]                NVARCHAR (200)   NULL,
    [LastStatusCheckDateTime]       DATETIME         NULL,
    [EndDateTime]                   DATETIME         NULL,
    [IsBlocked]                     BIT              CONSTRAINT [DF_CurrentExecution_IsBlocked] DEFAULT ((0)) NOT NULL,
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
    [AuditCreated]                  DATETIME         CONSTRAINT [DF_CurrentExecution_AuditCreated] DEFAULT (getdate()) NOT NULL,
    [AuditCreatedBy]                VARCHAR (125)    CONSTRAINT [DF_CurrentExecution_AuditCreatedBy] DEFAULT (suser_sname()) NOT NULL,
    [AuditUpdated]                  DATETIME         NULL,
    [AuditUpdatedBy]                VARCHAR (125)    NULL,
    CONSTRAINT [PK_CurrentExecution] PRIMARY KEY CLUSTERED ([LocalExecutionId] ASC, [StageId] ASC, [PipelineId] ASC, [ConfigId] ASC),
    CONSTRAINT [FK_CurrentExecution_Parameters] FOREIGN KEY ([ConfigId]) REFERENCES [ControlFramework].[Parameters] ([ConfigID]) ON UPDATE CASCADE,
    CONSTRAINT [FK_CurrentExecution_Pipelines] FOREIGN KEY ([PipelineId]) REFERENCES [ControlFramework].[Pipelines] ([PipelineId]),
    CONSTRAINT [FK_CurrentExecution_Stages] FOREIGN KEY ([StageId]) REFERENCES [ControlFramework].[Stages] ([StageId])
);


GO

CREATE NONCLUSTERED INDEX [IDX_GetPipelinesInStage]
    ON [ControlFramework].[CurrentExecution]([LocalExecutionId] ASC, [StageId] ASC, [PipelineStatus] ASC)
    INCLUDE([PipelineId], [PipelineName], [OrchestratorType], [OrchestratorName], [OrchestratorResourceGroupName]);


GO


CREATE TRIGGER [ControlFramework].[DeleteCurrentExecution]
	ON [ControlFramework].[CurrentExecution]
	AFTER DELETE
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO [ControlFramework].[CurrentExecutionHistory]  
		([LocalExecutionId]
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
		,[LastStatusCheckDateTime]
		,[EndDateTime]
		,[IsBlocked]
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
		 [LocalExecutionId]
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
		,[LastStatusCheckDateTime]
		,[EndDateTime]
		,[IsBlocked]
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




CREATE TRIGGER [ControlFramework].[UpdateCurrentExecution]
	ON [ControlFramework].[CurrentExecution]
	AFTER UPDATE
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE [ControlFramework].[CurrentExecution]
	SET [AuditUpdated] = GETDATE(), [AuditUpdatedBy] = SYSTEM_USER
	FROM inserted AS ins
	WHERE [ControlFramework].[CurrentExecution].[LocalExecutionId] = ins.[LocalExecutionId]
	AND   [ControlFramework].[CurrentExecution].[StageId] = ins.[StageId]
	AND  [ControlFramework].[CurrentExecution].[PipelineId] = ins.[PipelineId]
	AND  [ControlFramework].[CurrentExecution].[ConfigId] = ins.[ConfigId];

	INSERT INTO [ControlFramework].[CurrentExecutionHistory]  
		([LocalExecutionId]
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
		,[LastStatusCheckDateTime]
		,[EndDateTime]
		,[IsBlocked]
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
		 [LocalExecutionId]
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
		,[LastStatusCheckDateTime]
		,[EndDateTime]
		,[IsBlocked]
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

