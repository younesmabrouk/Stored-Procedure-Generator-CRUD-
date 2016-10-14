CREATE procedure [dbo].[spSubjectGetByPage]
(
	@name NVARCHAR (250),
	@scolarLevelId INT,
	@iSortCol INT=1,
	@sSortDir NVARCHAR(100)='asc',	 
	@pageNumber INT = 1,
	@pageSize INT = 10
)
AS
BEGIN
	SELECT Count(*) Over() AS TotalRows,
	 	s.SubjectId,
		s.Name,
		s.ScolarLevelId
	FROM   Subject s
	WHERE   (COALESCE(s.Name,'') LIKE '%' + COALESCE(@name, COALESCE(s.Name,'')) + '%')
	AND (s.ScolarLevelId=@scolarLevelId OR @scolarLevelId IS NULL)
	ORDER BY  CASE WHEN @iSortCol = 41 AND @sSortDir='asc' THEN s.Name END asc,
		CASE WHEN @iSortCol = 41 AND @sSortDir='desc' THEN s.Name END desc,
		CASE WHEN @iSortCol = 42 AND @sSortDir='asc' THEN s.ScolarLevelId END asc,
		CASE WHEN @iSortCol = 42 AND @sSortDir='desc' THEN s.ScolarLevelId END desc
	OFFSET (@pageNumber-1)*@pageSize ROWS
	FETCH NEXT @pageSize ROWS ONLY;
END

/*----------------------------------------------------------------------------*/

CREATE procedure [dbo].[spSubjectAdd]
(
	@name NVARCHAR (250),
	@scolarLevelId INT
)
AS
BEGIN
	INSERT INTO Subject ( Name, ScolarLevelId )
	VALUES ( @name, @scolarLevelId	)
END

/*----------------------------------------------------------------------------*/

CREATE procedure [dbo].[spSubjectUpdate]
(
	@name NVARCHAR (250),
	@scolarLevelId INT,
	@subjectId INT
)
AS
BEGIN
	UPDATE Subject SET Name=@name, ScolarLevelId=@scolarLevelId
	WHERE SubjectId=@subjectId
END

/*----------------------------------------------------------------------------*/

CREATE procedure [dbo].[spSubjectDelete]
(
	@subjectId INT
)
AS
BEGIN
	DELETE FROM Subject
	WHERE 	SubjectId = @subjectId
END

/*----------------------------------------------------------------------------*/

CREATE procedure [dbo].[spSubjectGetAll]
(
)
AS
BEGIN
	SELECT 
	 	s.SubjectId,
		s.Name,
		s.ScolarLevelId
	FROM   Subject s
END

/*----------------------------------------------------------------------------*/
