CREATE TABLE [ControlFramework].[BatchExecution] (
    [BatchId]        UNIQUEIDENTIFIER NOT NULL,
    [ExecutionId]    UNIQUEIDENTIFIER NOT NULL,
    [BatchName]      VARCHAR (255)    NOT NULL,
    [BatchStatus]    NVARCHAR (200)   NOT NULL,
    [StartDateTime]  DATETIME         NOT NULL,
    [EndDateTime]    DATETIME         NULL,
    [AuditCreated]   DATETIME         CONSTRAINT [DF_BatchExecution_AuditCreated] DEFAULT (getdate()) NULL,
    [AuditCreatedBy] VARCHAR (125)    CONSTRAINT [DF_BatchExecution_AuditCreatedBy] DEFAULT (suser_sname()) NOT NULL,
    [AuditUpdated]   DATETIME         NULL,
    [AuditUpdatedBy] VARCHAR (125)    NULL,
    CONSTRAINT [PK_BatchExecution] PRIMARY KEY CLUSTERED ([BatchId] ASC, [ExecutionId] ASC)
);


GO



CREATE TRIGGER [ControlFramework].[DeleteBatchExecution]
	ON [ControlFramework].[BatchExecution]
	AFTER DELETE
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO [ControlFramework].[BatchExecutionHistory]  
		([BatchId]
		,[ExecutionId]
		,[BatchName]
		,[BatchStatus]
		,[StartDateTime]
		,[EndDateTime]
		,[AuditCreated]
		,[AuditCreatedBy]
		,[AuditUpdated]
		,[AuditUpdatedBy])
	SELECT 
		 [BatchId]
		,[ExecutionId]
		,[BatchName]
		,[BatchStatus]
		,[StartDateTime]
		,[EndDateTime]
		,[AuditCreated]
		,[AuditCreatedBy]
		,GETDATE()
		,SYSTEM_USER
	FROM deleted;

	SET NOCOUNT OFF;
END

GO


-- Triggers

CREATE TRIGGER [ControlFramework].[Update_BatchExecution]
	ON [ControlFramework].[BatchExecution]
	AFTER UPDATE
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE [ControlFramework].[BatchExecution]
	SET [AuditUpdated] = GETDATE(), [AuditUpdatedBy] = SYSTEM_USER
	WHERE CONCAT([BatchId], [ExecutionId]) IN (SELECT DISTINCT CONCAT([BatchId], [ExecutionId])  FROM inserted);

	INSERT INTO [ControlFramework].[BatchExecutionHistory]  
		([BatchId]
		,[ExecutionId]
		,[BatchName]
		,[BatchStatus]
		,[StartDateTime]
		,[EndDateTime]
		,[AuditCreated]
		,[AuditCreatedBy]
		,[AuditUpdated]
		,[AuditUpdatedBy])
	SELECT 
		 [BatchId]
		,[ExecutionId]
		,[BatchName]
		,[BatchStatus]
		,[StartDateTime]
		,[EndDateTime]
		,[AuditCreated]
		,[AuditCreatedBy]
		,GETDATE()
		,SYSTEM_USER
	FROM deleted;

	SET NOCOUNT OFF;
END;

GO

