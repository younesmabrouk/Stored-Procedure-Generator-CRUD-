CREATE procedure [dbo].[spStudentQuestionLevelGetByPage]
(
	@studentId INT,
	@subjectId INT,
	@questionlevel INT,
	@score FLOAT,
	@rightQuestions INT,
	@allQuestions INT,
	@iSortCol INT=1,
	@sSortDir NVARCHAR(100)='asc',	 
	@pageNumber INT = 1,
	@pageSize INT = 10
)
AS
BEGIN
	SELECT Count(*) Over() AS TotalRows,
	 	s.StudentQuestionLevelId,
		s.StudentId,
		s.SubjectId,
		s.Questionlevel,
		s.Score,
		s.RightQuestions,
		s.AllQuestions
	FROM   StudentQuestionLevel s
	WHERE   (s.StudentId=@studentId OR @studentId IS NULL)
	AND (s.SubjectId=@subjectId OR @subjectId IS NULL)
	AND (s.Questionlevel=@questionlevel OR @questionlevel IS NULL)
	AND (COALESCE(s.Score,'') LIKE '%' + COALESCE(@score, COALESCE(s.Score,'')) + '%')
	AND (s.RightQuestions=@rightQuestions OR @rightQuestions IS NULL)
	AND (s.AllQuestions=@allQuestions OR @allQuestions IS NULL)
	ORDER BY  CASE WHEN @iSortCol = 35 AND @sSortDir='asc' THEN s.StudentId END asc,
		CASE WHEN @iSortCol = 35 AND @sSortDir='desc' THEN s.StudentId END desc,
		CASE WHEN @iSortCol = 36 AND @sSortDir='asc' THEN s.SubjectId END asc,
		CASE WHEN @iSortCol = 36 AND @sSortDir='desc' THEN s.SubjectId END desc,
		CASE WHEN @iSortCol = 37 AND @sSortDir='asc' THEN s.Questionlevel END asc,
		CASE WHEN @iSortCol = 37 AND @sSortDir='desc' THEN s.Questionlevel END desc,
		CASE WHEN @iSortCol = 38 AND @sSortDir='asc' THEN s.Score END asc,
		CASE WHEN @iSortCol = 38 AND @sSortDir='desc' THEN s.Score END desc,
		CASE WHEN @iSortCol = 39 AND @sSortDir='asc' THEN s.RightQuestions END asc,
		CASE WHEN @iSortCol = 39 AND @sSortDir='desc' THEN s.RightQuestions END desc,
		CASE WHEN @iSortCol = 40 AND @sSortDir='asc' THEN s.AllQuestions END asc,
		CASE WHEN @iSortCol = 40 AND @sSortDir='desc' THEN s.AllQuestions END desc
	OFFSET (@pageNumber-1)*@pageSize ROWS
	FETCH NEXT @pageSize ROWS ONLY;
END

/*----------------------------------------------------------------------------*/

CREATE procedure [dbo].[spStudentQuestionLevelAdd]
(
	@studentId INT,
	@subjectId INT,
	@questionlevel INT,
	@score FLOAT,
	@rightQuestions INT,
	@allQuestions INT
)
AS
BEGIN
	INSERT INTO StudentQuestionLevel ( StudentId, SubjectId, Questionlevel, Score, RightQuestions, AllQuestions )
	VALUES ( @studentId, @subjectId, @questionlevel, @score, @rightQuestions, @allQuestions	)
END

/*----------------------------------------------------------------------------*/

CREATE procedure [dbo].[spStudentQuestionLevelUpdate]
(
	@studentId INT,
	@subjectId INT,
	@questionlevel INT,
	@score FLOAT,
	@rightQuestions INT,
	@allQuestions INT,
	@studentQuestionLevelId INT
)
AS
BEGIN
	UPDATE StudentQuestionLevel SET StudentId=@studentId, SubjectId=@subjectId, Questionlevel=@questionlevel, Score=@score, RightQuestions=@rightQuestions, AllQuestions=@allQuestions
	WHERE StudentQuestionLevelId=@studentQuestionLevelId
END

/*----------------------------------------------------------------------------*/

CREATE procedure [dbo].[spStudentQuestionLevelDelete]
(
	@studentQuestionLevelId INT
)
AS
BEGIN
	DELETE FROM StudentQuestionLevel
	WHERE 	StudentQuestionLevelId = @studentQuestionLevelId
END

/*----------------------------------------------------------------------------*/

CREATE procedure [dbo].[spStudentQuestionLevelGetAll]
(
)
AS
BEGIN
	SELECT 
	 	s.StudentQuestionLevelId,
		s.StudentId,
		s.SubjectId,
		s.Questionlevel,
		s.Score,
		s.RightQuestions,
		s.AllQuestions
	FROM   StudentQuestionLevel s
END

/*----------------------------------------------------------------------------*/
