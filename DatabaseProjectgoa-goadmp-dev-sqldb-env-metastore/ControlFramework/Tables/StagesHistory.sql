CREATE TABLE [ControlFramework].[StagesHistory] (
    [StageId]          INT            NOT NULL,
    [StageName]        VARCHAR (225)  NOT NULL,
    [StageDescription] VARCHAR (4000) NULL,
    [Enabled]          BIT            NOT NULL,
    [AuditCreated]     DATETIME       NOT NULL,
    [AuditCreatedBy]   VARCHAR (125)  NOT NULL,
    [AuditUpdated]     DATETIME       NULL,
    [AuditUpdatedBy]   VARCHAR (125)  NULL
);


GO

