/*2-ой триггер.
Последующий триггер на изменение количества лекарства в аптеке 
– если количество упаковок лекарства < 3, формируем строку с заказом на это лекарство.*/

CREATE OR ALTER TRIGGER AddMed
ON [Конкретное лекарство]
AFTER UPDATE, INSERT
AS
BEGIN
    --Сколько будем заказывать каждого лекарства.
    DECLARE @CountOrd INT = 10;

	--Объявим курсор для множественной обработки.
    DECLARE @Id INT, @IdMed INT, @INN NVARCHAR(10),
	@Description NVARCHAR(250), @Count INT,
	@Date_Start DATE, @Date_Finish DATE, 
	@In_Price MONEY, @Out_Price MONEY;

	DECLARE MyCursor_in_AddMed CURSOR FOR 
        SELECT *
	    FROM INSERTED
		WHERE [Количество] < 3

	OPEN MyCursor_in_AddMed;
	FETCH NEXT FROM MyCursor_in_AddMed INTO @Id, @IdMed, @INN, @Description, 
	@Count, @Date_Start, @Date_Finish, @In_Price, @Out_Price;
	WHILE @@FETCH_STATUS = 0
	BEGIN

	   --Здесь сработает первый триггер, поэтому беспокоиться не о чем.
       INSERT INTO [Заказ состоит из] VALUES (@IdMed, 1, @CountOrd);

	   --И так проверим каждую строку.
	   FETCH NEXT FROM MyCursor_in_AddMed INTO @Id, @IdMed, @INN, @Description, 
	   @Count, @Date_Start, @Date_Finish, @In_Price, @Out_Price;
	END;

	CLOSE MyCursor_in_AddMed;
	DEALLOCATE MyCursor_in_AddMed;
END;
GO

SELECT *
FROM [dbo].[Конкретное лекарство]
WHERE [Идентификационный номер конкретного лекарства] = 32

UPDATE [dbo].[Конкретное лекарство]
SET [Количество] -= 48
WHERE [Идентификационный номер конкретного лекарства] = 32

SELECT *
FROM [dbo].[Заказ состоит из]
WHERE [Номер заказа] = 18
