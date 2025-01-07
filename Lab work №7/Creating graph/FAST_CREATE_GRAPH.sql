CREATE TABLE [Болезнь_Граф]
( 
[Идентификационный код болезни] INT IDENTITY(1,1) NOT NULL PRIMARY KEY, 
[Название болезни] NVARCHAR(100) NULL
) AS NODE

CREATE TABLE [Лекарство_Граф]
(
[Идентификационный номер лекарства] INT IDENTITY(1,1) NOT NULL PRIMARY KEY, 
[Название лекарства] NVARCHAR(100) NULL, 
[Раздел] NVARCHAR(100) NULL, 
[Основное действующее вещество] NVARCHAR(100) NULL
) AS NODE

CREATE TABLE [Производитель_Граф]
(
[ИНН] NVARCHAR(10) NOT NULL PRIMARY KEY CHECK([ИНН] LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'), 
[Название производителя] NVARCHAR(100) NULL
) AS NODE

CREATE TABLE [Конкретное лекарство_Граф]
(
[Идентификационный номер конкретного лекарства] INT IDENTITY(1,1) NOT NULL PRIMARY KEY, 
[Аннотация] NVARCHAR(250) NULL, 
[Количество] INT NULL DEFAULT(0) CHECK([Количество] >= 0),  
[Дата упаковки] DATE NULL,
[Дата срока годности] DATE NULL,
[Закупочная цена] MONEY NULL DEFAULT(0) CHECK([Закупочная цена] >= 0), 
[Цена для продажи] MONEY NULL DEFAULT(0) CHECK([Цена для продажи] >= 0)
) AS NODE

CREATE TABLE [Сотрудник_Граф]
(
[ИНН] NVARCHAR(12) NOT NULL PRIMARY KEY CHECK([ИНН] LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
[ФИО] NVARCHAR(50) NULL,
[Паспортные данные] NVARCHAR(13) NOT NULL UNIQUE CHECK([Паспортные данные] LIKE '[0-9][0-9][0-9][0-9][ ][0-9][0-9][0-9][0-9][0-9][0-9]'),
[Должность] NVARCHAR(100) NULL,
[Номер телефона] NVARCHAR(11) NULL UNIQUE CHECK([Номер телефона] LIKE '[7][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
) AS NODE

CREATE TABLE [Продажа_Граф]
(
[Номер продажи] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
[Дата продажи] DATETIME NULL, 
[Общая сумма] MONEY NULL
) AS NODE

CREATE TABLE [Заказ_Граф]
(
[Номер заказа] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
[Дата заказа] DATETIME NULL,
[Сумма заказа] MONEY NULL  CHECK([Сумма заказа] >= 0)
) AS NODE

CREATE TABLE [Лечит_Граф] AS EDGE
CREATE TABLE [Заказ состоит из_Граф] ([Количество] INT) AS EDGE
CREATE TABLE [Продажа состоит из_Граф] ([Количество] INT) AS EDGE
CREATE TABLE [Знает как делать_Граф] AS EDGE
CREATE TABLE [Производит_Граф] AS EDGE
CREATE TABLE [Содержит информацию_Граф] AS EDGE
CREATE TABLE [Сделать заказ_Граф] AS EDGE
CREATE TABLE [Сделать продажу_Граф] AS EDGE

INSERT INTO [Болезнь_Граф] 
    SELECT [Название болезни] FROM [dbo].[Болезнь]

INSERT INTO [Лекарство_Граф]
    SELECT [Название лекарства], [Раздел],
    [Основное действующее вещество]
	FROM [dbo].[Лекарство]

INSERT INTO [Производитель_Граф]
    SELECT * FROM [dbo].[Производитель]

INSERT INTO [Конкретное лекарство_Граф]
    SELECT [Аннотация], [Количество], 
    [Дата упаковки], [Дата срока годности],
    [Закупочная цена], [Цена для продажи]
	FROM [dbo].[Конкретное лекарство]

INSERT INTO [Сотрудник_Граф]
    SELECT * FROM [dbo].[Сотрудник]

INSERT INTO [Продажа_Граф]
    SELECT [Дата продажи], [Общая сумма]
	FROM [dbo].[Продажа]

INSERT INTO [Заказ_Граф]
    SELECT [Дата заказа], [Сумма заказа]
	FROM [dbo].[Заказ]
--------------------------------------------------------------------------------------------
DECLARE @Dis INT, @Med INT;

DECLARE MyCursor CURSOR FOR 
    SELECT * FROM [dbo].[Лечит]
OPEN MyCursor;
FETCH NEXT FROM MyCursor INTO @Dis, @Med;
WHILE @@FETCH_STATUS = 0
BEGIN
    INSERT INTO [Лечит_Граф] VALUES
        ((SELECT $node_id FROM [dbo].[Лекарство_Граф]  WHERE [Идентификационный номер лекарства] = @Med), 
        (SELECT $node_id FROM [dbo].[Болезнь_Граф] WHERE [Идентификационный код болезни] = @Dis))

    FETCH NEXT FROM MyCursor INTO @Dis, @Med;
END
CLOSE MyCursor;
DEALLOCATE MyCursor;
---------------------------------------------------------------------------------------------
DECLARE @Sup NVARCHAR(MAX);

DECLARE MyCursor2 CURSOR FOR 
    SELECT * FROM [dbo].[Знает как делать]
OPEN MyCursor2;
FETCH NEXT FROM MyCursor2 INTO @Med, @Sup;
WHILE @@FETCH_STATUS = 0
BEGIN
    INSERT INTO [Знает как делать_Граф] VALUES 
        ((SELECT $node_id FROM [dbo].[Производитель_Граф] WHERE [ИНН] = @Sup), 
		(SELECT $node_id FROM [dbo].[Лекарство_Граф] WHERE [Идентификационный номер лекарства] = @Med))

    FETCH NEXT FROM MyCursor2 INTO @Med, @Sup;
END
CLOSE MyCursor2;
DEALLOCATE MyCursor2;
-------------------------------------------------------------------------------------------------
DECLARE @Ord INT, @Count INT;

DECLARE MyCursor3 CURSOR FOR 
    SELECT * FROM [dbo].[Заказ состоит из]
OPEN MyCursor3;
FETCH NEXT FROM MyCursor3 INTO @Med, @Ord, @Count;
WHILE @@FETCH_STATUS = 0
BEGIN
    INSERT INTO [Заказ состоит из_Граф] VALUES 
        ((SELECT $node_id FROM [dbo].[Заказ_Граф] WHERE [Номер заказа] = @Ord), 
		(SELECT $node_id FROM [dbo].[Лекарство_Граф] WHERE [Идентификационный номер лекарства] = @Med), @Count)

    FETCH NEXT FROM MyCursor3 INTO @Med, @Ord, @Count;
END
CLOSE MyCursor3;
DEALLOCATE MyCursor3;
-------------------------------------------------------------------------------------------------
DECLARE @Spec_Med INT, @Sale INT;

DECLARE MyCursor4 CURSOR FOR 
    SELECT * FROM [dbo].[Продажа состоит из]
OPEN MyCursor4;
FETCH NEXT FROM MyCursor4 INTO @Spec_Med, @Sale, @Count;
WHILE @@FETCH_STATUS = 0
BEGIN
    INSERT INTO [Продажа состоит из_Граф] VALUES 
        ((SELECT $node_id FROM [dbo].[Продажа_Граф] WHERE [Номер продажи] = @Sale), 
		(SELECT $node_id FROM [dbo].[Конкретное лекарство_Граф]  WHERE [Идентификационный номер конкретного лекарства] = @Spec_Med), @Count)

    FETCH NEXT FROM MyCursor4 INTO @Spec_Med, @Sale, @Count;
END
CLOSE MyCursor4;
DEALLOCATE MyCursor4;
-------------------------------------------------------------------------------------------------
DECLARE MyCursor5 CURSOR FOR 
    SELECT [Идентификационный номер конкретного лекарства], 
    [Идентификационный номер лекарства], [ИНН(Производителя)]
	FROM [dbo].[Конкретное лекарство]
OPEN MyCursor5;
FETCH NEXT FROM MyCursor5 INTO @Spec_Med, @Med, @Sup;
WHILE @@FETCH_STATUS = 0
BEGIN
    INSERT INTO [Производит_Граф] VALUES
        ((SELECT $node_id FROM [dbo].[Производитель_Граф] WHERE [ИНН] = @Sup), 
        (SELECT $node_id FROM [dbo].[Конкретное лекарство_Граф]  WHERE [Идентификационный номер конкретного лекарства] = @Spec_Med))

    
    INSERT INTO [Содержит информацию_Граф] VALUES
        ((SELECT $node_id FROM [dbo].[Лекарство_Граф] WHERE [Идентификационный номер лекарства] = @Med), 
        (SELECT $node_id FROM [dbo].[Конкретное лекарство_Граф]  WHERE [Идентификационный номер конкретного лекарства] = @Spec_Med))

    FETCH NEXT FROM MyCursor5 INTO @Spec_Med, @Med, @Sup;
END
CLOSE MyCursor5;
DEALLOCATE MyCursor5;
-------------------------------------------------------------------------------------------------
DECLARE @Emp NVARCHAR(MAX);

DECLARE MyCursor6 CURSOR FOR 
    SELECT [Номер заказа], [ИНН(Сотрудника)] 
	FROM [dbo].[Заказ]
OPEN MyCursor6;
FETCH NEXT FROM MyCursor6 INTO @Ord, @Emp;
WHILE @@FETCH_STATUS = 0
BEGIN
    INSERT INTO [Сделать заказ_Граф] VALUES 
       ((SELECT $node_id FROM [dbo].[Сотрудник_Граф]  WHERE [ИНН] = @Emp),
       (SELECT $node_id FROM [dbo].[Заказ_Граф] WHERE [Номер заказа] = @Ord))

    FETCH NEXT FROM MyCursor6 INTO @Ord, @Emp;
END
CLOSE MyCursor6;
DEALLOCATE MyCursor6;
-------------------------------------------------------------------------------------------------
DECLARE MyCursor7 CURSOR FOR 
    SELECT [Номер продажи], [ИНН(Сотрудника)] 
	FROM [dbo].[Продажа]
OPEN MyCursor7;
FETCH NEXT FROM MyCursor7 INTO @Sale, @Emp;
WHILE @@FETCH_STATUS = 0
BEGIN
    INSERT INTO [dbo].[Сделать продажу_Граф] VALUES 
        ((SELECT $node_id FROM [dbo].[Сотрудник_Граф]  WHERE [ИНН] = @Emp),
        (SELECT $node_id FROM [dbo].[Продажа_Граф] WHERE [Номер продажи] = @Sale))

    FETCH NEXT FROM MyCursor7 INTO @Sale, @Emp;
END
CLOSE MyCursor7;
DEALLOCATE MyCursor7;