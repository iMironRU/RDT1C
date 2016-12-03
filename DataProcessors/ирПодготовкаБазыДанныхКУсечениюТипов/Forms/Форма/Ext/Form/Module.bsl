﻿////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ МОДУЛЯ

Перем мТекущаяГруппа;
Перем мТекущийРегистр;
Перем мТекущийПВХ;

Процедура УстановитьТолькоПросмотрКолонок(ТабличноеПоле)

	Для Каждого Колонка Из ТабличноеПоле.Колонки Цикл
		Колонка.ТолькоПросмотр = Истина;
	КонецЦикла;

КонецПроцедуры // УстановитьТолькоПросмотрКолонок()

Процедура ВывестиСоставРегистра(НовыйТекущийРегистр = Неопределено)
	
	Если НовыйТекущийРегистр <> Неопределено Тогда
		мТекущийРегистр = НовыйТекущийРегистр;
	КонецЕсли;
	ГруппыТекущегоРегистра.Очистить();
	//ЭлементыФормы.ГруппыТекущегоРегистра.ТолькоПросмотр = (мТекущийРегистр = Неопределено);
	Если мТекущийРегистр = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	мЗапрос.Текст = "ВЫБРАТЬ * ИЗ " + мТекущийРегистр.Имя;
	ГруппыТекущегоРегистра = мЗапрос.Выполнить().Выгрузить();
	ЭлементыФормы.ПроблемныеРегистры.ТекущаяСтрока = мТекущийРегистр;
	ГруппыТекущегоРегистра.Колонки.Вставить(0, "НомерГруппы");
	ГруппыТекущегоРегистра.Колонки.Вставить(0, "ВывестиСостав");
	
	МетаРегистр = Метаданные.РегистрыСведений[мТекущийРегистр.Имя];
	Для Каждого МетаИзмерение Из МетаРегистр.Измерения Цикл
		мСтруктураПредставлений.Вставить(МетаИзмерение.Имя, МетаИзмерение.Представление());
	КонецЦикла;
	Для Каждого МетаРесурс Из МетаРегистр.Ресурсы Цикл
		мСтруктураПредставлений.Вставить(МетаРесурс.Имя, МетаРесурс.Представление());
	КонецЦикла;
	Для Каждого МетаРеквизит Из МетаРегистр.Реквизиты Цикл
		мСтруктураПредставлений.Вставить(МетаРеквизит.Имя, МетаРеквизит.Представление());
	КонецЦикла;
	
	УстановитьПредставленияКолонок(ГруппыТекущегоРегистра);
	Для Счетчик = 1 По ГруппыТекущегоРегистра.Количество() Цикл
		ГруппыТекущегоРегистра[Счетчик - 1].НомерГруппы = Счетчик;
	КонецЦикла;
		
	ЭлементыФормы.ГруппыТекущегоРегистра.СоздатьКолонки();
	УстановитьТолькоПросмотрКолонок(ЭлементыФормы.ГруппыТекущегоРегистра);
	Если ГруппыТекущегоРегистра.Количество() > 0 Тогда
		ВывестиСоставГруппы(ГруппыТекущегоРегистра[0]);
	КонецЕсли; 
	ирОбщий.ОбновитьТекстПослеМаркераВСтрокеЛкс(ЭлементыФормы.РамкаГруппыГруппыТекущегоРегистра.Заголовок, , 
		Строка(ГруппыТекущегоРегистра.Количество()) + ")", "(");
		
КонецПроцедуры

Процедура ВывестиСоставПВХ(НовыйТекущийПВХ = Неопределено)
	
	Если НовыйТекущийПВХ <> Неопределено Тогда
		мТекущийПВХ = НовыйТекущийПВХ;
	КонецЕсли;
	ЗатрагиваемыеЭлементыТекущегоПланаВидовХарактеристик.Очистить();
	Если мТекущийПВХ = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПостроительЗапроса = Новый ПостроительЗапроса;
	ПостроительЗапроса.Текст = "
	|ВЫБРАТЬ 
	|	* 
	|ИЗ 
	|	ПланВидовХарактеристик." + мТекущийПВХ.Имя + " КАК _Таблица_ 
	|	ГДЕ 
	|	_Таблица_.Ссылка В (&СписокОтбора)";
	ПостроительЗапроса.ЗаполнитьНастройки();
	ОтобранныеСсылки = мЗатронутыеЭлементыПВХ.Скопировать(Новый Структура("Имя", мТекущийПВХ.Имя)).ВыгрузитьКолонку("Ссылка");
	ПостроительЗапроса.Параметры.Вставить("СписокОтбора", ОтобранныеСсылки);
	ПостроительЗапроса.Выполнить();
	ЗатрагиваемыеЭлементыТекущегоПланаВидовХарактеристик = ПостроительЗапроса.Результат.Выгрузить();
	ЭлементыФормы.ПроблемныеПланыВидовХарактеристик.ТекущаяСтрока = мТекущийПВХ;
	ЭлементыФормы.ЗатрагиваемыеЭлементыТекущегоПланаВидовХарактеристик.СоздатьКолонки();
	УстановитьТолькоПросмотрКолонок(ЭлементыФормы.ЗатрагиваемыеЭлементыТекущегоПланаВидовХарактеристик);
	ирОбщий.ОбновитьТекстПослеМаркераВСтрокеЛкс(ЭлементыФормы.РамкаГруппыЗатрагиваемыеЭлементыТекущегоПланаВидовХарактеристик.Заголовок, ,
		Строка(ЗатрагиваемыеЭлементыТекущегоПланаВидовХарактеристик.Количество()) + ")", "(");
	
КонецПроцедуры

Процедура ВывестиСоставГруппы(НоваяТекущаяГруппа = Неопределено)
	
	Если НоваяТекущаяГруппа <> Неопределено Тогда
		мТекущаяГруппа = НоваяТекущаяГруппа;
	КонецЕсли;
	ЭлементыТекущейГруппы.Очистить();
	//ЭлементыФормы.ЭлементыТекущейГруппы.ТолькоПросмотр = (мТекущаяГруппа = Неопределено);
	Если мТекущаяГруппа = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ЭлементыТекущейГруппы = ПолучитьПроблемныеЗаписиГруппыРегистра(мТекущийРегистр, мТекущаяГруппа);
	//ЭлементыТекущейГруппы.Колонки.Добавить("Правильный", Новый ОписаниеТипов("Булево"));
	ЭлементыТекущейГруппы.Колонки.Вставить(0, "ОткрытьЗапись");
	
	ЭлементыФормы.ГруппыТекущегоРегистра.ТекущаяСтрока = мТекущаяГруппа;
	УстановитьПредставленияКолонок(ЭлементыТекущейГруппы);
	ЭлементыФормы.ЭлементыТекущейГруппы.СоздатьКолонки();
	УстановитьТолькоПросмотрКолонок(ЭлементыФормы.ЭлементыТекущейГруппы);
	
	ирОбщий.ОбновитьТекстПослеМаркераВСтрокеЛкс(ЭлементыФормы.РамкаГруппыЭлементыГруппы.Заголовок, ,
		Строка(ЭлементыТекущейГруппы.Количество()) + ")", "(");
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ДЕЙСТВИЯ КОМАНДНОЙ ПАНЕЛЕЙ ФОРМЫ "НастройкиОтчета"

Процедура УстановитьПредставленияКолонок(Таблица)

	Для Каждого Колонка Из Таблица.Колонки Цикл
		Колонка.Заголовок = мСтруктураПредставлений[Колонка.Имя];
	КонецЦикла;

КонецПроцедуры // УстановитьПредставленияКолонок()

// <Описание процедуры>
//
// Параметры:
//  <Параметр1>  – <Тип.Вид> – <описание параметра>
//                 <продолжение описания параметра>;
//  <Параметр2>  – <Тип.Вид> – <описание параметра>
//                 <продолжение описания параметра>.
//
Процедура ОбновитьДанные()

	Успех = ВыполнитьАнализ();
	
	ирОбщий.ОбновитьТекстПослеМаркераВСтрокеЛкс(ЭлементыФормы.ПанельОсновная.Страницы.РегистрыСведений.Заголовок, ,
		Строка(ПроблемныеРегистры.Количество()) + ")", "(");
		
	ирОбщий.ОбновитьТекстПослеМаркераВСтрокеЛкс(ЭлементыФормы.ПанельОсновная.Страницы.ПланыВидовХарактеристик.Заголовок, ,
		Строка(ПроблемныеПланыВидовХарактеристик.Количество()) + ")", "(");
		
	Если ПроблемныеПланыВидовХарактеристик.Количество() > 0 Тогда
		ВывестиСоставПВХ(ПроблемныеПланыВидовХарактеристик[0]);
	КонецЕсли; 

	//ГруппыТекущегоРегистра.Сортировать(ирОбщий.ПолучитьСтрокуПорядкаЛкс(ПостроительОтчетаОтбора.Порядок));
	Если ПроблемныеРегистры.Количество() > 0 Тогда
		ВывестиСоставРегистра(ПроблемныеРегистры[0]);
	КонецЕсли;
	
	Если Успех Тогда
		Предупреждение("Проблем не обнаружено");
	КонецЕсли;

КонецПроцедуры // ОбновитьДанные()

Процедура КоманднаяПанельНастройкиОтчетаПоиск(Кнопка)
	
	ОбновитьДанные();

КонецПроцедуры

Процедура ЭлементыТекущейГруппыПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
		
	ОформлениеСтроки.Ячейки.ОткрытьЗапись.УстановитьТекст(">>>");
	ОформлениеСтроки.Ячейки.ОткрытьЗапись.ЦветФона = WebЦвета.Аквамарин;
	
КонецПроцедуры

Процедура ГруппыТекущегоРегистраВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	Если Элемент.ТекущаяСтрока <> Неопределено Тогда
		Если Колонка.Имя = "ВывестиСостав" Тогда
			ВывестиСоставГруппы(Элемент.ТекущаяСтрока);
		Иначе
			ЗначениеЯчейки = Элемент.ТекущаяСтрока[Колонка.Имя];
			КорневойТипЗначения = ирОбщий.ПолучитьКорневойТипКонфигурацииЛкс(ЗначениеЯчейки);
			Если КорневойТипЗначения <> Неопределено Тогда
				ОткрытьЗначение(ЗначениеЯчейки);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ГруппыТекущегоРегистраПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	
	Если ДанныеСтроки = мТекущаяГруппа Тогда
		ОформлениеСтроки.ЦветФона = Новый Цвет(255, 200, 200);
	КонецЕсли;
	ОформлениеСтроки.Ячейки.ВывестиСостав.УстановитьТекст(">>>");
	ОформлениеСтроки.Ячейки.ВывестиСостав.ЦветФона = WebЦвета.Аквамарин;
	
КонецПроцедуры

Процедура КоманднаяПанельЭлементыТекущейГруппыАвтоопределениеПравильных(Кнопка)
	// Вставить содержимое обработчика.
КонецПроцедуры

Процедура ГруппыТекущегоРегистраПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	
КонецПроцедуры

Процедура ГруппыТекущегоРегистраПередНачаломДобавления(Элемент, Отказ, Копирование)
	
	Если Копирование Тогда
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

Процедура ГруппыТекущегоРегистраПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	КопияТаблицы = ГруппыТекущегоРегистра.Скопировать(, "НомерГруппы");
	КопияТаблицы.Сортировать("НомерГруппы Убыв");
	Если КопияТаблицы.Количество() > 1 Тогда
		ПоследнийНомер = КопияТаблицы[0].НомерГруппы;
	Иначе
		ПоследнийНомер = 0;
	КонецЕсли;
	Элемент.ТекущаяСтрока.НомерГруппы = ПоследнийНомер + 1;
	ирОбщий.ОбновитьТекстПослеМаркераВСтрокеЛкс(ЭлементыФормы.РамкаГруппыГруппыТекущегоРегистра.Заголовок, ,
		Строка(ГруппыТекущегоРегистра.Количество()) + ")", "(");
	ВывестиСоставГруппы(Элемент.ТекущаяСтрока);

КонецПроцедуры

Процедура ЗависимыеОбъектыПриАктивизацииСтроки(Элемент)
	
	Элемент.Колонки.Правильный.ЭлементУправления.КнопкаВыбора = (Элемент.ТекущаяСтрока.Уровень() = 2);
	Элемент.Колонки.Правильный.ТолькоПросмотр   = (Элемент.ТекущаяСтрока.Уровень() = 0);
	Элемент.Колонки.НеПравильный.ТолькоПросмотр = (Элемент.ТекущаяСтрока.Уровень() = 0);
	
КонецПроцедуры

Процедура ПроблемныеРегистрыВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)

	//Если ВыбраннаяСтрока <> Неопределено Тогда
		Если Колонка.Имя = "ВывестиСостав" Тогда
			ВывестиСоставРегистра(ВыбраннаяСтрока);
		Иначе
			ЗначениеЯчейки = ВыбраннаяСтрока[Колонка.Имя];
			КорневойТипЗначения = ирОбщий.ПолучитьКорневойТипКонфигурацииЛкс(ЗначениеЯчейки);
			Если КорневойТипЗначения <> Неопределено Тогда
				ОткрытьЗначение(ЗначениеЯчейки);
			КонецЕсли;
		КонецЕсли;
	//КонецЕсли;
	
КонецПроцедуры

Процедура ПроблемныеРегистрыПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	
	Если ДанныеСтроки = мТекущийРегистр Тогда
		ОформлениеСтроки.ЦветФона = Новый Цвет(255, 200, 200);
	КонецЕсли;
	ОформлениеСтроки.Ячейки.ВывестиСостав.УстановитьТекст(">>>");
	ОформлениеСтроки.Ячейки.ВывестиСостав.ЦветФона = WebЦвета.Аквамарин;

КонецПроцедуры

Процедура ЭлементыТекущейГруппыВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	Если Колонка.Имя = "ОткрытьЗапись" Тогда 
		МенеджерЗначения = РегистрыСведений[мТекущийРегистр.Имя];
		ФормаСписка = МенеджерЗначения.ПолучитьФормуСписка();
		ФормаСписка.ПараметрТекущаяСтрока = ирОбщий.ПолучитьКлючПоСтруктуреЗаписиРегистраЛкс(ВыбраннаяСтрока, Метаданные.РегистрыСведений[мТекущийРегистр.Имя]);
		ФормаСписка.Открыть();
	Иначе
		ОткрытьЗначение(ВыбраннаяСтрока[Колонка.Имя]);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПроблемныеПВХВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)

	//Если ВыбраннаяСтрока <> Неопределено Тогда
		Если Колонка.Имя = "ВывестиСостав" Тогда
			ВывестиСоставПВХ(ВыбраннаяСтрока);
		Иначе
			ЗначениеЯчейки = ВыбраннаяСтрока[Колонка.Имя];
			КорневойТипЗначения = ирОбщий.ПолучитьКорневойТипКонфигурацииЛкс(ЗначениеЯчейки);
			Если КорневойТипЗначения <> Неопределено Тогда
				ОткрытьЗначение(ЗначениеЯчейки);
			КонецЕсли;
		КонецЕсли;
	//КонецЕсли;
	
КонецПроцедуры

Процедура ЭлементыТекущегоПВХВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	ОткрытьЗначение(ВыбраннаяСтрока[Колонка.Имя]);
		
КонецПроцедуры

Процедура КоманднаяПанельЗатрагиваемыеЭлементыТекущегоПланаВидовХарактеристикАвтоОчисткаТиповЗначений(Кнопка)
	
	фВыполнитьКоррекциюПВХ(ЗатрагиваемыеЭлементыТекущегоПланаВидовХарактеристик);
	ОбновитьДанные();
	 
КонецПроцедуры

Процедура КоманднаяПанельПроблемныеПланыВидовХарактеристикАвтоОчисткаТиповЗначений(Кнопка)

	фВыполнитьКоррекциюПВХ(мЗатронутыеЭлементыПВХ);
	ОбновитьДанные();
 
КонецПроцедуры

Процедура КоманднаяПанельЭлементыТекущейГруппыРегистраУдалить(Кнопка)
	
	ВыполнитьОчисткуГруппыРегистра(мТекущийРегистр, мТекущаяГруппа);
	ОбновитьДанные();
	
КонецПроцедуры

Процедура КоманднаяПанельРегистрыУдалить(Кнопка)
	
	ВыполнитьОчисткуРегистров();
	ОбновитьДанные();
	
КонецПроцедуры

Процедура КоманднаяПанельГруппыТекущегоРегистраУдалить(Кнопка)
	
	ВыполнитьОчисткуРегистра(мТекущийРегистр);
	ОбновитьДанные();
	
КонецПроцедуры

// <Описание процедуры>
//
// Параметры:
//  <Параметр1>  – <Тип.Вид> – <описание параметра>
//                 <продолжение описания параметра>;
//  <Параметр2>  – <Тип.Вид> – <описание параметра>
//                 <продолжение описания параметра>.
//
Процедура фВыполнитьКоррекциюПВХ(ЭлементыПВХ) 

	Ответ = Вопрос("Вы уверены, что хотите удалить из типов значений ссылки на типы """ + УсекаемыеТипы + """?",
		РежимДиалогаВопрос.ОКОтмена);
	Если Ответ = КодВозвратаДиалога.Отмена Тогда
		Возврат;
	КонецЕсли;
	ВыполнитьКоррекциюПВХ(ЭлементыПВХ);

КонецПроцедуры // мВыполнитьКоррекциюПВХ()

Процедура АвтокоррекцияНажатие(Элемент)
	
	Ответ = Вопрос("Проблемные записи регистров будут удалены. Из типов значений видов характеристик будут удалены ссылки на указанные типы."
		+ " Продолжить?", РежимДиалогаВопрос.ОКОтмена);
	Если Ответ = КодВозвратаДиалога.Отмена Тогда
		Возврат;
	КонецЕсли;
	Если ВыполнятьВТранзакции Тогда
		НачатьТранзакцию();
	КонецЕсли;
	ВыполнитьКоррекциюПВХ(мЗатронутыеЭлементыПВХ);
	ВыполнитьОчисткуРегистров();
	Если ВыполнятьВТранзакции Тогда
		ЗафиксироватьТранзакцию();
	КонецЕсли;
	ОбновитьДанные();
	
КонецПроцедуры

Процедура КоманднаяПанельОПодсистеме(Кнопка)
	ирОбщий.ОткрытьСправкуПоПодсистемеЛкс(ЭтотОбъект);
КонецПроцедуры

Процедура ГлавнаяКоманднаяПанельНовоеОкно(Кнопка)
	
	ирОбщий.ОткрытьНовоеОкноОбработкиЛкс(ЭтотОбъект);
	
КонецПроцедуры

Процедура КоманднаяПанельЗаполнитьУсекаемыеТипы(Кнопка, Таймаут = Неопределено)
	
	Если Таймаут = Неопределено Тогда
		Таймаут = 10;
	КонецЕсли; 
	Ответ = Вопрос("Хотите заполнить усекаемые типы путем сравнения конфигурации БД с выбранным файлом конфигурации (Да),
		|иначе путем сравнения с основной конфигурацией и требуется освободить конфигуратор (Нет)?", РежимДиалогаВопрос.ДаНет, Таймаут);
	Если Ответ = КодВозвратаДиалога.Да Тогда
		ВыборФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
		ВыборФайла.Фильтр = ирОбщий.ПолучитьСтрокуФильтраДляВыбораФайлаЛкс("CF");
		ВыборФайла.Расширение = "CF";
		Если Не ВыборФайла.Выбрать() Тогда
			Возврат;
		КонецЕсли;
		ПолноеИмяФайлаКонфигурации = ВыборФайла.ПолноеИмяФайла;
		ЗаполнитьПоРазницеМеждуКонфигурациями(ПолноеИмяФайлаКонфигурации);
	Иначе
		Если Не КонфигурацияИзменена() Тогда
			Предупреждение("Конфигурация БД совпадает с основной конфигурацией", Таймаут);
			Возврат;
		КонецЕсли; 
		ЗаполнитьПоРазницеМеждуКонфигурациями();
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	ирОбщий.ФормаОбработкаОповещенияЛкс(ЭтаФорма, ИмяСобытия, Параметр, Источник); 

КонецПроцедуры

ирОбщий.ИнициализироватьФормуЛкс(ЭтаФорма, "Обработка.ирПодготовкаБазыДанныхКУсечениюТипов.Форма.Форма");
ЭлементыФормы.ЗаписьНаСервере.Доступность = Не ирКэш.ЛиПортативныйРежимЛкс();
