
CREATE FUNCTION [ControlFramework].[GetResourceName](@ResourceValue varchar(1000)) 
RETURNS VARCHAR(1000) WITH SCHEMABINDING 
AS 
BEGIN
	IF @ResourceValue IS NULL 
		RETURN NULL
    -- DEV
	RETURN (SELECT CASE @ResourceValue 
				WHEN 'goa-dmp-dev-rg-envres' THEN 'Metastore Resource Group' 
				WHEN 'goa-goadmp-dev-rg-environment' THEN 'LURP Resource Group'
				WHEN 'goa-goadmp-dev-rg-env-wwxf' THEN 'WWXF Resource Group'
				WHEN 'goa-goadmp-dev-df-env-lurp' THEN 'LURP Data Factory'
				WHEN 'goa-goadmp-dev-env-airdm-df' THEN 'AIRDM Data Factory'
				WHEN 'goa-goadmp-dev-env-wmtt-df' THEN 'WMTT Data Factory'
				WHEN 'goa-goadmp-dev-env-wlic-df' THEN 'WLIC Data Factory'
				WHEN 'goa-goadmp-dev-env-wwxf-df' THEN 'WWXF Data Factory'
				WHEN 'goa-goadmp-dev-env-lurp-sql' THEN 'LURP SQL Database'
				WHEN 'https://goadmpdevenvwwxfst.dfs.core.windows.net/' THEN 'WWXF Storage URL'
				WHEN 'https://goadmp-dev-env-wlic-kv.vault.azure.net/' THEN 'WLIC Storage URL'  
				WHEN 'https://goadmpdevenvlurpst.dfs.core.windows.net' THEN 'LURP Storage URL'  
				WHEN 'https://goadmpdevenvwmttst.dfs.core.windows.net' THEN 'WMTT Storage URL'  				
				WHEN 'https://goadmp-dev-env-lurp-kv.vault.azure.net/' THEN 'LURP Key Vault URL'
				WHEN 'https://goadmp-dev-env-airdm-kv.vault.azure.net/' THEN 'AIRDM Key Vault URL'
				WHEN 'connstr-goa-goadmp-dev-sql-env-lurp' THEN 'LURP Connection Secret'
				WHEN 'connstr-synapse-env-lurp-as' THEN 'LURP Synapse Connection Secret'
				WHEN 'connstr-synapse-env-airdm-as' THEN 'AIRDM Synapse Connection Secret'
				WHEN 'connstr-synapse-env-wlic-as' THEN 'WLIC Synapse Connection Secret'				
				WHEN 'goadmpdevenvwwxfst/raw' THEN 'WWXF Raw Storage'
				WHEN 'goadmpdevenvwwxfst/curated' THEN 'WWXF Curated Storage'				
				WHEN 'goadmpdevenvlurpst' THEN 'LURP Storage'
				WHEN 'goadmpdevenvwlicst' THEN 'WLIC Storage'
				WHEN 'goadmpdevenvwmttst' THEN 'WMTT Storage'
				WHEN 'goadmpdevenvairdmst' THEN 'AIRDM Storage'
				WHEN 'NotebookData("main", 1200, {"domain": "adb-3017902265547742.2.azuredatabricks.net", "env": "devtest3", "job_id": "1087601183789941", "reference_date": "2022-02-25", "zulu": "00Z"})' THEN 'Databricks Script 1'
				WHEN 'NotebookData("main", 1200, {"domain": "adb-3017902265547742.2.azuredatabricks.net", "env": "devtest3", "job_id": "1087601183789941", "reference_date": "2022-02-25", "zulu": "12Z"})' THEN 'Databricks Script 2'
				WHEN 'https://adb-3017902265547742.2.azuredatabricks.net/' THEN 'Databricks URL'
				WHEN '/subscriptions/02990269-f997-44a4-bb12-f617f3a99ad6/resourceGroups/goa-goadmp-dev-rg-env-wwxf/providers/Microsoft.Databricks/workspaces/goa-goadmp-dev-env-wwxf-dbw' THEN 'Databricks Resource ID'
				WHEN '0408-214022-rgpy9jj9' THEN 'Databricks Cluster ID'
				WHEN 'https://prod-03.canadacentral.logic.azure.com:443/workflows/1065d04b753943f29cb1cce8e44f9f31/triggers/manual/paths/invoke?api-version=2016-10-01&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=h36B2r12_Iezb-UXnM-40SpHR0KnieTK784KMRbhweU' THEN 'Databricks Post API'
				WHEN '/DEV-WWXF/ADF-Main' THEN 'Notebook Path'
				WHEN ', "To":"andrew.boudreau@microsoft.com; Svetlana.a.Soldatov@gov.ab.ca", "BCC": "andrew.boudreau@microsoft.com; Svetlana.a.Soldatov@gov.ab.ca; ganesh.valluru@gov.ab.ca","Admin":"andrew.boudreau@microsoft.com","Subject":"DEV - Current Forecasts - ", "Folder": "/curated/devtest3/"}' THEN 'Databricks API Body'
				ELSE @ResourceValue
			END)END

GO

