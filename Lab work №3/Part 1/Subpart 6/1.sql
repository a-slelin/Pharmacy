/*Задание №6.
Привести примеры получения сводных (итоговых) таблиц с использованием PIVOT и UNPIVOT.
Привести примеры получения сводных (итоговых) таблиц с использованием CASE.*/

--Предположим, что нам надо узнать сколько и от какого производителя имеется
--конкретных лекарств 1, 24, 8, 5, 11. По ним нужен отчёт. Если производитель не 
--поставляет текущее лекарство, то написать об этом.
SELECT [ИНН(Производителя)],
CASE WHEN CAST([1] AS NVARCHAR(MAX)) IS NULL THEN 'Не поставляется.' 
     ELSE CAST([1] AS NVARCHAR(MAX))
END AS [Id=1],
CASE WHEN CAST([24] AS NVARCHAR(MAX)) IS NULL THEN 'Не поставляется.' 
     ELSE CAST([24] AS NVARCHAR(MAX))
END AS [Id=24],
CASE WHEN CAST([8] AS NVARCHAR(MAX)) IS NULL THEN 'Не поставляется.' 
     ELSE CAST([8] AS NVARCHAR(MAX))
END AS [Id=8],
CASE WHEN CAST([5] AS NVARCHAR(MAX)) IS NULL THEN 'Не поставляется.' 
     ELSE CAST([5] AS NVARCHAR(MAX))
END AS [Id=5],
CASE WHEN CAST([11] AS NVARCHAR(MAX)) IS NULL THEN 'Не поставляется.' 
     ELSE CAST([11] AS NVARCHAR(MAX))
END AS [Id=11]
FROM
(
    SELECT [ИНН(Производителя)],
    [Идентификационный номер лекарства],
    [Количество]
    FROM [Конкретное лекарство]
) AS Source
PIVOT
(
    SUM([Количество])
    FOR [Идентификационный номер лекарства] 
	IN ([1], [24], [8], [5], [11])
) AS PivotTable;


