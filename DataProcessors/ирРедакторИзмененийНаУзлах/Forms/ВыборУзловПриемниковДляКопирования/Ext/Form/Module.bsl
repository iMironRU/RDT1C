﻿
Процедура ОсновныеДействияФормыОК(Кнопка)
	
	ВыбранныеУзлыПриемники = УзлыПриемники.Скопировать(Новый Структура("Пометка", Истина)).ВыгрузитьКолонку("Ссылка");
	ирОбщий.СкопироватьРаспределитьРегистрациюИзмененийПоУзламЛкс(УзелИсточник, ВыбранныеУзлыПриемники, ВариантКопирования = 1, , ОбъектыМД);
	Закрыть(Истина);
	
КонецПроцедуры

Процедура ОсновныеДействияФормыОтмена(Кнопка)
	
	Закрыть();
	
КонецПроцедуры

Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	
	ирОбщий.ЗагрузитьВТаблицуЗначенийЛкс(Узлы, УзлыПриемники, , Новый Структура("Пометка", Ложь));
	ЭтаФорма.ПланОбменаИсточника = УзелИсточник.Метаданные().Имя;
	
КонецПроцедуры

Процедура КоманднаяПанель1ДобавитьНесуществующийУзел(Кнопка)
	
	Если Не ЗначениеЗаполнено(ИмяПланОбмена) Тогда
		Возврат;
	КонецЕсли; 
	СтрокаУзла = УзлыПриемники.Добавить();
	СтрокаУзла.Ссылка = ПланыОбмена[ИмяПланОбмена].ПолучитьСсылку();
	
КонецПроцедуры

Процедура КлсУниверсальнаяКомандаНажатие(Кнопка) Экспорт 
	
	ирОбщий.УниверсальнаяКомандаФормыЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура ОбработчикОжиданияСПараметрамиЛкс() Экспорт 
	
	ирОбщий.ОбработчикОжиданияСПараметрамиЛкс();

КонецПроцедуры

Процедура ВнешнееСобытие(Источник, Событие, Данные)
	
	ирОбщий.Форма_ВнешнееСобытиеЛкс(ЭтаФорма, Источник, Событие, Данные);

КонецПроцедуры

ирОбщий.ИнициализироватьФормуЛкс(ЭтаФорма, "Обработка.ирРедакторИзмененийНаУзлах.Форма.ВыборУзловПриемниковДляКопирования");
