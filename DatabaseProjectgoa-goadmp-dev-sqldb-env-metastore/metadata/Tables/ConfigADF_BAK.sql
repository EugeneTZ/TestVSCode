CREATE TABLE [metadata].[ConfigADF_BAK] (
    [configID]                      INT            IDENTITY (1, 1) NOT NULL,
    [configType]                    TINYINT        NOT NULL,
    [sourceSchema]                  VARCHAR (100)  NULL,
    [sourceTable]                   VARCHAR (MAX)  NULL,
    [sourceConnectionSecret]        VARCHAR (100)  NULL,
    [destinationContainer]          VARCHAR (100)  NULL,
    [destinationFolder]             VARCHAR (100)  NULL,
    [destinationFileName]           VARCHAR (100)  NULL,
    [destinationURL]                VARCHAR (100)  NULL,
    [destinationConnectionSecret]   VARCHAR (100)  NULL,
    [synapseConnectionSecret]       VARCHAR (100)  NULL,
    [synapseSchema]                 VARCHAR (100)  NULL,
    [synapseTable]                  VARCHAR (100)  NULL,
    [destinationExternalDataSource] VARCHAR (8000) NULL,
    [destinationExternalLocation]   VARCHAR (201)  NULL,
    [synapseScript]                 VARCHAR (8000) NULL,
    [destinationSchema]             VARCHAR (100)  NULL,
    [destinationTable]              VARCHAR (100)  NULL,
    [sourceSQL]                     NVARCHAR (MAX) NULL,
    [DataFactoryName]               VARCHAR (100)  NULL
);


GO

