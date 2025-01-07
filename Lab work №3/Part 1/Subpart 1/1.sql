/*Задание 1.1.
Выбрать из произвольной таблицы данные и 
отсортировать их по двум  произвольным имеющимся 
в таблице признакам (разные направления сортировки).*/

--Отсортируем все лекарства по цене для продажи по убыванию.
SELECT [Идентификационный номер конкретного лекарства], [Цена для продажи], [Количество]
FROM [Конкретное лекарство]
ORDER BY [Цена для продажи] DESC

--Отсортируем все лекарства по количеству по возрастанию.
SELECT [Идентификационный номер конкретного лекарства], [Цена для продажи], [Количество]
FROM [Конкретное лекарство]
ORDER BY [Количество] ASC


