﻿//ирПортативный Перем ирПортативный Экспорт;
//ирПортативный Перем ирОбщий Экспорт;
//ирПортативный Перем ирСервер Экспорт;
//ирПортативный Перем ирКэш Экспорт;
//ирПортативный Перем ирПривилегированный Экспорт;

Перем мИмяКолонкиПометки Экспорт;
Перем мИмяКолонкиРезультатаОбработки Экспорт;
Перем мИмяКолонкиПолногоИмениТаблицы Экспорт;
Перем мЗапрос Экспорт;
Перем мПлатформа Экспорт;
Перем мРезультатЗапроса Экспорт;
Перем мСхемаКолонок Экспорт;
Перем мВопросНаОбновлениеСтрокДляОбработкиЗадавался Экспорт;
Перем мСоставПланаОбмена;
Перем мИмяНастройкиПоУмолчанию Экспорт;

////////////////////////////////////////////////////////////////////////////////
// ВСПОМОГАТЕЛЬНЫЕ ПРОЦЕДУРЫ

// Разбирает строку выделяя из нее префикс и числовую часть
//
// Параметры:
//  Стр            - Строка. Разбираемая строка
//  ЧисловаяЧасть  - Число. Переменная в которую возвратится числовая часть строки
//  Режим          - Строка. Если "Число", то возвратит числовую часть иначе - префикс
//
// Возвращаемое значение:
//  Префикс строки
//              
Функция вПолучитьПрефиксЧислоНомера(Знач Стр, ЧисловаяЧасть="", Режим="") Экспорт
    
	Стр		=	СокрЛП(Стр);
	Префикс	=	Стр;
	Длина	=	СтрДлина(Стр);
	
	Для Сч = 1 По Длина Цикл
		Попытка
			ЧисловаяЧасть = Число(Стр);
		Исключение
		    Стр = Прав(Стр, Длина - Сч);
			Продолжить;
		КонецПопытки; 
		
	    Если (ЧисловаяЧасть > 0) И (СтрДлина(Формат(ЧисловаяЧасть, "ЧГ=0")) = Длина - Сч + 1) Тогда 
			Префикс	=	Лев(Префикс, Сч - 1);
			
			Пока Прав(Префикс, 1) = "0" Цикл
			    Префикс = Лев(Префикс, СтрДлина(Префикс)-1);
			КонецЦикла;
			
			Прервать;
	    Иначе
			Стр = Прав(Стр, Длина - Сч);
		КонецЕсли;
		
		Если ЧисловаяЧасть < 0 Тогда	ЧисловаяЧасть = - ЧисловаяЧасть		КонецЕсли;
			
	КонецЦикла;

	Если Режим = "Число" Тогда
	    Возврат(ЧисловаяЧасть);
	Иначе
		Возврат(Префикс);
	КонецЕсли;

КонецФункции // вПолучитьПрефиксЧислоНомера()

// Приводит номер (код) к требуемой длине. При этом выделяется префикс
// и числовая часть номера, остальное пространство между префиксом и
// номером заполняется нулями
//
// Параметры:
//  Стр            - Преобразовываемая строка
//  Длина          - Требуемая длина строки
//
// Возвращаемое значение:
//  Строка - код или номер, приведенная к требуемой длине
// 
Функция вПривестиНомерКДлине(Знач Стр, Длина) Экспорт
                            
	Стр			    =	СокрЛП(Стр);
		
	ЧисловаяЧасть	=	"";
	Результат		=	вПолучитьПрефиксЧислоНомера(Стр, ЧисловаяЧасть);
	Пока Длина - СтрДлина(Результат) - СтрДлина(Формат(ЧисловаяЧасть, "ЧГ=0")) > 0 Цикл
		Результат	=	Результат + "0";
	КонецЦикла;
	Результат	=	Результат + Формат(ЧисловаяЧасть, "ЧГ=0");
	
	Возврат(Результат);
	
КонецФункции // вПривестиНомерКДлине()

// Добавляет к префиксу номера или кода подстроку
//
// Параметры:
//  Стр            - Строка. Номер или код
//  Добавок        - Добаляемая к префиксу подстрока
//  Длина          - Требуемая результрирубщая длина строки
//  Режим          - "Слева" - подстрока добавляется слева к префиксу, иначе - справа
//
// Возвращаемое значение:
//  Строка - номер или код, к префиксу которого добавлена указанная подстрока
//                                                                                                     
Функция вДобавитьКПрефиксу(Знач Стр, Добавок="", Длина="", Режим="Слева") Экспорт

	Стр = СокрЛП(Стр);
	
	Если ПустаяСтрока(Длина) Тогда
		Длина = СтрДлина(Стр);
	КонецЕсли;
	
	ЧисловаяЧасть	=	"";
	Префикс			=	вПолучитьПрефиксЧислоНомера(Стр, ЧисловаяЧасть);
	Если Режим="Слева" Тогда
		Результат	=	СокрЛП(Добавок) + Префикс;
	Иначе
		Результат	=	Префикс + СокрЛП(Добавок);
	КонецЕсли;

	Пока Длина - СтрДлина(Результат) - СтрДлина(Формат(ЧисловаяЧасть, "ЧГ=0")) > 0 Цикл
	    Результат	=	Результат + "0";
	КонецЦикла;
	Результат	=	Результат + Формат(ЧисловаяЧасть, "ЧГ=0");
	
	Возврат(Результат);
	
КонецФункции // вДобавитьКПрефиксу()

// Дополняет строку указанным символом до указанной длины
//
// Параметры: 
//  Стр            - Дополняемая строка
//  Длина          - Требуемая длина результирующей строки
//  Чем            - Символ, которым дополняется строка
//
// Возвращаемое значение:
//  Строка дополненная указанным символом до указанной длины
//
Функция вДополнитьСтрокуСимволами(Стр="", Длина, Чем=" ") Экспорт
	Результат = СокрЛП(Стр);
	Пока Длина - СтрДлина(Результат) > 0 Цикл
		Результат	=	Результат + Чем;
	КонецЦикла;
	Возврат(Результат);
КонецФункции // вДополнитьСтрокуСимволами() 

// Выполняет обработку объектов.
//
// Параметры:
//  Нет.
//
Функция вВыполнитьГрупповуюОбработку(ПараметрыОбработки) Экспорт

	ТранзакцииРазрешены = Истина;
	Если Истина
		И ирКэш.ПараметрыЗаписиОбъектовЛкс().ОбъектыНаСервере 
		И ирКэш.ЛиПортативныйРежимЛкс()
		И Не ирПортативный.ЛиСерверныйМодульДоступенЛкс(Ложь)
		И ирПортативный.ЭмуляцияЗаписиНаСервере
	Тогда
		Сообщить("В режиме эмуляции записи на сервере транзакции не поддерживаются");
		ТранзакцииРазрешены = Ложь;
		ОбщаяТранзакция = Ложь;
	КонецЕсли; 
	Отказ = Ложь;
	ИмяМетода = ПараметрыОбработки.ИмяОбработки + "_" + "ПередОбработкойВсех";
	Если ирОбщий.МетодРеализованЛкс(ирОбщий, ИмяМетода) Тогда
		Выполнить("ирОбщий." + ИмяМетода + "(ПараметрыОбработки, Отказ)");
	КонецЕсли;
	Если Отказ Тогда
		Возврат 0;
	КонецЕсли; 
	ИмяМетода = ПараметрыОбработки.ИмяОбработки + "_" + "ОбработатьОбъект";
	Если Не ирОбщий.МетодРеализованЛкс(ирОбщий, ИмяМетода) Тогда 
		Возврат 0;
	КонецЕсли; 
	НайденныеОбъекты.ЗаполнитьЗначения("", мИмяКолонкиРезультатаОбработки);
	Если ОбщаяТранзакция Тогда
		НачатьТранзакцию();
	КонецЕсли;
	Попытка
		мСоставПланаОбмена = Неопределено;
		Если ЗначениеЗаполнено(УзелОтбораОбъектов) Тогда
			мСоставПланаОбмена = УзелОтбораОбъектов.Метаданные().Состав;
		КонецЕсли; 
		ТипТаблицы = ирОбщий.ПолучитьТипТаблицыБДЛкс(?(МноготабличнаяВыборка, ОбластьПоиска[0], ОбластьПоиска));
		СтруктураКлючаОбъектаДоп = ирОбщий.ПолучитьСтруктуруКлючаТаблицыБДЛкс(?(МноготабличнаяВыборка, ОбластьПоиска[0], ОбластьПоиска), Ложь);
		СтруктураКлючаОбъекта = ирОбщий.ПолучитьСтруктуруКлючаТаблицыБДЛкс(?(МноготабличнаяВыборка, ОбластьПоиска[0], ОбластьПоиска), Ложь);
		СтруктураКлючаСтроки = ирОбщий.ПолучитьСтруктуруКлючаТаблицыБДЛкс(?(МноготабличнаяВыборка, ОбластьПоиска[0], ОбластьПоиска), Истина);
		Если МноготабличнаяВыборка Тогда
			СтруктураКлючаОбъектаДоп.Вставить(мИмяКолонкиПолногоИмениТаблицы);
			СтруктураКлючаСтроки.Вставить(мИмяКолонкиПолногоИмениТаблицы);
		КонецЕсли;
		СтрокаКлюча = "";
		Для Каждого КлючИЗначение Из СтруктураКлючаОбъектаДоп Цикл
			Если СтрокаКлюча <> "" Тогда
				СтрокаКлюча  = СтрокаКлюча + ", ";
			КонецЕсли; 
			СтрокаКлюча = СтрокаКлюча + КлючИЗначение.Ключ;
		КонецЦикла;
		Если ДинамическаяВыборка Тогда
			Если СтруктураКлючаОбъектаДоп.Количество() > 1 Тогда
				Сообщить("Динамическая выборка по сложному ключу не поддерживается. Загрузите выборку полностью.", СтатусСообщения.Внимание);
				Возврат 0;
			КонецЕсли; 
			
			мРезультатЗапроса = мЗапрос.Выполнить();
			Если СтруктураКлючаСтроки.Количество() = СтруктураКлючаОбъектаДоп.Количество() Тогда
				ВыборкаКлючей = мРезультатЗапроса.Выбрать();
				КоличествоОбъектов = ВыборкаКлючей.Количество();
				КоличествоСтрок = КоличествоОбъектов;
				Индикатор = ирОбщий.ПолучитьИндикаторПроцессаЛкс(КоличествоОбъектов);
				Пока ВыборкаКлючей.Следующий() Цикл
					ирОбщий.ОбработатьИндикаторЛкс(Индикатор);
					СтрокиДляОбработки = НайденныеОбъекты.СкопироватьКолонки();
					ЗаполнитьЗначенияСвойств(СтрокиДляОбработки.Добавить(), ВыборкаКлючей);
					
					РезультатОбработки = ОбработатьЭлементыОбъекта(ТипТаблицы, СтруктураКлючаОбъектаДоп, СтруктураКлючаОбъекта, СтруктураКлючаСтроки, ВыборкаКлючей,
						СтрокиДляОбработки, ПараметрыОбработки, ТранзакцииРазрешены, Индикатор.Счетчик = 1, Индикатор.Счетчик = КоличествоОбъектов);
				КонецЦикла;
			Иначе
				ЗапросКлючей = Новый Запрос();
				Фрагменты = ирОбщий.ПолучитьМассивИзСтрокиСРазделителемЛкс(мЗапрос.Текст, "//Секция_Упорядочить");
				ИсключаемоеПоле = Неопределено;
				//Если СтруктураКлючаСтроки <> СтруктураКлючаОбъектаСПометкой Тогда
					ИсключаемоеПоле = ирОбщий.ПеревестиСтроку("НомерСтроки");
				//КонецЕсли; 
				СтрокаПорядка = ирОбщий.ВыражениеПорядкаКомпоновкиНаЯзыкеЛкс(Компоновщик.Настройки.Порядок, ИсключаемоеПоле);
				СтрокаПолейПорядка = "";
				Для Каждого Колонка Из мРезультатЗапроса.Колонки Цикл
					Если Ложь
						Или СтруктураКлючаОбъектаДоп.Свойство(Колонка.Имя) 
						Или ирОбщий.СтрокиРавныЛкс(ИсключаемоеПоле, Колонка.Имя)
					Тогда
						Продолжить;
					КонецЕсли; 
					СтрокаПолейПорядка = ", " + Колонка.Имя;
				КонецЦикла;
				Если ЗначениеЗаполнено(СтрокаПорядка) Тогда
					СтрокаПорядка = " УПОРЯДОЧИТЬ ПО " + СтрокаПорядка;
				КонецЕсли; 
				Если Ложь
					Или Не БезАвтоупорядочивания 
					//Или ЗначениеЗаполнено(СтрокаПорядка)
				Тогда
					СтрокаПорядка = СтрокаПорядка + "
					|АВТОУПОРЯДОЧИВАНИЕ";
				КонецЕсли; 
				ТекстЗапроса = "ВЫБРАТЬ РАЗЛИЧНЫЕ " + СтрокаКлюча + СтрокаПолейПорядка + "
				| ИЗ (" + Фрагменты[0] + ") КАК Т " + СтрокаПорядка; // Доделать имя таблицы (Т.) у полей
				ЗапросКлючей.Текст = ТекстЗапроса;
				ирОбщий.СкопироватьУниверсальнуюКоллекциюЛкс(мЗапрос.Параметры, ЗапросКлючей.Параметры);
				РезультатЗапроса = ЗапросКлючей.Выполнить();
				#Если Сервер И Не Сервер Тогда
					_Запрос = Новый Запрос;
				    ВыборкаЗапроса = _Запрос.Выполнить().Выбрать();
				#КонецЕсли
				ВыборкаКлючей = РезультатЗапроса.Выбрать();
				//Построитель = Новый ПостроительЗапроса;
				//Построитель.ИсточникДанных = Новый ОписаниеИсточникаДанных(мРезультатЗапроса);
				//Для Каждого КлючИЗначение Из СтруктураКлючаОбъекта Цикл
				//	Построитель.ИсточникДанных.Колонки[ИмяПоляСсылка].Измерение = Истина;
				//КонецЦикла; 
				//Построитель.ЗаполнитьНастройки();
				//Для Каждого КлючИЗначение Из СтруктураКлючаОбъекта Цикл
				//	Построитель.Измерения.Добавить(КлючИЗначение.Ключ);
				//КонецЦикла; 
				//ВыборкаКлючей = Построитель.Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
				ПостроительЗапросаДеталей = Новый ПостроительЗапроса();
				ПостроительЗапросаДеталей.Текст = мЗапрос.Текст;
				ПостроительЗапросаДеталей.ЗаполнитьНастройки();
				Для Каждого КлючИЗначение Из СтруктураКлючаОбъектаДоп Цикл
					ЭлементОтбора = ПостроительЗапросаДеталей.Отбор.Добавить(КлючИЗначение.Ключ);
					ЭлементОтбора.Использование = Истина;
				КонецЦикла;
				КоличествоОбъектов = ВыборкаКлючей.Количество();
				КоличествоСтрок = 0;
				Индикатор = ирОбщий.ПолучитьИндикаторПроцессаЛкс(КоличествоОбъектов, "Обработка объектов");
				ирОбщий.СкопироватьУниверсальнуюКоллекциюЛкс(мЗапрос.Параметры, ПостроительЗапросаДеталей.Параметры);
				ИндексКлюча = 0;
				Пока ВыборкаКлючей.Следующий() Цикл
					ирОбщий.ОбработатьИндикаторЛкс(Индикатор);
					Для Каждого КлючИЗначение Из СтруктураКлючаОбъектаДоп Цикл
						ПостроительЗапросаДеталей.Отбор[КлючИЗначение.Ключ].Значение = ВыборкаКлючей[КлючИЗначение.Ключ];
					КонецЦикла;
					ТаблицаРезультатаДеталей = ПостроительЗапросаДеталей.Результат.Выгрузить();
					СтрокиДляОбработки = НайденныеОбъекты.СкопироватьКолонки();
					ирОбщий.ЗагрузитьВТаблицуЗначенийЛкс(ТаблицаРезультатаДеталей, СтрокиДляОбработки);
					РезультатОбработки = ОбработатьЭлементыОбъекта(ТипТаблицы, СтруктураКлючаОбъектаДоп, СтруктураКлючаОбъекта, СтруктураКлючаСтроки, ВыборкаКлючей,
						СтрокиДляОбработки, ПараметрыОбработки, ТранзакцииРазрешены, ИндексКлюча = 0, ИндексКлюча = КоличествоОбъектов - 1);
					КоличествоСтрок = КоличествоСтрок + СтрокиДляОбработки.Количество();
					ИндексКлюча = ИндексКлюча + 1;
				КонецЦикла;
			КонецЕсли; 
		Иначе
			// Порядок обработки строк таблицы БД сохраняется только в случае, если на каждый объект БД приходится только одна строка
			КлючиДляОбработки = НайденныеОбъекты.Скопировать(Новый Структура(мИмяКолонкиПометки, Истина));
			КоличествоСтрок = КлючиДляОбработки.Количество();
			КлючиДляОбработки.Колонки.Добавить("_ПорядокСтроки");
			Для Индекс = 0 По КлючиДляОбработки.Количество() - 1 Цикл
				СтрокаТаблицы  = КлючиДляОбработки[Индекс];
				СтрокаТаблицы._ПорядокСтроки = Индекс;
			КонецЦикла;
			КлючиДляОбработки.Свернуть(СтрокаКлюча, "_ПорядокСтроки");
			КлючиДляОбработки.Сортировать("_ПорядокСтроки");
			КоличествоОбъектов = КлючиДляОбработки.Количество();
			Индикатор = ирОбщий.ПолучитьИндикаторПроцессаЛкс(КоличествоОбъектов, "Обработка объектов");
			СтруктураКлючаОбъектаДоп.Вставить(мИмяКолонкиПометки, Истина);
			
			СтрокаИндекса = СтрокаКлюча;
			СтрокаИндекса = СтрокаИндекса + ", " + мИмяКолонкиПометки;
			Если МноготабличнаяВыборка Тогда
				СтрокаИндекса = СтрокаИндекса + ", "+ мИмяКолонкиПолногоИмениТаблицы;
			КонецЕсли;
			ирОбщий.ДобавитьИндексВТаблицуЛкс(НайденныеОбъекты, СтрокаИндекса);
			
			ПроверитьДобавитьИндексВНайденныеОбъекты();
			Для ИндексКлюча = 0 По КоличествоОбъектов - 1 Цикл
				ирОбщий.ОбработатьИндикаторЛкс(Индикатор);
				СтрокаКлюча = КлючиДляОбработки[ИндексКлюча];
				ЗаполнитьЗначенияСвойств(СтруктураКлючаОбъектаДоп, СтрокаКлюча); 
				ЗаполнитьЗначенияСвойств(СтруктураКлючаОбъекта, СтрокаКлюча); 
				СтрокиДанных = НайденныеОбъекты.НайтиСтроки(СтруктураКлючаОбъектаДоп);
				СтрокиДляОбработки = НайденныеОбъекты.Скопировать(СтрокиДанных);
				РезультатОбработки = ОбработатьЭлементыОбъекта(ТипТаблицы, СтруктураКлючаОбъектаДоп, СтруктураКлючаОбъекта, СтруктураКлючаСтроки, СтрокаКлюча,
					СтрокиДляОбработки, ПараметрыОбработки, ТранзакцииРазрешены, ИндексКлюча = 0, ИндексКлюча = КоличествоОбъектов - 1);
				Для Каждого СтрокаДанных Из СтрокиДанных Цикл
					СтрокаДанных[мИмяКолонкиРезультатаОбработки] = РезультатОбработки;
				КонецЦикла; 
			КонецЦикла;
		КонецЕсли; 
		Если Истина
			И КоличествоСтрок > 0 
			И КоличествоСтрок <> КоличествоОбъектов 
		Тогда
			Сообщить("Обработано " + КоличествоСтрок + " строк");
		КонецЕсли; 
		ирОбщий.ОсвободитьИндикаторПроцессаЛкс(, Истина);
		Если ОбщаяТранзакция Тогда
			ЗафиксироватьТранзакцию();
		КонецЕсли;
	Исключение
		Если ОбщаяТранзакция Тогда
			ОтменитьТранзакцию();
		КонецЕсли; 
		ВызватьИсключение;
	КонецПопытки;
	ИмяМетода = ПараметрыОбработки.ИмяОбработки + "_" + "ПослеОбработкиВсех";
	Если ирОбщий.МетодРеализованЛкс(ирОбщий, ИмяМетода) Тогда
		Выполнить("ирОбщий." + ИмяМетода + "(ПараметрыОбработки)");
	КонецЕсли; 
	мВопросНаОбновлениеСтрокДляОбработкиЗадавался = Ложь;
	Возврат Индекс;

КонецФункции

Процедура ПроверитьДобавитьИндексВНайденныеОбъекты() Экспорт 
	
	Если НайденныеОбъекты.Индексы.Количество() = 0 Тогда
		//СтрокаИндекса = "";
		//Для Каждого ЭлементКлюча Из мСтруктураКлюча Цикл
		//	СтрокаИндекса = СтрокаИндекса + "," + ЭлементКлюча.Ключ;
		//КонецЦикла;
		//СтрокаИндекса = Сред(СтрокаИндекса, 2);
		//НайденныеОбъекты.Индексы.Добавить(СтрокаИндекса); // Закомментирвано из-за высоких расходов времени
		//СтрокаИндексаОбъекта = мИмяКолонкиПометки;
		СтрокаИндексаОбъекта = "";
		СтруктураКлючаОбъекта = ирОбщий.ПолучитьСтруктуруКлючаТаблицыБДЛкс(?(МноготабличнаяВыборка, ОбластьПоиска[0].Значение, ОбластьПоиска), Ложь);
		Для Каждого КлючИЗначение Из СтруктураКлючаОбъекта Цикл
			СтрокаИндексаОбъекта = СтрокаИндексаОбъекта + "," + КлючИЗначение.Ключ;
		КонецЦикла;
		НайденныеОбъекты.Индексы.Добавить(СтрокаИндексаОбъекта); // Для регистров с большим числом измерений тут будут высокие, но оправданные расходы
	КонецЕсли;

КонецПроцедуры

// <Описание процедуры>
//
// Параметры:
//  СтрокиДляОбработки – ТаблицаЗначений – ;
//  <Параметр2>  – <Тип.Вид> – <описание параметра>
//                 <продолжение описания параметра>.
// 
Функция ОбработатьЭлементыОбъекта(ТипТаблицы, СтруктураКлючаОбъектаСПометкой, СтруктураКлючаОбъекта, СтруктураКлючаСтроки, СтрокаКлюча, СтрокиДляОбработки, ПараметрыОбработки,
	ТранзакцииРазрешены, ЭтоПервыйОбъектБД, ЭтоПоследнийОбъектБД)

	ИмяПоляСсылка = ирОбщий.ПеревестиСтроку("Ссылка");
	ИмяПоляНомерСтроки = ирОбщий.ПеревестиСтроку("НомерСтроки");
	ИмяПоляПериод = ирОбщий.ПеревестиСтроку("Период");
	Если РежимОбходаДанных = "Строки" Тогда
		Если СтрокиДляОбработки.Колонки.Найти(ИмяПоляНомерСтроки) <> Неопределено Тогда
			СтрокиДляОбработки.Сортировать(ИмяПоляНомерСтроки + " Убыв");
		КонецЕсли; 
	КонецЕсли; 
	Если МноготабличнаяВыборка Тогда
		ПолноеИмяТаблицыСтроки = СтруктураКлючаОбъектаСПометкой[мИмяКолонкиПолногоИмениТаблицы];
	Иначе
		ПолноеИмяТаблицыСтроки = ирОбщий.ПолучитьИмяТаблицыИзМетаданныхЛкс(ОбластьПоиска);
	КонецЕсли; 
	//ЭтоРегистрБухгалтерии = ирОбщий.ЛиПолноеИмяРегистраБухгалтерииЛкс(ПолноеИмяТаблицыСтроки);
	МассивФрагментов = ирОбщий.ПолучитьМассивИзСтрокиСРазделителемЛкс(ПолноеИмяТаблицыСтроки);
	ОбъектМДЗаписи = мПлатформа.ПолучитьОбъектМДПоПолномуИмени(МассивФрагментов[0] + "." + МассивФрагментов[1]);
	ПроводитьПроведенные = Истина
		И ПроводитьПроведенныеДокументыПриЗаписи
		И ирОбщий.ЛиКорневойТипДокументаЛкс(ирОбщий.ПолучитьПервыйФрагментЛкс(ПолноеИмяТаблицыСтроки))
		И ОбъектМДЗаписи.Проведение = Метаданные.СвойстваОбъектов.Проведение.Разрешить;
	КоллекцияСтрок = Неопределено;
	ЗагрузитьСтрокиПослеОбработки = Ложь;
	ЭлементыОбъекта = Новый Массив();
	ПрименятьПообъектныеТранзакции = ПообъектныеТранзакции;
	Если Не ТранзакцииРазрешены Тогда
		ПрименятьПообъектныеТранзакции = Ложь;
		ОбщаяТранзакция = Ложь;
	КонецЕсли; 
	Если ПрименятьПообъектныеТранзакции Тогда
		НачатьТранзакцию();
	КонецЕсли; 
	Попытка
		Если Ложь
			Или ирОбщий.ЛиКорневойТипСсылочногоОбъектаБДЛкс(ТипТаблицы)
			Или ирОбщий.ЛиКорневойТипЖурналаДокументовЛкс(ТипТаблицы)
			Или ТипТаблицы = "Внешняя"
		Тогда
			Если РежимОбходаДанных = "КлючиОбъектов" Тогда
				//ОбъектДляОбработки = СтрокаКлюча[ИмяПоляСсылка];
				ОбъектДляОбработки = Новый Структура;
				ОбъектДляОбработки.Вставить("Методы", СтрокаКлюча[ИмяПоляСсылка]);
				ОбъектДляОбработки.Вставить("Данные", СтрокаКлюча[ИмяПоляСсылка]);
			Иначе
				ирОбщий.ЗаблокироватьСсылкуВТранзакцииЛкс(СтрокаКлюча[ИмяПоляСсылка], Истина);
				//ОбъектДляОбработки = СтрокаКлюча[ИмяПоляСсылка].ПолучитьОбъект();
				ОбъектДляОбработки = ирОбщий.ОбъектБДПоКлючуЛкс(ПолноеИмяТаблицыСтроки, СтрокаКлюча[ИмяПоляСсылка]);
			КонецЕсли; 
			ЭлементыОбъекта.Добавить(ОбъектДляОбработки.Данные);
		ИначеЕсли ирОбщий.ЛиКорневойТипКонстантыЛкс(ТипТаблицы) Тогда
			//ОбъектДляОбработки = Новый (СтрЗаменить(СтрокаКлюча[мИмяКолонкиПолногоИмениТаблицы], ".", "МенеджерЗначения."));
			ОбъектДляОбработки = ирОбщий.ОбъектБДПоКлючуЛкс(ПолноеИмяТаблицыСтроки);
			Если РежимОбходаДанных = "КлючиОбъектов" Тогда
				//
			Иначе
				ирОбщий.ЗаблокироватьКонстантуЛкс(ОбъектДляОбработки.Методы, Истина);
				ОбъектДляОбработки.Методы.Прочитать();
			КонецЕсли; 
			ЭлементыОбъекта.Добавить(ОбъектДляОбработки.Данные);
		ИначеЕсли ирОбщий.ЛиКорневойТипПеречисленияЛкс(ТипТаблицы) Тогда
			//ОбъектДляОбработки = СтрокаКлюча[ИмяПоляСсылка];
			ОбъектДляОбработки = Новый Структура;
			ОбъектДляОбработки.Вставить("Методы", СтрокаКлюча[ИмяПоляСсылка]);
			ОбъектДляОбработки.Вставить("Данные", СтрокаКлюча[ИмяПоляСсылка]);
			ЭлементыОбъекта.Добавить(ОбъектДляОбработки.Данные);
		ИначеЕсли ирОбщий.ЛиТипВложеннойТаблицыБДЛкс(ТипТаблицы) Тогда
			ирОбщий.ЗаблокироватьСсылкуВТранзакцииЛкс(СтрокаКлюча[ИмяПоляСсылка], Истина);
			//ОбъектДляОбработки = СтрокаКлюча[ИмяПоляСсылка].ПолучитьОбъект();
			ОбъектДляОбработки = ирОбщий.ОбъектБДПоКлючуЛкс(ОбъектМДЗаписи.ПолноеИмя(), СтрокаКлюча[ИмяПоляСсылка]);
			Если РежимОбходаДанных = "Строки" Тогда
				ИмяТЧ = ирОбщий.ПолучитьМассивИзСтрокиСРазделителемЛкс(ирОбщий.ПолучитьИмяТаблицыИзМетаданныхЛкс(ПолноеИмяТаблицыСтроки))[2];
				КоллекцияСтрок = ОбъектДляОбработки.Данные[ИмяТЧ];
				Для Каждого СтрокаДляОбработки Из СтрокиДляОбработки Цикл
					Если КоллекцияСтрок.Количество() < СтрокаДляОбработки[ИмяПоляНомерСтроки] Тогда
						ВызватьИсключение "Строка таблицы с номером " + СтрокаДляОбработки[ИмяПоляНомерСтроки] + " не найдена в объекте БД";
					КонецЕсли; 
					ЭлементыОбъекта.Добавить(КоллекцияСтрок[СтрокаДляОбработки[ИмяПоляНомерСтроки] - 1]);
				КонецЦикла;
			Иначе
				ЭлементыОбъекта.Добавить(ОбъектДляОбработки.Данные);
			КонецЕсли; 
		ИначеЕсли Ложь
			Или ирОбщий.ЛиКорневойТипРегистраБДЛкс(ТипТаблицы) 
			Или ирОбщий.ЛиКорневойТипПоследовательностиЛкс(ТипТаблицы)
		Тогда
			//ОбъектДляЗаписи = Новый (СтрЗаменить(ПолноеИмяТаблицыСтроки, ".", "НаборЗаписей."));
			//Для Каждого ЭлементОтбора Из ОбъектДляЗаписи.Отбор Цикл
			//	ЭлементОтбора.Использование = Истина;
			//	ЭлементОтбора.ВидСравнения = ВидСравнения.Равно;
			//	//ЭлементОтбора.Значение = СтруктураКлючаОбъекта[ЭлементОтбора.Имя];
			//	ЭлементОтбора.Значение = СтрокаКлюча[ЭлементОтбора.Имя];
			//КонецЦикла;
			ЗаполнитьЗначенияСвойств(СтруктураКлючаОбъекта, СтрокаКлюча); 
			ОбъектДляОбработки = ирОбщий.ОбъектБДПоКлючуЛкс(ПолноеИмяТаблицыСтроки, СтруктураКлючаОбъекта,, Ложь);
			Если РежимОбходаДанных <> "КлючиОбъектов" Тогда
				КоллекцияСтрок = ирОбщий.ПрочитатьНаборЗаписейВТаблицуЛкс(ОбъектДляОбработки.Методы, РежимБлокировкиДанных.Исключительный);
			КонецЕсли;
			Если РежимОбходаДанных = "Строки" Тогда
				СтараяКоллекцияСтрок = КоллекцияСтрок.Скопировать();
				ЗагрузитьСтрокиПослеОбработки = Истина;
				Если СтруктураКлючаСтроки.Свойство(ИмяПоляНомерСтроки) Тогда
					ИмяКлюча = ИмяПоляНомерСтроки;
					КлючСтроки = Новый Структура(ИмяКлюча);
				ИначеЕсли СтруктураКлючаСтроки.Свойство(ИмяПоляПериод) Тогда
					ИмяКлюча = ИмяПоляПериод;
					КлючСтроки = Новый Структура(ИмяКлюча);
				Иначе
					КлючСтроки = Неопределено;
				КонецЕсли; 
				Для Каждого СтрокаДляОбработки Из СтрокиДляОбработки Цикл
					Если КлючСтроки = Неопределено Тогда
						Если КоллекцияСтрок.Количество() = 0 Тогда
							ВызватьИсключение "Строка таблицы не найдена в объекте БД. Возможно она уже была удалена.";
						КонецЕсли; 
						СтрокаОбъекта = КоллекцияСтрок[0];
					Иначе
						ЗаполнитьЗначенияСвойств(КлючСтроки, СтрокаДляОбработки); 
						НайденныеСтроки = КоллекцияСтрок.НайтиСтроки(КлючСтроки);
						Если НайденныеСтроки.Количество() = 0 Тогда
							ВызватьИсключение "Строка таблицы по ключу " + КлючСтроки[ИмяКлюча] + " не найдена в объекте БД";
						КонецЕсли;
						//Если ЭтоРегистрБухгалтерии Тогда
							СтрокаОбъекта = НайденныеСтроки[0];
						//Иначе
						//	ИндексСтрокиНабора = КоллекцияСтрок.Индекс(НайденныеСтроки[0]);
						//	СтрокаОбъекта = ОбъектДляЗаписи[ИндексСтрокиНабора];
						//КонецЕсли; 
					КонецЕсли; 
					ЭлементыОбъекта.Добавить(СтрокаОбъекта);
				КонецЦикла;
			Иначе
				КоллекцияСтрок = Неопределено;
				ЭлементыОбъекта.Добавить(ОбъектДляОбработки.Данные);
			КонецЕсли; 
		Иначе
			ВызватьИсключение "Неподдерживаемый тип таблицы """ + ТипТаблицы + """";
		КонецЕсли;
		//Если РежимОбходаДанных <> "КлючиОбъектов" Тогда
		//	ирОбщий.УстановитьПараметрыЗаписиОбъектаЛкс(ОбъектДляОбработки.Методы, ОтключатьКонтрольЗаписи, БезАвторегистрацииИзменений);
		//КонецЕсли; 
		Если ОбъектДляОбработки = Неопределено Тогда
			РезультатОбработки = "Пропущен";
			Если ВыводитьСообщения Тогда
				Сообщить("Пропущен удаленный """ + СтрокаКлюча[ИмяПоляСсылка] + """");
			КонецЕсли;
		Иначе
			ТекстСообщенияОбОбработкеОбъекта = "Обработка объекта " + ирОбщий.ПолучитьXMLКлючОбъектаБДЛкс(ОбъектДляОбработки.Методы);
			Если ВыводитьСообщения Тогда
				Сообщить(ТекстСообщенияОбОбработкеОбъекта);
			КонецЕсли;
			СчетчикЭлемента = 0;
			КоличествоЭлементов = ЭлементыОбъекта.Количество();
			ПринудительнаяЗапись = Ложь;
			Для Каждого ЭлементОбъекта Из ЭлементыОбъекта Цикл
				СчетчикЭлемента = СчетчикЭлемента + 1;
				ПараметрыОбработки.Вставить("ЭтоПервыйОбъектБД", ЭтоПервыйОбъектБД);
				ПараметрыОбработки.Вставить("ЭтоПоследнийОбъектБД", ЭтоПоследнийОбъектБД);
				ПараметрыОбработки.Вставить("ЭтоПервыйЭлемент", СчетчикЭлемента = 1);
				ПараметрыОбработки.Вставить("ЭтоПоследнийЭлемент", СчетчикЭлемента = КоличествоЭлементов);
				ПараметрыОбработки.Вставить("ПринудительнаяЗапись", ПринудительнаяЗапись);
				ИмяМетода = ПараметрыОбработки.ИмяОбработки + "_" + "ОбработатьОбъект";
				Выполнить("ирОбщий." + ИмяМетода + "(ЭтотОбъект, ЭлементОбъекта, КоллекцияСтрок, ОбъектДляОбработки.Данные, ПараметрыОбработки, ОбъектДляОбработки.Методы)");
				ПринудительнаяЗапись = ПараметрыОбработки.ПринудительнаяЗапись;
			КонецЦикла;
			Если ЗагрузитьСтрокиПослеОбработки Тогда
				Если ПринудительнаяЗапись Или Не ирОбщий.ТаблицыЗначенийРавныЛкс(СтараяКоллекцияСтрок, КоллекцияСтрок) Тогда
					ОбъектДляОбработки.Методы.Загрузить(КоллекцияСтрок);
				КонецЕсли; 
			КонецЕсли; 
			Если Истина
				И РежимОбходаДанных <> "КлючиОбъектов"
				И Не ирОбщий.ЛиКорневойТипПеречисленияЛкс(ТипТаблицы)
			Тогда
				Попытка
					Модифицированность = ОбъектДляОбработки.Методы.Модифицированность() Или ПринудительнаяЗапись;
				Исключение
					// Объект мог быть удален
					Модифицированность = Ложь;
				КонецПопытки; 
				Если Модифицированность Тогда
					РежимЗаписи = Неопределено;
					Если Истина
						И ПроводитьПроведенные
						И ОбъектДляОбработки.Данные.Проведен
					Тогда
						РежимЗаписи = РежимЗаписиДокумента.Проведение;
					КонецЕсли;
					ирОбщий.ЗаписатьОбъектЛкс(ОбъектДляОбработки.Методы,, РежимЗаписи);
				КонецЕсли;
			КонецЕсли; 
			РезультатОбработки = "Успех";
			Если ВыводитьСообщения Тогда
				Сообщить(Символы.Таб + РезультатОбработки);
			КонецЕсли; 
		КонецЕсли; 
		Если ПрименятьПообъектныеТранзакции Тогда
			ЗафиксироватьТранзакцию();
		КонецЕсли; 
	Исключение
		Если ПрименятьПообъектныеТранзакции Тогда
			ОтменитьТранзакцию();
		КонецЕсли; 
		РезультатОбработки = ОписаниеОшибки();
		Если Не ВыводитьСообщения Тогда
			Сообщить(ТекстСообщенияОбОбработкеОбъекта);
		КонецЕсли; 
		Сообщить(Символы.Таб + РезультатОбработки, СтатусСообщения.Внимание);
		Если Не ПропускатьОшибки Или ОбщаяТранзакция Тогда
			ВызватьИсключение;
		КонецЕсли; 
	КонецПопытки;
	Если Истина
		И РезультатОбработки = "Успех"
		И УдалятьРегистрациюНаУзлеПослеОбработкиОбъекта 
		И ЗначениеЗаполнено(УзелОтбораОбъектов)
	Тогда 
		ОбъектМД = Метаданные.НайтиПоТипу(ирОбщий.ТипОбъектаБДЛкс(ОбъектДляОбработки.Методы));
		Если мСоставПланаОбмена.Содержит(ОбъектМД) Тогда
			ирОбщий.ПланыОбменаИзменитьРегистрациюЛкс(УзелОтбораОбъектов, ОбъектДляОбработки, Ложь);
		КонецЕсли; 
	КонецЕсли; 
	Возврат РезультатОбработки;

КонецФункции

Функция ПолучитьОписаниеТиповОбрабатываемогоЭлементаИлиОбъекта(ИскомыйОбъект, НуженТипОбъекта = Ложь, выхПолноеИмяТаблицы = "") Экспорт
	
	МассивИлиИмяТаблицыБД = Новый Массив();
	Если ИскомыйОбъект <> Неопределено Тогда
		ТипТаблицы = ИскомыйОбъект.ТипТаблицы;
		Если МноготабличнаяВыборка Тогда
			МассивИлиИмяТаблицыБД = ОбластьПоиска.ВыгрузитьЗначения();
		Иначе
			МассивИлиИмяТаблицыБД.Добавить(ОбластьПоиска);
		КонецЕсли; 
	КонецЕсли; 
	Результат = ирОбщий.ОписаниеТиповОбъектаИлиСтрокиБДПоИменамТаблицЛкс(МассивИлиИмяТаблицыБД, НуженТипОбъекта, РежимОбходаДанных, ТипТаблицы, выхПолноеИмяТаблицы);
	Возврат Результат;

КонецФункции

Функция ОбщиеПараметрыОбработки() Экспорт 
	
	Результат = Новый Структура;
	Для Каждого МетаРеквизит Из Метаданные().Реквизиты Цикл
		Результат.Вставить(МетаРеквизит.Имя, ЭтотОбъект[МетаРеквизит.Имя]);
	КонецЦикла;
	Результат.Вставить("НайденныеОбъекты", НайденныеОбъекты);
	СтруктураЗапроса = Новый Структура("Текст, Параметры");
	Если мЗапрос <> Неопределено Тогда
		ЗаполнитьЗначенияСвойств(СтруктураЗапроса, мЗапрос); 
	КонецЕсли; 
	Результат.Вставить("Запрос", СтруктураЗапроса);
	Возврат Результат;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТИРУЕМЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Процедура вЗагрузитьОбработки(ДоступныеОбработки, ВыбранныеОбработки) Экспорт

	ТаблицаОбработок = ирОбщий.ПолучитьТаблицуИзТабличногоДокументаЛкс(ПолучитьМакет("Обработки"));
	Для каждого СтрокаОбработки из ТаблицаОбработок Цикл
		МетаФорма = Метаданные().Формы[СтрокаОбработки.Имя];
		НайденнаяСтрока = ДоступныеОбработки.Строки.Найти(МетаФорма.Имя, "ИмяФормы");
		Если НайденнаяСтрока = Неопределено Тогда
			НайденнаяСтрока = ДоступныеОбработки.Строки.Добавить();
			НайденнаяСтрока.ИмяФормы  = МетаФорма.Имя;
		КонецЕсли; 
		ЗаполнитьЗначенияСвойств(НайденнаяСтрока, СтрокаОбработки); 
		НайденнаяСтрока.Групповая = Вычислить(СтрокаОбработки.Групповая);
		НайденнаяСтрока.Многотабличная = Вычислить(СтрокаОбработки.Многотабличная);
		НайденнаяСтрока.Обработка = МетаФорма.Синоним;
		ФормаОбработки = ЭтотОбъект.ПолучитьФорму(МетаФорма.Имя);
		Если ФормаОбработки.КартинкаЗаголовка.Вид <> ВидКартинки.Пустая Тогда
			НайденнаяСтрока.Картинка = ФормаОбработки.КартинкаЗаголовка;
		КонецЕсли; 
		Попытка
			ИспользоватьНастройки = ФормаОбработки.мИспользоватьНастройки;
		Исключение
			ИспользоватьНастройки = Ложь;
		КонецПопытки; 
		Если Не ИспользоватьНастройки Тогда
			НайденнаяСтрока.Строки.Очистить();
		КонецЕсли;
	КонецЦикла;

	МассивДляУдаления = Новый Массив;
	
	Для каждого ДоступнаяОбработка из ДоступныеОбработки.Строки Цикл
		Если ТаблицаОбработок.Найти(ДоступнаяОбработка.ИмяФормы, "Имя") = Неопределено Тогда
			МассивДляУдаления.Добавить(ДоступнаяОбработка);
		КонецЕсли;
	КонецЦикла;

	Для Индекс = 0 по МассивДляУдаления.Количество() - 1 Цикл
		ДоступныеОбработки.Строки.Удалить(МассивДляУдаления[Индекс]);
	КонецЦикла;

	МассивДляУдаления.Очистить();
	
	Для каждого ВыбраннаяОбработка из ВыбранныеОбработки Цикл
		Если      ВыбраннаяОбработка.СтрокаДоступнойОбработки = Неопределено Тогда
			МассивДляУдаления.Добавить(ВыбраннаяОбработка);
		Иначе
			Если ВыбраннаяОбработка.СтрокаДоступнойОбработки.Родитель = Неопределено Тогда
				Если ДоступныеОбработки.Строки.Найти(ВыбраннаяОбработка.СтрокаДоступнойОбработки.ИмяФормы, "ИмяФормы") = Неопределено Тогда
					МассивДляУдаления.Добавить(ВыбраннаяОбработка);
				КонецЕсли;
			Иначе
				Если ДоступныеОбработки.Строки.Найти(ВыбраннаяОбработка.СтрокаДоступнойОбработки.Родитель.ИмяФормы, "ИмяФормы") = Неопределено Тогда
					МассивДляУдаления.Добавить(ВыбраннаяОбработка);
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;

	ДоступныеОбработки.Строки.Сортировать("Обработка", Истина);
	Для Индекс = 0 по МассивДляУдаления.Количество() - 1 Цикл
		ВыбранныеОбработки.Удалить(МассивДляУдаления[Индекс]);
	КонецЦикла;

КонецПроцедуры // вЗагрузитьОбработки()

//////////////////////////////////////////////////////////////////////////////////
//// ОПЕРАТОРЫ ОСНОВНОЙ ПРОГРАММЫ

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

ЭтотОбъект.НастройкиКомпоновки = Новый Соответствие;
ЭтотОбъект.АвтовВыбранныеПоляИзОтбора = Истина;
//ЭтотОбъект.ВыводитьСообщения = Истина;
ЭтотОбъект.ПообъектныеТранзакции = Истина;
ЭтотОбъект.ПропускатьОшибки = Истина;
ЭтотОбъект.РежимОбходаДанных = "Строки";
ЭтотОбъект.ОбластьПоиска = "";
ЭтотОбъект.ВыполнятьНаСервере = ирОбщий.ПолучитьРежимОбъектыНаСервереПоУмолчаниюЛкс(Ложь);
мПлатформа = ирКэш.Получить();
мИмяКолонкиПометки = "_ПометкаСлужебная";
мИмяКолонкиРезультатаОбработки = "_РезультатОбработки";
мИмяКолонкиПолногоИмениТаблицы = "_ПолноеИмяТаблицы";
мВопросНаОбновлениеСтрокДляОбработкиЗадавался = Истина;
мИмяНастройкиПоУмолчанию = "Новая настройка";
