CREATE TABLE [ControlFramework].[PropertiesHistory] (
    [PropertyId]     INT            NOT NULL,
    [PropertyName]   VARCHAR (128)  NOT NULL,
    [PropertyValue]  NVARCHAR (MAX) NOT NULL,
    [Description]    NVARCHAR (MAX) NULL,
    [ValidFrom]      DATETIME       NOT NULL,
    [ValidTo]        DATETIME       NULL,
    [AuditCreated]   DATETIME       NOT NULL,
    [AuditCreatedBy] VARCHAR (125)  NOT NULL,
    [AuditUpdated]   DATETIME       NULL,
    [AuditUpdatedBy] VARCHAR (125)  NULL
);


GO

