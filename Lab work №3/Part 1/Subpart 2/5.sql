/*Задание №5. 
Привести примеры 2-3 запросов с использованием агрегатных функций
и группировки.*/

--Для каждого лекарства найдем сколько всего количества в аптеке(от разных производителей),
--а также итоговую закупочную цену, итоговую цену для продажи
--и конечно какую прибыль мы получим, когда это все продадим.
SELECT [Идентификационный номер лекарства], SUM([Количество]) AS CntMedicines, 
SUM([Количество] * [Закупочная цена]) AS TotalPurchasePrice,
SUM([Количество] * [Цена для продажи]) AS TotalSalePrice,
SUM([Количество] * [Цена для продажи]) - SUM([Количество] * [Закупочная цена]) AS Profit
FROM [Конкретное лекарство]
GROUP BY [Идентификационный номер лекарства]

--Предположим нам надо проверить работу кассиров, тогда мы посмотрим
--на то, не "исчезают" ли деньги за продажи лекарств. Посмотри каждую 
--продажу и выясним сколько денег пропало из кассы.
SELECT [Продажа].[Номер продажи], [ИНН(Сотрудника)], [Дата продажи],
SUM([Общая сумма]) / COUNT([Общая сумма]) AS PriceSale,
SUM([Продажа состоит из].[Количество] * [Цена для продажи]) AS RealPriceSale,
SUM([Общая сумма]) / COUNT([Общая сумма]) - SUM([Продажа состоит из].[Количество] * [Цена для продажи]) 
AS MissedMoney
FROM [Продажа] INNER JOIN [Продажа состоит из]
ON [Продажа].[Номер продажи] = [Продажа состоит из].[Номер продажи] INNER JOIN [Конкретное лекарство]
ON [Продажа состоит из].[Идентификационный номер конкретного лекарства] 
= [Конкретное лекарство].[Идентификационный номер конкретного лекарства]
GROUP BY [Продажа].[Номер продажи], [ИНН(Сотрудника)], [Дата продажи]
ORDER BY [Продажа].[Номер продажи] ASC



