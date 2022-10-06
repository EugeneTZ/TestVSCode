CREATE TABLE [DataQuality].[TablesList] (
    [TableListID]            INT            IDENTITY (1, 1) NOT NULL,
    [ServerName]             VARCHAR (120)  NULL,
    [SchemaName]             VARCHAR (18)   NULL,
    [TableName]              VARCHAR (200)  NULL,
    [KeyField]               VARCHAR (100)  NULL,
    [RuleID]                 INT            NULL,
    [ProjectName]            VARCHAR (32)   NULL,
    [SourceConnectionSecret] VARCHAR (250)  NULL,
    [SourceConnectionURL]    NVARCHAR (500) NULL,
    PRIMARY KEY CLUSTERED ([TableListID] ASC)
);


GO

