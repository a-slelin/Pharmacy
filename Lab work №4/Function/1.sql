/*1-я функция.
Скалярная функция, возвращающая выручку аптеки на заданную дату.*/

CREATE OR ALTER FUNCTION Profit
(
    @StartDate DATE = '2022-10-08', --Дата открытия "аптеки"
	@FinishDate DATE = '2023-12-31' --Дата закрытия "аптеки"
)
RETURNS MONEY
AS
BEGIN
    DECLARE @Result MONEY = 0;

	SELECT @Result = ISNULL(SUM([Сумма заказа]), 0)
	FROM [Заказ]
	WHERE CAST([Дата заказа] AS DATE) 
	BETWEEN @StartDate AND @FinishDate

    SELECT @Result = ISNULL(SUM([Общая сумма]), 0) - @Result
	FROM [Продажа] 
	WHERE CAST([Дата продажи] AS DATE) 
	BETWEEN @StartDate AND @FinishDate

	RETURN @Result;
END;
GO


--Нужно учесть тот факт, что заказы я делал очень болишими, и 
--на крупные деньги, а продаж не так много и на маленькую сумму,
--так как покупатели обычно не очень много покупают в аптеке, 
--вряд ли у кого-то получается покупка больше 10000рублей.
--Поэтому в данной аптеке выручка будет отрицательна...

DECLARE @Result MONEY;
EXEC @Result = dbo.Profit '2023-07-17', '2023-07-17';
PRINT @Result