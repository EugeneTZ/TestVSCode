CREATE TABLE [wwxf].[Params] (
    [ParamPK]    INT            IDENTITY (1, 1) NOT NULL,
    [ParamName]  NVARCHAR (50)  NULL,
    [ParamValue] NVARCHAR (150) NULL,
    [Param1]     NVARCHAR (50)  NULL,
    [Param2]     NVARCHAR (50)  NULL,
    [Param3]     NVARCHAR (50)  NULL,
    CONSTRAINT [PK_Params] PRIMARY KEY CLUSTERED ([ParamPK] ASC)
);


GO

