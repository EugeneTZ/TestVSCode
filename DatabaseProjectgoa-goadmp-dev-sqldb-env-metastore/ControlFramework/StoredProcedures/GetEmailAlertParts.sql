CREATE PROCEDURE [ControlFramework].[GetEmailAlertParts]
	(
	@PipelineId INT
	)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @ToRecipients NVARCHAR(MAX) = ''
	DECLARE @CcRecipients NVARCHAR(MAX) = ''
	DECLARE @BccRecipients NVARCHAR(MAX) = ''
	DECLARE @EmailImportance VARCHAR(55)
	DECLARE @LogicAppTrigger NVARCHAR(MAX) = ''

	SELECT @LogicAppTrigger = PropertyValue FROM [ControlFramework].[Properties] WHERE PropertyName = 'EmailAlertLogicAppHttpTrigger';
	IF NOT (@LogicAppTrigger <> '')  
		BEGIN
			RAISERROR('There is no property set for EmailAlertLogicAppHttpTrigger in the properties table.',16,1);
		END;
				
	--get to recipients
	SELECT	@ToRecipients += r.[EmailAddress] + ','
	FROM	[ControlFramework].[Recipients] r
	WHERE	r.[Enabled] = 1	AND UPPER(r.[MessagePreference]) = 'TO' AND r.[PipelineId] = @PipelineId;

	IF (@ToRecipients <> '') 
		SET @ToRecipients = LEFT(@ToRecipients,LEN(@ToRecipients)-1);
	ELSE	
		SELECT @ToRecipients = PropertyValue
		  FROM [ControlFramework].[Properties]
		 WHERE PropertyName = 'EmailAlertDefaultFailureEmailAddress'

	--get cc recipients
	SELECT	@CcRecipients += r.[EmailAddress] + ','
	FROM	[ControlFramework].[Recipients] r
	WHERE	r.[Enabled] = 1	AND UPPER(r.[MessagePreference]) = 'CC' AND r.[PipelineId] = @PipelineId;
	
	IF (@CcRecipients <> '') SET @CcRecipients = LEFT(@CcRecipients,LEN(@CcRecipients)-1);

	--get bcc recipients
	SELECT	@BccRecipients += r.[EmailAddress] + ','
	FROM	[ControlFramework].[Recipients] r
	WHERE	r.[Enabled] = 1	AND UPPER(r.[MessagePreference]) = 'BCC' AND r.[PipelineId] = @PipelineId;

	IF (@BccRecipients <> '') SET @BccRecipients = LEFT(@BccRecipients,LEN(@BccRecipients)-1);
	
	--get email template
	SELECT
		--importance
		@EmailImportance = 
			CASE [PipelineStatus] 
				WHEN 'Success' THEN 'Low'
				WHEN 'Failed' THEN 'High'
				ELSE 'Normal'
			END
	FROM
		[ControlFramework].[CurrentExecution]
	WHERE
		[PipelineId] = @PipelineId
	ORDER BY
		[StartDateTime] DESC;

	--return email parts
	SELECT
		@ToRecipients AS emailRecipients,
		@CcRecipients AS emailCcRecipients,
		@BccRecipients AS emailBccRecipients,
		@EmailImportance AS emailImportance,
		@LogicAppTrigger AS logicAppHttpTrigger;
END;

GO

