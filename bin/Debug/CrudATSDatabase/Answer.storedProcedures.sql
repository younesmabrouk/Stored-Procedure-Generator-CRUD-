CREATE procedure [dbo].[spAnswerGetByPage]
(
	@orderNum INT,
	@descriptionText NVARCHAR (-1),
	@isTrue INT,
	@questionId INT,
	@iSortCol INT=1,
	@sSortDir NVARCHAR(100)='asc',	 
	@pageNumber INT = 1,
	@pageSize INT = 10
)
AS
BEGIN
	SELECT Count(*) Over() AS TotalRows,
	 	a.AnswerId,
		a.OrderNum,
		a.DescriptionText,
		a.IsTrue,
		a.QuestionId
	FROM   Answer a
	WHERE   (a.OrderNum=@orderNum OR @orderNum IS NULL)
	AND (COALESCE(a.DescriptionText,'') LIKE '%' + COALESCE(@descriptionText, COALESCE(a.DescriptionText,'')) + '%')
	AND (a.IsTrue=@isTrue OR @isTrue IS NULL)
	AND (a.QuestionId=@questionId OR @questionId IS NULL)
	ORDER BY  CASE WHEN @iSortCol = 0 AND @sSortDir='asc' THEN a.OrderNum END asc,
		CASE WHEN @iSortCol = 0 AND @sSortDir='desc' THEN a.OrderNum END desc,
		CASE WHEN @iSortCol = 1 AND @sSortDir='asc' THEN a.DescriptionText END asc,
		CASE WHEN @iSortCol = 1 AND @sSortDir='desc' THEN a.DescriptionText END desc,
		CASE WHEN @iSortCol = 2 AND @sSortDir='asc' THEN a.IsTrue END asc,
		CASE WHEN @iSortCol = 2 AND @sSortDir='desc' THEN a.IsTrue END desc,
		CASE WHEN @iSortCol = 3 AND @sSortDir='asc' THEN a.QuestionId END asc,
		CASE WHEN @iSortCol = 3 AND @sSortDir='desc' THEN a.QuestionId END desc
	OFFSET (@pageNumber-1)*@pageSize ROWS
	FETCH NEXT @pageSize ROWS ONLY;
END

/*----------------------------------------------------------------------------*/

CREATE procedure [dbo].[spAnswerAdd]
(
	@orderNum INT,
	@descriptionText NVARCHAR (-1),
	@isTrue INT,
	@questionId INT
)
AS
BEGIN
	INSERT INTO Answer ( OrderNum, DescriptionText, IsTrue, QuestionId )
	VALUES ( @orderNum, @descriptionText, @isTrue, @questionId	)
END

/*----------------------------------------------------------------------------*/

CREATE procedure [dbo].[spAnswerUpdate]
(
	@orderNum INT,
	@descriptionText NVARCHAR (-1),
	@isTrue INT,
	@questionId INT,
	@answerId INT
)
AS
BEGIN
	UPDATE Answer SET OrderNum=@orderNum, DescriptionText=@descriptionText, IsTrue=@isTrue, QuestionId=@questionId
	WHERE AnswerId=@answerId
END

/*----------------------------------------------------------------------------*/

CREATE procedure [dbo].[spAnswerDelete]
(
	@answerId INT
)
AS
BEGIN
	DELETE FROM Answer
	WHERE 	AnswerId = @answerId
END

/*----------------------------------------------------------------------------*/

CREATE procedure [dbo].[spAnswerGetAll]
(
)
AS
BEGIN
	SELECT 
	 	a.AnswerId,
		a.OrderNum,
		a.DescriptionText,
		a.IsTrue,
		a.QuestionId
	FROM   Answer a
END

/*----------------------------------------------------------------------------*/
