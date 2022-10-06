CREATE TABLE [ControlFramework].[Pipelines] (
    [PipelineId]           INT            IDENTITY (1, 1) NOT NULL,
    [OrchestratorId]       AS             ([ControlFramework].[GetOrchestratorId]()),
    [StageId]              INT            NOT NULL,
    [PipelineName]         NVARCHAR (200) NOT NULL,
    [SubscriptionId]       NVARCHAR (200) NOT NULL,
    [ResourceGroupName]    NVARCHAR (200) NOT NULL,
    [DataFactoryName]      NVARCHAR (200) NOT NULL,
    [BatchId]              NVARCHAR (200) NULL,
    [DestinationIsSynapse] BIT            CONSTRAINT [DF_Pipelines_DestinationIsSynapse] DEFAULT ((0)) NOT NULL,
    [Enabled]              BIT            CONSTRAINT [DF_Pipelines_Enabled] DEFAULT ((1)) NOT NULL,
    [AuditCreated]         DATETIME       CONSTRAINT [DF_Pipelines_AuditCreated] DEFAULT (getdate()) NULL,
    [AuditCreatedBy]       VARCHAR (125)  CONSTRAINT [DF_Pipelines_AuditCreatedBy] DEFAULT (suser_sname()) NOT NULL,
    [AuditUpdated]         DATETIME       NULL,
    [AuditUpdatedBy]       VARCHAR (125)  NULL,
    CONSTRAINT [PK_Pipelines] PRIMARY KEY CLUSTERED ([PipelineId] ASC)
);


GO



CREATE TRIGGER [ControlFramework].[UpdatePipelines]
	ON [ControlFramework].[Pipelines]
	AFTER UPDATE
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE [ControlFramework].[Pipelines]
	SET [AuditUpdated] = GETDATE(), [AuditUpdatedBy] = SYSTEM_USER
	WHERE [PipelineId] IN (SELECT DISTINCT [PipelineId] FROM inserted);

	INSERT INTO [ControlFramework].[PipelinesHistory]  (
		[PipelineId],
		[OrchestratorId],
		[StageId],
		[PipelineName],
		[Enabled],
		[SubscriptionId],
		[ResourceGroupName],
		[DataFactoryName],
		[BatchId],
		[DestinationIsSynapse],
		[AuditCreated],
		[AuditCreatedBy],
		[AuditUpdated],
		[AuditUpdatedBy]
	)
	SELECT 
		[PipelineId],
		[OrchestratorId],
		[StageId],
		[PipelineName],
		[Enabled],
		[SubscriptionId],
		[ResourceGroupName],
		[DataFactoryName],
		[BatchId],
		[DestinationIsSynapse],
		[AuditCreated],
		[AuditCreatedBy],
		GETDATE(),
		SYSTEM_USER
	FROM deleted;

	SET NOCOUNT OFF;
END;

GO


/****** Object:  Trigger [DeletePipelines]    Script Date: 2022/05/02 10:30:19 PM ******/

CREATE TRIGGER [ControlFramework].[DeletePipelines]
	ON [ControlFramework].[Pipelines]
	AFTER DELETE
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO [ControlFramework].[PipelinesHistory]  (
		[PipelineId],
		[OrchestratorId],
		[StageId],
		[PipelineName],
		[Enabled],
		[SubscriptionId],
		[ResourceGroupName],
		[DataFactoryName],
		[BatchId],
		[DestinationIsSynapse],
		[AuditCreated],
		[AuditCreatedBy],
		[AuditUpdated],
		[AuditUpdatedBy]
	)
	SELECT 
		[PipelineId],
		[OrchestratorId],
		[StageId],
		[PipelineName],
		[Enabled],
		[SubscriptionId],
		[ResourceGroupName],
		[DataFactoryName],
		[BatchId],
		[DestinationIsSynapse],
		[AuditCreated],
		[AuditCreatedBy],
		GETDATE(),
		SYSTEM_USER
	FROM deleted;

	SET NOCOUNT OFF;
END

GO

