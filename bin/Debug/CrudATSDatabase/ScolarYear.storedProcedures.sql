CREATE procedure [dbo].[spScolarYearGetByPage]
(
	@name nvarchar (250),
	@countryId int,
	@iSortCol INT=1,
	@sSortDir NVARCHAR(100)='asc',	 
	@pageNumber INT = 1,
	@pageSize INT = 10
)
AS
BEGIN
	SELECT Count(*) Over() AS TotalRows,
	 	s.Name,
		s.CountryId
	FROM   ScolarYear s
	WHERE   (COALESCE(s.Name,'') LIKE '%' + COALESCE(@name, COALESCE(s.Name,'')) + '%')
	AND (s.CountryId=@countryId OR @countryId IS NULL)
	ORDER BY  CASE WHEN @iSortCol = 22 AND @sSortDir='asc' THEN s.Name END asc,
		CASE WHEN @iSortCol = 22 AND @sSortDir='desc' THEN s.Name END desc,
		CASE WHEN @iSortCol = 23 AND @sSortDir='asc' THEN s.CountryId END asc,
		CASE WHEN @iSortCol = 23 AND @sSortDir='desc' THEN s.CountryId END desc
	OFFSET (@pageNumber-1)*@pageSize ROWS
	FETCH NEXT @pageSize ROWS ONLY;
END

/*----------------------------------------------------------------------------*/

CREATE procedure [dbo].[spScolarYearAdd]
(
	@name nvarchar (250),
	@countryId int
)
AS
BEGIN
	INSERT INTO ScolarYear ( Name, CountryId )
	VALUES ( @name, @countryId	)
END

/*----------------------------------------------------------------------------*/

CREATE procedure [dbo].[spScolarYearUpdate]
(
	@name nvarchar (250),
	@countryId int,
	@scolarYearId int
)
AS
BEGIN
	UPDATE ScolarYear SET Name=@name, CountryId=@countryId
	WHERE ScolarYearId=@scolarYearId
END

/*----------------------------------------------------------------------------*/

CREATE procedure [dbo].[spScolarYearDelete]
(
	@scolarYearId int
)
AS
BEGIN
	DELETE FROM ScolarYear
	WHERE 	ScolarYearId = @scolarYearId
END

/*----------------------------------------------------------------------------*/

