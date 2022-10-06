CREATE PROCEDURE [dbo].[ExampleCustomExecutionPrecursor]
	(
	@BatchName VARCHAR(255) = NULL
	)
AS
BEGIN
	--IF ((SELECT @BatchName) IS NULL)
	--	BEGIN
	--	SELECT 1;
	--	END;
	--ELSE
	--	BEGIN
	--		IF ((SELECT @BatchName) = 'WWXF-00Z')
	--			BEGIN
	--				UPDATE [ControlFramework].[Parameters]
	--				SET [ExcludeInGeneral] = 1
	--				WHERE [ConfigId] = 212;
				
	--				UPDATE [ControlFramework].[Parameters]
	--				SET [ExcludeInGeneral] = 0
	--				WHERE [ConfigId] = 209;
				
	--				SELECT 1;
	--			END;
	--		ELSE IF ((SELECT @BatchName) = 'WWXF-12Z')
	--			BEGIN
	--				UPDATE [ControlFramework].[Parameters]
	--				SET [ExcludeInGeneral] = 1
	--				WHERE [ConfigId] = 209;
				
	--				UPDATE [ControlFramework].[Parameters]
	--				SET [ExcludeInGeneral] = 0
	--				WHERE [ConfigId] = 212;

	--				SELECT 1;
	--			END;	
	--	END
	SELECT 1
	--disable certain Workers if running at the weekend...
	-- YOUR CODE HERE

	--enable certain Workers if running on the 10th day of the month...
	-- YOUR CODE HERE

	--disable certain Stages if running on Friday...
	-- YOUR CODE HERE

	--set Worker pipeline parameters to new value based on ______ ....
	-- YOUR CODE HERE
	
	--etc

END;

GO

