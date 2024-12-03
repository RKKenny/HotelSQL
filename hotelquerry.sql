/*Первый SELECT
Мы выбираем имя клиента, номер подтверждения, номер комнаты, даты прибытия и выезда,
количество дней, вид размещения, категорию номера, стоимость проживания и тариф.

Используем таблицы `Reservations` и `Reservations_Timelines`, связывая их
по полю `_ID` из `Reservations` и `_parentID` из `Reservations_Timelines`
с помощью FROM и JOIN.

Фильтруем записи, чтобы выбрать только те, у которых тариф "Base rate".

*/
SELECT 
    r.GuestName AS ИмяКлиента,
    r.ReservationId AS НомерПодтверждения,
    rt.Room AS НомерКомнаты,
    r.ArrivalDate AS ДатаПрибытия,
    r.DepartureDate AS ДатаВыезда,
    DATEDIFF(r.DepartureDate, r.ArrivalDate) AS КоличествоДней,
    r.GuestsLayout AS ВидРазмещения,
    rt.RoomTypeName AS Категория,
    rt.StayPrice AS СтоимостьПроживания,
    'Базовый тариф' AS Тариф
FROM 
    Reservations r
JOIN 
    Reservations_Timelines rt ON r._ID = rt._parentID
WHERE 
    rt.RateName = 'Base rate'

/*Объединяет результаты первого запроса с результатами второго запроса.
Используется UNION чтобы исключить дубликаты.*/

UNION

/*Аналогично первому запросу, но здесь мы выбираем даты начала и окончания временной рамки
для тарифа "Extra hours".

Фильтруем записи, чтобы выбрать только тариф "Extra hours".

Группируем результаты по всем выбранным полям.*/

SELECT 
    r.GuestName AS ИмяКлиента,
    r.ReservationId AS НомерПодтверждения,
    rt.Room AS НомерКомнаты,
    rt.TimelineDateStart AS ДатаПрибытия,
    rt.TimelineDateEnd AS ДатаВыезда,
    DATEDIFF(rt.TimelineDateEnd, rt.TimelineDateStart) AS КоличествоДней,
    r.GuestsLayout AS ВидРазмещения,
    rt.RoomTypeName AS Категория,
    rt.StayPrice AS СтоимостьПроживания,
    rt.RateName AS Тариф
FROM 
    Reservations r
JOIN 
    Reservations_Timelines rt ON r._ID = rt._parentID
WHERE 
    rt.RateName = 'Extra hours'
GROUP BY 
    r.GuestName,
    rt.StayPrice;

/*Технически, могли бы группировать вообще все, но в нашем примере это избыточно и очевидно.*/