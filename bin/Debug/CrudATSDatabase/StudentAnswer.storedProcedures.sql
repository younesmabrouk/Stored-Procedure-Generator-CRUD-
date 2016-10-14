CREATE procedure [dbo].[spStudentAnswerGetByPage]
(
	@studentId INT,
	@questionId INT,
	@answerId INT,
	@gregDate NVARCHAR (300),
	@iSortCol INT=1,
	@sSortDir NVARCHAR(100)='asc',	 
	@pageNumber INT = 1,
	@pageSize INT = 10
)
AS
BEGIN
	SELECT Count(*) Over() AS TotalRows,
	 	s.StudentAnswerId,
		s.StudentId,
		s.QuestionId,
		s.AnswerId,
		s.GregDate
	FROM   StudentAnswer s
	WHERE   (s.StudentId=@studentId OR @studentId IS NULL)
	AND (s.QuestionId=@questionId OR @questionId IS NULL)
	AND (s.AnswerId=@answerId OR @answerId IS NULL)
	AND (COALESCE(s.GregDate,'') LIKE '%' + COALESCE(@gregDate, COALESCE(s.GregDate,'')) + '%')
	ORDER BY  CASE WHEN @iSortCol = 31 AND @sSortDir='asc' THEN s.StudentId END asc,
		CASE WHEN @iSortCol = 31 AND @sSortDir='desc' THEN s.StudentId END desc,
		CASE WHEN @iSortCol = 32 AND @sSortDir='asc' THEN s.QuestionId END asc,
		CASE WHEN @iSortCol = 32 AND @sSortDir='desc' THEN s.QuestionId END desc,
		CASE WHEN @iSortCol = 33 AND @sSortDir='asc' THEN s.AnswerId END asc,
		CASE WHEN @iSortCol = 33 AND @sSortDir='desc' THEN s.AnswerId END desc,
		CASE WHEN @iSortCol = 34 AND @sSortDir='asc' THEN s.GregDate END asc,
		CASE WHEN @iSortCol = 34 AND @sSortDir='desc' THEN s.GregDate END desc
	OFFSET (@pageNumber-1)*@pageSize ROWS
	FETCH NEXT @pageSize ROWS ONLY;
END

/*----------------------------------------------------------------------------*/

CREATE procedure [dbo].[spStudentAnswerAdd]
(
	@studentId INT,
	@questionId INT,
	@answerId INT,
	@gregDate NVARCHAR (300)
)
AS
BEGIN
	INSERT INTO StudentAnswer ( StudentId, QuestionId, AnswerId, GregDate )
	VALUES ( @studentId, @questionId, @answerId, @gregDate	)
END

/*----------------------------------------------------------------------------*/

CREATE procedure [dbo].[spStudentAnswerUpdate]
(
	@studentId INT,
	@questionId INT,
	@answerId INT,
	@gregDate NVARCHAR (300),
	@studentAnswerId INT
)
AS
BEGIN
	UPDATE StudentAnswer SET StudentId=@studentId, QuestionId=@questionId, AnswerId=@answerId, GregDate=@gregDate
	WHERE StudentAnswerId=@studentAnswerId
END

/*----------------------------------------------------------------------------*/

CREATE procedure [dbo].[spStudentAnswerDelete]
(
	@studentAnswerId INT
)
AS
BEGIN
	DELETE FROM StudentAnswer
	WHERE 	StudentAnswerId = @studentAnswerId
END

/*----------------------------------------------------------------------------*/

CREATE procedure [dbo].[spStudentAnswerGetAll]
(
)
AS
BEGIN
	SELECT 
	 	s.StudentAnswerId,
		s.StudentId,
		s.QuestionId,
		s.AnswerId,
		s.GregDate
	FROM   StudentAnswer s
END

/*----------------------------------------------------------------------------*/
