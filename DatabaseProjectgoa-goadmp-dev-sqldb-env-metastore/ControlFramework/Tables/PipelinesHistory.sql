CREATE TABLE [ControlFramework].[PipelinesHistory] (
    [PipelineId]           INT            NOT NULL,
    [OrchestratorId]       INT            NULL,
    [StageId]              INT            NOT NULL,
    [PipelineName]         NVARCHAR (200) NOT NULL,
    [SubscriptionId]       NVARCHAR (200) NOT NULL,
    [ResourceGroupName]    NVARCHAR (200) NOT NULL,
    [DataFactoryName]      NVARCHAR (200) NOT NULL,
    [BatchId]              NVARCHAR (200) NULL,
    [DestinationIsSynapse] BIT            NOT NULL,
    [Enabled]              BIT            NOT NULL,
    [AuditCreated]         DATETIME       NULL,
    [AuditCreatedBy]       VARCHAR (125)  NOT NULL,
    [AuditUpdated]         DATETIME       NULL,
    [AuditUpdatedBy]       VARCHAR (125)  NULL
);


GO

