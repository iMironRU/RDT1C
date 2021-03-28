﻿//ирПортативный Перем ирПортативный Экспорт;
//ирПортативный Перем ирОбщий Экспорт;
//ирПортативный Перем ирСервер Экспорт;
//ирПортативный Перем ирКэш Экспорт;
//ирПортативный Перем ирПривилегированный Экспорт;

Перем РежимОтладки Экспорт;
Перем ТаблицаПрав Экспорт; 
Перем Роли Экспорт; 

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	#Если _ Тогда
		СхемаКомпоновки = Новый СхемаКомпоновкиДанных;
		КонечнаяНастройка = Новый НастройкиКомпоновкиДанных;
		ВнешниеНаборыДанных = Новый Структура;
		ДокументРезультат = Новый ТабличныйДокумент;
	#КонецЕсли
	СтандартнаяОбработка = Ложь;
	ПрофилиГруппДоступа = Новый ТаблицаЗначений;
	ПрофилиГруппДоступа.Колонки.Добавить("РольИмя", Новый ОписаниеТипов("Строка"));
	ПрофилиГруппДоступа.Колонки.Добавить("ПрофильГруппДоступа", Новый ОписаниеТипов("Строка"));
	ПрофилиГруппДоступа.Колонки.Добавить("КоличествоРолей", Новый ОписаниеТипов("Число"));
	Если ирКэш.НомерВерсииБСПЛкс() >= 200 Тогда
		Запрос = Новый Запрос;
		Запрос.Текст =
		"
		|ВЫБРАТЬ
		|	ПрофилиГруппДоступаРоли.Ссылка КАК ПрофильГруппДоступа,
		|	Профили.КоличествоРолей КАК КоличествоРолей,
		|	ПрофилиГруппДоступаРоли.Роль.Имя КАК РольИмя
		|ИЗ
		|	Справочник.ПрофилиГруппДоступа.Роли КАК ПрофилиГруппДоступаРоли
		|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
		|			ПрофилиГруппДоступа_РолиТ.Ссылка КАК Ссылка,
		|			КОЛИЧЕСТВО(ПрофилиГруппДоступа_РолиТ.Роль) КАК КоличествоРолей
		|		ИЗ
		|			Справочник.ПрофилиГруппДоступа.Роли КАК ПрофилиГруппДоступа_РолиТ
		|		
		|		СГРУППИРОВАТЬ ПО
		|			ПрофилиГруппДоступа_РолиТ.Ссылка) КАК Профили
		|		ПО Профили.Ссылка = ПрофилиГруппДоступаРоли.Ссылка
		|";
		ПрофилиГруппДоступа = Запрос.Выполнить().Выгрузить();
	КонецЕсли; 
	РолиПользователей = Новый ТаблицаЗначений;
	РолиПользователей.Колонки.Добавить("Роль", Новый ОписаниеТипов("Строка"));
	РолиПользователей.Колонки.Добавить("Пользователь", Новый ОписаниеТипов("Строка"));
	Если ПравоДоступа("Администрирование", Метаданные) Тогда
		ДоступныеПользователи = ПользователиИнформационнойБазы.ПолучитьПользователей();
	Иначе
		ДоступныеПользователи = Новый Массив;
		ДоступныеПользователи.Добавить(ПользователиИнформационнойБазы.ТекущийПользователь());
	КонецЕсли; 
	Для Каждого ПользовательИБ Из ДоступныеПользователи Цикл
		#Если Сервер И Не Сервер Тогда
			ПользовательИБ = ПользователиИнформационнойБазы.СоздатьПользователя();
		#КонецЕсли
		Для Каждого РольЦикл Из ПользовательИБ.Роли Цикл
			СтрокаРоли = РолиПользователей.Добавить();
			СтрокаРоли.Роль = РольЦикл.Имя;
			СтрокаРоли.Пользователь = ПользовательИБ.Имя;
		КонецЦикла;
	КонецЦикла;
	ТаблицаРоли = Новый ТаблицаЗначений;
	ТаблицаРоли.Колонки.Добавить("Роль", Новый ОписаниеТипов("Строка"));
	ТаблицаРоли.Колонки.Добавить("УстанавливатьПраваДляНовыхОбъектов");
	ТаблицаРоли.Колонки.Добавить("НезависимыеПраваПодчиненныхОбъектов");
	ТаблицаРоли.Колонки.Добавить("УстанавливатьПраваДляРеквизитовИТабличныхЧастейПоУмолчанию");
	Если ИзвлечьСвойстваРолей Тогда
		мПлатформа = ирКэш.Получить();
		#Если Сервер И Не Сервер Тогда
			мПлатформа = Обработки.ирПлатформа.Создать();
		#КонецЕсли
		Для Каждого МетаРоль Из Роли Цикл
			ФайлРоли = Новый Файл("" + мПлатформа.СтруктураПодкаталоговФайловогоКэша.КэшРолей.ПолноеИмя + "\Роль." + МетаРоль.Имя + ".Права.xml");
			Если Не ФайлРоли.Существует() Тогда
				Сообщить("В кэше ролей не обнаружен файл роли """ + МетаРоль.Имя + """. Для извлечения свойств этой роли необходимо обновить кэш ролей.");
				Продолжить;
			КонецЕсли; 
			СтрокаРоли = ТаблицаРоли.Добавить();
			СтрокаРоли.Роль = МетаРоль.Имя;
			ЧтениеXML = Новый ЧтениеXML;
			ЧтениеXML.ОткрытьФайл(ФайлРоли.ПолноеИмя);
			ЧтениеXML.Прочитать();
			Для Счетчик = 1 По 3 Цикл
				ЧтениеXML.Прочитать();
				Если ЧтениеXML.ТипУзла = ТипУзлаXML.НачалоЭлемента Тогда
					Если ЧтениеXML.ЛокальноеИмя = "setForNewObjects" Тогда
						ЧтениеXML.Прочитать();
						СтрокаРоли.УстанавливатьПраваДляНовыхОбъектов = Булево(ЧтениеXML.Значение);
					ИначеЕсли ЧтениеXML.ЛокальноеИмя = "setForAttributesByDefault" Тогда
						ЧтениеXML.Прочитать();
						СтрокаРоли.НезависимыеПраваПодчиненныхОбъектов = Булево(ЧтениеXML.Значение);
					ИначеЕсли ЧтениеXML.ЛокальноеИмя = "independentRightsOfChildObjects" Тогда
						ЧтениеXML.Прочитать();
						СтрокаРоли.УстанавливатьПраваДляРеквизитовИТабличныхЧастейПоУмолчанию = Булево(ЧтениеXML.Значение);
					КонецЕсли; 
					ЧтениеXML.Прочитать();
				КонецЕсли; 
			КонецЦикла;
		КонецЦикла;
	КонецЕсли; 
	Если ВычислятьФункциональныеОпции Тогда
		ФункциональныеОпции.Очистить();
		Для Каждого ФункциональнаяОпция Из Метаданные.ФункциональныеОпции Цикл
			Попытка
				ЗначениеОпции = ПолучитьФункциональнуюОпцию(ФункциональнаяОпция.Имя);
			Исключение
				// Опция с параметрами
				Продолжить;
			КонецПопытки; 
			СтрокаТаблицы = ФункциональныеОпции.Добавить();
			СтрокаТаблицы.ФункциональнаяОпция = ФункциональнаяОпция.Имя;
			СтрокаТаблицы.ФункциональнаяОпцияВключена = ЗначениеОпции;
		КонецЦикла;
	КонецЕсли; 
	КонечнаяНастройка = КомпоновщикНастроек.ПолучитьНастройки();
	Если ЗначениеЗаполнено(Пользователь) Тогда
		ирОбщий.НайтиДобавитьЭлементОтбораКомпоновкиЛкс(КонечнаяНастройка, "Пользователь", Пользователь,,, Ложь);
	КонецЕсли; 
	Если ЗначениеЗаполнено(ОбъектМетаданных) Тогда
		ирОбщий.НайтиДобавитьЭлементОтбораКомпоновкиЛкс(КонечнаяНастройка, "ОбъектМетаданных", ОбъектМетаданных,,, Ложь);
	КонецЕсли; 
	Если ЗначениеЗаполнено(Роль) Тогда
		ирОбщий.НайтиДобавитьЭлементОтбораКомпоновкиЛкс(КонечнаяНастройка, "Роль", Роль,,, Ложь);
	КонецЕсли; 
	ВнешниеНаборыДанных = Новый Структура;
	ВнешниеНаборыДанных.Вставить("ПрофилиГруппДоступа", ПрофилиГруппДоступа);
	ВнешниеНаборыДанных.Вставить("РолиПользователей", РолиПользователей);
	ВнешниеНаборыДанных.Вставить("Роли", ТаблицаРоли);
	ВнешниеНаборыДанных.Вставить("Таблица", ТаблицаПрав);
	ВнешниеНаборыДанных.Вставить("ФункциональныеОпции", ФункциональныеОпции);
	ВнешниеНаборыДанных.Вставить("ФункциональныеОпцииПолей", ФункциональныеОпцииПолей);
	Если РежимОтладки = 2 Тогда
		ирОбщий.ОтладитьЛкс(СхемаКомпоновкиДанных, , КонечнаяНастройка, ВнешниеНаборыДанных);
		Возврат;
	КонецЕсли; 
	ДокументРезультат.Очистить();
	ирОбщий.СкомпоноватьВТабличныйДокументЛкс(СхемаКомпоновкиДанных, КонечнаяНастройка, ДокументРезультат, ВнешниеНаборыДанных, ДанныеРасшифровки);
	
КонецПроцедуры

Процедура ВычислитьПрава(ИменаРолей) Экспорт 
	Роли = Новый Массив;
	Для Каждого ИмяРоли Из ИменаРолей Цикл
		Роли.Добавить(Метаданные.Роли[ИмяРоли]);
	КонецЦикла;
	ТаблицаПрав = Новый ТаблицаЗначений;
	ТаблицаПрав.Колонки.Добавить("ТипМетаданных", Новый ОписаниеТипов("Строка"));
	ТаблицаПрав.Колонки.Добавить("ОбъектМетаданных", Новый ОписаниеТипов("Строка"));
	ТаблицаПрав.Колонки.Добавить("ОбъектМетаданныхПредставление", Новый ОписаниеТипов("Строка"));
	ТаблицаПрав.Колонки.Добавить("ОбъектМД"); // Удалим перед возвращением результата
	ТаблицаПрав.Колонки.Добавить("Поле", Новый ОписаниеТипов("Строка"));
	ТаблицаПрав.Колонки.Добавить("ПолеПолноеИмя", Новый ОписаниеТипов("Строка"));
	ТаблицаПрав.Колонки.Добавить("ТабличнаяЧасть", Новый ОписаниеТипов("Строка"));
	ТаблицаПрав.Колонки.Добавить("Роль", Новый ОписаниеТипов("Строка"));
	ТаблицаПрав.Колонки.Добавить("Право", Новый ОписаниеТипов("Строка"));
	ТаблицаПрав.Колонки.Добавить("Доступ", Новый ОписаниеТипов("Строка"));
	МассивПрав = Новый Структура;
	МассивПрав.Вставить("Чтение", "1.Чтение");
	МассивПрав.Вставить("Просмотр", "2.Просмотр");
	МассивПрав.Вставить("Добавление", "3.Добавление");
	МассивПрав.Вставить("ИнтерактивноеДобавление", "4.Интерактивное Добавление");
	МассивПрав.Вставить("Изменение", "5.Изменение");
	МассивПрав.Вставить("Редактирование", "6.Интерактивное изменение");
	МассивПрав.Вставить("Удаление", "7.Удаление");
	МассивПрав.Вставить("ИнтерактивноеУдаление", "8.Интерактивное Удаление");
	МассивПрав.Вставить("Использование", "9.Использование");
	ПраваСсылочные = Новый Структура;
	ПраваСсылочные.Вставить("Чтение");
	ПраваСсылочные.Вставить("Просмотр");
	ПраваСсылочные.Вставить("Добавление");
	ПраваСсылочные.Вставить("ИнтерактивноеДобавление");
	ПраваСсылочные.Вставить("Изменение");
	ПраваСсылочные.Вставить("Редактирование");
	ПраваСсылочные.Вставить("Удаление");
	ПраваСсылочные.Вставить("ИнтерактивноеУдаление");
	ПраваРегистры = Новый Структура;
	ПраваРегистры.Вставить("Чтение");
	ПраваРегистры.Вставить("Просмотр");
	ПраваРегистры.Вставить("Изменение");
	ПраваРегистры.Вставить("Редактирование");
	ПраваПоследовательность = Новый Структура;
	ПраваПоследовательность.Вставить("Чтение");
	ПраваПоследовательность.Вставить("Изменение");
	ПраваЖурналы = Новый Структура;
	ПраваЖурналы.Вставить("Чтение");
	ПраваЖурналы.Вставить("Просмотр");
	ПраваНехранимые = Новый Структура;
	ПраваНехранимые.Вставить("Использование");
	ПраваНехранимые.Вставить("Просмотр");
	мПлатформа = ирКэш.Получить();
	#Если Сервер И Не Сервер Тогда
		мПлатформа = Обработки.ирПлатформа.Создать();
	#КонецЕсли
	ТипыМетаданных = ирКэш.ТипыМетаОбъектов(Истина, Ложь, Ложь);
	СтрокаТипаВнешнегоИсточникаДанных = мПлатформа.ПолучитьСтрокуТипаМетаОбъектов("ВнешнийИсточникДанных");
	КоллекцияКорневыхТипов = Новый Массив;
	Для Каждого СтрокаТипаМетаданных Из ТипыМетаданных Цикл
		КоллекцияКорневыхТипов.Добавить(СтрокаТипаМетаданных.Единственное);
	КонецЦикла; 
	Если ирКэш.НомерРежимаСовместимостиЛкс() >= 802013 Тогда
		Для Каждого МетаВнешнийИсточникДанных Из Метаданные.ВнешниеИсточникиДанных Цикл
			КоллекцияКорневыхТипов.Добавить(МетаВнешнийИсточникДанных.ПолноеИмя());
		КонецЦикла; 
	КонецЕсли; 
	ИндикаторТиповМетаданных = ирОбщий.ПолучитьИндикаторПроцессаЛкс(КоллекцияКорневыхТипов.Количество(), "Объекты. Типы метаданных");
	Для Каждого КорневойТип Из КоллекцияКорневыхТипов Цикл
		ирОбщий.ОбработатьИндикаторЛкс(ИндикаторТиповМетаданных);
		СтрокаТипаМетаданных = мПлатформа.ПолучитьСтрокуТипаМетаОбъектов(КорневойТип);
		Если СтрокаТипаМетаданных = Неопределено Тогда
			СтрокаТипаМетаданных = СтрокаТипаВнешнегоИсточникаДанных;
			ОбъектМДКорневогоТипа = ирКэш.ОбъектМДПоПолномуИмениЛкс(КорневойТип);
			КоллекцияМетаОбъектов = ОбъектМДКорневогоТипа.Таблицы;
			ЕстьДоступ = ПравоДоступа("Использование", ОбъектМДКорневогоТипа);
			ЛиКорневойТипСсылочный = Истина;
			ЛиКорневойТипРегистра = Истина;
			ЛиКорневойТипНехранимый = Ложь;
			ЛиКорневойТипЖурнала = Ложь;
		Иначе
			Попытка
				КоллекцияМетаОбъектов = Метаданные[СтрокаТипаМетаданных.Множественное];
			Исключение
				Продолжить;
			КонецПопытки;
			Если Ложь
				Или ирОбщий.ЛиКорневойТипПеречисленияЛкс(КорневойТип) 
				Или ирОбщий.ЛиКорневойТипВнешнегоИсточникаДанныхЛкс(КорневойТип)
			Тогда
				Продолжить;
			КонецЕсли; 
			ЛиКорневойТипСсылочный = ирОбщий.ЛиКорневойТипСсылкиЛкс(КорневойТип);
			ЛиКорневойТипРегистра = ирОбщий.ЛиКорневойТипРегистраБДЛкс(КорневойТип);
			ЛиКорневойТипПоследовательности = ирОбщий.ЛиКорневойТипПоследовательностиЛкс(КорневойТип);
			ЛиКорневойТипЖурнала = ирОбщий.ЛиКорневойТипЖурналаДокументовЛкс(КорневойТип);
			ЛиКорневойТипНехранимый = Не ЛиКорневойТипСсылочный И Не ЛиКорневойТипРегистра И Не ЛиКорневойТипЖурнала;
			Если Истина
				И ЛиКорневойТипНехранимый
				//И ТипМетаданныхИмяЕдинственное <> "HttpСервис"
				//И ТипМетаданныхИмяЕдинственное <> "WebСервис"
				И КорневойТип <> "Интерфейс"
				И КорневойТип <> "КритерийОтбора"
				И КорневойТип <> "Отчет"
				И КорневойТип <> "Обработка"
				И КорневойТип <> "ОбщаяКоманда"
				И КорневойТип <> "ОбщаяФорма"
				И КорневойТип <> "ОбщийРеквизит"
				И КорневойТип <> "ПараметрСеанса"
			Тогда
				Продолжить;
			КонецЕсли;
			ЕстьДоступ = Истина;
		КонецЕсли; 
		Если ЗначениеЗаполнено(ПолеОбъекта) Тогда
			ИмяПоляТипаМетаданных = ПолеОбъекта;
		ИначеЕсли ЛиКорневойТипСсылочный Или ЛиКорневойТипЖурнала Тогда
			ИмяПоляТипаМетаданных = "Ссылка";
		ИначеЕсли ЛиКорневойТипРегистра Тогда
			ИмяПоляТипаМетаданных = "Период";
		Иначе
			ИмяПоляТипаМетаданных = Неопределено;
		КонецЕсли; 
		ИндикаторОбъектов = ирОбщий.ПолучитьИндикаторПроцессаЛкс(КоллекцияМетаОбъектов.Количество(), СтрокаТипаМетаданных.Множественное);
		Для Каждого МетаОбъект Из КоллекцияМетаОбъектов Цикл
			#Если Сервер И Не Сервер Тогда
				МетаОбъект = Метаданные.Обработки.ирАнализЖурналаРегистрации;
			#КонецЕсли
			Если СтрокаТипаМетаданных = СтрокаТипаВнешнегоИсточникаДанных Тогда
				ЛиКорневойТипСсылочный = ирОбщий.ЛиМетаданныеСсылочногоОбъектаЛкс(МетаОбъект);
				ЛиКорневойТипРегистра = Не ЛиКорневойТипСсылочный;
			КонецЕсли; 
			ирОбщий.ОбработатьИндикаторЛкс(ИндикаторОбъектов);
			ПолноеИмяОбъектаМД = МетаОбъект.ПолноеИмя();
			ТабличныеЧасти = Новый Массив;
			Если Истина
				И Не ИспользоватьНаборПолей
				И ЗначениеЗаполнено(ОбъектМетаданных) 
			Тогда
				Если ОбъектМетаданных <> ПолноеИмяОбъектаМД Тогда
					Продолжить;
				КонецЕсли;
				Если Не ЗначениеЗаполнено(ПолеОбъекта) Тогда
					СтруктураТабличныхЧастей = ирОбщий.ТабличныеЧастиОбъектаЛкс(МетаОбъект);
					#Если Сервер И Не Сервер Тогда
						СтруктураТабличныхЧастей = Новый Структура;
					#КонецЕсли
					Для Каждого КлючИЗначение Из СтруктураТабличныхЧастей Цикл
						ТабличныеЧасти.Добавить(КлючИЗначение.Ключ);
					КонецЦикла;
				КонецЕсли; 
			ИначеЕсли ИспользоватьНаборПолей Тогда
				ТабличныеЧасти = НаборПолейТаблица.Выгрузить(Новый Структура("ОбъектМДПолноеИмя", ПолноеИмяОбъектаМД)).ВыгрузитьКолонку("ТабличнаяЧасть");
				Если ТабличныеЧасти.Количество() = 0 Тогда
					Продолжить;
				КонецЕсли; 
			КонецЕсли;
			ТабличныеЧасти.Добавить("");
			Для Каждого ИмяТЧ Из ТабличныеЧасти Цикл
				ТЧ_МД = МетаОбъект;
				ПолноеИмяТЧ_МД = ПолноеИмяОбъектаМД;
				Если ЗначениеЗаполнено(ИмяТЧ) Тогда
					ПолноеИмяТЧ_МД = ПолноеИмяТЧ_МД + "." + ИмяТЧ;
					ТЧ_МД = МетаОбъект.ТабличныеЧасти[ИмяТЧ];
				КонецЕсли; 
				ПредставлениеМД = ТЧ_МД.Представление();
				Если ВычислятьФункциональныеОпции Тогда
					// Добавим фиктивную строку для проверки функциональных опций на сам объект
					СтрокаТаблицы = ТаблицаПрав.Добавить();
					СтрокаТаблицы.ТипМетаданных = КорневойТип;
					СтрокаТаблицы.ОбъектМетаданных = ПолноеИмяОбъектаМД;
					СтрокаТаблицы.ОбъектМетаданныхПредставление = ПредставлениеМД;
					СтрокаТаблицы.ОбъектМД = МетаОбъект;
					СтрокаТаблицы.ТабличнаяЧасть = ИмяТЧ;
					СтрокаТаблицы.ПолеПолноеИмя = ПолноеИмяТЧ_МД;
				КонецЕсли; 
				ПоляТЧ = Новый Массив;
				Если ЛиКорневойТипНехранимый Тогда 
					ПоляТЧ.Добавить("");
				ИначеЕсли Истина
					И Не ИспользоватьНаборПолей
					И ЗначениеЗаполнено(ОбъектМетаданных) 
				Тогда
					ПоляТаблицы = ирКэш.ПоляТаблицыБДЛкс(ПолноеИмяТЧ_МД);
					Для Каждого СтрокаПоля Из ПоляТаблицы Цикл
						Если Ложь
							Или ЗначениеЗаполнено(ПолеОбъекта) И СтрокаПоля.Имя <> ПолеОбъекта
							Или СтрокаПоля.ТипЗначения.СодержитТип(Тип("ТаблицаЗначений")) 
							Или (Истина
								И ЗначениеЗаполнено(ИмяТЧ)
								И (Ложь
									Или СтрокаПоля.Имя = "Ссылка"
									Или СтрокаПоля.Имя = "НомерСтроки"))
						Тогда
							Продолжить;
						КонецЕсли; 
						ПоляТЧ.Добавить(СтрокаПоля.Имя);
					КонецЦикла;
				ИначеЕсли ИспользоватьНаборПолей Тогда
					ПоляТЧ = НаборПолейТаблица.Выгрузить(Новый Структура("ОбъектМДПолноеИмя, ТабличнаяЧасть", ПолноеИмяОбъектаМД, ИмяТЧ)).ВыгрузитьКолонку("Поле");
					Если ПоляТЧ.Количество() = 0 Тогда
						Продолжить;
					КонецЕсли;
				ИначеЕсли Не ЗначениеЗаполнено(ИмяТЧ) Тогда
					ПоляТЧ.Добавить(ИмяПоляТипаМетаданных);
				КонецЕсли;
				//ПоляТЧ.Добавить("");
				Для Каждого ИмяПоляОбъекта Из ПоляТЧ Цикл
					Для Каждого КлючИЗначение Из МассивПрав Цикл
						Если Ложь
							Или ЛиКорневойТипСсылочный И Не ПраваСсылочные.Свойство(КлючИЗначение.Ключ) 
							Или ЛиКорневойТипРегистра И Не ПраваРегистры.Свойство(КлючИЗначение.Ключ) 
							Или ЛиКорневойТипЖурнала И Не ПраваЖурналы.Свойство(КлючИЗначение.Ключ) 
							Или ЛиКорневойТипПоследовательности И Не ПраваПоследовательность.Свойство(КлючИЗначение.Ключ) 
							Или (Истина
								И ЛиКорневойТипНехранимый 
								И Не ПраваНехранимые.Свойство(КлючИЗначение.Ключ)
								И Не (КорневойТип = "ОбщийРеквизит" И КлючИЗначение.Ключ = "Редактирование")
								И Не (КорневойТип = "ОбщаяФорма" И КлючИЗначение.Ключ = "Использование"))
						Тогда
							Продолжить;
						КонецЕсли; 
						//ИндикаторРолей = ирОбщий.ПолучитьИндикаторПроцессаЛкс(Метаданные.Роли.Количество(), "Роли");
						Для Каждого РольЦикл Из Роли Цикл
							Право = КлючИЗначение.Ключ;
							ПрерватьЦикл = Ложь;
							ИмяПоляВместеСТЧ = ИмяПоляОбъекта;
							Если ЗначениеЗаполнено(ИмяТЧ) Тогда
								ИмяПоляВместеСТЧ = ИмяТЧ + "." + ИмяПоляОбъекта;
							КонецЕсли; 
							Если ЛиКорневойТипНехранимый Тогда
								ПроверяемыйОбъект = ТЧ_МД;
								Если ЗначениеЗаполнено(ИмяПоляОбъекта) Тогда
									ПроверяемыйОбъект = ТЧ_МД.Реквизиты[ИмяПоляОбъекта];
								КонецЕсли; 
								Попытка
									ПараметрыДоступа = ПравоДоступа(Право, ПроверяемыйОбъект, РольЦикл);
								Исключение
									Прервать;
								КонецПопытки;
							Иначе
								Попытка
									ПараметрыДоступа = ПараметрыДоступа(Право, МетаОбъект, ИмяПоляВместеСТЧ, РольЦикл);
								Исключение
									Если Ложь
										Или ЗначениеЗаполнено(ПолеОбъекта) 
										Или ЗначениеЗаполнено(ИмяТЧ)
									Тогда
										ПрерватьЦикл = Истина;
									Иначе
										ИмяПоляОбъекта = "";
										ПараметрыДоступа = ирОбщий.ПараметрыДоступаКОбъектуМДЛкс(Право, МетаОбъект, РольЦикл, ПрерватьЦикл, ИмяПоляОбъекта);
									КонецЕсли; 
									Если ПрерватьЦикл Тогда
										Прервать;
									КонецЕсли; 
								КонецПопытки;
							КонецЕсли; 
							СтрокаТаблицы = ТаблицаПрав.Добавить();
							СтрокаТаблицы.ТипМетаданных = КорневойТип;
							СтрокаТаблицы.ОбъектМетаданных = ПолноеИмяОбъектаМД;
							СтрокаТаблицы.ОбъектМетаданныхПредставление = ПредставлениеМД;
							СтрокаТаблицы.ОбъектМД = МетаОбъект;
							СтрокаТаблицы.ТабличнаяЧасть = ИмяТЧ;
							СтрокаТаблицы.Поле = ИмяПоляОбъекта;
							СтрокаТаблицы.ПолеПолноеИмя = ПолноеИмяОбъектаМД + "." + ИмяПоляВместеСТЧ;
							//ДочернийОбъектМД = ирОбщий.ДочернийОбъектМДПоИмениЛкс(МетаОбъект, ИмяПоляОбъекта, КорневойТип);
							//Если ДочернийОбъектМД <> Неопределено Тогда
							//	СтрокаТаблицы.ПолеПолноеИмя = ДочернийОбъектМД.ПолноеИмя();
							//КонецЕсли; 
							СтрокаТаблицы.Роль = РольЦикл.Имя;
							СтрокаТаблицы.Право = КлючИЗначение.Значение;
							Если ТипЗнч(ПараметрыДоступа) = Тип("Булево") Тогда
								Если ПараметрыДоступа Тогда
									Доступ = "да";
								Иначе
									Доступ = "нет";
								КонецЕсли; 
							ИначеЕсли ПараметрыДоступа.Доступность Тогда
								Если ПараметрыДоступа.ОграничениеУсловием Тогда
									Доступ = "да ограничено";
								Иначе
									Доступ = "да";
								КонецЕсли;
							Иначе
								Доступ = "нет";
							КонецЕсли;
							СтрокаТаблицы.Доступ = Доступ;
						КонецЦикла;
					КонецЦикла; 
					//ирОбщий.ОсвободитьИндикаторПроцессаЛкс();
				КонецЦикла;
			КонецЦикла;
		КонецЦикла;
		ирОбщий.ОсвободитьИндикаторПроцессаЛкс();
	КонецЦикла;
	ирОбщий.ОсвободитьИндикаторПроцессаЛкс();
	Если ВычислятьФункциональныеОпции Тогда
		ОпцииОбъектовМД = ирКэш.ФункциональныеОпцииОбъектовМДЛкс();
		ДобавленныеОбъектыМД = Новый Соответствие;
		ИменаГруппировок = "ОбъектМД, ТабличнаяЧасть, Поле, ПолеПолноеИмя";
		ПолныеИменаПолей = ТаблицаПрав.Скопировать(, ИменаГруппировок);
		ПолныеИменаПолей.Свернуть(ИменаГруппировок);
		Индикатор = ирОбщий.ПолучитьИндикаторПроцессаЛкс(ПолныеИменаПолей.Количество(), "Функциональные опции");
		Для Каждого СтрокаПоля Из ПолныеИменаПолей Цикл
			ирОбщий.ОбработатьИндикаторЛкс(Индикатор);
			РодительскийОбъектМД = СтрокаПоля.ОбъектМД;
			Если ЗначениеЗаполнено(СтрокаПоля.ТабличнаяЧасть) Тогда
				ТЧ_МД = РодительскийОбъектМД.ТабличныеЧасти.Найти(СтрокаПоля.ТабличнаяЧасть);
				Если ТЧ_МД <> Неопределено Тогда
					РодительскийОбъектМД = ТЧ_МД;
				КонецЕсли; 
			КонецЕсли; 
			ДочернийОбъектМД = ирОбщий.ДочернийОбъектМДПоИмениЛкс(РодительскийОбъектМД, СтрокаПоля.Поле);
			Если ДочернийОбъектМД <> Неопределено Тогда
				ОбъектМД = ДочернийОбъектМД;
				ПрямоеНазначение = Истина;
			Иначе
				Если ЗначениеЗаполнено(СтрокаПоля.Поле) Тогда
					Продолжить;
				КонецЕсли; 
				ОбъектМД = РодительскийОбъектМД;
				ПрямоеНазначение = Ложь;
			КонецЕсли;
			Для Каждого СтрокаОпции Из ОпцииОбъектовМД.НайтиСтроки(Новый Структура("ИмяОбъектаМД", ОбъектМД.ПолноеИмя())) Цикл
				СтрокаТаблицы = ФункциональныеОпцииПолей.Добавить();
				СтрокаТаблицы.ФункциональнаяОпция = СтрокаОпции.ИмяОпции;
				СтрокаТаблицы.ПолеПолноеИмя = СтрокаПоля.ПолеПолноеИмя;
				СтрокаТаблицы.ПрямоеНазначение = ПрямоеНазначение = ЗначениеЗаполнено(СтрокаПоля.Поле);
				//ДобавленыСтроки = Истина;
			КонецЦикла;
			//Если Не ДобавленыСтроки Тогда
			//	// Если объект не входит в функциональные опции
			//	СтрокаТаблицы = ФункциональныеОпцииПолей.Добавить();
			//	СтрокаТаблицы.ФункциональнаяОпция = "";
			//	СтрокаТаблицы.ПолеПолноеИмя = СтрокаПоля.ПолеПолноеИмя;
			//	СтрокаТаблицы.ПрямоеНазначение = ПрямоеНазначение = ЗначениеЗаполнено(СтрокаПоля.Поле);
			//КонецЕсли;
		КонецЦикла;
		ирОбщий.ОсвободитьИндикаторПроцессаЛкс();
	КонецЕсли; 
	ТаблицаПрав.Колонки.Удалить("ОбъектМД");
КонецПроцедуры

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