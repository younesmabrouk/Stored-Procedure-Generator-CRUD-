CREATE procedure [dbo].[spwebpages_OAuthMembershipGetByPage]
(
	@userId int,
	@iSortCol INT=1,
	@sSortDir NVARCHAR(100)='asc',	 
	@pageNumber INT = 1,
	@pageSize INT = 10
)
AS
BEGIN
	SELECT Count(*) Over() AS TotalRows,
	 	w.UserId
	FROM   webpages_OAuthMembership w
	WHERE   (w.UserId=@userId OR @userId IS NULL)
	ORDER BY  CASE WHEN @iSortCol = 55 AND @sSortDir='asc' THEN w.UserId END asc,
		CASE WHEN @iSortCol = 55 AND @sSortDir='desc' THEN w.UserId END desc
	OFFSET (@pageNumber-1)*@pageSize ROWS
	FETCH NEXT @pageSize ROWS ONLY;
END

/*----------------------------------------------------------------------------*/

CREATE procedure [dbo].[spwebpages_OAuthMembershipAdd]
(
	@userId int
)
AS
BEGIN
	INSERT INTO webpages_OAuthMembership ( UserId )
	VALUES ( @userId	)
END

/*----------------------------------------------------------------------------*/

CREATE procedure [dbo].[spwebpages_OAuthMembershipUpdate]
(
	@userId int,
	@provider nvarchar (30),
	@providerUserId nvarchar (100)
)
AS
BEGIN
	UPDATE webpages_OAuthMembership SET UserId=@userId
	WHERE Provider=@provider AND
ProviderUserId=@providerUserId
END

/*----------------------------------------------------------------------------*/

CREATE procedure [dbo].[spwebpages_OAuthMembershipDelete]
(
	@provider nvarchar (30),
	@providerUserId nvarchar (100)
)
AS
BEGIN
	DELETE FROM webpages_OAuthMembership
	WHERE 	Provider = @provider AND
	ProviderUserId = @providerUserId
END

/*----------------------------------------------------------------------------*/

