CREATE procedure [dbo].[spwebpages_MembershipGetByPage]
(
	@createDate DATETIME,
	@confirmationToken NVARCHAR (128),
	@isConfirmed BIT,
	@lastPasswordFailureDate DATETIME,
	@passwordFailuresSinceLastSuccess INT,
	@password NVARCHAR (128),
	@passwordChangedDate DATETIME,
	@passwordSalt NVARCHAR (128),
	@passwordVerificationToken NVARCHAR (128),
	@passwordVerificationTokenExpirationDate DATETIME,
	@iSortCol INT=1,
	@sSortDir NVARCHAR(100)='asc',	 
	@pageNumber INT = 1,
	@pageSize INT = 10
)
AS
BEGIN
	SELECT Count(*) Over() AS TotalRows,
	 	w.UserId,
		w.CreateDate,
		w.ConfirmationToken,
		w.IsConfirmed,
		w.LastPasswordFailureDate,
		w.PasswordFailuresSinceLastSuccess,
		w.Password,
		w.PasswordChangedDate,
		w.PasswordSalt,
		w.PasswordVerificationToken,
		w.PasswordVerificationTokenExpirationDate
	FROM   webpages_Membership w
	WHERE   (COALESCE(w.CreateDate,'') LIKE '%' + COALESCE(@createDate, COALESCE(w.CreateDate,'')) + '%')
	AND (COALESCE(w.ConfirmationToken,'') LIKE '%' + COALESCE(@confirmationToken, COALESCE(w.ConfirmationToken,'')) + '%')
	AND (COALESCE(w.IsConfirmed,'') LIKE '%' + COALESCE(@isConfirmed, COALESCE(w.IsConfirmed,'')) + '%')
	AND (COALESCE(w.LastPasswordFailureDate,'') LIKE '%' + COALESCE(@lastPasswordFailureDate, COALESCE(w.LastPasswordFailureDate,'')) + '%')
	AND (w.PasswordFailuresSinceLastSuccess=@passwordFailuresSinceLastSuccess OR @passwordFailuresSinceLastSuccess IS NULL)
	AND (COALESCE(w.Password,'') LIKE '%' + COALESCE(@password, COALESCE(w.Password,'')) + '%')
	AND (COALESCE(w.PasswordChangedDate,'') LIKE '%' + COALESCE(@passwordChangedDate, COALESCE(w.PasswordChangedDate,'')) + '%')
	AND (COALESCE(w.PasswordSalt,'') LIKE '%' + COALESCE(@passwordSalt, COALESCE(w.PasswordSalt,'')) + '%')
	AND (COALESCE(w.PasswordVerificationToken,'') LIKE '%' + COALESCE(@passwordVerificationToken, COALESCE(w.PasswordVerificationToken,'')) + '%')
	AND (COALESCE(w.PasswordVerificationTokenExpirationDate,'') LIKE '%' + COALESCE(@passwordVerificationTokenExpirationDate, COALESCE(w.PasswordVerificationTokenExpirationDate,'')) + '%')
	ORDER BY  CASE WHEN @iSortCol = 45 AND @sSortDir='asc' THEN w.CreateDate END asc,
		CASE WHEN @iSortCol = 45 AND @sSortDir='desc' THEN w.CreateDate END desc,
		CASE WHEN @iSortCol = 46 AND @sSortDir='asc' THEN w.ConfirmationToken END asc,
		CASE WHEN @iSortCol = 46 AND @sSortDir='desc' THEN w.ConfirmationToken END desc,
		CASE WHEN @iSortCol = 47 AND @sSortDir='asc' THEN w.IsConfirmed END asc,
		CASE WHEN @iSortCol = 47 AND @sSortDir='desc' THEN w.IsConfirmed END desc,
		CASE WHEN @iSortCol = 48 AND @sSortDir='asc' THEN w.LastPasswordFailureDate END asc,
		CASE WHEN @iSortCol = 48 AND @sSortDir='desc' THEN w.LastPasswordFailureDate END desc,
		CASE WHEN @iSortCol = 49 AND @sSortDir='asc' THEN w.PasswordFailuresSinceLastSuccess END asc,
		CASE WHEN @iSortCol = 49 AND @sSortDir='desc' THEN w.PasswordFailuresSinceLastSuccess END desc,
		CASE WHEN @iSortCol = 50 AND @sSortDir='asc' THEN w.Password END asc,
		CASE WHEN @iSortCol = 50 AND @sSortDir='desc' THEN w.Password END desc,
		CASE WHEN @iSortCol = 51 AND @sSortDir='asc' THEN w.PasswordChangedDate END asc,
		CASE WHEN @iSortCol = 51 AND @sSortDir='desc' THEN w.PasswordChangedDate END desc,
		CASE WHEN @iSortCol = 52 AND @sSortDir='asc' THEN w.PasswordSalt END asc,
		CASE WHEN @iSortCol = 52 AND @sSortDir='desc' THEN w.PasswordSalt END desc,
		CASE WHEN @iSortCol = 53 AND @sSortDir='asc' THEN w.PasswordVerificationToken END asc,
		CASE WHEN @iSortCol = 53 AND @sSortDir='desc' THEN w.PasswordVerificationToken END desc,
		CASE WHEN @iSortCol = 54 AND @sSortDir='asc' THEN w.PasswordVerificationTokenExpirationDate END asc,
		CASE WHEN @iSortCol = 54 AND @sSortDir='desc' THEN w.PasswordVerificationTokenExpirationDate END desc
	OFFSET (@pageNumber-1)*@pageSize ROWS
	FETCH NEXT @pageSize ROWS ONLY;
END

/*----------------------------------------------------------------------------*/

CREATE procedure [dbo].[spwebpages_MembershipAdd]
(
	@createDate DATETIME,
	@confirmationToken NVARCHAR (128),
	@isConfirmed BIT,
	@lastPasswordFailureDate DATETIME,
	@passwordFailuresSinceLastSuccess INT,
	@password NVARCHAR (128),
	@passwordChangedDate DATETIME,
	@passwordSalt NVARCHAR (128),
	@passwordVerificationToken NVARCHAR (128),
	@passwordVerificationTokenExpirationDate DATETIME
)
AS
BEGIN
	INSERT INTO webpages_Membership ( CreateDate, ConfirmationToken, IsConfirmed, LastPasswordFailureDate, PasswordFailuresSinceLastSuccess, Password, PasswordChangedDate, PasswordSalt, PasswordVerificationToken, PasswordVerificationTokenExpirationDate )
	VALUES ( @createDate, @confirmationToken, @isConfirmed, @lastPasswordFailureDate, @passwordFailuresSinceLastSuccess, @password, @passwordChangedDate, @passwordSalt, @passwordVerificationToken, @passwordVerificationTokenExpirationDate	)
END

/*----------------------------------------------------------------------------*/

CREATE procedure [dbo].[spwebpages_MembershipUpdate]
(
	@createDate DATETIME,
	@confirmationToken NVARCHAR (128),
	@isConfirmed BIT,
	@lastPasswordFailureDate DATETIME,
	@passwordFailuresSinceLastSuccess INT,
	@password NVARCHAR (128),
	@passwordChangedDate DATETIME,
	@passwordSalt NVARCHAR (128),
	@passwordVerificationToken NVARCHAR (128),
	@passwordVerificationTokenExpirationDate DATETIME,
	@userId INT
)
AS
BEGIN
	UPDATE webpages_Membership SET CreateDate=@createDate, ConfirmationToken=@confirmationToken, IsConfirmed=@isConfirmed, LastPasswordFailureDate=@lastPasswordFailureDate, PasswordFailuresSinceLastSuccess=@passwordFailuresSinceLastSuccess, Password=@password, PasswordChangedDate=@passwordChangedDate, PasswordSalt=@passwordSalt, PasswordVerificationToken=@passwordVerificationToken, PasswordVerificationTokenExpirationDate=@passwordVerificationTokenExpirationDate
	WHERE UserId=@userId
END

/*----------------------------------------------------------------------------*/

CREATE procedure [dbo].[spwebpages_MembershipDelete]
(
	@userId INT
)
AS
BEGIN
	DELETE FROM webpages_Membership
	WHERE 	UserId = @userId
END

/*----------------------------------------------------------------------------*/

CREATE procedure [dbo].[spwebpages_MembershipGetAll]
(
)
AS
BEGIN
	SELECT 
	 	w.UserId,
		w.CreateDate,
		w.ConfirmationToken,
		w.IsConfirmed,
		w.LastPasswordFailureDate,
		w.PasswordFailuresSinceLastSuccess,
		w.Password,
		w.PasswordChangedDate,
		w.PasswordSalt,
		w.PasswordVerificationToken,
		w.PasswordVerificationTokenExpirationDate
	FROM   webpages_Membership w
END

/*----------------------------------------------------------------------------*/
