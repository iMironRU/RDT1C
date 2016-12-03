﻿//ирПортативный Перем ирПортативный Экспорт;
//ирПортативный Перем ирОбщий Экспорт;
//ирПортативный Перем ирСервер Экспорт;
//ирПортативный Перем ирКэш Экспорт;
//ирПортативный Перем ирПривилегированный Экспорт;

Перем мРежимРедактора Экспорт;
Перем мИмяРедактируемойСхемы Экспорт;
Перем мВнешниеНаборыДанных Экспорт;
Перем мСхемаКомпоновкиДанных Экспорт;

Функция ОткрытьПоОбъектуМетаданных(ПолноеИмяМД, Отбор = Неопределено) Экспорт
	
	мСхемаКомпоновкиДанных = ирОбщий.ПолучитьСхемуКомпоновкиПоОбъектуМетаданныхЛкс(ПолноеИмяМД);
	КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(мСхемаКомпоновкиДанных));
	КорневойТип = ирОбщий.ПолучитьПервыйФрагментЛкс(ПолноеИмяМД);
	НаборПолейВыбора = Новый Массив();
	НаборПолейПорядка = Новый Массив();
	МассивФрагментов = ирОбщий.ПолучитьМассивИзСтрокиСРазделителемЛкс(ПолноеИмяМД);
	Если Истина
		И МассивФрагментов.Количество() = 3
		И МассивФрагментов[2] = "Изменения"
	Тогда
		Построитель = Новый ПостроительЗапроса("ВЫБРАТЬ Т.* ИЗ " + ПолноеИмяМД + " КАК Т");
		Построитель.ЗаполнитьНастройки();
		Для Каждого ДоступноеПоле Из Построитель.ДоступныеПоля Цикл
			НаборПолейВыбора.Добавить(ДоступноеПоле.ПутьКДанным);
			НаборПолейПорядка.Добавить(ДоступноеПоле.ПутьКДанным);
		КонецЦикла; 
	ИначеЕсли ирОбщий.ЛиКорневойТипОбъектаБДЛкс(КорневойТип) Тогда
		НаборПолейВыбора.Добавить("Ссылка");
		НаборПолейПорядка.Добавить("Ссылка");
	Иначе
		НаборЗаписей = Новый (СтрЗаменить(ПолноеИмяМД, ".", "НаборЗаписей."));
		Для Каждого ЭлементОтбора Из НаборЗаписей.Отбор Цикл
			НаборПолейВыбора.Добавить(ЭлементОтбора.ПутьКДанным);
			НаборПолейПорядка.Добавить(ЭлементОтбора.ПутьКДанным);
		КонецЦикла; 
	КонецЕсли; 
	Для Каждого Поле Из НаборПолейВыбора Цикл
		ирОбщий.НайтиДобавитьЭлементНастроекКомпоновкиПоПолюЛкс(КомпоновщикНастроек.Настройки.Выбор, Поле);
	КонецЦикла; 
	Для Каждого Поле Из НаборПолейПорядка Цикл
		ирОбщий.НайтиДобавитьЭлементНастроекКомпоновкиПоПолюЛкс(КомпоновщикНастроек.Настройки.Порядок, Поле);
	КонецЦикла; 
	ирОбщий.НайтиДобавитьЭлементСтруктурыГруппировкаКомпоновкиЛкс(КомпоновщикНастроек.Настройки.Структура);
	Если Отбор <> Неопределено Тогда
		Для Каждого КлючИЗначение Из Отбор Цикл
			ирОбщий.НайтиДобавитьЭлементОтбораКомпоновкиЛкс(КомпоновщикНастроек.Настройки.Отбор, КлючИЗначение.Ключ, КлючИЗначение.Значение);
		КонецЦикла; 
	КонецЕсли; 
	Форма = ЭтотОбъект.ПолучитьФорму();
	Форма.Открыть();
	Возврат Форма;
	
КонецФункции 

Функция ОткрытьПоТаблицеЗначений(ТаблицаЗначений) Экспорт
	
	мСхемаКомпоновкиДанных = ирОбщий.СоздатьСхемуПоТаблицамЗначенийЛкс(Новый Структура("Основной", ТаблицаЗначений));
	КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(мСхемаКомпоновкиДанных));
	Для Каждого Колонка Из ТаблицаЗначений.Колонки Цикл
		//ирОбщий.НайтиДобавитьЭлементНастроекКомпоновкиПоПолюЛкс(КомпоновщикНастроек.Настройки.Порядок, Колонка.Имя);
		ирОбщий.НайтиДобавитьЭлементНастроекКомпоновкиПоПолюЛкс(КомпоновщикНастроек.Настройки.Выбор, Колонка.Имя);
	КонецЦикла;
	мВнешниеНаборыДанных = Новый Структура("Основной", ТаблицаЗначений);
	ирОбщий.НайтиДобавитьЭлементСтруктурыГруппировкаКомпоновкиЛкс(КомпоновщикНастроек.Настройки.Структура);
	Форма = ЭтотОбъект.ПолучитьФорму();
	Форма.Открыть();
	Возврат Форма;
	
КонецФункции 

Функция ОткрытьПоЗапросу(Запрос, Отбор = Неопределено) Экспорт
	
	мСхемаКомпоновкиДанных = ирОбщий.ПолучитьСхемуКомпоновкиПоЗапросуЛкс(Запрос);
	Попытка
		КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(мСхемаКомпоновкиДанных));
	Исключение
		Сообщить(ОписаниеОшибки());
	КонецПопытки; 
	Для Каждого ДоступноеПоле Из КомпоновщикНастроек.Настройки.ДоступныеПоляВыбора.Элементы Цикл
		Если Не ДоступноеПоле.Папка Тогда
			ирОбщий.НайтиДобавитьЭлементНастроекКомпоновкиПоПолюЛкс(КомпоновщикНастроек.Настройки.Выбор, ДоступноеПоле.Поле);
			ирОбщий.НайтиДобавитьЭлементНастроекКомпоновкиПоПолюЛкс(КомпоновщикНастроек.Настройки.Порядок, ДоступноеПоле.Поле);
		КонецЕсли; 
	КонецЦикла;
	Для Каждого ЗначениеПараметра Из КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы Цикл
		ЗначениеПараметра.Использование = Истина;
	КонецЦикла;
	Если Отбор <> Неопределено Тогда
		Для Каждого КлючИЗначение Из Отбор Цикл
			ирОбщий.НайтиДобавитьЭлементОтбораКомпоновкиЛкс(КомпоновщикНастроек.Настройки.Отбор, КлючИЗначение.Ключ, КлючИЗначение.Значение);
		КонецЦикла; 
	КонецЕсли; 
	ирОбщий.НайтиДобавитьЭлементСтруктурыГруппировкаКомпоновкиЛкс(КомпоновщикНастроек.Настройки.Структура);
	Форма = ЭтотОбъект.ПолучитьФорму();
	Форма.Открыть();
	Возврат Форма;
	
КонецФункции 

Функция ОткрытьДляОтладки(СхемаКомпоновки, Настройки = Неопределено, ВнешниеНаборыДанных = Неопределено,
	Модально = Истина) Экспорт
	
	мИмяРедактируемойСхемы = Неопределено;
	Форма = ЭтотОбъект.ПолучитьФорму();
	мСхемаКомпоновкиДанных = ирОбщий.ПолучитьКопиюОбъектаЛкс(СхемаКомпоновки);
	Если Настройки <> Неопределено Тогда
		Для Каждого ПараметрСхемы Из мСхемаКомпоновкиДанных.Параметры Цикл
			Если Не ПараметрСхемы.ОграничениеИспользования Тогда 
				Продолжить;
			КонецЕсли;
			ЗначениеПараметра = Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных(ПараметрСхемы.Имя));
			Если Истина
				И ЗначениеПараметра <> Неопределено
				И ЗначениеПараметра.Использование
			Тогда 
				ПараметрСхемы.ОграничениеИспользования = Ложь;
				Сообщить("Для используемого скрытого параметра """ + ПараметрСхемы.Имя + """ выполнено снятие ограничения использования");
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	Попытка
		КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(мСхемаКомпоновкиДанных));
	Исключение
		Сообщить(ОписаниеОшибки());
	КонецПопытки; 
	Если Настройки <> Неопределено Тогда
		КомпоновщикНастроек.ЗагрузитьНастройки(Настройки);
	КонецЕсли;
	мВнешниеНаборыДанных = ВнешниеНаборыДанных;
	Если мВнешниеНаборыДанных = Неопределено Тогда
		мВнешниеНаборыДанных = Новый Структура;
	КонецЕсли;
	Если Модально Тогда
		Возврат Форма.ОткрытьМодально();
	Иначе
		Форма.Открыть();
	КонецЕсли;
	
КонецФункции 

Процедура ОткрытьПоТабличномуПолю(ТабличноеПоле, СхемаКомпоновки = Неопределено, НастройкаКомпоновки = Неопределено, ВнешниеНаборыДанных = Неопределено) Экспорт
	
	Если ВнешниеНаборыДанных = Неопределено Тогда
		ВнешниеНаборыДанных = Новый Структура("Основной", ТабличноеПоле.Значение);
	КонецЕсли;
	Если СхемаКомпоновки = Неопределено Тогда
		мСхемаКомпоновкиДанных = ирОбщий.СоздатьСхемуПоТаблицамЗначенийЛкс(ВнешниеНаборыДанных);
	Иначе
		мСхемаКомпоновкиДанных = СхемаКомпоновки;
	КонецЕсли; 
	Попытка
		КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(мСхемаКомпоновкиДанных));
	Исключение
		Сообщить(ОписаниеОшибки());
	КонецПопытки; 
	КомпоновщикНастроек.ЗагрузитьНастройки(НастройкаКомпоновки);
	Если КомпоновщикНастроек.Настройки.Структура.Количество() = 0 Тогда
		ирОбщий.НайтиДобавитьЭлементСтруктурыГруппировкаКомпоновкиЛкс(КомпоновщикНастроек.Настройки.Структура);
	КонецЕсли; 
	Для Каждого КолонкаТП Из ТабличноеПоле.Колонки Цикл
		ирОбщий.НайтиДобавитьЭлементНастроекКомпоновкиПоПолюЛкс(КомпоновщикНастроек.Настройки.Выбор, КолонкаТП.Данные);
	КонецЦикла;
    ОткрытьДляОтладки(СхемаКомпоновки, КомпоновщикНастроек.Настройки, ВнешниеНаборыДанных, Ложь);
	
КонецПроцедуры

Функция РедактироватьСтруктуруСхемы(ВладелецФормы, СтруктураСхемы, Модально = Ложь) Экспорт

	мИмяРедактируемойСхемы = Неопределено;
	мРежимРедактора = Истина;
	мСхемаКомпоновкиДанных = СтруктураСхемы.СхемаКомпоновки;
	Попытка
		КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(мСхемаКомпоновкиДанных));
	Исключение
		Сообщить(ОписаниеОшибки());
	КонецПопытки; 
	Если СтруктураСхемы.Свойство("Настройки") Тогда
		КомпоновщикНастроек.ЗагрузитьНастройки(СтруктураСхемы.Настройки);
	КонецЕсли;
	Если СтруктураСхемы.Свойство("Имя") Тогда
		мИмяРедактируемойСхемы = СтруктураСхемы.Имя;
	КонецЕсли;
	Форма = ЭтотОбъект.ПолучитьФорму("Форма", ВладелецФормы);
	Если СтруктураСхемы.Свойство("РазрешитьРедактироватьСхему") Тогда
		Форма.ЭлементыФормы.ДеревоОтчетов.ТолькоПросмотр = Не СтруктураСхемы.РазрешитьРедактироватьСхему;
	КонецЕсли; 
	Если Модально Тогда
		Результат = Форма.ОткрытьМодально();
	Иначе
		Форма.Открыть();
	КонецЕсли; 
	Возврат Результат;
	
КонецФункции // РедактироватьСтруктуруСхемы()

Функция ПолучитьПутьСтроки(Строка) Экспорт

	ПутьСтроки = Неопределено;

	Если Строка <> Неопределено Тогда
		ТС = Строка;
		Пока ТС <> Неопределено Цикл
			Если ПутьСтроки = Неопределено Тогда
				ПутьСтроки = ТС.ИмяОтчета;
			Иначе
				ПутьСтроки = ТС.ИмяОтчета + Символы.ПС + ПутьСтроки;
			КонецЕсли;
			ТС = ТС.Родитель;
		КонецЦикла;
	КонецЕсли;

	Возврат ПутьСтроки;

КонецФункции

Функция НайтиСтрокуПоПути(Путь) Экспорт

	ТекущаяСтрокаДерева = Неопределено;

	Если Путь <> Неопределено Тогда

		Для тс = 1 По СтрЧислоСтрок(Путь) Цикл

			ТекущееИмяОтчета = СтрПолучитьСтроку(Путь, тс);

			Если ТекущаяСтрокаДерева = Неопределено Тогда 
				Строки = ДеревоОтчетов.Строки;
			Иначе
				Строки = ТекущаяСтрокаДерева.Строки;
			КонецЕсли;

			Найдено = Ложь;
			Для Каждого сд Из Строки Цикл
				Если сд.ИмяОтчета = ТекущееИмяОтчета Тогда
					// Нашли текущее имя
					Найдено = Истина;
					ТекущаяСтрокаДерева = сд;
					Прервать;
				КонецЕсли;
			КонецЦикла;

			Если Не Найдено Тогда
				Прервать;
			КонецЕсли;

		КонецЦикла;

	КонецЕсли;

	Возврат ТекущаяСтрокаДерева;

КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Вывод макета компоновки в табличный документ

Функция ПолучитьПредставлениеМакетовМакетаКомпоновкиДанных(СхемаКомпоновкиДанных = Неопределено, НастройкиКомпоновкиДанных = Неопределено, МакетКомпоновки = Неопределено) Экспорт
	
	Если МакетКомпоновки = Неопределено Тогда
		КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
		МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, НастройкиКомпоновкиДанных);
	КонецЕсли;
	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.НачатьВывод();
	
	ЭлементРезультата = Новый ЭлементРезультатаКомпоновкиДанных;
	ЭлементРезультата.ТипЭлемента = ТипЭлементаРезультатаКомпоновкиДанных.Начало;
	ЭлементРезультата.РасположениеВложенныхЭлементов = РасположениеВложенныхЭлементовРезультатаКомпоновкиДанных.Вертикально;
	ПроцессорВывода.ВывестиЭлемент(ЭлементРезультата);
	
	Для Каждого ОписаниеМакетаОбластиМакетаКомпоновкиДанных Из МакетКомпоновки.Макеты Цикл
		Если ТипЗнч(ОписаниеМакетаОбластиМакетаКомпоновкиДанных.Макет) = Тип("МакетОбластиКомпоновкиДанных") Тогда
			ВывестиОПисание(ОписаниеМакетаОбластиМакетаКомпоновкиДанных.Имя, ПроцессорВывода);
			ВывестиМакетОбласти(ОписаниеМакетаОбластиМакетаКомпоновкиДанных, ПроцессорВывода, МакетКомпоновки.ЗначенияПараметров);
		КонецЕсли;
	КонецЦикла;
	
	ЭлементРезультата = Новый ЭлементРезультатаКомпоновкиДанных;
	ЭлементРезультата.ТипЭлемента = ТипЭлементаРезультатаКомпоновкиДанных.Конец;
	ПроцессорВывода.ВывестиЭлемент(ЭлементРезультата);
	
	ТабличныйДокумент = ПроцессорВывода.ЗакончитьВывод();
	
	Возврат ТабличныйДокумент;
	
КонецФункции

Функция ПолучитьПредставлениеТелаМакетаКомпоновкиДанных(СхемаКомпоновкиДанных = Неопределено, НастройкиКомпоновкиДанных = Неопределено, МакетКомпоновки = Неопределено) Экспорт
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	
	Если МакетКомпоновки = Неопределено Тогда
		КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
		МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, НастройкиКомпоновкиДанных);
	КонецЕсли;
	
	ТелоXDTO = СериализаторXDTO.ЗаписатьXDTO(МакетКомпоновки).body;
	ВывестиСписокXDTO(ТелоXDTO, ТабличныйДокумент, 0, 0);
	
	Возврат ТабличныйДокумент;
	
КонецФункции

Функция ПолучитьПредставлениеМакетовИТелаМакетаКомпоновкиДанных(СхемаКомпоновкиДанных = Неопределено, НастройкиКомпоновкиДанных = Неопределено, МакетКомпоновки = Неопределено) Экспорт
	
	Если МакетКомпоновки = Неопределено Тогда
		КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
		МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, НастройкиКомпоновкиДанных);
	КонецЕсли;
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ПредставлениеМакетов = ПолучитьПредставлениеМакетовМакетаКомпоновкиДанных(СхемаКомпоновкиДанных, НастройкиКомпоновкиДанных, МакетКомпоновки);
	ПредставлениеТела = ПолучитьПредставлениеТелаМакетаКомпоновкиДанных(СхемаКомпоновкиДанных, НастройкиКомпоновкиДанных, МакетКомпоновки);
	ТабличныйДокумент.Вывести(ПредставлениеТела);
	ТабличныйДокумент.Вывести(ПредставлениеМакетов);
	Возврат ТабличныйДокумент;
	
КонецФункции

Процедура ВывестиСписокXDTO(СписокXDTO, ТабличныйДокумент, НомерСтроки, НомерКолонки)
	
	Линия = Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Точечная);
	МаксимальныйНомерСтроки = 0;
	СчетчикЭлементов = 0;
	КоличествоЭлементов = СписокXDTO.Количество();
	Для Каждого ЭлементСпискаXDTO Из СписокXDTO Цикл
		СчетчикЭлементов = СчетчикЭлементов + 1;
		ТекущийНомерСтроки = НомерСтроки;
		НомерКолонки = НомерКолонки + 1;
		НомерКолонкиПередВыводом = НомерКолонки;
		Если ТипЗнч(ЭлементСпискаXDTO) = Тип("ОбъектXDTO") Тогда
			ВывестиОбъектXDTO(ЭлементСпискаXDTO, ТабличныйДокумент, НомерСтроки, НомерКолонки);
		Иначе
			ВывестиОбъект(ЭлементСпискаXDTO, ТабличныйДокумент, НомерСтроки, НомерКолонки);
		КонецЕсли;
		МаксимальныйНомерСтроки = Макс(НомерСтроки, МаксимальныйНомерСтроки);
		НомерСтроки = ТекущийНомерСтроки;
		Если СчетчикЭлементов < КоличествоЭлементов Тогда
			Если НомерКолонки > НомерКолонкиПередВыводом Тогда
				ОбластьЯчеек = ТабличныйДокумент.Область(НомерСтроки+1, НомерКолонкиПередВыводом+1, НомерСтроки+1, НомерКолонки);
				ОбластьЯчеек.ЦветФона = WebЦвета.СветлоЖелтый;
				ОбластьЯчеек.Обвести( , Линия, , Линия);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	НомерСтроки = МаксимальныйНомерСтроки;
	
КонецПроцедуры

Процедура ВывестиОбъектXDTO(ОбъектXDTO, ТабличныйДокумент, НомерСтроки, НомерКолонки)
	
	Линия = Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная);
	СвойстваXDTO = ОбъектXDTO.Свойства();
	
	МаксимальныйНомерКолонки = НомерКолонки;
	
	Для Каждого СвойствоXDTO Из СвойстваXDTO Цикл
		ИмяСвойства = СвойствоXDTO.Имя;
		ЗначениеСвойства = ОбъектXDTO[ИмяСвойства];
		Если ЗначениеЗаполнено(ЗначениеСвойства) Тогда
			НомерСтроки = НомерСтроки + 1;
			ОбластьЯчеек = ТабличныйДокумент.Область(НомерСтроки, НомерКолонки);
			ОбластьЯчеек.ШиринаКолонки = 25;
			ОбластьЯчеек.РазмещениеТекста = ТипРазмещенияТекстаТабличногоДокумента.Переносить;
			ОбластьЯчеек.Обвести(Линия, Линия, Линия, Линия);
			Если ТипЗнч(ЗначениеСвойства) = Тип("СписокXDTO") Тогда
				ОбластьЯчеек.Текст = ИмяСвойства;
				ТекущийНомерКолонки = НомерКолонки;
				НомерСтрокиПередВыводом = НомерСтроки;
				ВывестиСписокXDTO(ЗначениеСвойства, ТабличныйДокумент, НомерСтроки, НомерКолонки);
				МаксимальныйНомерКолонки = Макс(НомерКолонки, МаксимальныйНомерКолонки);
				НомерКолонки = ТекущийНомерКолонки;
				ОбластьЯчеек = ТабличныйДокумент.Область(НомерСтрокиПередВыводом, НомерКолонки, НомерСтроки, НомерКолонки);
				ОбластьЯчеек.Объединить();
				ОбластьЯчеек.Обвести(Линия, Линия, Линия, Линия);
				ОбластьЯчеек.ВертикальноеПоложение = ВертикальноеПоложение.Центр;
			Иначе
				ОбластьЯчеек.Текст = ИмяСвойства + " = " + Строка(ЗначениеСвойства);
			КонецЕсли;
			ОбластьЯчеек.ЦветФона = WebЦвета.СветлоЖелтый;
		КонецЕсли;
	КонецЦикла;
	
	НомерКолонки = МаксимальныйНомерКолонки;
	
КонецПроцедуры

Процедура ВывестиОбъект(ЭлементСпискаXDTO, ТабличныйДокумент, НомерСтроки, НомерКолонки)
	
	Если ЗначениеЗаполнено(ЭлементСпискаXDTO) Тогда
		НомерСтроки = НомерСтроки + 1;
		ОбластьЯчеек = ТабличныйДокумент.Область(НомерСтроки, НомерКолонки);
		ОбластьЯчеек.ШиринаКолонки = 25;
		ОбластьЯчеек.РазмещениеТекста = ТипРазмещенияТекстаТабличногоДокумента.Переносить;
		Линия = Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная);
		ОбластьЯчеек.Обвести(Линия, Линия, Линия, Линия);
		ОбластьЯчеек.Текст = Строка(ЭлементСпискаXDTO);
		ОбластьЯчеек.ЦветФона = WebЦвета.СветлоЖелтый;
	КонецЕсли;
	
КонецПроцедуры

Процедура ВывестиМакетОбласти(Макет, ПроцессорВывода, МакетКомпоновкиЗначенияПараметров)
	
	ЭлементРезультата = Новый ЭлементРезультатаКомпоновкиДанных;
	ЭлементРезультата.Макет = Макет.Имя;
	ОписаниеМакетаОбластиМакетаКомпоновкиДанных = ЭлементРезультата.Макеты.Добавить();
	ЗаполнитьЗначенияСвойств(ОписаниеМакетаОбластиМакетаКомпоновкиДанных, Макет);
	
	Если ТипЗнч(Макет.Макет) = Тип("МакетОбластиКомпоновкиДанных") Тогда
		Для Каждого СтрокаТаблицыОбластиКомпоновкиДанных Из Макет.Макет Цикл
			Для Каждого ЯчейкаТаблицыОбластиКомпоновкиДанных Из СтрокаТаблицыОбластиКомпоновкиДанных.Ячейки Цикл
				Для Каждого ЗначениеПараметраКомпоновкиДанных Из ЯчейкаТаблицыОбластиКомпоновкиДанных.Оформление.Элементы Цикл
					Если ТипЗнч(ЗначениеПараметраКомпоновкиДанных.Значение) = Тип("ПараметрКомпоновкиДанных") И ЗначениеПараметраКомпоновкиДанных.Использование Тогда
						ЗначениеПараметра = Макет.Параметры.Найти(ЗначениеПараметраКомпоновкиДанных.Значение);
						Если ТипЗнч(ЗначениеПараметра) = Тип("ПараметрОбластиВыражениеКомпоновкиДанных") Тогда
							ИмяПараметра = Строка(ЗначениеПараметраКомпоновкиДанных.Параметр);
							Выражение = ЗначениеПараметра.Выражение;
							ВывестиОписание(ИмяПараметра + " = " + Выражение, ПроцессорВывода);
							
							ЗначениеПараметраКомпоновкиДанных.Использование = Ложь;
						КонецЕсли;
					КонецЕсли;
				КонецЦикла;
			КонецЦикла;
			ЯчейкаТаблицыОбластиКомпоновкиДанных = СтрокаТаблицыОбластиКомпоновкиДанных.Ячейки.Добавить();
			ПолеОбластиКомпоновкиДанных = ЯчейкаТаблицыОбластиКомпоновкиДанных.Элементы.Добавить(Тип("ПолеОбластиКомпоновкиДанных"));
			ПолеОбластиКомпоновкиДанных.Значение = СтрокаТаблицыОбластиКомпоновкиДанных.ИдентификаторТаблицы; 
		КонецЦикла;
	КонецЕсли;
	
	Для Каждого ПараметрМакета Из Макет.Параметры Цикл
		
		НовыйПараметр = ОписаниеМакетаОбластиМакетаКомпоновкиДанных.Параметры.Добавить(ТипЗнч(ПараметрМакета));
		ЗаполнитьЗначенияСвойств(НовыйПараметр, ПараметрМакета);
		
		ЗначениеПараметраМакетаКомпоновкиДанных = ЭлементРезультата.ЗначенияПараметров.Добавить();
		ЗначениеПараметраМакетаКомпоновкиДанных.Имя = ПараметрМакета.Имя;
		ЗначениеПараметраМакетаКомпоновкиДанных.Значение = ПараметрМакета.Имя;
		Если ТипЗнч(ПараметрМакета) = Тип("ПараметрОбластиВыражениеКомпоновкиДанных") Тогда
			
			Если Найти(ВРег(ПараметрМакета.Выражение), "УРОВЕНЬ()") > 0 Тогда
				Выражение = СтрЗаменить(ПараметрМакета.Выражение, "Уровень()", "1");
				Выражение = Вычислить(Выражение);
			Иначе
				Выражение = ПараметрМакета.Выражение;
			КонецЕсли;
			
			ЗначениеПараметраМакетаКомпоновкиДанных.Значение = Выражение;
			
		КонецЕсли;
		
	КонецЦикла;
	
	ПроцессорВывода.ВывестиЭлемент(ЭлементРезультата);
	
КонецПроцедуры

Процедура ВывестиОписание(Описание, ПроцессорВывода)
	
	ЭлементРезультата = Новый ЭлементРезультатаКомпоновкиДанных;
	ЭлементРезультата.Макет = "МакетОписание";
	ОписаниеМакетаОбластиМакетаКомпоновкиДанных = ЭлементРезультата.Макеты.Добавить();
	ОписаниеМакетаОбластиМакетаКомпоновкиДанных.Имя = "МакетОписание";
	
	МакетОбластиКомпоновкиДанных = Новый МакетОбластиКомпоновкиДанных;
	
	// пустая строка
	СтрокаТаблицыОбластиКомпоновкиДанных = МакетОбластиКомпоновкиДанных.Добавить(Тип("СтрокаТаблицыОбластиКомпоновкиДанных"));
	ЯчейкаТаблицыОбластиКомпоновкиДанных = СтрокаТаблицыОбластиКомпоновкиДанных.Ячейки.Добавить();
	ПолеОбластиКомпоновкиДанных = ЯчейкаТаблицыОбластиКомпоновкиДанных.Элементы.Добавить(Тип("ПолеОбластиКомпоновкиДанных"));
	
	СтрокаТаблицыОбластиКомпоновкиДанных = МакетОбластиКомпоновкиДанных.Добавить(Тип("СтрокаТаблицыОбластиКомпоновкиДанных"));
	ЯчейкаТаблицыОбластиКомпоновкиДанных = СтрокаТаблицыОбластиКомпоновкиДанных.Ячейки.Добавить();
	ПолеОбластиКомпоновкиДанных = ЯчейкаТаблицыОбластиКомпоновкиДанных.Элементы.Добавить(Тип("ПолеОбластиКомпоновкиДанных"));
	ПолеОбластиКомпоновкиДанных.Значение = Описание;
	
	ОписаниеМакетаОбластиМакетаКомпоновкиДанных.Макет = МакетОбластиКомпоновкиДанных;
	ПроцессорВывода.ВывестиЭлемент(ЭлементРезультата);
	
КонецПроцедуры

//ирПортативный #Если Клиент Тогда
//ирПортативный Контейнер = Новый Структура();
//ирПортативный Оповестить("ирПолучитьБазовуюФорму", Контейнер);
//ирПортативный Если Не Контейнер.Свойство("ирПортативный", ирПортативный) Тогда
//ирПортативный 	ПолноеИмяФайлаБазовогоМодуля = ВосстановитьЗначение("ирПолноеИмяФайлаОсновногоМодуля");
//ирПортативный 	ирПортативный = ВнешниеОбработки.ПолучитьФорму(ПолноеИмяФайлаБазовогоМодуля);
//ирПортативный КонецЕсли; 
//ирПортативный ирОбщий = ирПортативный.ПолучитьОбщийМодульЛкс("ирОбщий");
//ирПортативный ирКэш = ирПортативный.ПолучитьОбщийМодульЛкс("ирКэш");
//ирПортативный ирСервер = ирПортативный.ПолучитьОбщийМодульЛкс("ирСервер");
//ирПортативный ирПривилегированный = ирПортативный.ПолучитьОбщийМодульЛкс("ирПривилегированный");
//ирПортативный #КонецЕсли

мРежимРедактора = Ложь;
мВнешниеНаборыДанных = Новый Структура;

// Создадим структуру дерева отчетов
ДеревоОтчетов.Колонки.Добавить("ИмяОтчета");
ДеревоОтчетов.Колонки.Добавить("СхемаКомпоновкиДанных");
ДеревоОтчетов.Колонки.Добавить("Автофиксация", Новый ОписаниеТипов("Булево"));
ДеревоОтчетов.Колонки.Добавить("Настройки");
ДеревоОтчетов.Колонки.Добавить("НастройкаДляЗагрузки");
ДеревоОтчетов.Колонки.Добавить("СохранятьНастройкиАвтоматически");
