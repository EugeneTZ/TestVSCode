
CREATE PROCEDURE [dbo].[SetSynapseMapping]
	(
	@JsonBody VARCHAR(MAX),
	@JsonRoot VARCHAR(MAX) = NULL,
	@KeyFields VARCHAR(1000) = NULL
	)
AS
BEGIN
	WITH CTE AS 
	(
		SELECT [key] AS [key], 'Y' IsKeyField, [type]
		FROM OPENJSON(@JsonBody, '$')
		WHERE CHARINDEX('/' + [Key] + '/', @KeyFields) > 0
	),
	CTE2 AS 
	(
		SELECT [key] AS [key], CASE WHEN CHARINDEX('/' + [Key] + '/', @KeyFields) > 0 THEN 'Y' ELSE 'N' END AS IsKeyField, [type]
		FROM OPENJSON(@JsonBody ,CASE WHEN @JsonRoot IS NOT NULL THEN CONCAT('$.',REPLACE(REPLACE(@JsonRoot,'{','['),'}',']')) ELSE '$' END)
	),	
	CTE3 AS
	(
		SELECT a.[key] + '.' + b.[key] AS [key], 'N' AS IsKeyField, a.[type]
		  FROM CTE2 AS a
		OUTER APPLY openjson(@JsonBody,'$."' + [key] + '"') AS b
		WHERE a.type = 5
		AND @KeyFields IS NULL
	)
	SELECT	STRING_AGG(CONCAT('[',
			CASE
				WHEN ISNUMERIC([key]) > 0 AND CHARINDEX('.',@JsonRoot) > 0
					THEN CONCAT(RIGHT(@JsonRoot,CHARINDEX('.',REVERSE(@JsonRoot))-1),'[',[key],']]')
				WHEN ISNUMERIC([key]) > 0 
					THEN CONCAT(@JsonRoot,'[',[key],']]')
				ELSE
					REPLACE([key],'.','_')
				END,
			'] varchar(max)'),
			', ') 
			+ ', [AuditCreated] varchar(max)' 
			+ ', [AuditCreatedBy] varchar(max)'  
			+ ', [AuditUpdated] varchar(max)'   
			+ ', [AuditUpdatedBy] varchar(max)'
			+ ', [AuditSystem] varchar(max)' 
			+ ', [SourceSystem] varchar(max)' 
			+ ', [AuditProcessId] varchar(max)'  AS Mapping
	FROM (SELECT * FROM CTE UNION SELECT * FROM CTE2 UNION ALL SELECT * FROM CTE3) AS d;

END;

GO

