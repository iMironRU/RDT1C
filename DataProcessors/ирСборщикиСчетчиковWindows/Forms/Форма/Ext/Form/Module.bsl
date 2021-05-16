﻿
Функция СохраняемаяНастройкаФормы(выхНаименование, выхИменаСвойств) Экспорт 
	выхИменаСвойств = "Табличная часть.СчетчикиНового, Форма.ПериодичностьСекунд, Форма.ИмяСборщика, Форма.ВыходнойФайл";
КонецФункции

Процедура ЗагрузитьНастройкуВФорме(НастройкаФормы, ДопПараметры) Экспорт 
	
	#Если Сервер И Не Сервер Тогда
		НастройкаФормы = Новый Структура;
	#КонецЕсли
	ирОбщий.ЗагрузитьНастройкуФормыЛкс(ЭтаФорма, НастройкаФормы); 
	Если Не ЗначениеЗаполнено(ПериодичностьСекунд) Тогда
		ЭтаФорма.ПериодичностьСекунд = 10;
	КонецЕсли; 
	Если Не ЗначениеЗаполнено(ИмяСборщика) Тогда
		ЭтаФорма.ИмяСборщика = "Счетчики1С";
	КонецЕсли; 
	СтандартныеСчетчики = ирОбщий.ТаблицаЗначенийИзТабличногоДокументаЛкс(ПолучитьМакет("СтандартныеСчетчики"));
	Для Каждого СтрокаСтандартногоСчетчика Из СтандартныеСчетчики Цикл
		СтрокаСчетчика = СчетчикиНового.Найти(СтрокаСтандартногоСчетчика.Счетчик, "Счетчик");
		Если СтрокаСчетчика = Неопределено Тогда
			СтрокаСчетчика = СчетчикиНового.Добавить();
			СтрокаСчетчика.Счетчик = СтрокаСтандартногоСчетчика.Счетчик; 
			СтрокаСчетчика.Пометка = СтрокаСтандартногоСчетчика.Пометка; 
		КонецЕсли; 
	КонецЦикла;
	Для Каждого СтрокаСчетчика Из СчетчикиНового Цикл
		ОбновитьКатегориюСчетчика(СтрокаСчетчика);
	КонецЦикла;
	СчетчикиНового.Сортировать("Счетчик");

КонецПроцедуры

Процедура ОбновитьКатегориюСчетчика(Знач СтрокаСчетчика)
	
	НИмя = НРег(СтрокаСчетчика.Счетчик);
	Если Ложь
		Или Найти(НИмя, "процессор") > 0 
		Или Найти(НИмя, "processor") > 0
	Тогда
		СтрокаСчетчика.Категория = "Процессор"; 
	ИначеЕсли Ложь
		Или Найти(НИмя, "памят") > 0 
		Или Найти(НИмя, "memory") > 0
		Или Найти(НИмя, "private") > 0 
		Или Найти(НИмя, "исключительн") > 0 
		Или Найти(НИмя, "virtual") > 0 
		Или Найти(НИмя, "виртуальн") > 0 
	Тогда
		СтрокаСчетчика.Категория = "Память"; 
	ИначеЕсли Ложь
		Или Найти(НИмя, "диск") > 0 
		Или Найти(НИмя, "disk") > 0
	Тогда
		СтрокаСчетчика.Категория = "Диск"; 
	ИначеЕсли Ложь
		Или Найти(НИмя, "сетев") > 0 
		Или Найти(НИмя, "network") > 0
	Тогда
		СтрокаСчетчика.Категория = "Сеть"; 
	Иначе
		СтрокаСчетчика.Категория = ""; 
	КонецЕсли;

КонецПроцедуры

Процедура СтруктураКоманднойПанелиНажатие(Кнопка)
	
	ирОбщий.ОткрытьСтруктуруКоманднойПанелиЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник) Экспорт
	
	ирОбщий.Форма_ОбработкаОповещенияЛкс(ЭтаФорма, ИмяСобытия, Параметр, Источник); 

КонецПроцедуры

Процедура ПриОткрытии()
	
	ирОбщий.Форма_ПриОткрытииЛкс(ЭтаФорма);
	ирОбщий.СоздатьМенеджерСохраненияНастроекФормыЛкс(ЭтаФорма,,,, "pmc");
	ЭтаФорма.ОтАдминистратора = ирКэш.ВКОбщаяЛкс().IsAdmin();
	КПСборщикиСчетчиковОбновить();
	СписокВыбора = ЭлементыФормы.ПериодичностьСекунд.СписокВыбора;
	СписокВыбора.Добавить(1);
	СписокВыбора.Добавить(5);
	СписокВыбора.Добавить(10);
	СписокВыбора.Добавить(30);
	СписокВыбора.Добавить(60);
	
КонецПроцедуры

Процедура СоздатьСборщикСчетчиковНажатие(Элемент)
	
	Если СчетчикиНового.НайтиСтроки(Новый Структура("Пометка", Истина)).Количество() = 0 Тогда
		ирОбщий.СообщитьЛкс("Необходимо выбрать счетчики");
		Возврат;
	КонецЕсли; 
	
	Массив = Новый Массив;
	Для Каждого СтрокаСчетчика Из СчетчикиНового.НайтиСтроки(Новый Структура("Пометка", Истина)) Цикл
		#Если Сервер И Не Сервер Тогда
			СтрокаСчетчика = СчетчикиНового.Найти();
		#КонецЕсли
		Массив.Добавить("'" + СтрокаСчетчика.Счетчик + "'");
	КонецЦикла;
	ТекстДокумент = ПолучитьМакет("СозданиеГруппыСборщиков");
	Текст = ТекстДокумент.ПолучитьТекст();
	Текст = ирОбщий.СтрЗаменитьЛкс(Текст, "<ПериодичностьСекунд>", XMLСтрока(ПериодичностьСекунд));
	Текст = ирОбщий.СтрЗаменитьЛкс(Текст, "<КаталогФайлов>", ВыходнойФайл);
	Текст = ирОбщий.СтрЗаменитьЛкс(Текст, "<ИмяСборщика>", ИмяСборщика);
	Текст = ирОбщий.СтрЗаменитьЛкс(Текст, "<ФорматИмениФайла>", "MMdd");
	Текст = ирОбщий.СтрЗаменитьЛкс(Текст, "<Счетчики>", ирОбщий.СтрСоединитьЛкс(Массив, ", "));
	ТекстДокумент.УстановитьТекст(Текст);
	ИмяФайлаСкрипта = ПолучитьИмяВременногоФайла("ps1");
	ТекстДокумент.Записать(ИмяФайлаСкрипта);
	КомандаСистемы = "powershell -executionpolicy RemoteSigned -file """ + ИмяФайлаСкрипта + """";
	Результат = ирОбщий.ВыполнитьКомандуОСЛкс(КомандаСистемы,,, Истина);
	УдалитьФайлы(ИмяФайлаСкрипта);
	//
	//Массив = Новый Массив;
	//Для Каждого СтрокаСчетчика Из СчетчикиНового.НайтиСтроки(Новый Структура("Пометка", Истина)) Цикл
	//	#Если Сервер И Не Сервер Тогда
	//		СтрокаСчетчика = СчетчикиНового.Найти();
	//	#КонецЕсли
	//	Массив.Добавить("""" + СтрЗаменить(СтрокаСчетчика.Счетчик, "%", "%%") + """");
	//КонецЦикла;
	//КомандаСистемы = "logman create counter """ + ИмяСборщика + """ -a -si " + XMLСтрока(ПериодичностьСекунд) + " -v mmddhhmm -o " + ВыходнойФайл + " -c " + ирОбщий.СтрСоединитьЛкс(Массив, " ");
	//Сообщить(КомандаСистемы);
	//Результат = ирОбщий.ВыполнитьКомандуОСЛкс(КомандаСистемы,,, Истина);
	//ирОбщий.СообщитьЛкс(Результат);
	
	КПСборщикиСчетчиковОбновить();
	НоваяСтрока = СборщикиСчетчиков.Найти(ИмяСборщика, "Имя");
	Если НоваяСтрока <> Неопределено Тогда
		ЭлементыФормы.СборщикиСчетчиков.ТекущаяСтрока = НоваяСтрока;
		Ответ = Вопрос("Перезапустить измененный сборщик счетчиков?", РежимДиалогаВопрос.ОКОтмена);
		Если Ответ = КодВозвратаДиалога.ОК Тогда
			Если НоваяСтрока.Выполняется Тогда
				ВыполнитьГрупповуюКоманду("stop");
			КонецЕсли; 
			ВыполнитьГрупповуюКоманду("start");
		Иначе
			Если НоваяСтрока.Выполняется Тогда
				ирОбщий.СообщитьЛкс("Сборщик применит новые параметры только при перезапуске");
			КонецЕсли; 
		КонецЕсли;
	КонецЕсли; 
	
КонецПроцедуры

Процедура ДействияФормыЗапуститьОтАдминистратора(Кнопка)
	
	ирОбщий.ПерезапуститьСеансОтИмениАдминистратораОСЛкс(ЭтаФорма);

КонецПроцедуры

Процедура КлсКомандаНажатие(Кнопка) Экспорт 
	
	ирОбщий.УниверсальнаяКомандаФормыЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура ИмяСборщикаПриИзменении(Элемент)
	
	ирОбщий.ПолеВводаСИсториейВыбора_ПриИзмененииЛкс(Элемент, ЭтаФорма);

КонецПроцедуры

Процедура КаталогФайловПриИзменении(Элемент)
	
	ирОбщий.ПолеВводаСИсториейВыбора_ПриИзмененииЛкс(Элемент, ЭтаФорма);
	
КонецПроцедуры

Процедура КаталогФайловНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	РезультатВыбора = ирОбщий.ВыбратьФайлЛкс(Ложь,,, ВыходнойФайл);
	Если РезультатВыбора <> Неопределено Тогда
		ирОбщий.ИнтерактивноЗаписатьВЭлементУправленияЛкс(ЭлементыФормы.ВыходнойФайл, РезультатВыбора);
	КонецЕсли; 
	
КонецПроцедуры

Процедура ПриЗакрытии()
	
	ирОбщий.Форма_ПриЗакрытииЛкс(ЭтаФорма);
	
КонецПроцедуры

Процедура ВнешнееСобытие(Источник, Событие, Данные) Экспорт
	
	ирОбщий.Форма_ВнешнееСобытиеЛкс(ЭтаФорма, Источник, Событие, Данные);

КонецПроцедуры

Процедура СчетчикиПриАктивизацииСтроки(Элемент)
	
	ирОбщий.ТабличноеПолеПриАктивизацииСтрокиЛкс(ЭтаФорма, Элемент);
	
КонецПроцедуры

Процедура СчетчикиПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	
	ирОбщий.ТабличноеПолеПриВыводеСтрокиЛкс(ЭтаФорма, Элемент, ОформлениеСтроки, ДанныеСтроки);
	
КонецПроцедуры

Процедура СчетчикиПриИзмененииФлажка(Элемент, Колонка)
	
	ирОбщий.ТабличноеПолеПриИзмененииФлажкаЛкс(ЭтаФорма, Элемент, Колонка);
	
КонецПроцедуры

Процедура ДействияФормыОткрытьМониторСчетчиков(Кнопка)
	
	ЗапуститьПриложение("perfmon");
	
КонецПроцедуры

Процедура КаталогФайловОткрытие(Элемент, СтандартнаяОбработка)
	
	Файл = Новый Файл(ВыходнойФайл);
	Файлы = НайтиФайлы(, Файл.Путь + Файл.ИмяБезРасширения + "*");
	Если Файлы.Количество() > 0 Тогда
		ирОбщий.ОткрытьФайлВПроводникеЛкс(Файлы[0].ПолноеИмя);
	Иначе
		ЗапуститьПриложение(Файл.Путь);
	КонецЕсли; 
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

Процедура СборщикиСчетчиковВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	Если Колонка = ЭлементыФормы.СборщикиСчетчиков.Колонки.КаталогФайлов Тогда
		ЗапуститьПриложение(ВыбраннаяСтрока.КорневойПуть);
	Иначе
		ПосмотретьГрафики(ВыбраннаяСтрока);
	КонецЕсли; 
	
КонецПроцедуры

Процедура ПосмотретьГрафики(Знач ВыбраннаяСтрока, РежимПросмотра = 0)
	
	Если Не ЗначениеЗаполнено(ВыбраннаяСтрока.ТекущийФайл) Тогда
		Возврат;
	КонецЕсли; 
	// https://forum.mista.ru/topic.php?id=864730
	Если ВыбраннаяСтрока.Выполняется Тогда
		Если Не ВыбраннаяСтрока.Добавление Тогда
			Ответ = Вопрос("Отчет выполняющегося сборщика может не отображать последниие минуты. Этот сборщик не позволяет продолжить (Добавление) текущий файл после остановки.
			|Приостановить сборщик для получения данных и за последние минуты?", РежимДиалогаВопрос.ДаНет);
		Иначе
			Ответ = КодВозвратаДиалога.Да;
		КонецЕсли; 
		Если Ответ = КодВозвратаДиалога.Да Тогда
			Результат = ирОбщий.ВыполнитьКомандуОСЛкс("logman stop """ + ВыбраннаяСтрока.Имя + """",,,, "Остановка сборщика");
		КонецЕсли; 
	КонецЕсли; 
	Если РежимПросмотра = 0 Тогда
		ЗапуститьПриложение(ВыбраннаяСтрока.ТекущийФайл);
	Иначе
		ИмяВыходногоФайла = ПолучитьИмяВременногоФайла("cvs");
		Результат = ирОбщий.ВыполнитьКомандуОСЛкс("relog """ + ВыбраннаяСтрока.ТекущийФайл + """ -f csv -o """ + ИмяВыходногоФайла + """",,,, "Конвертация журнала");
	КонецЕсли; 
	Если Ответ = КодВозвратаДиалога.Да Тогда
		Результат = ирОбщий.ВыполнитьКомандуОСЛкс("logman start """ + ВыбраннаяСтрока.Имя + """",,,, "Запуск сборщика");
	КонецЕсли; 
	КПСборщикиСчетчиковОбновить();
	Если РежимПросмотра = 1 Тогда
		Разделитель = ",";
		Текст = Новый ТекстовыйДокумент;
		Текст.Прочитать(ИмяВыходногоФайла);
		УдалитьФайлы(ИмяВыходногоФайла);
		ТаблицаСтроковыхЗначений = ирОбщий.ТаблицаИзСтрокиСРазделителемЛкс(Текст.ПолучитьТекст(), Разделитель, Истина, Истина);
		#Если Сервер И Не Сервер Тогда
			ТаблицаСтроковыхЗначений = Новый ТаблицаЗначений;
		#КонецЕсли
		ТаблицаТипизированая = Новый ТаблицаЗначений;
		ИменаКомпьютеров = Новый Соответствие;
		ИмяКомпьютера = "";
		Для Каждого Колонка Из ТаблицаСтроковыхЗначений.Колонки Цикл
			Если ТаблицаТипизированая.Колонки.Количество() = 0 Тогда
				Тип = Новый ОписаниеТипов("Дата");
			Иначе
				Тип = Новый ОписаниеТипов("Число");
				ИмяКомпьютера = ирОбщий.СтрокаМеждуМаркерамиЛкс(Колонка.Заголовок, "\\", "\", Ложь);
				ИменаКомпьютеров.Вставить(НРег(ИмяКомпьютера));
			КонецЕсли;
			ТаблицаТипизированая.Колонки.Добавить(Колонка.Имя, Тип, Колонка.Заголовок);
		КонецЦикла;
		Если ИменаКомпьютеров.Количество() = 1 Тогда
			Для Каждого Колонка Из ТаблицаТипизированая.Колонки Цикл
				Колонка.Заголовок = ирОбщий.ПоследнийФрагментЛкс(Колонка.Заголовок, ИмяКомпьютера + "\"); 
			КонецЦикла; 
		КонецЕсли; 
		ирОбщий.КонвертироватьСтроковуюТаблицуВТипизированнуюЛкс(ТаблицаСтроковыхЗначений, ТаблицаТипизированая, Истина);
		ТаблицаТипизированая.Колонки[0].Имя = "МоментВремени";
		ТаблицаТипизированая.Колонки[0].Заголовок = "Момент времени";
		
		СхемаКомпоновки = ПолучитьМакет("СхемаКомпоновки");
		#Если Сервер И Не Сервер Тогда
			СхемаКомпоновки = Новый СхемаКомпоновкиДанных;
		#КонецЕсли
		НастройкаКомпоновки = СхемаКомпоновки.НастройкиПоУмолчанию;
		ПолеНабораПоказателяЭталон = СхемаКомпоновки.НаборыДанных[0].Поля.Найти("Показатель");
		Для Каждого Колонка Из ТаблицаТипизированая.Колонки Цикл
			Если ТипЗнч(ТаблицаТипизированая[0][Колонка.Имя]) <> Тип("Число") Тогда 
				Продолжить;
			КонецЕсли; 
			ПолеНабораПоказателя = СхемаКомпоновки.НаборыДанных[0].Поля.Добавить(Тип("ПолеНабораДанныхСхемыКомпоновкиДанных"));
			ЗаполнитьЗначенияСвойств(ПолеНабораПоказателя, ПолеНабораПоказателяЭталон); 
			ПолеНабораПоказателя.Поле = Колонка.Имя;
			ПолеНабораПоказателя.ПутьКДанным = Колонка.Имя;
			ПолеНабораПоказателя.Заголовок = Колонка.Заголовок;
			ПолеИтога = СхемаКомпоновки.ПоляИтога.Добавить();
			ПолеИтога.ПутьКДанным = Колонка.Имя;
			ПолеИтога.Выражение = "Среднее(" + Колонка.Имя + ")";
			ирОбщий.НайтиДобавитьЭлементНастроекКомпоновкиПоПолюЛкс(НастройкаКомпоновки.Выбор, Колонка.Имя);
		КонецЦикла;
		СхемаКомпоновки.НаборыДанных[0].Поля.Удалить(ПолеНабораПоказателяЭталон);
		ВнешниеНаборыДанных = Новый Структура;
		ВнешниеНаборыДанных.Вставить("Таблица", ТаблицаТипизированая);
		ирОбщий.ОтладитьЛкс(СхемаКомпоновки, Ложь, НастройкаКомпоновки, ВнешниеНаборыДанных);
	КонецЕсли; 

КонецПроцедуры

Процедура КПСборщикиСчетчиковОбновить(Кнопка = Неопределено)
	
	ирОбщий.СостояниеЛкс("Обновление списка сборщиков");
	СостоянияСтрок = ирОбщий.ТабличноеПолеСостояниеСтрокЛкс(ЭлементыФормы.СборщикиСчетчиков, "Имя");
	Текст = Новый ТекстовыйДокумент;
	Текст.УстановитьТекст(ирОбщий.ВыполнитьКомандуОСЛкс("logman query",,, Истина));
	СборщикиСчетчиков.Очистить();
	ЭтоДанные = Ложь;
	СписокСчетчиков = Неопределено;
	Для Счетчик = 1 По Текст.КоличествоСтрок() Цикл
		СтрокаТекста = Текст.ПолучитьСтроку(Счетчик);
		Если ирОбщий.СтрНачинаетсяСЛкс(СтрокаТекста, "----------") Тогда 
			ЭтоДанные = Истина;
			Продолжить;
		КонецЕсли;
		Если ПустаяСтрока(СтрокаТекста) Тогда 
			ЭтоДанные = Ложь;
			Продолжить;
		КонецЕсли; 
		Если ЭтоДанные Тогда
			ФрагментСтроки = СтрокаТекста;
			СостояниеСборщика = ирОбщий.ПоследнийФрагментЛкс(ФрагментСтроки, " ");
			ФрагментСтроки = СокрП(Лев(ФрагментСтроки, СтрДлина(ФрагментСтроки) - СтрДлина(СостояниеСборщика)));
			ТипСборщика = ирОбщий.ПоследнийФрагментЛкс(ФрагментСтроки, " ");
			ФрагментСтроки = СокрП(Лев(ФрагментСтроки, СтрДлина(ФрагментСтроки) - СтрДлина(ТипСборщика)));
			СтрокаСборщика = СборщикиСчетчиков.Добавить();
			СтрокаСборщика.Имя = ФрагментСтроки;
			СтрокаСборщика.ЭтоГруппа = Истина
				И ТипСборщика <> "Счетчик"
				И ТипСборщика <> "Counter";
			СтрокаСборщика.Выполняется = Истина
				И СостояниеСборщика <> "Остановлено"
				И СостояниеСборщика <> "Stopped";
			ТекстОписания = Новый ТекстовыйДокумент;
			ТекстОписания.УстановитьТекст(ирОбщий.ВыполнитьКомандуОСЛкс("logman """ + СтрокаСборщика.Имя + """",,, Истина));
			ЭтоСчетчики = Ложь;
			Для СчетчикОписания = 1 По ТекстОписания.КоличествоСтрок() Цикл
				СтрокаОписания = ТекстОписания.ПолучитьСтроку(СчетчикОписания);
				Если ЭтоСчетчики Тогда 
					Если ПустаяСтрока(СтрокаОписания) Тогда
						Прервать;
					Иначе
						СписокСчетчиков.Добавить(СокрЛП(СтрокаОписания));
					КонецЕсли; 
				КонецЕсли; 
				ПозицияРазделителя = Найти(СтрокаОписания, ":");
				Если ПозицияРазделителя > 0 Тогда
					ИмяСвойства = Лев(СтрокаОписания, ПозицияРазделителя - 1);
					Если Ложь
						Или ИмяСвойства = "Счетчики" 
						Или ИмяСвойства = "Counters"
					Тогда
						СписокСчетчиков = Новый СписокЗначений;
						ЭтоСчетчики = Истина;
						Продолжить;
					КонецЕсли; 
					ЗначениеСвойства = СокрЛП(Сред(СтрокаОписания, ПозицияРазделителя + 1));
					Если Ложь
						Или ИмяСвойства = "Корневой путь"
						Или ИмяСвойства = "Root Path"
					Тогда
						СтрокаСборщика.КорневойПуть = ЗначениеСвойства;
					ИначеЕсли Ложь
						Или ИмяСвойства = "Сегмент"
						Или ИмяСвойства = "Segment"
					Тогда
						СтрокаСборщика.Сегмент = СтрокаВБулево(ЗначениеСвойства);
					ИначеЕсли Ложь
						Или ИмяСвойства = "Расписания"
						Или ИмяСвойства = "Schedules"
					Тогда
						СтрокаСборщика.Расписания = СтрокаВБулево(ЗначениеСвойства);
					ИначеЕсли Ложь
						Или ИмяСвойства = "Запуск от имени"
						Или ИмяСвойства = "Run as"
					Тогда
						СтрокаСборщика.ПользовательОС = ЗначениеСвойства;
					ИначеЕсли Ложь
						Или ИмяСвойства = "Размещение вывода"
						Или ИмяСвойства = "Output location"
					Тогда
						СтрокаСборщика.ТекущийФайл = ЗначениеСвойства;
						Файл = Новый Файл(ЗначениеСвойства);
						Если Файл.Существует() Тогда
							СтрокаСборщика.РазмерФайлаКБ = Файл.Размер() / 1024;
							СтрокаСборщика.ДатаИзмененияФайла = Файл.ПолучитьВремяИзменения();
						КонецЕсли; 
					ИначеЕсли Ложь
						Или ИмяСвойства = "Добавление"
						Или ИмяСвойства = "Append"
					Тогда
						СтрокаСборщика.Добавление = СтрокаВБулево(ЗначениеСвойства);
					ИначеЕсли Ложь
						Или ИмяСвойства = "Циклический"
						Или ИмяСвойства = "Cyrcular"
					Тогда
						СтрокаСборщика.Циклический = СтрокаВБулево(ЗначениеСвойства);
					ИначеЕсли Ложь
						Или ИмяСвойства = "Замена"
						Или ИмяСвойства = "Overwrite"
					Тогда
						СтрокаСборщика.Замена = СтрокаВБулево(ЗначениеСвойства);
					ИначеЕсли Ложь
						Или ИмяСвойства = "Интервал выборки"
						Или ИмяСвойства = "Sample Interval"
					Тогда
						СтрокаСборщика.ПериодичностьСекунд = ирОбщий.СтрокаВЧислоЛкс(ирОбщий.ПервыйФрагментЛкс(ЗначениеСвойства, " "));
					ИначеЕсли Ложь
						Или ИмяСвойства = "Максимальный размер сегмента"
						Или ИмяСвойства = "Max segment size"
					Тогда
						СтрокаСборщика.МаксимальныйРазмерСегмента = ирОбщий.СтрокаВЧислоЛкс(ирОбщий.ПервыйФрагментЛкс(ЗначениеСвойства, " "));
					КонецЕсли; 
				КонецЕсли; 
			КонецЦикла; 
			Если СписокСчетчиков <> Неопределено Тогда
				СписокСчетчиков.СортироватьПоЗначению();
				СтрокаСборщика.Счетчики = ирОбщий.СтрСоединитьЛкс(СписокСчетчиков.ВыгрузитьЗначения(), Символы.ПС);
			КонецЕсли; 
		КонецЕсли;
	КонецЦикла;
	ирОбщий.ТабличноеПолеВосстановитьСостояниеСтрокЛкс(ЭлементыФормы.СборщикиСчетчиков, СостоянияСтрок);
	ирОбщий.СостояниеЛкс("");
КонецПроцедуры

Функция СтрокаВБулево(Строка)
	Результат = Ложь
		 Или Строка = "вкл."
		 Или Строка = "on";
	Возврат Результат;
КонецФункции

Процедура СборщикиСчетчиковПриАктивизацииСтроки(Элемент)
	
	ирОбщий.ТабличноеПолеПриАктивизацииСтрокиЛкс(ЭтаФорма, Элемент);
	СчетчикиТекущего.Очистить();
	Если ЭлементыФормы.СборщикиСчетчиков.ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	МассивСчетчиков = ирОбщий.СтрРазделитьЛкс(ЭлементыФормы.СборщикиСчетчиков.ТекущаяСтрока.Счетчики, Символы.ПС);
	Для Счетчик = 1 По МассивСчетчиков.Количество() Цикл
		СчетчикиТекущего.Добавить();
	КонецЦикла;
	СчетчикиТекущего.ЗагрузитьКолонку(МассивСчетчиков, "Счетчик");

КонецПроцедуры

Процедура СборщикиСчетчиковПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	
	ирОбщий.ТабличноеПолеПриВыводеСтрокиЛкс(ЭтаФорма, Элемент, ОформлениеСтроки, ДанныеСтроки);

КонецПроцедуры

Процедура ДействияФормыПроцессыЧерезИдентификатор(Кнопка)
	СкриптРегистрации = ПолучитьМакет("ПатчРеестраФорматИмениПроцесса");
	ИмяФайлаСкрипта = ПолучитьИмяВременногоФайла("reg");
	СкриптРегистрации.Записать(ИмяФайлаСкрипта, КодировкаТекста.ANSI);
	ирОбщий.ВыполнитьКомандуОСЛкс("regedit /s """ + ИмяФайлаСкрипта + """",,, Истина);
	ирОбщий.СообщитьЛкс("В системный реестр добавлен параметр HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\PerfProc\Performance\ProcessNameFormat");
	УдалитьФайлы(ИмяФайлаСкрипта);
КонецПроцедуры

Процедура ВыполнитьГрупповуюКоманду(Команда)
	Индикатор = ирОбщий.ПолучитьИндикаторПроцессаЛкс(ЭлементыФормы.СборщикиСчетчиков.ВыделенныеСтроки.Количество(), "Отправка команды " + Команда + " сборщикам");
	Для Каждого ВыделеннаяСтрока Из ЭлементыФормы.СборщикиСчетчиков.ВыделенныеСтроки Цикл
		ирОбщий.ОбработатьИндикаторЛкс(Индикатор);
		Результат = ирОбщий.ВыполнитьКомандуОСЛкс("logman " + Команда + " """ + ВыделеннаяСтрока.Имя + """",,, Истина);
		Сообщить(Результат);
	КонецЦикла;
	ирОбщий.ОсвободитьИндикаторПроцессаЛкс();
	КПСборщикиСчетчиковОбновить();
КонецПроцедуры

Процедура КПСборщикиСчетчиковОстановить(Кнопка)
	ВыполнитьГрупповуюКоманду("stop");
КонецПроцедуры

Процедура КПСборщикиСчетчиковЗапустить(Кнопка)
	ВыполнитьГрупповуюКоманду("start");
КонецПроцедуры

Процедура СборщикиСчетчиковПередУдалением(Элемент, Отказ)
	Отказ = Истина;
	Ответ = Вопрос("Вы действительно хотите удалить выделенные сборщики?", РежимДиалогаВопрос.ОКОтмена);
	Если Ответ = КодВозвратаДиалога.ОК Тогда
		ВыполнитьГрупповуюКоманду("stop");
		ВыполнитьГрупповуюКоманду("delete");
	КонецЕсли;
КонецПроцедуры

Процедура СборщикиСчетчиковПередНачаломДобавления(Элемент, Отказ, Копирование)
	Отказ = Истина;
КонецПроцедуры

Процедура КПСборщикиСчетчиковПосмотретьСобранныеСчетчики(Кнопка)
	
	ПосмотретьГрафики(ЭлементыФормы.СборщикиСчетчиков.ТекущаяСтрока);
	
КонецПроцедуры

Процедура СчетчикиПолноеИмяПриИзменении(Элемент)
	
	ОбновитьКатегориюСчетчика(ЭлементыФормы.СчетчикиНового.ТекущаяСтрока);

КонецПроцедуры

Процедура СчетчикиПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Колонка)
	
	ЗначениеПеретаскивания = ПараметрыПеретаскивания.Значение;
	Если ТипЗнч(ЗначениеПеретаскивания) = Тип("Массив") Тогда
		Если ТипЗнч(ЗначениеПеретаскивания[0]) = Тип("СтрокаТаблицыЗначений") Тогда 
			СтандартнаяОбработка = Ложь;
			ПараметрыПеретаскивания.ДопустимыеДействия = ДопустимыеДействияПеретаскивания.Копирование;
		КонецЕсли; 
	КонецЕсли;
	
КонецПроцедуры

Процедура СчетчикиПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Колонка)
	
	ЗначениеПеретаскивания = ПараметрыПеретаскивания.Значение;
	Если ТипЗнч(ЗначениеПеретаскивания) = Тип("Массив") Тогда
		Если ТипЗнч(ЗначениеПеретаскивания[0]) = Тип("СтрокаТаблицыЗначений") Тогда 
			СтандартнаяОбработка = Ложь;
			ТекущаяСтрокаУстановлена = Ложь;
			Для Каждого СтрокаТаблицыИсточника Из ЗначениеПеретаскивания Цикл
				СтрокаПриемника = СчетчикиНового.Найти(СтрокаТаблицыИсточника.Счетчик, "Счетчик");
				Если СтрокаПриемника = Неопределено Тогда
					СтрокаПриемника = СчетчикиНового.Добавить();
					СтрокаПриемника.Счетчик = СтрокаТаблицыИсточника.Счетчик;
					ОбновитьКатегориюСчетчика(СтрокаПриемника);
				КонецЕсли; 
				Если Не ТекущаяСтрокаУстановлена Тогда
					ЭлементыФормы.СчетчикиНового.ТекущаяСтрока = СтрокаПриемника;
					ТекущаяСтрокаУстановлена = Истина;
				КонецЕсли; 
				ЭлементыФормы.СчетчикиНового.ВыделенныеСтроки.Добавить(СтрокаПриемника);
			КонецЦикла;
		КонецЕсли; 
	КонецЕсли;
	
КонецПроцедуры

Процедура КПСборщикиСчетчиковКонсольКомпоновки(Кнопка)
	
	ПосмотретьГрафики(ЭлементыФормы.СборщикиСчетчиков.ТекущаяСтрока, 1);
	
КонецПроцедуры

Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	ирОбщий.ПроверитьПлатформаНеWindowsЛкс(Отказ);
КонецПроцедуры

ирОбщий.ИнициироватьФормуЛкс(ЭтаФорма, "Обработка.ирСборщикиСчетчиковWindows.Форма.Форма");
