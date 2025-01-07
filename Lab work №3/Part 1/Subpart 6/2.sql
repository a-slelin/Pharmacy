--Сделаем UNPIVOT для таблицы выше.
WITH PivotCTE AS (
    SELECT [ИНН(Производителя)],
        [1],
        [24],
        [8],
        [5],
        [11]
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
    ) AS PivotTable
)

SELECT [ИНН(Производителя)], 
[Id], 
CASE WHEN CAST([Количество] AS NVARCHAR(MAX)) = '0' THEN 'Не заказано!'
ELSE CAST([Количество] AS NVARCHAR(MAX)) END AS [Количество]
FROM PivotCTE
UNPIVOT
(
    [Количество] FOR [Id] IN ([1], [24], [8], [5], [11])
) AS UnpivotedTable;
