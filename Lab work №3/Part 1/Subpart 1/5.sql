/*Задание 1.5. 
Выбрать из таблиц информацию об объектах, 
в названиях которых нет заданной последовательности букв (LIKE).*/

--Найдем все кислоты
SELECT *
FROM [Лекарство]
WHERE [Название лекарства] LIKE '%кислота'

--Найдем всех менеджеров в аптеке
SELECT *
FROM [Сотрудник]
WHERE [Должность] LIKE  '%менеджер%'





