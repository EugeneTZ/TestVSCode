CREATE TABLE [metadata].[ConfigADF] (
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
    [destinationExternalDataSource] AS             (([destinationContainer]+'_')+replace(replace(replace(Trim([destinationURL]),'http://',''),'https://',''),'.','_')),
    [destinationExternalLocation]   AS             ((Trim([destinationURL])+case when [destinationURL] IS NOT NULL AND right(Trim([destinationURL]),(1))<>'/' then '/' else '' end)+[destinationContainer]),
    [synapseScript]                 AS             (case when [configType]=(6) OR [configType]=(3) OR [configType]=(2) OR [configType]=(1) then (((((((((((((((((((((((((((((((((('IF NOT EXISTS (SELECT * FROM sys.symmetric_keys WHERE name = ''##MS_DatabaseMasterKey##'')
  CREATE MASTER KEY ENCRYPTION BY PASSWORD = ''#M@st3rK3yP@ssw0rd#''

IF NOT EXISTS (SELECT * FROM sys.database_scoped_credentials) 
  CREATE DATABASE SCOPED CREDENTIAL SynapseIdentity WITH IDENTITY = ''Managed Identity'';

IF NOT EXISTS (SELECT * FROM sys.external_file_formats WHERE name = ''SynapseParquetFormat'') 
    CREATE EXTERNAL FILE FORMAT [SynapseParquetFormat] WITH ( FORMAT_TYPE = PARQUET); 

IF NOT EXISTS (SELECT * FROM sys.external_data_sources WHERE name = '''+[destinationContainer])+'_')+replace(replace(replace(Trim([destinationURL]),'http://',''),'https://',''),'.','_'))+''') 
    CREATE EXTERNAL DATA SOURCE [')+[destinationContainer])+'_')+replace(replace(replace(Trim([destinationURL]),'http://',''),'https://',''),'.','_'))+'] 
    WITH (LOCATION   = ''')+Trim([destinationURL]))+case when [destinationURL] IS NOT NULL AND right(Trim([destinationURL]),(1))<>'/' then '/' else '' end)+[destinationContainer])+''',CREDENTIAL = SynapseIdentity );

IF SCHEMA_ID(''')+[synapseSchema])+''') IS NULL 
  EXEC (''CREATE SCHEMA [')+[synapseSchema])+']'')

IF EXISTS (SELECT * FROM sys.external_tables WHERE OBJECT_ID=OBJECT_ID(''[')+[synapseSchema])+'].[')+[synapseTable])+']'')) 
  DROP EXTERNAL TABLE [')+[synapseSchema])+'].[')+[synapseTable])+'];

CREATE EXTERNAL TABLE [')+[synapseSchema])+'].[')+[synapseTable])+'] (
    #COLUMN_DEFINITIONS#
    )
    WITH (LOCATION = ''')+[destinationFolder])+[destinationFileName])+'''
    ,DATA_SOURCE = [')+[destinationContainer])+'_')+replace(replace(replace(Trim([destinationURL]),'http://',''),'https://',''),'.','_'))+']
    ,FILE_FORMAT = [SynapseParquetFormat]
    );
select ADF_Lookup_Result=1;
'  end),
    [destinationSchema]             VARCHAR (100)  NULL,
    [destinationTable]              VARCHAR (100)  NULL,
    [sourceSQL]                     AS             (case when [configType]=(4) OR [configType]=(2) then case when Trim([sourceTable]) like 'SELECT %' then [sourceTable] else (('SELECT * FROM '+quotename([sourceSchema]))+'.')+quotename([sourceTable]) end  end),
    [DataFactoryName]               VARCHAR (100)  NULL,
    [ExcludeInGeneral]              BIT            DEFAULT ((0)) NOT NULL,
    [JobDescription]                VARCHAR (1000) NULL,
    [ProjectName]                   VARCHAR (50)   NULL,
    [JobVersion]                    VARCHAR (15)   NULL,
    [LoadType]                      VARCHAR (125)  NULL,
    [Frequency]                     VARCHAR (50)   NULL,
    [SecurityClassification]        VARCHAR (50)   NULL,
    [ExecutionMachine]              VARCHAR (125)  NULL,
    CONSTRAINT [pk_ConfigADF] PRIMARY KEY CLUSTERED ([configID] ASC)
);


GO

