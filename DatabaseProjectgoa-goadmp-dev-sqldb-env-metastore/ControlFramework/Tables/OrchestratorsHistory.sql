CREATE TABLE [ControlFramework].[OrchestratorsHistory] (
    [OrchestratorId]                INT              NULL,
    [OrchestratorName]              NVARCHAR (200)   NOT NULL,
    [OrchestratorType]              CHAR (3)         NOT NULL,
    [IsFrameworkOrchestrator]       BIT              NOT NULL,
    [OrchestratorResourceGroupName] NVARCHAR (200)   NOT NULL,
    [SubscriptionId]                UNIQUEIDENTIFIER NOT NULL,
    [TenantId]                      UNIQUEIDENTIFIER NOT NULL,
    [Description]                   NVARCHAR (MAX)   NULL,
    [AuditCreated]                  DATETIME         DEFAULT (getdate()) NULL,
    [AuditCreatedBy]                VARCHAR (125)    DEFAULT (suser_sname()) NOT NULL,
    [AuditUpdated]                  DATETIME         NULL,
    [AuditUpdatedBy]                VARCHAR (125)    NULL
);


GO

