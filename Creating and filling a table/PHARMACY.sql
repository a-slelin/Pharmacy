-----------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------Создание таблиц-------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE [Болезнь]
( 
[Идентификационный код болезни] INT IDENTITY(1,1) NOT NULL PRIMARY KEY, 
[Название болезни] NVARCHAR(100) NULL
)

CREATE TABLE [Лекарство]
(
[Идентификационный номер лекарства] INT IDENTITY(1,1) NOT NULL PRIMARY KEY, 
[Название лекарства] NVARCHAR(100) NULL, 
[Раздел] NVARCHAR(100) NULL, 
[Основное действующее вещество] NVARCHAR(100) NULL
)

CREATE TABLE [Производитель]
(
[ИНН] NVARCHAR(10) NOT NULL PRIMARY KEY CHECK([ИНН] LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'), 
[Название производителя] NVARCHAR(100) NULL
)

CREATE TABLE [Конкретное лекарство]
(
[Идентификационный номер конкретного лекарства] INT IDENTITY(1,1) NOT NULL PRIMARY KEY, 
[Идентификационный номер лекарства] INT NOT NULL FOREIGN KEY REFERENCES [Лекарство]([Идентификационный номер лекарства]), 
[ИНН(Производителя)] NVARCHAR(10) NOT NULL FOREIGN KEY REFERENCES [Производитель]([ИНН]), --
[Аннотация] NVARCHAR(250) NULL, 
[Количество] INT NULL DEFAULT(0) CHECK([Количество] >= 0),  
[Дата упаковки] DATE NULL,
[Дата срока годности] DATE NULL,
[Закупочная цена] MONEY NULL DEFAULT(0) CHECK([Закупочная цена] >= 0), 
[Цена для продажи] MONEY NULL DEFAULT(0) CHECK([Цена для продажи] >= 0)
)

CREATE TABLE [Сотрудник]
(
[ИНН] NVARCHAR(12) NOT NULL PRIMARY KEY CHECK([ИНН] LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
[ФИО] NVARCHAR(50) NULL,
[Паспортные данные] NVARCHAR(13) NOT NULL UNIQUE CHECK([Паспортные данные] LIKE '[0-9][0-9][0-9][0-9][ ][0-9][0-9][0-9][0-9][0-9][0-9]'),
[Должность] NVARCHAR(100) NULL,
[Номер телефона] NVARCHAR(11) NULL UNIQUE CHECK([Номер телефона] LIKE '[7][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
)

CREATE TABLE [Продажа]
(
[Номер продажи] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
[ИНН(Сотрудника)] NVARCHAR(12) NOT NULL FOREIGN KEY REFERENCES [Сотрудник]([ИНН]),
[Дата продажи] DATETIME NULL, 
[Общая сумма] MONEY NULL
)

CREATE TABLE [Заказ]
(
[Номер заказа] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
[ИНН(Сотрудника)] NVARCHAR(12) NOT NULL FOREIGN KEY REFERENCES [Сотрудник]([ИНН]),
[Дата заказа] DATETIME NULL,
[Сумма заказа] MONEY NULL  CHECK([Сумма заказа] >= 0)
)

CREATE TABLE [Лечит]
(
[Идентификационный код болезни] INT NOT NULL FOREIGN KEY REFERENCES [Болезнь]([Идентификационный код болезни]),
[Идентификационный номер лекарства] INT NOT NULL FOREIGN KEY REFERENCES [Лекарство]([Идентификационный номер лекарства]),
PRIMARY KEY([Идентификационный код болезни], [Идентификационный номер лекарства])
)

CREATE TABLE [Заказ состоит из]
(
[Идентификационный номер лекарства] INT NOT NULL FOREIGN KEY REFERENCES [Лекарство]([Идентификационный номер лекарства]),
[Номер заказа] INT NOT NULL FOREIGN KEY REFERENCES [Заказ]([Номер заказа]), 
[Количество] INT NULL CHECK([Количество] >= 0), 
PRIMARY KEY([Идентификационный номер лекарства], [Номер заказа])
)


CREATE TABLE [Продажа состоит из]
(
[Идентификационный номер конкретного лекарства] INT NOT NULL FOREIGN KEY REFERENCES [Конкретное лекарство]([Идентификационный номер конкретного лекарства]),
[Номер продажи] INT NOT NULL FOREIGN KEY REFERENCES [Продажа]([Номер продажи]),
[Количество] INT NULL CHECK([Количество] >= 0), 
PRIMARY KEY([Идентификационный номер конкретного лекарства], [Номер продажи])
)

CREATE TABLE [Знает как делать]
(
[Идентификационный номер лекарства] INT NOT NULL FOREIGN KEY REFERENCES [Лекарство]([Идентификационный номер лекарства]),
[ИНН(Производителя)] NVARCHAR(10) NOT NULL FOREIGN KEY REFERENCES [Производитель]([ИНН]),
PRIMARY KEY([Идентификационный номер лекарства], [ИНН(Производителя)])
)
-----------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------Заполняем Болезни-----------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
 INSERT INTO [Болезнь] VALUES 
('Гипотония'), --1
('Гипертония'), --2
('ОРВИ'), --3
('Грипп'), --4
('Простуда'), --5
('Сердечная недостаточность'), --6
('Бронхит'), --7
('Остеоартроз'), --8
('Аллергия'), --9
('Диарея'), --10
('Метаболизм'), --11
('Ангина'), --12
('Насморк'), --13
('Гастроэзофагеальный рефлюкс и язвенную болезнь'), --14
('Дефицит витамина B9'), --15
('Избыточное кровотечение'), --16
('Ковид-19'), --17 
('Рак') --18
-----------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------Заполняем Сотрудников-------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
INSERT INTO [Сотрудник] VALUES 
('787930136149', 'Бебнев Захар Ефимович', '4420 413208', 'Главный менеджер', '79667733092'), --1
('278521282856', 'Кылымныка Кира Антоновна', '4416 830558', 'Менеджер', '79189291681'), --2
('237036054889', 'Лубашева Сюзанна Климентьевна', '4359 240387', 'Бухгалтер', '79098469371'), --3
('647543544304', 'Ясенков Герман Трофимович', '4172 346821', 'Кассир', '79745527339'), --4
('671685248700', 'Яхонтова Ярослава Константиновна', '4737 976677', 'Кассир', '79422191151'), --5
('842487576835', 'Митасова Анфиса Аркадивна', '4265 429444', 'Кассир', '79515464645'), --6
('360286343811', 'Лагутов Иван Ефимович', '4210 967045', 'Кассир', '79515464659'), --7
('429992101190', 'Цирюльников Филипп Филиппович', '4752 760148', 'Уборщик', '79056137585'), --8
('201394775390', 'Беломестных Павел Семенович', '4563 471405', 'Бухгалтер', '79619124979'), --9
('826560804384', 'Вергунова Александра Севастьяновна', '4460 439052', 'Бухгалтер', '79467446421'), --10
('984593495309', 'Соколов Петр Александрович', '4245 729240', 'Проектный менеджер по маркетингу', '78901765432'), --11
('349573908402', 'Иванова Александра Игоревна', '4923 926927', 'Менеджер по продажам и клиентскому обслуживанию', '74567890123'), --12
('239479298349', 'Малышев Дмитрий Сергеевич', '4349 283629', 'ИТ-менеджер по информационной безопасности', '73210987654'), --13
('483877981105', 'Игнатов Прохор Маркович', '4672 992076', 'Бухгалтер', '76423737363'), --14
('114463565491', 'Справцев Роман Сергеевич', '4133 166291', 'Кассир', '79604205681'), --15
('282291385810', 'Фокин Афанасий Панкратович', '4719 264064', 'Главный Бухгалтер', '74694051277'), --16
('563981027086', 'Кочергин Даниил Викторович', '4388 992680', 'Бухгалтер', '79253066283'),--17
('363310664902', 'Карабатов Илья Власович', '4467 650917', 'Кассир', '77452675921'), --18
('160426840850', 'Живенков Михаил Ильич', '4915 911522', 'Старший Бухгалтер', '75541717753'), --19
('621221668164', 'Миров Игнат Ильич', '4083 321300', 'Кассир', '76076635893'), --20
('430266451178', 'Стегнова Марианна Ипполитовна', '4882 572404', 'Бухгалтер', '74260989254'), --21
('062004779485', 'Ярочкин Герасим Викторович', '4388 704220', 'Кассир', '75692194301') --22
-----------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------Заполняем Производителей----------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
INSERT INTO [Производитель] VALUES 
('1270510540', 'Медикорп'), --1
('5143221279', 'Фармагенекс'), --2
('5533875414', 'Фармавита'), --3
('7679074326', 'Фармацевтическая индустрия'), --4
('3495720209', 'Медиатика'), --5 
('8478569190', 'ФармаЛайн'), --6
('0158007889', 'Генефарм'), --7
('2887676065', 'МедФарма'), --8
('2393847293', 'ФармЛайф'), --9
('7539442890', 'ФармаЛаб'), --10
('0826255394', 'ФармаКленз'), --11
('8183115667', 'МедиМекал') --12
-----------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------Заполняем Лекарства---------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
INSERT INTO [Лекарство] VALUES 
('Цитрамон П', 'Препараты нормализации артериального давления', 'Ацетилсалициловая кислота'), --1
('Кофеин-бензонат натрия', 'Препараты нормализации артериального давления', 'Кофеин'), --2
('Валидол', 'Сердечно-сосудистое', 'Левоментол'), --3
('Анальгин', 'Обезболивающее', 'Метамизол натрия'), --4
('Гриппферон', 'Противовирусные', 'Интерферон альфа'), --5
('Парацетамол', 'Жаропонижающее', 'Парацетамол'), --6
('Ацетилсалициловая кислота', 'Жаропонижающее', 'Ацетилсалициловая кислота'), --7
('Арпефлю', 'Противовирусные', 'Умиферомин'), --8
('Ибуклин', 'Противовирусные', 'Ибупрофен'), --9
('Флуимуцил', 'Стимулятор моторной функции дыхательных путей', 'Ацетилцестеин'), --10
('Нимесулид', 'Противовоспалительные', 'Нимесулид'), --11
('Амелотекс', 'Противовоспалительные', 'Мелоксикам'), --12
('Зитрек', 'Противоаллергенные', 'Мелоксикам'), --13
('Цетрин', 'Противоаллергенные', 'Цетиризин'), --14
('Кларидол', 'Противоаллергенные', 'Лоратадин'), --15
('Но-шпа', 'Спазмолитический препарат', 'Дротаверин'), --16
('Смекта', 'Спазмолитический препарат', 'Смектит диоктаэдрический'), --17
('Лоперамид', 'Противодиарейное', 'Лоперамид'), --18
('Уголь активированный', 'Противодиарейное', 'Уголь активированный'), --19
('Амоксициллин', 'Антибиотик', 'Пловлатутин'), -- 20
('Отривин', 'Против насморка', 'Физипропан'), --21
('РиноСтоп', 'Против насморка', 'Алоэ'), --22
('Амоксиклав', 'Противовоспалительные', 'Камридий'), ----23
('Риновир', 'Против насморка', 'Физипропан'), --24
('Альгиновая кислота', 'Препараты для лечения гастроэзофагеального рефлюкса и язвенной болезни', 'Карендом'), --25
('Фолиевая кислота', 'Витамины', 'Витамин B9'), --26
('Транексамовая кислота', 'Гемостатики и антифибринолитики', 'Полиминол'), --27
('Спазмотекс-Д', 'Миотропные средства', 'Дротаверин'), --28
('Дротакальм', 'Ингибиторы фосфодиэстеразы', 'Дротаверин')  --29
-----------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------Заполняем Конкретные лекарства----------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
INSERT INTO [Конкретное лекарство] VALUES 
(1, '0158007889', 'Аннотация лекарства №1.', 0, '2022-10-08', '2025-10-08', 440, 469), --1
(1, '0826255394', 'Аннотация лекарства №2.', 0, '2022-10-08', '2024-10-08', 440, 469), --2
(1, '5143221279', 'Аннотация лекарства №3.', 0, '2022-10-08', '2025-10-08', 433, 462), --3
(1, '7539442890', 'Аннотация лекарства №4.', 0, '2022-10-08', '2025-10-08', 444, 473), --4

(2, '7679074326', 'Аннотация лекарства №5.', 53, '2022-10-08', '2023-12-08', 869, 1002), --5
(2, '2887676065', 'Аннотация лекарства №6.', 75, '2022-10-08', '2023-12-08', 883, 1016), --6
(2, '1270510540', 'Аннотация лекарства №7.', 75, '2022-10-08', '2023-12-08', 899, 1032), --7

(3, '0158007889', 'Аннотация лекарства №8.', 0, '2022-10-08', '2026-10-08', 298, 434), --8
(3, '0826255394', 'Аннотация лекарства №9.', 0, '2022-10-08', '2026-10-08', 285, 421), --9

(4, '5143221279', 'Аннотация лекарства №10.', 66, '2022-10-08', '2024-10-08', 966, 997), --10
(4, '8478569190', 'Аннотация лекарства №11.', 12, '2022-10-08', '2025-10-08', 951, 982), --11
(4, '8183115667', 'Аннотация лекарства №12.', 18, '2022-10-08', '2025-10-08', 944, 975), --12
(4, '2887676065', 'Аннотация лекарства №13.', 48, '2022-10-08', '2026-10-08', 931, 962), --13
(4, '1270510540', 'Аннотация лекарства №14.', 99, '2022-10-08', '2025-10-08', 989, 1020), --14

(5, '8478569190', 'Аннотация лекарства №15.', 16, '2022-10-08', '2030-10-08', 350, 427), --15
(5, '5533875414', 'Аннотация лекарства №16.', 30, '2022-10-08', '2030-10-08', 352, 429), --16
(5, '5143221279', 'Аннотация лекарства №17.', 25, '2022-10-08', '2030-10-08', 389, 466), --17
(5, '8183115667', 'Аннотация лекарства №18.', 40, '2022-10-08', '2029-10-08', 350, 427), --18

(6, '0158007889', 'Аннотация лекарства №19.', 24, '2022-10-08', '2024-10-08', 900, 1076), --19
(6, '0826255394', 'Аннотация лекарства №20.', 90, '2022-10-08', '2025-10-08', 936, 1112), --20
(6, '8478569190', 'Аннотация лекарства №21.', 88, '2022-10-08', '2024-10-08', 938, 1114), --21

(7, '8478569190', 'Аннотация лекарства №22.', 45, '2022-10-08', '2026-10-08', 585, 737), --22
(7, '7679074326', 'Аннотация лекарства №23.', 23, '2022-10-08', '2026-10-08', 576, 728), --23
(7, '1270510540', 'Аннотация лекарства №24.', 85, '2022-10-08', '2026-10-08', 587, 739), --24
(7, '8183115667', 'Аннотация лекарства №25.', 24, '2022-10-08', '2026-10-08', 593, 745), --25

(8, '8183115667', 'Аннотация лекарства №26.', 11, '2022-10-08', '2028-10-08', 556, 753), --26
(8, '5143221279', 'Аннотация лекарства №27.', 85, '2022-10-08', '2028-10-08', 531, 728), --27
(8, '2887676065', 'Аннотация лекарства №28.', 52, '2022-10-08', '2028-10-08', 534, 731), --28
(8, '7679074326', 'Аннотация лекарства №29.', 93, '2022-10-08', '2028-10-08', 546, 743), --29
(8, '8478569190', 'Аннотация лекарства №30.', 46, '2022-10-08', '2023-12-08', 524, 721), --30

(9, '1270510540', 'Аннотация лекарства №31.', 72, '2022-10-08', '2025-10-08', 348, 426), --31
(9, '8478569190', 'Аннотация лекарства №32.', 49, '2022-10-08', '2025-10-08', 359, 437), --32

(10, '0158007889', 'Аннотация лекарства №33.', 99, '2022-10-08', '2025-10-08', 888, 947), --33
(10, '8183115667', 'Аннотация лекарства №34.', 29, '2022-10-08', '2027-10-08', 854, 913), --34
(10, '5533875414', 'Аннотация лекарства №35.', 89, '2022-10-08', '2027-10-08', 874, 933), --35
(10, '8478569190', 'Аннотация лекарства №36.', 44, '2022-10-08', '2025-10-08', 834, 893), --36
(10, '2887676065', 'Аннотация лекарства №37.', 84, '2022-10-08', '2025-10-08', 846, 905), --37
(10, '0826255394', 'Аннотация лекарства №38.', 36, '2022-10-08', '2026-10-08', 797, 856), --38

(11, '8478569190', 'Аннотация лекарства №39.', 65, '2022-10-08', '2023-10-08', 1019, 1080), --39
(11, '7539442890', 'Аннотация лекарства №40.', 17, '2022-10-08', '2023-10-08', 1025, 1086), --40
(11, '8183115667', 'Аннотация лекарства №41.', 88, '2022-10-08', '2023-10-08', 936, 997), --41
(11, '5533875414', 'Аннотация лекарства №42.', 90, '2022-10-08', '2023-10-08', 955, 1076), --42

(12, '8478569190', 'Аннотация лекарства №43.', 100, '2022-10-08', '2027-10-08', 971, 1051), --43
(12, '8183115667', 'Аннотация лекарства №44.', 14, '2022-10-08', '2027-10-08', 1017, 1107), --44
(12, '2887676065', 'Аннотация лекарства №45.', 61, '2022-10-08', '2027-10-08', 1008, 1098), --45

(13, '0826255394', 'Аннотация лекарства №46.', 35, '2022-10-08', '2023-12-08', 1107, 1226), --46

(14, '8478569190', 'Аннотация лекарства №47.', 82, '2022-10-08', '2024-10-08', 1176, 1272), --47
(14, '7679074326', 'Аннотация лекарства №48.', 81, '2022-10-08', '2024-10-08', 1078, 1174), --48
(14, '8183115667', 'Аннотация лекарства №49.', 35, '2022-10-08', '2024-10-08', 1289, 1385), --49
(14, '5533875414', 'Аннотация лекарства №50.', 81, '2022-10-08', '2024-10-08', 1122, 1218), --50

(15, '0158007889', 'Аннотация лекарства №51.', 46, '2022-10-08', '2026-10-08', 1255, 1327), --51
(15, '1270510540', 'Аннотация лекарства №52.', 66, '2022-10-08', '2026-10-08', 1339, 1411), --52
(15, '8183115667', 'Аннотация лекарства №53.', 90, '2022-10-08', '2026-10-08', 1429, 1501), --53
(15, '7539442890', 'Аннотация лекарства №54.', 91, '2022-10-08', '2026-10-08', 1427, 1499), --54
(15, '2887676065', 'Аннотация лекарства №55.', 77, '2022-10-08', '2025-10-08', 1241, 1313), --55
(15, '0826255394', 'Аннотация лекарства №56.', 38, '2022-10-08', '2026-10-08', 1469, 1541), --56
(15, '5143221279', 'Аннотация лекарства №57.', 48, '2022-10-08', '2026-10-08', 1252, 1324), --57
(15, '7679074326', 'Аннотация лекарства №58.', 15, '2022-10-08', '2026-10-08', 1480, 1552), --58
(15, '8478569190', 'Аннотация лекарства №59.', 32, '2022-10-08', '2026-10-08', 1157, 1229), --59

(16, '8478569190', 'Аннотация лекарства №60.', 100, '2022-10-08', '2027-10-08', 332, 356), --60
(16, '5533875414', 'Аннотация лекарства №61.', 77, '2022-10-08', '2027-10-08', 298, 322), --61
(16, '8183115667', 'Аннотация лекарства №62.', 37, '2022-10-08', '2027-10-08', 332, 356), --62

(17, '7679074326', 'Аннотация лекарства №63.', 41, '2022-10-08', '2026-10-08', 880, 1035), --63
(17, '0826255394', 'Аннотация лекарства №64.', 92, '2022-10-08', '2026-10-08', 825, 980), --64

(18, '1270510540', 'Аннотация лекарства №65.', 76, '2022-10-08', '2029-10-08', 779, 886), --65

(19, '5143221279', 'Аннотация лекарства №66.', 41, '2022-10-08', '2023-12-08', 684, 795), --66
(19, '0158007889', 'Аннотация лекарства №67.', 80, '2022-10-08', '2025-10-08', 701, 812), --67

(20, '5533875414', 'Аннотация лекарства №68.', 67, '2022-10-08', '2025-10-08', 771, 822), --68

(21, '3495720209', 'Аннотация лекарства №69.', 0, '2023-12-08', '2026-12-08', 456, 496), --69 
(21, '8478569190', 'Аннотация лекарства №70.', 25, '2023-12-08', '2026-12-08', 478, 512), --70

(22, '2393847293', 'Аннотация лекарства №71.', 0, '2022-10-08', '2025-10-08', 324, 401), --71 
(22, '1270510540', 'Аннотация лекарства №72.', 9, '2022-10-08', '2025-10-08', 322, 399), --72

(23, '2393847293', 'Аннотация лекарства №73.', 0, '2022-10-08', '2025-10-08', 945, 1029), --73 
(23, '5143221279', 'Аннотация лекарства №74.', 67, '2022-10-08', '2025-10-08', 899, 999), --74

(24, '3495720209', 'Аннотация лекарства №75.', 0, '2022-10-08', '2025-10-08', 74, 121), --75 
(24, '7539442890', 'Аннотация лекарства №76.', 98, '2023-12-08', '2026-12-08', 69, 115),--76

(28, '1270510540', 'Аннотация лекарства №77.', 0,'2022-10-08','2026-10-08', 100, 130), --77

(29, '1270510540', 'Аннотация лекарства №78.', 0,'2022-10-08','2027-10-08', 253, 302) --78
-----------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------Заполняем Заказы------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
INSERT INTO [Заказ] VALUES 
('201394775390', '2022-13-10 12:34:50.454', 327682), --1
('201394775390', '2022-05-09 15:41:49.827', 149847), --2
('201394775390', '2022-30-01 12:21:21.730', 163274), --3

('237036054889', '2022-03-08 14:30:30.755', 174605), --4
('237036054889', '2022-23-05 18:12:57.506', 73462), --5
('237036054889', '2022-01-02 12:09:03.969', 236897), --6

('826560804384', '2022-12-03 16:04:37.106', 65310), --7
('826560804384', '2022-04-07 16:15:00.535', 69175), --8
('826560804384', '2022-25-06 10:55:54.977', 149821), --9
('826560804384', '2022-09-04 11:30:52.888', 36366), --10

('282291385810', '2023-24-08 12:09:43.123', 407564), --11
('282291385810', '2023-10-03 10:56:21.130', 323811), --12


('160426840850', '2023-12-06 14:22:54.393', 126834), --13
('160426840850', '2023-01-02 16:04:41.549', 29504), --14
('160426840850', '2023-14-12 17:32:09.874', 127875), --15
('160426840850', '2023-05-04 12:34:01.132', 300119) --16
-----------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------Заполняем Продажи-----------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
INSERT INTO [Продажа] VALUES
('360286343811', '2023-20-10 18:50:57.699', 3002), --1
('360286343811', '2023-17-07 12:08:50.942', 3590), --2
('360286343811', '2023-28-01 12:53:02.841', 1848), --3

('647543544304', '2023-17-06 13:22:15.433', 8202), --4
('647543544304', '2023-17-08 10:55:00.896', 3869), --5
('647543544304', '2023-26-02 17:12:09.474', 2023), --6

('671685248700', '2023-13-03 09:43:34.519', 7822), --7
('671685248700', '2023-12-09 13:26:30.813', 854), --8

('842487576835', '2023-16-04 13:24:44.852', 4750), --9 
('842487576835', '2022-08-05 17:58:53.502', 5564), --10

('160426840850', '2023-09-09 13:34:23.205', 7449), --11
('160426840850', '2023-04-11 13:34:23.205', 6303), --12

('282291385810', '2023-23-03 13:34:23.205', 1226), --13
('282291385810', '2023-12-12 13:34:23.205', 8762), --14

('360286343811', '2023-29-11 11:54:02.841', 3573), --15

('671685248700', '2023-29-11 14:23:09.841', 8760), --16
('671685248700', '2023-29-11 10:12:34.365', 1960), --17

('647543544304', '2023-29-11 16:21:02.258', 11053), --18
('647543544304', '2023-29-11 18:53:33.943', 3834) --19
-----------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------Заполняем Лечит-----------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
INSERT INTO [Лечит] VALUES 
(1, 1), --1
(2, 2), --2
(6, 3), --3
(3, 4), --4
(4, 4), --5
(5, 4), --6
(3, 5), --7
(4, 5), --8
(5, 5), --9
(3, 6), --10
(4, 6), --11
(5, 6), --12
(3, 7), --13
(4, 7), --14
(5, 7), --15
(3, 8), --16
(4, 8), --17
(5, 8), --18
(7, 8), --19
(4, 9), --20
(5, 9), --21
(7, 10), --22
(8, 11), --23
(8, 12), --24
(9, 13), --25
(9, 14), --26
(9, 15), --27
(11, 16), --28
(10, 17), --29
(10, 18), --30
(11, 18), --31
(10, 19), --32
(12, 20), --33 
(13, 21), --34
(13, 22), --35
(12, 23), --36
(13, 24), --37
(14, 25), --38
(15, 26), --39
(16, 27) --40
-----------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------Заполняем Знает как делать--------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
INSERT INTO [Знает как делать] VALUES 
(1, '0158007889'), --1
(1, '0826255394'), --2
(1, '5143221279'), --3
(1, '7539442890'), --4

(2, '7679074326'), --5
(2, '2887676065'), --6
(2, '1270510540'), --7

(3, '0158007889'), --8
(3, '0826255394'), --9

(4, '5143221279'), --10
(4, '8478569190'), --11
(4, '8183115667'), --12
(4, '2887676065'), --13
(4, '1270510540'), --14

(5, '8478569190'), --15
(5, '5533875414'), --16
(5, '5143221279'), --17
(5, '8183115667'), --18

(6, '0158007889'), --19
(6, '0826255394'), --20
(6, '8478569190'), --21

(7, '8478569190'), --22
(7, '7679074326'), --23
(7, '1270510540'), --24
(7, '8183115667'), --25

(8, '8183115667'), --26
(8, '5143221279'), --27
(8, '2887676065'), --28
(8, '7679074326'), --29
(8, '8478569190'), --30

(9, '1270510540'), --31
(9, '8478569190'), --32

(10, '0158007889'), --33
(10, '8183115667'), --34
(10, '5533875414'), --35
(10, '8478569190'), --36
(10, '2887676065'), --37
(10, '0826255394'), --38

(11, '8478569190'), --39
(11, '7539442890'), --40
(11, '8183115667'), --41
(11, '5533875414'), --42

(12, '8478569190'), --43
(12, '8183115667'), --44
(12, '2887676065'), --45

(13, '0826255394'), --46

(14, '8478569190'), --47
(14, '7679074326'), --48
(14, '8183115667'), --49
(14, '5533875414'), --50

(15, '0158007889'), --51
(15, '1270510540'), --52
(15, '8183115667'), --53
(15, '7539442890'), --54
(15, '2887676065'), --55
(15, '0826255394'), --56
(15, '5143221279'), --57
(15, '7679074326'), --58
(15, '8478569190'), --59

(16, '8478569190'), --60
(16, '5533875414'), --61
(16, '8183115667'), --62

(17, '7679074326'), --63
(17, '0826255394'), --64
(18, '1270510540'), --65

(19, '5143221279'), --66
(19, '0158007889'), --67

(20, '3495720209'), --68
(20, '2393847293'), --69

(21, '8183115667'), --70

(22, '5143221279'), --71
(22, '2393847293'), --72

(23, '0158007889'), --73
(23, '3495720209'), --74
(23, '1270510540'), --75

(24, '5143221279'), --76
(24, '3495720209'), --77
(24, '2393847293'), --78

(25, '2393847293'), --79
(25, '0158007889'), --80
(25, '5143221279'), --81

(26, '1270510540'), --82
(26, '8478569190'), --83
(26, '5533875414'), --84
(26, '2887676065'), --85

(27, '7679074326'), --86

(28, '1270510540'), --87
(29, '1270510540') --88
-----------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------Заполняем Заказ состоит из--------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
INSERT INTO [Заказ состоит из] VALUES 
(18, 1, 14), --1
(10, 1, 4), --2
(16, 1, 40), --3
(1, 1, 46), --4

(1, 2, 22), --5
(3, 2, 2), --6
(17, 2, 47), --7

(3, 3, 8), --8
(14, 3, 34), --9

(16, 4, 6), --10
(9, 4, 15), --11
(4, 4, 14), --12
(12, 4, 24), --13
(19, 4, 14), --14

(11, 5, 4), --15
(9, 5, 9), --16
(18, 5, 33), --17
(3, 5, 44), --18

(9, 6, 38), --19
(6, 6, 48), --20
(2, 6, 29), --21

(14, 7, 14), --22

(16, 8, 10), --23
(19, 8, 43), --24

(2, 9, 31), --25
(14, 9, 12), --26
(3, 9, 20), --27

(5, 10, 22), --28
(3, 10, 8), --29

(3, 11, 12), --30
(23, 11, 84), --31
(12, 11, 82), --32

(2, 12, 45), --33
(8, 12, 76), --34

(3, 13, 90), --35
(20, 13, 92), --36
(24, 13, 24), --37

(23, 14, 16), --38

(17, 15, 75), --39

(2, 16, 85), --40
(18, 16, 96) --41
-----------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------Заполняем Продажа состоит из------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
INSERT INTO [dbo].[Продажа состоит из] VALUES 
(16, 1, 2), --1
(7, 1, 1), --2
(20, 1, 1), --3

(28, 2, 2), --4
(45, 2, 1), --5
(7, 2, 1), --6

(49, 3, 1), --7
(3, 3, 1), --8

(3, 4, 1), --9
(21, 4, 1), --10
(36, 4, 4), --11
(43, 4, 1), --12
(5, 4, 2), --13

(16, 5, 1), --14
(5, 5, 3), --15
(8, 5, 1), --16

(33, 6, 1), --17
(19, 6, 1), --18

(52, 7, 2), --19

(31, 8, 1), --20
(16, 8, 1), --21

(29, 9, 1), --22
(51, 9, 1), --23
(44, 9, 2), --24
(1, 9, 1), --25

(51, 10, 1), --26
(47, 10, 3), --27
(9, 10, 1), --28

(24, 11, 4), --30
(62, 11, 9), --31
(16, 11, 3), --32

(63, 12, 2), --33
(52, 12, 3), --34

(46, 13, 1), --35

(14, 14, 3), --36
(42, 14, 5), --37
(61, 14, 1), --38

(44, 15, 1), --39
(68, 15, 3), --40

(28, 16, 3), --41
(46, 16, 5), --42
(32, 16, 1), --43

(64, 17, 2), --44

(7, 18, 4), --45
(49, 18, 5), --46

(4, 19, 2), --47
(39, 19, 2), --48
(27, 19, 1) --49
-----------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------База данных создана---------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------