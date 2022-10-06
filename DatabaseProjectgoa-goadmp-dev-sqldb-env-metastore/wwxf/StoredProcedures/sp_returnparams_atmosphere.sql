

-- =============================================
-- Author:      <Author, , Name>
-- Create Date: <Create Date, , >
-- Description: <Description, , >
-- =============================================
CREATE PROCEDURE [wwxf].[sp_returnparams_atmosphere]
(
    -- Add the parameters for the stored procedure here
    @Param1 as nvarchar(3), @Param2 as Datetime, @Param3 as nvarchar(200)
)
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON
DECLARE @runDate DateTime;
DECLARE @runtype nvarchar(3);
DECLARE @baseURL nvarchar(200);
Set @runType = @Param1;
Set @RunDate = @Param2;
Set @baseURL = @Param3;
DECLARE @CursorTestID INT = 1;
DECLARE @RunningTotal BIGINT = 0;
DECLARE @rdpsCnt BIGINT = 0;
DECLARE @day1Cnt BIGINT = 12;
DECLARE @day2Cnt BIGINT = 24;
DECLARE @day3Cnt BIGINT = 24;
DECLARE @day4Cnt BIGINT = 13;
DECLARE @curDate Datetime = Format(@runDate, 'yyyy-MM-ddT00:00:00Z');
DECLARE @refDate Datetime = Format(@runDate, 'yyyy-MM-ddT00:00:00Z');
DECLARE @subx as nvarchar(50);
DECLARE @suby as nvarchar(50);
DEClare @format as nvarchar(50);
If @runtype = '00Z'
Begin
	SET @rdpsCnt = 0;
	SET @day1Cnt = 24;
	SET @day2Cnt = 24;
	SET @day3Cnt = 24;
END
Else
BEGIN
	SET @rdpsCnt = 0;
	SET @day1Cnt = 12;
	SET @day2Cnt = 24;
	SET @day3Cnt = 24;
	SET @day4Cnt = 13;
	SET @curDate = Format(@runDate, 'yyyy-MM-ddT00:00:00Z');
	SET @refDate = Format(@runDate, 'yyyy-MM-ddT00:00:00Z');
	SET @curDate = DATEADD(hour, 12,@curDate)
	SET @refDate = DATEADD(hour, 12,@refDate)
END

DECLARE @rhour INT = 0;
CREATE TABLE #tmpparams (
    rdps nvarchar(50),
    run nvarchar(3),
	hour nvarchar(2),
	dim_reference_time datetime,
	time datetime,
	subsetx nvarchar(50),
	subsety nvarchar(50),
	format nvarchar(50),
	url nvarchar(max),
	folder nvarchar(200)

);
DECLARE @rdps as nvarchar(50);
DECLARE load_cursor CURSOR FOR 
    SELECT ParamValue, Param1 as subsex, Param2 as subsety, Param3 as format
    FROM wwxf.Params where ParamName = 'rdps' 
 
OPEN load_cursor 
FETCH NEXT FROM load_cursor  INTO @rdps, @subx, @suby, @format 
 
WHILE @@FETCH_STATUS = 0 
BEGIN 
	IF @runtype = '00Z'
	BEGIN
		WHILE @CursorTestID <= @day1Cnt

			BEGIN
				INSERT INTO #tmpparams (rdps, run, hour, dim_reference_time, time, subsetx, subsety, format, url, folder)
				VALUES (@rdps, @runtype, RIGHT('0' + CAST(@rhour AS VARCHAR(2)), 2), @refDate, @curDate, @subx, @suby, @format, CONCAT(@baseURL,@rdps,'&dim_reference_time=',Format(@refDate, 'yyyy-MM-ddTHH:mm:00Z'), '&time=',Format(@curDate, 'yyyy-MM-ddTHH:mm:00Z'),'&subset=x(', @subx,')&subset=y(', @suby,')&format=',@format ),CONCAT(@rdps, '/',@runtype,'/',Format(@refDate, 'yyyy'), '/', Format(@refDate, 'MM'),'/',Format(@refDate, 'dd'),'/',CONCAT(@rdps,Format(@curDate, 'yyyyMMdd'),RIGHT('0' + CAST(@rhour AS VARCHAR(2)), 2)),'.tiff'))
				SET @rhour = @rhour + 1
				SET @CursorTestID = @CursorTestID + 1
				SET @curDate = DATEADD(hour,1,@curDate)
			END
		SET @rhour = 0
		SET @CursorTestID = 1
		SET @curDate  = Format(DATEADD(day,1,@runDate), 'yyyy-MM-ddT00:00:00Z');
		WHILE @CursorTestID <= @day1Cnt

			BEGIN
				INSERT INTO #tmpparams (rdps, run, hour, dim_reference_time, time, subsetx, subsety, format, url, folder)
				VALUES (@rdps, @runtype, RIGHT('0' + CAST(@rhour AS VARCHAR(2)), 2), @refDate,@curDate, @subx, @suby, @format, CONCAT(@baseURL,@rdps,'&dim_reference_time=',Format(@refDate, 'yyyy-MM-ddTHH:mm:00Z'), '&time=',Format(@curDate, 'yyyy-MM-ddTHH:mm:00Z'),'&subset=x(', @subx,')&subset=y(', @suby,')&format=',@format ),CONCAT(@rdps, '/',@runtype,'/',Format(@refDate, 'yyyy'), '/', Format(@refDate, 'MM'),'/',Format(@refDate, 'dd'),'/',CONCAT(@rdps,Format(@curDate, 'yyyyMMdd'),RIGHT('0' + CAST(@rhour AS VARCHAR(2)), 2)),'.tiff'))
				SET @rhour = @rhour + 1
				SET @CursorTestID = @CursorTestID + 1
				SET @curDate = DATEADD(hour,1,@curDate)
			END
		SET @rhour = 0
		SET @CursorTestID = 1
		SET @curDate  = Format(DATEADD(day,2,@runDate), 'yyyy-MM-ddT00:00:00Z');
		WHILE @CursorTestID <= @day3Cnt

			BEGIN
				INSERT INTO #tmpparams (rdps, run, hour, dim_reference_time, time, subsetx, subsety, format,url,folder)
				VALUES (@rdps, @runtype, RIGHT('0' + CAST(@rhour AS VARCHAR(2)), 2), @refDate,@curDate, @subx, @suby, @format, CONCAT(@baseURL,@rdps,'&dim_reference_time=',Format(@refDate, 'yyyy-MM-ddTHH:mm:00Z'), '&time=',Format(@curDate, 'yyyy-MM-ddTHH:mm:00Z'),'&subset=x(', @subx,')&subset=y(', @suby,')&format=',@format ),CONCAT(@rdps, '/',@runtype,'/',Format(@refDate, 'yyyy'), '/', Format(@refDate, 'MM'),'/',Format(@refDate, 'dd'),'/',CONCAT(@rdps,Format(@curDate, 'yyyyMMdd'),RIGHT('0' + CAST(@rhour AS VARCHAR(2)), 2)),'.tiff'))
				SET @rhour = @rhour + 1
				SET @CursorTestID = @CursorTestID + 1
				SET @curDate = DATEADD(hour,1,@curDate)
			END
		SET @rhour = 0
		SET @CursorTestID = 1
		SET @curDate  = Format(DATEADD(day,3,GETDATE()) AT TIME ZONE 'UTC' AT TIME ZONE 'Pacific Standard Time', 'yyyy-MM-ddT00:00:00Z');
		INSERT INTO #tmpparams (rdps, run, hour, dim_reference_time, time, subsetx, subsety, format, url, folder)
		VALUES (@rdps, @runtype, RIGHT('0' + CAST(@rhour AS VARCHAR(2)), 2), @refDate,@curDate, @subx, @suby, @format, CONCAT(@baseURL,@rdps,'&dim_reference_time=',Format(@refDate, 'yyyy-MM-ddTHH:mm:00Z'), '&time=',Format(@curDate, 'yyyy-MM-ddTHH:mm:00Z'),'&subset=x(', @subx,')&subset=y(', @suby,')&format=',@format ),CONCAT(@rdps, '/',@runtype,'/',Format(@refDate, 'yyyy'), '/', Format(@refDate, 'MM'),'/',Format(@refDate, 'dd'),'/',CONCAT(@rdps,Format(@curDate, 'yyyyMMdd'),RIGHT('0' + CAST(@rhour AS VARCHAR(2)), 2)),'.tiff'))
		SET @curDate  = Format(@runDate, 'yyyy-MM-ddT00:00:00Z');
	END
	ELSE
	BEGIN
		SET @rhour = 12
		WHILE @CursorTestID <= @day1Cnt

			BEGIN
				INSERT INTO #tmpparams (rdps, run, hour, dim_reference_time, time, subsetx, subsety, format,url,folder)
				VALUES (@rdps, @runtype, RIGHT('0' + CAST(@rhour AS VARCHAR(2)), 2), @refDate,@curDate, @subx, @suby, @format, CONCAT(@baseURL,@rdps,'&dim_reference_time=',Format(@refDate, 'yyyy-MM-ddTHH:mm:00Z'), '&time=',Format(@curDate, 'yyyy-MM-ddTHH:mm:00Z'),'&subset=x(', @subx,')&subset=y(', @suby,')&format=',@format ),CONCAT(@rdps, '/',@runtype,'/',Format(@refDate, 'yyyy'), '/', Format(@refDate, 'MM'),'/',Format(@refDate, 'dd'),'/',CONCAT(@rdps,Format(@curDate, 'yyyyMMdd'),RIGHT('0' + CAST(@rhour AS VARCHAR(2)), 2)),'.tiff'))
				SET @rhour = @rhour + 1
				SET @CursorTestID = @CursorTestID + 1
				SET @curDate = DATEADD(hour,1,@curDate)
			END
		SET @rhour = 0
		SET @CursorTestID = 1
		SET @curDate  = Format(DATEADD(day,1,@runDate), 'yyyy-MM-ddT00:00:00Z');
		WHILE @CursorTestID <= @day2Cnt

			BEGIN
				INSERT INTO #tmpparams (rdps, run, hour, dim_reference_time, time, subsetx, subsety, format,url,folder)
				VALUES (@rdps, @runtype, RIGHT('0' + CAST(@rhour AS VARCHAR(2)), 2), @refDate,@curDate, @subx, @suby, @format, CONCAT(@baseURL,@rdps,'&dim_reference_time=',Format(@refDate, 'yyyy-MM-ddTHH:mm:00Z'), '&time=',Format(@curDate, 'yyyy-MM-ddTHH:mm:00Z'),'&subset=x(', @subx,')&subset=y(', @suby,')&format=',@format ),CONCAT(@rdps, '/',@runtype,'/',Format(@refDate, 'yyyy'), '/', Format(@refDate, 'MM'),'/',Format(@refDate, 'dd'),'/',CONCAT(@rdps,Format(@curDate, 'yyyyMMdd'),RIGHT('0' + CAST(@rhour AS VARCHAR(2)), 2)),'.tiff'))
				SET @rhour = @rhour + 1
				SET @CursorTestID = @CursorTestID + 1
				SET @curDate = DATEADD(hour,1,@curDate)
			END
		SET @rhour = 0
		SET @CursorTestID = 1
		SET @curDate  = Format(DATEADD(day,2,@runDate), 'yyyy-MM-ddT00:00:00Z');

		WHILE @CursorTestID <= @day3Cnt
			BEGIN
				INSERT INTO #tmpparams (rdps, run, hour, dim_reference_time, time, subsetx, subsety, format,url,folder)
				VALUES (@rdps, @runtype, RIGHT('0' + CAST(@rhour AS VARCHAR(2)), 2), @refDate,@curDate, @subx, @suby, @format, CONCAT(@baseURL,@rdps,'&dim_reference_time=',Format(@refDate, 'yyyy-MM-ddTHH:mm:00Z'), '&time=',Format(@curDate, 'yyyy-MM-ddTHH:mm:00Z'),'&subset=x(', @subx,')&subset=y(', @suby,')&format=',@format ),CONCAT(@rdps, '/',@runtype,'/',Format(@refDate, 'yyyy'), '/', Format(@refDate, 'MM'),'/',Format(@refDate, 'dd'),'/',CONCAT(@rdps,Format(@curDate, 'yyyyMMdd'),RIGHT('0' + CAST(@rhour AS VARCHAR(2)), 2)),'.tiff'))
				SET @rhour = @rhour + 1
				SET @CursorTestID = @CursorTestID + 1
				SET @curDate = DATEADD(hour,1,@curDate)
			END
		SET @curDate  = Format(DATEADD(day,3,@runDate), 'yyyy-MM-ddT00:00:00Z');
		SET @rhour = 0
		SET @CursorTestID = 1
		SET @curDate  = Format(DATEADD(day,3,@runDate), 'yyyy-MM-ddT00:00:00Z');
		WHILE @CursorTestID <= @day4Cnt

			BEGIN
				INSERT INTO #tmpparams (rdps, run, hour, dim_reference_time, time, subsetx, subsety, format,url, folder)
				VALUES (@rdps, @runtype, RIGHT('0' + CAST(@rhour AS VARCHAR(2)), 2), @refDate,@curDate, @subx, @suby, @format, CONCAT(@baseURL,@rdps,'&dim_reference_time=',Format(@refDate, 'yyyy-MM-ddTHH:mm:00Z'), '&time=',Format(@curDate, 'yyyy-MM-ddTHH:mm:00Z'),'&subset=x(', @subx,')&subset=y(', @suby,')&format=',@format ),CONCAT(@rdps, '/',@runtype,'/',Format(@refDate, 'yyyy'), '/', Format(@refDate, 'MM'),'/',Format(@refDate, 'dd'),'/',CONCAT(@rdps,Format(@curDate, 'yyyyMMdd'),RIGHT('0' + CAST(@rhour AS VARCHAR(2)), 2)),'.tiff'))
				SET @rhour = @rhour + 1
				SET @CursorTestID = @CursorTestID + 1
				SET @curDate = DATEADD(hour,1,@curDate)
			END
		SET @rhour = 0
		SET @CursorTestID = 1
		SET @curDate = Format(@runDate, 'yyyy-MM-ddT00:00:00Z');
		SET @curDate = DATEADD(hour, 12,@curDate)
	END
FETCH NEXT FROM load_cursor INTO @rdps, @subx, @suby, @format
END
CLOSE load_cursor 
DEALLOCATE load_cursor 
Select rdps, run, hour, Format(dim_reference_time, 'yyyy-MM-ddTHH:mm:00Z') as dim_reference_time, Format(time, 'yyyy-MM-ddTHH:mm:00Z') as time, subsetx, subsety, format, url, folder From #tmpparams 
RETURN ;
END

GO

