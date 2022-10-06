CREATE TABLE [ControlFramework].[Orchestrators] (
    [OrchestratorId]                INT              IDENTITY (1, 1) NOT NULL,
    [OrchestratorName]              NVARCHAR (200)   NOT NULL,
    [OrchestratorType]              CHAR (3)         NOT NULL,
    [IsFrameworkOrchestrator]       BIT              DEFAULT ((0)) NOT NULL,
    [OrchestratorResourceGroupName] NVARCHAR (200)   NOT NULL,
    [SubscriptionId]                UNIQUEIDENTIFIER NOT NULL,
    [TenantId]                      UNIQUEIDENTIFIER NOT NULL,
    [Description]                   NVARCHAR (MAX)   NULL,
    [AuditCreated]                  DATETIME         DEFAULT (getdate()) NULL,
    [AuditCreatedBy]                VARCHAR (125)    DEFAULT (suser_sname()) NOT NULL,
    [AuditUpdated]                  DATETIME         NULL,
    [AuditUpdatedBy]                VARCHAR (125)    NULL,
    CONSTRAINT [PK_Orchestrators] PRIMARY KEY CLUSTERED ([OrchestratorId] ASC)
);


GO


CREATE TRIGGER [ControlFramework].[DeleteOrchestrators]
	ON [ControlFramework].[Orchestrators]
	AFTER DELETE
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO [ControlFramework].[OrchestratorsHistory]  (
		[OrchestratorId],
        [OrchestratorName],
        [OrchestratorType],
        [IsFrameworkOrchestrator],
        [OrchestratorResourceGroupName],
        [SubscriptionId],
        [TenantId],
        [Description],
		[AuditCreated],
		[AuditCreatedBy],
		[AuditUpdated],
		[AuditUpdatedBy]
	)
	SELECT 
		[OrchestratorId],
        [OrchestratorName],
        [OrchestratorType],
        [IsFrameworkOrchestrator],
        [OrchestratorResourceGroupName],
        [SubscriptionId],
        [TenantId],
        [Description],
		[AuditCreated],
		[AuditCreatedBy],
		GETDATE(),
		SYSTEM_USER
	FROM deleted;

	SET NOCOUNT OFF;
END

GO



CREATE TRIGGER [ControlFramework].[UpdateOrchestrators]
	ON [ControlFramework].[Orchestrators]
	AFTER UPDATE
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE [ControlFramework].[Orchestrators]
	SET [AuditUpdated] = GETDATE(), [AuditUpdatedBy] = SYSTEM_USER
	WHERE [OrchestratorId] IN (SELECT DISTINCT [OrchestratorId] FROM inserted);

	INSERT INTO [ControlFramework].[OrchestratorsHistory]  (
		[OrchestratorId],
        [OrchestratorName],
        [OrchestratorType],
        [IsFrameworkOrchestrator],
        [OrchestratorResourceGroupName],
        [SubscriptionId],
        [TenantId],
        [Description],
		[AuditCreated],
		[AuditCreatedBy],
		[AuditUpdated],
		[AuditUpdatedBy]
	)
	SELECT 
		[OrchestratorId],
        [OrchestratorName],
        [OrchestratorType],
        [IsFrameworkOrchestrator],
        [OrchestratorResourceGroupName],
        [SubscriptionId],
        [TenantId],
        [Description],
		[AuditCreated],
		[AuditCreatedBy],
		GETDATE(),
		SYSTEM_USER
	FROM deleted;

	SET NOCOUNT OFF;
END;

GO

