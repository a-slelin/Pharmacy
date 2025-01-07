--Создание двух имен входа.
CREATE LOGIN [User_a.slelin] WITH PASSWORD = '1234567',
DEFAULT_DATABASE = [PHARMACY], DEFAULT_LANGUAGE = [Русский], 
CHECK_POLICY = OFF

CREATE LOGIN [User1_a.slelin] WITH PASSWORD = '1234567',
DEFAULT_DATABASE = [PHARMACY], DEFAULT_LANGUAGE = [Русский], 
CHECK_POLICY = OFF

USE PHARMACY

--Создание двух пользователей.
CREATE USER [User_a.slelin] FOR LOGIN [User_a.slelin]

CREATE USER [User1_a.slelin] FOR LOGIN [User1_a.slelin]

--Создадим две роли.
CREATE ROLE [Менеджер]

CREATE ROLE [Бухгалтер]

--Добавим наших пользователь к ролям.
ALTER ROLE [Менеджер] ADD MEMBER [User_a.slelin]

ALTER ROLE [Бухгалтер] ADD MEMBER [User1_a.slelin]

/*Пропишем все что нужно для бухгалтера.
Наши бухгалтеры очень ответственные люди, им необходимо следить
в первую очередь за заказами в аптеку, поэтому им нужна много 
информации, касающейся заказов. Также помимо этого они формируют 
зарплату кассирам(более старшие бухгалтеры занимаются зарплатами 
всех сотрудников), которая естественным образом как то зависит от продаж
и их суммы. Из-за этого нужна некоторая информация для формирования зарплаты.
Также бухгалтеры делают отчёты о работе в форме представлений и используют 
процедуры и функции для итоговых отчётов.*/

GRANT SELECT, INSERT, UPDATE, DELETE ON [dbo].[Заказ] TO [Бухгалтер]
GRANT SELECT, INSERT, UPDATE, DELETE ON [dbo].[Заказ состоит из] TO [Бухгалтер]
GRANT SELECT ON [dbo].[Конкретное лекарство] TO [Бухгалтер]
GRANT SELECT ON [dbo].[Производитель] TO [Бухгалтер]

GRANT SELECT ON [dbo].[Продажа] TO [Бухгалтер]
GRANT SELECT ON [dbo].[Сотрудник] TO [Бухгалтер]
-------------------------------------------------------------------------------------------
GRANT EXECUTE TO [Бухгалтер] WITH GRANT OPTION
GRANT SELECT ON [dbo].[CheckMedWithDiseas] TO [Бухгалтер] WITH GRANT OPTION
GRANT SELECT ON [dbo].[CorrectProfit] TO [Бухгалтер] WITH GRANT OPTION
-------------------------------------------------------------------------------------------
GRANT CREATE VIEW TO [Бухгалтер]

/*Теперь пропишем, что может и не может менеджер.
Менеджер может для своих нужд создавать некоторые объекты базы данных, а также
имеет право выполнять любые функции и смотреть на всю информацию. Помимо этого он 
может изменять любым образом (не структуру) таблицы, которые не связаны с заказами, так как
ими занимаются бухгалтеры, или с продажами, которыми занимаются кассиры. Менять структуру
менеджеру нельзя, как и создавать бд или заниматься бэкапами.*/

GRANT CREATE TABLE, CREATE RULE, CREATE VIEW, CREATE PROCEDURE, EXECUTE TO [Менеджер] 

GRANT SELECT TO [Менеджер]
GRANT INSERT, UPDATE, DELETE ON [dbo].[Болезнь] TO [Менеджер]
GRANT INSERT, UPDATE, DELETE ON [dbo].[Знает как делать] TO [Менеджер]
GRANT INSERT, UPDATE, DELETE ON [dbo].[Конкретное лекарство] TO [Менеджер]
GRANT INSERT, UPDATE, DELETE ON [dbo].[Лекарство] TO [Менеджер]
GRANT INSERT, UPDATE, DELETE ON [dbo].[Производитель] TO [Менеджер]
GRANT INSERT, UPDATE, DELETE ON [dbo].[Сотрудник] TO [Менеджер]


