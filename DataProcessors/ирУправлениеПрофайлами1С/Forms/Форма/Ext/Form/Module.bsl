﻿Процедура СтруктураКоманднойПанелиНажатие(Кнопка)
	
	ирОбщий.ОткрытьСтруктуруКоманднойПанелиЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура ДействияФормыОПодсистеме(Кнопка)
	
	ирОбщий.ОткрытьСправкуПоПодсистемеЛкс(ЭтотОбъект);
	
КонецПроцедуры

Процедура ДействияФормыСтруктураФормы(Кнопка)
	
	ирОбщий.ОткрытьСтруктуруФормыЛкс(ЭтаФорма);
	
КонецПроцедуры

Процедура ПриОткрытии()
	
	СистемнаяИнформация = Новый СистемнаяИнформация;
	ЭтотОбъект.ПользовательОС = ирКэш.ТекущийПользовательОСЛкс();
	УстановитьПараметрыВыбраннойБазы();
	
КонецПроцедуры

Процедура УстановитьПараметрыВыбраннойБазы(Знач НастройкиБазыНаКлиенте = Неопределено)
	
	Если НастройкиБазыНаКлиенте = Неопределено Тогда
		НастройкиБазыНаКлиенте = ирКэш.НастройкиБазыНаКлиентеЛкс();
	КонецЕсли; 
	Если НастройкиБазыНаКлиенте = Неопределено Тогда
		ЭтотОбъект.ИдентификаторБазы = "?";
		ЭтотОбъект.КаталогКэшейБазы = Неопределено;
		ЭтотОбъект.КаталогБазы = Неопределено;
		Возврат;
	КонецЕсли; 
	#Если Сервер И Не Сервер Тогда
		НастройкиБазыНаКлиенте = Обработки.ирПлатформа.Создать().СписокБазПользователя.Добавить();
	#КонецЕсли
	ЭтотОбъект.ИдентификаторБазы = НастройкиБазыНаКлиенте.ID;
	ВыбранаТекущаяБаза = НастройкиБазыНаКлиенте.ID = ирКэш.НастройкиБазыНаКлиентеЛкс().ID;
	Если ВыбранаТекущаяБаза Тогда
		КлючомЯвляетсяСтрокаСоединения = Неопределено;
		КлючБазыВСпискеПользователя = ирОбщий.КлючБазыВСпискеПользователяЛкс(КлючомЯвляетсяСтрокаСоединения);
	Иначе
		КлючомЯвляетсяСтрокаСоединения = Не ирОбщий.ЛиИдентификацияБазыВСпискеПоНаименованиюЛкс();
	КонецЕсли; 
	Если Не КлючомЯвляетсяСтрокаСоединения Тогда
		ЭтотОбъект.База = НастройкиБазыНаКлиенте.Наименование;
	Иначе
		ЭтотОбъект.База = НастройкиБазыНаКлиенте.Connect;
	КонецЕсли; 
	ЭтотОбъект.КаталогКэшейБазы = НастройкиБазыНаКлиенте.КаталогКэша;
	ЭтотОбъект.КаталогБазы = НастройкиБазыНаКлиенте.КаталогНастроек;
	УстановитьПараметрыПользователя1С(ВыбранаТекущаяБаза);
	ОбновитьТаблицуФайлов();

КонецПроцедуры

Процедура УстановитьПараметрыПользователя1С(ВыбранаТекущаяБаза = Неопределено)
	
	Если ВыбранаТекущаяБаза = Истина Или База = ирКэш.КлючБазыВСпискеПользователяИзКоманднойСтрокиЛкс() Тогда
		Если Не ЗначениеЗаполнено(ЭтотОбъект.Пользователь1С) Тогда
			ТекущийПользователь1С = ПользователиИнформационнойБазы.ТекущийПользователь();
			ЭтотОбъект.Пользователь1С = ТекущийПользователь1С.Имя;
		КонецЕсли; 
		ЭтотОбъект.ИдентификаторПользователя1С = ПользователиИнформационнойБазы.НайтиПоИмени(ЭтотОбъект.Пользователь1С).УникальныйИдентификатор;
		ShellApplication = Новый COMobject("Shell.Application");
		КаталогПеремещаемыхФайлов = ирКэш.КаталогИзданияПлатформыВПрофилеЛкс(Ложь);
		КаталогПеремещаемыхФайловБазы = КаталогПеремещаемыхФайлов + "\" + ИдентификаторБазы;
		ЭтотОбъект.КаталогПользователя1С = КаталогПеремещаемыхФайлов + "\" + ИдентификаторБазы + "\" + ИдентификаторПользователя1С;
	Иначе
		ЭтотОбъект.ИдентификаторПользователя1С = "?";
		ЭтотОбъект.Пользователь1С = Неопределено;
		ЭтотОбъект.КаталогПользователя1С = Неопределено;
	КонецЕсли;

КонецПроцедуры

Процедура ОбновитьТаблицуФайлов()
	
	Если ЭлементыФормы.Файлы.ТекущаяСтрока <> Неопределено Тогда
		ИмяТекущегоФайла = ЭлементыФормы.Файлы.ТекущаяСтрока.ПолноеИмяФайла;
	КонецЕсли; 
	Файлы.Очистить();
	ShellApplication = Новый COMobject("Shell.Application");
	КаталогПеремещаемыхФайлов = ирКэш.КаталогИзданияПлатформыВПрофилеЛкс(Ложь);
	КаталогПеремещаемыхФайловБазы = КаталогПеремещаемыхФайлов + "\" + ИдентификаторБазы;
	КаталогПеремещаемыхФайловПользователя1С = КаталогПеремещаемыхФайлов + "\" + ИдентификаторБазы + "\" + ИдентификаторПользователя1С;
	СтрокаФайла = Файлы.Добавить();
	СтрокаФайла.ЛогическийПуть = "$Local\$1Cv";
	СтрокаФайла.ПолноеИмяФайла = ShellApplication.Namespace(28).Self.Path + "\1C\1Cv8\appsrvrs.lst";
	СтрокаФайла.Описание = "Список центральных серверов 1С:Предприятия, зарегистрированных в утилите администрирования информационных баз в варианте клиент-сервер. Также содержит последний путь в дереве консоли.";
	СтрокаФайла = Файлы.Добавить();
	СтрокаФайла.ЛогическийПуть = "$Local\$1Cv";
	СтрокаФайла.ПолноеИмяФайла = ShellApplication.Namespace(28).Self.Path + "\1C\1Cv8\1cv8u.pfl";
	СтрокаФайла.Описание = "Какой то идентификатор клиента";
	СтрокаФайла = Файлы.Добавить();
	СтрокаФайла.ЛогическийПуть = "$Roaming\$1CEStart";
	СтрокаФайла.ПолноеИмяФайла = ShellApplication.Namespace(26).Self.Path + "\1C\1CEStart\ibases.v8i";
	СтрокаФайла.Описание = "Список баз.";
	СтрокаФайла = Файлы.Добавить();
	СтрокаФайла.ЛогическийПуть = "$Roaming\$1Cv";
	СтрокаФайла.ПолноеИмяФайла = КаталогПеремещаемыхФайлов + "\" + "1Cv8.pfl";
	СтрокаФайла.Описание = "Настройки конфигуратора. Примеры. Открыто ли табло. Настройки текстового редактора. Настройки приложений сравнения/объединения текстов.";
	СтрокаФайла = Файлы.Добавить();
	СтрокаФайла.ЛогическийПуть = "$Roaming\$1Cv";
	СтрокаФайла.ПолноеИмяФайла = КаталогПеремещаемыхФайлов + "\" + "1Cv8c.pfl";
	СтрокаФайла.Описание = "Настройки тонкого клиента.";
	СтрокаФайла = Файлы.Добавить();
	СтрокаФайла.ЛогическийПуть = "$Roaming\$1Cv";
	СтрокаФайла.ПолноеИмяФайла = КаталогПеремещаемыхФайлов + "\" + "1Cv8conn.pfl";
	СтрокаФайла.Описание = "Файлы клиентских настроек, информация о резервных кластерах и другая служебная информация.";
	СтрокаФайла = Файлы.Добавить();
	СтрокаФайла.ЛогическийПуть = "$Roaming\$1Cv";
	СтрокаФайла.ПолноеИмяФайла = КаталогПеремещаемыхФайлов + "\" + "1Cv8cmn.pfl";
	СтрокаФайла.Описание = "Настройки конфигуратора. Примеры. Расположение окон. Цвета редактора модулей. Расположение и состав панелей инструментов и меню. Список последних открытых файлов.";
	СтрокаФайла = Файлы.Добавить();
	СтрокаФайла.ЛогическийПуть = "$Roaming\$1Cv";
	СтрокаФайла.ПолноеИмяФайла = КаталогПеремещаемыхФайлов + "\" + "1Cv8u.pfl";
	СтрокаФайла.Описание = "От содержимого этого файла зависит свойство СистемнаяИнформация.ИдентификаторКлиента";
	СтрокаФайла = Файлы.Добавить();
	СтрокаФайла.ЛогическийПуть = "$Roaming\$1Cv";
	СтрокаФайла.ПолноеИмяФайла = КаталогПеремещаемыхФайлов + "\" + "1Cv8strt.pfl";
	СтрокаФайла.Описание = "Параметры диалога выбора базы. Примеры. Размеры и расположение диалога запуска. Настройки диалогов установки параметров информационных баз.";
	СтрокаФайла = Файлы.Добавить();
	СтрокаФайла.ЛогическийПуть = "$Roaming\$1Cv";
	СтрокаФайла.ПолноеИмяФайла = КаталогПеремещаемыхФайлов + "\" + "1Cv8prim.pfl";
	СтрокаФайла.Описание = "Настройки клиент-серверного режима.";
	СтрокаФайла = Файлы.Добавить();
	СтрокаФайла.ЛогическийПуть = "$Roaming\$1Cv\$База";
	СтрокаФайла.ПолноеИмяФайла = КаталогПеремещаемыхФайловБазы + "\" + "1Cv8.pfl";
	СтрокаФайла.Описание = "Настройки конфигуратора. Примеры. Настройки сравнения файлов. Настройки глобального поиска по текстам конфигурации. Настройки отладки.";
	СтрокаФайла = Файлы.Добавить();
	СтрокаФайла.ЛогическийПуть = "$Roaming\$1Cv\$База";
	СтрокаФайла.ПолноеИмяФайла = КаталогПеремещаемыхФайловБазы + "\" + "1Cv8c.pfl";
	СтрокаФайла.Описание = "Настройки клиентского приложения. Примеры. Привязка окна заставки к монитору.";
	СтрокаФайла = Файлы.Добавить();
	СтрокаФайла.ЛогическийПуть = "$Roaming\$1Cv\$База";
	СтрокаФайла.ПолноеИмяФайла = КаталогПеремещаемыхФайловБазы + "\" + "def.usr";
	СтрокаФайла.Описание = "Последнее имя входа в базу";
	СтрокаФайла = Файлы.Добавить();
	СтрокаФайла.ЛогическийПуть = "$Roaming\$1Cv\$База\$Пользователь1С";
	СтрокаФайла.ПолноеИмяФайла = КаталогПеремещаемыхФайловПользователя1С + "\" + "1Cv8.pfl";
	СтрокаФайла.Описание = "Настройки конфигуратора. Примеры. Параметры подключения к хранилищу конфигурации. Расположение окна синтакс-помощника. Настройки окна табло. Список последних вычисленных выражений.";
	СтрокаФайла = Файлы.Добавить();
	СтрокаФайла.ЛогическийПуть = "$Roaming\$1Cv\$База\$Пользователь1С";
	СтрокаФайла.ПолноеИмяФайла = КаталогПеремещаемыхФайловПользователя1С + "\" + "1Cv8c.pfl";
	СтрокаФайла.Описание = "Настройки тонкого клиента";
	СтрокаФайла = Файлы.Добавить();
	СтрокаФайла.ЛогическийПуть = "$Roaming\$1Cv\$База\$Пользователь1С";
	СтрокаФайла.ПолноеИмяФайла = КаталогПеремещаемыхФайловПользователя1С + "\" + "1Cv8ccmn.pfl";
	СтрокаФайла.Описание = "Настройки клиентского приложения";
	
	// http://forum.infostart.ru/forum86/topic59725/message1344689/#message1344689
	СтрокаФайла = Файлы.Добавить();
	СтрокаФайла.ЛогическийПуть = "$Roaming\$1Cv\$База\$Пользователь1С";
	СтрокаФайла.ПолноеИмяФайла = КаталогПеремещаемыхФайловПользователя1С + "\" + "1Cv8cmn.pfl";
	СтрокаФайла.Описание = "Настройки клиентского приложения. Примеры. Расположение окон. Расположение и состав панелей инструментов и меню. Список последних открытых файлов.";
	
	Для Каждого СтрокаФайла Из Файлы Цикл
		Файл = Новый Файл(СтрокаФайла.ПолноеИмяФайла);
		СтрокаФайла.КраткоеИмяФайла = Файл.Имя;
		Если СтрокаФайла.ЛогическийПуть = "$Local\$1Cv" Тогда
			СтрокаФайла.ПринадлежностьДанных = "Пользователь ОС";
		ИначеЕсли СтрокаФайла.ЛогическийПуть = "$Roaming\$1Cv" Тогда
			СтрокаФайла.ПринадлежностьДанных = "Пользователь ОС";
		ИначеЕсли СтрокаФайла.ЛогическийПуть = "$Roaming\$1CEStart" Тогда
			СтрокаФайла.ПринадлежностьДанных = "Пользователь ОС";
		ИначеЕсли СтрокаФайла.ЛогическийПуть = "$Roaming\$1Cv\$База" Тогда
			СтрокаФайла.ПринадлежностьДанных = "Пользователь ОС, база";
		ИначеЕсли СтрокаФайла.ЛогическийПуть = "$Roaming\$1Cv\$База\$Пользователь1С" Тогда
			СтрокаФайла.ПринадлежностьДанных = "Пользователь ОС, база, пользователь 1С";
			Если Не ЗначениеЗаполнено(Пользователь1С) Тогда
				Продолжить;
			КонецЕсли; 
		КонецЕсли; 
		СтрокаФайла.ФайлСуществует = Файл.Существует(); // Возвращет Истина для путей с "?"
		Если СтрокаФайла.ФайлСуществует Тогда
			СтрокаФайла.ДатаИзменения = Файл.ПолучитьВремяИзменения();
			СтрокаФайла.РазмерБайт = Файл.Размер();
		КонецЕсли; 
	КонецЦикла;
	Файлы.Сортировать("ЛогическийПуть, КраткоеИмяФайла");
	Если ИмяТекущегоФайла <> Неопределено Тогда
		ЭлементыФормы.Файлы.ТекущаяСтрока = Файлы.Найти(ИмяТекущегоФайла, "ПолноеИмяФайла");
	КонецЕсли; 
	
КонецПроцедуры

Процедура СборкиПлатформыВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	ирОбщий.ОткрытьФайлВПроводникеЛкс(ВыбраннаяСтрока.ПолноеИмяФайла);
	
КонецПроцедуры

Процедура КПФайлыОбновить(Кнопка)
	
	ОбновитьТаблицуФайлов();
	
КонецПроцедуры

Процедура КПФайлыОткрытьФайл(Кнопка)
	
	Если ЭлементыФормы.Файлы.ТекущаяСтрока <> Неопределено Тогда
		ЗапуститьПриложение(ЭлементыФормы.Файлы.ТекущаяСтрока.ПолноеИмяФайла);
	КонецЕсли; 
	
КонецПроцедуры

Процедура КПФайлыНайтиВПроводнике(Кнопка)
	
	Если ЭлементыФормы.Файлы.ТекущаяСтрока <> Неопределено Тогда
		ирОбщий.ОткрытьФайлВПроводникеЛкс(ЭлементыФормы.Файлы.ТекущаяСтрока.ПолноеИмяФайла);
	КонецЕсли; 

КонецПроцедуры

Процедура КПФайлыУдалитьФайл(Кнопка)
	
	Если ЭлементыФормы.Файлы.ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	Ответ = Вопрос("Вы уверены, что хотите удалить файл?", РежимДиалогаВопрос.ОКОтмена);
	Если Ответ = КодВозвратаДиалога.ОК Тогда
		ИмяФайла = ЭлементыФормы.Файлы.ТекущаяСтрока.ПолноеИмяФайла;
		Файл = Новый Файл(ИмяФайла);
		Если Файл.Существует() Тогда
			УдалитьФайлы(Файл.ПолноеИмя);
		КонецЕсли; 
		ОбновитьТаблицуФайлов();
	КонецЕсли;
	
КонецПроцедуры

Процедура ДействияФормыИТС(Кнопка)
	
	ЗапуститьПриложение("https://its.1c.ru/db/metod8dev/content/1591/hdoc/_top/1cv8.pfl");

КонецПроцедуры

Процедура ДействияФормыВыгрузитьФайлы(Кнопка)
	
	РезультатВыбора = ирОбщий.ВыбратьФайлЛкс(Ложь, "zip", "Архив файлов настроек клиента 1С");
	Если РезультатВыбора <> Неопределено Тогда
		ВременныйКаталог = ПолучитьИмяВременногоФайла();
		СоздатьКаталог(ВременныйКаталог);
		Для Каждого ПомеченнаяСтрока Из Файлы.НайтиСтроки(Новый Структура("Пометка", Истина)) Цикл
			ИмяФайлаПриемника = ВременныйКаталог + "\" + ПомеченнаяСтрока.ЛогическийПуть;
			СоздатьКаталог(ИмяФайлаПриемника);
			КопироватьФайл(ПомеченнаяСтрока.ПолноеИмяФайла, ИмяФайлаПриемника + "\" + ПомеченнаяСтрока.КраткоеИмяФайла);
		КонецЦикла;
		Архив = Новый ЗаписьZipФайла(РезультатВыбора);
		Архив.Добавить(ВременныйКаталог + "\*.*", РежимСохраненияПутейZIP.СохранятьОтносительныеПути, РежимОбработкиПодкаталоговZIP.ОбрабатыватьРекурсивно);
		Архив.Записать();
		УдалитьФайлы(ВременныйКаталог);
	КонецЕсли; 
	
КонецПроцедуры

Процедура ДействияФормыЗагрузитьФайлы(Кнопка)

	РезультатВыбора = ирОбщий.ВыбратьФайлЛкс(Истина, "zip", "Архив файлов настроек клиента 1С");
	Если РезультатВыбора <> Неопределено Тогда
		Архив = Новый ЧтениеZipФайла(РезультатВыбора);
		Для Каждого СтрокаФайла Из Файлы Цикл
			СтрокаФайла.Пометка = Ложь;
		КонецЦикла;
		ЕстьНастройкиКонфигуратора = Ложь;
		Для Каждого ЭлементАрхива Из Архив.Элементы Цикл
			СтрокаФайла = Файлы.НайтиСтроки(Новый Структура("ЛогическийПуть, КраткоеИмяФайла", ирОбщий.ПолучитьСтрокуБезКонцаЛкс(ЭлементАрхива.Путь, 1), ЭлементАрхива.Имя));
			Если СтрокаФайла.Количество() > 0 Тогда
				СтрокаФайла = СтрокаФайла[0];
				СтрокаФайла.Пометка = Истина;
				Если Найти(СтрокаФайла.Описание, "конфигуратор") > 0 Тогда
					ЕстьНастройкиКонфигуратора = Истина;
				КонецЕсли; 
			Иначе
				Сообщить("Файлу настроек " + ЭлементАрхива.ПолноеИмя + " из архива не найдено сопоставление");
			КонецЕсли; 
		КонецЦикла;
		Если ЕстьНастройкиКонфигуратора Тогда
			Ответ = Вопрос("Перед загрузкой настроек конфигуратора необходимо закрыть все конфигураторы под текущим пользователем ОС. Продолжить?", РежимДиалогаВопрос.ОКОтмена);
			Если Ответ <> КодВозвратаДиалога.ОК Тогда
				Возврат;
			КонецЕсли;
		КонецЕсли; 
		Ответ = Вопрос("Будут заменены " + Файлы.НайтиСтроки(Новый Структура("Пометка", Истина)).Количество() + " файлов настроек (обозначены пометками). Продолжить?", РежимДиалогаВопрос.ОКОтмена);
		Если Ответ <> КодВозвратаДиалога.ОК Тогда
			Возврат;
		КонецЕсли;
		ВременныйКаталог = ПолучитьИмяВременногоФайла();
		СоздатьКаталог(ВременныйКаталог);
		Архив.ИзвлечьВсе(ВременныйКаталог);
		Для Каждого ЭлементАрхива Из Архив.Элементы Цикл
			СтрокаФайла = Файлы.НайтиСтроки(Новый Структура("ЛогическийПуть, КраткоеИмяФайла", ирОбщий.ПолучитьСтрокуБезКонцаЛкс(ЭлементАрхива.Путь, 1), ЭлементАрхива.Имя));
			Если СтрокаФайла.Количество() > 0 Тогда
				СтрокаФайла = СтрокаФайла[0];
				КопироватьФайл(ВременныйКаталог + "\" + ЭлементАрхива.Путь + ЭлементАрхива.Имя, СтрокаФайла.ПолноеИмяФайла);
			КонецЕсли; 
		КонецЦикла;
		УдалитьФайлы(ВременныйКаталог);
		ОбновитьТаблицуФайлов();
	КонецЕсли; 
	
КонецПроцедуры

Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	ирОбщий.ФормаОбработкаОповещенияЛкс(ЭтаФорма, ИмяСобытия, Параметр, Источник); 
	
КонецПроцедуры

Процедура КПФайлыВсеНастройкиКонфигуратора(Кнопка)
	
	Для Каждого СтрокаФайла Из Файлы Цикл
		СтрокаФайла.Пометка = Ложь;
	КонецЦикла;  
	Для Каждого СтрокаФайла Из Файлы Цикл
		Если Найти(СтрокаФайла.Описание, "конфигуратор") > 0 Тогда
			СтрокаФайла.Пометка = Истина;
		КонецЕсли; 
	КонецЦикла;  
	
КонецПроцедуры

Процедура ИдентификаторБазыНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	ФормаВыбора = ирОбщий.ПолучитьФормуЛкс("Обработка.ирПлатформа.Форма.СписокБазПользователяОС");
	ФормаВыбора.РежимВыбора = Истина;
	ФормаВыбора.НачальноеЗначениеВыбора = Элемент.Значение;
	РезультатВыбора = ФормаВыбора.ОткрытьМодально();
	Если РезультатВыбора <> Неопределено Тогда
		УстановитьПараметрыВыбраннойБазы(РезультатВыбора);
	КонецЕсли; 
	
КонецПроцедуры

Процедура ИдентификаторПользователя1СНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	Если База <> ирКэш.КлючБазыВСпискеПользователяИзКоманднойСтрокиЛкс() Тогда
		Возврат;
	КонецЕсли; 
	ФормаВыбора = ирОбщий.ПолучитьФормуЛкс("Обработка.ирРедакторПользователей.Форма",, Элемент);
	ФормаВыбора.РежимВыбора = Истина;
	ФормаВыбора.НачальноеЗначениеВыбора = Элемент.Значение;
	РезультатВыбора = ФормаВыбора.ОткрытьМодально();
	Если РезультатВыбора <> Неопределено Тогда
		ЭтотОбъект.Пользователь1С = РезультатВыбора;
		УстановитьПараметрыПользователя1С();
		ОбновитьТаблицуФайлов();
	КонецЕсли; 
	
КонецПроцедуры

Процедура КПФайлыОтборБезЗначенияВТекущейКолонке(Кнопка)
	
	ирОбщий.ТабличноеПоле_ОтборБезЗначенияВТекущейКолонке_КнопкаЛкс(ЭлементыФормы.Файлы);
	
КонецПроцедуры

Процедура КПФайлыОткрытьМенеджерТабличногоПоля(Кнопка)
	
	ирОбщий.ОткрытьМенеджерТабличногоПоляЛкс(ЭлементыФормы.Файлы, ЭтаФорма);
	
КонецПроцедуры

Процедура КаталогКэшейБазыОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ЗапуститьПриложение(Элемент.Значение);
	
КонецПроцедуры

Процедура КаталогБазыОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ЗапуститьПриложение(Элемент.Значение);

КонецПроцедуры

Процедура КаталогПользователя1СОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ЗапуститьПриложение(Элемент.Значение);

КонецПроцедуры

Процедура КПФайлыСравнить(Кнопка)
	
	ирОбщий.СравнитьСодержимоеЭлементаУправленияЛкс(ЭлементыФормы.Файлы);
	
КонецПроцедуры

Процедура ФайлыПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	
	Если ДанныеСтроки.Пометка Тогда
		ОформлениеСтроки.ЦветФона = ирОбщий.ЦветФонаАкцентаЛкс();
	КонецЕсли; 
	
КонецПроцедуры

Процедура КПФайлыСнятьФлажки(Кнопка)
	
	ирОбщий.ИзменитьПометкиВыделенныхИлиОтобранныхСтрокЛкс(ЭлементыФормы.Файлы,, Ложь);
	
КонецПроцедуры

Процедура КПФайлыУстановитьФлажки(Кнопка)
	
	ирОбщий.ИзменитьПометкиВыделенныхИлиОтобранныхСтрокЛкс(ЭлементыФормы.Файлы,, Истина);
	
КонецПроцедуры

ирОбщий.ИнициализироватьФормуЛкс(ЭтаФорма, "Обработка.ирУправлениеПрофайлами1С.Форма.Форма");
