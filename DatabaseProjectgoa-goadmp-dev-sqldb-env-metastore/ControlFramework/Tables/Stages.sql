CREATE TABLE [ControlFramework].[Stages] (
    [StageId]          INT            IDENTITY (1, 1) NOT NULL,
    [StageName]        VARCHAR (225)  NOT NULL,
    [StageDescription] VARCHAR (4000) NULL,
    [Enabled]          BIT            CONSTRAINT [DF_Stages_Enabled] DEFAULT ((1)) NOT NULL,
    [AuditCreated]     DATETIME       CONSTRAINT [DF_Stages_AuditCreated] DEFAULT (getdate()) NOT NULL,
    [AuditCreatedBy]   VARCHAR (125)  CONSTRAINT [DF_Stages_AuditCreatedBy] DEFAULT (suser_sname()) NOT NULL,
    [AuditUpdated]     DATETIME       NULL,
    [AuditUpdatedBy]   VARCHAR (125)  NULL,
    CONSTRAINT [PK_Stages] PRIMARY KEY CLUSTERED ([StageId] ASC)
);


GO

CREATE TRIGGER [ControlFramework].[DeleteStages]
	ON [ControlFramework].[Stages]
	AFTER DELETE
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO [ControlFramework].[StagesHistory]  (
		[StageId],
		[StageName],
		[StageDescription],
		[Enabled],
		[AuditCreated],
		[AuditCreatedBy],
		[AuditUpdated],
		[AuditUpdatedBy]
	)
	SELECT 
		[StageId],
		[StageName],
		[StageDescription],
		[Enabled],
		[AuditCreated],
		[AuditCreatedBy],
		GETDATE(),
		SYSTEM_USER
	FROM deleted;

	SET NOCOUNT OFF;
END

GO


CREATE TRIGGER [ControlFramework].[UpdateStages]
	ON [ControlFramework].[Stages]
	AFTER UPDATE
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE [ControlFramework].[Stages]
	SET [AuditUpdated] = GETDATE(), [AuditUpdatedBy] = SYSTEM_USER
	WHERE [StageId] IN (SELECT DISTINCT [StageId] FROM inserted);

	INSERT INTO [ControlFramework].[StagesHistory]  (
		[StageId],
		[StageName],
		[StageDescription],
		[Enabled],
		[AuditCreated],
		[AuditCreatedBy],
		[AuditUpdated],
		[AuditUpdatedBy]
	)
	SELECT 
		[StageId],
		[StageName],
		[StageDescription],
		[Enabled],
		[AuditCreated],
		[AuditCreatedBy],
		GETDATE(),
		SYSTEM_USER
	FROM deleted;

	SET NOCOUNT OFF;
END;

GO

