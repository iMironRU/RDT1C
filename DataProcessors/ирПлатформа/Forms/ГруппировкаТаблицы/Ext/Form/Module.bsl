﻿Перем мТаблицаИсточника;
Перем мСтруктураИсточника;
Перем мСхемаКомпоновки;
перем мСтрокаПолейКлюча;
Перем мСтарыйСнимокНастройкиКомпоновки;
Перем мПоследняяВыбраннаяТаблицаБД;

Функция СохраняемаяНастройкаФормы(выхНаименование, выхИменаСвойств) Экспорт 
	выхИменаСвойств = "Форма.ГруппироватьСразу, Форма.МинимальныйРазмерГруппы";
	выхИменаСвойств = выхИменаСвойств + ", Форма.АвтовидимостьКолонокСоставаГруппы";
	Возврат Неопределено;
КонецФункции

Процедура ЗагрузитьНастройкуВФорме(НастройкаФормы, ДопПараметры) Экспорт 
	
	ирОбщий.ЗагрузитьНастройкуФормыЛкс(ЭтаФорма, НастройкаФормы); 
	ПриИзмененииАвтовидимостьКолонокСоставаГруппы();
	ГруппироватьСразуПриИзменении();
	
КонецПроцедуры

Процедура ПриОткрытии()
	
	ирОбщий.Форма_ПриОткрытииЛкс(ЭтаФорма);
	ирОбщий.СоздатьМенеджерСохраненияНастроекФормыЛкс(ЭтаФорма);
	Если ЭтаФорма.ВладелецФормы = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	УстановитьИсточник();
	ДанныеКолонки = ирОбщий.ПутьКДаннымКолонкиТабличногоПоляЛкс(ВладелецФормы);
	Если ЗначениеЗаполнено(ДанныеКолонки) Тогда
		ДоступноеПолеТекущейКолонки = Компоновщик.Настройки.ДоступныеПоляПорядка.НайтиПоле(Новый ПолеКомпоновкиДанных(ДанныеКолонки));
		Если ДоступноеПолеТекущейКолонки <> Неопределено Тогда
			ЭлементыФормы.ДоступныеПоля.ТекущаяСтрока = ДоступноеПолеТекущейКолонки;
			Если Не ЗначениеЗаполнено(ПараметрИменаКлючевыхКолонок) Тогда
				ПараметрИменаКлючевыхКолонок = ДанныеКолонки;
			КонецЕсли; 
		КонецЕсли; 
	КонецЕсли; 
	СтараяТекущаяСтрока = ВладелецФормы.ТекущаяСтрока;
	Если Компоновщик.Настройки.Отбор.Элементы.Количество() = 0 И СтараяТекущаяСтрока <> Неопределено Тогда
		Для Каждого ДоступноеПоле Из Компоновщик.Настройки.Отбор.ДоступныеПоляОтбора.Элементы Цикл
			ИмяКолонкиИсточника = "" + ДоступноеПоле.Поле;
			Если мТаблицаИсточника.Колонки.Найти(ИмяКолонкиИсточника) = Неопределено Тогда
				Продолжить;
			КонецЕсли; 
			ирОбщий.НайтиДобавитьЭлементОтбораКомпоновкиЛкс(Компоновщик.Настройки.Отбор, ДоступноеПоле.Поле, СтараяТекущаяСтрока[ИмяКолонкиИсточника],,,, Ложь);
		КонецЦикла;
	КонецЕсли; 
	Если ЗначениеЗаполнено(ПараметрИменаКлючевыхКолонок) Тогда
		ИменаКолонок = ирОбщий.СтрРазделитьЛкс(ПараметрИменаКлючевыхКолонок, "," , Истина, Ложь);
		Для Каждого ИмяКолонки Из ИменаКолонок Цикл
			ирОбщий.НайтиДобавитьЭлементНастроекКомпоновкиПоПолюЛкс(Компоновщик.Настройки.Порядок, ИмяКолонки);
		КонецЦикла;
		МинимальныйРазмерГруппы = 2;
		КПКлючиСтрокВыполнить();
		Если Истина
			И КлючиСтрок.Колонки.Количество() > 0
			И СтараяТекущаяСтрока <> Неопределено 
		Тогда
			ТекущийКлюч = Новый Структура(ПараметрИменаКлючевыхКолонок);
			ЗаполнитьЗначенияСвойств(ТекущийКлюч, СтараяТекущаяСтрока); 
			ТекущаяСтрока = КлючиСтрок.НайтиСтроки(ТекущийКлюч);
			Если ТекущаяСтрока.Количество() > 0 Тогда
				ЭлементыФормы.КлючиСтрок.ТекущаяСтрока = ТекущаяСтрока[0];
			КонецЕсли; 
		КонецЕсли; 
		КПКлючиСтрокВыделитьВИсточнике();
		//ВладелецФормы.ТекущаяСтрока = СтараяТекущаяСтрока; // Так сбросится выделение строк группы
	Иначе
		ГруппироватьСразуПриИзменении();
	КонецЕсли; 
	
КонецПроцедуры

Функция УстановитьИсточник()
	
	мПлатформа = ирКэш.Получить();
	#Если Сервер И Не Сервер Тогда
		мПлатформа = Обработки.ирПлатформа.Создать();
	#КонецЕсли
	ИсточникДействий = ЭтаФорма.ВладелецФормы;
	ЗначениеТабличногоПоля = ирОбщий.ДанныеЭлементаФормыЛкс(ИсточникДействий);
	ТипИсточника = ирОбщий.ОбщийТипДанныхТабличногоПоляЛкс(ИсточникДействий);
	ЭтаФорма.Отбор = Неопределено;
	Если ТипИсточника = "ТаблицаЗначений" Тогда 
		//
	ИначеЕсли ТипИсточника = "ДеревоЗначений" Тогда 
		//
	Иначе
		Если ТипИсточника = "ТабличнаяЧасть" Тогда 
			ЭтаФорма.Отбор = ИсточникДействий.ОтборСтрок;
		ИначеЕсли ТипИсточника = "НаборЗаписей" Тогда 
			ЭтаФорма.Отбор = ИсточникДействий.ОтборСтрок;
		Иначе
			Возврат Ложь;
		КонецЕсли;
	КонецЕсли;
	Если Отбор <> Неопределено Тогда
		ирОбщий.СкопироватьОтборЛюбойЛкс(Компоновщик.Настройки.Отбор, Отбор);
	КонецЕсли; 
	мТаблицаИсточника = ирОбщий.ТаблицаИлиДеревоЗначенийИзТаблицыФормыСКоллекциейЛкс(ИсточникДействий);
	мТаблицаИсточника = ирОбщий.СузитьТипыКолонокТаблицыБезПотериДанныхЛкс(мТаблицаИсточника);
	мСтруктураИсточника = Новый Структура("Таблица", мТаблицаИсточника);
	мСхемаКомпоновки = ирОбщий.СоздатьСхемуПоТаблицамЗначенийЛкс(мСтруктураИсточника);
	ИсточникНастроек = Новый ИсточникДоступныхНастроекКомпоновкиДанных(мСхемаКомпоновки);
	Компоновщик.Инициализировать(ИсточникНастроек);
	ЭлементПорядка = ирОбщий.НайтиДобавитьЭлементНастроекКомпоновкиПоПолюЛкс(Компоновщик.Настройки.Порядок, "КоличествоСтрокАвто");
	ЭлементПорядка.ТипУпорядочивания = НаправлениеСортировкиКомпоновкиДанных.Убыв;
	ЭтаФорма.СтрокиТекущегоКлюча = мТаблицаИсточника.СкопироватьКолонки();
	//ЭлементыФормы.СтрокиТекущегоКлюча.Колонки.Очистить();
	ЭлементыФормы.СтрокиТекущегоКлюча.СоздатьКолонки();
	ирОбщий.НастроитьДобавленныеКолонкиТабличногоПоляЛкс(ЭлементыФормы.СтрокиТекущегоКлюча,,,, Истина);
	
КонецФункции

Процедура КПКлючиСтрокВыполнить(Кнопка = Неопределено, РежимОтладки = Ложь, ВыбрасыватьИсключение = Ложь)
	
	Если мСхемаКомпоновки = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	КлючиСтрок.Очистить();
	КлючиСтрок.Колонки.Очистить();
	ЭлементыФормы.КлючиСтрок.Колонки.Очистить();
	Компоновщик.Восстановить();
	ВременныеНастройки = Компоновщик.ПолучитьНастройки();
	Если ВременныеНастройки.Структура.Количество() = 0 Тогда
		ирОбщий.НайтиДобавитьЭлементСтруктурыГруппировкаКомпоновкиЛкс(ВременныеНастройки.Структура);
	КонецЕсли;
	ПоляГруппировки = ВременныеНастройки.Структура[0].ПоляГруппировки.Элементы;
	ПоляГруппировки.Очистить();
	ВременныеНастройки.Выбор.Элементы.Очистить();
	мСтрокаПолейКлюча = Новый Массив;
	Для Каждого ЭлементПорядка Из ВременныеНастройки.Порядок.Элементы Цикл
		Если ЭлементПорядка.Использование Тогда
			Если "" + ЭлементПорядка.Поле <> "КоличествоСтрокАвто" Тогда
				мСтрокаПолейКлюча.Добавить("" + ЭлементПорядка.Поле);
				ирОбщий.НайтиДобавитьЭлементНастроекКомпоновкиПоПолюЛкс(ПоляГруппировки, ЭлементПорядка.Поле);
			КонецЕсли; 
			ирОбщий.НайтиДобавитьЭлементНастроекКомпоновкиПоПолюЛкс(ВременныеНастройки.Выбор, ЭлементПорядка.Поле);
		КонецЕсли; 
	КонецЦикла;
	ирОбщий.НайтиДобавитьЭлементНастроекКомпоновкиПоПолюЛкс(ВременныеНастройки.Выбор, "КоличествоСтрокАвто");
	ирОбщий.НайтиДобавитьЭлементОтбораКомпоновкиЛкс(ВременныеНастройки.Структура[0].Отбор, "КоличествоСтрокАвто", МинимальныйРазмерГруппы, ВидСравненияКомпоновкиДанных.БольшеИлиРавно);
	Попытка
		ирОбщий.СкомпоноватьВКоллекциюЗначенийПоСхемеЛкс(мСхемаКомпоновки, ВременныеНастройки, КлючиСтрок, мСтруктураИсточника,,,,, РежимОтладки);
	Исключение
		Если ВыбрасыватьИсключение Тогда
			ВызватьИсключение;
		Иначе
			ирОбщий.СообщитьЛкс(ОписаниеОшибки());
			Возврат;
		КонецЕсли; 
	КонецПопытки; 
	ЭтаФорма.КлючиСтрокКоличество = КлючиСтрок.Количество();
	ЭтаФорма.СтрокиТекущегоКлючаКоличество = 0;
	ЭлементыФормы.КлючиСтрок.СоздатьКолонки();
	ирОбщий.НастроитьДобавленныеКолонкиТабличногоПоляЛкс(ЭлементыФормы.КлючиСтрок,,,, Истина);
	мСтрокаПолейКлюча = ирОбщий.СтрСоединитьЛкс(мСтрокаПолейКлюча);
	Если КлючиСтрок.Количество() > 0 Тогда
		ЭлементыФормы.КлючиСтрок.ТекущаяСтрока = КлючиСтрок[0];
	КонецЕсли; 
	
КонецПроцедуры

Процедура ПриПолученииДанныхДоступныхПолей(Элемент, ОформленияСтрок)

	ирОбщий.ПриПолученииДанныхДоступныхПолейКомпоновкиЛкс(ЭтаФорма, Элемент, ОформленияСтрок);

КонецПроцедуры

Процедура КлючиСтрокПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки) Экспорт
	
	ирОбщий.ТабличноеПолеПриВыводеСтрокиЛкс(ЭтаФорма, Элемент, ОформлениеСтроки, ДанныеСтроки, ЭлементыФормы.КПКлючиСтрок.Кнопки.Идентификаторы);
	
КонецПроцедуры

Процедура МинимальныйРазмерГруппыПриИзменении(Элемент)
	
	ПроверитьИСгруппировать();
	
КонецПроцедуры

Процедура ПроверитьИСгруппировать()
	
	Если ГруппироватьСразу Тогда
		КПКлючиСтрокВыполнить();
	КонецЕсли; 
	
КонецПроцедуры

Процедура КлючевыеКолонкиПриИзмененииФлажка(Элемент, Колонка)
	
	ПроверитьИСгруппировать();
	
КонецПроцедуры

Процедура СтрокиТекущегоКлючаПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки) Экспорт
	
	ирОбщий.ТабличноеПолеПриВыводеСтрокиЛкс(ЭтаФорма, Элемент, ОформлениеСтроки, ДанныеСтроки, ЭлементыФормы.КПСтрокиТекущегоКлюча.Кнопки.Идентификаторы);

КонецПроцедуры

Процедура КПСтрокиТекущегоКлючаАвтовидимостьКолонок(Кнопка)
	
	ЭтаФорма.АвтовидимостьКолонокСоставаГруппы = Не Кнопка.Пометка;
	ПриИзмененииАвтовидимостьКолонокСоставаГруппы();
	
КонецПроцедуры

Процедура ПриИзмененииАвтовидимостьКолонокСоставаГруппы()
	
	ЭлементыФормы.КПСтрокиТекущегоКлюча.Кнопки.АвтовидимостьКолонок.Пометка = АвтовидимостьКолонокСоставаГруппы;
	ирОбщий.СкрытьПоказатьОднозначныеКолонкиТабличногоПоляЛкс(ЭлементыФормы.СтрокиТекущегоКлюча, АвтовидимостьКолонокСоставаГруппы);
	
КонецПроцедуры

Процедура КлючиСтрокПриАктивизацииСтроки(Элемент)
	
	ирОбщий.ТабличноеПолеПриАктивизацииСтрокиЛкс(ЭтаФорма, Элемент);
	СтрокиТекущегоКлюча.Очистить();
	ЭтаФорма.СтрокиТекущегоКлючаКоличество = 0;
	Если ЭлементыФормы.КлючиСтрок.ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	ВременныеНастройки = Компоновщик.ПолучитьНастройки();
	ТекущийКлюч = Новый Структура(мСтрокаПолейКлюча);
	ЗаполнитьЗначенияСвойств(ТекущийКлюч, ЭлементыФормы.КлючиСтрок.ТекущаяСтрока); 
	Для Каждого КлючИЗначение Из ТекущийКлюч Цикл
		ЭлементОтбора = ирОбщий.НайтиДобавитьЭлементОтбораКомпоновкиЛкс(ВременныеНастройки.Отбор, КлючИЗначение.Ключ, КлючИЗначение.Значение);
		#Если Сервер И Не Сервер Тогда
			ЭлементОтбора = ВременныеНастройки.Отбор.Элементы.Добавить();
		#КонецЕсли
		ЭлементОтбора.Использование = Истина;
	КонецЦикла;
	ВременныеНастройки.Выбор.Элементы.Очистить();
	Для Каждого ДоступноеПоле Из ВременныеНастройки.ДоступныеПоляВыбора.Элементы Цикл
		Если Не ДоступноеПоле.Папка И "" + ДоступноеПоле.Поле <> "КоличествоСтрокАвто" Тогда
			ирОбщий.НайтиДобавитьЭлементНастроекКомпоновкиПоПолюЛкс(ВременныеНастройки.Выбор, ДоступноеПоле.Поле);
		КонецЕсли;
	КонецЦикла;
	ирОбщий.СкомпоноватьВКоллекциюЗначенийПоСхемеЛкс(мСхемаКомпоновки, ВременныеНастройки, СтрокиТекущегоКлюча, мСтруктураИсточника);
	ЭтаФорма.СтрокиТекущегоКлючаКоличество = СтрокиТекущегоКлюча.Количество();
	ПриИзмененииАвтовидимостьКолонокСоставаГруппы();
	
КонецПроцедуры

Процедура СтрокиТекущегоКлючаПриАктивизацииСтроки(Элемент)
	
	ирОбщий.ТабличноеПолеПриАктивизацииСтрокиЛкс(ЭтаФорма, Элемент);

КонецПроцедуры

Процедура ДействияФормыИсходнаяТаблица(Кнопка)
	
	ирОбщий.ОткрытьЗначениеЛкс(мТаблицаИсточника,,,, Ложь);
	
КонецПроцедуры

Процедура КлючиСтрокВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	ирОбщий.ЯчейкаТабличногоПоляРасширенногоЗначения_ВыборЛкс(ЭтаФорма, Элемент, СтандартнаяОбработка);
	
КонецПроцедуры

Процедура СтрокиТекущегоКлючаВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	ирОбщий.ЯчейкаТабличногоПоляРасширенногоЗначения_ВыборЛкс(ЭтаФорма, Элемент, СтандартнаяОбработка);

КонецПроцедуры

Процедура КПКлючиСтрокВыделитьВИсточнике(Кнопка = Неопределено)
	
	Если ЭлементыФормы.КлючиСтрок.ТекущаяСтрока = Неопределено Или Не ЗначениеЗаполнено(мСтрокаПолейКлюча) Тогда
		Возврат;
	КонецЕсли; 
	ирОбщий.ВыделитьСтрокиТабличногоПоляПоКлючуЛкс(ЭтаФорма.ВладелецФормы, ЭлементыФормы.КлючиСтрок.ТекущаяСтрока, мСтрокаПолейКлюча);
	
КонецПроцедуры

Процедура ДействияФормыИсполняемаяКомпоновка(Кнопка)
	
	КПКлючиСтрокВыполнить(, Истина);
	
КонецПроцедуры

Процедура МинимальныйРазмерГруппыОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Элемент.Значение = Элемент.МинимальноеЗначение;
	
КонецПроцедуры

Процедура ГруппироватьСразуПриИзменении(Элемент = Неопределено)
	
	Если ГруппироватьСразу Тогда
		ПроверитьИСгруппировать();
	КонецЕсли; 
	
КонецПроцедуры

Процедура ОбновлениеОтображения()
	
	ЭлементыФормы.НадписьОтбор.Заголовок = ирОбщий.ПредставлениеОтбораЛкс(Компоновщик.Настройки.Отбор);
	Если ГруппироватьСразу Тогда
		Если мСтарыйСнимокНастройкиКомпоновки <> ирОбщий.СохранитьОбъектВВидеСтрокиXMLЛкс(Компоновщик.Настройки) Тогда
			Компоновщик.Восстановить();
			КПКлючиСтрокВыполнить();
			мСтарыйСнимокНастройкиКомпоновки = ирОбщий.СохранитьОбъектВВидеСтрокиXMLЛкс(Компоновщик.Настройки);
		КонецЕсли; 
	КонецЕсли; 
	
КонецПроцедуры

Процедура ДоступныеПоляВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	ирОбщий.НайтиДобавитьЭлементНастроекКомпоновкиПоПолюЛкс(ЭлементыФормы.КлючевыеКолонки, ВыбраннаяСтрока.Поле,,, СтандартнаяОбработка);
	
КонецПроцедуры

Процедура КлючевыеКолонкиВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	ирОбщий.ТабличноеПолеПорядкаКомпоновкиВыборЛкс(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка);
	
КонецПроцедуры

Процедура ОтборПриАктивизацииСтроки(Элемент)
	
	ирОбщий.ТабличноеПолеПриАктивизацииСтрокиЛкс(ЭтаФорма, Элемент);
	
КонецПроцедуры

Процедура КлючевыеКолонкиПриАктивизацииСтроки(Элемент)
	
	ирОбщий.ТабличноеПолеПриАктивизацииСтрокиЛкс(ЭтаФорма, Элемент);

КонецПроцедуры

Процедура КлючевыеКолонкиПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки) Экспорт
	
	ирОбщий.ТабличноеПолеПриВыводеСтрокиЛкс(ЭтаФорма, Элемент, ОформлениеСтроки, ДанныеСтроки);
	
КонецПроцедуры

Процедура ОтборПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки) Экспорт
	
	ирОбщий.ТабличноеПолеПриВыводеСтрокиЛкс(ЭтаФорма, Элемент, ОформлениеСтроки, ДанныеСтроки);

КонецПроцедуры

Процедура КлсКомандаНажатие(Кнопка) Экспорт 
	
	ирОбщий.УниверсальнаяКомандаФормыЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура СтруктураКоманднойПанелиНажатие(Кнопка)
	
	ирОбщий.ОткрытьСтруктуруКоманднойПанелиЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура КПСтрокиТекущегоКлючаВыделитьВИсточнике(Кнопка)
	
	ирОбщий.ВыделитьСтрокиТабличногоПоляПоКлючуЛкс(ЭтаФорма.ВладелецФормы, ЭлементыФормы.СтрокиТекущегоКлюча.ТекущаяСтрока,, Ложь);
	
КонецПроцедуры

Процедура КлючевыеКолонкиПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Колонка)
	
	ирОбщий.ТабличноеПолеЭлементовКомпоновкиПеретаскиваниеЛкс(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Колонка);
	
КонецПроцедуры

Процедура ПриЗакрытии()
	
	ирОбщий.Форма_ПриЗакрытииЛкс(ЭтаФорма);

КонецПроцедуры

Процедура ДействияФормыУстановитьГруппирующиеКолонкиПоТаблицеБД(Кнопка)
	
	ФормаВыбораОбъектаБД = ирОбщий.ПолучитьФормуВыбораОбъектаМетаданныхЛкс(,, мПоследняяВыбраннаяТаблицаБД,,,, Истина, Истина,,, Истина, Истина);
	РезультатВыбора = ФормаВыбораОбъектаБД.ОткрытьМодально();
	Если РезультатВыбора = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	мПоследняяВыбраннаяТаблицаБД = РезультатВыбора.ПолноеИмяОбъекта;
	СтруктураКлюча = ирОбщий.СтруктураКлючаТаблицыБДЛкс(ирКэш.ИмяТаблицыИзМетаданныхЛкс(мПоследняяВыбраннаяТаблицаБД),,, Ложь);
	#Если Сервер И Не Сервер Тогда
		СтруктураКлюча = Новый Структура;
	#КонецЕсли
	Для Каждого КлючИЗначение Из СтруктураКлюча Цикл
		ЭлементПорядка = ирОбщий.НайтиДобавитьЭлементНастроекКомпоновкиПоПолюЛкс(Компоновщик.Настройки.Порядок, КлючИЗначение.Ключ);
		Если ЭлементПорядка = Неопределено Тогда
			ирОбщий.СообщитьЛкс("Поле """ + КлючИЗначение.Ключ + """ ключа не найдено в доступных полях компоновки");
		КонецЕсли; 
	КонецЦикла;
	
КонецПроцедуры

Процедура ВнешнееСобытие(Источник, Событие, Данные) Экспорт
	
	ирОбщий.Форма_ВнешнееСобытиеЛкс(ЭтаФорма, Источник, Событие, Данные);

КонецПроцедуры

Процедура ТабличноеПолеПриПолученииДанных(Элемент, ОформленияСтрок) Экспорт 
	
	ирОбщий.ТабличноеПолеПриПолученииДанныхЛкс(ЭтаФорма, Элемент, ОформленияСтрок);

КонецПроцедуры

ирОбщий.ИнициализироватьФормуЛкс(ЭтаФорма, "Обработка.ирПлатформа.Форма.ГруппировкаТаблицы");
ирОбщий.ПодключитьОбработчикиСобытийДоступныхПолейКомпоновкиЛкс(ЭлементыФормы.ДоступныеПоля);
АвтовидимостьКолонокСоставаГруппы = Истина;
