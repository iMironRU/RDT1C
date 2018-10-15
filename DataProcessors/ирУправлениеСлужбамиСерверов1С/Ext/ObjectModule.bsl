﻿//ирПортативный Перем ирПортативный Экспорт;
//ирПортативный Перем ирОбщий Экспорт;
//ирПортативный Перем ирСервер Экспорт;
//ирПортативный Перем ирКэш Экспорт;
//ирПортативный Перем ирПривилегированный Экспорт;

Перем мПлатформа;
Перем мТипыСлужб Экспорт;

// "C:\Program Files\1cv8\current\bin\ras.exe" cluster --service --port=1545 localhost:2540
// "C:\Program Files\1cv8\current\bin\dbgs.exe" --service -p 2610"
// "C:\Program Files\1cv8\current\bin\crserver.exe" -srvc -port 1542 -d e:\storage83\

Функция ПрименитьИзменения() Экспорт
	
	Для Каждого ТипСлужбы Из мТипыСлужб Цикл
		ТаблицаСлужб = ЭтотОбъект[ТипСлужбы.Значение.ИмяТабличнойЧасти];
		Для Каждого СтрокаСлужбы Из ТаблицаСлужб Цикл
			ОбновитьСлужбуПоСтроке(СтрокаСлужбы);
		КонецЦикла;
	КонецЦикла;
	Возврат Истина;
		
КонецФункции

Процедура ОбновитьСлужбуПоСтроке(СтрокаСлужбы)
	
		#Если Сервер И Не Сервер Тогда
		    СтрокаСлужбы = СлужбыАгентовСерверов.Добавить();
		#КонецЕсли
	СлужбаWMI = ирКэш.ПолучитьCOMОбъектWMIЛкс(Компьютер);
	Если СлужбаWMI = Неопределено Тогда
		Возврат;
	КонецЕсли; 	
	АктуальныеСлужбы = СлужбаWMI.ExecQuery("SELECT * 
	|FROM Win32_Service
	|WHERE NAME = '" + СтрокаСлужбы.Имя + "'");
	АктуальнаяСлужба = Неопределено;
	Для Каждого АктуальнаяСлужба Из АктуальныеСлужбы Цикл
		Прервать;
	КонецЦикла;
	Команда = "sc \\" + Компьютер;
	ИмяСлужбы = СтрокаСлужбы.Имя;
	Если Ложь
		Или Не ЗначениеЗаполнено(ИмяСлужбы)
		Или ирОбщий.СтрокиРавныЛкс("<Авто>", ИмяСлужбы)
	Тогда
		Порт = ПортСтрокиСлужбы(СтрокаСлужбы);
		ПортСтрока = XMLСтрока(Порт);
		ИмяСлужбы = мТипыСлужб[СтрокаСлужбы.ТипСлужбы].ИмяПоУмолчанию + " " + ПортСтрока;
	КонецЕсли;
	ТекстИмяСлужбы = """" + ИмяСлужбы + """";
	Если СтрокаСлужбы.Удалить Тогда
		Команда = Команда + " delete " + ТекстИмяСлужбы;
	Иначе
		ОбновитьСтрокуЗапускаСлужбы(СтрокаСлужбы);
		СтрокаЗапускаНовая = СтрокаСлужбы.СтрокаЗапускаНовая;
		ПредставлениеСлужбы = СтрокаСлужбы.Представление;
		Если Ложь
			Или Не ЗначениеЗаполнено(ПредставлениеСлужбы)
			Или ирОбщий.СтрокиРавныЛкс("<Авто>", ПредставлениеСлужбы)
		Тогда
			ПредставлениеСлужбы = мТипыСлужб[СтрокаСлужбы.ТипСлужбы].ПредставлениеПоУмолчанию + " " + ПортСтрока;
		КонецЕсли;
		ПредставлениеСлужбы = """" + ПредставлениеСлужбы + """";
		//Если УдалитьСуществующуюПоИмени Тогда
		//	Команда = "sc delete " + ТекстИмяСлужбы;
		//	Результат = ирОбщий.ПолучитьТекстРезультатаКомандыОСЛкс(Команда);
		//	Сообщить(Результат);
		//КонецЕсли;
		Если АктуальнаяСлужба = Неопределено Тогда
			ТипОперации = "create";
		Иначе
			ТипОперации = "config";
		КонецЕсли; 
		Если СтрокаСлужбы.Автозапуск Тогда
			РежимЗапускаСлужбы = "auto";
		Иначе
			РежимЗапускаСлужбы = "demand";
		КонецЕсли; 
		Команда = Команда + " " + ТипОперации + " " + ТекстИмяСлужбы + " binPath= """ + СтрЗаменить(СтрокаЗапускаНовая, """", "\""") + """ start= " + РежимЗапускаСлужбы + " displayname= " + ТекстИмяСлужбы 
		+ " depend= Dnscache/Tcpip/lanmanworkstation/lanmanserver displayname= " + ПредставлениеСлужбы;
		Если ЗначениеЗаполнено(СтрокаСлужбы.ПарольПользователя) Тогда
			Команда = Команда + " obj= " + СтрокаСлужбы.ИмяПользователя + " password= " + СтрокаСлужбы.ПарольПользователя;
		КонецЕсли; 
	КонецЕсли; 
	Результат = ирОбщий.ПолучитьТекстРезультатаКомандыОСЛкс(Команда,,, Истина);
	Если Не ЗначениеЗаполнено(Результат) Тогда
		Результат = "Не удалось получить результат обработки службы";
	КонецЕсли;
	Сообщить("Результат обновления службы """ + ИмяСлужбы + """: " + СокрЛП(Результат));
	//Если ЗапуститьСразу Тогда
	//	Команда = "net start " + ТекстИмяСлужбы;
	//	Результат = ирОбщий.ПолучитьТекстРезультатаКомандыОСЛкс(Команда);
	//	Сообщить(Результат);
	//КонецЕсли;

КонецПроцедуры

Функция ПолноеИмяИсполняемогоФайла(СтрокаСлужбы, выхКаталогИсполняемыхФайлов = "")
	
	#Если Сервер И Не Сервер Тогда
		СтрокаСлужбы = Обработки.ирУправлениеСлужбамиСерверов1С.Создать().СлужбыАгентовСерверов.Добавить();
	#КонецЕсли
	КраткоеИмяИсполняемогоФайла = мТипыСлужб[СтрокаСлужбы.ТипСлужбы].ИмяИсполняемогоФайла;
	ОтборВерсий = Новый Структура(СтрокаСлужбы.ТипСлужбы + ", КлючСборки", Истина, СтрокаСлужбы.СборкаПлатформыНовая);
	ПодходящиеВерсии = СборкиПлатформы.Выгрузить(ОтборВерсий);
	ПодходящиеВерсии.Сортировать("x64 Убыв");
	Если ПодходящиеВерсии.Количество() > 0 Тогда
		выхКаталогИсполняемыхФайлов = ПодходящиеВерсии[0].Каталог;
	Иначе
		выхКаталогИсполняемыхФайлов = СтрокаСлужбы.СборкаПлатформыНовая;
	КонецЕсли; 
	ирОбщий.ДобавитьЕслиНужноПравыйСлешВФайловыйПутьЛкс(выхКаталогИсполняемыхФайлов);
	СтрокаЗапускаНовая = """" + выхКаталогИсполняемыхФайлов + "bin\" + КраткоеИмяИсполняемогоФайла + """";
	Возврат СтрокаЗапускаНовая;

КонецФункции

Процедура ОбновитьСтрокуЗапускаСлужбы(Знач СтрокаСлужбы) Экспорт 
	
	#Если Сервер И Не Сервер Тогда
	    СтрокаСлужбы = Обработки.ирУправлениеСлужбамиСерверов1С.Создать().СлужбыАгентовСерверов.Добавить();
	#КонецЕсли
	КаталогИсполняемыхФайлов = Неопределено;
    СтрокаЗапускаНовая = ПолноеИмяИсполняемогоФайла(СтрокаСлужбы, КаталогИсполняемыхФайлов);
	Порт = ПортСтрокиСлужбы(СтрокаСлужбы);
	ПортСлужбы = XMLСтрока(Порт);
	Если СтрокаСлужбы.ТипСлужбы = мТипыСлужб.АгентСервера.ТипСлужбы Тогда
		НачальныйПортРабочихПроцессов = СтрокаСлужбы.НачальныйПортРабочихПроцессов;
		Если Ложь
			Или Не ЗначениеЗаполнено(НачальныйПортРабочихПроцессов)
			Или ирОбщий.СтрокиРавныЛкс("<Авто>", НачальныйПортРабочихПроцессов)
		Тогда
			НачальныйПортРабочихПроцессов = Порт + 20;
		КонецЕсли; 
		КонечныйПортРабочихПроцессов = СтрокаСлужбы.КонечныйПортРабочихПроцессов;
		Если Ложь
			Или Не ЗначениеЗаполнено(КонечныйПортРабочихПроцессов)
			Или ирОбщий.СтрокиРавныЛкс("<Авто>", КонечныйПортРабочихПроцессов)
		Тогда
			КонечныйПортРабочихПроцессов = Порт + 51;
		КонецЕсли; 
		ПортКластера = XMLСтрока(Порт + 1);
		КаталогКонфигурации = СтрокаСлужбы.КаталогКонфигурации;
		Если Ложь
			Или Не ЗначениеЗаполнено(КаталогКонфигурации)
			Или ирОбщий.СтрокиРавныЛкс("<Авто>", КаталогКонфигурации)
		Тогда
			ФайлКаталогаВерсии = Новый Файл(КаталогИсполняемыхФайлов);
			КаталогКонфигурации = ФайлКаталогаВерсии.Путь + "srvinfo" + XMLСтрока(ПортСлужбы);
		КонецЕсли;
		СоздатьКаталог(КаталогКонфигурации);
		ДиапазонПортов = XMLСтрока(НачальныйПортРабочихПроцессов) + ":" + XMLСтрока(КонечныйПортРабочихПроцессов);
		СтрокаЗапускаНовая = СтрокаЗапускаНовая + " -srvc -agent -regport " + ПортКластера + " -port " + ПортСлужбы + " -range " + ДиапазонПортов + " -d """ + КаталогКонфигурации + """";
		Если СтрокаСлужбы.РежимОтладки = "tcp" Тогда
			СтрокаЗапускаНовая = СтрокаЗапускаНовая + " -debug";
		ИначеЕсли СтрокаСлужбы.РежимОтладки = "http" Тогда
			СтрокаЗапускаНовая = СтрокаЗапускаНовая + " -debug -http";
			Если ЗначениеЗаполнено(СтрокаСлужбы.СерверОтладкиАдрес) Тогда
				СтрокаЗапускаНовая = СтрокаЗапускаНовая + " -debugServerAddr " + СтрокаСлужбы.СерверОтладкиАдрес;
			КонецЕсли; 
			Если ЗначениеЗаполнено(СтрокаСлужбы.СерверОтладкиПорт) Тогда
				СтрокаЗапускаНовая = СтрокаЗапускаНовая + " -debugServerPort " + XMLСтрока(СтрокаСлужбы.СерверОтладкиПорт);
			КонецЕсли; 
			Если ЗначениеЗаполнено(СтрокаСлужбы.СерверОтладкиПароль) Тогда
				СтрокаЗапускаНовая = СтрокаЗапускаНовая + " -debugServerPwd " + СтрокаСлужбы.СерверОтладкиПароль;
			КонецЕсли; 
		КонецЕсли;
	ИначеЕсли СтрокаСлужбы.ТипСлужбы = мТипыСлужб.СерверАдминистрирования.ТипСлужбы Тогда
		Если СтрокаСлужбы.РежимКластера Тогда
			СтрокаЗапускаНовая = СтрокаЗапускаНовая + " cluster";
		КонецЕсли; 
		СтрокаЗапускаНовая = СтрокаЗапускаНовая + " --service --port=" + ПортСлужбы + " " + СтрокаСлужбы.СтрокаСоединенияАгентаСервера;
	ИначеЕсли СтрокаСлужбы.ТипСлужбы = мТипыСлужб.СерверОтладки.ТипСлужбы Тогда
		СтрокаЗапускаНовая = СтрокаЗапускаНовая + " --service -p " + ПортСлужбы;
	ИначеЕсли СтрокаСлужбы.ТипСлужбы = мТипыСлужб.СерверХранилища.ТипСлужбы Тогда
		СтрокаЗапускаНовая = СтрокаЗапускаНовая + " -srvc -port " + ПортСлужбы + " -d """ + СтрокаСлужбы.КаталогХранилища + """";
	КонецЕсли; 
	СтрокаСлужбы.СтрокаЗапускаНовая = СтрокаЗапускаНовая;

КонецПроцедуры

Функция ПортСтрокиСлужбы(Знач СтрокаСлужбы) Экспорт 
	
	#Если Сервер И Не Сервер Тогда
	    СтрокаСлужбы = Обработки.ирУправлениеСлужбамиСерверов1С.Создать().СлужбыАгентовСерверов.Добавить();
	#КонецЕсли
	Порт = СтрокаСлужбы.Порт;
	Если Не ЗначениеЗаполнено(Порт) Тогда
		Порт = мТипыСлужб[СтрокаСлужбы.ТипСлужбы].ПортПоУмолчанию;
	КонецЕсли;
	Возврат Порт;

КонецФункции

Процедура Заполнить() Экспорт 

	ирОбщий.ЗаполнитьДоступныеСборкиПлатформыЛкс(СборкиПлатформы, Компьютер);
	СлужбыАгентовСерверов.Очистить();
	СлужбыСерверовАдминистрирования.Очистить();
	СлужбыСерверовОтладки.Очистить();
	СлужбыХранилищКонфигураций.Очистить();
	СлужбаWMI = ирКэш.ПолучитьCOMОбъектWMIЛкс(Компьютер);
	Если СлужбаWMI = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	
	// СлужбыАгентовСерверов
	АктуальныеСлужбы = СлужбаWMI.ExecQuery("SELECT 
		|* 
		|FROM Win32_Service
		|WHERE PathName LIKE '%" + мТипыСлужб.АгентСервера.ИмяИсполняемогоФайла + "%'
		|AND PathName LIKE '%-srvc -agent%'");
	Для Каждого АктуальнаяСлужба Из АктуальныеСлужбы Цикл
		СтрокаСлужбы = ДобавитьЗаполнитьСтрокуСлужбы(СлужбыАгентовСерверов, АктуальнаяСлужба);
			#Если Сервер И Не Сервер Тогда
			    СтрокаСлужбы = СлужбыАгентовСерверов.Добавить();
			#КонецЕсли
		СтрокаСлужбы.ТипСлужбы = мТипыСлужб.АгентСервера.ТипСлужбы;
		СтрокаЗапускаСлужбы = АктуальнаяСлужба.PathName;
		МаркерПорт = " -port ";
		Если Найти(НРег(СтрокаЗапускаСлужбы), МаркерПорт) > 0 Тогда
			СтрокаСлужбы.Порт = Число(ирОбщий.ПолучитьСтрокуМеждуМаркерамиЛкс(НРег(СтрокаЗапускаСлужбы), МаркерПорт, " ", Ложь));
		КонецЕсли; 
		СтрокаДиапазона = ирОбщий.ПолучитьСтрокуМеждуМаркерамиЛкс(НРег(СтрокаЗапускаСлужбы), "-range ", " ", Ложь);
		Если ЗначениеЗаполнено(СтрокаДиапазона) Тогда
			ФрагментыДиапазона = ирОбщий.ПолучитьМассивИзСтрокиСРазделителемЛкс(СтрокаДиапазона, ":");
			СтрокаСлужбы.НачальныйПортРабочихПроцессов = Число(ФрагментыДиапазона[0]);
			СтрокаСлужбы.КонечныйПортРабочихПроцессов = Число(ФрагментыДиапазона[1]);
		КонецЕсли; 
		СтрокаСлужбы.КаталогКонфигурации = ирОбщий.ПолучитьСтрокуМеждуМаркерамиЛкс(СтрокаЗапускаСлужбы, "-d """, """"); // Регистрозависимость маркера не убрана!
		Если Не ЗначениеЗаполнено(СтрокаСлужбы.КаталогКонфигурации) Тогда
			СтрокаСлужбы.КаталогКонфигурации = ирОбщий.ПолучитьСтрокуМеждуМаркерамиЛкс(СтрокаЗапускаСлужбы, " -d ", " ");
		КонецЕсли; 
		СтрокаСлужбы.РежимОтладки = ирОбщий.РежимОтладкиИзКоманднойСтрокиЛкс(СтрокаЗапускаСлужбы);
		СтрокаСлужбы.СерверОтладкиАдрес = ирОбщий.ПолучитьСтрокуМеждуМаркерамиЛкс(Нрег(СтрокаЗапускаСлужбы), НРег("-debugServerAddr "), " ", Ложь);
		СтрокаСлужбы.СерверОтладкиПорт = ирОбщий.ПолучитьСтрокуМеждуМаркерамиЛкс(Нрег(СтрокаЗапускаСлужбы), НРег("-debugServerPort "), " ", Ложь);
		СтрокаСлужбы.СерверОтладкиПароль = ирОбщий.ПолучитьСтрокуМеждуМаркерамиЛкс(Нрег(СтрокаЗапускаСлужбы), НРег("-debugServerPwd "), " ", Ложь);
	КонецЦикла; 
	СлужбыАгентовСерверов.Сортировать("Имя");

	// СлужбыАдминистрированияСерверов
	// "C:\Program Files\1cv8\current\bin\ras.exe" cluster --service --port=1545 localhost:2540
	АктуальныеСлужбы = СлужбаWMI.ExecQuery("SELECT 
		|* 
		|FROM Win32_Service
		|WHERE PathName LIKE '%" + мТипыСлужб.СерверАдминистрирования.ИмяИсполняемогоФайла + "%'");
	Для Каждого АктуальнаяСлужба Из АктуальныеСлужбы Цикл
		СтрокаСлужбы = ДобавитьЗаполнитьСтрокуСлужбы(СлужбыСерверовАдминистрирования, АктуальнаяСлужба);
			#Если Сервер И Не Сервер Тогда
			    СтрокаСлужбы = СлужбыСерверовАдминистрирования.Добавить();
			#КонецЕсли
		СтрокаСлужбы.ТипСлужбы = мТипыСлужб.СерверАдминистрирования.ТипСлужбы;
		СтрокаЗапускаСлужбы = СокрЛП(АктуальнаяСлужба.PathName);
		МаркерПорт = " --port=";
		Если Найти(НРег(СтрокаЗапускаСлужбы), МаркерПорт) > 0 Тогда
			СтрокаСлужбы.Порт = Число(ирОбщий.ПолучитьСтрокуМеждуМаркерамиЛкс(НРег(СтрокаЗапускаСлужбы), МаркерПорт, " ", Ложь));
		КонецЕсли; 
		МаркерПорт = " -p="; // альтернативный
		Если Найти(НРег(СтрокаЗапускаСлужбы), МаркерПорт) > 0 Тогда
			СтрокаСлужбы.Порт = Число(ирОбщий.ПолучитьСтрокуМеждуМаркерамиЛкс(НРег(СтрокаЗапускаСлужбы), МаркерПорт, " ", Ложь));
		КонецЕсли; 
		СтрокаСлужбы.РежимКластера = Найти(НРег(СтрокаЗапускаСлужбы), " cluster ") > 0;
		Фрагменты = ирОбщий.ПолучитьМассивИзСтрокиСРазделителемЛкс(СтрокаЗапускаСлужбы, " ", Истина);
		СтрокаСлужбы.СтрокаСоединенияАгентаСервера = Фрагменты[Фрагменты.ВГраница()];
	КонецЦикла; 
	СлужбыАгентовСерверов.Сортировать("Имя");
	
	// СлужбыСерверовОтладки
	// "C:\Program Files\1cv8\current\bin\dbgs.exe --service -p 2610"
	АктуальныеСлужбы = СлужбаWMI.ExecQuery("SELECT 
		|* 
		|FROM Win32_Service
		|WHERE PathName LIKE '%" + мТипыСлужб.СерверОтладки.ИмяИсполняемогоФайла + "%'");
	Для Каждого АктуальнаяСлужба Из АктуальныеСлужбы Цикл
		СтрокаСлужбы = ДобавитьЗаполнитьСтрокуСлужбы(СлужбыСерверовОтладки, АктуальнаяСлужба);
			#Если Сервер И Не Сервер Тогда
			    СтрокаСлужбы = СлужбыСерверовОтладки.Добавить();
			#КонецЕсли
		СтрокаСлужбы.ТипСлужбы = мТипыСлужб.СерверОтладки.ТипСлужбы;
		СтрокаЗапускаСлужбы = СокрЛП(АктуальнаяСлужба.PathName);
		МаркерПорт = " -p ";
		Если Найти(НРег(СтрокаЗапускаСлужбы), МаркерПорт) > 0 Тогда
			СтрокаСлужбы.Порт = Число(ирОбщий.ПолучитьСтрокуМеждуМаркерамиЛкс(НРег(СтрокаЗапускаСлужбы), МаркерПорт, " ", Истина));
		КонецЕсли; 
	КонецЦикла; 
	СлужбыАгентовСерверов.Сортировать("Имя");

	// СлужбыХранилищКонфигураций
	// "C:\Program Files\1cv8\current\bin\crserver.exe" -srvc -port 1542 -d e:\storage83\
	АктуальныеСлужбы = СлужбаWMI.ExecQuery("SELECT 
		|* 
		|FROM Win32_Service
		|WHERE PathName LIKE '%" + мТипыСлужб.СерверХранилища.ИмяИсполняемогоФайла + "%'");
	Для Каждого АктуальнаяСлужба Из АктуальныеСлужбы Цикл
		СтрокаСлужбы = ДобавитьЗаполнитьСтрокуСлужбы(СлужбыХранилищКонфигураций, АктуальнаяСлужба);
			#Если Сервер И Не Сервер Тогда
			    СтрокаСлужбы = СлужбыХранилищКонфигураций.Добавить();
			#КонецЕсли
		СтрокаСлужбы.ТипСлужбы = мТипыСлужб.СерверХранилища.ТипСлужбы;
		СтрокаЗапускаСлужбы = СокрЛП(АктуальнаяСлужба.PathName);
		МаркерПорт = " -port ";
		Если Найти(НРег(СтрокаЗапускаСлужбы), МаркерПорт) > 0 Тогда
			СтрокаСлужбы.Порт = Число(ирОбщий.ПолучитьСтрокуМеждуМаркерамиЛкс(НРег(СтрокаЗапускаСлужбы), МаркерПорт, " ", Ложь));
		КонецЕсли; 
		СтрокаСлужбы.КаталогХранилища = ирОбщий.ПолучитьСтрокуМеждуМаркерамиЛкс(СтрокаЗапускаСлужбы, "-d """, """"); // Регистрозависимость маркера не убрана!
		Если Не ЗначениеЗаполнено(СтрокаСлужбы.КаталогХранилища) Тогда
			СтрокаСлужбы.КаталогХранилища = ирОбщий.ПолучитьСтрокуМеждуМаркерамиЛкс(СтрокаЗапускаСлужбы, " -d ", " ");
		КонецЕсли; 
	КонецЦикла; 
	СлужбыАгентовСерверов.Сортировать("Имя");

КонецПроцедуры

Функция ДобавитьЗаполнитьСтрокуСлужбы(ТаблицаСлужб, Знач АктуальнаяСлужба)
	
		#Если Сервер И Не Сервер Тогда
		    ТаблицаСлужб = ЭтотОбъект.СлужбыСерверовОтладки;
		#КонецЕсли
	СтрокаЗапускаСлужбы = АктуальнаяСлужба.PathName;
	СтрокаСлужбы = ТаблицаСлужб.Добавить();
	СтрокаСлужбы.Имя = АктуальнаяСлужба.Name;
	СтрокаСлужбы.СтрокаЗапускаСлужбы = СтрокаЗапускаСлужбы;
	СтрокаЗапускаСлужбы = СтрЗаменить(СтрокаЗапускаСлужбы + " ", " /", " -");
	Если ЗначениеЗаполнено(АктуальнаяСлужба.ProcessId) Тогда
		АктивныйПроцесс = ирОбщий.ПолучитьПроцессОСЛкс(АктуальнаяСлужба.ProcessId);
		Если ТипЗнч(АктивныйПроцесс) <> Тип("Строка") Тогда
			СтрокаСлужбы.СтрокаЗапускаАктивная = АктивныйПроцесс.CommandLine;
			СтрокаСлужбы.ПараметрыИзменены = Не ирОбщий.СтрокиРавныЛкс(СтрокаСлужбы.СтрокаЗапускаАктивная, СтрокаСлужбы.СтрокаЗапускаСлужбы);
		КонецЕсли; 
	КонецЕсли; 
	СтрокаСлужбы.Представление = АктуальнаяСлужба.Caption;
	СтрокаСлужбы.ИмяПользователя = АктуальнаяСлужба.StartName;
	СтрокаСлужбы.ИдентификаторПроцесса = АктуальнаяСлужба.ProcessId;
	СтрокаСлужбы.Выполняется = ирОбщий.СтрокиРавныЛкс(АктуальнаяСлужба.State, "Running");
	СтрокаСлужбы.Автозапуск = ирОбщий.СтрокиРавныЛкс(АктуальнаяСлужба.StartMode, "Auto");
	СтрокаСлужбы.СборкаПлатформыНовая = ПолучитьСборкуПлатформуИзКоманднойСтроки(СтрокаЗапускаСлужбы);
	Если ЗначениеЗаполнено(СтрокаСлужбы.ИдентификаторПроцесса) Тогда
		АктивныйПроцесс = ирОбщий.ПолучитьПроцессОСЛкс(АктуальнаяСлужба.ProcessId, , Компьютер);
		СтрокаЗапускаПроцесса = АктивныйПроцесс.CommandLine;
	Иначе
		АктивныйПроцесс = Неопределено;
	КонецЕсли; 
	Если АктивныйПроцесс <> Неопределено И ТипЗнч(СтрокаЗапускаПроцесса) = Тип("Строка") Тогда 
		СтрокаСлужбы.СборкаПлатформыАктивная = ПолучитьСборкуПлатформуИзКоманднойСтроки(СтрокаЗапускаПроцесса);
	КонецЕсли;
	Возврат СтрокаСлужбы;

КонецФункции

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Отказ = Ложь;
	МассивИсключений = Новый Массив;
	МассивИсключений.Добавить("");
	МассивИсключений.Добавить("<Авто>");
	Для Каждого ТипСлужбы Из мТипыСлужб Цикл
		ТипСлужбы = ТипСлужбы.Значение;
		ИмяТабличнойЧасти = ТипСлужбы.ИмяТабличнойЧасти;
		ТаблицаСлужб = ЭтотОбъект[ИмяТабличнойЧасти];
		Отказ = Отказ Или Не ирОбщий.ПроверитьУникальностьСтрокТЧПоКолонкеЛкс(ЭтотОбъект, ИмяТабличнойЧасти, "Имя",,, МассивИсключений);
		Отказ = Отказ Или Не ирОбщий.ПроверитьУникальностьСтрокТЧПоКолонкеЛкс(ЭтотОбъект, ИмяТабличнойЧасти, "Представление",,, МассивИсключений);
		Отказ = Отказ Или Не ирОбщий.ПроверитьУникальностьСтрокТЧПоКолонкеЛкс(ЭтотОбъект, ИмяТабличнойЧасти, "Порт", , Новый Структура("Автозапуск, Удалить", Истина, Ложь));
		Если ТипСлужбы.ТипСлужбы = мТипыСлужб.СерверХранилища.ТипСлужбы Тогда
			Отказ = Отказ Или Не ирОбщий.ПроверитьУникальностьСтрокТЧПоКолонкеЛкс(ЭтотОбъект, ИмяТабличнойЧасти, "КаталогХранилища", , Новый Структура("Автозапуск, Удалить", Истина, Ложь));
		КонецЕсли; 
		Для Индекс = 0 По ТаблицаСлужб.Количество() - 1 Цикл
			СтрокаСлужбы = ТаблицаСлужб[Индекс];
			Если Не СтрокаСлужбы.Удалить Тогда
				МассивПутейКДанным = Новый Соответствие;
				Если ТипСлужбы.ТипСлужбы = мТипыСлужб.СерверХранилища.ТипСлужбы Тогда
					МассивПутейКДанным.Вставить(ИмяТабличнойЧасти + "[" + Индекс + "].КаталогХранилища");
				ИначеЕсли ТипСлужбы.ТипСлужбы = мТипыСлужб.СерверАдминистрирования.ТипСлужбы Тогда
					МассивПутейКДанным.Вставить(ИмяТабличнойЧасти + "[" + Индекс + "].СтрокаСоединенияАгентаСервера");
				КонецЕсли; 
				МассивПутейКДанным.Вставить(ИмяТабличнойЧасти + "[" + Индекс + "].СборкаПлатформыНовая");
				МассивПутейКДанным.Вставить(ИмяТабличнойЧасти + "[" + Индекс + "].Порт");
				ирОбщий.ПроверитьЗаполнениеРеквизитовОбъектаЛкс(ЭтотОбъект, МассивПутейКДанным, Отказ);
			КонецЕсли; 
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры

Функция ПолучитьWMIОбъектСлужбы(ИмяСлужбы, Компьютер = Неопределено, ВызыватьИсключениеЕслиНеНайдена = Истина) Экспорт 
	
	СлужбаWMI = ирКэш.ПолучитьCOMОбъектWMIЛкс(Компьютер);
	Если СлужбаWMI = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли; 
	ТекстЗапросаWQL = "Select * from Win32_Service Where Name = '" + ИмяСлужбы + "'";
	ВыборкаСистемныхСлужб = СлужбаWMI.ExecQuery(ТекстЗапросаWQL);
	Для Каждого лСистемнаяСлужба Из ВыборкаСистемныхСлужб Цикл
		СистемнаяСлужба = лСистемнаяСлужба;
	КонецЦикла;
	Если СистемнаяСлужба = Неопределено Тогда 
		СистемнаяСлужба = "Системная служба с именем """ + ИмяСлужбы + """ не найдена на компьютере """ + Компьютер + """" ; // Сигнатура (начало строки) используется в Обработка.ПоддержаниеСервераПриложенийИис
		Если ВызыватьИсключениеЕслиНеНайдена Тогда
			ВызватьИсключение СистемнаяСлужба;
		КонецЕсли; 
	КонецЕсли;
	Возврат СистемнаяСлужба;

КонецФункции

Функция ПолучитьСборкуПлатформуИзКоманднойСтроки(Строка)
	
	#Если Сервер И Не Сервер Тогда
	    мПлатформа = Обработки.ирПлатформа.Создать();
	#КонецЕсли
	Результат = "";
	ВычислительРегулярок = мПлатформа.RegExp;
	ВычислительРегулярок.Pattern = """(.+\\\d+\.\d+\.\d+\.\d+\\)";
	Вхождения = ВычислительРегулярок.Execute(Строка);
	Если Вхождения.Count > 0 Тогда
		Результат = Вхождения.Item(0).Submatches(0);
	Иначе
		ВычислительРегулярок = мПлатформа.RegExp;
		ВычислительРегулярок.Pattern = """(.+\\)bin\\.*\.exe""";
		Вхождения = ВычислительРегулярок.Execute(Строка);
		Если Вхождения.Count > 0 Тогда
			Результат = Вхождения.Item(0).Submatches(0);
		КонецЕсли; 
	КонецЕсли; 
	Для Каждого СтрокаСборкаПлатформы Из СборкиПлатформы Цикл
		Если ирОбщий.СтрокиРавныЛкс(СтрокаСборкаПлатформы.Каталог, Результат) Тогда
			Результат = СтрокаСборкаПлатформы.КлючСборки;
			Прервать;
		КонецЕсли; 
	КонецЦикла;
	Возврат Результат;
	
КонецФункции

Функция ПолучитьПолноеИмяФайлаСпискаСерверов1С() Экспорт 
	
	КаталогФайловыхКэшей = ирКэш.КаталогИзданияПлатформыВПрофилеЛкс();
	ПолноеИмяФайлаСпискаСерверов = КаталогФайловыхКэшей + "\" + "appsrvrs.lst";
	Возврат ПолноеИмяФайлаСпискаСерверов;
	
КонецФункции

Функция ПолучитьТаблицуСерверовИзСпискаПользователя(ТаблицаСерверов = Неопределено) Экспорт 
	
	ТаблицаСерверовИзФайла = Новый ТаблицаЗначений;
	ТаблицаСерверовИзФайла.Колонки.Добавить("Протокол");
	ТаблицаСерверовИзФайла.Колонки.Добавить("Компьютер");
	ТаблицаСерверовИзФайла.Колонки.Добавить("НКомпьютер");
	ТаблицаСерверовИзФайла.Колонки.Добавить("Порт");
	ТаблицаСерверовИзФайла.Колонки.Добавить("Наименование");
	//ТаблицаСерверовИзФайла.Колонки.Добавить("ИзданиеПлатформы");
		ТаблицаСерверов.Колонки.Добавить("НКомпьютер");
		Для Каждого СтрокаСервера Из ТаблицаСерверов Цикл
			СтрокаСервера.НКомпьютер = НРег(СтрокаСервера.Компьютер);
		КонецЦикла;
		ПолноеИмяФайлаСпискаСерверов = ПолучитьПолноеИмяФайлаСпискаСерверов1С();
		Файл = Новый Файл(ПолноеИмяФайлаСпискаСерверов);
		Если Файл.Существует() Тогда
			ТекстовыйДокумент = Новый ТекстовыйДокумент;
			ТекстовыйДокумент.Прочитать(ПолноеИмяФайлаСпискаСерверов);
			ТекстФайла = ТекстовыйДокумент.ПолучитьТекст();
			// {2,
			// {"tcp","pcname",1540,""},
			// {"tcp","pcname",1740,""}
			// }
			ДокументDOM = ирОбщий.ПолучитьДокументDOMИзСтрокиВнутрЛкс(ТекстФайла);
			РазыменовательПИ = Новый РазыменовательПространствИменDOM(ДокументDOM);
			ИмяЭлемента = "/elem/elem";
			РезультатXPath = ДокументDOM.ВычислитьВыражениеXPath(ИмяЭлемента, ДокументDOM, РазыменовательПИ, ТипРезультатаDOMXPath.УпорядоченныйИтераторУзлов);
			Пока 1 = 1 Цикл
				Узел = РезультатXPath.ПолучитьСледующий();
				Если Узел = Неопределено Тогда
					Прервать;
				КонецЕсли;
				ДочерниеУзлы = Узел.ДочерниеУзлы;
				// Здесь есть пробельный узел, который сместит индексы н начиная с 2, если отключить игнорирование пробельных символов при построении документа DOM
				Порт = Вычислить(ДочерниеУзлы[2].ТекстовоеСодержимое);
				Компьютер = ирОбщий.ПолучитьПоследнийФрагментЛкс(Вычислить(ДочерниеУзлы[1].ТекстовоеСодержимое), "/"); // Имя компьютера может быть указано в виде "REMOTE/GOMER"
				КлючПоиска = Новый Структура("НКомпьютер, Порт", НРег(Компьютер), Порт); 
				Если ТаблицаСерверовИзФайла.НайтиСтроки(КлючПоиска).Количество() > 0 Тогда
					Продолжить;
				КонецЕсли; 
				ОписаниеСервера = ТаблицаСерверовИзФайла.Добавить();
				ЗаполнитьЗначенияСвойств(ОписаниеСервера, КлючПоиска); 
				ОписаниеСервера.Протокол = Вычислить(ДочерниеУзлы[0].ТекстовоеСодержимое);
				ОписаниеСервера.Компьютер = Компьютер;
				ОписаниеСервера.Наименование = Вычислить(ДочерниеУзлы[3].ТекстовоеСодержимое);
				Если Не ЗначениеЗаполнено(ОписаниеСервера.Наименование) Тогда
					ОписаниеСервера.Наименование = ОписаниеСервера.Компьютер + ":" + XMLСтрока(ОписаниеСервера.Порт);
				КонецЕсли; 
				СтрокиСервера = ТаблицаСерверов.НайтиСтроки(Новый Структура("НКомпьютер, Порт", ОписаниеСервера.НКомпьютер, ОписаниеСервера.Порт));
			КонецЦикла;
		КонецЕсли;
		Если ТаблицаСерверов <> Неопределено Тогда
			Для Каждого СтрокаСервера Из ТаблицаСерверов Цикл
				СтрокаСервераИзФайла = ТаблицаСерверовИзФайла.Добавить();
				ЗаполнитьЗначенияСвойств(СтрокаСервераИзФайла, СтрокаСервера); 
				СтрокаСервераИзФайла.Протокол = "tcp";
			КонецЦикла;
		КонецЕсли; 
	Возврат ТаблицаСерверовИзФайла;
		
КонецФункции

Процедура ПоместитьТаблицуСерверовВСписокПользователя(ТаблицаСерверов, ТекущаяСтрокаТаблицыСерверов = Неопределено) Экспорт

	#Если _ Тогда
		ТаблицаСерверов = Новый ТаблицаЗначений;
		ТаблицаСерверов.Колонки.Добавить("Протокол");
		ТаблицаСерверов.Колонки.Добавить("Компьютер");
		ТаблицаСерверов.Колонки.Добавить("Порт");
		ТаблицаСерверов.Колонки.Добавить("Наименование");
	#КонецЕсли
	// {2,
	// {"tcp","pyramid",1540,""},
	// {"tcp","pyramid",1740,""}
	// }
	Текст = "";
	Для Каждого СтрокаСервера Из ТаблицаСерверов Цикл
		Если Текст <> "" Тогда
			Текст = Текст + "," + Символы.ПС;
		КонецЕсли; 
		Текст = Текст + "{" 
			+ """" + СтрокаСервера.Протокол + ""","
			+ """" + СтрокаСервера.Компьютер + ""","
			+ XMLСтрока(СтрокаСервера.Порт) + ","
			+ """" + СтрокаСервера.Наименование + """"
			+ "}";
	КонецЦикла;
	Текст = "{" + XMLСтрока(ТаблицаСерверов.Количество()) + "," + Символы.ПС + Текст + "}";
	ПолноеИмяФайлаСпискаСерверов = ПолучитьПолноеИмяФайлаСпискаСерверов1С();
	Файл = Новый Файл(ПолноеИмяФайлаСпискаСерверов);
	ТекстовыйДокумент = Новый ТекстовыйДокумент;
	ТекстовыйДокумент.УстановитьТекст(Текст);
	ТекстовыйДокумент.Записать(ПолноеИмяФайлаСпискаСерверов);
	Если ТекущаяСтрокаТаблицыСерверов <> Неопределено Тогда
		УстановитьТекущийПутьВДеревеКонсолиСерверов(ТекущаяСтрокаТаблицыСерверов, ТаблицаСерверов);
	КонецЕсли; 

КонецПроцедуры

Процедура УстановитьТекущийПутьВДеревеКонсолиСерверов(ТекущаяСтрокаТаблицыСерверов, ТаблицаСерверов) Экспорт 
	
	МассивПути = ПолучитьМассивПутиКСсылкеВКонсолиСерверов(ТекущаяСтрокаТаблицыСерверов);
	ПолноеИмяФайлаНастроекКонсолиСерверов = ирОбщий.КаталогПеремещаемыхДанныхПриложенийЛкс() + "\Microsoft\MMC\1CV8 Servers";
	Файл = Новый Файл(ПолноеИмяФайлаНастроекКонсолиСерверов);
	Если Не Файл.Существует() Тогда
		Возврат;
	КонецЕсли; 
	ДокументDOM = ирОбщий.ПрочитатьФайлВДокументDOMЛкс(ПолноеИмяФайлаНастроекКонсолиСерверов);
	РазыменовательПИ = Новый РазыменовательПространствИменDOM(ДокументDOM);
	ИмяЭлемента = "/MMC_ConsoleFile/Views/View/BookMark[2]";
	РезультатXPath = ДокументDOM.ВычислитьВыражениеXPath(ИмяЭлемента, ДокументDOM, РазыменовательПИ);
	ЭлементДом = РезультатXPath.ПолучитьСледующий();
	КорневыеЭлементы = ЭлементДом.ПолучитьЭлементыПоИмени("DynamicPath");
	Если КорневыеЭлементы.Количество() > 0 Тогда
		КорневойЭлемент = КорневыеЭлементы[0];
	Иначе
		КорневойЭлемент = ДокументDOM.СоздатьЭлемент("DynamicPath");
		ЭлементДом.ДобавитьДочерний(КорневойЭлемент);
	КонецЕсли; 
	Пока КорневойЭлемент.ПервыйДочерний <> Неопределено Цикл
		КорневойЭлемент.УдалитьДочерний(КорневойЭлемент.ПервыйДочерний);
	КонецЦикла; 
	Для Каждого ЭлементПути Из МассивПути Цикл
		ЭлементСегмент = ДокументDOM.СоздатьЭлемент("Segment");
		ЭлементСегмент.УстановитьАтрибут("String", ЭлементПути);
		КорневойЭлемент.ДобавитьДочерний(ЭлементСегмент);
	КонецЦикла;
	ЗаписьXML = Новый ЗаписьXML;
	ЗаписьXML.ОткрытьФайл(ПолноеИмяФайлаНастроекКонсолиСерверов);
	ЗаписьДом = Новый ЗаписьDOM;
	ЗаписьДом.Записать(ДокументDOM, ЗаписьXML); 
	
КонецПроцедуры

Функция ПолучитьМассивПутиКСсылкеВКонсолиСерверов(СтрокаТаблицыСерверов)
	
	// <Segment String="(*)ServerName"/>
	// <Segment String="Кластеры"/>
	// <Segment String="Интеграция"/>
	// <Segment String="Информационные базы"/>
	// <Segment String="IBName"/>
	МассивПути = Новый Массив;
	ЭлементПути = СтрокаТаблицыСерверов.Компьютер;
	Если ирОбщий.ЭтоИмяЛокальногоСервераЛкс(ЭлементПути) Тогда
		ЭлементПути = "(*)" + ЭлементПути;
	КонецЕсли; 
	МассивПути.Добавить(ЭлементПути);
	Возврат МассивПути;

КонецФункции

Процедура ОткрытьКонсольСерверов1С(Знач ТаблицаСерверов = Неопределено, Знач ТекущаяСтрокаТаблицыСерверов = Неопределено) Экспорт 
	
	ОбработкаРегистрации = ирОбщий.ПолучитьОбъектПоПолномуИмениМетаданныхЛкс("Обработка.ирУправлениеCOMКлассами1С");
		#Если Сервер И Не Сервер Тогда
		    ОбработкаРегистрации = Обработки.ирУправлениеCOMКлассами1С.Создать();
		#КонецЕсли
	ОбработкаРегистрации.ЗаполнитьТипыCOMКлассов();
	ирОбщий.ЗаполнитьДоступныеСборкиПлатформыЛкс(СборкиПлатформы, Компьютер, ОбработкаРегистрации.ТипыComКлассов);

	ТипКласса = "ServerAdminScope";
	СтрокаСборкиПлатформы = СборкиПлатформы.НайтиСтроки(Новый Структура("КлючСборки," + ТипКласса, ТекущаяСтрокаТаблицыСерверов.СборкаПлатформыАктивная, Истина));
	Если СтрокаСборкиПлатформы.Количество() = 0 Тогда
		Возврат;
	КонецЕсли; 
	СтрокаСборкиПлатформы = СтрокаСборкиПлатформы[0];
	#Если Сервер И Не Сервер Тогда
	    СтрокаСборкиПлатформы = СборкиПлатформы[0];
	#КонецЕсли
	ПолноеИмяФайлаКонсоли = "";
	КаталогПрограммныхФайлов = ирОбщий.КаталогПрограммныхФайловОСЛкс(СтрокаСборкиПлатформы.x64);
	Если ирКэш.НомерИзданияПлатформыЛкс() = "81" Тогда
		ПолноеИмяФайлаКонсоли = КаталогПрограммныхФайлов + "\1cv81\bin\1CV8 Servers.msc";
		Файл = Новый Файл(ПолноеИмяФайлаКонсоли);
		Если Не Файл.Существует() Тогда
			ПолноеИмяФайлаКонсоли = "";
		КонецЕсли; 
	ИначеЕсли ирКэш.НомерИзданияПлатформыЛкс() = "82" Тогда 
		ПолноеИмяФайлаКонсоли = КаталогПрограммныхФайлов + "\1cv82\common\";
		Если СтрокаСборкиПлатформы.x64 Тогда
			ПолноеИмяФайлаКонсоли = ПолноеИмяФайлаКонсоли + "1CV8 Servers (x86-64).msc";
		Иначе
			ПолноеИмяФайлаКонсоли = ПолноеИмяФайлаКонсоли + "1CV8 Servers.msc";
		КонецЕсли; 
		Файл = Новый Файл(ПолноеИмяФайлаКонсоли);
		Если Не Файл.Существует() Тогда
			ПолноеИмяФайлаКонсоли = "";
		КонецЕсли; 
	ИначеЕсли ирКэш.НомерИзданияПлатформыЛкс() = "83" Тогда
		ПолноеИмяФайлаКонсоли = КаталогПрограммныхФайлов + "\1cv8\common\";
		Если СтрокаСборкиПлатформы.x64 Тогда
			ПолноеИмяФайлаКонсоли = ПолноеИмяФайлаКонсоли + "1CV8 Servers (x86-64).msc";
		Иначе
			ПолноеИмяФайлаКонсоли = ПолноеИмяФайлаКонсоли + "1CV8 Servers.msc";
		КонецЕсли; 
		Файл = Новый Файл(ПолноеИмяФайлаКонсоли);
		Если Не Файл.Существует() Тогда
			ПолноеИмяФайлаКонсоли = "";
		КонецЕсли; 
	КонецЕсли; 
	Если ЗначениеЗаполнено(ПолноеИмяФайлаКонсоли) Тогда
		ТаблицаСерверов = ПолучитьТаблицуСерверовИзСпискаПользователя(ТаблицаСерверов);
		ПоместитьТаблицуСерверовВСписокПользователя(ТаблицаСерверов, ТекущаяСтрокаТаблицыСерверов);
		ОбработкаРегистрации = ирОбщий.ПолучитьОбъектПоПолномуИмениМетаданныхЛкс("Обработка.ирУправлениеCOMКлассами1С");
			#Если Сервер И Не Сервер Тогда
			    ОбработкаРегистрации = Обработки.ирУправлениеCOMКлассами1С.Создать();
			#КонецЕсли
		ОбработкаРегистрации.ЗаполнитьТипыCOMКлассов();
		СтрокаТипаКласса = ОбработкаРегистрации.ТипыComКлассов.Найти(ТипКласса, "Имя");
		ОбработкаРегистрации.СборкиПлатформы.Загрузить(СборкиПлатформы.Выгрузить());
		ОбработкаРегистрации.ЗарегистрироватьCOMКлассСборкиПлатформы(СтрокаТипаКласса, СтрокаСборкиПлатформы.x64, СтрокаСборкиПлатформы.СборкаПлатформы);
		ЗапуститьПриложение("""" + ПолноеИмяФайлаКонсоли + """");
	Иначе
		Если СтрокаСборкиПлатформы.x64 Тогда
			ПредставлениеРазрядности = "64";
		Иначе
			ПредставлениеРазрядности = "32";
		КонецЕсли; 
		Сообщить("Файл консоли серверов 1С " + ирКэш.НомерИзданияПлатформыЛкс() + " " + ПредставлениеРазрядности + "б не найден по пути """ + ПолноеИмяФайлаКонсоли + """");
	КонецЕсли; 
	
КонецПроцедуры

//ирПортативный лФайл = Новый Файл(ИспользуемоеИмяФайла);
//ирПортативный ПолноеИмяФайлаБазовогоМодуля = Лев(лФайл.Путь, СтрДлина(лФайл.Путь) - СтрДлина("Модули")) + "ирПортативный.epf";
//ирПортативный #Если Клиент Тогда
//ирПортативный 	Контейнер = Новый Структура();
//ирПортативный 	Оповестить("ирПолучитьБазовуюФорму", Контейнер);
//ирПортативный 	Если Не Контейнер.Свойство("ирПортативный", ирПортативный) Тогда
//ирПортативный 		ПолноеИмяФайлаБазовогоМодуля = ирОбщий.ВосстановитьЗначениеЛкс("ирПолноеИмяФайлаОсновногоМодуля");
//ирПортативный 		ирПортативный = ВнешниеОбработки.ПолучитьФорму(ПолноеИмяФайлаБазовогоМодуля);
//ирПортативный 	КонецЕсли; 
//ирПортативный #Иначе
//ирПортативный 	ирПортативный = ВнешниеОбработки.Создать(ПолноеИмяФайлаБазовогоМодуля, Ложь); // Это будет второй экземпляр объекта
//ирПортативный #КонецЕсли
//ирПортативный ирОбщий = ирПортативный.ПолучитьОбщийМодульЛкс("ирОбщий");
//ирПортативный ирКэш = ирПортативный.ПолучитьОбщийМодульЛкс("ирКэш");
//ирПортативный ирСервер = ирПортативный.ПолучитьОбщийМодульЛкс("ирСервер");
//ирПортативный ирПривилегированный = ирПортативный.ПолучитьОбщийМодульЛкс("ирПривилегированный");

мПлатформа = ирКэш.Получить();
ТаблицаТиповСлужб = ирОбщий.ПолучитьТаблицуИзТабличногоДокументаЛкс(ПолучитьМакет("ПараметрыТиповСлужб"),,,, Истина);
мТипыСлужб = Новый Структура;
Для Каждого СтрокаТаблицы Из ТаблицаТиповСлужб Цикл
	мТипыСлужб.Вставить(СтрокаТаблицы.ТипСлужбы, СтрокаТаблицы);
КонецЦикла;
ЭтотОбъект.Компьютер = ИмяКомпьютера();
