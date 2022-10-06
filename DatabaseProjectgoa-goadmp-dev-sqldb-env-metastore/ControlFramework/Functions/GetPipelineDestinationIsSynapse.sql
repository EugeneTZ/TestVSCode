
CREATE FUNCTION [ControlFramework].[GetPipelineDestinationIsSynapse](@pipelineId int)
RETURNS BIT
AS
BEGIN
    DECLARE @IsSynapse bit
    SELECT @IsSynapse = [DestinationIsSynapse] FROM [ControlFramework].[Pipelines]
		WHERE PipelineId = @pipelineId
    RETURN @IsSynapse
END

GO

