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
