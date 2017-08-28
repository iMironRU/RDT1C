﻿Перем мОтказОтЗакрытия;
Перем мТекущийШаблон;

////////////////////////////////////////////////////////////////////////////////
// ОБЩИЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Процедура СохранитьШаблон(Имя, Представление, Описание)
	
	ДокументДОМ = ДокументДОМ();
	
	Элемент = СоздатьЭлементДОМ("draft");
	Шаблон = ДокументДОМ.ПервыйДочерний.ДобавитьДочерний(Элемент);
	
	Элемент = СоздатьЭлементДОМ("presentation");
	Предст = Шаблон.ДобавитьДочерний(Элемент);
	Предст.ТекстовоеСодержимое = Представление;
	                                       
	Элемент = СоздатьЭлементДОМ("description");
	Опис = Шаблон.ДобавитьДочерний(Элемент);
	Опис.ТекстовоеСодержимое = Описание;
	
	лИмяФайла = ПолучитьИмяФайлаШаблона(Имя);
	ЗаписатьДОМ(ДокументДОМ, лИмяФайла);
	Сообщить("Шаблон """ + Имя + """ сохранен в файл """ + лИмяФайла + """");
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ, ВЫЗЫВАЕМЫЕ ИЗ ОБРАБОТЧИКОВ ЭЛЕМЕНТОВ ФОРМЫ

// Инициализация формы
//
Процедура ПриОткрытии()
	
	мОтказОтЗакрытия = Ложь;
	
	// Если нет подкаталога conf, создадим его
	ПутьКФайлу = Новый Файл(ПолучитьДиректориюКонфигурационногоФайла(, Истина));
	ИмяСервера = ирСервер.ПолучитьИмяКомпьютераЛкс();
	ЭлементыФормы.ФлажокНаСервере.Доступность = Истина
		И Не ирКэш.ЭтоФайловаяБазаЛкс()
		//И (Ложь
		//	Или Не ирКэш.ЛиПортативныйРежимЛкс() 
		//	//Или ирПортативный.ЛиСерверныйМодульДоступенЛкс()
		//	//Или ирОбщий.СтрокиРавныЛкс(ИмяСервера, ИмяКомпьютера())
		//	)
		;
	Если Не ЭлементыФормы.ФлажокНаСервере.Доступность Тогда
		ЭтотОбъект.НаСервере = Ложь;
	КонецЕсли; 
	Если Не ирКэш.ЭтоФайловаяБазаЛкс() Тогда 
		ЭлементыФормы.ФлажокНаСервере.Заголовок = "На сервере " + ИмяСервера;
	КонецЕсли; 
	ИспользоватьОбщийКаталогНастроекПриИзменении(Неопределено);
	//ЗагрузитьФайлНастройки();
	
	Если ТипДампа = 0 Тогда
		ПолеСпискаФлагиДампа.Добавить("0", "Минимальный", Истина);
	Иначе
		ПолеСпискаФлагиДампа.Добавить("0", "Минимальный", Ложь);
	КонецЕсли;
	ПолеСпискаФлагиДампа.Добавить("1", "Сегмент данных", ПроверитьБит(1, ТипДампа));
	ПолеСпискаФлагиДампа.Добавить("2", "Содержимое всей памяти процесса", ПроверитьБит(2, ТипДампа));
	ПолеСпискаФлагиДампа.Добавить("4", "Данные дескрипторов", ПроверитьБит(3, ТипДампа));
	ПолеСпискаФлагиДампа.Добавить("8", "Только информация, необходимая для восстановления стека вызовов", ПроверитьБит(4, ТипДампа));
	ПолеСпискаФлагиДампа.Добавить("16", "Ссылки на память модулей в стеке", ПроверитьБит(5, ТипДампа));
	ПолеСпискаФлагиДампа.Добавить("32", "Дамп памяти из-под выгруженных модулей", ПроверитьБит(6, ТипДампа));
	ПолеСпискаФлагиДампа.Добавить("64", "Дамп памяти, на которую есть ссылки", ПроверитьБит(7, ТипДампа));
	ПолеСпискаФлагиДампа.Добавить("128", "Подробная информация о файлах модулей", ПроверитьБит(8, ТипДампа));
	ПолеСпискаФлагиДампа.Добавить("256", "Локальные данные потоков", ПроверитьБит(9, ТипДампа));
	ПолеСпискаФлагиДампа.Добавить("512", "Память из всего доступного виртуального адресного пространства", ПроверитьБит(10, ТипДампа));
		
КонецПроцедуры

// Закрыть все возможно открытые формы, связанные с главной формой
//
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Если Модифицированность Тогда
		Ответ = Вопрос("Сохранить изменения?",
					   РежимДиалогаВопрос.ДаНетОтмена,, КодВозвратаДиалога.Да);
		Если Ответ = КодВозвратаДиалога.Отмена Тогда
			Отказ = Истина;
			мОтказОтЗакрытия = Истина;
			Возврат;
		КонецЕсли;   
		Если Ответ = КодВозвратаДиалога.Да Тогда
			Если Не СохранитьВФорме() Тогда
				Отказ = Истина;
			КонецЕсли; ;
		КонецЕсли;
	Иначе
		мОтказОтЗакрытия = Ложь;
	КонецЕсли;
	// Закрываем возможно открытые формы, связанные с главной формой
	Форма = ОбработкаОбъект.ПолучитьФорму("НастройкаКаталога", ЭтаФорма);
	Если Форма.Открыта() Тогда
		Форма.Закрыть();
	КонецЕсли;
		
КонецПроцедуры

// Сохранить настройки технологического журнала
//
Процедура КнопкаСохранитьНажатие(Элемент = Неопределено)
	
	СохранитьВФорме();
	
КонецПроцедуры

Функция СохранитьВФорме()
	
	// Проверка настройки
	НеуникальныйКаталог = "";
	РазныеКаталоги = Новый Соответствие();
	Для Каждого СтрокаЖурнала Из ТабличноеПолеЖурналы Цикл
		Если РазныеКаталоги[СтрокаЖурнала.Местоположение] = 1 Тогда
			НеуникальныйКаталог = СтрокаЖурнала.Местоположение;
			Прервать;
		КонецЕсли; 
		РазныеКаталоги[СтрокаЖурнала.Местоположение] = 1;
	КонецЦикла;
	Если СоздаватьДамп Тогда
		Если Не ПустаяСтрока(РасположениеДампа) Тогда
			Если РазныеКаталоги[РасположениеДампа] = 1 Тогда
				НеуникальныйКаталог = РасположениеДампа;
			КонецЕсли; 
		КонецЕсли; 
	КонецЕсли; 
	Если Не ПустаяСтрока(КаталогСистемногоЖурнала) Тогда
		Если РазныеКаталоги[КаталогСистемногоЖурнала] = 1 Тогда
			НеуникальныйКаталог = КаталогСистемногоЖурнала;
		КонецЕсли; 
	КонецЕсли; 
	Если НЕ ПустаяСтрока(НеуникальныйКаталог) Тогда
		Предупреждение("Каталог """ + НеуникальныйКаталог + """ указан в настройке более одного раза. Сохранение невозможно", 20);
		Возврат Ложь;
	КонецЕсли; 
	Если РазныеКаталоги[""] = 1 Тогда
		Предупреждение("Для журналов не допускается указание пустых каталогов. Сохранение невозможно", 20);
		Возврат Ложь;
	КонецЕсли; 
	Для Каждого СтрокаЖурнала Из ТабличноеПолеЖурналы Цикл
		Если ПустаяСтрока(СтрокаЖурнала.События) Тогда
			Предупреждение("Для журнала """ + СтрокаЖурнала.Местоположение + """ не задано условие регистрации событий. Сохранение невозможно", 20);
			Возврат Ложь;
		КонецЕсли; 
	КонецЦикла;
	
	ИмяЗаписанногоФайла = ЗаписатьКонфигурационныйXML();
	Модифицированность = Ложь;
	Если ИспользоватьОбщийКаталогНастроек Тогда
		ИмяИндивидуальнойНастройки = ПолучитьПолноеИмяКонфигурационногоФайла(Ложь);
		Если НРег(ИмяЗаписанногоФайла) <> НРег(ИмяИндивидуальнойНастройки) Тогда
			ФайлСуществует = ЛиФайлСуществует(ИмяИндивидуальнойНастройки);
			Если ФайлСуществует Тогда
				ФайлИндивидуальнойНастройки = Новый Файл(ИмяИндивидуальнойНастройки);
				ИмяФайлаОтката = ФайлИндивидуальнойНастройки.Путь + ФайлИндивидуальнойНастройки.ИмяБезРасширения + ".bak";
				мПереместитьФайл(ФайлИндивидуальнойНастройки.ПолноеИмя, ИмяФайлаОтката);
				Сообщить("Индивидуальная рабочая настройка техножурнала """ + ИмяИндивидуальнойНастройки + """ отключена и переименована в """ + ИмяФайлаОтката + """");
			КонецЕсли; 
		КонецЕсли; 
	КонецЕсли; 
	ПриИзмененииПравилаПолученияФайлаНастройки();
	Возврат Истина;
	
КонецФункции

// Обновить состояние главной формы
//
Процедура КнопкаОбновитьНажатие(Элемент)
	
	Если Модифицированность Тогда
		Ответ = Вопрос("Все несохраненные настройки будут потеряны. Продолжить?",
					   РежимДиалогаВопрос.ДаНет,, КодВозвратаДиалога.Да);
		Если Ответ <> КодВозвратаДиалога.Да Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли;
	//ЗакрытьДокумент();
	//ПриОткрытии();
	ЗагрузитьФайлНастройки();
	
КонецПроцедуры

// Сохранение шаблона
//
Процедура КнопкаСохранитьШаблонНажатие(Элемент)
	
	Имя = ?(мТекущийШаблон = Неопределено, "", мТекущийШаблон.Значение);
	Представление = ?(мТекущийШаблон = Неопределено, "", мТекущийШаблон.Представление);
	ФормаУстановкиИмени = ОбработкаОбъект.ПолучитьФорму("СохранениеШаблона", ЭтаФорма);
	ФормаУстановкиИмени.ПолеВводаИмяШаблона = Имя;
	ФормаУстановкиИмени.ПолеВводаПредставлениеШаблона = Представление;
	ФормаУстановкиИмени.ПолеВводаОписаниеШаблона = ПолучитьОписаниеШаблона(Имя);
	Результат = ФормаУстановкиИмени.ОткрытьМодально();
	Если Результат = "ОК" Тогда
		Имя = ФормаУстановкиИмени.ПолеВводаИмяШаблона;
		Представление = ФормаУстановкиИмени.ПолеВводаПредставлениеШаблона;
		Описание = ФормаУстановкиИмени.ПолеВводаОписаниеШаблона;
		СохранитьШаблон(Имя, Представление, Описание);
		ДобавитьОписаниеШаблона(Имя, Описание);
	ИначеЕсли Истина
		И ТипЗнч(Результат) = Тип("Строка")
		И ЗначениеЗаполнено(Результат)
	Тогда
		ДокументДОМ = ДокументДОМ();
		ЗаписатьДОМ(ДокументДОМ, Результат);
	КонецЕсли;
	
КонецПроцедуры

// Выбор шаблона
//
Процедура КнопкаВыбратьШаблон(Кнопка)
	
	ФормаВыбораШаблона = ОбработкаОбъект.ПолучитьФорму("ВыборШаблона", ЭтаФорма);
	ФормаВыбораШаблона.НачальноеЗначениеВыбора = мТекущийШаблон;
	РезультатВыбора = ФормаВыбораШаблона.ОткрытьМодально();
	Если ТипЗнч(РезультатВыбора) = Тип("ЭлементСпискаЗначений") Тогда
		//Если мТекущийШаблон <> Неопределено И Шаблон.Значение = мТекущийШаблон.Значение Тогда
		//	Возврат;
		//КонецЕсли;
		лИмяФайла = РезультатВыбора.Значение;
		ЗагрузитьФайлНастройки(лИмяФайла, Истина, УстанавливатьОсновныеКаталоги);
		мТекущийШаблон = РезультатВыбора;
	ИначеЕсли ТипЗнч(РезультатВыбора) = Тип("Строка") Тогда
		ЗагрузитьФайлНастройки(РезультатВыбора, Истина, УстанавливатьОсновныеКаталоги, Ложь);
	Иначе
		Возврат;
	КонецЕсли;
	Если ТабличноеПолеЖурналы.Количество() > 0 Тогда
		ЭлементыФормы.ТабличноеПолеЖурналы.ТекущаяСтрока = ТабличноеПолеЖурналы[0];
	КонецЕсли; 
	
КонецПроцедуры

Функция ЗагрузитьФайлНастройки(пИмяФайла = Неопределено, УстановитьПризнакИзменения = Ложь, УстанавливатьОсновныеКаталоги = Ложь, пНаСервере = Неопределено) Экспорт

	Если пНаСервере = Неопределено Тогда
		пНаСервере = НаСервере;
	КонецЕсли; 

	ЗакрытьДокумент();
	//Если лИмяФайла = Неопределено Тогда
	//	лИмяФайла = ПолучитьПолноеИмяКонфигурационногоФайла();
	//КонецЕсли; 
	Если ЗагрузитьКонфигурационныйXML(пИмяФайла, пНаСервере) = Неопределено Тогда
		ирОбщий.СообщитьСУчетомМодальностиЛкс("Ошибка при чтении XML (" + пИмяФайла + ").", МодальныйРежим);
		Возврат Неопределено;
	КонецЕсли;
	//Сообщить("Загружен файл " + лИмяФайла);
	Если УстанавливатьОсновныеКаталоги Тогда
		УстановитьПути(ОсновнойКаталогЖурнала, ОсновнойКаталогДампов);
	КонецЕсли;
	ПрочитатьНастройкиЖурналов(ТабличноеПолеЖурналы);
	ПрочитатьНастройкиДампа();
	
	Документ = ДокументДОМ();
	
	СистемныйЖурнал = Документ.ПолучитьЭлементыПоИмени("defaultlog");
	Если СистемныйЖурнал.Количество() > 0 Тогда
		ИзФайла = СистемныйЖурнал[0].ПолучитьАтрибут("location");
		КаталогСистемногоЖурнала = ?(ИзФайла = Неопределено, "", ИзФайла);
		ИзФайла = СистемныйЖурнал[0].ПолучитьАтрибут("history");
		СрокХраненияСистемногоЖурнала = ?(ИзФайла = Неопределено, 24, XMLЗначение(Тип("Число"), ИзФайла));
	Иначе
		СрокХраненияСистемногоЖурнала = 24;
		КаталогСистемногоЖурнала = "";
	КонецЕсли;
	
	Память = Документ.ПолучитьЭлементыПоИмени("mem");
	ЭтотОбъект.СледитьЗаУтечкамиПамятиВРабочихПроцессах = (Память.Количество() > 0);
	
	ПланыЗапросов = Документ.ПолучитьЭлементыПоИмени("plansql");
	ЭтотОбъект.ФиксироватьПланыЗапросовSQL = (ПланыЗапросов.Количество() > 0);
	
	БлокировкиСУБД = Документ.ПолучитьЭлементыПоИмени("dbmslocks");
	ЭтотОбъект.СобиратьБлокировкиСУБД = (БлокировкиСУБД.Количество() > 0);
	
	ЭлементыЛ = Документ.ПолучитьЭлементыПоИмени("scriptcircrefs");
	ЭтотОбъект.КонтрольЦиклическихСсылок = (ЭлементыЛ.Количество() > 0);

	ЭтотОбъект.КонтрольнаяТочкаУтечкиКлиент = Ложь;
	ЭтотОбъект.КонтрольнаяТочкаУтечкиСервер = Ложь;
	УтечкиМетоды.Очистить();
	//УтечкиПроцедуры.Очистить();
	Утечки = Документ.ПолучитьЭлементыПоИмени("leaks");
	ЭтотОбъект.СледитьЗаУтечкамиПамятиВПрикладномКоде = (Утечки.Количество() > 0);
	Если СледитьЗаУтечкамиПамятиВПрикладномКоде Тогда
		Элемент = Утечки.Элемент(0);
		Если Элемент <> Неопределено Тогда
			ИзФайла = Элемент.ПолучитьАтрибут("collect");
			РежимУтечки = ?(ИзФайла = Неопределено, Ложь, XMLЗначение(Тип("Булево"), ИзФайла));
			Точки = Элемент.ПолучитьЭлементыПоИмени("point");
			Для каждого Точка из Точки Цикл
				ИзФайла = Точка.ПолучитьАтрибут("call");
				Если ИзФайла <> Неопределено Тогда
					Если НРег(ИзФайла) = "server" Тогда
						ЭтотОбъект.КонтрольнаяТочкаУтечкиСервер = Истина;
					ИначеЕсли НРег(ИзФайла) = "client" Тогда
						ЭтотОбъект.КонтрольнаяТочкаУтечкиКлиент = Истина;
					КонецЕсли;
					Продолжить;
				КонецЕсли;
				ИзФайла = Точка.ПолучитьАтрибут("proc");
				Если ИзФайла <> Неопределено Тогда
					СтрокаДанных = УтечкиМетоды.Добавить();
					СтрокаДанных.Метод = ИзФайла;
					Продолжить;
				КонецЕсли;
				//ИзФайла = Точка.ПолучитьАтрибут("on");
				//ИзФайла2 = Точка.ПолучитьАтрибут("off");
				//Если ИзФайла <> Неопределено И ИзФайла2 <> Неопределено Тогда
				//	СтрокаДанных = УтечкиПроцедуры.Добавить();
				//	СтрокаДанных.Строка1 = ИзФайла;
				//	СтрокаДанных.Строка2 = ИзФайла2;
				//КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	
	// настройки системных событий (/system)
	СистемныеСобытия.Очистить();
	лСистемныеСобытия = Документ.ПолучитьЭлементыПоИмени("system");
	Если лСистемныеСобытия.Количество() > 0 Тогда
		СистемныеУровни = ПолучитьСписокУровнейСистемныхСобытий();
		Для каждого ЭлементСобытия Из лСистемныеСобытия Цикл
			Уровень = ЭлементСобытия.ПолучитьАтрибут("level");
			Если ПустаяСтрока(Уровень) Тогда
				//Сообщить(НСтр("ru = 'В элементе <system> не указано значение атрибута ""level"". Элемент игнорируется'", "ru"));
				Продолжить;
			КонецЕсли;
			Если СистемныеУровни.НайтиПоЗначению(Уровень) = Неопределено Тогда
				//Сообщить(Форматировать(НСтр("ru = 'В элементе <system> указано неизвестно значение атрибута. level = ""%1%"". Элемент игнорируется'", "ru"), Уровень));
				Продолжить;
			КонецЕсли;
			СтрокаСобытия = СистемныеСобытия.Добавить();
			СтрокаСобытия.Уровень = Уровень;
			СтрокаСобытия.Компонент = ЭлементСобытия.ПолучитьАтрибут("component");
			СтрокаСобытия.Класс = ЭлементСобытия.ПолучитьАтрибут("class");
		КонецЦикла;
	КонецЕсли;
	Панель1ПриСменеСтраницы();
	Модифицированность = УстановитьПризнакИзменения;
	//ВычислитьРазмерыКаталогов(); // Может долго выполняться
	Возврат Неопределено;

КонецФункции

Процедура КоманднаяПанельФормаОПодсистеме(Кнопка)
	
	ирОбщий.ОткрытьСправкуПоПодсистемеЛкс(ЭтотОбъект);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЧНОГО ПОЛЯ

Процедура ТабличноеПолеЖурналыПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	Ответ = Вопрос("Действительно удалить настройку каталога журнала?",
				   РежимДиалогаВопрос.ДаНет,, КодВозвратаДиалога.Да,
				   "Удалить настройку каталога журнала?");
	Если Ответ = КодВозвратаДиалога.Нет Тогда
		Возврат;
	КонецЕсли;
	Инд = ТабличноеПолеЖурналы.Индекс(Элемент.ТекущаяСтрока);
	ДокументДОМ = ДокументДОМ();
	УзелЖурнала = ПолучитьУзелЖурнала(Инд);
	Если УзелЖурнала <> Неопределено Тогда
		УзелКонфигурации = ДокументДОМ.ПервыйДочерний;
		УзелКонфигурации.УдалитьДочерний(УзелЖурнала);
		ПрочитатьНастройкиЖурналов(ТабличноеПолеЖурналы);
		Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры

Процедура ТабличноеПолеЖурналыПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	ОткрытьФормуРедактированияЖурнала();
	
КонецПроцедуры

Функция ОткрытьФормуРедактированияЖурнала() Экспорт
	
	ФормаКаталога = ОбработкаОбъект.ПолучитьФорму("НастройкаКаталога", ЭтаФорма);
	ФормаКаталога.ЭтаФорма.ДобавлениеНового = Ложь;
	ТекущийЖурнал = ТабличноеПолеЖурналы.Индекс(ЭлементыФормы.ТабличноеПолеЖурналы.ТекущаяСтрока);
	ФормаКаталога.Открыть();
	Возврат ФормаКаталога;
	
КонецФункции

Процедура ТабличноеПолеЖурналыПередНачаломДобавления(Элемент, Отказ, Копирование)
	
	Отказ = Истина;
	ФормаСобытия = ОбработкаОбъект.ПолучитьФорму("НастройкаКаталога", ЭтаФорма);
	ФормаСобытия.ЭтаФорма.ДобавлениеНового = Истина;
	ФормаСобытия.Открыть();
	
КонецПроцедуры

Процедура ИспользоватьОбщийКаталогНастроекПриИзменении(Элемент)
	
	ПриИзмененииПравилаПолученияФайлаНастройки();
	
КонецПроцедуры

Процедура ФлажокНаСервереПриИзменении(Элемент)
	
	ПриИзмененииПравилаПолученияФайлаНастройки();
	
КонецПроцедуры

Процедура ПриИзмененииПравилаПолученияФайлаНастройки() Экспорт
	
	ЭлементыФормы.КаталогНастройки.ОтметкаНезаполненного = Ложь;
	ЭлементыФормы.КаталогНастройки.АвтоОтметкаНезаполненного = ирКэш.ЛиПортативныйРежимЛкс() И ЭтотОбъект.НаСервере;
	ЭлементыФормы.ИспользоватьОбщийКаталогНастроек.Доступность = Не ЭлементыФормы.КаталогНастройки.АвтоОтметкаНезаполненного И Не ЗначениеЗаполнено(КаталогНастройки);
	ЭтаФорма.ПолноеИмяФайлаНастройки = ПолучитьПолноеИмяКонфигурационногоФайла();
	ИмяФайлаВычислено = ЗначениеЗаполнено(ПолноеИмяФайлаНастройки);
	ЭлементыФормы.ДействияФормы.Кнопки.КнопкаСохранить.Доступность = ИмяФайлаВычислено;
	ЭлементыФормы.ДействияФормы.Кнопки.КнопкаОбновить.Доступность = ИмяФайлаВычислено;
	ЭлементыФормы.ДействияФормы.Кнопки.Выключить.Доступность = ИмяФайлаВычислено;
	лДатаИзмененияФайла = 0;
	ФайлНайден = ЛиФайлСуществует(ПолноеИмяФайлаНастройки, , лДатаИзмененияФайла);
	Если ЗначениеЗаполнено(лДатаИзмененияФайла) Тогда
		ДатаИзмененияФайла = лДатаИзмененияФайла;
	Иначе
		ДатаИзмененияФайла = Неопределено;
	КонецЕсли; 
	ОбновлениеВремениДоСчитывания();
	Если ФайлНайден Тогда
		//Если ДатаИзмененияФайла + 60 > ТекущаяДата() Тогда
		//	СостояниеФайла = "Обновление";
		//	ЭлементыФормы.СостояниеФайла.ЦветТекстаПоля = Новый Цвет(0, 0, 150);
		//Иначе
			СостояниеФайла = "Присутствует";
			ЭлементыФормы.СостояниеФайла.ЦветТекстаПоля = Новый Цвет(0, 150, 0);
		//КонецЕсли; 
	Иначе
		СостояниеФайла = "Отсутствует";
		ЭлементыФормы.СостояниеФайла.ЦветТекстаПоля = Новый Цвет(150, 0, 0);
	КонецЕсли;
	ПодключитьОбработчикОжидания("ОбновлениеВремениДоСчитывания", 1);
	Если Не Модифицированность Тогда
		ЗагрузитьФайлНастройки();
	КонецЕсли; 
	
КонецПроцедуры

Процедура ОбновлениеВремениДоСчитывания()
	
	ВремяДоСчитывания = ДатаИзмененияФайла + 60 - ирОбщий.ПолучитьТекущуюДатуЛкс(НаСервере);
	Если ВремяДоСчитывания < 0 Тогда
		ВремяДоСчитывания = 0;
		ОтключитьОбработчикОжидания("ОбновлениеВремениДоСчитывания");
	КонецЕсли; 
	
КонецПроцедуры

Процедура ДействияФормыВыключить(Кнопка)
	
	Ответ = Вопрос("Считать рабочую настройку перед отключением?", РежимДиалогаВопрос.ДаНетОтмена);
	Если Ответ = КодВозвратаДиалога.Отмена Тогда
		Возврат;
	ИначеЕсли Ответ = КодВозвратаДиалога.Да Тогда
		СчитатьНастройку = Истина;
	Иначе
		СчитатьНастройку = Ложь;
	КонецЕсли;
	
	ИмяИндивидуальнойНастройки = ПолучитьПолноеИмяКонфигурационногоФайла(Ложь);
	ФайлИндивидуальнойНастройки = Новый Файл(ИмяИндивидуальнойНастройки);
	ФайлСуществует = ЛиФайлСуществует(ИмяИндивидуальнойНастройки);
	Если ФайлСуществует Тогда
		Если СчитатьНастройку Тогда
			ЗагрузитьФайлНастройки(ИмяИндивидуальнойНастройки, Истина);
			//УстановитьПризнакИзменения(Истина);
			Модифицированность = Истина;
		КонецЕсли; 
		ИмяФайлаОтката = ФайлИндивидуальнойНастройки.Путь + ФайлИндивидуальнойНастройки.ИмяБезРасширения + ".bak";
		мПереместитьФайл(ФайлИндивидуальнойНастройки.ПолноеИмя, ИмяФайлаОтката);
		Сообщить("Индивидуальная рабочая настройка техножурнала """ + ИмяИндивидуальнойНастройки + """ отключена и переименована в """ + ИмяФайлаОтката + """");
	КонецЕсли; 
	ИмяОбщейНастройки = ПолучитьПолноеИмяКонфигурационногоФайла(Истина);
	ФайлОбщейНастройки = Новый Файл(ИмяОбщейНастройки);
	ФайлСуществует = ЛиФайлСуществует(ИмяОбщейНастройки);
	Если ФайлСуществует Тогда
		Если СчитатьНастройку Тогда
			ЗагрузитьФайлНастройки(ИмяОбщейНастройки, Истина);
			//УстановитьПризнакИзменения(Истина);
			Модифицированность = Истина;
		КонецЕсли; 
		ИмяФайлаОтката = ФайлОбщейНастройки.Путь + ФайлОбщейНастройки.ИмяБезРасширения + ".bak";
		мПереместитьФайл(ФайлОбщейНастройки.ПолноеИмя, ИмяФайлаОтката);
		ЭтаФорма.ДатаИзмененияФайла = ТекущаяДата();
		Сообщить("Общая рабочая настройка техножурнала """ + ИмяОбщейНастройки + """ отключена и переименована в """ + ИмяФайлаОтката + """");
	КонецЕсли; 
	ПриИзмененииПравилаПолученияФайлаНастройки();
	
КонецПроцедуры

Процедура КоманднаяПанель1Анализ(Кнопка)
	
	ТекущаяСтрока = ПолучитьТекущуюСтрокуКаталоговЖурнала();
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	Если ЗначениеЗаполнено(ТекущаяСтрока.Местоположение) Тогда
		//Если НаСервере Тогда
		//	Сообщить("Внимание! Анализ техножурнала выполняется только на клиенте!", СтатусСообщения.Информация);
		//КонецЕсли; 
		АнализТехножурнала = ирОбщий.ПолучитьОбъектПоПолномуИмениМетаданныхЛкс("Обработка.ирАнализТехножурнала");
		#Если Сервер И Не Сервер Тогда
			АнализТехножурнала = Обработки.ирАнализТехножурнала.Создать();
		#КонецЕсли
		АнализТехножурнала.ОткрытьСПараметрами(ТекущаяСтрока.Местоположение);
	КонецЕсли; 
	
КонецПроцедуры

Процедура КоманднаяПанель1ОчиститьКаталогЖурнала(Кнопка)
	
	ТекущаяСтрока = ПолучитьТекущуюСтрокуКаталоговЖурнала();
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	Если ЗначениеЗаполнено(ТекущаяСтрока.Местоположение) Тогда
		ирОбщий.ОчиститьКаталогТехножурналаЛкс(ТекущаяСтрока.Местоположение, НаСервере);
		ТекущаяСтрока.Доступен = Не ирОбщий.ЛиКаталогТехножурналаНедоступенЛкс(ТекущаяСтрока.Местоположение, НаСервере, Ложь);
	КонецЕсли; 
	
КонецПроцедуры

Функция ПолучитьТекущуюСтрокуКаталоговЖурнала()

	ТекущаяСтрока = ЭлементыФормы.ТабличноеПолеЖурналы.ТекущаяСтрока;
	Если ТекущаяСтрока = Неопределено Тогда
		Если ТабличноеПолеЖурналы.Количество() = 1 Тогда
			ТекущаяСтрока = ТабличноеПолеЖурналы[0];
			ЭлементыФормы.ТабличноеПолеЖурналы.ТекущаяСтрока = ТекущаяСтрока;
		КонецЕсли; 
	КонецЕсли; 
	Возврат ТекущаяСтрока;

КонецФункции

Процедура КоманднаяПанель1ОбновитьРазмер(Кнопка)
	
	ВычислитьРазмерыКаталогов();
	
КонецПроцедуры

Процедура ВычислитьРазмерыКаталогов() Экспорт
	
	Для Каждого СтрокаКаталога Из ТабличноеПолеЖурналы Цикл
		Если НаСервере Тогда
			ОбщийРазмер = ирСервер.ВычислитьРазмерКаталогаЛкс(СтрокаКаталога.Местоположение);
		Иначе
			ОбщийРазмер = ирОбщий.ВычислитьРазмерКаталогаЛкс(СтрокаКаталога.Местоположение);
		КонецЕсли; 
		СтрокаКаталога.Размер = ОбщийРазмер / 1024;
		СтрокаКаталога.Доступен = Не ирОбщий.ЛиКаталогТехножурналаНедоступенЛкс(СтрокаКаталога.Местоположение, НаСервере);
	КонецЦикла;
	
КонецПроцедуры

Процедура ОсновнойКаталогЖурналаПриИзменении(Элемент)
	
	ирОбщий.ПолеВводаСИсториейВыбора_ПриИзмененииЛкс(Элемент, ЭтаФорма);
	
КонецПроцедуры

Процедура ОсновнойКаталогДамповПриИзменении(Элемент)
	
	ирОбщий.ПолеВводаСИсториейВыбора_ПриИзмененииЛкс(Элемент, ЭтаФорма);
	
КонецПроцедуры

Процедура ОсновнойКаталогЖурналаНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	ирОбщий.ПолеФайловогоКаталога_НачалоВыбораЛкс(Элемент, СтандартнаяОбработка);
	
КонецПроцедуры

Процедура ОсновнойКаталогДамповНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	ирОбщий.ПолеФайловогоКаталога_НачалоВыбораЛкс(Элемент, СтандартнаяОбработка);
	
КонецПроцедуры

Процедура ОсновнойКаталогЖурналаНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)

	ирОбщий.ПолеВводаСИсториейВыбора_НачалоВыбораИзСпискаЛкс(Элемент, ЭтаФорма);
	
КонецПроцедуры

Процедура ОсновнойКаталогДамповНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)

	ирОбщий.ПолеВводаСИсториейВыбора_НачалоВыбораИзСпискаЛкс(Элемент, ЭтаФорма);
	
КонецПроцедуры

Процедура ОсновнойКаталогЖурналаОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ЗапуститьПриложение(Элемент.Значение);
		
КонецПроцедуры

Процедура ОсновнойКаталогДамповОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ЗапуститьПриложение(Элемент.Значение);

КонецПроцедуры

Процедура КоманднаяПанель1ОткрытьКаталог(Кнопка)
	
	ТекущаяСтрока = ПолучитьТекущуюСтрокуКаталоговЖурнала();
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	Если ЗначениеЗаполнено(ТекущаяСтрока.Местоположение) Тогда
		ЗапуститьПриложение(ТекущаяСтрока.Местоположение);
	КонецЕсли; 
	
КонецПроцедуры

Процедура РасположениеДампаОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Элемент.Значение = ОсновнойКаталогДампов;

КонецПроцедуры

Процедура РасположениеДампаОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ЗапуститьПриложение(Элемент.Значение);

КонецПроцедуры

Процедура РасположениеДампаПриИзменении(Элемент)
	
	ирОбщий.ПолеВводаСИсториейВыбора_ПриИзмененииЛкс(Элемент, ЭтаФорма);
	
КонецПроцедуры

Процедура РасположениеДампаНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	
	ирОбщий.ПолеВводаСИсториейВыбора_НачалоВыбораИзСпискаЛкс(Элемент, ЭтаФорма);

КонецПроцедуры

// Обработка события изменения состояния флажков
// 
Процедура ПолеСпискаФлагиДампаПриИзмененииФлажка(Элемент)
	
	ФлагДампа = Элемент.ТекущаяСтрока;
	
	Если ФлагДампа.Пометка Тогда
		ЭтотОбъект.ТипДампа = ЭтотОбъект.ТипДампа + Число(ФлагДампа.Значение);
	Иначе
		ЭтотОбъект.ТипДампа = ЭтотОбъект.ТипДампа - Число(ФлагДампа.Значение);
	КонецЕсли;
	
	Если ТипДампа = 0 Тогда
		Элемент.Значение[0].Пометка = Истина;
	Иначе
		Элемент.Значение[0].Пометка = Ложь;
	КонецЕсли;
	ТипДампа = 0;
	Для Каждого ФлагДампа Из ПолеСпискаФлагиДампа Цикл
		Если ФлагДампа.Пометка Тогда
			ТипДампа = ТипДампа + ФлагДампа.Значение;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

// Установить все флажки
// 
Процедура КоманднаяПанельСпискаДампаУстановитьФлажки(Кнопка)
	
	ТипДампа = 0;
	Для Каждого ФлагДампа Из ПолеСпискаФлагиДампа Цикл
		Если ФлагДампа.Значение = "0" Тогда
			Продолжить;
		КонецЕсли;
		ФлагДампа.Пометка = Истина;
		ТипДампа = ТипДампа + ФлагДампа.Значение;
	КонецЦикла;
	ЭлементыФормы.ПолеСпискаФлагиДампа.Значение[0].Пометка = Ложь;
	
КонецПроцедуры

// Снять все флажки
// 
Процедура КоманднаяПанельСпискаДампаСнятьФлажки(Кнопка)
	
	Для Каждого ФлагДампа Из ПолеСпискаФлагиДампа Цикл
		Если ФлагДампа.Значение = "0" Тогда
			Продолжить
		КонецЕсли;
		ФлагДампа.Пометка = Ложь;
	КонецЦикла;
	ЭтотОбъект.ТипДампа = 0;
	ЭлементыФормы.ПолеСпискаФлагиДампа.Значение[0].Пометка = Истина;
	
КонецПроцедуры

// Выбор каталога расположения дампа
// 
Процедура РасположениеДампаНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	ирОбщий.ПолеФайловогоКаталога_НачалоВыбораЛкс(Элемент, СтандартнаяОбработка);
	
КонецПроцедуры

Процедура Панель1ПриСменеСтраницы(Элемент = Неопределено, ТекущаяСтраница = Неопределено)
	
    Элемент = ЭлементыФормы.ПанельРедактируемаяНастройка;
	ТекущаяСтраница = Элемент.ТекущаяСтраница.Имя;
	Если Элемент.Страницы[ТекущаяСтраница] = Элемент.Страницы.XML Тогда
		ЭлементыФормы.СодержимоеКонфигурационногоФайла.УстановитьТекст(ПолучитьСтрокуХМЛ(ПолучитьОбновитьДокументДОМ()));
	КонецЕсли; 
	
КонецПроцедуры

Процедура ТабличноеПолеЖурналыПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	
	Если Ложь
		Или ПустаяСтрока(ДанныеСтроки.Местоположение)
		Или ПустаяСтрока(ДанныеСтроки.События)
		Или Не ДанныеСтроки.Доступен
	Тогда
		ОформлениеСтроки.ЦветФона = Новый Цвет(255, 240, 240);
	КонецЕсли; 
	
КонецПроцедуры

Процедура КонтрольнаяТочкаУтечкиКлиентПриИзменении(Элемент)
	
	Если Элемент.Значение Тогда
		ЭтотОбъект.СледитьЗаУтечкамиПамятиВПрикладномКоде = Истина;
	КонецЕсли; 
	
КонецПроцедуры

Процедура КаталогСистемногоЖурналаПоУмолчаниюОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ЗапуститьПриложение(Элемент.Значение);
	
КонецПроцедуры

Процедура ДействияФормыITS(Кнопка)
	
	ЗапуститьПриложение("http://its.1c.ru/db/v8doc#content:26:1:issogl1_3.14.logcfg.xml");

КонецПроцедуры

Процедура УтечкиПоМодулямПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	Если Не ОтменаРедактирования Тогда
		ЭтотОбъект.СледитьЗаУтечкамиПамятиВПрикладномКоде = Истина;
	КонецЕсли; 
	
КонецПроцедуры

Процедура ПолноеИмяФайлаНастройкиОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ЗапуститьПриложение(Элемент.Значение);
	
КонецПроцедуры

Процедура КаталогНастройкиПриИзменении(Элемент)
	
	ирОбщий.ПолеВводаСИсториейВыбора_ПриИзмененииЛкс(Элемент, ЭтаФорма);
	ПриИзмененииПравилаПолученияФайлаНастройки();

КонецПроцедуры

Процедура СтруктураКоманднойПанелиНажатие(Кнопка)
	
	ирОбщий.ОткрытьСтруктуруКоманднойПанелиЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	ирОбщий.ФормаОбработкаОповещенияЛкс(ЭтаФорма, ИмяСобытия, Параметр, Источник); 

КонецПроцедуры

Процедура ДействияФормыСтруктураФормы(Кнопка)
	
	ирОбщий.ОткрытьСтруктуруФормыЛкс(ЭтаФорма);
	
КонецПроцедуры

Процедура ПриЗакрытии()
	
	ирОбщий.Форма_ПриЗакрытииЛкс(ЭтаФорма);
	
КонецПроцедуры


ирОбщий.ИнициализироватьФормуЛкс(ЭтаФорма, "Обработка.ирНастройкаТехножурнала.Форма.НастройкаТехножурнала");

КаталогСистемногоЖурналаПоУмолчанию = ирКэш.Получить().ПолучитьКаталогВерсииПлатформыВПрофиле() + "\logs";
КаталогДампаПоУмолчанию = ирКэш.Получить().ПолучитьКаталогВерсииПлатформыВПрофиле() + "\dumps";
ЗаполнитьСписокВыбораСрокаХранения(ЭлементыФормы.СрокХраненияСистемногоЖурнала.СписокВыбора);
ЭлементыФормы.СистемныеСобытия.Колонки.Уровень.ЭлементУправления.СписокВыбора = ПолучитьСписокУровнейСистемныхСобытий();
ЗаполнитьСтруктуруСобытий();
ЗаполнитьСписокСвойствСобытий();