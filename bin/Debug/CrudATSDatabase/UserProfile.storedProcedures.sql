CREATE procedure [dbo].[spUserProfileGetByPage]
(
	@username nvarchar (56),
	@email nvarchar (250),
	@iSortCol INT=1,
	@sSortDir NVARCHAR(100)='asc',	 
	@pageNumber INT = 1,
	@pageSize INT = 10
)
AS
BEGIN
	SELECT Count(*) Over() AS TotalRows,
	 	u.Username,
		u.Email
	FROM   UserProfile u
	WHERE   (COALESCE(u.Username,'') LIKE '%' + COALESCE(@username, COALESCE(u.Username,'')) + '%')
	AND (COALESCE(u.Email,'') LIKE '%' + COALESCE(@email, COALESCE(u.Email,'')) + '%')
	ORDER BY  CASE WHEN @iSortCol = 43 AND @sSortDir='asc' THEN u.Username END asc,
		CASE WHEN @iSortCol = 43 AND @sSortDir='desc' THEN u.Username END desc,
		CASE WHEN @iSortCol = 44 AND @sSortDir='asc' THEN u.Email END asc,
		CASE WHEN @iSortCol = 44 AND @sSortDir='desc' THEN u.Email END desc
	OFFSET (@pageNumber-1)*@pageSize ROWS
	FETCH NEXT @pageSize ROWS ONLY;
END

/*----------------------------------------------------------------------------*/

CREATE procedure [dbo].[spUserProfileAdd]
(
	@username nvarchar (56),
	@email nvarchar (250)
)
AS
BEGIN
	INSERT INTO UserProfile ( Username, Email )
	VALUES ( @username, @email	)
END

/*----------------------------------------------------------------------------*/

CREATE procedure [dbo].[spUserProfileUpdate]
(
	@username nvarchar (56),
	@email nvarchar (250),
	@userId int
)
AS
BEGIN
	UPDATE UserProfile SET Username=@username, Email=@email
	WHERE UserId=@userId
END

/*----------------------------------------------------------------------------*/

CREATE procedure [dbo].[spUserProfileDelete]
(
	@userId int
)
AS
BEGIN
	DELETE FROM UserProfile
	WHERE 	UserId = @userId
END

/*----------------------------------------------------------------------------*/

