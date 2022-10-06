-- table Batches
CREATE TABLE [ControlFramework].[Batches] (
    [BatchId]          UNIQUEIDENTIFIER CONSTRAINT [DF_Batches_BatchId] DEFAULT (newid()) NOT NULL,
    [BatchName]        VARCHAR (255)    NOT NULL,
    [BatchDescription] VARCHAR (4000)   NULL,
    [Enabled]          BIT              CONSTRAINT [DF_Batches_Enabled] DEFAULT ((0)) NOT NULL,
    [AuditCreated]     DATETIME         CONSTRAINT [DF_Batches_AuditCreated] DEFAULT (getdate()) NULL,
    [AuditCreatedBy]   VARCHAR (125)    CONSTRAINT [DF_Batches_AuditCreatedBy] DEFAULT (suser_sname()) NOT NULL,
    [AuditUpdated]     DATETIME         NULL,
    [AuditUpdatedBy]   VARCHAR (125)    NULL
);


GO


CREATE TRIGGER [ControlFramework].[DeleteBatches]
	ON [ControlFramework].[Batches]
	AFTER DELETE
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO [ControlFramework].[BatchesHistory]  (
		[BatchId],
		[BatchName],
		[BatchDescription],
		[Enabled],
		[AuditCreated],
		[AuditCreatedBy],
		[AuditUpdated],
		[AuditUpdatedBy]
	)
	SELECT 
		[BatchId],
		[BatchName],
		[BatchDescription],
		[Enabled],
		[AuditCreated],
		[AuditCreatedBy],
		GETDATE(),
		SYSTEM_USER
	FROM deleted;

	SET NOCOUNT OFF;
END

GO


CREATE TRIGGER [ControlFramework].[UpdateBatches]
	ON [ControlFramework].[Batches]
	AFTER UPDATE
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE [ControlFramework].[Batches]
	SET [AuditUpdated] = GETDATE(), [AuditUpdatedBy] = SYSTEM_USER
	WHERE BatchId IN (SELECT DISTINCT BatchId FROM inserted);

	INSERT INTO [ControlFramework].[BatchesHistory]  (
		[BatchId],
		[BatchName],
		[BatchDescription],
		[Enabled],
		[AuditCreated],
		[AuditCreatedBy],
		[AuditUpdated],
		[AuditUpdatedBy]
	)
	SELECT 
		[BatchId],
		[BatchName],
		[BatchDescription],
		[Enabled],
		[AuditCreated],
		[AuditCreatedBy],
		GETDATE(),
		SYSTEM_USER
	FROM deleted;

	SET NOCOUNT OFF;
END;

GO

