/*Задание №3. 
Левое внешнее соединение left join. Привести 2-3 запроса.*/

--Найдем все лекарства, у которых пока нет конкретной реализации
--у производителя(не успели занести, например)
SELECT [Лекарство].[Идентификационный номер лекарства], [Название лекарства]
FROM [Лекарство] LEFT OUTER JOIN [Конкретное лекарство]
ON [Лекарство].[Идентификационный номер лекарства] = [Конкретное лекарство].[Идентификационный номер лекарства]
WHERE [Конкретное лекарство].[Идентификационный номер конкретного лекарства] IS NULL

--Найдем всех бухгалтеров, которые еще не делали 
--ни одного заказа.
SELECT [Сотрудник].[ИНН], [Сотрудник].[ФИО]
FROM [Сотрудник] LEFT OUTER JOIN [Заказ]
ON [Сотрудник].[ИНН] = [Заказ].[ИНН(Сотрудника)]
WHERE [Сотрудник].[Должность] = 'Бухгалтер'
AND [Заказ].[Номер заказа] IS NULL

