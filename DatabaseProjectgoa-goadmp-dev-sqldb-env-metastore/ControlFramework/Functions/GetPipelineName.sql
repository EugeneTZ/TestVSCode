CREATE FUNCTION ControlFramework.GetPipelineName(@pipelineId int)
RETURNS VARCHAR(100)
AS
BEGIN
    DECLARE @name VARCHAR(100)
    SELECT @name = PipelineName FROM [ControlFramework].[Pipelines]
		WHERE PipelineId = @pipelineId
    RETURN @name
END

GO

