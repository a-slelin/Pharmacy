/*Задание D).
Найти все лекарства от ангины и насморка.*/

SELECT [Идентификационный номер конкретного лекарства], [Название лекарства], [Раздел], [Цена для продажи]
FROM [Конкретное лекарство] INNER JOIN [Лекарство]
ON [Конкретное лекарство].[Идентификационный номер лекарства] = [Лекарство].[Идентификационный номер лекарства] INNER JOIN [Лечит]
ON [Лекарство].[Идентификационный номер лекарства] = [Лечит].[Идентификационный номер лекарства] INNER JOIN [Болезнь]
ON [Лечит].[Идентификационный код болезни] = [Болезнь].[Идентификационный код болезни]
WHERE [Болезнь].[Название болезни] = 'Насморк' OR [Болезнь].[Название болезни] = 'Ангина'