CREATE TABLE [dbo].[TalendJobProcessor] (
    [TalendJobProcessorKey]  INT           IDENTITY (1, 1) NOT NULL,
    [ProjectName]            VARCHAR (50)  NOT NULL,
    [ProcessName]            VARCHAR (100) NOT NULL,
    [Pid]                    VARCHAR (50)  NOT NULL,
    [ParentPid]              VARCHAR (50)  NULL,
    [FatherPid]              VARCHAR (50)  NULL,
    [JobVersion]             VARCHAR (15)  NULL,
    [ExecutionMachine]       VARCHAR (125) NOT NULL,
    [ExecutionUserId]        VARCHAR (50)  NOT NULL,
    [Environment]            VARCHAR (25)  NULL,
    [LoadType]               VARCHAR (125) NULL,
    [Status]                 VARCHAR (25)  NULL,
    [ExecutionStartTime]     DATETIME      NULL,
    [ExecutionEndTime]       DATETIME      NULL,
    [Creator]                VARCHAR (255) NOT NULL,
    [SourceSystem]           VARCHAR (125) NOT NULL,
    [SourceTable]            VARCHAR (125) NOT NULL,
    [TargetSystem]           VARCHAR (125) NOT NULL,
    [TargetTable]            VARCHAR (125) NULL,
    [DataSetName]            VARCHAR (255) NOT NULL,
    [Frequency]              VARCHAR (50)  NOT NULL,
    [SecurityClassification] VARCHAR (50)  NOT NULL,
    [RecordCount]            INT           NOT NULL,
    [ProcessorMessage]       VARCHAR (MAX) NULL,
    [AuditCreated]           DATETIME      NOT NULL,
    [AuditUpdated]           DATETIME      NOT NULL,
    CONSTRAINT [PK_TalendJobProcessor] PRIMARY KEY CLUSTERED ([TalendJobProcessorKey] ASC)
);


GO

