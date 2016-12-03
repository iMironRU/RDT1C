﻿//ирМобильный Перем ирМобильный Экспорт;
//ирМобильный Перем ирОбщий Экспорт;
//ирМобильный Перем ирСервер Экспорт;
//ирМобильный Перем ирКэш Экспорт;
//ирМобильный Перем ирПривилегированный Экспорт;

#Если Клиент Тогда
Перем мОбъектЗапроса Экспорт; // запрос
Перем мКомандаADO Экспорт; // запрос
Перем мСоединениеADO Экспорт; // запрос
Перем мWMIService Экспорт; // запрос
Перем мСтрокаЗапроса;
Перем мРежимРедактора Экспорт;
Перем мСсылка Экспорт;
Перем мРедактируемыйНаборДанных Экспорт;
Перем мРежимОтладки Экспорт;
Перем мКоллекцияДляЗаполнения Экспорт;

Функция ПолучитьНовуюТаблицуПараметров()

	ТаблицаПараметров = Новый ТаблицаЗначений;
	
	// Порядок должен соответствовать установленному в табличном поле!
	ТаблицаПараметров.Колонки.Добавить("ИмяПараметра");
	ТаблицаПараметров.Колонки.Добавить("ЭтоВыражение");
	ТаблицаПараметров.Колонки.Добавить("ТипЗначения");
	ТаблицаПараметров.Колонки.Добавить("НеИспользоватьОграничениеТипа");
	ТаблицаПараметров.Колонки.Добавить("Значение"); // Без колонки ТП
	ТаблицаПараметров.Колонки.Добавить("НИмяПараметра"); // Без колонки ТП
	Возврат ТаблицаПараметров;

КонецФункции // ПолучитьНовуюТаблицуПараметров()

Процедура ИнициализацияСлужебногоРежима()

	ЭтотОбъект.ИспользоватьАвтосохранение = Ложь;
	мСтрокаЗапроса = ДеревоЗапросов.Строки.Добавить();
	мСтрокаЗапроса.ПараметрыЗапроса = ПолучитьНовуюТаблицуПараметров();

КонецПроцедуры // ИнициализацияСлужебногоРежима

Процедура ДобавитьПараметрыИзЗапроса(пЗапросОтладки, пТаблицаПараметров, ОписаниеТиповЭлементаУправленияПараметра)

	МаркерНеверныхПараметров = "Неверные параметры";
	ЗапросОтладки = Новый Запрос(пЗапросОтладки.Текст);
	ЗапросОтладки.МенеджерВременныхТаблиц = пЗапросОтладки.МенеджерВременныхТаблиц;
	Попытка
		ПараметрыЗапроса = ЗапросОтладки.НайтиПараметры();
	Исключение
		Сообщить(ОписаниеОшибки());
		ПараметрыЗапроса = Новый Массив;
	КонецПопытки;
	// Получим значения использованных в тексте параметров
	Для каждого ПараметрЗапроса Из ПараметрыЗапроса Цикл
		Если пТаблицаПараметров.Найти(ПараметрЗапроса.Имя, "НИмяПараметра") <> Неопределено Тогда
			Продолжить;
		КонецЕсли;
		ИмяПараметра =  ПараметрЗапроса.Имя;
		СтрокаПараметров = пТаблицаПараметров.Добавить();
		СтрокаПараметров.ИмяПараметра = ИмяПараметра;
		ирОбщий.ОбновитьКопиюСвойстваВНижнемРегистреЛкс(СтрокаПараметров, "ИмяПараметра");
		СтрокаПараметров.ЭтоВыражение = Ложь;
		СтрокаПараметров.ТипЗначения = ПараметрЗапроса.ТипЗначения;
		ЗначениеПараметраЗапроса = 0;
		Если пЗапросОтладки.Параметры.Свойство(ИмяПараметра, ЗначениеПараметраЗапроса) Тогда
			ТипЗначенияПараметра = ТипЗнч(ЗначениеПараметраЗапроса);
			Если ТипЗначенияПараметра = Тип("Массив") Тогда 
				СписокЗначений = Новый СписокЗначений;
				ПреобразованиеУспешно = Истина;
				Для Каждого ЭлементМассива Из ЗначениеПараметраЗапроса Цикл
					Если ОписаниеТиповЭлементаУправленияПараметра.СодержитТип(ТипЗнч(ЭлементМассива)) Тогда
						СписокЗначений.Добавить(ЭлементМассива);
					Иначе
						ПреобразованиеУспешно = Ложь;
						Прервать;
					КонецЕсли;
				КонецЦикла;
				Если ПреобразованиеУспешно Тогда
					ЗначениеПараметраЗапроса = СписокЗначений;
					ТипЗначенияПараметра = ТипЗнч(ЗначениеПараметраЗапроса);
					Сообщить("Значение параметра """ + ИмяПараметра + """ было преобразовано из массива в список значений", СтатусСообщения.Внимание);
				КонецЕсли;
			КонецЕсли;
			СтрокаПараметров.Значение = ЗначениеПараметраЗапроса; 
			Если ТипЗначенияПараметра = Тип("СписокЗначений") Тогда 
				СтрокаПараметров.ЭтоВыражение = 2;
			ИначеЕсли ОписаниеТиповЭлементаУправленияПараметра.СодержитТип(ТипЗначенияПараметра) Тогда
			Иначе
				СтрокаПараметров.НеИспользоватьОграничениеТипа = Истина;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	// Получим значения установленных параметров
	ДополнитьТаблицуПараметровЗапросаПоСтруктуре(пЗапросОтладки.Параметры, пТаблицаПараметров);

КонецПроцедуры // ДобавитьПараметрыИзЗапроса()

Функция ДополнитьТаблицуПараметровЗапросаПоСтруктуре(СтруктураПараметров, пТаблицаПараметров)

	Для каждого КлючИЗначение Из СтруктураПараметров Цикл
		Если пТаблицаПараметров.Найти(НРег(КлючИЗначение.Ключ), "НИмяПараметра") <> Неопределено Тогда
			Продолжить;
		КонецЕсли;
		ИмяПараметра = КлючИЗначение.Ключ;
		СтрокаПараметров = пТаблицаПараметров.Добавить();
		СтрокаПараметров.ИмяПараметра = ИмяПараметра;
		ирОбщий.ОбновитьКопиюСвойстваВНижнемРегистреЛкс(СтрокаПараметров, "ИмяПараметра");
		СтрокаПараметров.ЭтоВыражение = Ложь;
		СтрокаПараметров.Значение = КлючИЗначение.Значение;
		Если ТипЗнч(КлючИЗначение.Значение) = Тип("СписокЗначений") Тогда 
			СтрокаПараметров.ЭтоВыражение = 2;
		КонецЕсли;
	КонецЦикла;

	Возврат Неопределено;

КонецФункции

Функция ОткрытьПоОбъектуМетаданных(ПолноеИмяМД) Экспорт
	
	ИнициализацияСлужебногоРежима();
	ТекстЗапроса = "ВЫБРАТЬ 
	|	* 
	|ИЗ
	|	" + ПолноеИмяМД + " КАК Т";
	мСтрокаЗапроса.ТекстЗапроса = ТекстЗапроса;
	мСтрокаЗапроса.Запрос = ПолноеИмяМД;
	Форма = ЭтотОбъект.ПолучитьФорму();
	Форма.Открыть();
	Возврат Форма;
	
КонецФункции 

// ТекстЗапроса - Строка - используется только в случае, если сам объект не содержит свойста с текстом (например WMI)
Функция ОткрытьДляОтладки(Запрос, ТипЗапроса = "Обычный", ИмяЗапроса = "Запрос для отладки", Модально = Истина, ТекстЗапроса = "") Экспорт
	
	ИнициализацияСлужебногоРежима();
	Если ТипЗнч(Запрос) = Тип("COMОбъект") Тогда
		ТипЗапроса = "WQL";
		мWMIService = Запрос;
		Попытка
			Пустышка = Запрос.CommandText;
			ЭтоКомандаADO = Истина;
			ТипЗапроса = "ADO";
			мКомандаADO = Запрос;
		Исключение
			ЭтоКомандаADO = Ложь;
			Попытка
				Пустышка = Запрос.ConnectionString;
				ЭтоСоединениеADO = Истина;
				ТипЗапроса = "ADO";
				мСоединениеADO = Запрос;
			Исключение
				ЭтоСоединениеADO = Ложь;
			КонецПопытки; 
		КонецПопытки; 
	Иначе
		мОбъектЗапроса = Запрос;
		ТекстЗапроса = мОбъектЗапроса.Текст;
	КонецЕсли; 
	мСтрокаЗапроса.ТекстЗапроса = ТекстЗапроса;
	мСтрокаЗапроса.Запрос = ИмяЗапроса;
	мСтрокаЗапроса.ТипЗапроса = ТипЗапроса;
	мРежимОтладки = Истина;
	Форма = ЭтотОбъект.ПолучитьФорму();
	ТаблицаПараметровЗапроса = Форма.ЭлементыФормы.Параметры.Значение;
	Если ТипЗнч(Запрос) = Тип("COMОбъект") Тогда
		Если ЭтоКомандаADO Тогда
			СтруктураПараметров = Новый Структура();
			Для Каждого Parameter Из Запрос.Parameters Цикл
				КлючПараметра = Parameter.Name;
				Если Не ирОбщий.ЛиИмяПеременнойЛкс(КлючПараметра) Тогда
					КлючПараметра = "_" + КлючПараметра;
				КонецЕсли; 
				Если Не ирОбщий.ЛиИмяПеременнойЛкс(КлючПараметра) Тогда
					КлючПараметра = КлючПараметра + XMLСтрока(СтруктураПараметров.Количество());
				КонецЕсли; 
				Если СтруктураПараметров.Свойство(КлючПараметра) Тогда
					ВызватьИсключение "Не удалось назначить параметру уникальное имя";
				КонецЕсли;
				СтруктураПараметров.Вставить(КлючПараметра, Parameter.Value);
			КонецЦикла;
			ДополнитьТаблицуПараметровЗапросаПоСтруктуре(СтруктураПараметров, ТаблицаПараметровЗапроса);
		КонецЕсли; 
	Иначе
		ДобавитьПараметрыИзЗапроса(Запрос, ТаблицаПараметровЗапроса, Форма.ЭлементыФормы.Параметры.Колонки.Значение.ЭлементУправления.ТипЗначения);
	КонецЕсли;
	Если Модально Тогда
		Возврат Форма.ОткрытьМодально();
	Иначе
		Форма.Открыть();
	КонецЕсли;
	
КонецФункции 

//Параметры:
// Коллекция - ТаблицаЗначений, ДеревоЗначений - если без колонок, то результату разрешается иметь произвольные колонки, иначе они фиксированы
// Запрос - Запрос, *Неопределено - начальный запрос
Функция ОткрытьДляЗаполненияКоллекции(КоллекцияДляЗаполнения, Запрос = Неопределено, ТипЗапроса = "Компоновка", Имя = "Запрос") Экспорт
	
	мКоллекцияДляЗаполнения = КоллекцияДляЗаполнения;
	мРежимЗаполненияКоллекции = Истина;
	ИнициализацияСлужебногоРежима();
	мСтрокаЗапроса.Запрос = Имя;
	мСтрокаЗапроса.ТипЗапроса = ТипЗапроса;
	Если Запрос <> Неопределено Тогда
		ТекстЗапроса = Запрос.Текст;
		мСтрокаЗапроса.ТекстЗапроса = ТекстЗапроса;
	КонецЕсли; 
	Форма = ЭтотОбъект.ПолучитьФорму();
	Если Запрос <> Неопределено Тогда
		ТаблицаПараметровЗапроса = Форма.ЭлементыФормы.Параметры.Значение;
		ДобавитьПараметрыИзЗапроса(Запрос, ТаблицаПараметровЗапроса, Форма.ЭлементыФормы.Параметры.Колонки.Значение.ЭлементУправления.ТипЗначения);
	КонецЕсли; 
	Результат = Форма.ОткрытьМодально();
	Если Форма.РезультатКоллекция.Количество() > 0 Тогда
		Ответ = Вопрос("Хотите заполнить коллекцию полученным результатом?", РежимДиалогаВопрос.ОКОтмена);
		Если Ответ = КодВозвратаДиалога.ОК Тогда
			Возврат Форма.РезультатКоллекция;
		КонецЕсли;
	КонецЕсли; 
	Возврат Неопределено;
	
КонецФункции

Функция ОткрытьПоПостроителю(Построитель, ИмяЗапроса = "Исполняемый запрос построителя") Экспорт
	
	ИнициализацияСлужебногоРежима();
	мСтрокаЗапроса.Запрос = ИмяЗапроса;
	ЗапросОтладки = Построитель.ПолучитьЗапрос();
	мСтрокаЗапроса.ТекстЗапроса = ЗапросОтладки.Текст;
	мСтрокаЗапроса.ТипЗапроса = "Построитель";
	Для Каждого ЭлементПараметра Из Построитель.Параметры Цикл
		СтрокаПараметров = мСтрокаЗапроса.ПараметрыЗапроса.Добавить();
		СтрокаПараметров.ИмяПараметра = ЭлементПараметра.Ключ;
		ирОбщий.ОбновитьКопиюСвойстваВНижнемРегистреЛкс(СтрокаПараметров, "ИмяПараметра");
		СтрокаПараметров.Значение = ЭлементПараметра.Значение;
		Если ТипЗнч(СтрокаПараметров.Значение) = Тип("СписокЗначений") Тогда 
			СтрокаПараметров.ЭтоВыражение = 2;
			СтрокаПараметров.ТипЗначения = СтрокаПараметров.Значение.ТипЗначения;
		Иначе
			СтрокаПараметров.ЭтоВыражение = Ложь;
			СтрокаПараметров.ТипЗначения = Новый ОписаниеТипов(ирОбщий.БыстрыйМассивЛкс(ТипЗнч(СтрокаПараметров.Значение)));
		КонецЕсли;
	КонецЦикла;
	Форма = ЭтотОбъект.ПолучитьФорму();
	ДобавитьПараметрыИзЗапроса(ЗапросОтладки, Форма.ЭлементыФормы.Параметры.Значение, 
		Форма.ЭлементыФормы.Параметры.Колонки.Значение.ЭлементУправления.ТипЗначения);
	мРежимОтладки = Истина;
	Форма.Открыть();
	
КонецФункции 

Процедура ДобавитьНаборыДанных(Родитель, ПараметрыЗапроса, НаборыДанных)

	Для каждого НаборДанных Из НаборыДанных Цикл
		лСтрокаЗапроса = Неопределено;
		Если ТипЗнч(НаборДанных) = Тип("НаборДанныхЗапросМакетаКомпоновкиДанных") Тогда
			лСтрокаЗапроса = Родитель.Строки.Добавить();
			лСтрокаЗапроса.Запрос = НаборДанных.Имя;
			лСтрокаЗапроса.ТекстЗапроса = НаборДанных.Запрос;
			лСтрокаЗапроса.ПараметрыЗапроса = ПараметрыЗапроса.Скопировать();
			лСтрокаЗапроса.ТипЗапроса = "Компоновка";
		ИначеЕсли ТипЗнч(НаборДанных) = Тип("НаборДанныхОбъединениеМакетаКомпоновкиДанных") Тогда
			лСтрокаЗапроса = Родитель.Строки.Добавить();
			лСтрокаЗапроса.Запрос = "Объединение - " + НаборДанных.Имя;
			лСтрокаЗапроса.ТипЗапроса = "Папка";
			ДобавитьНаборыДанных(лСтрокаЗапроса, ПараметрыЗапроса, НаборДанных.Элементы);
		КонецЕсли;
		Если НаборДанных.ВложенныеНаборыДанных.Количество() > 0 Тогда
			Если лСтрокаЗапроса = Неопределено Тогда
				лСтрокаЗапроса = Родитель.Строки.Добавить();
				лСтрокаЗапроса.Запрос = НаборДанных.Имя;
				лСтрокаЗапроса.ТипЗапроса = "Папка";
			КонецЕсли;
			ДобавитьНаборыДанных(лСтрокаЗапроса, ПараметрыЗапроса, НаборДанных.ВложенныеНаборыДанных);
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры // ДобавитьНаборыДанных()

Функция ОткрытьПоМакетуКомпоновки(МакетКомпоновки, Модально = Истина, СхемаКомпоновки = Неопределено) Экспорт
	
	//ИнициализацияСлужебногоРежима();
	ЭтотОбъект.ИспользоватьАвтосохранение = Ложь;
	ДобавитьМакетКомпоновки(ДеревоЗапросов, МакетКомпоновки);
	мРежимОтладки = Истина;
	Форма = ЭтотОбъект.ПолучитьФорму();
	Если Модально Тогда
		Возврат Форма.ОткрытьМодально();
	Иначе
		Форма.Открыть();
	КонецЕсли;
	
КонецФункции

Функция ДобавитьМакетКомпоновки(СтрокаДереваЗапросов, МакетКомпоновки)

	ПараметрыЗапроса = ПолучитьНовуюТаблицуПараметров();
	ЗаполнитьПараметрыИзМакетаКомпоновки(ПараметрыЗапроса, МакетКомпоновки);
	ДобавитьНаборыДанных(СтрокаДереваЗапросов, ПараметрыЗапроса, МакетКомпоновки.НаборыДанных);
	Для Каждого ЭлементТела Из МакетКомпоновки.Тело Цикл
		Если ТипЗнч(ЭлементТела) = Тип("ВложенныйОбъектМакетаКомпоновкиДанных") Тогда
			Если ЭлементТела.КомпоновкаДанных.НаборыДанных.Количество() > 0 Тогда
				лСтрокаЗапроса = СтрокаДереваЗапросов.Строки.Добавить();
				лСтрокаЗапроса.Запрос = ЭлементТела.Имя;
				лСтрокаЗапроса.ТипЗапроса = "Папка";
				ДобавитьМакетКомпоновки(лСтрокаЗапроса, ЭлементТела.КомпоновкаДанных);
			КонецЕсли;
		КонецЕсли; 
	КонецЦикла;

КонецФункции

Процедура ЗаполнитьПараметрыИзМакетаКомпоновки(ПараметрыЗапроса, МакетКомпоновки)

	Для Каждого Значение Из МакетКомпоновки.ЗначенияПараметров Цикл
		СтрокаПараметров = ПараметрыЗапроса.Добавить();
		СтрокаПараметров.ИмяПараметра = Значение.Имя;
		ирОбщий.ОбновитьКопиюСвойстваВНижнемРегистреЛкс(СтрокаПараметров, "ИмяПараметра");
		СтрокаПараметров.Значение = Значение.Значение; 
		//ПараметрСхемы = Неопределено;
		//Если СхемаКомпоновки <> Неопределено Тогда 
		//	ПараметрСхемы = СхемаКомпоновки.Параметры.Найти(Значение.Имя);
		//КонецЕсли; 
		Если ТипЗнч(СтрокаПараметров.Значение) = Тип("СписокЗначений") Тогда 
			СтрокаПараметров.ЭтоВыражение = 2;
			СтрокаПараметров.ТипЗначения = СтрокаПараметров.Значение.ТипЗначения;
		//ИначеЕсли Истина
		//	И ПараметрСхемы <> Неопределено
		//	И ПараметрСхемы.Выражение <> ""
		//Тогда
		//	СтрокаПараметров.ЭтоВыражение = Истина;
		Иначе
			СтрокаПараметров.ЭтоВыражение = Ложь;
			СтрокаПараметров.ТипЗначения = Новый ОписаниеТипов(ирОбщий.БыстрыйМассивЛкс(ТипЗнч(СтрокаПараметров.Значение)));
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры

Функция РедактироватьНаборДанныхСхемыКомпоновкиДанных(ВладелецФормы, НаборДанных, Схема) Экспорт

	мРежимРедактора = Истина;
	мРедактируемыйНаборДанных = НаборДанных;
	ИнициализацияСлужебногоРежима();
	мСтрокаЗапроса.Запрос = НаборДанных.Имя;
	ПараметыСхемы = Схема.Параметры;
	Для Каждого ПараметрСхемы Из ПараметыСхемы Цикл
		СтрокаПараметров = мСтрокаЗапроса.ПараметрыЗапроса.Добавить();
		СтрокаПараметров.ИмяПараметра = ПараметрСхемы.Имя;
		ирОбщий.ОбновитьКопиюСвойстваВНижнемРегистреЛкс(СтрокаПараметров, "ИмяПараметра");
		СтрокаПараметров.Значение = ПараметрСхемы.Значение;
		СтрокаПараметров.ТипЗначения = ПараметрСхемы.ТипЗначения;
		Если ПараметрСхемы.Выражение <> "" Тогда
			СтрокаПараметров.ЭтоВыражение = Истина;
			СтрокаПараметров.Значение = ПараметрСхемы.Выражение;
		ИначеЕсли ТипЗнч(ПараметрСхемы.Значение) = Тип("СписокЗначений") Тогда 
			СтрокаПараметров.ЭтоВыражение = 2;
		Иначе
			СтрокаПараметров.ЭтоВыражение = Ложь;
		КонецЕсли;
	КонецЦикла;
	мСтрокаЗапроса.ТекстЗапроса = НаборДанных.Запрос;
	мСтрокаЗапроса.ТипЗапроса = "Компоновка";
	Форма = ЭтотОбъект.ПолучитьФорму(, ВладелецФормы);
	Форма.Открыть();
	
КонецФункции // РедактироватьНаборДанныхСхемыКомпоновкиДанных()

Функция РедактироватьСтруктуруЗапроса(ВладелецФормы, СтруктураЗапроса) Экспорт

	мРежимРедактора = Истина;
	ИнициализацияСлужебногоРежима();
	Если СтруктураЗапроса.Свойство("Имя") Тогда
		мСтрокаЗапроса.Запрос = СтруктураЗапроса.Имя;
	КонецЕсли;
	Если СтруктураЗапроса.Свойство("Ссылка") Тогда
		мСсылка = СтруктураЗапроса.Ссылка;
	КонецЕсли;
	Если СтруктураЗапроса.Свойство("Параметры") Тогда
		мСтрокаЗапроса.ПараметрыЗапроса = СтруктураЗапроса.Параметры.Скопировать();
	КонецЕсли;
	мСтрокаЗапроса.ТекстЗапроса = СтруктураЗапроса.ТекстЗапроса;
	Если СтруктураЗапроса.Свойство("ТипЗапроса") Тогда
		мСтрокаЗапроса.ТипЗапроса = СтруктураЗапроса.ТипЗапроса;
	Иначе
		мСтрокаЗапроса.ТипЗапроса = "Построитель";
	КонецЕсли;
	Форма = ЭтотОбъект.ПолучитьФорму(, ВладелецФормы);
	Форма.Открыть();
	
КонецФункции // РедактироватьСтруктуруЗапроса()

//ирМобильный #Если Клиент Тогда
//ирМобильный Контейнер = Новый Структура();
//ирМобильный Оповестить("ирПолучитьБазовуюФорму", Контейнер);
//ирМобильный Если Не Контейнер.Свойство("ирМобильный", ирМобильный) Тогда
//ирМобильный 	ПолноеИмяФайлаБазовогоМодуля = ВосстановитьЗначение("ирПолноеИмяФайлаОсновногоМодуля");
//ирМобильный 	ирМобильный = ВнешниеОбработки.ПолучитьФорму(ПолноеИмяФайлаБазовогоМодуля);
//ирМобильный КонецЕсли; 
//ирМобильный ирОбщий = ирМобильный.ПолучитьОбщийМодульЛкс("ирОбщий");
//ирМобильный ирКэш = ирМобильный.ПолучитьОбщийМодульЛкс("ирКэш");
//ирМобильный ирСервер = ирМобильный.ПолучитьОбщийМодульЛкс("ирСервер");
//ирМобильный ирПривилегированный = ирМобильный.ПолучитьОбщийМодульЛкс("ирПривилегированный");
//ирМобильный #КонецЕсли

мОбъектЗапроса = Новый Запрос;
мРежимРедактора = Ложь;
мРежимОтладки = Ложь;

// Создадим структуру дерева запросов
ДеревоЗапросов.Колонки.Добавить("Запрос");
ДеревоЗапросов.Колонки.Добавить("ТекстЗапроса");
ДеревоЗапросов.Колонки.Добавить("ПараметрыЗапроса");
ДеревоЗапросов.Колонки.Добавить("СпособВыгрузки", Новый ОписаниеТипов("Число"));
ДеревоЗапросов.Колонки.Добавить("НовыйМенеджерВременныхТаблиц", Новый ОписаниеТипов("Булево"));
ДеревоЗапросов.Колонки.Добавить("КодОбработкиСтрокиРезультата");
ДеревоЗапросов.Колонки.Добавить("КодПередВыполнениемЗапроса");
ДеревоЗапросов.Колонки.Добавить("КодОбработкиРезультата");
ДеревоЗапросов.Колонки.Добавить("Настройка");
ДеревоЗапросов.Колонки.Добавить("ВыбратьВсеПоля", Новый ОписаниеТипов("Булево"));
ДеревоЗапросов.Колонки.Добавить("ТипЗапроса", Новый ОписаниеТипов("Строка"));
ДеревоЗапросов.Колонки.Добавить("Длительность", Новый ОписаниеТипов("Число, Строка"));
ДеревоЗапросов.Колонки.Добавить("РазмерРезультата", Новый ОписаниеТипов("Число, Строка"));
ДеревоЗапросов.Колонки.Добавить("ПараметрыWMI");
ДеревоЗапросов.Колонки.Добавить("ПараметрыADO");
ДеревоЗапросов.Колонки.Добавить("СтандартнаяВыгрузкаВДерево", Новый ОписаниеТипов("Булево"));
ДеревоЗапросов.Колонки.Добавить("АвтовыборкиИтогов", Новый ОписаниеТипов("Булево"));
ДеревоЗапросов.Колонки.Добавить("ДобавлятьСлужебныеКолонкиРезультата", Новый ОписаниеТипов("Булево"));
ДеревоЗапросов.Колонки.Добавить("ОбходитьИерархическиеВыборкиРекурсивно", Новый ОписаниеТипов("Булево"));
ДеревоЗапросов.Колонки.Добавить("ВыборкиИтогов");
#КонецЕсли
