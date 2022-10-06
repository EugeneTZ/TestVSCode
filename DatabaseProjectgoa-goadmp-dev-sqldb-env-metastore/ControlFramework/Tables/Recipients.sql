CREATE TABLE [ControlFramework].[Recipients] (
    [RecipientId]       INT            IDENTITY (1, 1) NOT NULL,
    [Name]              VARCHAR (255)  NULL,
    [EmailAddress]      NVARCHAR (500) NOT NULL,
    [MessagePreference] CHAR (3)       CONSTRAINT [DF_Recipients_MessagePreference] DEFAULT ('TO') NOT NULL,
    [Enabled]           BIT            CONSTRAINT [DF_Recipients_Enabled] DEFAULT ((1)) NOT NULL,
    [PipelineId]        INT            NULL,
    [AuditCreated]      DATETIME       CONSTRAINT [DF_Recipients_AuditCreated] DEFAULT (getdate()) NOT NULL,
    [AuditCreatedBy]    VARCHAR (125)  CONSTRAINT [DF_Recipients_AuditCreatedBy] DEFAULT (suser_sname()) NOT NULL,
    [AuditUpdated]      DATETIME       NULL,
    [AuditUpdatedBy]    VARCHAR (125)  NULL,
    CONSTRAINT [PK_Recipients] PRIMARY KEY CLUSTERED ([RecipientId] ASC),
    CONSTRAINT [MessagePreferenceValue] CHECK ([MessagePreference]='BCC' OR [MessagePreference]='CC' OR [MessagePreference]='TO')
);


GO


CREATE TRIGGER [ControlFramework].[UpdateRecipients]
	ON [ControlFramework].[Recipients]
	AFTER UPDATE
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE [ControlFramework].[Recipients]
	   SET [AuditUpdated] = GETDATE(), [AuditUpdatedBy] = SYSTEM_USER
	 WHERE [RecipientId] IN (SELECT DISTINCT [RecipientId] FROM inserted);

	INSERT INTO [ControlFramework].[RecipientsHistory]  (
		[RecipientId],
		[Name],
		[EmailAddress],
		[MessagePreference],
		[Enabled],
		[PipelineId],
		[AuditCreated],
		[AuditCreatedBy],
		[AuditUpdated],
		[AuditUpdatedBy]
	)
	SELECT 
		[RecipientId],
		[Name],
		[EmailAddress],
		[MessagePreference],
		[Enabled],
		[PipelineId],
		[AuditCreated],
		[AuditCreatedBy],
		GETDATE(),
		SYSTEM_USER
	FROM deleted;

	SET NOCOUNT OFF;
END;

GO

CREATE TRIGGER [ControlFramework].[DeleteRecipients]
	ON [ControlFramework].[Recipients]
	AFTER DELETE
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO [ControlFramework].[RecipientsHistory]  (
		[RecipientId],
		[Name],
		[EmailAddress],
		[MessagePreference],
		[Enabled],
		[PipelineId],
		[AuditCreated],
		[AuditCreatedBy],
		[AuditUpdated],
		[AuditUpdatedBy]
	)
	SELECT 
		[RecipientId],
		[Name],
		[EmailAddress],
		[MessagePreference],
		[Enabled],
		[PipelineId],
		[AuditCreated],
		[AuditCreatedBy],
		GETDATE(),
		SYSTEM_USER
	FROM deleted;

	SET NOCOUNT OFF;
END

GO

