CREATE TABLE [ControlFramework].[RecipientsHistory] (
    [RecipientId]       INT            NOT NULL,
    [Name]              VARCHAR (255)  NULL,
    [EmailAddress]      NVARCHAR (500) NOT NULL,
    [MessagePreference] CHAR (3)       NOT NULL,
    [Enabled]           BIT            NOT NULL,
    [PipelineId]        INT            NULL,
    [AuditCreated]      DATETIME       NOT NULL,
    [AuditCreatedBy]    VARCHAR (125)  NOT NULL,
    [AuditUpdated]      DATETIME       NULL,
    [AuditUpdatedBy]    VARCHAR (125)  NULL
);


GO

