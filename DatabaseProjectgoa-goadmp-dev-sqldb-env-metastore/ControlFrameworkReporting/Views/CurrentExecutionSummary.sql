CREATE VIEW [ControlFrameworkReporting].[CurrentExecutionSummary]
AS

SELECT 
	ISNULL([PipelineStatus], 'Not Started') AS 'PipelineStatus',
	COUNT(0) AS 'RecordCount'
FROM 
	[ControlFramework].[CurrentExecution]
GROUP BY
	[PipelineStatus]

GO

