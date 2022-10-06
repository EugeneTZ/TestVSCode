


CREATE PROCEDURE [dbo].[SetJsonMapping]
	(
	@JsonBody VARCHAR(MAX),
	@JsonRoot VARCHAR(MAX) = NULL,
	@KeyFields VARCHAR(1000) = NULL
	)
AS
BEGIN
	-- make sure there is data to map
	IF NOT EXISTS (SELECT * FROM OPENJSON(@JsonBody ,CASE WHEN @JsonRoot IS NOT NULL THEN CONCAT('$.',REPLACE(REPLACE(@JsonRoot,'{','['),'}',']')) ELSE '$' END))
	BEGIN
		SELECT '' AS Mapping
		RETURN
	END;

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
	SELECT CONCAT(
				'{ "type": "TabularTranslator", "mappings": [ ',
				STRING_AGG(CONCAT('{ "source": { "path": "',
					CASE
						WHEN IsKeyField = 'Y' 
						    THEN CONCAT('$[''',[key],''']')
						WHEN @JsonRoot IS NOT NULL AND RIGHT(@JsonRoot,3) = '[0]'
							THEN CONCAT('[''',[key],''']')
						WHEN @JsonRoot IS NOT NULL AND RIGHT(@JsonRoot,1) = ']' AND ISNUMERIC(SUBSTRING(RIGHT(@JsonRoot,CHARINDEX('[',REVERSE(@JsonRoot))-1),1,LEN(RIGHT(@JsonRoot,CHARINDEX('[',REVERSE(@JsonRoot))-1))-1)) > 0 AND ISNUMERIC([key]) > 0 --'@JsonRoot a.b.c.d[0] key [0]'
							THEN CONCAT('$[''',REPLACE(REPLACE(REPLACE(REPLACE(@JsonRoot,'[',''']['),'].','])'),'.',''']['''),')','['''),'[',[key],']')
						WHEN @JsonRoot IS NOT NULL AND RIGHT(@JsonRoot,1) = ']' AND ISNUMERIC(SUBSTRING(RIGHT(@JsonRoot,CHARINDEX('[',REVERSE(@JsonRoot))-1),1,LEN(RIGHT(@JsonRoot,CHARINDEX('[',REVERSE(@JsonRoot))-1))-1)) > 0  --'@JsonRoot a.b.c.d[0] key ['e']'
							THEN  CONCAT('$[''',REPLACE(REPLACE(REPLACE(REPLACE(@JsonRoot,'[',''']['),'].','])'),'.',''']['''),')','['''),'[''',[key],''']')
						WHEN @JsonRoot IS NOT NULL AND ISNUMERIC([key]) > 0 --'@JsonRoot a.b.c.d key [0]'
							THEN CONCAT('$[''',REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@JsonRoot+'*','[',''']['),'].','])'),'.',''']['''),')','['''),'*',''']'),'[',[key],']')
						WHEN @JsonRoot IS NOT NULL  -- '@JsonRoot a.b.c.d key ['e']'
							THEN CONCAT('$[''',REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@JsonRoot+'*','[',''']['),'].','])'),'.',''']['''),')','['''),'*',''']'),'[''',[key],''']')
						ELSE
							CONCAT('$[''',REPLACE([key], '.','''].['''),''']')
						END,
					'" }, "sink": { "name": "',
					CASE
						WHEN ISNUMERIC([key]) > 0 AND CHARINDEX('.',@JsonRoot) > 0
							THEN CONCAT(RIGHT(@JsonRoot,CHARINDEX('.',REVERSE(@JsonRoot))-1),'[',[key],']')
						WHEN ISNUMERIC([key]) > 0 
							THEN CONCAT(@JsonRoot,'[',[key],']')
						ELSE
							replace([key], '.','_')
						END,
					'", "type": "String" } }'), ',')
					,', { "source": { "path": "$[''AuditCreated'']" }, "sink": { "name": "AuditCreated", "type": "String" } } '
					,', { "source": { "path": "$[''AuditCreatedBy'']" }, "sink": { "name": "AuditCreatedBy", "type": "String" } } '
					,', { "source": { "path": "$[''AuditUpdated'']" }, "sink": { "name": "AuditUpdated", "type": "String" } } '
					,', { "source": { "path": "$[''AuditUpdatedBy'']" }, "sink": { "name": "AuditUpdatedBy", "type": "String" } } '
					,', { "source": { "path": "$[''AuditSystem'']" }, "sink": { "name": "AuditSystem", "type": "String" } } '
					,', { "source": { "path": "$[''SourceSystem'']" }, "sink": { "name": "SourceSystem", "type": "String" } } '
					,', { "source": { "path": "$[''AuditProcessId'']" }, "sink": { "name": "AuditProcessId", "type": "String" } } '
					,' ], "mapComplexValuesToString": true'+ CASE WHEN @JsonRoot IS NOT NULL AND RIGHT(@JsonRoot,3) = '[0]' THEN ', "collectionReference": "$['''+ LEFT(@JsonRoot, CHARINDEX('[0]', @JsonRoot) - 1) + ''']"' ELSE '' END +'}') AS Mapping
	FROM (SELECT * FROM CTE UNION SELECT * FROM CTE2 UNION ALL SELECT * FROM CTE3) AS d;

	RETURN;
END;

GO

