CREATE procedure [dbo].[spStudentGetByPage]
(
	@fullname nvarchar (250),
	@countryId int,
	@scolarLevelId int,
	@email nvarchar (250),
	@password nvarchar (250),
	@gregDate nvarchar (250),
	@deviceToken nvarchar (-1),
	@iSortCol INT=1,
	@sSortDir NVARCHAR(100)='asc',	 
	@pageNumber INT = 1,
	@pageSize INT = 10
)
AS
BEGIN
	SELECT Count(*) Over() AS TotalRows,
	 	s.Fullname,
		s.CountryId,
		s.ScolarLevelId,
		s.Email,
		s.Password,
		s.GregDate,
		s.DeviceToken
	FROM   Student s
	WHERE   (COALESCE(s.Fullname,'') LIKE '%' + COALESCE(@fullname, COALESCE(s.Fullname,'')) + '%')
	AND (s.CountryId=@countryId OR @countryId IS NULL)
	AND (s.ScolarLevelId=@scolarLevelId OR @scolarLevelId IS NULL)
	AND (COALESCE(s.Email,'') LIKE '%' + COALESCE(@email, COALESCE(s.Email,'')) + '%')
	AND (COALESCE(s.Password,'') LIKE '%' + COALESCE(@password, COALESCE(s.Password,'')) + '%')
	AND (COALESCE(s.GregDate,'') LIKE '%' + COALESCE(@gregDate, COALESCE(s.GregDate,'')) + '%')
	AND (COALESCE(s.DeviceToken,'') LIKE '%' + COALESCE(@deviceToken, COALESCE(s.DeviceToken,'')) + '%')
	ORDER BY  CASE WHEN @iSortCol = 24 AND @sSortDir='asc' THEN s.Fullname END asc,
		CASE WHEN @iSortCol = 24 AND @sSortDir='desc' THEN s.Fullname END desc,
		CASE WHEN @iSortCol = 25 AND @sSortDir='asc' THEN s.CountryId END asc,
		CASE WHEN @iSortCol = 25 AND @sSortDir='desc' THEN s.CountryId END desc,
		CASE WHEN @iSortCol = 26 AND @sSortDir='asc' THEN s.ScolarLevelId END asc,
		CASE WHEN @iSortCol = 26 AND @sSortDir='desc' THEN s.ScolarLevelId END desc,
		CASE WHEN @iSortCol = 27 AND @sSortDir='asc' THEN s.Email END asc,
		CASE WHEN @iSortCol = 27 AND @sSortDir='desc' THEN s.Email END desc,
		CASE WHEN @iSortCol = 28 AND @sSortDir='asc' THEN s.Password END asc,
		CASE WHEN @iSortCol = 28 AND @sSortDir='desc' THEN s.Password END desc,
		CASE WHEN @iSortCol = 29 AND @sSortDir='asc' THEN s.GregDate END asc,
		CASE WHEN @iSortCol = 29 AND @sSortDir='desc' THEN s.GregDate END desc,
		CASE WHEN @iSortCol = 30 AND @sSortDir='asc' THEN s.DeviceToken END asc,
		CASE WHEN @iSortCol = 30 AND @sSortDir='desc' THEN s.DeviceToken END desc
	OFFSET (@pageNumber-1)*@pageSize ROWS
	FETCH NEXT @pageSize ROWS ONLY;
END

/*----------------------------------------------------------------------------*/

CREATE procedure [dbo].[spStudentAdd]
(
	@fullname nvarchar (250),
	@countryId int,
	@scolarLevelId int,
	@email nvarchar (250),
	@password nvarchar (250),
	@gregDate nvarchar (250),
	@deviceToken nvarchar (-1)
)
AS
BEGIN
	INSERT INTO Student ( Fullname, CountryId, ScolarLevelId, Email, Password, GregDate, DeviceToken )
	VALUES ( @fullname, @countryId, @scolarLevelId, @email, @password, @gregDate, @deviceToken	)
END

/*----------------------------------------------------------------------------*/

CREATE procedure [dbo].[spStudentUpdate]
(
	@fullname nvarchar (250),
	@countryId int,
	@scolarLevelId int,
	@email nvarchar (250),
	@password nvarchar (250),
	@gregDate nvarchar (250),
	@deviceToken nvarchar (-1),
	@studentId int
)
AS
BEGIN
	UPDATE Student SET Fullname=@fullname, CountryId=@countryId, ScolarLevelId=@scolarLevelId, Email=@email, Password=@password, GregDate=@gregDate, DeviceToken=@deviceToken
	WHERE StudentId=@studentId
END

/*----------------------------------------------------------------------------*/

CREATE procedure [dbo].[spStudentDelete]
(
	@studentId int
)
AS
BEGIN
	DELETE FROM Student
	WHERE 	StudentId = @studentId
END

/*----------------------------------------------------------------------------*/

