CREATE procedure [dbo].[spwebpages_RolesGetByPage]
(
	@roleName nvarchar (256),
	@iSortCol INT=1,
	@sSortDir NVARCHAR(100)='asc',	 
	@pageNumber INT = 1,
	@pageSize INT = 10
)
AS
BEGIN
	SELECT Count(*) Over() AS TotalRows,
	 	w.RoleName
	FROM   webpages_Roles w
	WHERE   (COALESCE(w.RoleName,'') LIKE '%' + COALESCE(@roleName, COALESCE(w.RoleName,'')) + '%')
	ORDER BY  CASE WHEN @iSortCol = 56 AND @sSortDir='asc' THEN w.RoleName END asc,
		CASE WHEN @iSortCol = 56 AND @sSortDir='desc' THEN w.RoleName END desc
	OFFSET (@pageNumber-1)*@pageSize ROWS
	FETCH NEXT @pageSize ROWS ONLY;
END

/*----------------------------------------------------------------------------*/

CREATE procedure [dbo].[spwebpages_RolesAdd]
(
	@roleName nvarchar (256)
)
AS
BEGIN
	INSERT INTO webpages_Roles ( RoleName )
	VALUES ( @roleName	)
END

/*----------------------------------------------------------------------------*/

CREATE procedure [dbo].[spwebpages_RolesUpdate]
(
	@roleName nvarchar (256),
	@roleId int
)
AS
BEGIN
	UPDATE webpages_Roles SET RoleName=@roleName
	WHERE RoleId=@roleId
END

/*----------------------------------------------------------------------------*/

CREATE procedure [dbo].[spwebpages_RolesDelete]
(
	@roleId int
)
AS
BEGIN
	DELETE FROM webpages_Roles
	WHERE 	RoleId = @roleId
END

/*----------------------------------------------------------------------------*/

