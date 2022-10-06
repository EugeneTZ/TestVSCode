CREATE TABLE [CONTROL].[DataLaketoDataWarehouse] (
    [DataLaketoDataWarehouseID]             INT           IDENTITY (1, 1) NOT NULL,
    [SourceNameDesignator]                  VARCHAR (50)  NOT NULL,
    [SourceCodeDesignator]                  VARCHAR (50)  NOT NULL,
    [ADWStoredProcedureSchema]              VARCHAR (50)  NOT NULL,
    [ADWStoredProcedureName]                VARCHAR (100) NOT NULL,
    [EnabledFlag]                           BIT           NOT NULL,
    [IncrementalLoadFlag]                   BIT           NOT NULL,
    [IncrementalReferenceFieldName]         VARCHAR (100) NOT NULL,
    [NextRunIncrementalReferenceFieldValue] VARCHAR (50)  NOT NULL,
    [LastRunIncrementalReferenceFieldValue] VARCHAR (50)  NOT NULL,
    [IncrementalReferenceFieldComparison]   VARCHAR (50)  NOT NULL,
    [LastRunDatetime]                       DATETIME      NOT NULL,
    [LastRunStatusCode]                     SMALLINT      NOT NULL
);


GO

