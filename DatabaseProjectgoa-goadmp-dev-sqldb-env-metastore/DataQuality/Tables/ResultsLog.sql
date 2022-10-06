CREATE TABLE [DataQuality].[ResultsLog] (
    [ScreenLogId]          INT            IDENTITY (1, 1) NOT NULL,
    [TableListID]          INT            NULL,
    [RuleId]               INT            NULL,
    [Fields]               VARCHAR (500)  NULL,
    [ReturnMessage]        VARCHAR (1000) NULL,
    [InsertedDate]         DATETIME       DEFAULT (getdate()) NULL,
    [ReservationUpdatedOn] DATETIME       DEFAULT (getdate()) NULL,
    [FieldValue]           VARCHAR (120)  NULL,
    PRIMARY KEY CLUSTERED ([ScreenLogId] ASC)
);


GO

