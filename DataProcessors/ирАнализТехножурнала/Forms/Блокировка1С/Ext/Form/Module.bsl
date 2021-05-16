﻿Перем ШаблонПоля;
Перем ШаблонЭлемента;
Перем ШаблонОбласти;

Процедура ПриОткрытии()
	
	Если КлючУникальности = "Автотест" Тогда
		Возврат;
	КонецЕсли;
	СтрокаСобытияБлокировки = ЭтаФорма.КлючУникальности; 
	ирОбщий.Форма_ПриОткрытииЛкс(ЭтаФорма);
	ЭтаФорма.Заголовок = ЭтаФорма.Заголовок + " - " + Формат(СтрокаСобытияБлокировки.МоментВремени, "ЧГ=");
	ЭтаФорма.Инфобаза = СтрокаСобытияБлокировки.Инфобаза;
	ЭтаФорма.Соединение = СтрокаСобытияБлокировки.Соединение_;
	ЭтаФорма.TCPСоединение = СтрокаСобытияБлокировки.TCPСоединение;
	ЭтаФорма.Сеанс = СтрокаСобытияБлокировки.Сеанс;
	ЭтаФорма.Пользователь = СтрокаСобытияБлокировки.Пользователь;
	ЭтаФорма.Длительность = СтрокаСобытияБлокировки.Длительность;
	ЭтаФорма.Пространства = СтрокаСобытияБлокировки.Regions;
	ЭтаФорма.ПространстваМета = СтрокаСобытияБлокировки.RegionsМета;
	ЭтаФорма.СтрокаМодуля = СтрокаСобытияБлокировки.СтрокаМодуля;
	ЭтаФорма.Дата = СтрокаСобытияБлокировки.Дата;
	ЭтаФорма.ДатаНачала = СтрокаСобытияБлокировки.ДатаНачала;
	ЭтаФорма.МоментВремени = СтрокаСобытияБлокировки.МоментВремени;
	ЭтаФорма.МоментВремениНачала = СтрокаСобытияБлокировки.МоментВремениНачала;
	МассивСоединенийБлокираторов = ирОбщий.СтрРазделитьЛкс(СтрокаСобытияБлокировки.Блокираторы,,, Ложь);
	Счетчик = 1;
	Для Каждого БлокировавшееСоединение Из МассивСоединенийБлокираторов Цикл
		СтрокаБлокиратора = БлокировавшиеСоединения.Добавить();
		СтрокаБлокиратора.TCPСоединение = БлокировавшееСоединение;
		СтрокаБлокиратора.Порядок = Счетчик;
		Счетчик = Счетчик + 1;
	КонецЦикла;
	ПоляОбластиБлокировки.Очистить();
	ОписаниеБлокировкиМета = ПолучитьОписаниеБлокировкиМета(СтрокаСобытияБлокировки);
	ЗагрузитьОбластиБлокировки(ОбластиБлокировки, СтрокаСобытияБлокировки.Locks, ОписаниеБлокировкиМета);
	ЭтаФорма.КоличествоЭлементов = ОбластиБлокировки.Количество();
	ирОбщий.ТабличноеПолеВставитьКолонкуНомерСтрокиЛкс(ЭлементыФормы.ОбластиБлокировки);
	ирОбщий.ТабличноеПолеВставитьКолонкуНомерСтрокиЛкс(ЭлементыФормы.ОбластиБлокировкиБлокиратора);
	
КонецПроцедуры

Функция ПолучитьОписаниеБлокировкиМета(Знач СтрокаБлокировки)
	
	ОписаниеБлокировкиМета = СтрокаБлокировки.LocksМета;
	Если ирОбщий.СтрокиРавныЛкс(ОписаниеБлокировкиМета, РезультатПереводаСлишкомБольшогоТекста()) Тогда
		Состояние("Перевод в термины метаданных...");
		ОписаниеБлокировкиМета = ПеревестиТекстБДВТерминыМетаданных(СтрокаБлокировки.Locks,,,,, 0);
		СтрокаБлокировки.LocksМета = ОписаниеБлокировкиМета;
		Состояние("");
	КонецЕсли;
	Если Не ЗначениеЗаполнено(ОписаниеБлокировкиМета) Тогда
		ОписаниеБлокировкиМета = СтрокаБлокировки.Locks;
	КонецЕсли; 
	Возврат ОписаниеБлокировкиМета;
	
КонецФункции

Процедура ЗагрузитьОбластиБлокировки(ТаблицаОбластейБлокировки, ОписаниеБлокировки, ОписаниеБлокировкиМета)
	
	ТаблицаОбластейБлокировки.Очистить();
	RegExpЭлементов = мПлатформа.RegExp;
	RegExpЭлементов.Global = Истина;
	RegExpЭлементов.Pattern = ШаблонЭлемента;
	RegExpОбластей = мПлатформа.RegExp2;
	RegExpОбластей.Global = Истина;
	RegExpОбластей.Pattern = ШаблонОбласти;
	ВхожденияЭлементов = RegExpЭлементов.НайтиВхождения(ОписаниеБлокировки);
	ВхожденияЭлементовМета = RegExpЭлементов.НайтиВхождения(ОписаниеБлокировкиМета);
	ИндикаторПространств = ирОбщий.ПолучитьИндикаторПроцессаЛкс(ВхожденияЭлементов.Количество(), "Пространства");
	Для ИндексЭлемента = 0 По ВхожденияЭлементов.Количество() - 1 Цикл
		ирОбщий.ОбработатьИндикаторЛкс(ИндикаторПространств);
		ВхождениеЭлемента = ВхожденияЭлементов[ИндексЭлемента];
		ВхождениеЭлементаМета = ВхожденияЭлементовМета[ИндексЭлемента];
		Пространство = ВхождениеЭлемента.SubMatches(0);
		ПространствоМета = ВхождениеЭлементаМета.SubMatches(0);
		ТипБлокировки = ВхождениеЭлемента.SubMatches(1);
		ВхожденияОбластей = RegExpОбластей.НайтиВхождения(ВхождениеЭлемента.SubMatches(2));
		ВхожденияОбластейМета = RegExpОбластей.НайтиВхождения(ВхождениеЭлементаМета.SubMatches(2));
		Если ВхожденияОбластей.Количество() > 0 Тогда
			ИндикаторОбласти = ирОбщий.ПолучитьИндикаторПроцессаЛкс(ВхожденияОбластей.Количество(), "Области");
			Для ИндексОбласти = 0 По ВхожденияОбластей.Count - 1 Цикл
				ирОбщий.ОбработатьИндикаторЛкс(ИндикаторОбласти);
				ВхождениеОбласти = ВхожденияОбластей[ИндексОбласти];
				ВхождениеОбластиМета = ВхожденияОбластейМета[ИндексОбласти];
				СтрокаОбластиБлокировки = ТаблицаОбластейБлокировки.Добавить();
				СтрокаОбластиБлокировки.Пространство = Пространство;
				СтрокаОбластиБлокировки.ПространствоМета = ПространствоМета;
				СтрокаОбластиБлокировки.ТипБлокировки = ТипБлокировки;
				СтрокаОбластиБлокировки.Область = СокрЛП(ВхождениеОбласти.SubMatches(0));
				СтрокаОбластиБлокировки.ОбластьМета = СокрЛП(ВхождениеОбластиМета.SubMatches(0));
			КонецЦикла; 
			ирОбщий.ОсвободитьИндикаторПроцессаЛкс();
		Иначе
			СтрокаОбластиБлокировки = ТаблицаОбластейБлокировки.Добавить();
			СтрокаОбластиБлокировки.Пространство = Пространство;
			СтрокаОбластиБлокировки.ПространствоМета = ПространствоМета;
			СтрокаОбластиБлокировки.ТипБлокировки = ТипБлокировки;
		КонецЕсли; 
	КонецЦикла;
	ирОбщий.ОсвободитьИндикаторПроцессаЛкс();
	ТаблицаОбластейБлокировки.Сортировать("ПространствоМета, ТипБлокировки, Область");

КонецПроцедуры

Процедура ЗагрузитьПоляЭлементаБлокировки(ТаблицаПолейЭлементаБлокировки, ОписаниеПолей, ОписаниеПолейМета)
    
	ТаблицаПолейЭлементаБлокировки.Очистить();
	RegExp = мПлатформа.RegExp;
	RegExp.Global = Истина;
	// ШаблонПоля = "(\w+)=(?:(\d+\:\w+)|(\d+)|T""(\d+)""|(\w+)|(""""""\w*"""""")|(\[(?:(\d+)|T""(\d+)""|(\+))\:(?:(\d+)|T""(\d+)""|(\+))\]))"; // Справочно
	RegExp.Pattern = ШаблонПоля;
	Вхождения = RegExp.НайтиВхождения(ОписаниеПолей);
	ВхожденияМета = RegExp.НайтиВхождения(ОписаниеПолейМета);
	Для ИндексЭлемента = 0 По Вхождения.Количество() - 1 Цикл
		Вхождение = Вхождения[ИндексЭлемента];
		ВхождениеМета = ВхожденияМета[ИндексЭлемента];
		СтрокаПоля = ТаблицаПолейЭлементаБлокировки.Добавить();
		СтрокаПоля.Поле = Вхождение.SubMatches(0);
		СтрокаПоля.ПолеМета = ВхождениеМета.SubMatches(0);
		Если Вхождение.SubMatches(1) <> Неопределено Тогда
			СтрокаПоля.ЗначениеSDBL = Вхождение.SubMatches(1);
			СтрокаПоля.Значение = ирОбщий.ПреобразоватьЗначениеИзSDBLЛкс(СтрокаПоля.ЗначениеSDBL, мАдресЧужойСхемыБД);
			Если ТипЗнч(СтрокаПоля.Значение) <> Тип("Строка") Тогда
				СтрокаПоля.ТипЗначения = ТипЗнч(СтрокаПоля.Значение);
			КонецЕсли; 
		ИначеЕсли Вхождение.SubMatches(2) <> Неопределено Тогда
			СтрокаПоля.ЗначениеSDBL = Вхождение.SubMatches(2);
			СтрокаПоля.Значение = Число(СтрокаПоля.ЗначениеSDBL);
			СтрокаПоля.ТипЗначения = ТипЗнч(СтрокаПоля.Значение);
		ИначеЕсли Вхождение.SubMatches(3) <> Неопределено Тогда
			СтрокаПоля.ЗначениеSDBL = Вхождение.SubMatches(3);
			СтрокаПоля.Значение = Дата(СтрокаПоля.ЗначениеSDBL);
			СтрокаПоля.ТипЗначения = ТипЗнч(СтрокаПоля.Значение);
		ИначеЕсли Вхождение.SubMatches(4) <> Неопределено Тогда
			СтрокаПоля.ЗначениеSDBL = Вхождение.SubMatches(4);
			//СтрокаПоля.Значение = Вычислить(СтрокаПоля.ЗначениеSDBL);
			СтрокаПоля.Значение = "<" + СтрокаПоля.ЗначениеSDBL + ">";
		ИначеЕсли Вхождение.SubMatches(5) <> Неопределено Тогда
			СтрокаПоля.ЗначениеSDBL = Вхождение.SubMatches(5);
			Попытка
				ЗначениеСтроки = Вычислить(СтрокаПоля.ЗначениеSDBL);
			Исключение
				Сообщить("Ошибка преобразования строкового значения из SDBL строки " + СтрокаПоля.ЗначениеSDBL);
			КонецПопытки; 
			СтрокаПоля.Значение = ЗначениеСтроки;
			СтрокаПоля.ТипЗначения = ТипЗнч(СтрокаПоля.Значение);
		ИначеЕсли Вхождение.SubMatches(6) <> Неопределено Тогда
			// Диапазон
			Если Вхождение.SubMatches(7) <> Неопределено Тогда
				СтрокаПоля.ЗначениеС = Число(Вхождение.SubMatches(7));
				СтрокаПоля.ТипЗначения = ТипЗнч(СтрокаПоля.ЗначениеС);
			ИначеЕсли Вхождение.SubMatches(8) <> Неопределено Тогда
				СтрокаПоля.ЗначениеС = Дата(Вхождение.SubMatches(8));
				СтрокаПоля.ТипЗначения = ТипЗнч(СтрокаПоля.ЗначениеС);
			Иначе
				СтрокаПоля.ЗначениеC = "<+>";
			КонецЕсли; 
			Если Вхождение.SubMatches(10) <> Неопределено Тогда
				СтрокаПоля.ЗначениеПо = Число(Вхождение.SubMatches(10));
				СтрокаПоля.ТипЗначения = ТипЗнч(СтрокаПоля.ЗначениеПо);
			ИначеЕсли Вхождение.SubMatches(11) <> Неопределено Тогда
				СтрокаПоля.ЗначениеПо = Дата(Вхождение.SubMatches(11));
				СтрокаПоля.ТипЗначения = ТипЗнч(СтрокаПоля.ЗначениеПо);
			Иначе
				СтрокаПоля.ЗначениеПо = "<+>";
			КонецЕсли; 
		КонецЕсли; 
	КонецЦикла;
	ТаблицаПолейЭлементаБлокировки.Сортировать("ПолеМета");

КонецПроцедуры

Процедура БлокировавшиеСоединенияПриАктивизацииСтроки(Элемент)
	
	ирОбщий.ТабличноеПолеПриАктивизацииСтрокиЛкс(ЭтаФорма, Элемент);
	ВозможныеБлокираторы.Очистить();
	Если Элемент.ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	Если Не ЗначениеЗаполнено(Элемент.ТекущаяСтрока.Сеанс) Тогда
		// Свойство WaitConnections для события TLOCK содержит номер единственного ожидаемого соединения
		// https://partners.v8.1c.ru/forum/t/1326446/m/1326446
		
		ВременныйПостроительЗапроса = Новый ПостроительЗапроса;
		ВременныйПостроительЗапроса.ИсточникДанных = Новый ОписаниеИсточникаДанных(ТаблицаЖурнала);
		ВременныйПостроительЗапроса.Отбор.Добавить("Инфобаза").Установить(Инфобаза);
		ВременныйПостроительЗапроса.Отбор.Добавить("Событие").Установить("SDBL");
		ВременныйПостроительЗапроса.Отбор.Добавить("TCPСоединение").Установить(Элемент.ТекущаяСтрока.TCPСоединение);
		ЭлементОтбораМоментВремени = ВременныйПостроительЗапроса.Отбор.Добавить("МоментВремени");
		ЭлементОтбораМоментВремени.Использование = Истина;
		ЭлементОтбораДействие = ВременныйПостроительЗапроса.Отбор.Добавить("Действие");
		
		// Ищем начало транзакции
		ЭлементОтбораМоментВремени.ВидСравнения = ВидСравнения.МеньшеИлиРавно; 
		ЭлементОтбораМоментВремени.Значение = МоментВремениНачала;
		ЭлементОтбораДействие.Установить("BeginTransaction");
		ВременныйПостроительЗапроса.Порядок.Установить("МоментВремени Убыв");
		НайденныеНачала = ВременныйПостроительЗапроса.Результат.Выгрузить();
		Если НайденныеНачала.Количество() > 0 Тогда
			Элемент.ТекущаяСтрока.НачалоТранзакции = НайденныеНачала[0].МоментВремени;
		КонецЕсли; 
		Если ЗначениеЗаполнено(Элемент.ТекущаяСтрока.НачалоТранзакции) Тогда
			Элемент.ТекущаяСтрока.Возраст = РазностьМоментовВремени(МоментВремениНачала, Элемент.ТекущаяСтрока.НачалоТранзакции) / 1000;
		КонецЕсли; 
		Если ТаблицаЖурнала.Найти("BeginTransaction", "Действие") = Неопределено Тогда
			Сообщить("В таблице журнала отсутствуют события начала транзакций (Действие=BeginTransaction).", СтатусСообщения.Внимание);
		КонецЕсли; 
		Если ТаблицаЖурнала.Найти("CommitTransaction", "Действие") = Неопределено Тогда
			Сообщить("В таблице журнала отсутствуют события окончания транзакций (Действие=CommitTransaction,RollbackTransaction).");
		КонецЕсли;
		
		// https://partners.v8.1c.ru/forum/topic/1326457
		// Ищем конец транзакции
		ЭлементОтбораМоментВремени.ВидСравнения = ВидСравнения.БольшеИлиРавно; 
		ЭлементОтбораМоментВремени.Значение = МоментВремениНачала;
		ЭлементОтбораДействие.ВидСравнения = ВидСравнения.ВСписке;
		ЭлементОтбораДействие.Использование = Истина;
		СписокДействий = Новый СписокЗначений;
		СписокДействий.Добавить("BeginTransaction"); // если собирали только BeginTransaction
		СписокДействий.Добавить("CommitTransaction");
		СписокДействий.Добавить("RollbackTransaction");
		ЭлементОтбораДействие.Значение = СписокДействий;;
		ВременныйПостроительЗапроса.Порядок.Установить("МоментВремени Возр");
		НайденныеКонцы = ВременныйПостроительЗапроса.Результат.Выгрузить();
		Если НайденныеКонцы.Количество() > 0 Тогда
			Элемент.ТекущаяСтрока.КонецТранзакции = НайденныеКонцы[0].МоментВремени;
			Элемент.ТекущаяСтрока.ПолнаяДлительность = РазностьМоментовВремени(Элемент.ТекущаяСтрока.КонецТранзакции, Элемент.ТекущаяСтрока.НачалоТранзакции) / 1000;
		Иначе
			Элемент.ТекущаяСтрока.ПолнаяДлительность = "?";
		КонецЕсли; 
	КонецЕсли;
	
	ВременныйПостроительЗапроса = Новый ПостроительЗапроса;
	ВременныйПостроительЗапроса.ИсточникДанных = Новый ОписаниеИсточникаДанных(ТаблицаЖурнала);
	ВременныйПостроительЗапроса.Отбор.Добавить("Инфобаза").Установить(Инфобаза);
	ВременныйПостроительЗапроса.Отбор.Добавить("Событие").Установить("TLOCK");
	ВременныйПостроительЗапроса.Отбор.Добавить("TCPСоединение").Установить(Элемент.ТекущаяСтрока.TCPСоединение);
	Если Найти(Пространства, ",") = 0 Тогда
		ЭлементОтбораПространства = ВременныйПостроительЗапроса.Отбор.Добавить("Regions");
		ЭлементОтбораПространства.Установить(Пространства);
		ЭлементОтбораПространства.ВидСравнения = ВидСравнения.Содержит;
	КонецЕсли; 
	ВременныйПостроительЗапроса.Порядок.Установить("МоментВремени Возр");
	ЭлементОтбораМоментВремени = ВременныйПостроительЗапроса.Отбор.Добавить("МоментВремени");
	ЭлементОтбораМоментВремени.Использование = Истина;
	//Если Элемент.ТекущаяСтрока.Порядок = 1 Тогда
	//	МоментВремениКонцаБлокираторов = МоментВремениНачала;
	//Иначе
	//	МоментВремениКонцаБлокираторов = МоментВремени;
	//КонецЕсли; 
	//Если Истина
	//	И ЗначениеЗаполнено(Элемент.ТекущаяСтрока.КонецТранзакции) 
	//	И ЗначениеЗаполнено(Элемент.ТекущаяСтрока.НачалоТранзакции) 
	//Тогда
	//	ЭлементОтбораМоментВремени.ВидСравнения = ВидСравнения.ИнтервалВключаяГраницы; 
	//	ЭлементОтбораМоментВремени.ЗначениеС = Элемент.ТекущаяСтрока.НачалоТранзакции;
	//	ЭлементОтбораМоментВремени.ЗначениеПо = Элемент.ТекущаяСтрока.КонецТранзакции;
	//Иначе
	Если ЗначениеЗаполнено(Элемент.ТекущаяСтрока.НачалоТранзакции) Тогда 
		ЭлементОтбораМоментВремени.ВидСравнения = ВидСравнения.ИнтервалВключаяГраницы; 
		ЭлементОтбораМоментВремени.ЗначениеС = Элемент.ТекущаяСтрока.НачалоТранзакции;
		ЭлементОтбораМоментВремени.ЗначениеПо = МоментВремени;
		Если ЗначениеЗаполнено(Элемент.ТекущаяСтрока.КонецТранзакции) Тогда 
			ЭлементОтбораМоментВремени.ВидСравнения = ВидСравнения.МеньшеИлиРавно; 
			ЭлементОтбораМоментВремени.Значение = Элемент.ТекущаяСтрока.КонецТранзакции;
		КонецЕсли; 
	Иначе
		ЭлементОтбораМоментВремени.ВидСравнения = ВидСравнения.МеньшеИлиРавно; 
		ЭлементОтбораМоментВремени.Значение = МоментВремени;
	КонецЕсли; 
	лВозможныеБлокираторы = ВременныйПостроительЗапроса.Результат.Выгрузить();
	Если лВозможныеБлокираторы.Количество() > 0 Тогда
		Для Каждого лВозможныйБлокиратор Из лВозможныеБлокираторы Цикл
			ЗаполнитьСвойстваСИменамиМетаданных(лВозможныйБлокиратор);
		КонецЦикла;
		ПоследнийВозможныйБлокиратор = лВозможныеБлокираторы[лВозможныеБлокираторы.Количество() - 1];
		Элемент.ТекущаяСтрока.Сеанс = ПоследнийВозможныйБлокиратор.Сеанс;
		Элемент.ТекущаяСтрока.Соединение = ПоследнийВозможныйБлокиратор.Соединение_;
		Элемент.ТекущаяСтрока.Пользователь = ПоследнийВозможныйБлокиратор.Пользователь;
		// На случай, если начала транзакции не нашли и номер соединения был использован разными сеансами
		ирОбщий.ЗагрузитьВТаблицуЗначенийЛкс(лВозможныеБлокираторы.Скопировать(Новый Структура("Сеанс", ПоследнийВозможныйБлокиратор.Сеанс)), ВозможныеБлокираторы);
		ЭтаФорма.КоличествоВозможныхБлокираторов = ВозможныеБлокираторы.Количество();
		RegExp = мПлатформа.RegExp;
		RegExp.Global = Истина;
		RegExp.Pattern = ШаблонОбласти;
		Индикатор = ирОбщий.ПолучитьИндикаторПроцессаЛкс(ВозможныеБлокираторы.Количество(), "Вычисление количества областей");
		Для Каждого СтрокаБлокиратора Из ВозможныеБлокираторы Цикл
			ирОбщий.ОбработатьИндикаторЛкс(Индикатор);
			Вхождения = RegExp.НайтиВхождения(СтрокаБлокиратора.Locks);
			СтрокаБлокиратора.Количество = Вхождения.Количество();
			СтрокаБлокиратора.Возраст = РазностьМоментовВремени(МоментВремениНачала, СтрокаБлокиратора.МоментВремени) / 1000;
		КонецЦикла; 
		ирОбщий.ОсвободитьИндикаторПроцессаЛкс();
		ЭлементыФормы.ВозможныеБлокираторы.ТекущаяСтрока = ВозможныеБлокираторы[0];
	КонецЕсли; 
	
КонецПроцедуры

Процедура ОткрытьНажатие(Элемент)
	
	ФормаСобытия = ПолучитьФорму("Событие", , МоментВремени);
	ФормаСобытия.Открыть();

КонецПроцедуры

Процедура ТаблицаЖурналаВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	ФормаСобытия = ПолучитьФорму("Событие", ВладелецФормы, ВыбраннаяСтрока.МоментВремени);
	ФормаСобытия.Открыть();

КонецПроцедуры

Процедура ТаблицаЖурналаПриАктивизацииСтроки(Элемент)
	
	ирОбщий.ТабличноеПолеПриАктивизацииСтрокиЛкс(ЭтаФорма, Элемент);
	Если Элемент.ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	//Если Элемент.ТекущаяСтрока.LocksМета = РезультатПереводаСлишкомБольшогоТекста() Тогда
	//	Элемент.ТекущаяСтрока.LocksМета = ПеревестиТекстБДВТерминыМетаданных(Элемент.ТекущаяСтрока.Locks, , , ,, 0);
	//КонецЕсли; 
	ОписаниеБлокировкиМета = ПолучитьОписаниеБлокировкиМета(Элемент.ТекущаяСтрока);
	ЗагрузитьОбластиБлокировки(ОбластиБлокировкиБлокиратора, Элемент.ТекущаяСтрока.Locks, ОписаниеБлокировкиМета);
	
КонецПроцедуры

Процедура ОбластиБлокировкиБлокиратораПриАктивизацииСтроки(Элемент)
	
	Если Элемент.ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	ПоляОбластиБлокировкиБлокиратора.Очистить();
	ЗагрузитьПоляЭлементаБлокировки(ПоляОбластиБлокировкиБлокиратора, Элемент.ТекущаяСтрока.Область, Элемент.ТекущаяСтрока.ОбластьМета);
	
КонецПроцедуры

Процедура ОбластиБлокировкиПриАктивизацииСтроки(Элемент)
	
	Если Элемент.ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	ЗагрузитьПоляЭлементаБлокировки(ПоляОбластиБлокировки, Элемент.ТекущаяСтрока.Область, Элемент.ТекущаяСтрока.ОбластьМета);
	
КонецПроцедуры

Процедура ПоляОбластиБлокировкиВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)

	Если Колонка.Имя = "Значение" Тогда
		СтандартнаяОбработка = Ложь;
		ОткрытьЗначение(ВыбраннаяСтрока.Значение);
	КонецЕсли; 
	
КонецПроцедуры

Процедура ПоляОбластиБлокировкиПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки) Экспорт
	
	Если ЗначениеЗаполнено(ДанныеСтроки.ЗначениеSDBL) Тогда
		ОформлениеСтроки.Ячейки.ЗначениеС.Видимость = Ложь;
		ОформлениеСтроки.Ячейки.ЗначениеПо.Видимость = Ложь;
	Иначе
		ОформлениеСтроки.Ячейки.Значение.Видимость = Ложь;
		ОформлениеСтроки.Ячейки.ЗначениеSDBL.Видимость = Ложь;
	КонецЕсли; 
	
КонецПроцедуры

Процедура КлсКомандаНажатие(Кнопка) Экспорт 
	
	ирОбщий.УниверсальнаяКомандаФормыЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура ОбработчикОжиданияСПараметрамиЛкс() Экспорт 
	
	ирОбщий.ОбработчикОжиданияСПараметрамиЛкс();

КонецПроцедуры

Процедура КоманднаяПанель1Сравнить(Кнопка)
	
	ВыводБезОформления = Ложь;
	СравниваемыйДокумент1 = ирОбщий.ВывестиСтрокиТабличногоПоляСНастройкойЛкс(ЭлементыФормы.ОбластиБлокировки, ВыводБезОформления);
	СравниваемыйДокумент2 = ирОбщий.ВывестиСтрокиТабличногоПоляСНастройкойЛкс(ЭлементыФормы.ОбластиБлокировкиБлокиратора, ВыводБезОформления);
	ирОбщий.СравнитьЗначенияВФормеЛкс(СравниваемыйДокумент1, СравниваемыйДокумент2, , "Заблокированный", "Блокиратор",, Ложь);
	
КонецПроцедуры

Процедура ОбластиБлокировкиПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки) Экспорт
	
	ирОбщий.ТабличноеПолеПриВыводеСтрокиЛкс(ЭтаФорма, Элемент, ОформлениеСтроки, ДанныеСтроки);

КонецПроцедуры

Процедура ОбластиБлокировкиБлокиратораПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки) Экспорт
	
	ирОбщий.ТабличноеПолеПриВыводеСтрокиЛкс(ЭтаФорма, Элемент, ОформлениеСтроки, ДанныеСтроки);

КонецПроцедуры

Процедура ВозможныеБлокираторыПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки) Экспорт
	
	ирОбщий.ТабличноеПолеПриВыводеСтрокиЛкс(ЭтаФорма, Элемент, ОформлениеСтроки, ДанныеСтроки);

КонецПроцедуры

Процедура БлокировавшиеСоединенияПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки) Экспорт
	
	ирОбщий.ТабличноеПолеПриВыводеСтрокиЛкс(ЭтаФорма, Элемент, ОформлениеСтроки, ДанныеСтроки);

КонецПроцедуры

Процедура ВнешнееСобытие(Источник, Событие, Данные) Экспорт
	
	ирОбщий.Форма_ВнешнееСобытиеЛкс(ЭтаФорма, Источник, Событие, Данные);

КонецПроцедуры

Процедура ТабличноеПолеПриПолученииДанных(Элемент, ОформленияСтрок) Экспорт 
	
	ирОбщий.ТабличноеПолеПриПолученииДанныхЛкс(ЭтаФорма, Элемент, ОформленияСтрок);

КонецПроцедуры

Процедура ПриЗакрытии()
	
	ирОбщий.Форма_ПриЗакрытииЛкс(ЭтаФорма);

КонецПроцедуры

Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник) Экспорт
	
	ирОбщий.Форма_ОбработкаОповещенияЛкс(ЭтаФорма, ИмяСобытия, Параметр, Источник); 

КонецПроцедуры

ирОбщий.ИнициироватьФормуЛкс(ЭтаФорма, "Обработка.ирАнализТехножурнала.Форма.Блокировка1С");
шИмя = "[" + мПлатформа.шБуква + "\d]+";
ШаблонПоля = "(" + шИмя + ")=(?:(\d+\:" + шИмя + ")|(-?\d+)|T""(\d+)""|(" + шИмя + ")|(""(?:(?:"""")*|[^""])*"")|(\[(?:(-?\d+)|T""(\d+)""|(\+))\:(?:(-?\d+)|T""(\d+)""|(\+))\]))";
ШаблонОбласти = "((?:\s+" + ШаблонПоля + ")+)\s*";
ШаблонЭлемента = "\s*(" + шИмя + "(?:\." + шИмя + ")+)\s+(" + шИмя + ")(" + ШаблонОбласти + "(,\s*" + ШаблонОбласти + ")*)?(?:,|$)";