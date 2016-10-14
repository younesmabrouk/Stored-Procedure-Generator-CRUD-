CREATE procedure [dbo].[spNotificationGetByPage]
(
	@descriptionText NVARCHAR (-1),
	@gregDate NVARCHAR (250),
	@administratorId INT,
	@iSortCol INT=1,
	@sSortDir NVARCHAR(100)='asc',	 
	@pageNumber INT = 1,
	@pageSize INT = 10
)
AS
BEGIN
	SELECT Count(*) Over() AS TotalRows,
	 	n.NotificationId,
		n.DescriptionText,
		n.GregDate,
		n.AdministratorId
	FROM   Notification n
	WHERE   (COALESCE(n.DescriptionText,'') LIKE '%' + COALESCE(@descriptionText, COALESCE(n.DescriptionText,'')) + '%')
	AND (COALESCE(n.GregDate,'') LIKE '%' + COALESCE(@gregDate, COALESCE(n.GregDate,'')) + '%')
	AND (n.AdministratorId=@administratorId OR @administratorId IS NULL)
	ORDER BY  CASE WHEN @iSortCol = 10 AND @sSortDir='asc' THEN n.DescriptionText END asc,
		CASE WHEN @iSortCol = 10 AND @sSortDir='desc' THEN n.DescriptionText END desc,
		CASE WHEN @iSortCol = 11 AND @sSortDir='asc' THEN n.GregDate END asc,
		CASE WHEN @iSortCol = 11 AND @sSortDir='desc' THEN n.GregDate END desc,
		CASE WHEN @iSortCol = 12 AND @sSortDir='asc' THEN n.AdministratorId END asc,
		CASE WHEN @iSortCol = 12 AND @sSortDir='desc' THEN n.AdministratorId END desc
	OFFSET (@pageNumber-1)*@pageSize ROWS
	FETCH NEXT @pageSize ROWS ONLY;
END

/*----------------------------------------------------------------------------*/

CREATE procedure [dbo].[spNotificationAdd]
(
	@descriptionText NVARCHAR (-1),
	@gregDate NVARCHAR (250),
	@administratorId INT
)
AS
BEGIN
	INSERT INTO Notification ( DescriptionText, GregDate, AdministratorId )
	VALUES ( @descriptionText, @gregDate, @administratorId	)
END

/*----------------------------------------------------------------------------*/

CREATE procedure [dbo].[spNotificationUpdate]
(
	@descriptionText NVARCHAR (-1),
	@gregDate NVARCHAR (250),
	@administratorId INT,
	@notificationId INT
)
AS
BEGIN
	UPDATE Notification SET DescriptionText=@descriptionText, GregDate=@gregDate, AdministratorId=@administratorId
	WHERE NotificationId=@notificationId
END

/*----------------------------------------------------------------------------*/

CREATE procedure [dbo].[spNotificationDelete]
(
	@notificationId INT
)
AS
BEGIN
	DELETE FROM Notification
	WHERE 	NotificationId = @notificationId
END

/*----------------------------------------------------------------------------*/

CREATE procedure [dbo].[spNotificationGetAll]
(
)
AS
BEGIN
	SELECT 
	 	n.NotificationId,
		n.DescriptionText,
		n.GregDate,
		n.AdministratorId
	FROM   Notification n
END

/*----------------------------------------------------------------------------*/
