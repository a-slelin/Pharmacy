/*Задание №4. 
Правое внешнее соединение right join. Привести 2-3 запроса.*/

--Найдем теперь всех кассиров, которые еще не
--сделали ни одной продажи
SELECT [ИНН], [ФИО], [Паспортные данные]
FROM [Продажа] RIGHT OUTER JOIN [Сотрудник]
ON [Продажа].[ИНН(Сотрудника)] = [Сотрудник].[ИНН]
WHERE [Сотрудник].[Должность] = 'Кассир'
AND [Продажа].[Номер продажи] IS NULL

--Найдем все лекарства у которых нет конкретных реализаций.
SELECT [Лекарство].[Идентификационный номер лекарства], [Название лекарства]
FROM [Конкретное лекарство] RIGHT OUTER JOIN [Лекарство]
ON [Конкретное лекарство].[Идентификационный номер лекарства] = [Лекарство].[Идентификационный номер лекарства]
WHERE [Конкретное лекарство].[Идентификационный номер лекарства] IS NULL





