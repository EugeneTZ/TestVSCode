CREATE FUNCTION [ControlFramework].[GetOrchestratorId] ()
RETURNS INT
AS
BEGIN
	DECLARE @orchestratorId int
	SELECT @orchestratorId = [OrchestratorID] FROM [ControlFramework].[Orchestrators]
		WHERE [IsFrameworkOrchestrator] = 1
	RETURN @orchestratorId
END

GO

