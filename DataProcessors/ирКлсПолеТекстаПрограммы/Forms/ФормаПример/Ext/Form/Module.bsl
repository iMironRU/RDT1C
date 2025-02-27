﻿////////////////////////////////////////////////////////////////////////////////
// ПРИМЕР ИСПОЛЬЗОВАНИЯ КОМПОНЕНТЫ.
//
// Здесь описан порядок подключения компоненты к своему полю текстового документа в режиме внутреннего языка или языка запросов.
//
// Создаете реквизит формы типа ОбработкаОбъект.ирКлсПолеТекстаПрограммы.
// Рядом с полем текстового документа лучше создать пустую командную панель, но можно и не создавать,
// тогда у поля будет только контекстное меню.
// При открытии формы прописываем инициализацию экземпляров компоненты, а при закрытии - их уничтожение.
// Для хранения всех экземпляров компоненты служит переменная модуля формы ПолеТекстаПрограммы.
// Блоки кода, отвечающие за работу с компонентой обрамлены в комментарии:

// +++.КЛАСС.ПолеТекстаПрограммы
//...
// ---.КЛАСС.ПолеТекстаПрограммы


// +++.КЛАСС.ПолеТекстаПрограммы
// Это коллекция экземпляров компоненты. Обязательный блок.
Перем ПолеТекстаПрограммы;
// ---.КЛАСС.ПолеТекстаПрограммы

Перем лСписок;

// @@@.КЛАСС.ПолеТекстаПрограммы
// Транслятор обработки событий нажатия на кнопки командной панели в компоненту.
// Является обязательным.
//
// Параметры:
//  Кнопка       – КнопкаКоманднойПанели.
//
Процедура КлсПолеТекстаПрограммыНажатие(Кнопка)
	
	// Имя страницы совпадает с именем поля текстового документа
	ИмяСтраницы = ЭлементыФормы.ПанельОсновная.ТекущаяСтраница.Имя;
	ЭкземплярКомпоненты = ПолеТекстаПрограммы[ИмяСтраницы];
	Если ИмяСтраницы = "ВстроенныйЯзык" Тогда 
		ирОбщий.ИнициироватьГлобальныйКонтекстПодсказкиЛкс(ЭкземплярКомпоненты);
		
		// Это пример добавления слов локального контекста. Каждое слово представляет собой имя доступное
		// напрямую в данном контексте. Необязательный блок.
		
		// Свойство - переменная модуля
		МассивТипов = Новый Массив;
		МассивТипов.Добавить(ТипЗнч(лСписок));
		ПолеТекстаПрограммы.ВстроенныйЯзык.ДобавитьСловоЛокальногоКонтекста(
				"лСписок", "Свойство", Новый ОписаниеТипов(МассивТипов));
				
		// Свойство - реквизит формы
		МассивТипов = Новый Массив;
		МассивТипов.Добавить(ТипЗнч(лПостроительОтчета));
		ПолеТекстаПрограммы.ВстроенныйЯзык.ДобавитьСловоЛокальногоКонтекста(
				"лПостроительОтчета", "Свойство", Новый ОписаниеТипов(МассивТипов));
				
		// Свойство - таблица значений
		лТаблицаЗначений = Новый ТаблицаЗначений;
		лТаблицаЗначений.Колонки.Добавить("Структура", Новый ОписаниеТипов("Структура"));
		лТаблицаЗначений.Колонки.Добавить("Название", Новый ОписаниеТипов("Строка"));
		НоваяСтрока = лТаблицаЗначений.Добавить();
		НоваяСтрока.Название = "Новая строка";
		МассивТипов = Новый Массив;
		МассивТипов.Добавить(ТипЗнч(лТаблицаЗначений));
		ПолеТекстаПрограммы.ВстроенныйЯзык.ДобавитьСловоЛокальногоКонтекста(
				"лТаблицаЗначений", "Свойство", Новый ОписаниеТипов(МассивТипов), лТаблицаЗначений);
				
		// Свойство - результат запроса
		Запрос = Новый Запрос;
		Запрос.Текст = "
		|ВЫБРАТЬ * ИЗ Справочник." + Метаданные.Справочники[0].Имя + "
		|";
		лРезультатЗапроса = Запрос.Выполнить();
		МассивТипов = Новый Массив;
		МассивТипов.Добавить(ТипЗнч(лРезультатЗапроса));
		ПолеТекстаПрограммы.ВстроенныйЯзык.ДобавитьСловоЛокальногоКонтекста(
				"лРезультатЗапроса", "Свойство", Новый ОписаниеТипов(МассивТипов), лРезультатЗапроса);
		
		// Метод - процедура
		ПолеТекстаПрограммы.ВстроенныйЯзык.ДобавитьСловоЛокальногоКонтекста(
				"СообщитьПривет", "Метод");
				
		// Метод - функция
		МассивТипов = Новый Массив;
		МассивТипов.Добавить(Тип("СправочникиМенеджер"));
		ПолеТекстаПрограммы.ВстроенныйЯзык.ДобавитьСловоЛокальногоКонтекста(
				"ПолучитьСправочникиМенеджер", "Метод", Новый ОписаниеТипов(МассивТипов));

	КонецЕсли;
	ЭкземплярКомпоненты.Нажатие(Кнопка);
	
КонецПроцедуры

// @@@.КЛАСС.ПолеТекстаПрограммы
// Эта процедура может использоваться в качестве обработчика ожидания подключаемого/отключаемого внутри класса
// Если ее удалить, то функция "АвтоКонтекстаяСправка" автоматически отключается
//
Процедура КлсПолеТекстаПрограммыАвтоОбновитьСправку()
	
	ИмяСтраницы = ЭлементыФормы.ПанельОсновная.ТекущаяСтраница.Имя;
	ЭкземплярКомпоненты = ПолеТекстаПрограммы[ИмяСтраницы];
	#Если Сервер И Не Сервер Тогда
	    ЭкземплярКомпоненты = Обработки.ирКлсПолеТекстаПрограммы.Создать();
	#КонецЕсли
	ЭкземплярКомпоненты.АвтоОбновитьСправку();
	
КонецПроцедуры

// @@@.КЛАСС.ПолеТекстаПрограммы
Процедура ВнешнееСобытие(Источник, Событие, Данные) Экспорт
	
	Если ПолеТекстаПрограммы = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	ИмяСтраницы = ЭлементыФормы.ПанельОсновная.ТекущаяСтраница.Имя;
	ЭкземплярКомпоненты = ПолеТекстаПрограммы[ИмяСтраницы];
	#Если Сервер И Не Сервер Тогда
	    ЭкземплярКомпоненты = Обработки.ирКлсПолеТекстаПрограммы.Создать();
	#КонецЕсли
	ЭкземплярКомпоненты.ВнешнееСобытиеОбъекта(Источник, Событие, Данные);
	
КонецПроцедуры

Процедура ПриОткрытии()
	
	// +++.КЛАСС.ПолеТекстаПрограммы
	ПолеТекстаПрограммы = Новый Структура;

	// Этот блок рекомендуется использовать в случае внутренней обработки. Обязательный блок.
	//ОбработкаМенеджер = Обработки.ирКлсПолеТекстаПрограммы;
	//ОбработкаМенеджер.Создать().Инициализировать(ПолеТекстаПрограммы,
	//	ЭтаФорма, ЭлементыФормы.ВстроенныйЯзык, ЭлементыФормы.КоманднаяПанельВстроенныйЯзык, Ложь, "ВыполнитьЛокально", ЭтаФорма);
	//ОбработкаМенеджер.Создать().Инициализировать(ПолеТекстаПрограммы,
	//	ЭтаФорма, ЭлементыФормы.ЯзыкЗапросов, ЭлементыФормы.КоманднаяПанельЯзыкЗапросов, Истина);
		
	// Этот блок рекомендуется использовать в случае внешней обработки. Обязательный блок.
	Обработка1.Инициализировать(ПолеТекстаПрограммы,
		ЭтаФорма, ЭлементыФормы.ВстроенныйЯзык, ЭлементыФормы.КоманднаяПанельВстроенныйЯзык, Ложь, "ВыполнитьЛокально", ЭтаФорма);
	Обработка2.Инициализировать(ПолеТекстаПрограммы,
		ЭтаФорма, ЭлементыФормы.ЯзыкЗапросов, ЭлементыФормы.КоманднаяПанельЯзыкЗапросов, Истина);
	// ---.КЛАСС.ПолеТекстаПрограммы

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

// @@@.КЛАСС.ПолеТекстаПрограммы
// Процедура служит для выполнения программы поля текстового документа в локальном контексте.
// Вызывается из компоненты ирКлсПолеТекстаПрограммы в режиме внутреннего языка.
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
	
	// +++.КЛАСС.ПолеТекстаПрограммы
	// Уничтожение всех экземпляров компоненты. Обязательный блок.
	Для Каждого Экземпляр Из ПолеТекстаПрограммы Цикл
		Экземпляр.Значение.Уничтожить();
	КонецЦикла;
	// ---.КЛАСС.ПолеТекстаПрограммы
	
КонецПроцедуры

Функция ПолучитьСправочникиМенеджер()

	Возврат Справочники;

КонецФункции // ПолучитьОбъектМетаданных()

Процедура СообщитьПривет()

	Сообщить("Привет");

КонецПроцедуры // СообщитьПривет()

Процедура ТабличноеПолеПриПолученииДанных(Элемент, ОформленияСтрок) Экспорт 
	
	ирОбщий.ТабличноеПолеПриПолученииДанныхЛкс(ЭтаФорма, Элемент, ОформленияСтрок);

КонецПроцедуры

ирОбщий.ИнициироватьФормуЛкс(ЭтаФорма, "Обработка.ирКлсПолеТекстаПрограммы.Форма.ФормаПример");

лСписок = Новый СписокЗначений;