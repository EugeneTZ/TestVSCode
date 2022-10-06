CREATE view [DataQuality].v_GetMetadataDataQuality
as
select t.SchemaName
	 , t.TableName
	 , t.TableListId
	 , t.KeyField
	 , SourceConnectionSecret
	 , SourceConnectionURL
	 , r.RuleId
	 , r.RuleCode
	 , r.ReturnMessage
	 , r.FieldsToCheck
	 , GETDATE() as InsertedDate
	 , GETDATE() as UpdatedOn
  From [DataQuality].[TablesList] t
 inner join [DataQuality].[Rules] r
    on r.TableListID = t.TableListID

GO

