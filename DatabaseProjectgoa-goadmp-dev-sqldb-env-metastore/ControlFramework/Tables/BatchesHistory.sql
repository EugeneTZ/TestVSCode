CREATE TABLE [ControlFramework].[BatchesHistory] (
    [BatchId]          UNIQUEIDENTIFIER NOT NULL,
    [BatchName]        VARCHAR (255)    NOT NULL,
    [BatchDescription] VARCHAR (4000)   NULL,
    [Enabled]          BIT              NOT NULL,
    [AuditCreated]     DATETIME         NOT NULL,
    [AuditCreatedBy]   VARCHAR (125)    NOT NULL,
    [AuditUpdated]     DATETIME         NULL,
    [AuditUpdatedBy]   VARCHAR (125)    NULL
);


GO

