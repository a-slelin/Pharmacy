/*Задание № 1.
На основе любых запросов из п. 2 создать два представления (VIEW).*/

CREATE VIEW FullOrder AS
    SELECT [Заказ состоит из].[Номер заказа], [Идентификационный номер лекарства],
    [Количество]
    FROM [Заказ состоит из] INNER JOIN [Заказ]
    ON [Заказ состоит из].[Номер заказа] = [Заказ].[Номер заказа]


CREATE VIEW TotalProfit AS
    SELECT [Идентификационный номер лекарства], SUM([Количество]) AS CntMedicines, 
    SUM([Количество] * [Закупочная цена]) AS TotalPurchasePrice,
    SUM([Количество] * [Цена для продажи]) AS TotalSalePrice,
    SUM([Количество] * [Цена для продажи]) - SUM([Количество] * [Закупочная цена]) AS Profit
    FROM [Конкретное лекарство]
    GROUP BY [Идентификационный номер лекарства]

SELECT *
FROM FullOrder

SELECT *
FROM TotalProfit

