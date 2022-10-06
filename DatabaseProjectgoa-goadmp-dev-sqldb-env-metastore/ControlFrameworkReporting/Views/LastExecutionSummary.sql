CREATE VIEW [ControlFrameworkReporting].[LastExecutionSummary]
AS

WITH maxLog AS
	(
	SELECT
		MAX([LogId]) AS 'MaxLogId'
	FROM
		[ControlFramework].[ExecutionLog]
	),
	lastExecutionId AS
	(
	SELECT
		[LocalExecutionId]
	FROM
		[ControlFramework].[ExecutionLog] el1
		INNER JOIN maxLog
			ON maxLog.[MaxLogId] = el1.[LogId]
	)
SELECT
	el2.[LocalExecutionId],
	DATEDIFF(MINUTE, MIN(el2.[StartDateTime]), MAX(el2.[EndDateTime])) 'RunDurationMinutes'
FROM 
	[ControlFramework].[ExecutionLog] el2
	INNER JOIN lastExecutionId
		ON el2.[LocalExecutionId] = lastExecutionId.[LocalExecutionId]
GROUP BY
	el2.[LocalExecutionId]

GO

