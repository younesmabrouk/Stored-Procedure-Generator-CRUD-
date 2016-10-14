CREATE procedure [dbo].[spCountryGetByPage]
(
	@name nvarchar (250),
	@englishName nvarchar (250),
	@phoneCode nvarchar (250),
	@nationality nvarchar (250),
	@iSortCol INT=1,
	@sSortDir NVARCHAR(100)='asc',	 
	@pageNumber INT = 1,
	@pageSize INT = 10
)
AS
BEGIN
	SELECT Count(*) Over() AS TotalRows,
	 	c.Name,
		c.EnglishName,
		c.PhoneCode,
		c.Nationality
	FROM   Country c
	WHERE   (COALESCE(c.Name,'') LIKE '%' + COALESCE(@name, COALESCE(c.Name,'')) + '%')
	AND (COALESCE(c.EnglishName,'') LIKE '%' + COALESCE(@englishName, COALESCE(c.EnglishName,'')) + '%')
	AND (COALESCE(c.PhoneCode,'') LIKE '%' + COALESCE(@phoneCode, COALESCE(c.PhoneCode,'')) + '%')
	AND (COALESCE(c.Nationality,'') LIKE '%' + COALESCE(@nationality, COALESCE(c.Nationality,'')) + '%')
	ORDER BY  CASE WHEN @iSortCol = 4 AND @sSortDir='asc' THEN c.Name END asc,
		CASE WHEN @iSortCol = 4 AND @sSortDir='desc' THEN c.Name END desc,
		CASE WHEN @iSortCol = 5 AND @sSortDir='asc' THEN c.EnglishName END asc,
		CASE WHEN @iSortCol = 5 AND @sSortDir='desc' THEN c.EnglishName END desc,
		CASE WHEN @iSortCol = 6 AND @sSortDir='asc' THEN c.PhoneCode END asc,
		CASE WHEN @iSortCol = 6 AND @sSortDir='desc' THEN c.PhoneCode END desc,
		CASE WHEN @iSortCol = 7 AND @sSortDir='asc' THEN c.Nationality END asc,
		CASE WHEN @iSortCol = 7 AND @sSortDir='desc' THEN c.Nationality END desc
	OFFSET (@pageNumber-1)*@pageSize ROWS
	FETCH NEXT @pageSize ROWS ONLY;
END

/*----------------------------------------------------------------------------*/

CREATE procedure [dbo].[spCountryAdd]
(
	@name nvarchar (250),
	@englishName nvarchar (250),
	@phoneCode nvarchar (250),
	@nationality nvarchar (250)
)
AS
BEGIN
	INSERT INTO Country ( Name, EnglishName, PhoneCode, Nationality )
	VALUES ( @name, @englishName, @phoneCode, @nationality	)
END

/*----------------------------------------------------------------------------*/

CREATE procedure [dbo].[spCountryUpdate]
(
	@name nvarchar (250),
	@englishName nvarchar (250),
	@phoneCode nvarchar (250),
	@nationality nvarchar (250),
	@countryId int
)
AS
BEGIN
	UPDATE Country SET Name=@name, EnglishName=@englishName, PhoneCode=@phoneCode, Nationality=@nationality
	WHERE CountryId=@countryId
END

/*----------------------------------------------------------------------------*/

CREATE procedure [dbo].[spCountryDelete]
(
	@countryId int
)
AS
BEGIN
	DELETE FROM Country
	WHERE 	CountryId = @countryId
END

/*----------------------------------------------------------------------------*/

