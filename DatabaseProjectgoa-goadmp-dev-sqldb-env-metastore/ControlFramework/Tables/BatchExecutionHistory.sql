CREATE TABLE [ControlFramework].[BatchExecutionHistory] (
    [BatchId]        UNIQUEIDENTIFIER NOT NULL,
    [ExecutionId]    UNIQUEIDENTIFIER NOT NULL,
    [BatchName]      VARCHAR (255)    NOT NULL,
    [BatchStatus]    NVARCHAR (200)   NOT NULL,
    [StartDateTime]  DATETIME         NOT NULL,
    [EndDateTime]    DATETIME         NULL,
    [AuditCreated]   DATETIME         NULL,
    [AuditCreatedBy] VARCHAR (125)    NOT NULL,
    [AuditUpdated]   DATETIME         NULL,
    [AuditUpdatedBy] VARCHAR (125)    NULL
);


GO

