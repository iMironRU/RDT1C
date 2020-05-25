﻿
Процедура ТабличныйДокументОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка, ДополнительныеПараметры)
	
	ирОбщий.ОтчетКомпоновкиОбработкаРасшифровкиЛкс(ЭтаФорма, Расшифровка, СтандартнаяОбработка, ДополнительныеПараметры, Элемент, ДанныеРасшифровки, Авторасшифровка);
	
КонецПроцедуры

Процедура ДействиеРасшифровки(ВыбранноеДействие, ПараметрВыбранногоДействия, СтандартнаяОбработка) Экспорт
	
	Перем Пользователь, ОбъектМетаданных;
	#Если Сервер И Не Сервер Тогда
	    ПараметрВыбранногоДействия = Новый Соответствие;
	#КонецЕсли
	Если ВыбранноеДействие = "ОткрытьПользователя" Тогда
		Пользователь = ПараметрВыбранногоДействия["Пользователь"];
		ирОбщий.ОткрытьПользователяИБЛкс(Пользователь);
	ИначеЕсли ВыбранноеДействие = "ОткрытьОбъектМетаданных" Тогда
		ОбъектМетаданных = ПараметрВыбранногоДействия["ОбъектМетаданных"];
		ирОбщий.ОткрытьОбъектМетаданныхЛкс(ОбъектМетаданных);
	ИначеЕсли ВыбранноеДействие = "ОткрытьОграничениеДоступа" Тогда
		СтруктураПараметров = Новый Структура;
		СтруктураПараметров.Вставить("ТаблицаБД", ПараметрВыбранногоДействия["ОбъектМетаданных"]);
		СтруктураПараметров.Вставить("Роль", ПараметрВыбранногоДействия["Роль"]);
		СтруктураПараметров.Вставить("Право", ирОбщий.ПоследнийФрагментЛкс(ПараметрВыбранногоДействия["Право"], "."));
		Если Не ЗначениеЗаполнено(СтруктураПараметров.Роль) Тогда
			Сообщить("Для открытия ограничения доступа необходима группировка либо отбор на равенство по роли");
			Возврат;
		КонецЕсли; 
		Если Не ЗначениеЗаполнено(СтруктураПараметров.ТаблицаБД) Тогда
			Сообщить("Для открытия ограничения доступа необходима группировка либо отбор на равенство по объекту метаданных");
			Возврат;
		КонецЕсли; 
		Если Не ЗначениеЗаполнено(СтруктураПараметров.Право) Тогда
			Сообщить("Для открытия ограничения доступа необходима группировка либо отбор на равенство по праву");
			Возврат;
		КонецЕсли; 
		ФормаОграниченияДоступа = ирОбщий.ПолучитьФормуЛкс("Обработка.ирРедакторОграниченияДоступа.Форма",,, ЗначениеВСтрокуВнутр(СтруктураПараметров));
		ЗаполнитьЗначенияСвойств(ФормаОграниченияДоступа, СтруктураПараметров); 
		ФормаОграниченияДоступа.Открыть();
	КонецЕсли; 
	
КонецПроцедуры

Процедура ОбработкаРасшифровки(ДанныеРасшифровки, ЭлементРасшифровки, ТабличныйДокумент, ДоступныеДействия, СписокДополнительныхДействий, РазрешитьАвтовыборДействия, ЗначенияВсехПолей) Экспорт 
	
	#Если Сервер И Не Сервер Тогда
		ДанныеРасшифровки = Новый ДанныеРасшифровкиКомпоновкиДанных;
		ЭлементРасшифровки = ДанныеРасшифровки.Элементы[0];
		ТабличныйДокумент = Новый ТабличныйДокумент;
		ДоступныеДействия = Новый Массив;
	#КонецЕсли
	ДоступныеДействия.Добавить(ДействиеОбработкиРасшифровкиКомпоновкиДанных.Отфильтровать);
	ДоступныеДействия.Добавить(ДействиеОбработкиРасшифровкиКомпоновкиДанных.Оформить);
	ДоступныеДействия.Добавить(ДействиеОбработкиРасшифровкиКомпоновкиДанных.Сгруппировать);
	ДоступныеДействия.Добавить(ДействиеОбработкиРасшифровкиКомпоновкиДанных.Упорядочить);
	ДоступныеДействия.Добавить(ДействиеОбработкиРасшифровкиКомпоновкиДанных.Расшифровать);
	ЗначенияПолей = ЭлементРасшифровки.ПолучитьПоля();
	Если ЗначенияПолей.Найти("Пользователь") <> Неопределено Тогда 
		СписокДополнительныхДействий.Вставить(0, "ОткрытьПользователя", "Открыть пользователя");
	КонецЕсли; 
	Если ЗначенияПолей.Найти("ОбъектМетаданных") <> Неопределено Тогда 
		СписокДополнительныхДействий.Вставить(0, "ОткрытьОбъектМетаданных", "Открыть объект метаданных");
	КонецЕсли; 
	Если Истина
		И ЗначенияПолей.Найти("Доступ") <> Неопределено 
		И Найти(ЗначенияПолей.Найти("Доступ").Значение, "да") = 1 
	Тогда 
		Если Ложь
			Или ЗначенияВсехПолей["Право"] = Неопределено
			Или ирОбщий.ПраваСОграничениямиДоступаКДаннымЛкс().НайтиПоЗначению(ирОбщий.ПоследнийФрагментЛкс(ЗначенияВсехПолей["Право"], ".")) <> Неопределено 
		Тогда 
			СписокДополнительныхДействий.Вставить(0, "ОткрытьОграничениеДоступа", "Открыть ограничение доступа");
		КонецЕсли; 
	КонецЕсли; 
	
КонецПроцедуры

Процедура ПриОткрытии()
	
	ЭтаФорма.Авторасшифровка = Истина;
	КнопкиПодменю = ЭлементыФормы.ДействияФормы.Кнопки.Варианты.Кнопки;
	Для Каждого ВариантНастроек Из СхемаКомпоновкиДанных.ВариантыНастроек Цикл
		Кнопка = КнопкиПодменю.Добавить();
		Кнопка.ТипКнопки = ТипКнопкиКоманднойПанели.Действие;
		Кнопка.Имя = ВариантНастроек.Имя;
		Кнопка.Текст = ВариантНастроек.Представление;
		Кнопка.Действие = Новый Действие("КнопкаВариантаНастроек");
	КонецЦикла;
	Если ЗначениеЗаполнено(ПараметрКлючВарианта) Тогда
		ЗагрузитьВариант(ПараметрКлючВарианта);
	КонецЕсли; 

КонецПроцедуры

Процедура КнопкаВариантаНастроек(Кнопка)
	
	ЗагрузитьВариант(Кнопка.Имя);
	
КонецПроцедуры

Процедура ЗагрузитьВариант(Знач ИмяВарианта) 
	
	КомпоновщикНастроек.ЗагрузитьНастройки(СхемаКомпоновкиДанных.ВариантыНастроек[ИмяВарианта].Настройки);

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
	//ЭлементыФормы.ТабличныйДокумент.ПоказатьУровеньГруппировокСтрок(0);
	
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

Процедура ПользовательНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	
	ирОбщий.ПолеВводаСИсториейВыбора_НачалоВыбораИзСпискаЛкс(Элемент, ЭтаФорма);
	
КонецПроцедуры

Процедура ПользовательПриИзменении(Элемент)
	
	ирОбщий.ПолеВводаСИсториейВыбора_ПриИзмененииЛкс(Элемент, ЭтаФорма);

КонецПроцедуры

Процедура ПользовательНачалоВыбора(Элемент, СтандартнаяОбработка)
	ФормаВыбора = ирОбщий.ПолучитьФормуЛкс("Обработка.ирРедакторПользователей.Форма",, Элемент);
	ФормаВыбора.РежимВыбора = Истина;
	ФормаВыбора.НачальноеЗначениеВыбора = Элемент.Значение;
	РезультатВыбора = ФормаВыбора.ОткрытьМодально();
	Если РезультатВыбора <> Неопределено Тогда
		ирОбщий.ИнтерактивноЗаписатьВЭлементУправленияЛкс(Элемент, РезультатВыбора);
	КонецЕсли; 
КонецПроцедуры

Процедура ОбъектМетаданныхПриИзменении(Элемент)
	ирОбщий.ПолеВводаСИсториейВыбора_ПриИзмененииЛкс(Элемент, ЭтаФорма);
КонецПроцедуры

Процедура ОбъектМетаданныхНачалоВыбора(Элемент, СтандартнаяОбработка)
	ФормаВыбора = ирОбщий.ПолучитьФормуВыбораОбъектаМетаданныхЛкс(Элемент,, Элемент.Значение,, Истина, Истина, Истина, Истина, Истина,,,,,, Истина,, Истина, Истина);
	РезультатВыбора = ФормаВыбора.ОткрытьМодально();
	Если РезультатВыбора <> Неопределено Тогда
		ирОбщий.ИнтерактивноЗаписатьВЭлементУправленияЛкс(Элемент, РезультатВыбора.ПолноеИмяОбъекта);
	КонецЕсли; 
КонецПроцедуры

Процедура ОбъектМетаданныхНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	ирОбщий.ПолеВводаСИсториейВыбора_НачалоВыбораИзСпискаЛкс(Элемент, ЭтаФорма);
КонецПроцедуры

Процедура ДействияФормыОграничениеДоступаКДанным(Кнопка)
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("ТаблицаБД", ОбъектМетаданных);
	ФормаОграниченияДоступа = ирОбщий.ПолучитьФормуЛкс("Обработка.ирРедакторОграниченияДоступа.Форма",,, ЗначениеВСтрокуВнутр(СтруктураПараметров));
	ЗаполнитьЗначенияСвойств(ФормаОграниченияДоступа, СтруктураПараметров); 
	ФормаОграниченияДоступа.Открыть();
		
КонецПроцедуры

ирОбщий.ИнициализироватьФормуЛкс(ЭтаФорма, "Отчет.ирАнализПравДоступа.Форма.ФормаОтчета");

