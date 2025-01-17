/*3-я функция.
Multi-statement-функция, выдающая список лекарств от заданной болезни, 
имеющихся в аптеке с указанием количества упаковок.*/

CREATE OR ALTER FUNCTION CheckMedWithDiseas
(
    @Diseas NVARCHAR(100)
)
RETURNS @ThisTable TABLE
(
    [Идентификационный номер конкретного лекарства] NVARCHAR(100),
	[Название лекарства] NVARCHAR(100),
	[Количество] INT,
	[Цена для продажи] MONEY
)
AS
BEGIN
    INSERT INTO @ThisTable
    SELECT [Идентификационный номер конкретного лекарства], 
	[Лекарство].[Название лекарства], [Количество], 
    [Цена для продажи]
	FROM [Болезнь] INNER JOIN [Лечит]
	ON [Болезнь].[Идентификационный код болезни] = 
	[Лечит].[Идентификационный код болезни] INNER JOIN
    [Лекарство] ON [Лечит].[Идентификационный номер лекарства] =
	[Лекарство].[Идентификационный номер лекарства] INNER JOIN 
    [Конкретное лекарство] ON 
	[Конкретное лекарство].[Идентификационный номер лекарства] =
	[Лекарство].[Идентификационный номер лекарства]
	WHERE [Болезнь].[Название болезни] = @Diseas
	--AND [Конкретное лекарство].[Количество] > 0 

    RETURN
END;
GO

SELECT *
FROM CheckMedWithDiseas('Гипотония');

SELECT *
FROM CheckMedWithDiseas('Диарея');


SELECT *
FROM CheckMedWithDiseas('ОРВИ');