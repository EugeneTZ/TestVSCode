CREATE TABLE [DataQuality].[Rules] (
    [RuleId]        INT           IDENTITY (1, 1) NOT NULL,
    [RuleName]      VARCHAR (240) NULL,
    [TableListID]   INT           NULL,
    [RuleCode]      VARCHAR (MAX) NULL,
    [ReturnMessage] VARCHAR (500) NULL,
    [FieldsToCheck] VARCHAR (500) NULL,
    PRIMARY KEY CLUSTERED ([RuleId] ASC)
);


GO

