CREATE TABLE [CONTROL].[DriverGroup] (
    [DriverGroupID]             INT            IDENTITY (1, 1) NOT NULL,
    [DriverGroupName]           NVARCHAR (100) NOT NULL,
    [DriverGroupCode]           VARCHAR (20)   NOT NULL,
    [DriverGroupLocationADL]    NVARCHAR (100) NULL,
    [DriverGroupLocationOther1] NVARCHAR (100) NULL,
    [DriverGroupLocationOther2] NVARCHAR (100) NULL,
    [DriverGroupLocationOther3] NVARCHAR (100) NULL,
    [EnabledFlag]               BIT            NOT NULL
);


GO

