/*3-я процедура.
Процедура, на входе получающая название лекарства, 
выходной параметр – самый дешевый его аналог с тем же действующим веществом.*/


CREATE OR ALTER PROCEDURE CheapAnalogue
    @MedicineName NVARCHAR(100),
	@Analogue NVARCHAR(100) OUTPUT
AS
BEGIN
    DECLARE @Ingridient NVARCHAR(100);
	SELECT @Ingridient = [Основное действующее вещество]
	FROM [Лекарство]
	WHERE [Название лекарства] = @MedicineName

	SET @Analogue =
	(
	    SELECT TOP 1 [Название лекарства]
	    FROM [Лекарство] INNER JOIN [Конкретное лекарство]
	    ON [Лекарство].[Идентификационный номер лекарства] =
		[Конкретное лекарство].[Идентификационный номер лекарства]
	    WHERE [Основное действующее вещество] = @Ingridient
	    AND [Название лекарства] <> @MedicineName
		ORDER BY [Цена для продажи] ASC
	)

	IF @Analogue IS NULL
	BEGIN
	    SET @Analogue = 'В данной аптеке нет аналога лекарству ' + @MedicineName;
	END;   
END;
GO


DECLARE @Input NVARCHAR(100);
--SET @Input = 'Но-шпа';
--SET @Input = 'РиноСтоп';
SET @Input = 'Зитрек';

DECLARE @Result NVARCHAR(100);
EXEC CheapAnalogue @Input, @Result OUTPUT;
PRINT @Result