CREATE PROCEDURE [ControlFramework].[GetFrameworkOrchestratorDetails]
	(
	@CallingOrchestratorName NVARCHAR(200)
	)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @FrameworkOrchestrator NVARCHAR(200)

	--defensive check
	SELECT
		@FrameworkOrchestrator = UPPER([OrchestratorName]),
		@CallingOrchestratorName = UPPER(@CallingOrchestratorName)
	FROM
		[ControlFramework].[Orchestrators]
	WHERE
		[IsFrameworkOrchestrator] = 1;

	IF(@FrameworkOrchestrator <> @CallingOrchestratorName)
	BEGIN
		RAISERROR('Orchestrator mismatch. Calling orchestrator does not match expected IsFrameworkOrchestrator name.',16,1);
		RETURN 0;
	END

	--orchestrator detials
	SELECT
		[TenantId],
		[SubscriptionId],
		[OrchestratorResourceGroupName],
		[OrchestratorName],
		[OrchestratorType]
	FROM
		[ControlFramework].[Orchestrators]
	WHERE
		[IsFrameworkOrchestrator] = 1;
END;

GO

