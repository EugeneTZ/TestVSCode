 CREATE procedure metadata.spConfigADFMetadata
	@configType int
 as
 select top(1)
	    DataFactoryName
	  , JobDescription
	  , ProjectName
	  , JobVersion
	  , LoadType 
	  , Frequency
	  , SecurityClassification 
	  , ExecutionMachine
   from [metadata].[ConfigADF]
  where	configType = @configType

GO

