﻿
Процедура КПКолонкиТолькоВключенные(Кнопка)
	
	УстановитьОтборТолькоВключенные(Не Кнопка.Пометка);
	
КонецПроцедуры

Процедура УстановитьОтборТолькоВключенные(НовоеЗначение)
	
	ЭлементыФормы.КПКолонки.Кнопки.ТолькоВключенные.Пометка = НовоеЗначение;
	ЭлементыФормы.КолонкиТабличногоПоля.ОтборСтрок.Пометка.ВидСравнения = ВидСравнения.Равно;
	ЭлементыФормы.КолонкиТабличногоПоля.ОтборСтрок.Пометка.Использование = НовоеЗначение;
	ЭлементыФормы.КолонкиТабличногоПоля.ОтборСтрок.Пометка.Значение = Истина;
	
КонецПроцедуры

Процедура ПриОткрытии()
	
	КолонкиТабличногоПоля.Очистить();
	Если ТипЗнч(ТабличноеПоле) = Тип("ТабличноеПоле") Тогда
		КолонкиТП = ТабличноеПоле.Колонки;
		ТекущаяКолонка = ТабличноеПоле.ТекущаяКолонка;
	Иначе
		КолонкиТП = ТабличноеПоле.ПодчиненныеЭлементы;
		ТекущаяКолонка = ТабличноеПоле.ТекущийЭлемент;
	КонецЕсли; 
	Для Каждого КолонкаТП Из КолонкиТП Цикл
		Если Не КолонкаТП.Видимость И Не КолонкаТП.ИзменятьВидимость Тогда
			Продолжить;
		КонецЕсли; 
		СтрокаКолонки = КолонкиТабличногоПоля.Добавить();
		СтрокаКолонки.Имя = КолонкаТП.Имя;
		Если ТипЗнч(КолонкаТП) = Тип("ПолеФормы") Тогда
			СтрокаКолонки.Заголовок = КолонкаТП.Заголовок;
		Иначе
			СтрокаКолонки.Заголовок = КолонкаТП.ТекстШапки;
		КонецЕсли; 
		СтрокаКолонки.Пометка = КолонкаТП.Видимость;
		СтрокаКолонки.Данные = ирОбщий.ПолучитьПутьКДаннымКолонкиТабличногоПоляЛкс(ТабличноеПоле, КолонкаТП);
		//СтрокаКолонки.ТипЗначения = 
		Если ТекущаяКолонка = КолонкаТП Тогда
			ЭлементыФормы.КолонкиТабличногоПоля.ТекущаяСтрока = СтрокаКолонки;
		КонецЕсли; 
	КонецЦикла;
	УстановитьОтборТолькоВключенные(Истина);
	ОбновитьДоступность();

КонецПроцедуры

Процедура КПКолонкиСнятьФлажки(Кнопка)
	
	ТекущаяСтрока = ЭлементыФормы.КолонкиТабличногоПоля.ТекущаяСтрока;
	ирОбщий.ИзменитьПометкиВыделенныхСтрокЛкс(ЭлементыФормы.КолонкиТабличногоПоля,, Ложь);
	Если КолонкиТабличногоПоля.Найти(Истина, "Пометка") = Неопределено Тогда
		УстановитьОтборТолькоВключенные(Ложь);
		ЭлементыФормы.КолонкиТабличногоПоля.ТекущаяСтрока = ТекущаяСтрока;
	КонецЕсли; 
	
КонецПроцедуры

Процедура КПКолонкиУстановитьФлажки(Кнопка)
	
	ирОбщий.ИзменитьПометкиВыделенныхСтрокЛкс(ЭлементыФормы.КолонкиТабличногоПоля,, Ложь);

КонецПроцедуры

Процедура ОсновныеДействияФормыОК(Кнопка)
	
	Закрыть(Истина);
	
КонецПроцедуры

Процедура БезОформленияПриИзменении(Элемент)
	
	ОбновитьДоступность();
	
КонецПроцедуры

Процедура ОбновитьДоступность()
	
	ЭлементыФормы.ВыводВТаблицуЗначений.Доступность = БезОформления;
	ЭлементыФормы.КолонкиИдентификаторов.Доступность = БезОформления;
	ЭлементыФормы.КолонкиТипов.Доступность = БезОформления;
	ЭлементыФормы.КолонкиПредставлений.Доступность = БезОформления;
	ЭлементыФормы.ОтображатьПустые.Доступность = БезОформления;
	ЭлементыФормы.ИтогиЧисловыхКолонок.Доступность = БезОформления;
	ЭлементыФормы.ОсновныеДействияФормы.Кнопки.ИсполняемаяКомпоновка.Доступность = БезОформления;
	
КонецПроцедуры

Процедура ПослеВосстановленияЗначений()
	
	ОбновитьДоступность();
	
КонецПроцедуры

Процедура ОсновныеДействияФормыИсполняемаяКомпоновка(Кнопка)
	
	ирОбщий.ВывестиСтрокиТабличногоПоляЛкс(ТабличноеПоле, ЭтаФорма, Истина);
	
КонецПроцедуры

Процедура СтруктураКоманднойПанелиНажатие(Кнопка)
	
	ирОбщий.ОткрытьСтруктуруКоманднойПанелиЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

ирОбщий.ИнициализироватьФормуЛкс(ЭтаФорма, "Обработка.ирПлатформа.Форма.ПараметрыВыводаСтрокТабличногоПоля");
БезОформления = Истина;
КолонкиПредставлений = Истина;
ВстроитьЗначенияВРасшифровки = Истина;
