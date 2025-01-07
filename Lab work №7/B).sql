/*Задание B).
Вывести заболевания, для которых в аптеке нет лекарств.*/

SELECT [Болезнь].[Идентификационный код болезни], [Болезнь].[Название болезни]
FROM [Болезнь] LEFT OUTER JOIN [Лечит]
ON [Болезнь].[Идентификационный код болезни] = [Лечит].[Идентификационный код болезни]
LEFT OUTER JOIN [Лекарство] ON [Лечит].[Идентификационный номер лекарства] =
[Лекарство].[Идентификационный номер лекарства] LEFT OUTER JOIN [Конкретное лекарство]
ON [Лекарство].[Идентификационный номер лекарства] = [Конкретное лекарство].[Идентификационный номер лекарства]
GROUP BY [Болезнь].[Идентификационный код болезни], [Болезнь].[Название болезни]
HAVING SUM([Конкретное лекарство].[Количество]) = 0 OR SUM([Конкретное лекарство].[Количество]) IS NULL


--Решение графом
;WITH CTE AS
(
    SELECT disease.[Идентификационный код болезни], disease.[Название болезни]
	FROM [dbo].[Болезнь_Граф] AS disease

	EXCEPT

	SELECT disease.[Идентификационный код болезни], disease.[Название болезни]
	FROM [dbo].[Болезнь_Граф] AS disease, [dbo].[Лекарство_Граф] AS medicine,
	[dbo].[Лечит_Граф] AS cures
	WHERE MATCH(medicine-(cures)->disease)
), CTE2 AS
(
    SELECT disease.[Идентификационный код болезни], disease.[Название болезни]
    FROM [dbo].[Болезнь_Граф] AS disease,[dbo].[Лекарство_Граф] AS medicine,
    [dbo].[Конкретное лекарство_Граф] AS specific_medicine,[dbo].[Лечит_Граф] AS cures,
    [dbo].[Содержит информацию_Граф] AS contains_information
    WHERE MATCH(specific_medicine<-(contains_information)-medicine-(cures)->disease)
    GROUP BY disease.[Идентификационный код болезни], disease.[Название болезни]
    HAVING SUM(specific_medicine.[Количество]) = 0
), CTE3 AS
(
    SELECT disease.[Идентификационный код болезни], disease.[Название болезни]
	FROM [dbo].[Болезнь_Граф] AS disease, [dbo].[Лекарство_Граф] AS medicine,
    [dbo].[Лечит_Граф] AS cures
	WHERE MATCH(medicine-(cures)->disease)
    

	EXCEPT

	SELECT disease.[Идентификационный код болезни], disease.[Название болезни]
	FROM [dbo].[Болезнь_Граф] AS disease,[dbo].[Лекарство_Граф] AS medicine,
    [dbo].[Конкретное лекарство_Граф] AS specific_medicine,[dbo].[Лечит_Граф] AS cures,
    [dbo].[Содержит информацию_Граф] AS contains_information 
	WHERE MATCH(specific_medicine-(contains_information)->medicine-(cures)->disease)
)
 

SELECT * FROM CTE
UNION 
SELECT * FROM CTE2
UNION
SELECT * FROM CTE3

