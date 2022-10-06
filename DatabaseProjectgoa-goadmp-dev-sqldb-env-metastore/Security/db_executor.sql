CREATE ROLE [db_executor]
    AUTHORIZATION [dbo];


GO

ALTER ROLE [db_executor] ADD MEMBER [goa-goadmp-dev-env-lurp-df];


GO

ALTER ROLE [db_executor] ADD MEMBER [Brett.Stengel.Z@gov.ab.ca];


GO

