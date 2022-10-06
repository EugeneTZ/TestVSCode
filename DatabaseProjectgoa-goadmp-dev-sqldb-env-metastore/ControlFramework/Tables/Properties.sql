CREATE TABLE [ControlFramework].[Properties] (
    [PropertyId]     INT            IDENTITY (1, 1) NOT NULL,
    [PropertyName]   VARCHAR (128)  NOT NULL,
    [PropertyValue]  NVARCHAR (MAX) NOT NULL,
    [Description]    NVARCHAR (MAX) NULL,
    [ValidFrom]      DATETIME       CONSTRAINT [DF_Properties_ValidFrom] DEFAULT (getdate()) NOT NULL,
    [ValidTo]        DATETIME       NULL,
    [AuditCreated]   DATETIME       CONSTRAINT [DF_Properties_AuditCreated] DEFAULT (getdate()) NOT NULL,
    [AuditCreatedBy] VARCHAR (125)  CONSTRAINT [DF_Properties_AuditCreatedBy] DEFAULT (suser_sname()) NOT NULL,
    [AuditUpdated]   DATETIME       NULL,
    [AuditUpdatedBy] VARCHAR (125)  NULL,
    CONSTRAINT [PK_Properties] PRIMARY KEY CLUSTERED ([PropertyId] ASC, [PropertyName] ASC)
);


GO

CREATE TRIGGER [ControlFramework].[DeleteProperties]
	ON [ControlFramework].[Properties]
	AFTER DELETE
AS
BEGIN
	SET NOCOUNT ON;

	INSERT [ControlFramework].[PropertiesHistory]  
	(
		[PropertyId],
		[PropertyName],
		[PropertyValue],
		[Description],
		[ValidFrom],
		[ValidTo],
		[AuditCreated],
		[AuditCreatedBy],
		[AuditUpdated],
		[AuditUpdatedBy]
	)
	SELECT 
		[PropertyId],
		[PropertyName],
		[PropertyValue],
		[Description],
		[ValidFrom],
		[ValidTo],
		[AuditCreated],
		[AuditCreatedBy],
		GETDATE(),
		SYSTEM_USER
	FROM deleted;

	SET NOCOUNT OFF;
END

GO


CREATE TRIGGER [ControlFramework].[UpdateProperties]
	ON [ControlFramework].[Properties]
	AFTER UPDATE
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE [ControlFramework].[Properties]
	   SET [AuditUpdated] = GETDATE(), 
	       [AuditUpdatedBy] = SYSTEM_USER
	 WHERE [PropertyId] IN (SELECT DISTINCT [PropertyId] FROM inserted);

	INSERT INTO [ControlFramework].[PropertiesHistory]  
	(
		[PropertyId],
		[PropertyName],
		[PropertyValue],
		[Description],
		[ValidFrom],
		[ValidTo],
		[AuditCreated],
		[AuditCreatedBy],
		[AuditUpdated],
		[AuditUpdatedBy]
	)
	SELECT 
		[PropertyId],
		[PropertyName],
		[PropertyValue],
		[Description],
		[ValidFrom],
		[ValidTo],
		[AuditCreated],
		[AuditCreatedBy],
		GETDATE(),
		SYSTEM_USER
	FROM deleted;

	SET NOCOUNT OFF;
END;

GO

