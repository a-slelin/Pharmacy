/*4-я процедура.
Процедура, вызывающая вложенную процедуру, которая подсчитывает 
среднее количество наименований лекарств для одной продажи, а сама выводит 
продажи с количеством лекарств, превышающим среднее в виде: номер продажи, дата, сумма, кассир.*/

CREATE OR ALTER PROCEDURE AvgMedicinesSale
    @Avg REAL OUTPUT
AS
BEGIN
    WITH CTE AS
	(
        SELECT [Номер продажи], 
		COUNT(DISTINCT [Идентификационный номер конкретного лекарства])
		AS Cnt
	    FROM [Продажа состоит из]
	    GROUP BY [Номер продажи]
	)

	SELECT @Avg = AVG(Cnt)
	FROM CTE
END;
GO


CREATE OR ALTER PROCEDURE MoreAvgMedicinesSale
AS
BEGIN
    DECLARE @Avg REAL;
	EXEC AvgMedicinesSale @Avg OUTPUT;
	PRINT 'Среднее количество наименований за продажу - ' + CAST(@Avg AS NVARCHAR(5));

	SELECT DISTINCT [Продажа].[Номер продажи],
	[Дата продажи], [Общая сумма], 
	[Сотрудник].[ИНН], [Сотрудник].[ФИО]
	FROM [Продажа] INNER JOIN [Продажа состоит из]
	ON [Продажа].[Номер продажи] = [Продажа состоит из].[Номер продажи]
	INNER JOIN [Сотрудник] ON [Сотрудник].[ИНН] = [Продажа].[ИНН(Сотрудника)]
	WHERE [Продажа].[Номер продажи] IN 
	(
	    SELECT [Номер продажи]
	    FROM [Продажа состоит из]
	    GROUP BY [Номер продажи]
		HAVING 
		COUNT(DISTINCT [Идентификационный номер конкретного лекарства]) > @Avg
	)
	ORDER BY [Продажа].[Номер продажи]
END;
GO

EXEC MoreAvgMedicinesSale;