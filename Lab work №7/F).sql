/*Задание F). 
Выдать выручку аптеки за вчерашний день по каждому разделу лекарств.*/

DECLARE @YesDay DATE = '2023-11-29';

WITH TMP (Topic, Summ) AS
(
    SELECT [Раздел], SUM([Продажа состоит из].[Количество] * [Цена для продажи])
	FROM [Продажа] INNER JOIN [Продажа состоит из]
    ON [Продажа].[Номер продажи] = [Продажа состоит из].[Номер продажи]
    INNER JOIN [Конкретное лекарство] 
    ON [Продажа состоит из].[Идентификационный номер конкретного лекарства] =
    [Конкретное лекарство].[Идентификационный номер конкретного лекарства]
    INNER JOIN [Лекарство] ON [Конкретное лекарство].[Идентификационный номер лекарства] =
    [Лекарство].[Идентификационный номер лекарства]
	WHERE CAST([Продажа].[Дата продажи] AS DATE) = @YesDay
	GROUP BY [Раздел]
), 

TMP_2 (Topic) AS 
(
    SELECT DISTINCT [Раздел]
	FROM [Лекарство]
)
 
SELECT DISTINCT TMP_2.Topic, IIF(TMP_2.Topic IN (TMP.Topic), TMP.Summ, 0)
AS TommorowProfit
FROM TMP RIGHT OUTER JOIN TMP_2
ON TMP_2.Topic = TMP.Topic
ORDER BY TMP_2.Topic ASC


--Решение графом
;WITH CTE AS
(
    SELECT medicine.[Раздел], SUM(consists_of.[Количество] * specific_medicine.[Цена для продажи])
	AS [Прибыль]
	FROM [dbo].[Продажа_Граф] AS sale, [dbo].[Лекарство_Граф] AS medicine,
    [dbo].[Конкретное лекарство_Граф] AS specific_medicine, 
    [dbo].[Содержит информацию_Граф] AS contains_information, 
	[dbo].[Продажа состоит из_Граф] AS consists_of
	WHERE MATCH(sale-(consists_of)->specific_medicine<-(contains_information)-medicine)
	AND CAST(sale.[Дата продажи] AS DATE) = @YesDay
	GROUP BY medicine.[Раздел]

), CTE2 AS
(
    SELECT medicine.[Раздел]
	FROM [dbo].[Лекарство_Граф] AS medicine
	GROUP BY medicine.[Раздел]
)

SELECT CTE2.[Раздел], 
CASE 
    WHEN CTE2.[Раздел] IN (CTE.[Раздел])
	THEN CTE.[Прибыль]
	ELSE 0
END AS [Прибыль]
FROM CTE RIGHT OUTER JOIN CTE2
ON CTE.[Раздел] = CTE2.[Раздел]