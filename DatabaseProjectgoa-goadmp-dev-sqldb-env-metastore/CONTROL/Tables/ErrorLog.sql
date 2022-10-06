CREATE TABLE [CONTROL].[ErrorLog] (
    [ErrorDate]               DATETIME        NOT NULL,
    [ErrorProcedure]          NVARCHAR (100)  NULL,
    [ErrorNumber]             INT             NULL,
    [ErrorSeverity]           INT             NULL,
    [ErrorState]              INT             NULL,
    [ErrorMessage]            NVARCHAR (4000) NULL,
    [ErrorRecordCreationDate] DATETIME        NULL,
    [RecordID]                INT             IDENTITY (1, 1) NOT NULL
);


GO

