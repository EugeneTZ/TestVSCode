CREATE TABLE [CONTROL].[ADLSGen2ToDeltaLake] (
    [ADLSToDeltaLakeID] INT            IDENTITY (1, 1) NOT NULL,
    [ADLSFileName]      NVARCHAR (100) NOT NULL,
    [ADLSFileType]      NVARCHAR (100) NOT NULL,
    [ADLSfilePath]      NVARCHAR (100) NOT NULL,
    [DeltaLakeFileName] NVARCHAR (100) NOT NULL,
    [DeltaLakeFileType] NVARCHAR (100) NOT NULL,
    [DeltaLakeFilePath] NVARCHAR (100) NOT NULL,
    [EnabledFlag]       BIT            NOT NULL,
    [LastRunDate]       DATETIME       NOT NULL,
    [LastRunStatus]     SMALLINT       NOT NULL
);


GO

