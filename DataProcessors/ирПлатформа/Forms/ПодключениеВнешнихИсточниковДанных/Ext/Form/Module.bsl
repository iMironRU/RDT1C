﻿Перем Параметры;

Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	
	СписокВыбора = ЭлементыФормы.СУБД.СписокВыбора;
	СписокВыбора.Добавить("IBMInfosphereWarehouse");
	СписокВыбора.Добавить("MSSQLServer");
	СписокВыбора.Добавить("MSSQLServerAnalysisServices");
	СписокВыбора.Добавить("MySQL");
	СписокВыбора.Добавить("OracleDatabase");
	СписокВыбора.Добавить("OracleEssbase");
	СписокВыбора.Добавить("PostgreSQL");
	СписокВыбора.Добавить("IBMDB2");
	СписокВыбора.Добавить("Прочее");
	ЭтаФорма.СУБД = "Прочее";
	
КонецПроцедуры

Процедура ПриОткрытии()
	
	ирОбщий.Форма_ПриОткрытииЛкс(ЭтаФорма);
	Если Параметры.Найти("АутентификацияОС") = Неопределено Тогда 
		ЭлементыФормы.АутентификацияОС.Видимость = Ложь;
		ЭлементыФормы.АутентификацияОСИспользование.Видимость = Ложь;
	КонецЕсли; 
	ОбновитьСписокВнешнихИсточников();
	ОбновитьВидимостьДоступность();
	
КонецПроцедуры

Процедура ОбновитьСписокВнешнихИсточников()
	
	КлючТекущейСтроки = ирОбщий.ТабличноеПолеКлючСтрокиЛкс(ЭлементыФормы.ВнешниеИсточники, "Имя");
	ВнешниеИсточники.Очистить();
	Для Каждого ВнешнийИсточникМД Из Метаданные.ВнешниеИсточникиДанных Цикл
		СтрокаИсточника = ВнешниеИсточники.Добавить();
		СтрокаИсточника.Имя = ВнешнийИсточникМД.Имя;
		СтрокаИсточника.Представление = ВнешнийИсточникМД.Представление();
		СтрокаИсточника.ЕстьДоступ = ПравоДоступа("Использование", ВнешнийИсточникМД);
		СтрокаИсточника.Подключен = ВнешниеИсточникиДанных[ВнешнийИсточникМД.Имя].ПолучитьСостояние() = СостояниеВнешнегоИсточникаДанных.Подключен;
	КонецЦикла;
	ВнешниеИсточники.Сортировать("Представление");
	ирОбщий.ТабличноеПолеВосстановитьТекущуюСтрокуЛкс(ЭлементыФормы.ВнешниеИсточники, КлючТекущейСтроки);

КонецПроцедуры

Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Если Не ПроверитьИзменениеПараметров() Тогда
		
		Отказ = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ДействияФормыСохранитьПараметры(Кнопка)
	
	СохранитьПараметрыСоединения();
	
КонецПроцедуры

Процедура ДействияФормыПодключиться(Кнопка)
	
	Если Не ПроверитьИзменениеПараметров() Тогда
		Возврат;
	КонецЕсли;
	ПодключитьсяКВнешнемуИсточникуСервер();
	ОбновитьВидимостьДоступность();
	
КонецПроцедуры

Процедура ДействияФормыОтключиться(Кнопка)
	
	Если Не ПроверитьИзменениеПараметров() Тогда
		Возврат;
	КонецЕсли;
	ОтключитьсяОтВнешнегоИсточникаСервер();
	ОбновитьВидимостьДоступность();
	
КонецПроцедуры

Процедура СохранитьПараметрыСоединения()
	
	ПараметрыСоединенияТекущие = ПолучитьПараметрыСоединения();
	Для Каждого Параметр Из Параметры Цикл
		Если Параметр = "Пароль" И Не ПарольИзменен Тогда
			Продолжить;
		КонецЕсли; 
		ЭлементФормыВПараметр(ПараметрыСоединенияТекущие, Параметр);
	КонецЦикла;
	Если ТипПараметровТекущий = 0 Тогда
		ВнешниеИсточникиДанных[ВнешнийИсточникТекущий].УстановитьОбщиеПараметрыСоединения(ПараметрыСоединенияТекущие);
	ИначеЕсли ТипПараметровТекущий = 1 Тогда
		ВнешниеИсточникиДанных[ВнешнийИсточникТекущий].УстановитьПараметрыСоединенияПользователя(ПользователиИнформационнойБазы.ТекущийПользователь(), ПараметрыСоединенияТекущие);
	Иначе
		ВнешниеИсточникиДанных[ВнешнийИсточникТекущий].УстановитьПараметрыСоединенияСеанса(ПараметрыСоединенияТекущие);
	КонецЕсли;
	Модифицированность = Ложь;
	ОбновитьВидимостьДоступность();
	
КонецПроцедуры

Процедура ЭлементФормыВПараметр(ПараметрыСоединенияТекущие, ИмяПараметра)
	
	Если ЭтаФорма[ИмяПараметра + "Использование"] Тогда
		ЗначениеПараметра = ЭтаФорма[ИмяПараметра];
		Если ИмяПараметра = "СУБД" И ЗначениеПараметра = "Прочее" Тогда
			ЗначениеПараметра = "";
		КонецЕсли;
		ПараметрыСоединенияТекущие[ИмяПараметра] = ЗначениеПараметра;
	Иначе
		ПараметрыСоединенияТекущие[ИмяПараметра] = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПодключитьсяКВнешнемуИсточникуСервер()
	
	СтароеСостояние = ВнешниеИсточникиДанных[ВнешнийИсточник].ПолучитьСостояние();
	Если СтароеСостояние = СостояниеВнешнегоИсточникаДанных.Подключен Тогда
		ОтключитьсяОтВнешнегоИсточникаСервер();
	КонецЕсли;
	Попытка
		ВнешниеИсточникиДанных[ВнешнийИсточник].УстановитьСоединение();
		ИсточникПодключен = Истина;
	Исключение
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		ТекстСообщения = "Не удалось установить соединение. Описание ошибки:" + Символы.ПС + ИнформацияОбОшибке.Причина.Описание;
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = ТекстСообщения;
		Сообщение.Сообщить();
	КонецПопытки;
	ОбновитьСписокВнешнихИсточников();
	
КонецПроцедуры

Процедура ОбновитьПрименение()
	ПрименяемыеУровни = Новый Структура(ирОбщий.СтрСоединитьЛкс(Параметры));
	Для Счетчик = 0 По 2 Цикл
		ПараметрыУровня = ПолучитьПараметрыСоединения(Счетчик);
		Для Каждого Параметр Из Параметры Цикл
			Если Параметр = "Пароль" Тогда
				ИспользованиеПараметра = ПараметрыУровня.ПарольУстановлен;
			Иначе
				ИспользованиеПараметра = ПараметрыУровня[Параметр] <> Неопределено;
			КонецЕсли; 
			Если ИспользованиеПараметра Тогда
				ПрименяемыеУровни.Вставить(Параметр, Счетчик);
			КонецЕсли; 
		КонецЦикла;
	КонецЦикла;
	Для Каждого Параметр Из Параметры Цикл
		Надпись = ЭлементыФормы["Надпись" + Параметр + "Применяется"];
		Если ПрименяемыеУровни[Параметр] = ТипПараметров Тогда
			Надпись.ЦветТекста = WebЦвета.Синий;
		Иначе
			Надпись.ЦветТекста = WebЦвета.Красный;
		КонецЕсли; 
		Если ПрименяемыеУровни[Параметр] = 0 Тогда
			Надпись.Заголовок = "Общие";
		ИначеЕсли ПрименяемыеУровни[Параметр] = 1 Тогда
			Надпись.Заголовок = "Пользователь";
		ИначеЕсли ПрименяемыеУровни[Параметр] = 2 Тогда
			Надпись.Заголовок = "Сеанс";
		Иначе
			Надпись.Заголовок = "Нет";
		КонецЕсли; 
	КонецЦикла;
КонецПроцедуры

Процедура ОтключитьсяОтВнешнегоИсточникаСервер()
	
	СтароеСостояние = ВнешниеИсточникиДанных[ВнешнийИсточник].ПолучитьСостояние();
	
	Если СтароеСостояние = СостояниеВнешнегоИсточникаДанных.Отключен Тогда
		
		ИсточникПодключен = Ложь;
		Возврат;
		
	КонецЕсли;
	
	Попытка
		
		ВнешниеИсточникиДанных[ВнешнийИсточник].РазорватьСоединение();
		ИсточникПодключен = Ложь;
		
	Исключение
		
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		ТекстСообщения = "Не удалось разорвать соединение. Описание ошибки:" + Символы.ПС + ИнформацияОбОшибке.Причина.Описание;
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = ТекстСообщения;
		Сообщение.Сообщить();
		
	КонецПопытки;
	ОбновитьСписокВнешнихИсточников();
	
КонецПроцедуры

Процедура ИспользованиеПриИзменении(Элемент)
	
	Для Каждого Параметр Из Параметры Цикл
		ЭтаФорма[Параметр + "Использование"] = Использование;
	КонецЦикла;
	ОбновитьВидимостьДоступность();
	
КонецПроцедуры

Процедура ТипПараметровПриИзменении(Элемент)
	
	ПриИзмененииТипаПараметров();
	
КонецПроцедуры

Процедура ТипПараметров1ПриИзменении(Элемент)
	
	ПриИзмененииТипаПараметров();
	
КонецПроцедуры

Процедура ТипПараметров2ПриИзменении(Элемент)
	
	ПриИзмененииТипаПараметров();
	
КонецПроцедуры

Процедура СУБДИспользованиеПриИзменении(Элемент)
	
	ОбновитьВидимостьДоступность();
	
КонецПроцедуры

Процедура АутентификацияСтандартнаяИспользованиеПриИзменении(Элемент)
	
	ОбновитьВидимостьДоступность();
	
КонецПроцедуры

Процедура ИмяПользователяИспользованиеПриИзменении(Элемент)
	
	ОбновитьВидимостьДоступность();
	
КонецПроцедуры

Процедура ПарольИспользованиеПриИзменении(Элемент)
	
	ПарольИзменен = Истина;
	ОбновитьВидимостьДоступность();
	
КонецПроцедуры

Процедура СтрокаСоединенияИспользованиеПриИзменении(Элемент)
	
	ОбновитьВидимостьДоступность();
	
КонецПроцедуры

Процедура ПарольПриИзменении(Элемент)
	
	ПарольИзменен = Истина;
	
КонецПроцедуры

Процедура ПолучитьИнформациюОСоединении()
	
	ПараметрыСоединенияТекущие = ПолучитьПараметрыСоединения();
	Если ПустаяСтрока(ВнешнийИсточник) Тогда
		ИсточникПодключен = Ложь;
	Иначе
		СтароеСостояние = ВнешниеИсточникиДанных[ВнешнийИсточник].ПолучитьСостояние();
		Если СтароеСостояние = СостояниеВнешнегоИсточникаДанных.Подключен Тогда
			ИсточникПодключен = Истина;
		Иначе
			ИсточникПодключен = Ложь;
		КонецЕсли;
	КонецЕсли;
	ПарольИзменен = Ложь;
	Использование = Ложь;
	Пароль = "";
	ПарольИспользование = Ложь;
	Для Каждого Параметр Из Параметры Цикл
		Если Параметр = "Пароль" Тогда
			Если ПараметрыСоединенияТекущие.ПарольУстановлен Тогда
				ПарольИспользование = Истина;
			КонецЕсли; 
		Иначе
			ПараметрВЭлементФормы(ПараметрыСоединенияТекущие, Параметр);
		КонецЕсли; 
	КонецЦикла;
	
КонецПроцедуры

Функция ПолучитьПараметрыСоединения(ТипПараметров = Неопределено)
	
	Если ТипПараметров = Неопределено Тогда
		ТипПараметров = ЭтаФорма.ТипПараметров;
	КонецЕсли; 
	Если ПустаяСтрока(ВнешнийИсточник) Тогда
		ПараметрыСоединенияТекущие = Новый ПараметрыСоединенияВнешнегоИсточникаДанных;
	Иначе
		Если ТипПараметров = 0 Тогда
			ПараметрыСоединенияТекущие = ВнешниеИсточникиДанных[ВнешнийИсточник].ПолучитьОбщиеПараметрыСоединения();
		ИначеЕсли ТипПараметров = 1 Тогда
			ПараметрыСоединенияТекущие = ВнешниеИсточникиДанных[ВнешнийИсточник].ПолучитьПараметрыСоединенияПользователя(ПользователиИнформационнойБазы.ТекущийПользователь().Имя);
		Иначе
			ПараметрыСоединенияТекущие = ВнешниеИсточникиДанных[ВнешнийИсточник].ПолучитьПараметрыСоединенияСеанса();
		КонецЕсли;
	КонецЕсли;
	Возврат ПараметрыСоединенияТекущие;
	
КонецФункции

Процедура ПараметрВЭлементФормы(ПараметрыСоединенияТекущие, ИмяПараметра)
	
	ЭтаФорма[ИмяПараметра] = ПараметрыСоединенияТекущие[ИмяПараметра];
	Если ИмяПараметра = "СУБД" И ЭтаФорма[ИмяПараметра] = "" Тогда
		ЭтаФорма[ИмяПараметра] = "Прочее";
	КонецЕсли;
	Если ПараметрыСоединенияТекущие[ИмяПараметра] = Неопределено Тогда
		ЭтаФорма[ИмяПараметра + "Использование"] = Ложь;
	Иначе
		ЭтаФорма[ИмяПараметра + "Использование"] = Истина;
		Использование = Истина;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриИзмененииТипаПараметров()
	
	Если Не ПроверитьИзменениеПараметров() Тогда
		ТипПараметров = ТипПараметровТекущий;
		Возврат;
	КонецЕсли;
	ТипПараметровТекущий = ТипПараметров;
	Модифицированность = Ложь;
	ПолучитьИнформациюОСоединении();
	ОбновитьВидимостьДоступность();
	
КонецПроцедуры

Процедура ОбновитьВидимостьДоступность()
	
	ИсточникВыбран = Не ПустаяСтрока(ВнешнийИсточник);
	ЭлементыФормы.ДействияФормы.Кнопки.Отключиться.Доступность = ИсточникВыбран;
	ЭлементыФормы.ДействияФормы.Кнопки.Подключиться.Доступность = ИсточникВыбран;
	ЭлементыФормы.ДействияФормы.Кнопки.СохранитьПараметры.Доступность = ИсточникВыбран;
	ЭлементыФормы.Использование.Доступность = ИсточникВыбран;
	ЭлементыФормы.СУБДИспользование.Доступность = ИсточникВыбран;
	ЭлементыФормы.АутентификацияСтандартнаяИспользование.Доступность = ИсточникВыбран;
	ЭлементыФормы.АутентификацияОСИспользование.Доступность = ИсточникВыбран;
	ЭлементыФормы.ИмяПользователяИспользование.Доступность = ИсточникВыбран;
	ЭлементыФормы.ПарольИспользование.Доступность = ИсточникВыбран;
	ЭлементыФормы.СтрокаСоединенияИспользование.Доступность = ИсточникВыбран;
	ЭлементыФормы.СУБД.ТолькоПросмотр = Не СУБДИспользование;
	ЭлементыФормы.АутентификацияСтандартная.Доступность = АутентификацияСтандартнаяИспользование;
	ЭлементыФормы.АутентификацияОС.Доступность = АутентификацияОСИспользование;
	ЭлементыФормы.ИмяПользователя.ТолькоПросмотр = Не ИмяПользователяИспользование;
	ЭлементыФормы.Пароль.ТолькоПросмотр = Не ПарольИспользование;
	ЭлементыФормы.СтрокаСоединения.ТолькоПросмотр = Не СтрокаСоединенияИспользование;
	Если ИсточникПодключен Тогда
		ЭлементыФормы.ИсточникПодключен.ЦветТекста = WebЦвета.Синий;
	Иначе
		ЭлементыФормы.ИсточникПодключен.ЦветТекста = WebЦвета.Красный;
	КонецЕсли;
	ОбновитьПрименение();
	
КонецПроцедуры

Функция ПроверитьИзменениеПараметров()
	
	Если Не Модифицированность Тогда
		Возврат Истина;
	КонецЕсли;
	Ответ = Вопрос("Параметры подключения были изменены. Сохранить изменения?", РежимДиалогаВопрос.ДаНетОтмена, 60);
	Если Ответ = КодВозвратаДиалога.Да Тогда
		СохранитьПараметрыСоединения();
		Возврат Истина;
	ИначеЕсли Ответ = КодВозвратаДиалога.Нет Тогда
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции

Процедура СтруктураКоманднойПанелиНажатие(Кнопка)
	
	ирОбщий.ОткрытьСтруктуруКоманднойПанелиЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура КлсКомандаНажатие(Кнопка) Экспорт 
	
	ирОбщий.УниверсальнаяКомандаФормыЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура СтрокаСоединенияНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	ирОбщий.ПолеВводаСтрокиСоединенияADODBНачалоВыбораЛкс(Элемент, СтандартнаяОбработка);
	
КонецПроцедуры

Процедура СУБДПриИзменении(Элемент)
	
	Если Истина
		И Элемент.Значение = "MSSQLServer"
		И Не ЗначениеЗаполнено(СтрокаСоединения) 
	Тогда
		СтрокаСоединения = "Driver={SQL Server}; Server=<ServerName>; DataBase=<DBName>;";
	КонецЕсли;
	
КонецПроцедуры

Процедура ВнешнееСобытие(Источник, Событие, Данные) Экспорт
	
	ирОбщий.Форма_ВнешнееСобытиеЛкс(ЭтаФорма, Источник, Событие, Данные);

КонецПроцедуры

Процедура ПриЗакрытии()
	
	ирОбщий.Форма_ПриЗакрытииЛкс(ЭтаФорма);

КонецПроцедуры

Процедура АутентификацияОСИспользованиеПриИзменении(Элемент)
	
	ОбновитьВидимостьДоступность();

КонецПроцедуры

Процедура ВнешниеИсточникиВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	ОткрытьОБъектМД(ВыбраннаяСтрока);
	
КонецПроцедуры

Процедура ОткрытьОБъектМД(Знач ВыбраннаяСтрока)
	
	ирОбщий.ОткрытьОбъектМетаданныхЛкс(Метаданные.ВнешниеИсточникиДанных[ВыбраннаяСтрока.Имя]);

КонецПроцедуры

Процедура ВнешниеИсточникиПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	ирОбщий.ТабличноеПолеПриВыводеСтрокиЛкс(ЭтаФорма, Элемент, ОформлениеСтроки, ДанныеСтроки);
	Если Не ДанныеСтроки.ЕстьДоступ Тогда
		ОформлениеСтроки.ЦветТекста = WebЦвета.Красный;
	КонецЕсли; 
КонецПроцедуры

Процедура ВнешниеИсточникиПриАктивизацииСтроки(Элемент)
	ирОбщий.ТабличноеПолеПриАктивизацииСтрокиЛкс(ЭтаФорма, Элемент);
	Если Элемент.ТекущаяСтрока <> Неопределено Тогда
		ЭтаФорма.ВнешнийИсточник = Элемент.ТекущаяСтрока.Имя;
		Если Не ПроверитьИзменениеПараметров() Тогда
			ЭтаФорма.ВнешнийИсточник = ВнешнийИсточникТекущий;
			Возврат;
		КонецЕсли;
		ЭтаФорма.ВнешнийИсточникТекущий = ВнешнийИсточник;
		Модифицированность = Ложь;
		ПолучитьИнформациюОСоединении();
		ОбновитьВидимостьДоступность();
	КонецЕсли; 
КонецПроцедуры

Процедура ДействияФормыОткрытьОбъектМетаданных(Кнопка)
	
	Если ЭлементыФормы.ВнешниеИсточники.ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	ОткрытьОБъектМД(ЭлементыФормы.ВнешниеИсточники.ТекущаяСтрока);
	
КонецПроцедуры

ирОбщий.ИнициироватьФормуЛкс(ЭтаФорма, "Обработка.ирПлатформа.Форма.ПодключениеВнешнихИсточниковДанных");

Параметры = Новый Массив;
Параметры.Добавить("СУБД");
Параметры.Добавить("АутентификацияСтандартная");
Если ирКэш.НомерВерсииПлатформыЛкс() >= 803001 Тогда
	Параметры.Добавить("АутентификацияОС");
КонецЕсли; 
Параметры.Добавить("ИмяПользователя");
Параметры.Добавить("Пароль");
Параметры.Добавить("СтрокаСоединения");