﻿//Признак использования настроек
Перем мИспользоватьНастройки Экспорт;

//Типы объектов, для которых может использоваться обработка.
//По умолчанию для всех.
Перем мТипыОбрабатываемыхОбъектов Экспорт;

Перем мНастройка;
Перем мОписаниеТиповОбъекта;
Перем мТаблицаПараметров;

////////////////////////////////////////////////////////////////////////////////
// ВСПОМОГАТЕЛЬНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Процедура ПередОбработкойВсех(ПараметрыОбработки) Экспорт 
	
КонецПроцедуры

Процедура ПослеОбработкиВсех(ПараметрыОбработки) Экспорт 
	
КонецПроцедуры

// Выполняет обработку строки таблицы.
//
// Параметры:
//  Объект - обрабатываемая строка таблицы;
//  *КоллекцияСтрок - ТабличнаяЧасть, НаборЗаписей - передается для возможности удаления строки из коллекции;
//
Процедура вОбработатьОбъект(Знач Объект, КоллекцияСтрок = Неопределено, Параметры = Неопределено) Экспорт

	ТекстАлгоритма = ЭлементыФормы.ТекстПроизвольногоАлгоритма.ПолучитьТекст();
	ТекстАлгоритма = "Объект" + " = _П0;
	|" + ТекстАлгоритма;
	Для Каждого СтрокаПараметра Из мТаблицаПараметров Цикл
		ТекстАлгоритма = СтрокаПараметра.Имя + " = _АлгоритмОбъект[" + мТаблицаПараметров.Индекс(СтрокаПараметра) + "];
		|" + ТекстАлгоритма;
	КонецЦикла; 
	ирОбщий.ВыполнитьАлгоритм(ТекстАлгоритма, мТаблицаПараметров.ВыгрузитьКолонку("Значение"), , Объект);
	//РедакторАлгоритма.ВыполнитьПрограммныйКод();

КонецПроцедуры // ОбработатьОбъект()

// Сохраняет значения реквизитов формы.
//
// Параметры:
//  Нет.
//
Процедура вСохранитьНастройку() Экспорт

	Если ПустаяСтрока(ЭлементыФормы.ТекущаяНастройка) Тогда
		Предупреждение("Задайте имя новой настройки для сохранения или выберите существующую настройку для перезаписи.");
	КонецЕсли;

	ТекстПроизвольногоАлгоритма = ЭлементыФормы.ТекстПроизвольногоАлгоритма.ПолучитьТекст();
	Если ТипЗнч(мТаблицаПараметров) = Тип("ТаблицаЗначений") Тогда
		Параметры = мТаблицаПараметров.Скопировать(Новый Структура("Вход", Ложь), "Имя, Значение");
	Иначе
		Параметры = мТаблицаПараметров.Выгрузить(Новый Структура("Вход", Ложь), "Имя, Значение");
	КонецЕсли; 
    НоваяНастройка = Новый Структура;
	Для каждого РеквизитНастройки из мНастройка Цикл
		Выполнить("НоваяНастройка.Вставить(Строка(РеквизитНастройки.Ключ), " + Строка(РеквизитНастройки.Ключ) + ");");
	КонецЦикла;

	Если ТекущаяНастройка.Родитель = Неопределено Тогда
		
		НоваяСтрока = ТекущаяНастройка.Строки.Добавить();
		НоваяСтрока.Обработка = ЭлементыФормы.ТекущаяНастройка.Значение;
		ТекущаяНастройка = НоваяСтрока;
		ЭтаФорма.ВладелецФормы.ЭлементыФормы.ДоступныеОбработки.ТекущаяСтрока = НоваяСтрока;
		
	ИначеЕсли НЕ ТекущаяНастройка.Обработка = ЭлементыФормы.ТекущаяНастройка.Значение Тогда
		
		НоваяСтрока           = ТекущаяНастройка.Родитель.Строки.Добавить();
		НоваяСтрока.Обработка = ЭлементыФормы.ТекущаяНастройка.Значение;
		ТекущаяНастройка      = НоваяСтрока;
		ЭтаФорма.ВладелецФормы.ЭлементыФормы.ДоступныеОбработки.ТекущаяСтрока = НоваяСтрока;
		
	КонецЕсли;
	
	ТекущаяНастройка.Настройка = НоваяНастройка;

	ЭтаФорма.Модифицированность = Ложь;

КонецПроцедуры // вСохранитьНастройку()

// Восстанавливает сохраненные значения реквизитов формы.
//
// Параметры:
//  Нет.
//
Процедура вЗагрузитьНастройку() Экспорт

	Если Ложь
		Или ТекущаяНастройка = Неопределено
		Или ТекущаяНастройка.Родитель = Неопределено 
	Тогда
		вУстановитьИмяНастройки("Новая настройка");
	Иначе
        Если НЕ ТекущаяНастройка.Настройка = Неопределено Тогда
			мНастройка = ТекущаяНастройка.Настройка;
		КонецЕсли;
	КонецЕсли;

	Если Не мНастройка.Свойство("Параметры") Тогда
		мНастройка.Вставить("Параметры", Новый ТаблицаЗначений);
	КонецЕсли; 
	//Для каждого РеквизитНастройки из мНастройка Цикл
	//	Значение = мНастройка[РеквизитНастройки.Ключ];
	//	Выполнить(Строка(РеквизитНастройки.Ключ) + " = Значение;");
	//КонецЦикла;

	ЭлементыФормы.ТекстПроизвольногоАлгоритма.УстановитьТекст(мНастройка.ТекстПроизвольногоАлгоритма);
	Для Каждого СтрокаПараметра Из мТаблицаПараметров.НайтиСтроки(Новый Структура("Вход", Ложь)) Цикл
		мТаблицаПараметров.Удалить(СтрокаПараметра);
	КонецЦикла;
	ирОбщий.ЗагрузитьВТаблицуЗначенийЛкс(мНастройка.Параметры, мТаблицаПараметров);
	Для Каждого СтрокаПараметра Из мТаблицаПараметров Цикл
		СтрокаПараметра.НИмя = НСтр(СтрокаПараметра.Имя);
		СтрокаПараметра.ТипЗначения = ТипЗнч(СтрокаПараметра.Значение);
	КонецЦикла;

КонецПроцедуры //вЗагрузитьНастройку()


// Устанавливает значение реквизита "ТекущаяНастройка" по имени настройки или произвольно.
//
// Параметры:
//  ИмяНастройки   - произвольное имя настройки, которое необходимо установить.
//
Процедура вУстановитьИмяНастройки(ИмяНастройки = "") Экспорт

	Если ПустаяСтрока(ИмяНастройки) Тогда
		Если ТекущаяНастройка = Неопределено Тогда
			ЭлементыФормы.ТекущаяНастройка.Значение = "";
		Иначе
			ЭлементыФормы.ТекущаяНастройка.Значение = ТекущаяНастройка.Обработка;
		КонецЕсли;
	Иначе
		ЭлементыФормы.ТекущаяНастройка.Значение = ИмяНастройки;
	КонецЕсли;

КонецПроцедуры // вУстановитьИмяНастройки()

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

// Процедура - обработчик события "ПередОткрытием" формы.
//
Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)

	Если мИспользоватьНастройки Тогда
		вУстановитьИмяНастройки();
		вЗагрузитьНастройку();
	Иначе
		ЭлементыФормы.ТекущаяНастройка.Доступность = Ложь;
		ЭлементыФормы.ОсновныеДействияФормы.Кнопки.СохранитьНастройку.Доступность = Ложь;
	КонецЕсли;

КонецПроцедуры // ПередОткрытием()

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ, ВЫЗЫВАЕМЫЕ ИЗ ЭЛЕМЕНТОВ ФОРМЫ

Функция ОбновитьКонтекстПодсказкиИПолучитьСтруктуруПараметров()

	ирОбщий.ИнициализироватьГлобальныйКонтекстПодсказкиЛкс(РедакторАлгоритма);
	
	// Локальный контекст
	//СтруктураПараметров = Новый Структура;
	Для Каждого СтрокаПараметра Из мТаблицаПараметров Цикл
		//СтруктураПараметров.Вставить(СтрокаПараметра.Имя, СтрокаПараметра.Значение);
		Если НРег(СтрокаПараметра.Имя) = НРег("Объект") Тогда
			РедакторАлгоритма.ДобавитьСловоЛокальногоКонтекста(
				"Объект", "Свойство", мОписаниеТиповОбъекта);
		Иначе
			Если СтрокаПараметра.Значение <> Неопределено Тогда
				МассивТипов = Новый Массив;
				МассивТипов.Добавить(ТипЗнч(СтрокаПараметра.Значение));
				РедакторАлгоритма.ДобавитьСловоЛокальногоКонтекста(
					СтрокаПараметра.Имя, "Свойство", Новый ОписаниеТипов(МассивТипов), , , СтрокаПараметра.Значение);
			КонецЕсли;
		КонецЕсли; 
	КонецЦикла;
		
	Возврат Неопределено;

КонецФункции // ОбновитьКонтекстПодсказкиИПолучитьСтруктуруПараметров()

// @@@.КЛАСС.ПолеТекстовогоДокументаСКонтекстнойПодсказкой
// Транслятор обработки событий нажатия на кнопки командной панели в компоненту.
// Является обязательным.
//
// Параметры:
//  Кнопка       – КнопкаКоманднойПанели.
//
Процедура КлсПолеТекстовогоДокументаСКонтекстнойПодсказкойНажатие(Кнопка)
	
	ОбновитьКонтекстПодсказкиИПолучитьСтруктуруПараметров();
	РедакторАлгоритма.Нажатие(Кнопка);
	
КонецПроцедуры

// @@@.КЛАСС.ПолеТекстовогоДокументаСКонтекстнойПодсказкой
Процедура КлсПолеТекстовогоДокументаСКонтекстнойПодсказкойАвтоОбновитьСправку()
	
	РедакторАлгоритма.АвтоОбновитьСправку();
	
КонецПроцедуры


// Обработчик действия "НачалоВыбораИзСписка" реквизита "ТекущаяНастройка".
//
Процедура ТекущаяНастройкаНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)

	Элемент.СписокВыбора.Очистить();

	Если ТекущаяНастройка.Родитель = Неопределено Тогда
		КоллекцияСтрок = ТекущаяНастройка.Строки;
	Иначе
		КоллекцияСтрок = ТекущаяНастройка.Родитель.Строки;
	КонецЕсли;

	Для каждого Строка из КоллекцияСтрок Цикл
		Элемент.СписокВыбора.Добавить(Строка, Строка.Обработка);
	КонецЦикла;

КонецПроцедуры // ТекущаяНастройкаНачалоВыбораИзСписка()

// Обработчик действия "ОбработкаВыбора" реквизита "ТекущаяНастройка".
//
Процедура ТекущаяНастройкаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;

	Если Истина
		И НЕ ТекущаяНастройка = ВыбранноеЗначение
		И Элемент.СписокВыбора.НайтиПоЗначению(ВыбранноеЗначение) <> Неопределено
	Тогда

		Если ЭтаФорма.Модифицированность Тогда
			Если Вопрос("Сохранить текущую настройку?", РежимДиалогаВопрос.ДаНет,, КодВозвратаДиалога.Да) = КодВозвратаДиалога.Да Тогда
				вСохранитьНастройку();
			КонецЕсли;
		КонецЕсли;

		ТекущаяНастройка = ВыбранноеЗначение;
		вУстановитьИмяНастройки();

		вЗагрузитьНастройку();

	КонецЕсли;

КонецПроцедуры // ТекущаяНастройкаОбработкаВыбора()

Функция вВыполнитьОбработку() Экспорт
	
	Если ТипЗнч(мТаблицаПараметров) = Тип("ТаблицаЗначений") Тогда
		Параметры = мТаблицаПараметров.Скопировать();
	Иначе
		Параметры = мТаблицаПараметров.Выгрузить();
	КонецЕсли; 
	Если Не ирОбщий.ЛиПараметрыАлгоритмыКорректныЛкс(Параметры) Тогда
		Возврат Неопределено;
	КонецЕсли; 
	Если Не РедакторАлгоритма.ПроверитьПрограммныйКод() Тогда
		Возврат Неопределено;
	КонецЕсли; 
	ОбработаноОбъектов = вВыполнитьГрупповуюОбработку(ЭтаФорма);
	Возврат ОбработаноОбъектов;
	
КонецФункции

// Обработчик действия "Выполнить" командной панели "ОсновныеДействияФормы".
//
Процедура ОсновныеДействияФормыВыполнить(Кнопка)

	ОбработаноОбъектов = вВыполнитьОбработку();

КонецПроцедуры // ОсновныеДействияФормыВыполнить()

// Обработчик действия "СохранитьНастройку" командной панели "ОсновныеДействияФормы".
//
Процедура ОсновныеДействияФормыСохранитьНастройку(Кнопка)

	вСохранитьНастройку();

КонецПроцедуры // ОсновныеДействияФормыСохранитьНастройку()

Процедура ПриОткрытии()
	
	Если ВладелецФормы <> Неопределено Тогда
		ВладелецФормы.Панель.Доступность = Ложь;
		ИскомыйОбъект = ВладелецФормы.мИскомыйОбъект;
	КонецЕсли; 
	
	мОписаниеТиповОбъекта = ПолучитьОписаниеТиповОбрабатываемогоЭлемента(ИскомыйОбъект);
	
КонецПроцедуры

Процедура ПриЗакрытии()
	
	Если ВладелецФормы <> Неопределено Тогда
		ВладелецФормы.Панель.Доступность = Истина;
	КонецЕсли; 
	
	// +++.КЛАСС.ПолеТекстовогоДокументаСКонтекстнойПодсказкой
	// Уничтожение всех экземпляров компоненты. Обязательный блок.
	РедакторАлгоритма.Уничтожить();
	// ---.КЛАСС.ПолеТекстовогоДокументаСКонтекстнойПодсказкой
	
КонецПроцедуры

//// @@@.КЛАСС.ПолеТекстовогоДокументаСКонтекстнойПодсказкой
//// Процедура служит для выполнения программы поля текстового документа в локальном контексте.
//// Вызывается из компоненты ирКлсПолеТекстовогоДокументаСКонтекстнойПодсказкой в режиме внутреннего языка.
////
//// Параметры:
////  ТекстДляВыполнения – Строка;
////  *ЛиСинтаксическийКонтроль - Булево, *Ложь - признак вызова только для синтаксического контроля.
////
//Функция ВыполнитьЛокально(ТекстДляВыполнения, ЛиСинтаксическийКонтроль = Ложь) Экспорт
//	
//	Если ЛиСинтаксическийКонтроль Тогда
//		Выполнить(ТекстДляВыполнения);
//		Возврат Неопределено;
//	КонецЕсли;
//	
//	Предупреждение("Функция недоступна в данном контексте");
//	
//КонецФункции // ВыполнитьЛокально()

Процедура КоманднаяПанельОбработкаСтрокиРезультатаШаблонЧтениеИЗаписьОбъекта(Кнопка)
	
	Текст =
	"Объект.
	|//Объект.ОбменДанными.Загрузка = Истина;
	|Объект.Записать();";
	
	ирОбщий.УстановитьТекстСОткатомЛкс(ЭлементыФормы.ТекстПроизвольногоАлгоритма, Текст);
	ЭтаФорма.ТекущийЭлемент = ЭлементыФормы.ТекстПроизвольногоАлгоритма;
	
КонецПроцедуры

Функция ПолучитьКодОбработкиТаблицыРезультата()
	
	ТекстОбработкиСтроки = ЭлементыФормы.ТекстПроизвольногоАлгоритма.ПолучитьТекст();
	ГотовыйТекстОбработчика = "";
	Для Счетчик = 1 По СтрЧислоСтрок(ТекстОбработкиСтроки) Цикл
		ГотовыйТекстОбработчика = ГотовыйТекстОбработчика + "
		|" + СтрПолучитьСтроку(ТекстОбработкиСтроки, Счетчик);
	КонецЦикла;
	ГотовыйТекстОбработчика = ГотовыйТекстОбработчика + Символы.ПС;

	ТекстМодуля = 
"МассивФрагментов = ирОбщий.ПолучитьМассивИзСтрокиСРазделителемЛкс(ОбластьПоиска);
|ОбъектМДЗаписи = Метаданные.НайтиПоПолномуИмени(МассивФрагментов[0] + ""."" + МассивФрагментов[1]);
|ПроводитьПроведенные = Истина
|	И ПроводитьПроведенныеДокументыПриЗаписи
|	И ирОбщий.ПолучитьПервыйФрагментЛкс(ОбластьПоиска) = ""Документ""
|	И ОбъектМДЗаписи.Проведение = Метаданные.СвойстваОбъектов.Проведение.Разрешить;
|НайденныеОбъекты.ЗаполнитьЗначения("""", ""_РезультатОбработки"");
|Если ВыполнятьВТранзакции Тогда
|	НачатьТранзакцию();
|КонецЕсли;
|// Порядок обработки строк таблицы БД сохраняется только в случае, если на каждый объект БД приходится только одна строка
|КлючиДляОбработки = НайденныеОбъекты.Скопировать(Новый Структура(мИмяКолонкиПометки, Истина));
|ТипТаблицы = ирОбщий.ПолучитьТипТаблицыБДЛкс(ОбластьПоиска);
|СтруктураКлючаОбъекта = ирОбщий.ПолучитьСтруктуруКлючаТаблицыБДЛкс(ОбластьПоиска, Ложь);
|СтруктураКлючаПолная = ирОбщий.ПолучитьСтруктуруКлючаТаблицыБДЛкс(ОбластьПоиска, Истина);
|СтрокаКлюча = """";
|Для Каждого КлючИЗначение Из СтруктураКлючаОбъекта Цикл
|	Если СтрокаКлюча <> """" Тогда
|		СтрокаКлюча  = СтрокаКлюча + "","";
|	КонецЕсли; 
|	СтрокаКлюча = СтрокаКлюча + КлючИЗначение.Ключ;
|КонецЦикла;
|КлючиДляОбработки.Колонки.Добавить(""_ПорядокСтроки"");
|Для Индекс = 0 По КлючиДляОбработки.Количество() - 1 Цикл
|	СтрокаТаблицы  = КлючиДляОбработки[Индекс];
|	СтрокаТаблицы._ПорядокСтроки = Индекс;
|КонецЦикла;
|КлючиДляОбработки.Свернуть(СтрокаКлюча, ""_ПорядокСтроки"");
|КлючиДляОбработки.Сортировать(""_ПорядокСтроки"");
|КоличествоОбъектов = КлючиДляОбработки.Количество();
|Индикатор = ирОбщий.ПолучитьИндикаторПроцессаЛкс(КоличествоОбъектов);
|СтруктураКлючаОбъекта.Вставить(мИмяКолонкиПометки, Истина);
|Для Индекс = 0 По КоличествоОбъектов - 1 Цикл
|	ирОбщий.ОбработатьИндикаторЛкс(Индикатор);
|	СтрокаКлюча = КлючиДляОбработки[Индекс];
|	ЗаполнитьЗначенияСвойств(СтруктураКлючаОбъекта, СтрокаКлюча); 
|	СтрокиДляОбработки = НайденныеОбъекты.НайтиСтроки(СтруктураКлючаОбъекта);
|	МассивОбъектов = Новый Массив();
|	Если ирОбщий.ЛиКорневойТипОбъектаБДЛкс(ТипТаблицы) Тогда
|		ОбъектДляЗаписи = СтрокаКлюча.Ссылка.ПолучитьОбъект();
|		МассивОбъектов.Добавить(ОбъектДляЗаписи);
|	ИначеЕсли ирОбщий.ЛиТипВложеннойТаблицыБДЛкс(ТипТаблицы) Тогда
|		ОбъектДляЗаписи = СтрокаКлюча.Ссылка.ПолучитьОбъект();
|		Если РежимОбходаДанных = ""Строки"" Тогда
|			ИмяТЧ = ирОбщий.ПолучитьМассивИзСтрокиСРазделителемЛкс(ирОбщий.ПолучитьИмяТаблицыИзМетаданныхЛкс(ОбластьПоиска))[2];
|			Для Каждого СтрокаДляОбработки Из СтрокиДляОбработки Цикл
|				Если ОбъектДляЗаписи[ИмяТЧ].Количество() < СтрокаДляОбработки.НомерСтроки Тогда
|					ВызватьИсключение ""Строка таблицы с номером "" + СтрокаДляОбработки.НомерСтроки + "" не найдена в объекте БД"";
|				КонецЕсли; 
|				МассивОбъектов.Добавить(ОбъектДляЗаписи[ИмяТЧ][СтрокаДляОбработки.НомерСтроки - 1]);
|			КонецЦикла;
|		Иначе
|			МассивОбъектов.Добавить(ОбъектДляЗаписи);
|		КонецЕсли; 
|	ИначеЕсли Ложь
|		Или ирОбщий.ЛиКорневойТипРегистраБДЛкс(ТипТаблицы) 
|		Или ирОбщий.ЛиКорневойТипПоследовательностиЛкс(ТипТаблицы)
|	Тогда
|		ОбъектДляЗаписи = Новый (СтрЗаменить(ОбластьПоиска, ""."", ""НаборЗаписей.""));
|		Для Каждого ЭлементОтбора Из ОбъектДляЗаписи.Отбор Цикл
|			ЭлементОтбора.Использование = Истина;
|			ЭлементОтбора.ВидСравнения = ВидСравнения.Равно;
|			ЭлементОтбора.Значение = СтруктураКлючаОбъекта[ЭлементОтбора.Имя];
|		КонецЦикла;
|		ОбъектДляЗаписи.Прочитать();
|		Если РежимОбходаДанных = ""Строки"" Тогда
|			Если СтруктураКлючаПолная.Свойство(""НомерСтроки"") Тогда
|				ИмяКлюча = ""НомерСтроки"";
|				КлючСтроки = Новый Структура(ИмяКлюча);
|			ИначеЕсли СтруктураКлючаПолная.Свойство(""Период"") Тогда
|				ИмяКлюча = ""Период"";
|				КлючСтроки = Новый Структура(ИмяКлюча);
|			Иначе
|				КлючСтроки = Неопределено;
|			КонецЕсли; 
|			ТаблицаНабора = ОбъектДляЗаписи.Выгрузить();
|			Для Каждого СтрокаДляОбработки Из СтрокиДляОбработки Цикл
|				Если КлючСтроки = Неопределено Тогда
|					СтрокаОбъекта = ОбъектДляЗаписи[0];
|				Иначе
|					ЗаполнитьЗначенияСвойств(КлючСтроки, СтрокаДляОбработки); 
|					НайденныеСтроки = ТаблицаНабора.НайтиСтроки(КлючСтроки);
|					Если НайденныеСтроки.Количество() = 0 Тогда
|						ВызватьИсключение ""Строка таблицы по ключу "" + КлючСтроки[ИмяКлюча] + "" не найдена в объекте БД"";
|					КонецЕсли;
|					ИндексСтрокиНабора = ТаблицаНабора.Индекс(НайденныеСтроки[0]);
|					СтрокаОбъекта = ОбъектДляЗаписи[ИндексСтрокиНабора];
|				КонецЕсли; 
|				МассивОбъектов.Добавить(СтрокаОбъекта);
|			КонецЦикла;
|		Иначе
|			МассивОбъектов.Добавить(ОбъектДляЗаписи);
|		КонецЕсли; 
|	КонецЕсли; 
|	Попытка
|		ОбменДанными = ОбъектДляЗаписи.ОбменДанными;
|	Исключение
|		ОбменДанными = Неопределено;
|	КонецПопытки; 
|	Если ОбменДанными <> Неопределено Тогда
|		ОбменДанными.Загрузка = ОтключатьКонтрольЗаписи;
|	КонецЕсли;
|	ТекстСообщенияОбОбработкеОбъекта = ""Обработка объекта "" + ирОбщий.ПолучитьXMLКлючОбъектаБДЛкс(ОбъектДляЗаписи);
|	Если ВыводитьСообщения Тогда
|		Сообщить(ТекстСообщенияОбОбработкеОбъекта);
|	КонецЕсли; 
|	Попытка
|		Для Каждого Объект Из МассивОбъектов Цикл
|			
|			/////////////////////////////////////////////
|			// НАЧАЛО обработчика
|			// Объект = мОписаниеТиповОбъекта;
|" + ГотовыйТекстОбработчика + "
|			// КОНЕЦ обработчика
|			/////////////////////////////////////////////
|				
|		КонецЦикла;
|		Если ОбъектДляЗаписи.Модифицированность() Тогда
|			Если Истина
|				И ПроводитьПроведенные
|				И ОбъектДляЗаписи.Проведен
|			Тогда
|				ОбъектДляЗаписи.Записать(РежимЗаписиДокумента.Проведение);
|			Иначе
|				ОбъектДляЗаписи.Записать();
|			КонецЕсли; 
|		КонецЕсли;
|		РезультатОбработки = ""Успех"";
|		Для Каждого СтрокаДанных Из СтрокиДляОбработки Цикл
|			СтрокаДанных._РезультатОбработки = РезультатОбработки;
|		КонецЦикла; 
|		Если ВыводитьСообщения Тогда
|			Сообщить(Символы.Таб + РезультатОбработки);
|		КонецЕсли; 
|	Исключение
|		РезультатОбработки = ОписаниеОшибки();
|		Если Не ВыводитьСообщения Тогда
|			Сообщить(ТекстСообщенияОбОбработкеОбъекта);
|		КонецЕсли; 
|		Сообщить(Символы.Таб + РезультатОбработки, СтатусСообщения.Внимание);
|		Для Каждого СтрокаДанных Из СтрокиДляОбработки Цикл
|			СтрокаДанных._РезультатОбработки = РезультатОбработки;
|		КонецЦикла; 
|		Если Не ПропускатьОшибки Тогда
|			ВызватьИсключение;
|		КонецЕсли; 
|	КонецПопытки; 
|КонецЦикла;
|ирОбщий.ОсвободитьИндикаторПроцессаЛкс(Индикатор, Истина);
|Если ВыполнятьВТранзакции Тогда
|	ЗафиксироватьТранзакцию();
|КонецЕсли;
|";
	Возврат ТекстМодуля;
	
КонецФункции

Процедура КоманднаяПанельКонсольКода(Кнопка)

	ТекстАлгоритма = ПолучитьКодОбработкиТаблицыРезультата();
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("ОтключатьКонтрольЗаписи", ОтключатьКонтрольЗаписи);
	СтруктураПараметров.Вставить("ПропускатьОшибки", ПропускатьОшибки);
	СтруктураПараметров.Вставить("РежимОбходаДанных", РежимОбходаДанных);
	СтруктураПараметров.Вставить("ВыполнятьВТранзакции", ВыполнятьВТранзакции);
	СтруктураПараметров.Вставить("ОбластьПоиска", ОбластьПоиска);
	СтруктураПараметров.Вставить("ПроводитьПроведенныеДокументыПриЗаписи", ПроводитьПроведенныеДокументыПриЗаписи);
	СтруктураПараметров.Вставить("НайденныеОбъекты", НайденныеОбъекты);
	СтруктураПараметров.Вставить("мОписаниеТиповОбъекта", мОписаниеТиповОбъекта);
	СтруктураПараметров.Вставить("мИмяКолонкиПометки", мИмяКолонкиПометки);
	СтруктураПараметров.Вставить("ВыводитьСообщения", ВыводитьСообщения);
	Для Каждого СтрокаПараметра Из мТаблицаПараметров Цикл
		Если СтруктураПараметров.Свойство(СтрокаПараметра.Имя) Тогда
			Сообщить("Невозможно сгенерировать текст для отладки из-за использования в коде имени """ + СтрокаПараметра.Имя + """",	СтатусСообщения.Внимание);
			Возврат;
		КонецЕсли; 
		Если Не СтрокаПараметра.Вход Тогда
			СтруктураПараметров.Вставить(СтрокаПараметра.Имя, СтрокаПараметра.Значение);
		КонецЕсли; 
	КонецЦикла;
	ФормаКонсолиКода = ирОбщий.ОперироватьСтруктуройЛкс(ТекстАлгоритма, , СтруктураПараметров);
	ФормаКонсолиКода.ПолеВстроенногоЯзыка.НайтиПоказатьСловоВТексте("////////");
	
КонецПроцедуры

Процедура ПараметрыПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	
	Если ДанныеСтроки.Вход Тогда
		ОформлениеСтроки.ЦветФона = Новый Цвет(230, 230, 230);
	КонецЕсли; 
	
КонецПроцедуры

Процедура ПараметрыПередНачаломИзменения(Элемент, Отказ)
	
	Если Элемент.ТекущиеДанные.Вход Тогда
		Отказ = Истина;
	КонецЕсли; 
	
КонецПроцедуры

Процедура КоманднаяПанельСсылкаНаОбъектБД(Кнопка)
	
	СтрокаПараметра = РедакторАлгоритма.ВставитьСсылкуНаОбъектБД(ЭлементыФормы.Параметры);
	Если СтрокаПараметра <> Неопределено Тогда
		СтрокаПараметра.ТипЗначения = ТипЗнч(СтрокаПараметра.Значение);
	КонецЕсли; 
	
КонецПроцедуры

Процедура ПараметрыПередУдалением(Элемент, Отказ)

	Если Элемент.ТекущиеДанные.Вход Тогда
		Отказ = Истина;
	КонецЕсли; 
	
КонецПроцедуры

Процедура ПараметрыПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока Тогда
		Элемент.ТекущиеДанные.Вход = Ложь;
		Элемент.ТекущиеДанные.Комментарий = "";
		Элемент.ТекущиеДанные.ДопустимыеТипы = Неопределено;
	КонецЕсли; 
	
КонецПроцедуры

Процедура ОсновныеДействияФормыЗагрузить(Кнопка)
	
	РезультатВыбора = ирОбщий.ВыбратьСсылкуЛкс(Метаданные.Справочники.ирАлгоритмы, ТекущийАлгоритм);
	Если Не ЗначениеЗаполнено(РезультатВыбора) Тогда
		Возврат;
	КонецЕсли; 
	ТекущийАлгоритм = РезультатВыбора;
	РедакторАлгоритма.ПолеТекстовогоДокумента.УстановитьТекст(ТекущийАлгоритм.ТекстАлгоритма);
	Если мТаблицаПараметров.Количество() > 0 Тогда
		Ответ = Вопрос("Очистить параметры перед загрузкой?", РежимДиалогаВопрос.ДаНет);
		Если Ответ = КодВозвратаДиалога.Да Тогда
			СтрокиВхода = мТаблицаПараметров.НайтиСтроки(Новый Структура("Вход", Ложь));
			Для Каждого СтрокаВхода Из СтрокиВхода Цикл
				мТаблицаПараметров.Удалить(СтрокаВхода);
			КонецЦикла;
		КонецЕсли;
	КонецЕсли; 
	Для Каждого СтрокаПараметраАлгоритма Из ТекущийАлгоритм.Параметры Цикл
		СтрокаПараметраКонсоли = мТаблицаПараметров.Найти(СтрокаПараметраАлгоритма.Имя, "Имя");
		Если СтрокаПараметраКонсоли = Неопределено Тогда
			СтрокаПараметраКонсоли = мТаблицаПараметров.Добавить();
			СтрокаПараметраКонсоли.Имя = СтрокаПараметраАлгоритма.Имя;
			СтрокаПараметраКонсоли.НИмя = НРег(СтрокаПараметраКонсоли.Имя);
		КонецЕсли; 
		СтрокаПараметраКонсоли.Значение = СтрокаПараметраАлгоритма.Значение;
		СтрокаПараметраКонсоли.ТипЗначения = ТипЗнч(СтрокаПараметраАлгоритма.Значение);
		СтрокаПараметраКонсоли.Вход = Ложь;
	КонецЦикла;
	ОбновитьПараметрыВПортативномРежиме();

КонецПроцедуры

Процедура ПараметрыЗначениеПриИзменении(Элемент)
	
	СтрокаПараметра = ЭлементыФормы.Параметры.ТекущиеДанные;
	СтрокаПараметра.ТипЗначения = ТипЗнч(СтрокаПараметра.Имя);
	
КонецПроцедуры

Процедура ПараметрыИмяПриИзменении(Элемент)
	
	СтрокаПараметра = ЭлементыФормы.Параметры.ТекущиеДанные;
	СтрокаПараметра.НИмя = НСтр(СтрокаПараметра.Имя);
	
КонецПроцедуры

Процедура ОсновныеДействияФормыСохранить(Кнопка)
	
	РезультатВыбора = ирОбщий.ВыбратьСсылкуЛкс(Метаданные.Справочники.ирАлгоритмы, ТекущийАлгоритм);
	Если ЗначениеЗаполнено(РезультатВыбора) Тогда
		//Если Не ЗначениеЗаполнено(ТекущийАлгоритм) Тогда
			ТекущийАлгоритм = РезультатВыбора;
		//КонецЕсли; 
		//АлгоритмОбъект = РезультатВыбора.ПолучитьОбъект();
		АлгоритмОбъект = РезультатВыбора;
	Иначе
		АлгоритмОбъект = Справочники.ирАлгоритмы.СоздатьЭлемент();
		ТекущийАлгоритм = ирОбщий.ПолучитьТочнуюСсылкуОбъектаЛкс(АлгоритмОбъект);
	КонецЕсли; 
	ФормаАлгоритма = АлгоритмОбъект.ПолучитьФорму();
	ФормаАлгоритма.ТекстАлгоритма = РедакторАлгоритма.ПолеТекстовогоДокумента.ПолучитьТекст();
	СтрокиПараметровКонсоли = мТаблицаПараметров.НайтиСтроки(Новый Структура("Вход", Ложь));
	Для Каждого СтрокаПараметраКонсоли Из СтрокиПараметровКонсоли Цикл
		СтрокаПараметраАлгоритма = ФормаАлгоритма.Параметры.Найти(СтрокаПараметраКонсоли.Имя, "Имя");
		Если СтрокаПараметраАлгоритма = Неопределено Тогда
			СтрокаПараметраАлгоритма = ФормаАлгоритма.Параметры.Добавить();
			СтрокаПараметраАлгоритма.Имя = СтрокаПараметраКонсоли.Имя;
		КонецЕсли; 
		СтрокаПараметраАлгоритма.Значение = СтрокаПараметраКонсоли.Значение;
	КонецЦикла;
	ФормаАлгоритма.СправочникОбъект = ФормаАлгоритма.СправочникОбъект;
	ФормаАлгоритма.Открыть();
	ФормаАлгоритма.Модифицированность = Истина;

КонецПроцедуры

Процедура ПараметрыПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	ОбновитьПараметрыВПортативномРежиме();
	
КонецПроцедуры

Процедура ПараметрыПослеУдаления(Элемент)
	
	ОбновитьПараметрыВПортативномРежиме();
	
КонецПроцедуры

Процедура ОбновитьПараметрыВПортативномРежиме()
	
	РедакторАлгоритма.Параметры.Загрузить(СкрытыеПараметры);
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ИНИЦИАЛИЗАЦИЯ МОДУЛЬНЫХ ПЕРЕМЕННЫХ

мИспользоватьНастройки = Истина;

//Реквизиты настройки и значения по умолчанию.
мНастройка = Новый Структура("ТекстПроизвольногоАлгоритма, Параметры", "", Новый ТаблицаЗначений);

мТипыОбрабатываемыхОбъектов = Неопределено;
ЭтаФорма.РедакторАлгоритма = рРедакторАлгоритма;
Если ирКэш.ЛиПортативныйРежимЛкс() Тогда
	ЭтаФорма.РедакторАлгоритма = ирОбщий.ПолучитьОбъектПоПолномуИмениМетаданныхЛкс("Обработка.ирКлсПолеТекстовогоДокументаСКонтекстнойПодсказкой");
	#Если _ Тогда
		ЭтаФорма.РедакторАлгоритма = Обработки.ирКлсПолеТекстовогоДокументаСКонтекстнойПодсказкой.Создать();
	#КонецЕсли
	ЭтаФорма.ЭлементыФормы.Удалить(ЭлементыФормы.Параметры);
	ЭтаФорма.ЭлементыФормы.СкрытыеПараметры.Имя = "Параметры";
	ЭтаФорма.ЭлементыФормы.Параметры.Видимость = Истина;
КонецЕсли; 
СтрокаПараметра = РедакторАлгоритма.Параметры.Добавить();
СтрокаПараметра.Имя = "Объект";
СтрокаПараметра.НИмя = НСтр(СтрокаПараметра.Имя);
СтрокаПараметра.Комментарий = "Для доступа к элементу данных";
СтрокаПараметра.Вход = Истина;
СтрокаПараметра.ТипЗначения = ТипЗнч(СтрокаПараметра.Значение);

РедакторАлгоритма.Инициализировать(,
	//ЭтаФорма, ЭлементыФормы.ТекстПроизвольногоАлгоритма, ЭлементыФормы.КоманднаяПанель, Ложь, "ВыполнитьЛокально", ЭтаФорма);
	ЭтаФорма, ЭлементыФормы.ТекстПроизвольногоАлгоритма, ЭлементыФормы.КоманднаяПанель, Ложь);
КнопкаВыполнить = ирОбщий.ПолучитьКнопкуКоманднойПанелиЭкземпляраКомпонентыЛкс(РедакторАлгоритма, "Выполнить");
ЭлементыФормы.КоманднаяПанель.Кнопки.Удалить(КнопкаВыполнить);
ЭлементыФормы.ОсновныеДействияФормы.Кнопки.Сохранить.Доступность = Не ирКэш.ЛиПортативныйРежимЛкс();
ЭлементыФормы.ОсновныеДействияФормы.Кнопки.Загрузить.Доступность = Не ирКэш.ЛиПортативныйРежимЛкс();
Если ирКэш.ЛиПортативныйРежимЛкс() Тогда
	ЭтаФорма.СкрытыеПараметры = ЭтаФорма.РедакторАлгоритма.Параметры.Выгрузить();
	мТаблицаПараметров = ЭтаФорма.СкрытыеПараметры;
Иначе
	мТаблицаПараметров = ЭтаФорма.РедакторАлгоритма.Параметры;
КонецЕсли; 
ЭлементыФормы.ОсновныеДействияФормы.Кнопки.Сохранить.Доступность = Не ирКэш.ЛиПортативныйРежимЛкс();
ЭлементыФормы.ОсновныеДействияФормы.Кнопки.Загрузить.Доступность = Не ирКэш.ЛиПортативныйРежимЛкс();

ирОбщий.ИнициализироватьФормуЛкс(ЭтаФорма, "Обработка.ирПодборИОбработкаОбъектов.Форма.ПроизвольныйАлгоритм");
