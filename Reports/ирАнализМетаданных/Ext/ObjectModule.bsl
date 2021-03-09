﻿//ирПортативный Перем ирПортативный Экспорт;
//ирПортативный Перем ирОбщий Экспорт;
//ирПортативный Перем ирСервер Экспорт;
//ирПортативный Перем ирКэш Экспорт;
//ирПортативный Перем ирПривилегированный Экспорт;

Перем РежимОтладки Экспорт;
Перем мОбъекты Экспорт;
Перем мКолонкиРасширенногоПредставления Экспорт;
Перем СтарыйТипОбъектов Экспорт;

Функция СхемаКомпоновки() Экспорт 
	
	мПлатформа = ирКэш.Получить();
	#Если Сервер И Не Сервер Тогда
		мПлатформа = Обработки.ирПлатформа.Создать();
	#КонецЕсли
	СтруктураТипаОбъекта = мПлатформа.НоваяСтруктураТипа();
	СтруктураТипаОбъекта.ИмяОбщегоТипа = ТипОбъектов;
	СвойстваЦелевогоОбъекта = мПлатформа.ПолучитьТаблицуСловСтруктурыТипа(СтруктураТипаОбъекта,,,,,, "Свойство");
	Если ТипОбъектов <> СтарыйТипОбъектов Тогда
		мОбъекты = Новый ТаблицаЗначений;
		мКолонкиРасширенногоПредставления = Новый СписокЗначений;
		мОбъекты.Колонки.Добавить("ОбъектМД");
		мОбъекты.Колонки.Добавить("ПолноеИмя");
		мОбъекты.Колонки.Добавить("ПолноеИмяРодителя");
		Для Каждого Свойство Из СвойстваЦелевогоОбъекта Цикл
			Если Ложь
				Или Свойство.Слово = "ПринадлежностьОбъекта" // Бесполезное свойство метаданных
				Или Свойство.ТипЗначения = "Неопределено"
				Или Свойство.ТипЗначения = "КоллекцияЗначенийСвойстваОбъектаМетаданных"
				Или Свойство.ТипЗначения = "ОписанияСтандартныхРеквизитов"
				Или Свойство.ТипЗначения = "ОписанияСтандартныхТабличныхЧастей"
				Или ирОбщий.ПервыйФрагментЛкс(Свойство.ТипЗначения, ":") = "КоллекцияОбъектовМетаданных"
			Тогда
				Продолжить;
			КонецЕсли; 
			Если Ложь
				Или Свойство.ТипЗначения = "Булево" 
				Или Свойство.ТипЗначения = "Число"
			Тогда
				ОписаниеТипов = Новый ОписаниеТипов("Строка," + Свойство.ТипЗначения);
			Иначе
				ОписаниеТипов = Новый ОписаниеТипов("Строка",,,, Новый КвалификаторыСтроки(300));
				Если Свойство.ТипЗначения <> "Строка" Тогда
					мКолонкиРасширенногоПредставления.Добавить(Свойство.Слово);
				КонецЕсли; 
			КонецЕсли; 
			мОбъекты.Колонки.Добавить(Свойство.Слово, ОписаниеТипов);
		КонецЦикла;
		мКолонкиРасширенногоПредставления.СортироватьПоЗначению();
		мКолонкиРасширенногоПредставления = мКолонкиРасширенногоПредставления.ВыгрузитьЗначения();
	КонецЕсли; 
	Схема = ирОбщий.СоздатьСхемуПоТаблицамЗначенийЛкс(Новый Структура("Объекты", мОбъекты));
	#Если Сервер И Не Сервер Тогда
		Схема = Новый СхемаКомпоновкиДанных;
	#КонецЕсли
	Для Каждого ПолеНабора Из Схема.НаборыДанных[0].Поля Цикл
		СтрокаСлова = СвойстваЦелевогоОбъекта.Найти(ПолеНабора.Поле, "Слово");
		Если СтрокаСлова = Неопределено Тогда
			Продолжить;
		КонецЕсли; 
		СписокЗначений = мПлатформа.ДоступныеЗначенияТипа(СтрокаСлова.ТипЗначения);
		Если СписокЗначений = Неопределено Тогда
			Продолжить;
		КонецЕсли; 
		// Иначе в табличный документ выводятся пустые строки - баг платформы https://www.hostedredmine.com/issues/918193
		Для Каждого ЭлементСписка Из СписокЗначений Цикл
			ЭлементСписка.Представление = ЭлементСписка.Значение;
		КонецЦикла;
		ПолеНабора.УстановитьДоступныеЗначения(СписокЗначений);
	КонецЦикла;
	Возврат Схема;
	
КонецФункции

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	СхемаКомпоновкиДанных = СхемаКомпоновки();
	СтандартнаяОбработка = Ложь;
	#Если _ Тогда
		СхемаКомпоновкиДанных = Новый СхемаКомпоновкиДанных;
		КонечнаяНастройка = Новый НастройкиКомпоновкиДанных;
		ВнешниеНаборыДанных = Новый Структура;
		ДокументРезультат = Новый ТабличныйДокумент;
		мПлатформа = Обработки.ирПлатформа.Создать();
	#КонецЕсли
	КонечнаяНастройка = КомпоновщикНастроек.ПолучитьНастройки();
	ВнешниеНаборыДанных = Новый Структура("Объекты", мОбъекты);
	Если РежимОтладки = 2 Тогда
		ирОбщий.ОтладитьЛкс(СхемаКомпоновкиДанных, , КонечнаяНастройка, ВнешниеНаборыДанных);
		Возврат;
	КонецЕсли; 
	ДокументРезультат.Очистить();
	ирОбщий.СкомпоноватьВТабличныйДокументЛкс(СхемаКомпоновкиДанных, КонечнаяНастройка, ДокументРезультат, ВнешниеНаборыДанных, ДанныеРасшифровки);
	
КонецПроцедуры

Функция ЭтоКорневойТипМетаданныхЛкс(ИмяОбщегоТипа) Экспорт 
	мПлатформа = ирКэш.Получить();
	#Если Сервер И Не Сервер Тогда
		мПлатформа = Обработки.ирПлатформа.Создать();
	#КонецЕсли
	мПлатформа.ИнициализацияОписанияМетодовИСвойств();
	СтрокаТипаКоллекции = мПлатформа.ТаблицаОбщихТипов.НайтиСтроки(Новый Структура("ЯзыкПрограммы, ТипЭлементаКоллекции", 0, ИмяОбщегоТипа));
	СтрокаТипаКоллекции = СтрокаТипаКоллекции[0];
	Найденные = мПлатформа.ТаблицаКонтекстов.НайтиСтроки(Новый Структура("ЯзыкПрограммы, ТипЗначения, ТипСлова", 0, СтрокаТипаКоллекции.Слово, "Свойство"));
	Результат = Истина;
	Для Каждого СтрокаКонтекста Из Найденные Цикл
		Если СтрокаКонтекста.ТипКонтекста <> "ОбъектМетаданныхКонфигурация" Тогда
			Результат = Ложь;
			Прервать;
		КонецЕсли; 
	КонецЦикла;
	Возврат Результат;
КонецФункции

// Параметры:
// Результат:
//     Булево - были ли подходящие коллекции
Функция СобратьОбъектыМетаданных(СтруктураТипа = Неопределено, Знач ЛиЦелевойТипКорневой = Неопределено, Знач ПолноеИмяРодителя = Неопределено, Знач ЗащитаРекурсия = Неопределено, Знач СвойстваРекурсия = Неопределено) Экспорт 
	
	мПлатформа = ирКэш.Получить();
	#Если Сервер И Не Сервер Тогда
		мПлатформа = Обработки.ирПлатформа.Создать();
		мОбъекты = Новый ТаблицаЗначений;
	#КонецЕсли
	Если СтруктураТипа = Неопределено Тогда
		СтруктураТипа = мПлатформа.СтруктураТипаИзЗначения(Метаданные);
		ЛиЦелевойТипКорневой = ЭтоКорневойТипМетаданныхЛкс(ТипОбъектов);
		мОбъекты.Очистить();
	КонецЕсли; 
	ТаблицаОбщихТипов = мПлатформа.ТаблицаОбщихТипов;
	Если ЗащитаРекурсия = Неопределено Тогда
		ЗащитаРекурсия = Новый Соответствие;
	КонецЕсли; 
	Если СвойстваРекурсия = Неопределено Тогда
		СвойстваРекурсия = Новый Соответствие;
	КонецЕсли; 
	Свойства = СвойстваРекурсия[СтруктураТипа.ИмяОбщегоТипа];
	Если Свойства = Неопределено Тогда 
		СвойстваВсе = мПлатформа.ПолучитьТаблицуСловСтруктурыТипа(СтруктураТипа,,,, Ложь,, "Свойство");
		Свойства = Новый Структура;
		Для Каждого Свойство Из СвойстваВсе Цикл
			Если Свойство.Слово = "Состав" Тогда
				Продолжить;
			КонецЕсли; 
			СтрокаТипаЗначения = ТаблицаОбщихТипов.НайтиСтроки(Новый Структура("ЯзыкПрограммы, Слово", 0, Свойство.ТипЗначения));
			Если СтрокаТипаЗначения.Количество() = 0 Тогда
				Продолжить;
			КонецЕсли;
			Свойства.Вставить(Свойство.Слово, СтрокаТипаЗначения[0].ТипЭлементаКоллекции);
		КонецЦикла;
		СвойстваРекурсия[СтруктураТипа.ИмяОбщегоТипа] = Свойства;
	КонецЕсли; 
	Если ПолноеИмяРодителя = Неопределено Тогда
		ИндикаторСвойств = ирОбщий.ПолучитьИндикаторПроцессаЛкс(Свойства.Количество());
	КонецЕсли; 
	ЛиБылиПодходящиеКоллекции = Ложь;
	Для Каждого Свойство Из Свойства Цикл
		Если ИндикаторСвойств <> Неопределено Тогда
			ирОбщий.ОбработатьИндикаторЛкс(ИндикаторСвойств);
		КонецЕсли;
		ТипЭлементаКоллекции = Свойство.Значение;
		ИмяСвойства = Свойство.Ключ;
		Если Истина
			И ЗначениеЗаполнено(ТипЭлементаКоллекции)
			И Найти(ТипЭлементаКоллекции, ",") = 0
		Тогда
			Если ТипЭлементаКоллекции = ТипОбъектов Тогда
				ЛиБылиПодходящиеКоллекции = Истина;
			КонецЕсли; 
			Попытка
				КоллекцияВСвойстве = СтруктураТипа.Метаданные[ИмяСвойства];
			Исключение
				Продолжить;
			КонецПопытки;
			Если КоллекцияВСвойстве = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			ИндикаторКоллекции = Неопределено;
			Если ПолноеИмяРодителя = Неопределено Тогда
				ИндикаторКоллекции = ирОбщий.ПолучитьИндикаторПроцессаЛкс(КоллекцияВСвойстве.Количество(), ИмяСвойства);
			КонецЕсли; 
			СтруктураТипаОбъекта = Неопределено;
			Для Каждого ОбъектМД Из КоллекцияВСвойстве Цикл
				#Если Сервер И Не Сервер Тогда
					ОбъектМД = Метаданные.Справочники.ирАлгоритмы;
				#КонецЕсли
				Если ИндикаторКоллекции <> Неопределено Тогда
					ирОбщий.ОбработатьИндикаторЛкс(ИндикаторКоллекции);
				КонецЕсли;
				ПолноеИмяМД = "";
				Попытка
					ПолноеИмяМД = ОбъектМД.ПолноеИмя();
				Исключение
					// Пакет XDTO
					// Описание стандартного реквизита
					Попытка
						ИмяОбъекта = ОбъектМД.Имя;
					Исключение
						ИмяОбъекта = "";
					КонецПопытки; 
					Если ЗначениеЗаполнено(ИмяОбъекта) Тогда
						ПолноеИмяМД = ПолноеИмяРодителя + "." + ирОбщий.ПоследнийФрагментЛкс(ТипЭлементаКоллекции, " ") + "." + ОбъектМД.Имя;
					КонецЕсли; 
				КонецПопытки; 
				Если ТипЭлементаКоллекции = ТипОбъектов Тогда
					СтрокаНайденного = мОбъекты.Добавить();
					ЗаполнитьЗначенияСвойств(СтрокаНайденного, ОбъектМД); 
					Если РасширенныеПредставления Тогда
						Для Каждого ИмяКолонкиРезультата Из мКолонкиРасширенногоПредставления Цикл
							Попытка
								ЗначениеСвойства = ОбъектМД[ИмяКолонкиРезультата];
							Исключение
								// Измерение последовательности
								Продолжить;
							КонецПопытки; 
							СтрокаНайденного[ИмяКолонкиРезультата] = ирОбщий.РасширенноеПредставлениеЗначенияЛкс(ЗначениеСвойства);
						КонецЦикла; 
					КонецЕсли; 
					СтрокаНайденного.ОбъектМД = ОбъектМД;
					СтрокаНайденного.ПолноеИмя = ПолноеИмяМД;
					СтрокаНайденного.ПолноеИмяРодителя = ПолноеИмяРодителя;
				КонецЕсли; 
				Если ЗначениеЗаполнено(ПолноеИмяМД) Тогда
					Если ЗащитаРекурсия[ПолноеИмяМД ] = 1 Тогда
						Продолжить;
					КонецЕсли; 
					ЗащитаРекурсия[ПолноеИмяМД] = 1;
				КонецЕсли; 
				Если СтруктураТипаОбъекта = Неопределено Тогда
					СтруктураТипаОбъекта = мПлатформа.НоваяСтруктураТипа();
					СтруктураТипаОбъекта.ИмяОбщегоТипа = ТипЭлементаКоллекции;
				КонецЕсли; 
				СтруктураТипаОбъекта.Метаданные = ОбъектМД;
				Если Не ЛиЦелевойТипКорневой Тогда
					ЛиБылиПодходящиеКоллекцииСнизу = СобратьОбъектыМетаданных(СтруктураТипаОбъекта, ЛиЦелевойТипКорневой, ПолноеИмяМД, ЗащитаРекурсия, СвойстваРекурсия);
					Если ЛиБылиПодходящиеКоллекцииСнизу Тогда
						ЛиБылиПодходящиеКоллекции = Истина;
					КонецЕсли; 
					Если Не ЛиБылиПодходящиеКоллекции Тогда
						Прервать;
					КонецЕсли; 
				КонецЕсли; 
			КонецЦикла;
			Если ИндикаторКоллекции <> Неопределено Тогда
				ирОбщий.ОсвободитьИндикаторПроцессаЛкс();
			КонецЕсли; 
		КонецЕсли;
	КонецЦикла;
	Если ИндикаторСвойств <> Неопределено Тогда
		ирОбщий.ОсвободитьИндикаторПроцессаЛкс();
	КонецЕсли; 
	Возврат ЛиБылиПодходящиеКоллекции;
	
КонецФункции

//ирПортативный лФайл = Новый Файл(ИспользуемоеИмяФайла);
//ирПортативный ПолноеИмяФайлаБазовогоМодуля = Лев(лФайл.Путь, СтрДлина(лФайл.Путь) - СтрДлина("Модули\")) + "ирПортативный.epf";
//ирПортативный #Если Клиент Тогда
//ирПортативный 	Контейнер = Новый Структура();
//ирПортативный 	Оповестить("ирПолучитьБазовуюФорму", Контейнер);
//ирПортативный 	Если Не Контейнер.Свойство("ирПортативный", ирПортативный) Тогда
//ирПортативный 		ирПортативный = ВнешниеОбработки.ПолучитьФорму(ПолноеИмяФайлаБазовогоМодуля);
//ирПортативный 		ирПортативный.Открыть();
//ирПортативный 	КонецЕсли; 
//ирПортативный #Иначе
//ирПортативный 	ирПортативный = ВнешниеОбработки.Создать(ПолноеИмяФайлаБазовогоМодуля, Ложь); // Это будет второй экземпляр объекта
//ирПортативный #КонецЕсли
//ирПортативный ирОбщий = ирПортативный.ПолучитьОбщийМодульЛкс("ирОбщий");
//ирПортативный ирКэш = ирПортативный.ПолучитьОбщийМодульЛкс("ирКэш");
//ирПортативный ирСервер = ирПортативный.ПолучитьОбщийМодульЛкс("ирСервер");
//ирПортативный ирПривилегированный = ирПортативный.ПолучитьОбщийМодульЛкс("ирПривилегированный");

РежимОтладки = 0;
ТипОбъектов = "ОбъектМетаданных: Измерение";