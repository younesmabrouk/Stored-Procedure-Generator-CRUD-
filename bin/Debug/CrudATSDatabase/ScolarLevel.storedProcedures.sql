CREATE procedure [dbo].[spScolarLevelGetByPage]
(
	@stage INT,
	@name NVARCHAR (250),
	@scolarYearId INT,
	@iSortCol INT=1,
	@sSortDir NVARCHAR(100)='asc',	 
	@pageNumber INT = 1,
	@pageSize INT = 10
)
AS
BEGIN
	SELECT Count(*) Over() AS TotalRows,
	 	s.ScolarLevelId,
		s.Stage,
		s.Name,
		s.ScolarYearId
	FROM   ScolarLevel s
	WHERE   (s.Stage=@stage OR @stage IS NULL)
	AND (COALESCE(s.Name,'') LIKE '%' + COALESCE(@name, COALESCE(s.Name,'')) + '%')
	AND (s.ScolarYearId=@scolarYearId OR @scolarYearId IS NULL)
	ORDER BY  CASE WHEN @iSortCol = 19 AND @sSortDir='asc' THEN s.Stage END asc,
		CASE WHEN @iSortCol = 19 AND @sSortDir='desc' THEN s.Stage END desc,
		CASE WHEN @iSortCol = 20 AND @sSortDir='asc' THEN s.Name END asc,
		CASE WHEN @iSortCol = 20 AND @sSortDir='desc' THEN s.Name END desc,
		CASE WHEN @iSortCol = 21 AND @sSortDir='asc' THEN s.ScolarYearId END asc,
		CASE WHEN @iSortCol = 21 AND @sSortDir='desc' THEN s.ScolarYearId END desc
	OFFSET (@pageNumber-1)*@pageSize ROWS
	FETCH NEXT @pageSize ROWS ONLY;
END

/*----------------------------------------------------------------------------*/

CREATE procedure [dbo].[spScolarLevelAdd]
(
	@stage INT,
	@name NVARCHAR (250),
	@scolarYearId INT
)
AS
BEGIN
	INSERT INTO ScolarLevel ( Stage, Name, ScolarYearId )
	VALUES ( @stage, @name, @scolarYearId	)
END

/*----------------------------------------------------------------------------*/

CREATE procedure [dbo].[spScolarLevelUpdate]
(
	@stage INT,
	@name NVARCHAR (250),
	@scolarYearId INT,
	@scolarLevelId INT
)
AS
BEGIN
	UPDATE ScolarLevel SET Stage=@stage, Name=@name, ScolarYearId=@scolarYearId
	WHERE ScolarLevelId=@scolarLevelId
END

/*----------------------------------------------------------------------------*/

CREATE procedure [dbo].[spScolarLevelDelete]
(
	@scolarLevelId INT
)
AS
BEGIN
	DELETE FROM ScolarLevel
	WHERE 	ScolarLevelId = @scolarLevelId
END

/*----------------------------------------------------------------------------*/

CREATE procedure [dbo].[spScolarLevelGetAll]
(
)
AS
BEGIN
	SELECT 
	 	s.ScolarLevelId,
		s.Stage,
		s.Name,
		s.ScolarYearId
	FROM   ScolarLevel s
END

/*----------------------------------------------------------------------------*/
