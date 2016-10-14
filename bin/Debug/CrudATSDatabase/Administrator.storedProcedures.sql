CREATE procedure [dbo].[spAdministratorGetByPage]
(
	@name nvarchar (250),
	@userId int,
	@iSortCol INT=1,
	@sSortDir NVARCHAR(100)='asc',	 
	@pageNumber INT = 1,
	@pageSize INT = 10
)
AS
BEGIN
	SELECT Count(*) Over() AS TotalRows,
	 	a.Name,
		a.UserId
	FROM   Administrator a
	WHERE   (COALESCE(a.Name,'') LIKE '%' + COALESCE(@name, COALESCE(a.Name,'')) + '%')
	AND (a.UserId=@userId OR @userId IS NULL)
	ORDER BY  CASE WHEN @iSortCol = -2 AND @sSortDir='asc' THEN a.Name END asc,
		CASE WHEN @iSortCol = -2 AND @sSortDir='desc' THEN a.Name END desc,
		CASE WHEN @iSortCol = -1 AND @sSortDir='asc' THEN a.UserId END asc,
		CASE WHEN @iSortCol = -1 AND @sSortDir='desc' THEN a.UserId END desc
	OFFSET (@pageNumber-1)*@pageSize ROWS
	FETCH NEXT @pageSize ROWS ONLY;
END

/*----------------------------------------------------------------------------*/

CREATE procedure [dbo].[spAdministratorAdd]
(
	@name nvarchar (250),
	@userId int
)
AS
BEGIN
	INSERT INTO Administrator ( Name, UserId )
	VALUES ( @name, @userId	)
END

/*----------------------------------------------------------------------------*/

CREATE procedure [dbo].[spAdministratorUpdate]
(
	@name nvarchar (250),
	@userId int,
	@administratorId int
)
AS
BEGIN
	UPDATE Administrator SET Name=@name, UserId=@userId
	WHERE AdministratorId=@administratorId
END

/*----------------------------------------------------------------------------*/

CREATE procedure [dbo].[spAdministratorDelete]
(
	@administratorId int
)
AS
BEGIN
	DELETE FROM Administrator
	WHERE 	AdministratorId = @administratorId
END

/*----------------------------------------------------------------------------*/

