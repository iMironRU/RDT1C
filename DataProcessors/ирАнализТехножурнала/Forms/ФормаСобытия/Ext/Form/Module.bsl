﻿
Процедура ЗначенияСвойствВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИмяРеквизита = ВыбраннаяСтрока.ИмяВТаблице;
	ТипЗначения = Метаданные().ТабличныеЧасти.ТаблицаЖурнала.Реквизиты[ИмяРеквизита].Тип;
	#Если _ Тогда
	    ТипЗначения = Новый ОписаниеТипов();
	#КонецЕсли
	СтрокаСвойстваИнфобаза = ЗначенияСвойств.Найти("Инфобаза", "ИмяВТаблице");
	Если СтрокаСвойстваИнфобаза <> Неопределено Тогда
		Инфобаза = СтрокаСвойстваИнфобаза.Значение;
	КонецЕсли; 
	Если Истина
		И ирОбщий.СтрокиРавныЛкс(ПолучитьИмяСвойстваБезМета(ИмяРеквизита), "ТекстSDBL")
		И (Ложь
			Или Инфобаза = ""
			Или ирОбщий.СтрокиРавныЛкс(Инфобаза, НСтр(СтрокаСоединенияИнформационнойБазы(), "Ref")))
	Тогда
		СтрокаСвойстваИнфобаза = ЗначенияСвойств.Найти("ТекстSDBL", "ИмяВТаблице");
		Если СтрокаСвойстваИнфобаза <> Неопределено Тогда
			ТекстSDBL = СтрокаСвойстваИнфобаза.Значение;
			ОткрытьТекстБДВКонверторе(ТекстSDBL, Не ирОбщий.СтрокиРавныЛкс(ИмяРеквизита, "ТекстSDBL"));
		КонецЕсли; 
	ИначеЕсли Истина
		И ТипЗначения.СодержитТип(Тип("Строка"))
		И ТипЗначения.КвалификаторыСтроки.Длина = 0
	Тогда
		ВариантПросмотра = ПолучитьВариантПросмотраТекстПоИмениРеквизита(ИмяРеквизита);
		ирОбщий.ОткрытьТекстЛкс(ВыбраннаяСтрока.Значение, ВыбраннаяСтрока.СвойствоСиноним, ВариантПросмотра, Истина,
			"" + ЭтаФорма.КлючУникальности + ВыбраннаяСтрока.ИмяВТаблице);
	Иначе
		ирОбщий.ЯчейкаТабличногоПоляРасширенногоЗначения_ВыборЛкс(Элемент, СтандартнаяОбработка);
	КонецЕсли; 

КонецПроцедуры

ирОбщий.ИнициализироватьФормуЛкс(ЭтаФорма, "Обработка.ирАнализТехножурнала.Форма.ФормаСобытия");
