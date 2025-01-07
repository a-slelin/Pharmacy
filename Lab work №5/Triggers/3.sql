/*3-й триггер.
Замещающий триггер на операцию удаления лекарства из списка купленных покупателем лекарств 
– если покупатель передумал покупать только что купленное лекарство, то выполняем операцию возврата
(удаляем это лекарство из списка купленных этим покупателем лекарств, возвращаем его в аптеку, 
пересчитываем сумму чека для покупателя).*/

CREATE OR ALTER TRIGGER MyTrigger_D
ON [Продажа состоит из]
INSTEAD OF DELETE
AS 
BEGIN
    DECLARE @Id INT, @IdSale INT, @Count INT;

	DECLARE MyCursor_in_MyTrigger_D CURSOR FOR 
	    SELECT *
		FROM DELETED
    
	--Создадим курсор для отработки каждой строки по-отдельности.
	OPEN MyCursor_in_MyTrigger_D;
	FETCH NEXT FROM MyCursor_in_MyTrigger_D INTO @Id, @IdSale, @Count;
    WHILE @@FETCH_STATUS = 0
	BEGIN
	    --Дата этой продажи понадобится чтобы проверить, что продажа была недавно (в этот же день).
	    DECLARE @Date DATE;
		SELECT @Date = [Дата продажи]
		FROM [Продажа]
		WHERE [Номер продажи] = @IdSale

		--Так же, для пересчета чека нам понадобится знать сколько
		--стоит лекарство, удаляемое из чека.
		DECLARE @Price MONEY;
		SELECT @Price = [Цена для продажи]
		FROM [Конкретное лекарство]
		WHERE [Идентификационный номер конкретного лекарства] = @Id

		--Будем работать только если мы редактируем в тот же самый день
		IF DAY(@Date) = DAY(GETDATE()) AND MONTH(@Date) = MONTH(GETDATE()) 
		AND YEAR(@Date) = YEAR(GETDATE())
		BEGIN

			--Удаляем строку из продажи.
		    DELETE FROM [Продажа состоит из]
			WHERE [Номер продажи] = @IdSale AND
            [Идентификационный номер конкретного лекарства] = @Id 
			AND [Количество] = @Count

			--Обновляем сумму(чек) продажи.
			UPDATE [Продажа]
			SET [Общая сумма] = [Общая сумма] - @Price * @Count
			WHERE [Номер продажи] = @IdSale

			--Доставляем лекарства назад в аптеку.
			UPDATE [Конкретное лекарство]
			SET [Количество] = [Количество] + @Count
			WHERE [Идентификационный номер конкретного лекарства] = @Id
		END;

		--Переходим к следующей строке.
		FETCH NEXT FROM MyCursor_in_MyTrigger_D INTO @Id, @IdSale, @Count;
	END;
	CLOSE MyCursor_in_MyTrigger_D;
	DEALLOCATE MyCursor_in_MyTrigger_D;
END;
GO

INSERT INTO [Продажа] VALUES('647543544304', GETDATE(), 4194);
INSERT INTO [Продажа состоит из] VALUES
(14, 21, 2),
(40, 21, 1),
(62, 21, 3)


SELECT *
FROM [Продажа состоит из]
WHERE [Номер продажи] = 21

SELECT *
FROM [Продажа]
WHERE [Номер продажи] = 21

DELETE FROM [Продажа состоит из]
WHERE [Номер продажи] = 21 AND
[Идентификационный номер конкретного лекарства] = 14
AND [Количество] = 2
