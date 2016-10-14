CREATE procedure [dbo].[spCountryGetByPage]
(
	@name NVARCHAR (250),
	@englishName NVARCHAR (250),
	@phoneCode NVARCHAR (250),
	@nationality NVARCHAR (250),
	@iSortCol INT=1,
	@sSortDir NVARCHAR(100)='asc',	 
	@pageNumber INT = 1,
	@pageSize INT = 10
)
AS
BEGIN
	SELECT Count(*) Over() AS TotalRows,
	 	c.CountryId,
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
	@name NVARCHAR (250),
	@englishName NVARCHAR (250),
	@phoneCode NVARCHAR (250),
	@nationality NVARCHAR (250)
)
AS
BEGIN
	INSERT INTO Country ( Name, EnglishName, PhoneCode, Nationality )
	VALUES ( @name, @englishName, @phoneCode, @nationality	)
END

/*----------------------------------------------------------------------------*/

CREATE procedure [dbo].[spCountryUpdate]
(
	@name NVARCHAR (250),
	@englishName NVARCHAR (250),
	@phoneCode NVARCHAR (250),
	@nationality NVARCHAR (250),
	@countryId INT
)
AS
BEGIN
	UPDATE Country SET Name=@name, EnglishName=@englishName, PhoneCode=@phoneCode, Nationality=@nationality
	WHERE CountryId=@countryId
END

/*----------------------------------------------------------------------------*/

CREATE procedure [dbo].[spCountryDelete]
(
	@countryId INT
)
AS
BEGIN
	DELETE FROM Country
	WHERE 	CountryId = @countryId
END

/*----------------------------------------------------------------------------*/

CREATE procedure [dbo].[spCountryGetAll]
(
)
AS
BEGIN
	SELECT 
	 	c.CountryId,
		c.Name,
		c.EnglishName,
		c.PhoneCode,
		c.Nationality
	FROM   Country c
END

/*----------------------------------------------------------------------------*/
