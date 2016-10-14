CREATE procedure [dbo].[spwebpages_UsersInRolesGetByPage]
(
,
	@iSortCol INT=1,
	@sSortDir NVARCHAR(100)='asc',	 
	@pageNumber INT = 1,
	@pageSize INT = 10
)
AS
BEGIN
	SELECT Count(*) Over() AS TotalRows,
	 
	FROM   webpages_UsersInRoles w
	WHERE  
	ORDER BY  
	OFFSET (@pageNumber-1)*@pageSize ROWS
	FETCH NEXT @pageSize ROWS ONLY;
END

/*----------------------------------------------------------------------------*/

CREATE procedure [dbo].[spwebpages_UsersInRolesAdd]
(

)
AS
BEGIN
	INSERT INTO webpages_UsersInRoles (  )
	VALUES ( 	)
END

/*----------------------------------------------------------------------------*/

CREATE procedure [dbo].[spwebpages_UsersInRolesUpdate]
(
,
	@userId int,
	@roleId int
)
AS
BEGIN
	UPDATE webpages_UsersInRoles SET 
	WHERE UserId=@userId AND
RoleId=@roleId
END

/*----------------------------------------------------------------------------*/

CREATE procedure [dbo].[spwebpages_UsersInRolesDelete]
(
	@userId int,
	@roleId int
)
AS
BEGIN
	DELETE FROM webpages_UsersInRoles
	WHERE 	UserId = @userId AND
	RoleId = @roleId
END

/*----------------------------------------------------------------------------*/

