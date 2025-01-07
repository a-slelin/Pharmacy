/*1-ый триггер.
Триггер любого типа на добавление лекарства в заказ: при добавлении нового лекарства проверить,
сформирован ли уже заказ на сегодня, если нет, то создать новый заказ на текущую дату и добавить туда лекарство. 
Если на сегодня заказ есть, то лекарство добавляется к нему.*/

CREATE OR ALTER TRIGGER AddMedOrd
ON [Заказ состоит из]
INSTEAD OF INSERT
AS 
BEGIN

    --Посмотрим есть ли у нас заказ сегодня.
    DECLARE @NumberOrder INT;
	SELECT @NumberOrder = [Номер заказа]
	FROM [Заказ]
	WHERE YEAR([Дата заказа]) = YEAR(GETDATE())
	AND MONTH([Дата заказа]) = MONTH(GETDATE())
	AND DAY([Дата заказа]) = DAY(GETDATE());

	--Если же нет такого заказа, то создадим его.
	IF @NumberOrder IS NULL
	BEGIN
	    DECLARE @INN NVARCHAR(MAX);
		SELECT TOP 1 @INN = [ИНН(Сотрудника)]
		FROM [Заказ]
		ORDER BY [Дата заказа] DESC

	    INSERT INTO [Заказ] VALUES (@INN, GETDATE(), 0)
		SELECT @NumberOrder = [Номер заказа]
	    FROM [Заказ]
	    WHERE YEAR([Дата заказа]) = YEAR(GETDATE())
	    AND MONTH([Дата заказа]) = MONTH(GETDATE())
	    AND DAY([Дата заказа]) = DAY(GETDATE());
	END;

	--Нам понадобится курсор, чтобы пройтись по каждой строчке.
    DECLARE @IdMed INT, @IdOrd INT, @Count INT;
	DECLARE MyCursor_in_AddMedOrd CURSOR FOR
	    SELECT [Идентификационный номер лекарства],
        [Номер заказа], [Количество]
		FROM INSERTED;

	OPEN MyCursor_in_AddMedOrd;
	FETCH NEXT FROM MyCursor_in_AddMedOrd INTO @IdMed, @IdOrd, @Count;
	WHILE @@FETCH_STATUS = 0
	BEGIN

	    --Проверка на то добавляем мы лекарство, которое уже сегодня добавляли 
		--или оно новое
	    IF EXISTS 
		(
	        SELECT 1
		    FROM [Заказ состоит из]
		    WHERE [Номер заказа] =  @NumberOrder AND 
            [Идентификационный номер лекарства] = @IdMed
		)
		BEGIN

		    --Если мы его уже добавляли, то просто изменим количество
		    UPDATE [Заказ состоит из]
			SET [Количество] = [Количество] + @Count
			WHERE [Идентификационный номер лекарства] = @IdMed
		END;
		ELSE
		BEGIN

	        --Добавим новые лекарства в заказ.
	        INSERT INTO [Заказ состоит из] VALUES (@IdMed, @NumberOrder, @Count)
		END;

		--Найдем цену заказа за это лекарство
		DECLARE @Price MONEY;
		SELECT @Price = SUM([Закупочная цена])
		FROM [Конкретное лекарство]
		WHERE [Идентификационный номер лекарства] = @IdMed
		GROUP BY [Идентификационный номер лекарства]

		--Теперь изменим цену текущего заказа.
		UPDATE [Заказ] 
		SET [Сумма заказа] = [Сумма заказа] + @Price * @Count
		WHERE [Номер заказа] = @NumberOrder

		--Перейдем к следующей строчке.
		FETCH NEXT FROM MyCursor_in_AddMedOrd INTO @IdMed, @IdOrd, @Count;
	END;
	CLOSE MyCursor_in_AddMedOrd;
	DEALLOCATE MyCursor_in_AddMedOrd;
END;
GO

INSERT INTO [dbo].[Заказ состоит из] VALUES
(1, 1, 3), 
(4, 1, 2)

INSERT INTO [dbo].[Заказ состоит из] VALUES
(5, 1, 6)

INSERT INTO [dbo].[Заказ состоит из] VALUES
(4, 1, 3),
(6, 2, 5),
(9, 3, 8)

SELECT *
FROM [dbo].[Заказ]
WHERE [Номер заказа] = 18

SELECT *
FROM [dbo].[Заказ состоит из]
WHERE [Номер заказа] = 18




