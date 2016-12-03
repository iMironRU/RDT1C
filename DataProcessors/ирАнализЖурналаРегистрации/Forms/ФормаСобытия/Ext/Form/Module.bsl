﻿
Процедура ПриОткрытии()
	
	Если НачальноеЗначениеВыбора <> Неопределено Тогда
		ЭлементыФормы.ТаблицаЖурнала.ТекущаяСтрока = НачальноеЗначениеВыбора;
	КонецЕсли; 
	
КонецПроцедуры

Процедура РасширенноеЗначениеОткрытие(Элемент, СтандартнаяОбработка)
	
	ирОбщий.ОткрытьФормуПроизвольногоЗначенияЛкс(СтрокаТаблицыЗначений[ирОбщий.ПолучитьПоследнийФрагментЛкс(Элемент.Данные)], Ложь, СтандартнаяОбработка);

КонецПроцедуры

Процедура ПредставлениеСобытияОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если ЭлементыФормы.ТаблицаЖурнала.ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	Форма = ирОбщий.ПолучитьФормуЛкс("Обработка.ирНастройкаЖурналаРегистрации.Форма");
	Форма.Открыть();
	лМетаданные = Неопределено;
	Если СтрокаТаблицыЗначений <> Неопределено Тогда
		лМетаданные = СтрокаТаблицыЗначений.Метаданные;
	КонецЕсли; 
	Форма.АктивизироватьСтрокуСобытия(ЭлементыФормы.Событие.Значение, лМетаданные);
	
КонецПроцедуры

ирОбщий.ИнициализироватьФормуЛкс(ЭтаФорма, "Обработка.ирАнализЖурналаРегистрации.Форма.ФормаСобытия");
