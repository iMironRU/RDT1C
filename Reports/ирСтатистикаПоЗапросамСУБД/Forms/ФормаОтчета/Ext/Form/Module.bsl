﻿
Процедура ТабличныйДокументОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка, ДополнительныеПараметры)
	
	ирОбщий.ОтчетКомпоновкиОбработкаРасшифровкиЛкс(ЭтаФорма, Расшифровка, СтандартнаяОбработка, ДополнительныеПараметры, Элемент, ДанныеРасшифровки, Авторасшифровка);

КонецПроцедуры

Процедура ДействиеРасшифровки(ВыбранноеДействие, ПараметрВыбранногоДействия, СтандартнаяОбработка) Экспорт
	
	#Если Сервер И Не Сервер Тогда
	    ПараметрВыбранногоДействия = Новый Соответствие;
	#КонецЕсли
	АнализТехножурнала = ирОбщий.ПолучитьОбъектПоПолномуИмениМетаданныхЛкс("Обработка.ирАнализТехножурнала");
		#Если Сервер И Не Сервер Тогда
		    АнализТехножурнала = Обработки.ирАнализТехножурнала.Создать();
		#КонецЕсли
	Если ВыбранноеДействие = "ОткрытьТекстЗапроса" Тогда
		ТекстЗапроса = ПараметрВыбранногоДействия["ТекстЗапроса"];
		АнализТехножурнала.ОткрытьТекстБДВКонверторе(ТекстЗапроса,,, Ложь);
	ИначеЕсли ВыбранноеДействие = "ОткрытьПланЗапроса" Тогда
		#Если ВебКлиент Тогда
			Предупреждение("Функция недоступна в вебклиенте");
		#Иначе
			ИмяВременногоФайла = ПолучитьИмяВременногоФайла("sqlplan");
			//СтандартнаяОбработка = Ложь;
			ПланЗапроса = ПараметрВыбранногоДействия["query_plan"];
			Если ЗначениеЗаполнено(ПланЗапроса) Тогда
				ПланЗапроса = ОтформатироватьТекстXML(ПланЗапроса);
				Ответ = Вопрос("Перевести план запроса в термины метаданных?", РежимДиалогаВопрос.ДаНет,, КодВозвратаДиалога.Да);
				Если Ответ = КодВозвратаДиалога.Да Тогда
					ПланЗапроса = АнализТехножурнала.ПеревестиТекстБДВТерминыМетаданных(ПланЗапроса,,, "MSSQL",, 999999);
				КонецЕсли;
				ТекстовыйДокумент = Новый ТекстовыйДокумент;
				ТекстовыйДокумент.УстановитьТекст(ПланЗапроса);
				ТекстовыйДокумент.Записать(ИмяВременногоФайла);
				ЗапуститьПриложение(ИмяВременногоФайла);
			КонецЕсли; 
		#КонецЕсли 
	КонецЕсли; 
	
КонецПроцедуры

Процедура ОбработкаРасшифровки(ДанныеРасшифровки, ЭлементРасшифровки, ТабличныйДокумент, ДоступныеДействия, СписокДополнительныхДействий,
	РазрешитьАвтовыборДействия, ЗначенияВсехПолей) Экспорт 
	
	#Если Сервер И Не Сервер Тогда
		ДанныеРасшифровки = Новый ДанныеРасшифровкиКомпоновкиДанных;
		ЭлементРасшифровки = ДанныеРасшифровки.Элементы[0];
		ТабличныйДокумент = Новый ТабличныйДокумент;
		ДоступныеДействия = Новый Массив;
	#КонецЕсли
	ДоступныеДействия.Добавить(ДействиеОбработкиРасшифровкиКомпоновкиДанных.Отфильтровать);
	ДоступныеДействия.Добавить(ДействиеОбработкиРасшифровкиКомпоновкиДанных.Оформить);
	ДоступныеДействия.Добавить(ДействиеОбработкиРасшифровкиКомпоновкиДанных.Упорядочить);
	ЗначенияПолей = ЭлементРасшифровки.ПолучитьПоля();
	Если Ложь
		Или ЗначенияПолей.Найти("ТекстЗапроса") <> Неопределено
		Или ЗначенияПолей.Найти("ТекстЗапросаМета") <> Неопределено
	Тогда 
		СписокДополнительныхДействий.Вставить(0, "ОткрытьТекстЗапроса", "Открыть запрос");
	ИначеЕсли Ложь
		Или ЗначенияПолей.Найти("query_plan") <> Неопределено
	Тогда 
		СписокДополнительныхДействий.Вставить(0, "ОткрытьПланЗапроса", "Открыть план");
	КонецЕсли;
	
КонецПроцедуры

Процедура ДействияФормыПараметрыСУБД(Кнопка)
	
	ирОбщий.ОткрытьФормуСоединенияСУБДЛкс();
	
КонецПроцедуры

Функция ОтформатироватьТекстXML(ТекстXML) Экспорт 

	Если Не ЗначениеЗаполнено(ТекстXML) Тогда
		Возврат "";
	КонецЕсли; 
	Дом = ирОбщий.ПрочитатьТекстВДокументDOMЛкс("<_>" + ТекстXML + "</_>");
	ЗаписьXML = Новый ЗаписьXML;
	ЗаписьДОМ = Новый ЗаписьDOM;
	ОтформатированныйТекст = "";
	Для Каждого ДочернийУзел Из ДОМ.ПервыйДочерний.ДочерниеУзлы Цикл
		ЗаписьXML.УстановитьСтроку();
		ЗаписьДОМ.Записать(ДочернийУзел, ЗаписьXML);
		Если ОтформатированныйТекст <> "" Тогда
			ОтформатированныйТекст = ОтформатированныйТекст + Символы.ПС;
		КонецЕсли;
		ОтформатированныйТекст = ОтформатированныйТекст + ЗаписьXML.Закрыть();
	КонецЦикла;
	Возврат ОтформатированныйТекст;

КонецФункции // ОтформатироватьТекстXML()

Процедура ПриОткрытии()
	
	ЭтаФорма.Авторасшифровка = Истина;
	Если ирКэш.ЭтоФайловаяБазаЛкс() Тогда 
		Сообщить("Для использования инструмента необходима клиент-серверная база", СтатусСообщения.Внимание);
		//Панель.Доступность = Ложь;
	КонецЕсли;
	КнопкиПодменю = ЭлементыФормы.ДействияФормы.Кнопки.Варианты.Кнопки;
	Для Каждого ВариантНастроек Из СхемаКомпоновкиДанных.ВариантыНастроек Цикл
		Кнопка = КнопкиПодменю.Добавить();
		Кнопка.ТипКнопки = ТипКнопкиКоманднойПанели.Действие;
		Кнопка.Имя = ВариантНастроек.Имя;
		Кнопка.Текст = ВариантНастроек.Представление;
		Кнопка.Действие = Новый Действие("КнопкаВариантаНастроек");
	КонецЦикла;
	Если ЗначениеЗаполнено(ПараметрКлючВарианта) Тогда
		ВариантНастроек = СхемаКомпоновкиДанных.ВариантыНастроек[ПараметрКлючВарианта];
		КомпоновщикНастроек.ЗагрузитьНастройки(ВариантНастроек.Настройки);
	КонецЕсли; 

КонецПроцедуры

Процедура КнопкаВариантаНастроек(Кнопка)
	
	КомпоновщикНастроек.ЗагрузитьНастройки(СхемаКомпоновкиДанных.ВариантыНастроек[Кнопка.Имя].Настройки);
	
КонецПроцедуры

Процедура ДействияФормыНоваяКонсоль(Кнопка)
	
	ирОбщий.ОткрытьНовоеОкноОбработкиЛкс(ЭтотОбъект);
	
КонецПроцедуры

Процедура ДействияФормыСтруктураФормы(Кнопка)
	
	ирОбщий.ОткрытьСтруктуруФормыЛкс(ЭтаФорма);
	
КонецПроцедуры

Процедура ДействияФормыОПодсистеме(Кнопка)
	
	ирОбщий.ОткрытьСправкуПоПодсистемеЛкс(ЭтотОбъект);
	
КонецПроцедуры

Процедура ДействияФормыСформировать(Кнопка = Неопределено) Экспорт 
	
	РежимОтладки = 0;
	СкомпоноватьРезультат(ЭлементыФормы.ТабличныйДокумент, ДанныеРасшифровки);
	ЭлементыФормы.ТабличныйДокумент.ПоказатьУровеньГруппировокСтрок(0);
	
КонецПроцедуры

Процедура ДействияФормыКопия(Кнопка)
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.Вывести(ЭлементыФормы.ТабличныйДокумент);
	ЗаполнитьЗначенияСвойств(ТабличныйДокумент, ЭлементыФормы.ТабличныйДокумент); 
	Результат = ирОбщий.ОткрытьЗначениеЛкс(ТабличныйДокумент,,,, Ложь);

КонецПроцедуры

Процедура СтруктураКоманднойПанелиНажатие(Кнопка)
	
	ирОбщий.ОткрытьСтруктуруКоманднойПанелиЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура ДействияФормыИсполняемаяКомпоновка(Кнопка)
	
	РежимОтладки = 2;
	СкомпоноватьРезультат(ЭлементыФормы.ТабличныйДокумент, ДанныеРасшифровки);
	
КонецПроцедуры

Процедура ДействияФормыЗапросСтатистики(Кнопка)
	
	РежимОтладки = 1;
	СкомпоноватьРезультат(ЭлементыФормы.ТабличныйДокумент, ДанныеРасшифровки);
	
КонецПроцедуры

ирОбщий.ИнициализироватьФормуЛкс(ЭтаФорма, "Отчет.ирСтатистикаПоЗапросамСУБД.Форма.ФормаОтчета");

