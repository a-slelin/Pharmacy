/*Задание №1. 
Привести примеры 3-4 запросов с использованием 
ROW_NUMBER, RANK, DENSE_RANK (c  PARTITION BY и без).*/

--Сделаем так, чтобы для каждого производителя создавалась нумерация
--производимых им конкретных лакарств(отсортированном).
SELECT IIF(ROW_NUMBER() OVER (PARTITION BY [ИНН(Производителя)] 
ORDER BY [ИНН(Производителя)], [Идентификационный номер конкретного лекарства]) = 1, 
[ИНН(Производителя)], '') AS [Производитель], 
ROW_NUMBER() OVER (PARTITION BY [ИНН(Производителя)] 
ORDER BY [ИНН(Производителя)], [Идентификационный номер конкретного лекарства]) AS NewNumber, 
[Идентификационный номер конкретного лекарства]
FROM [Конкретное лекарство]

--Пронумеруем всех бухгалтеров, но сортировать будем по сумме заказа
SELECT DENSE_RANK() OVER(ORDER BY [ИНН(Сотрудника)]) AS NumberOfEmployee, 
[Номер заказа], [Сумма заказа]
FROM [Заказ]
ORDER BY [Сумма заказа]

--Создадим ранк для каждого бухгалтера относительно его цены
--заказа. То есть теперь мы можем найти n-ый наибольший заказ
--у каждого бухгалтера.
;WITH RankedOrders (INN, NumberOrder, Summ, EmployeeRank) AS (
  SELECT[ИНН(Сотрудника)], [Номер заказа],[Сумма заказа],
  RANK() OVER (PARTITION BY [ИНН(Сотрудника)] ORDER BY [Сумма заказа] DESC) AS EmployeeRank
  FROM [Заказ]
)

SELECT INN, NumberOrder, Summ
FROM RankedOrders
WHERE EmployeeRank = 2

