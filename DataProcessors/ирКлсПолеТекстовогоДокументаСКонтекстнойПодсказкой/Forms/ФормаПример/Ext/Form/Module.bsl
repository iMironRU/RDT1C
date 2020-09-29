﻿//ирПортативный Перем ирПортативный Экспорт;
//ирПортативный Перем ирОбщий Экспорт;
//ирПортативный Перем ирСервер Экспорт;
//ирПортативный Перем ирКэш Экспорт;
//ирПортативный Перем ирПривилегированный Экспорт;

////////////////////////////////////////////////////////////////////////////////
// ПРИМЕР ИСПОЛЬЗОВАНИЯ КОМПОНЕНТЫ.
//
// Здесь описан порядок подключения компоненты к своему полю текстового документа в режиме внутреннего языка или языка запросов.
//
// Создаете реквизит формы типа ОбработкаОбъект.ирКлсПолеТекстовогоДокументаСКонтекстнойПодсказкой.
// Рядом с полем текстового документа лучше создать пустую командную панель, но можно и не создавать,
// тогда у поля будет только контекстное меню.
// При открытии формы прописываем инициализацию экземпляров компоненты, а при закрытии - их уничтожение.
// Для хранения всех экземпляров компоненты служит переменная модуля формы ПолеТекстовогоДокументаСКонтекстнойПодсказкой.
// Блоки кода, отвечающие за работу с компонентой обрамлены в комментарии:

// +++.КЛАСС.ПолеТекстовогоДокументаСКонтекстнойПодсказкой
//...
// ---.КЛАСС.ПолеТекстовогоДокументаСКонтекстнойПодсказкой


// +++.КЛАСС.ПолеТекстовогоДокументаСКонтекстнойПодсказкой
// Это коллекция экземпляров компоненты. Обязательный блок.
Перем ПолеТекстовогоДокументаСКонтекстнойПодсказкой;
// ---.КЛАСС.ПолеТекстовогоДокументаСКонтекстнойПодсказкой

Перем лСписок;

// @@@.КЛАСС.ПолеТекстовогоДокументаСКонтекстнойПодсказкой
// Транслятор обработки событий нажатия на кнопки командной панели в компоненту.
// Является обязательным.
//
// Параметры:
//  Кнопка       – КнопкаКоманднойПанели.
//
Процедура КлсПолеТекстовогоДокументаСКонтекстнойПодсказкойНажатие(Кнопка)
	
	// Имя страницы совпадает с именем поля текстового документа
	ИмяСтраницы = ЭлементыФормы.ПанельОсновная.ТекущаяСтраница.Имя;
	ЭкземплярКомпоненты = ПолеТекстовогоДокументаСКонтекстнойПодсказкой[ИмяСтраницы];
	Если ИмяСтраницы = "ВстроенныйЯзык" Тогда 
		ирОбщий.ИнициализироватьГлобальныйКонтекстПодсказкиЛкс(ЭкземплярКомпоненты);
		
		// Это пример добавления слов локального контекста. Каждое слово представляет собой имя доступное
		// напрямую в данном контексте. Необязательный блок.
		
		// Свойство - переменная модуля
		МассивТипов = Новый Массив;
		МассивТипов.Добавить(ТипЗнч(лСписок));
		ПолеТекстовогоДокументаСКонтекстнойПодсказкой.ВстроенныйЯзык.ДобавитьСловоЛокальногоКонтекста(
				"лСписок", "Свойство", Новый ОписаниеТипов(МассивТипов));
				
		// Свойство - реквизит формы
		МассивТипов = Новый Массив;
		МассивТипов.Добавить(ТипЗнч(лПостроительОтчета));
		ПолеТекстовогоДокументаСКонтекстнойПодсказкой.ВстроенныйЯзык.ДобавитьСловоЛокальногоКонтекста(
				"лПостроительОтчета", "Свойство", Новый ОписаниеТипов(МассивТипов));
				
		// Свойство - таблица значений
		лТаблицаЗначений = Новый ТаблицаЗначений;
		лТаблицаЗначений.Колонки.Добавить("Структура", Новый ОписаниеТипов("Структура"));
		лТаблицаЗначений.Колонки.Добавить("Название", Новый ОписаниеТипов("Строка"));
		НоваяСтрока = лТаблицаЗначений.Добавить();
		НоваяСтрока.Название = "Новая строка";
		МассивТипов = Новый Массив;
		МассивТипов.Добавить(ТипЗнч(лТаблицаЗначений));
		ПолеТекстовогоДокументаСКонтекстнойПодсказкой.ВстроенныйЯзык.ДобавитьСловоЛокальногоКонтекста(
				"лТаблицаЗначений", "Свойство", Новый ОписаниеТипов(МассивТипов), лТаблицаЗначений);
				
		// Свойство - результат запроса
		Запрос = Новый Запрос;
		Запрос.Текст = "
		|ВЫБРАТЬ * ИЗ Справочник." + Метаданные.Справочники[0].Имя + "
		|";
		лРезультатЗапроса = Запрос.Выполнить();
		МассивТипов = Новый Массив;
		МассивТипов.Добавить(ТипЗнч(лРезультатЗапроса));
		ПолеТекстовогоДокументаСКонтекстнойПодсказкой.ВстроенныйЯзык.ДобавитьСловоЛокальногоКонтекста(
				"лРезультатЗапроса", "Свойство", Новый ОписаниеТипов(МассивТипов), лРезультатЗапроса);
		
		// Метод - процедура
		ПолеТекстовогоДокументаСКонтекстнойПодсказкой.ВстроенныйЯзык.ДобавитьСловоЛокальногоКонтекста(
				"СообщитьПривет", "Метод");
				
		// Метод - функция
		МассивТипов = Новый Массив;
		МассивТипов.Добавить(Тип("СправочникиМенеджер"));
		ПолеТекстовогоДокументаСКонтекстнойПодсказкой.ВстроенныйЯзык.ДобавитьСловоЛокальногоКонтекста(
				"ПолучитьСправочникиМенеджер", "Метод", Новый ОписаниеТипов(МассивТипов));

	КонецЕсли;
	ЭкземплярКомпоненты.Нажатие(Кнопка);
	
КонецПроцедуры

// @@@.КЛАСС.ПолеТекстовогоДокументаСКонтекстнойПодсказкой
// Эта процедура может использоваться в качестве обработчика ожидания подключаемого/отключаемого внутри класса
// Если ее удалить, то функция "АвтоКонтекстаяСправка" автоматически отключается
//
Процедура КлсПолеТекстовогоДокументаСКонтекстнойПодсказкойАвтоОбновитьСправку()
	
	ИмяСтраницы = ЭлементыФормы.ПанельОсновная.ТекущаяСтраница.Имя;
	ЭкземплярКомпоненты = ПолеТекстовогоДокументаСКонтекстнойПодсказкой[ИмяСтраницы];
	#Если Сервер И Не Сервер Тогда
	    ЭкземплярКомпоненты = Обработки.ирКлсПолеТекстовогоДокументаСКонтекстнойПодсказкой.Создать();
	#КонецЕсли
	ЭкземплярКомпоненты.АвтоОбновитьСправку();
	
КонецПроцедуры

// @@@.КЛАСС.ПолеТекстовогоДокументаСКонтекстнойПодсказкой
Процедура ВнешнееСобытие(Источник, Событие, Данные)
	
	ИмяСтраницы = ЭлементыФормы.ПанельОсновная.ТекущаяСтраница.Имя;
	ЭкземплярКомпоненты = ПолеТекстовогоДокументаСКонтекстнойПодсказкой[ИмяСтраницы];
	#Если Сервер И Не Сервер Тогда
	    ЭкземплярКомпоненты = Обработки.ирКлсПолеТекстовогоДокументаСКонтекстнойПодсказкой.Создать();
	#КонецЕсли
	ЭкземплярКомпоненты.ВнешнееСобытиеОбъекта(Источник, Событие, Данные);
	
КонецПроцедуры

Процедура ПриОткрытии()
	
	// +++.КЛАСС.ПолеТекстовогоДокументаСКонтекстнойПодсказкой
	ПолеТекстовогоДокументаСКонтекстнойПодсказкой = Новый Структура;

	// Этот блок рекомендуется использовать в случае внутренней обработки. Обязательный блок.
	//ОбработкаМенеджер = Обработки.ирКлсПолеТекстовогоДокументаСКонтекстнойПодсказкой;
	//ОбработкаМенеджер.Создать().Инициализировать(ПолеТекстовогоДокументаСКонтекстнойПодсказкой,
	//	ЭтаФорма, ЭлементыФормы.ВстроенныйЯзык, ЭлементыФормы.КоманднаяПанельВстроенныйЯзык, Ложь, "ВыполнитьЛокально", ЭтаФорма);
	//ОбработкаМенеджер.Создать().Инициализировать(ПолеТекстовогоДокументаСКонтекстнойПодсказкой,
	//	ЭтаФорма, ЭлементыФормы.ЯзыкЗапросов, ЭлементыФормы.КоманднаяПанельЯзыкЗапросов, Истина);
		
	// Этот блок рекомендуется использовать в случае внешней обработки. Обязательный блок.
	Обработка1.Инициализировать(ПолеТекстовогоДокументаСКонтекстнойПодсказкой,
		ЭтаФорма, ЭлементыФормы.ВстроенныйЯзык, ЭлементыФормы.КоманднаяПанельВстроенныйЯзык, Ложь, "ВыполнитьЛокально", ЭтаФорма);
	Обработка2.Инициализировать(ПолеТекстовогоДокументаСКонтекстнойПодсказкой,
		ЭтаФорма, ЭлементыФормы.ЯзыкЗапросов, ЭлементыФормы.КоманднаяПанельЯзыкЗапросов, Истина);
	// ---.КЛАСС.ПолеТекстовогоДокументаСКонтекстнойПодсказкой

	ЭлементыФормы.ВстроенныйЯзык.УстановитьТекст("
	|//: ТаблицаРасчета = Новый ТаблицаЗначений;
	|// ТаблицаОкругления = Новый ТаблицаЗначений;
	|Таблица1 = Новый ТаблицаЗначений;
	|Таблица1.Колонки.Добавить(""Колонка1"");
	|Структура1 = Новый Структура(""Имя1, Имя2"");
	|Структура1.Имя1 = ""Структура1.Имя2 = 345"";
	|// Структура1.Имя2 = 90;
	|Список1 = Новый СписокЗначений;
	|СтрокаТаблицы1 = Таблица1.Добавить();
	|СтрокаТаблицы1.Колонка1 = 45;
	|Для Каждого Строка1 Из Таблица1 Цикл
	|	Сообщить(Строка1.Колонка1);
	|	Если Структура1.Свойство(""Имя1"") Тогда
	|		Выборка = Справочники." + Метаданные.Справочники[0].Имя + ".Выбрать();
	|		Пока Выборка.Следующий() Цикл
	|			Сообщить("""" + Выборка.Ссылка + "" "" + Строка1.Колонка1 + "" "" + Список1.НайтиПоЗначению(""343""));
	|		КонецЦикла;
	|	КонецЕсли;
	|КонецЦикла;
	|лПостроительОтчета.Параметры.Очистить();
	|СообщитьПривет();
	|Сообщить(ПолучитьСправочникиМенеджер().ТипВсеСсылки(), СтатусСообщения.Информация);
	|Сообщить(лТаблицаЗначений[0].Название);
	|ВыборкаИзЗапроса = лРезультатЗапроса.Выбрать();
	|Пока ВыборкаИзЗапроса.Следующий() Цикл
	|	Сообщить(ВыборкаИзЗапроса.Код);
	|КонецЦикла;
	|");
	
	ЭлементыФормы.ЯзыкЗапросов.УстановитьТекст("
	|ВЫБРАТЬ 
	|	Спр.Наименование
	|ИЗ 
	|	Справочник." + Метаданные.Справочники[0].Имя + " КАК Спр
	|");

КонецПроцедуры

// @@@.КЛАСС.ПолеТекстовогоДокументаСКонтекстнойПодсказкой
// Процедура служит для выполнения программы поля текстового документа в локальном контексте.
// Вызывается из компоненты ирКлсПолеТекстовогоДокументаСКонтекстнойПодсказкой в режиме внутреннего языка.
// Не является обязательной.
//
// Параметры:
//  ТекстДляВыполнения – Строка;
//  *ЛиСинтаксическийКонтроль - Булево, *Ложь - признак вызова только для синтаксического контроля.
//
Функция ВыполнитьЛокально(ТекстДляВыполнения, ЛиСинтаксическийКонтроль = Ложь) Экспорт

	Выполнить(ТекстДляВыполнения);

КонецФункции // ВыполнитьЛокально()

Процедура ПриЗакрытии()
	
	// +++.КЛАСС.ПолеТекстовогоДокументаСКонтекстнойПодсказкой
	// Уничтожение всех экземпляров компоненты. Обязательный блок.
	Для Каждого Экземпляр Из ПолеТекстовогоДокументаСКонтекстнойПодсказкой Цикл
		Экземпляр.Значение.Уничтожить();
	КонецЦикла;
	// ---.КЛАСС.ПолеТекстовогоДокументаСКонтекстнойПодсказкой
	
КонецПроцедуры

Функция ПолучитьСправочникиМенеджер()

	Возврат Справочники;

КонецФункции // ПолучитьОбъектМетаданных()

Процедура СообщитьПривет()

	Сообщить("Привет");

КонецПроцедуры // СообщитьПривет()

//ирПортативный #Если Клиент Тогда
//ирПортативный Контейнер = Новый Структура();
//ирПортативный Оповестить("ирПолучитьБазовуюФорму", Контейнер);
//ирПортативный Если Не Контейнер.Свойство("ирПортативный", ирПортативный) Тогда
//ирПортативный 	ПолноеИмяФайлаБазовогоМодуля = ирОбщий.ВосстановитьЗначениеЛкс("ирПолноеИмяФайлаОсновногоМодуля");
//ирПортативный 	ирПортативный = ВнешниеОбработки.ПолучитьФорму(ПолноеИмяФайлаБазовогоМодуля);
//ирПортативный КонецЕсли; 
//ирПортативный ирОбщий = ирПортативный.ПолучитьОбщийМодульЛкс("ирОбщий");
//ирПортативный ирКэш = ирПортативный.ПолучитьОбщийМодульЛкс("ирКэш");
//ирПортативный ирСервер = ирПортативный.ПолучитьОбщийМодульЛкс("ирСервер");
//ирПортативный ирПривилегированный = ирПортативный.ПолучитьОбщийМодульЛкс("ирПривилегированный");
//ирПортативный #КонецЕсли

ирОбщий.ИнициализироватьФормуЛкс(ЭтаФорма, "Обработка.ирКлсПолеТекстовогоДокументаСКонтекстнойПодсказкой.Форма.ФормаПример");

лСписок = Новый СписокЗначений;