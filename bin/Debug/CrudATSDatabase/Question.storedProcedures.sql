CREATE procedure [dbo].[spQuestionGetByPage]
(
	@descriptionText NVARCHAR (250),
	@type INT,
	@lessonId INT,
	@withTime INT,
	@level INT,
	@isHidden INT,
	@iSortCol INT=1,
	@sSortDir NVARCHAR(100)='asc',	 
	@pageNumber INT = 1,
	@pageSize INT = 10
)
AS
BEGIN
	SELECT Count(*) Over() AS TotalRows,
	 	q.QuestionId,
		q.DescriptionText,
		q.Type,
		q.LessonId,
		q.WithTime,
		q.Level,
		q.IsHidden
	FROM   Question q
	WHERE   (COALESCE(q.DescriptionText,'') LIKE '%' + COALESCE(@descriptionText, COALESCE(q.DescriptionText,'')) + '%')
	AND (q.Type=@type OR @type IS NULL)
	AND (q.LessonId=@lessonId OR @lessonId IS NULL)
	AND (q.WithTime=@withTime OR @withTime IS NULL)
	AND (q.Level=@level OR @level IS NULL)
	AND (q.IsHidden=@isHidden OR @isHidden IS NULL)
	ORDER BY  CASE WHEN @iSortCol = 13 AND @sSortDir='asc' THEN q.DescriptionText END asc,
		CASE WHEN @iSortCol = 13 AND @sSortDir='desc' THEN q.DescriptionText END desc,
		CASE WHEN @iSortCol = 14 AND @sSortDir='asc' THEN q.Type END asc,
		CASE WHEN @iSortCol = 14 AND @sSortDir='desc' THEN q.Type END desc,
		CASE WHEN @iSortCol = 15 AND @sSortDir='asc' THEN q.LessonId END asc,
		CASE WHEN @iSortCol = 15 AND @sSortDir='desc' THEN q.LessonId END desc,
		CASE WHEN @iSortCol = 16 AND @sSortDir='asc' THEN q.WithTime END asc,
		CASE WHEN @iSortCol = 16 AND @sSortDir='desc' THEN q.WithTime END desc,
		CASE WHEN @iSortCol = 17 AND @sSortDir='asc' THEN q.Level END asc,
		CASE WHEN @iSortCol = 17 AND @sSortDir='desc' THEN q.Level END desc,
		CASE WHEN @iSortCol = 18 AND @sSortDir='asc' THEN q.IsHidden END asc,
		CASE WHEN @iSortCol = 18 AND @sSortDir='desc' THEN q.IsHidden END desc
	OFFSET (@pageNumber-1)*@pageSize ROWS
	FETCH NEXT @pageSize ROWS ONLY;
END

/*----------------------------------------------------------------------------*/

CREATE procedure [dbo].[spQuestionAdd]
(
	@descriptionText NVARCHAR (250),
	@type INT,
	@lessonId INT,
	@withTime INT,
	@level INT,
	@isHidden INT
)
AS
BEGIN
	INSERT INTO Question ( DescriptionText, Type, LessonId, WithTime, Level, IsHidden )
	VALUES ( @descriptionText, @type, @lessonId, @withTime, @level, @isHidden	)
END

/*----------------------------------------------------------------------------*/

CREATE procedure [dbo].[spQuestionUpdate]
(
	@descriptionText NVARCHAR (250),
	@type INT,
	@lessonId INT,
	@withTime INT,
	@level INT,
	@isHidden INT,
	@questionId INT
)
AS
BEGIN
	UPDATE Question SET DescriptionText=@descriptionText, Type=@type, LessonId=@lessonId, WithTime=@withTime, Level=@level, IsHidden=@isHidden
	WHERE QuestionId=@questionId
END

/*----------------------------------------------------------------------------*/

CREATE procedure [dbo].[spQuestionDelete]
(
	@questionId INT
)
AS
BEGIN
	DELETE FROM Question
	WHERE 	QuestionId = @questionId
END

/*----------------------------------------------------------------------------*/

CREATE procedure [dbo].[spQuestionGetAll]
(
)
AS
BEGIN
	SELECT 
	 	q.QuestionId,
		q.DescriptionText,
		q.Type,
		q.LessonId,
		q.WithTime,
		q.Level,
		q.IsHidden
	FROM   Question q
END

/*----------------------------------------------------------------------------*/
