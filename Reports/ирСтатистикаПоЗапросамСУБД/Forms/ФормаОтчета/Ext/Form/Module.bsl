﻿// +++.КЛАСС.ПолеТабличногоДокументаСГруппировками
Перем ПолеТабличногоДокументаСГруппировками;
// ---.КЛАСС.ПолеТабличногоДокументаСГруппировками

Процедура ТабличныйДокументОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка, ДополнительныеПараметры)
	
	Перем ВыбранноеДействие, ПараметрВыбранногоДействия;
	#Если _ Тогда
		ДанныеРасшифровки = Новый ДанныеРасшифровкиКомпоновкиДанных;
		ЭлементРасшифровки = ДанныеРасшифровки.Элементы[0];
		ТабличныйДокумент = Новый ТабличныйДокумент;
	#КонецЕсли
	Если ТипЗнч(Расшифровка) <> Тип("ИдентификаторРасшифровкиКомпоновкиДанных") Тогда
		Возврат;
	КонецЕсли; 
	ЭлементРасшифровки = ДанныеРасшифровки.Элементы[Расшифровка];
	ДоступныеДействия = Новый Массив;
	РазрешитьАвтовыборДействия = Истина;
	СписокДополнительныхДействий = Новый СписокЗначений;
	ОбработкаРасшифровки(ДанныеРасшифровки, ЭлементРасшифровки, ЭлементыФормы.ТабличныйДокумент, ДоступныеДействия, СписокДополнительныхДействий, РазрешитьАвтовыборДействия);
	Если Истина
		И РазрешитьАвтовыборДействия
		И Авторасшифровка 
		И СписокДополнительныхДействий.Количество() = 1 
	Тогда
		ВыбранноеДействие = СписокДополнительныхДействий[0].Значение;
	КонецЕсли;
	Если ВыбранноеДействие = Неопределено Тогда
		ИсточникДоступныхНастроек = Новый ИсточникДоступныхНастроекКомпоновкиДанных(СхемаКомпоновкиДанных);
		ОбработкаРасшифровки = Новый ОбработкаРасшифровкиКомпоновкиДанных(ДанныеРасшифровки, ИсточникДоступныхНастроек);
		ОбработкаРасшифровки.ВыбратьДействие(Расшифровка, ВыбранноеДействие, ПараметрВыбранногоДействия, ДоступныеДействия, СписокДополнительныхДействий, Авторасшифровка);	
	КонецЕсли;
	Если ВыбранноеДействие = ДействиеОбработкиРасшифровкиКомпоновкиДанных.Нет Тогда
		СтандартнаяОбработка = Ложь;
		Возврат;
	КонецЕсли;
	Если ПараметрВыбранногоДействия = Неопределено Тогда
		ПараметрВыбранногоДействия = Новый Структура;
		ЗначенияПолей = ЭлементРасшифровки.ПолучитьПоля();
		Для Каждого ЗначениеПоля Из ЗначенияПолей Цикл
			ПараметрВыбранногоДействия.Вставить(ЗначениеПоля.Поле, ЗначениеПоля.Значение);
		КонецЦикла;
	КонецЕсли;
	ДействиеРасшифровки(ВыбранноеДействие, ПараметрВыбранногоДействия, СтандартнаяОбработка);
	Если СтандартнаяОбработка Тогда
		Если ВыбранноеДействие = ДействиеОбработкиРасшифровкиКомпоновкиДанных.ОткрытьЗначение Тогда
			ОткрытьЗначение(ПараметрВыбранногоДействия);
		ИначеЕсли ТипЗнч(ВыбранноеДействие) = Тип("ДействиеОбработкиРасшифровкиКомпоновкиДанных") Тогда
			ИсточникДоступныхНастроек = Новый ИсточникДоступныхНастроекКомпоновкиДанных(СхемаКомпоновкиДанных);
			ОбработкаРасшифровки = Новый ОбработкаРасшифровкиКомпоновкиДанных(ДанныеРасшифровки, ИсточникДоступныхНастроек);
			НовыеНастройки = ОбработкаРасшифровки.ПрименитьНастройки(Расшифровка, ПараметрВыбранногоДействия);
			ОтчетОбъект.КомпоновщикНастроек.ЗагрузитьНастройки(НовыеНастройки);
			СкомпоноватьРезультат(РежимКомпоновкиРезультата.Непосредственно);
		КонецЕсли;
	КонецЕсли;
	СтандартнаяОбработка = Ложь;

КонецПроцедуры


// @@@.КЛАСС.ПолеТабличногоДокументаСГруппировками
Процедура КлсПолеТабличногоДокументаСГруппировкамиНажатие(Кнопка)
	
	ПолеТабличногоДокументаСГруппировками.Нажатие(Кнопка);
	
КонецПроцедуры

Процедура ДействияФормыПараметрыСУБД(Кнопка)
	
	ирОбщий.ОткрытьФормуСоединенияСУБДЛкс().Открыть();
	
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

Процедура ДействиеРасшифровки(ВыбранноеДействие, ПараметрВыбранногоДействия, СтандартнаяОбработка) Экспорт
	
	АнализТехножурнала = Обработки.ирАнализТехножурнала.Создать();
	Если ВыбранноеДействие = "ОткрытьТекстЗапроса" Тогда
		ТекстЗапроса = Неопределено;
		ПараметрВыбранногоДействия.Свойство("ТекстЗапроса", ТекстЗапроса);
		АнализТехножурнала.ОткрытьТекстБДВКонверторе(ТекстЗапроса,,, Ложь);
	ИначеЕсли ВыбранноеДействие = "ОткрытьПланЗапроса" Тогда
		#Если ВебКлиент Тогда
			Предупреждение("Функция недоступна в вебклиенте");
		#Иначе
			ИмяВременногоФайла = ПолучитьИмяВременногоФайла("sqlplan");
			//СтандартнаяОбработка = Ложь;
			ПланЗапроса = Неопределено;
			ПараметрВыбранногоДействия.Свойство("query_plan", ПланЗапроса);
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
	РазрешитьАвтовыборДействия) Экспорт 
	
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
		СписокДополнительныхДействий.Добавить("ОткрытьТекстЗапроса", "Открыть");
	ИначеЕсли Ложь
		Или ЗначенияПолей.Найти("query_plan") <> Неопределено
	Тогда 
		СписокДополнительныхДействий.Добавить("ОткрытьПланЗапроса", "Открыть");
	КонецЕсли; 
	
КонецПроцедуры

Процедура ПриОткрытии()
	
	Если ирКэш.ЭтоФайловаяБазаЛкс() Тогда 
		Сообщить("Для использования инструмента необходима клиент-серверная база");
		Панель.Доступность = Ложь;
	КонецЕсли; 

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

Процедура ДействияФормыСформировать(Кнопка)
	
	СкомпоноватьРезультат(ЭлементыФормы.ТабличныйДокумент, ДанныеРасшифровки);
	ЭлементыФормы.ТабличныйДокумент.ПоказатьУровеньГруппировокСтрок(1);
	
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


ирОбщий.ИнициализироватьФормуЛкс(ЭтаФорма, "Отчет.ирСтатистикаПоЗапросамСУБД.Форма.ФормаОтчета");

// +++.КЛАСС.ПолеТабличногоДокументаСГруппировками
ПолеТабличногоДокументаСГруппировками = ирОбщий.ПолучитьОбъектПоПолномуИмениМетаданныхЛкс("Обработка.ирКлсПолеТабличногоДокументаСГруппировками");
#Если Сервер И Не Сервер Тогда
	ПолеТабличногоДокументаСГруппировками = Обработки.ирКлсПолеТабличногоДокументаСГруппировками.Создать();
#КонецЕсли
ПолеТабличногоДокументаСГруппировками.Инициализировать(, ЭтаФорма, ЭлементыФормы.ТабличныйДокумент);
// ---.КЛАСС.ПолеТабличногоДокументаСГруппировками

ЭтаФорма.Авторасшифровка = Истина;

