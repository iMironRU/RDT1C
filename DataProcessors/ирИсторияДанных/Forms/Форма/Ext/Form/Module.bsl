﻿Перем мОписанияТиповПолей;

Процедура ПриОткрытии()
	
	ПроверятьНаличиеВерсийПриИзменении();
	КПТипыОбновить();
	
КонецПроцедуры

Процедура КПТипыОбновить(Кнопка = Неопределено)
	
	Поля.Очистить();
	Версии.Очистить();
	ИсторияДанныхМоя = Вычислить("ИсторияДанных");
	#Если Сервер И Не Сервер Тогда
		ИсторияДанныхМоя = ИсторияДанных;
	#КонецЕсли
	ТекущийТип = ЭлементыФормы.Типы.ТекущаяСтрока;
	Если ТекущийТип <> Неопределено Тогда
		ТекущийТип = ТекущийТип.ПолноеИмяМД;
	КонецЕсли; 
	Типы.Очистить(); 
	ИспользованиеИсторииДанныхИспользовать = Метаданные.СвойстваОбъектов.ИспользованиеИсторииДанных.Использовать;
	СтрокиМетаОбъектов = мПлатформа.ТаблицаТиповМетаОбъектов.НайтиСтроки(Новый Структура("Категория", 0));
	ИндикаторТипаМетаданных = ирОбщий.ПолучитьИндикаторПроцессаЛкс(СтрокиМетаОбъектов.Количество(), "Типы метаданных");
	Для Каждого СтрокаТаблицыМетаОбъектов Из СтрокиМетаОбъектов Цикл
		ирОбщий.ОбработатьИндикаторЛкс(ИндикаторТипаМетаданных);
		Единственное = СтрокаТаблицыМетаОбъектов.Единственное;
		Если Ложь
			Или ирОбщий.ЛиКорневойТипСсылкиЛкс(Единственное, Истина, Истина) 
			Или ирОбщий.ЛиКорневойТипРегистраСведенийЛкс(Единственное)
			Или ирОбщий.ЛиКорневойТипКонстантыЛкс(Единственное)
		Тогда 
			КоллекцияМетаданных = Метаданные[СтрокаТаблицыМетаОбъектов.Множественное];
			ИндикаторТипаОбъектов = ирОбщий.ПолучитьИндикаторПроцессаЛкс(КоллекцияМетаданных.Количество(), Единственное);
			Для Каждого ОбъектМД Из КоллекцияМетаданных Цикл
				ирОбщий.ОбработатьИндикаторЛкс(ИндикаторТипаОбъектов);
				#Если Сервер И Не Сервер Тогда
					ОбъектМД = Метаданные.Справочники.ирАлгоритмы;
				#КонецЕсли
				ПолноеИмя = ОбъектМД.ПолноеИмя();
				Попытка
					НастройкиИстории = ИсторияДанныхМоя.ПолучитьНастройки(ОбъектМД);
				Исключение
					// В этой версии платформы не поддерживается этот корневой тип метаданных
					//ОписаниеОшибки = ОписаниеОшибки();
					Продолжить;
				КонецПопытки; 
				СтрокаДанных = Типы.Добавить();
				СтрокаДанных.ТипМетаданных = ирОбщий.ПолучитьПервыйФрагментЛкс(ПолноеИмя);
				СтрокаДанных.ПолноеИмяМД = ПолноеИмя;
				СтрокаДанных.ИмяМД = ОбъектМД.Имя;
				СтрокаДанных.ПредставлениеМД = ОбъектМД.Представление();
				СтрокаДанных.ИспользованиеВМетаданных = ОбъектМД.ИсторияДанных = ИспользованиеИсторииДанныхИспользовать;
				СтрокаДанных.Использование = СтрокаДанных.ИспользованиеВМетаданных;
				ОбновитьПредставлениеПолейВСтрокеТипа(НастройкиИстории, ОбъектМД, СтрокаДанных);
				Если ВычислятьКоличествоВерсий Тогда
					СтрокаДанных.КоличествоВерсий = ВыбратьВерсии(ИсторияДанныхМоя, ОбъектМД).Количество();
				КонецЕсли; 
			КонецЦикла;
			ирОбщий.ОсвободитьИндикаторПроцессаЛкс();
		КонецЕсли;
	КонецЦикла;
	ирОбщий.ОсвободитьИндикаторПроцессаЛкс();
	Типы.Сортировать("ПолноеИмяМД");
	Если ТекущийТип <> Неопределено Тогда
		ЭлементыФормы.Типы.ТекущаяСтрока = Типы.Найти(ТекущийТип, "ПолноеИмяМД");
	КонецЕсли; 
	
КонецПроцедуры

Процедура ОбновитьПредставлениеПолейВСтрокеТипа(Знач НастройкиИстории, ОбъектМД, Знач СтрокаДанных = Неопределено)
	
	Если СтрокаДанных = Неопределено Тогда
		СтрокаДанных = ЭлементыФормы.Типы.ТекущаяСтрока;
	КонецЕсли; 
	ИспользованиеПолейНастроекИстории = Неопределено;
	Если НастройкиИстории <> Неопределено Тогда
		СтрокаДанных.Использование = НастройкиИстории.Использование;
		ИспользованиеПолейНастроекИстории = НастройкиИстории.ИспользованиеПолей;
	КонецЕсли;
	ТаблицаПолей = ИспользованиеПолей(ОбъектМД, ИспользованиеПолейНастроекИстории);
	СтрокаДанных.ПоляВключенные = ПредставлениеПолей(ТаблицаПолей, Истина);
	СтрокаДанных.ПоляВыключенные = ПредставлениеПолей(ТаблицаПолей, Ложь);

КонецПроцедуры

Функция ИспользованиеПолей(ОбъектМД, ИспользованиеПолейНастроекИстории = Неопределено, Подробно = Ложь)
	
	#Если Сервер И Не Сервер Тогда
		ОбъектМД = Метаданные.Справочники.ирАлгоритмы;
	#КонецЕсли
	Если ИспользованиеПолейНастроекИстории = Неопределено Тогда
		ИсторияДанныхМоя = Вычислить("ИсторияДанных");
		#Если Сервер И Не Сервер Тогда
			ИсторияДанныхМоя = ИсторияДанных;
		#КонецЕсли
		НастройкиИстории = ИсторияДанныхМоя.ПолучитьНастройки(ОбъектМД);
		Если НастройкиИстории <> Неопределено Тогда
			ИспользованиеПолейНастроекИстории = НастройкиИстории.ИспользованиеПолей;
		КонецЕсли;
	КонецЕсли; 
	ТаблицаПолей = Поля.ВыгрузитьКолонки();
	ИспользованиеИсторииДанныхИспользовать = Метаданные.СвойстваОбъектов.ИспользованиеИсторииДанных.Использовать;
	Если Метаданные.Константы.Содержит(ОбъектМД) Тогда
		Возврат ТаблицаПолей;
	КонецЕсли; 
	#Если Сервер И Не Сервер Тогда
		ТаблицаПолей = Поля;
	#КонецЕсли
	ИмяПоляВерсияДанных = ирОбщий.ПеревестиСтроку("ВерсияДанных");
	ИмяПоляНомерСтроки = ирОбщий.ПеревестиСтроку("НомерСтроки");
	ИмяПоляСсылка = ирОбщий.ПеревестиСтроку("Ссылка");
	Если Подробно Тогда
		мОписанияТиповПолей = Новый ТаблицаЗначений;
		мОписанияТиповПолей.Колонки.Добавить("Имя");
		мОписанияТиповПолей.Колонки.Добавить("ОписаниеТипов");
	КонецЕсли; 
	Для Каждого СтандартныйРеквизит Из ОбъектМД.СтандартныеРеквизиты Цикл
		Если СтандартныйРеквизит.Имя = ИмяПоляСсылка Тогда
			Продолжить;
		КонецЕсли; 
		СтрокаПоля = ТаблицаПолей.Добавить();
		СтрокаПоля.ИмяПоля = СтандартныйРеквизит.Имя;
		СтрокаПоля.ПредставлениеПоля  = СтандартныйРеквизит.Представление();
		СтрокаПоля.ИспользованиеВМетаданных = СтандартныйРеквизит.ИсторияДанных = ИспользованиеИсторииДанныхИспользовать;
		СтрокаПоля.Использование = СтрокаПоля.ИспользованиеВМетаданных;
		СтрокаПоля.ТипПоля = 1;
		Если ИспользованиеПолейНастроекИстории <> Неопределено И ИспользованиеПолейНастроекИстории[СтрокаПоля.ИмяПоля] <> Неопределено Тогда
			СтрокаПоля.Использование = ИспользованиеПолейНастроекИстории[СтрокаПоля.ИмяПоля];
		КонецЕсли; 
		Если Подробно Тогда
			СтрокаОписанияТипов = мОписанияТиповПолей.Добавить();
			СтрокаОписанияТипов.Имя = СтрокаПоля.ИмяПоля;
			СтрокаОписанияТипов.ОписаниеТипов = СтандартныйРеквизит.Тип;
			СтрокаПоля.ОписаниеТипов = ирОбщий.РасширенноеПредставлениеЗначенияЛкс(СтрокаОписанияТипов.ОписаниеТипов);
		КонецЕсли; 
	КонецЦикла;
	ТабличныеЧасти = ирОбщий.ТабличныеЧастиОбъектаЛкс(ОбъектМД);
	#Если Сервер И Не Сервер Тогда
		ТабличныеЧасти = Новый Структура;
	#КонецЕсли
	ТабличныеЧасти.Вставить("_", ОбъектМД);
	ИмяТаблицыБД = ирОбщий.ИмяТаблицыИзМетаданныхЛкс(ОбъектМД);
	Для Каждого ОписаниеТЧ Из ТабличныеЧасти Цикл
		Если ОписаниеТЧ.Ключ = "_" Тогда
			ПоляТаблицыБД = ирКэш.ПоляТаблицыБДЛкс(ИмяТаблицыБД);
		Иначе
			ПоляТаблицыБД = ирКэш.ПоляТаблицыБДЛкс(ИмяТаблицыБД + "." + ОписаниеТЧ.Ключ);
		КонецЕсли; 
		Для Каждого СтрокаПоляБД Из ПоляТаблицыБД Цикл
			ИмяПоля = СтрокаПоляБД.Имя;
			ПредставлениеПоля = СтрокаПоляБД.Заголовок;
			Если ОписаниеТЧ.Ключ = "_" Тогда
				Если Ложь
					Или ТаблицаПолей.Найти(ИмяПоля, "ИмяПоля") <> Неопределено 
					Или ИмяПоля = ИмяПоляСсылка
					Или ИмяПоля = ИмяПоляВерсияДанных
					Или СтрокаПоляБД.ТипЗначения.СодержитТип(Тип("ТаблицаЗначений"))
				Тогда
					Продолжить;
				КонецЕсли;
				ТипПоля = 2;
			Иначе
				Если Ложь
					Или ИмяПоля = ИмяПоляСсылка
					Или ИмяПоля = ИмяПоляНомерСтроки
				Тогда
					Продолжить;
				КонецЕсли; 
				ИмяПоля = ОписаниеТЧ.Ключ + "." + ИмяПоля;
				ПредставлениеПоля = ОписаниеТЧ.Значение + "." + ПредставлениеПоля;
				ТипПоля = 3;
			КонецЕсли; 
			СтрокаПоля = ТаблицаПолей.Добавить();
			СтрокаПоля.ИмяПоля = ИмяПоля;
			СтрокаПоля.ПредставлениеПоля = ПредставлениеПоля;
			МетаданныеПоля = СтрокаПоляБД.Метаданные;
			Если МетаданныеПоля <> Неопределено Тогда
				СтрокаПоля.ИспользованиеВМетаданных = МетаданныеПоля.ИсторияДанных = ИспользованиеИсторииДанныхИспользовать;
			КонецЕсли; 
			СтрокаПоля.Использование = СтрокаПоля.ИспользованиеВМетаданных;
			СтрокаПоля.ТипПоля = ТипПоля;
			Если ИспользованиеПолейНастроекИстории <> Неопределено И ИспользованиеПолейНастроекИстории[ИмяПоля] <> Неопределено Тогда
				СтрокаПоля.Использование = ИспользованиеПолейНастроекИстории[ИмяПоля];
			КонецЕсли; 
			Если Подробно Тогда
				СтрокаОписанияТипов = мОписанияТиповПолей.Добавить();
				СтрокаОписанияТипов.Имя = СтрокаПоля.ИмяПоля;
				СтрокаОписанияТипов.ОписаниеТипов = СтрокаПоляБД.ТипЗначения;
				СтрокаПоля.ОписаниеТипов = ирОбщий.РасширенноеПредставлениеЗначенияЛкс(СтрокаОписанияТипов.ОписаниеТипов);
			КонецЕсли; 
		КонецЦикла;
	КонецЦикла;
	ТаблицаПолей.Сортировать("ТипПоля, ИмяПоля");
	Возврат ТаблицаПолей;
	
КонецФункции

Функция ПредставлениеПолей(ТаблицаПолей, Использование)
	
	#Если Сервер И Не Сервер Тогда
		ТаблицаПолей = Поля;
	#КонецЕсли
	Результат = Новый ЗаписьXML;
	Результат.УстановитьСтроку("");
	ВыбранныеПоля = ТаблицаПолей.НайтиСтроки(Новый Структура("Использование", Использование));
	Если ВыбранныеПоля.Количество() > 0 Тогда
		Результат.ЗаписатьБезОбработки("" + ВыбранныеПоля.Количество() + ": ");
		ЭтоПервоеПоле = Истина;
		Для Каждого СтрокаПоля Из ВыбранныеПоля Цикл
			#Если Сервер И Не Сервер Тогда
				СтрокаПоля = ТаблицаПолей.Добавить();
			#КонецЕсли
			Если Не ЭтоПервоеПоле Тогда
				Результат.ЗаписатьБезОбработки(", ");
			КонецЕсли; 
			Результат.ЗаписатьБезОбработки(СтрокаПоля.ИмяПоля);
			ЭтоПервоеПоле = Ложь;
		КонецЦикла;
	КонецЕсли; 
	Результат = Результат.Закрыть();
	Возврат Результат;
	
КонецФункции

Процедура ИмяПредставлениеПриИзменении(Элемент)
	
	ТабличноеПоле = ЭлементыФормы.Типы;
	ТабличноеПоле.Колонки.ПредставлениеМД.Видимость = Не ИмяПредставление;
	ТабличноеПоле.Колонки.ИмяМД.Видимость = ИмяПредставление;
	СтараяКолонка = ТабличноеПоле.ТекущаяКолонка;
	Если СтараяКолонка <> Неопределено Тогда
		Если Найти(СтараяКолонка.Имя, "МД") > 0 Тогда
			Если ТабличноеПоле.Колонки.ПредставлениеМД.Видимость Тогда
				ТабличноеПоле.ТекущаяКолонка = ТабличноеПоле.Колонки.ПредставлениеМД;
			Иначе
				ТабличноеПоле.ТекущаяКолонка = ТабличноеПоле.Колонки.ИмяМД;
			КонецЕсли; 
		КонецЕсли; 
	КонецЕсли; 
	ТабличноеПоле = ЭлементыФормы.Поля;
	ТабличноеПоле.Колонки.ПредставлениеПоля.Видимость = Не ИмяПредставление;
	ТабличноеПоле.Колонки.ИмяПоля.Видимость = ИмяПредставление;
	СтараяКолонка = ТабличноеПоле.ТекущаяКолонка;
	Если СтараяКолонка <> Неопределено Тогда
		Если Найти(НРег(СтараяКолонка.Имя), "поля") > 0 Тогда
			Если ТабличноеПоле.Колонки.ПредставлениеПоля.Видимость Тогда
				ТабличноеПоле.ТекущаяКолонка = ТабличноеПоле.Колонки.ПредставлениеПоля;
			Иначе
				ТабличноеПоле.ТекущаяКолонка = ТабличноеПоле.Колонки.ИмяПоля;
			КонецЕсли; 
		КонецЕсли; 
	КонецЕсли; 

КонецПроцедуры

Процедура ТипыПриАктивизацииСтроки(Элемент)
	
	КП_ОбновитьВерсии();
	Если ЭлементыФормы.Типы.ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	Поля.Загрузить(ИспользованиеПолей(Метаданные.НайтиПоПолномуИмени(ЭлементыФормы.Типы.ТекущаяСтрока.ПолноеИмяМД),, Истина));
	
КонецПроцедуры

Процедура ГлавнаяКоманднаяПанельНовоеОкно(Кнопка)
	
	ирОбщий.ОткрытьНовоеОкноОбработкиЛкс(ЭтотОбъект);

КонецПроцедуры

Процедура ГлавнаяКоманднаяПанельОПодсистеме(Кнопка)
	ирОбщий.ОткрытьСправкуПоПодсистемеЛкс(ЭтотОбъект);
КонецПроцедуры

Процедура КП_СвязанныеДанныеОтборБезЗначения(Кнопка)
	
	ирОбщий.ТабличноеПоле_ОтборБезЗначенияВТекущейКолонке_КнопкаЛкс(ЭлементыФормы.Версии);
	
КонецПроцедуры

Процедура КоманднаяПанельТипыОтборБезЗначения(Кнопка)
	
	ирОбщий.ТабличноеПоле_ОтборБезЗначенияВТекущейКолонке_КнопкаЛкс(ЭлементыФормы.Типы);
	
КонецПроцедуры

Процедура ТипыПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	
	Если ДанныеСтроки = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ОформлениеСтроки.Ячейки.ТипМетаданных.УстановитьКартинку(ирОбщий.ПолучитьКартинкуКорневогоТипаЛкс(ДанныеСтроки.ТипМетаданных));
	
КонецПроцедуры

Процедура ДанныеПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	
	ДанныеСтроки = ОформлениеСтроки.ДанныеСтроки;
	Ячейки = ОформлениеСтроки.Ячейки;
	Если НадоСериализоватьКлюч() Тогда
		Попытка
			КлючЗаписи = ЗначениеИзСтрокиВнутр(Ячейки.Данные.Текст);
		Исключение
			// Некоторые большие ключи регистров в сериализованном виде не умещаются в 1024 символа
			КлючЗаписи = "<Ключ записи регистра обрезан и не может быть восстановлен>";
		КонецПопытки; 
		Ячейки.Данные.Текст = ирОбщий.ПредставлениеКлючаСтрокиБДЛкс(КлючЗаписи, Ложь);
	КонецЕсли;

КонецПроцедуры

Процедура КП_ДанныеРедакторОбъектаБД(Кнопка = Неопределено, НайтиВерсию = Неопределено)
	
	ТекущиеДанные = ЭлементыФормы.Версии.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	КлючОбъектаВерсии = КлючОбъектаВерсии(ТекущиеДанные);
	Если КлючОбъектаВерсии = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	ФормаРедактора = ирОбщий.ОткрытьСсылкуВРедактореОбъектаБДЛкс(КлючОбъектаВерсии);
	Если НайтиВерсию <> Ложь Тогда
		ФормаРедактора.НайтиВерсию(ТекущиеДанные.НомерВерсии);
	КонецЕсли; 
	
КонецПроцедуры

Функция КлючОбъектаВерсии(Знач СтрокаТаблицыВерсий = Неопределено)
	
	Если СтрокаТаблицыВерсий = Неопределено Тогда
		СтрокаТаблицыВерсий = ЭлементыФормы.Версии.ТекущиеДанные;
	КонецЕсли; 
	Если СтрокаТаблицыВерсий = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли; 
	Если Не НадоСериализоватьКлюч() Тогда
		СсылкаОбъекта = СтрокаТаблицыВерсий.Данные;
	Иначе
		Попытка
			СсылкаОбъекта = ЗначениеИзСтрокиВнутр(СтрокаТаблицыВерсий.Данные);
		Исключение
			СсылкаОбъекта = Неопределено;
		КонецПопытки; 
	КонецЕсли;
	Возврат СсылкаОбъекта;

КонецФункции

Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	
	Если ирКэш.НомерРежимаСовместимостиЛкс() < 803011 Тогда
		Сообщить("Инструмент доступен только в режиме совместимости 8.3.11 и выше");
		Отказ = Истина;
	КонецЕсли; 
	
КонецПроцедуры

Процедура ДанныеВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	Если Колонка = ЭлементыФормы.Версии.Колонки.Данные Тогда
		КлючОбъектаВерсии = КлючОбъектаВерсии(ВыбраннаяСтрока);
		Если КлючОбъектаВерсии = Неопределено Тогда
			Возврат;
		КонецЕсли;
		Если ирОбщий.ЛиКлючЗаписиРегистраЛкс(КлючОбъектаВерсии) Тогда
			ОбъектМД = Метаданные.НайтиПоПолномуИмени(ЭлементыФормы.типы.ТекущаяСтрока.ПолноеИмяМД);
			#Если Сервер И Не Сервер Тогда
				ОбъектМД = Метаданные.РегистрыСведений.ABCКлассификацияПокупателей;
			#КонецЕсли
			Если ОбъектМД.ОсновнаяФормаЗаписи <> Неопределено Тогда
				ОткрытьЗначение(КлючОбъектаВерсии);
			Иначе
				КП_ДанныеРедакторОбъектаБД(, Ложь);
			КонецЕсли; 
		Иначе
			ОткрытьЗначение(КлючОбъектаВерсии);
		КонецЕсли; 
	Иначе
		КП_ДанныеОткрытьОтчетПоВерсии();
	КонецЕсли; 
	
КонецПроцедуры

Процедура ГлавнаяКоманднаяПанельИТС(Кнопка)
	
	ЗапуститьПриложение("http://its.1c.ru/db/metod8dev#content:5367:hdoc");
	
КонецПроцедуры

Процедура КлсУниверсальнаяКомандаНажатие(Кнопка) Экспорт 
	
	ирОбщий.УниверсальнаяКомандаФормыЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура СтруктураКоманднойПанелиНажатие(Кнопка)
	
	ирОбщий.ОткрытьСтруктуруКоманднойПанелиЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура ГлавнаяКоманднаяПанельСтруктураФормы(Кнопка)
	
	ирОбщий.ОткрытьСтруктуруФормыЛкс(ЭтаФорма);
	
КонецПроцедуры

Процедура ПриЗакрытии()
	
	ирОбщий.Форма_ПриЗакрытииЛкс(ЭтаФорма);

КонецПроцедуры

Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	ирОбщий.ФормаОбработкаОповещенияЛкс(ЭтаФорма, ИмяСобытия, Параметр, Источник); 

КонецПроцедуры

Процедура КоманднаяПанельТипыОткрытьОбъектМетаданных(Кнопка)
	
	Если ЭлементыФормы.Типы.ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	ирОбщий.ОткрытьОбъектМетаданныхЛкс(ЭлементыФормы.Типы.ТекущаяСтрока.ПолноеИмяМД);
	
КонецПроцедуры

Процедура ГлавнаяКоманднаяПанельПараметрыЗаписи(Кнопка)
	
	ирОбщий.ОткрытьОбщиеПараметрыЗаписиЛкс();
	
КонецПроцедуры

Процедура ТипыПриИзмененииФлажка(Элемент, Колонка)
	
	ИсторияДанныхМоя = Вычислить("ИсторияДанных");
	#Если Сервер И Не Сервер Тогда
		ИсторияДанныхМоя = ИсторияДанных;
	#КонецЕсли
	ОбъектМД = Метаданные.НайтиПоПолномуИмени(ЭлементыФормы.Типы.ТекущаяСтрока.ПолноеИмяМД);
	НастройкиИстории = ИсторияДанныхМоя.ПолучитьНастройки(ОбъектМД);
	Если НастройкиИстории = Неопределено Тогда 
		НастройкиИстории = Новый ("НастройкиИсторииДанных");
	КонецЕсли; 
	НастройкиИстории.Использование = ЭлементыФормы.Типы.ТекущаяСтрока.Использование;
	ИсторияДанныхМоя.УстановитьНастройки(ОбъектМД, НастройкиИстории);
	
КонецПроцедуры

Процедура КП_ОбновитьВерсии(Кнопка = Неопределено)
	
	ТекущиеДанные = ЭлементыФормы.Версии.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		СтараяТекущаяВерсия = Новый Структура("Данные, НомерВерсии", ТекущиеДанные.Данные, ТекущиеДанные.НомерВерсии);
	КонецЕсли; 
	Версии.Очистить();
	Если ЭлементыФормы.Типы.ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	ИсторияДанныхМоя = Вычислить("ИсторияДанных");
	#Если Сервер И Не Сервер Тогда
		ИсторияДанныхМоя = ИсторияДанных;
	#КонецЕсли
	ОбъектМД = Метаданные.НайтиПоПолномуИмени(ЭлементыФормы.Типы.ТекущаяСтрока.ПолноеИмяМД);
	Если Не ПравоДоступа("ПросмотрИсторииДанных", ОбъектМД) Тогда
		Сообщить("Нет прав на просмотр истории данных " + ОбъектМД.ПолноеИмя());
		Возврат;
	КонецЕсли; 
	НадоСериализоватьКлюч = НадоСериализоватьКлюч();
	Для Каждого СтрокаВыборки Из ВыбратьВерсии(ИсторияДанныхМоя, ОбъектМД) Цикл
		СтрокаВерсии = Версии.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаВерсии, СтрокаВыборки); 
		Если НадоСериализоватьКлюч Тогда
			СтрокаВерсии.Данные = ЗначениеВСтрокуВнутр(СтрокаВыборки.Данные);
		КонецЕсли; 
		Если Истина
			И СтараяТекущаяВерсия <> Неопределено
			И СтараяТекущаяВерсия.Данные = СтрокаВерсии.Данные
			И СтараяТекущаяВерсия.НомерВерсии = СтрокаВерсии.НомерВерсии
		Тогда
			ЭлементыФормы.Версии.ТекущаяСтрока = СтрокаВерсии;
		КонецЕсли; 
	КонецЦикла;
	
КонецПроцедуры

Функция НадоСериализоватьКлюч()
	
	НадоСериализоватьКлюч = Ложь
		Или ирОбщий.ЛиКорневойТипРегистраСведенийЛкс(ЭлементыФормы.Типы.ТекущаяСтрока.ТипМетаданных)
		Или ирОбщий.ЛиКорневойТипКонстантыЛкс(ЭлементыФормы.Типы.ТекущаяСтрока.ТипМетаданных);
	Возврат НадоСериализоватьКлюч;

КонецФункции

Функция ВыбратьВерсии(Знач ИсторияДанныхМоя, Знач ОбъектМД)
	
	ОтборВерсий = Новый Структура("Метаданные", ОбъектМД);
	Если ЗначениеЗаполнено(НачалоПериода) Тогда
		ОтборВерсий.Вставить("ДатаНачала", НачалоПериода);
	КонецЕсли; 
	Если ЗначениеЗаполнено(КонецПериода) Тогда
		ОтборВерсий.Вставить("ДатаОкончания", КонецПериода);
	КонецЕсли; 
	Возврат ИсторияДанныхМоя.ВыбратьВерсии(ОтборВерсий,,, МаксКоличествоВерсий);

КонецФункции

Процедура МаксКоличествоВерсийПриИзменении(Элемент)
	
	КП_ОбновитьВерсии();

КонецПроцедуры

Процедура ГлавнаяКоманднаяПанельОбновитьИсторию(Кнопка)
	
	ИсторияДанныхМоя = Вычислить("ИсторияДанных");
	#Если Сервер И Не Сервер Тогда
		ИсторияДанныхМоя = ИсторияДанных;
	#КонецЕсли
	ИсторияДанныхМоя.ОбновитьИсторию();
	КПТипыОбновить();
	
КонецПроцедуры

Процедура КП_ДанныеНайтиВФормеСпискаВерсий(Кнопка)
	
	КлючОбъекта = КлючОбъектаВерсии();
	Если КлючОбъекта = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	ТекущиеДанные = ЭлементыФормы.Версии.ТекущиеДанные;
	ирОбщий.ОткрытьСистемнуюФормуСписокВерсийЛкс(КлючОбъекта, ТекущиеДанные.НомерВерсии);
	
КонецПроцедуры

Процедура КП_ДанныеОткрытьОтчетПоВерсии(Кнопка = Неопределено)
	
	КлючОбъекта = КлючОбъектаВерсии();
	Если КлючОбъекта = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	ТекущиеДанные = ЭлементыФормы.Версии.ТекущиеДанные;
	ирОбщий.ОткрытьСистемнуюФормуОтчетПоВерсииЛкс(КлючОбъекта, ТекущиеДанные.НомерВерсии);
	
КонецПроцедуры

Процедура КоманднаяПанельТипыУстановитьФлажки(Кнопка)
	
	ИзменитьИспользованиеУВыделенныхИлиВсехСтрокТипов(Истина);

КонецПроцедуры

Процедура КоманднаяПанельТипыСнятьФлажки(Кнопка)
	
	ИзменитьИспользованиеУВыделенныхИлиВсехСтрокТипов(Ложь);
	
КонецПроцедуры

Процедура ИзменитьИспользованиеУВыделенныхИлиВсехСтрокТипов(Знач НовоеЗначениеПометки)
	
	ТабличноеПоле = ЭлементыФормы.Типы;
	ВыделенныеСтроки = ТабличноеПоле.ВыделенныеСтроки;
	Если ВыделенныеСтроки.Количество() <= 1 Тогда
		ВыделенныеСтроки = ТабличноеПоле.Значение; 
		Попытка
			ОтборСтрок = ТабличноеПоле.ОтборСтрок;
		Исключение
		КонецПопытки; 
		Если ОтборСтрок <> Неопределено Тогда
			Построитель = ирОбщий.ПолучитьПостроительТабличногоПоляСОтборомКлиентаЛкс(ТабличноеПоле);
			#Если Сервер И Не Сервер Тогда
				Построитель = Новый ПостроительЗапроса;
			#КонецЕсли
			Построитель.ВыбранныеПоля.Очистить();
			Построитель.ВыбранныеПоля.Добавить("ПолноеИмяМД");
			НомераОтобранныхСтрок = Построитель.Результат.Выгрузить();
			НомераОтобранныхСтрок.Индексы.Добавить("ПолноеИмяМД");
		КонецЕсли; 
	КонецЕсли; 
	Для каждого Строка из ВыделенныеСтроки Цикл
		Если Истина
			И НомераОтобранныхСтрок <> Неопределено
			И НомераОтобранныхСтрок.Найти(Строка.ПолноеИмяМД, "ПолноеИмяМД") = Неопределено
		Тогда
			// Строка не отвечает отбору
			Продолжить;
		КонецЕсли;
		Строка.Использование = НовоеЗначениеПометки;
		ИсторияДанныхМоя = Вычислить("ИсторияДанных");
		#Если Сервер И Не Сервер Тогда
			ИсторияДанныхМоя = ИсторияДанных;
		#КонецЕсли
		ОбъектМД = Метаданные.НайтиПоПолномуИмени(Строка.ПолноеИмяМД);
		НастройкиИстории = ИсторияДанныхМоя.ПолучитьНастройки(ОбъектМД);
		Если НастройкиИстории = Неопределено Тогда 
			НастройкиИстории = Новый ("НастройкиИсторииДанных");
		КонецЕсли; 
		НастройкиИстории.Использование = НовоеЗначениеПометки;
		ИсторияДанныхМоя.УстановитьНастройки(ОбъектМД, НастройкиИстории);
	КонецЦикла;
	ТабличноеПоле.ОбновитьСтроки();

КонецПроцедуры

Процедура ПоляПриИзмененииФлажка(Элемент, Колонка)
	
	Если ЭлементыФормы.Типы.ТекущаяСтрока = Неопределено Тогда
		Поля.Очистить();
		Возврат;
	КонецЕсли; 
	ИсторияДанныхМоя = Вычислить("ИсторияДанных");
	#Если Сервер И Не Сервер Тогда
		ИсторияДанныхМоя = ИсторияДанных;
	#КонецЕсли
	ОбъектМД = Метаданные.НайтиПоПолномуИмени(ЭлементыФормы.Типы.ТекущаяСтрока.ПолноеИмяМД);
	НастройкиИстории = ИсторияДанныхМоя.ПолучитьНастройки(ОбъектМД);
	Если НастройкиИстории = Неопределено Тогда 
		НастройкиИстории = Новый ("НастройкиИсторииДанных");
	КонецЕсли; 
	ИспользованиеПолей = Новый Соответствие;
	Для Каждого СтрокаПоля Из Поля Цикл
		Если СтрокаПоля.ИспользованиеВМетаданных <> СтрокаПоля.Использование Тогда
			ИспользованиеПолей.Вставить(СтрокаПоля.ИмяПоля, СтрокаПоля.Использование);
		КонецЕсли; 
	КонецЦикла;
	НастройкиИстории.ИспользованиеПолей = ИспользованиеПолей;
	ИсторияДанныхМоя.УстановитьНастройки(ОбъектМД, НастройкиИстории);
	ОбновитьПредставлениеПолейВСтрокеТипа(НастройкиИстории, ОбъектМД);
	
КонецПроцедуры

Процедура ПроверятьНаличиеВерсийПриИзменении(Элемент = Неопределено)
	
	Если ВычислятьКоличествоВерсий Тогда
		КПТипыОбновить();
		ЭлементыФормы.Типы.Колонки.КоличествоВерсий.Видимость = Истина;
	КонецЕсли; 
	
КонецПроцедуры

Процедура ПоляПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	
	ИндексКартинки = ирОбщий.ПолучитьИндексКартинкиТипаЛкс(мОписанияТиповПолей.Найти(ДанныеСтроки.ИмяПоля, "Имя").ОписаниеТипов);
	Если ИндексКартинки <> Неопределено Тогда
		ОформлениеСтроки.Ячейки.ОписаниеТипов.ОтображатьКартинку = Истина;
		ОформлениеСтроки.Ячейки.ОписаниеТипов.ИндексКартинки = ИндексКартинки;
	КонецЕсли; 
	
КонецПроцедуры

Процедура КППоляМенеджерТабличногоПоля(Кнопка)
	
	ирОбщий.ОткрытьМенеджерТабличногоПоляЛкс(ЭлементыФормы.Поля, ЭтаФорма);
	
КонецПроцедуры

Процедура КПТипыМенеджерТабличногоПоля(Кнопка)
	
	ирОбщий.ОткрытьМенеджерТабличногоПоляЛкс(ЭлементыФормы.Типы, ЭтаФорма);
	
КонецПроцедуры

Процедура КППоляУстановитьФлажки(Кнопка)
	
	ИзменитьИспользованиеУВыделенныхИлиВсехСтрокПолей(Истина);
	
КонецПроцедуры

Процедура КППоляСнятьФлажки(Кнопка)
	
	ИзменитьИспользованиеУВыделенныхИлиВсехСтрокПолей(Ложь);
	
КонецПроцедуры

Процедура ИзменитьИспользованиеУВыделенныхИлиВсехСтрокПолей(Знач НовоеЗначениеПометки)
	
	Если ЭлементыФормы.Типы.ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	ТабличноеПоле = ЭлементыФормы.Поля;
	ВыделенныеСтроки = ТабличноеПоле.ВыделенныеСтроки;
	Если ВыделенныеСтроки.Количество() <= 1 Тогда
		ВыделенныеСтроки = ТабличноеПоле.Значение; 
		Попытка
			ОтборСтрок = ТабличноеПоле.ОтборСтрок;
		Исключение
		КонецПопытки; 
		Если ОтборСтрок <> Неопределено Тогда
			Построитель = ирОбщий.ПолучитьПостроительТабличногоПоляСОтборомКлиентаЛкс(ТабличноеПоле);
			#Если Сервер И Не Сервер Тогда
				Построитель = Новый ПостроительЗапроса;
			#КонецЕсли
			Построитель.ВыбранныеПоля.Очистить();
			Построитель.ВыбранныеПоля.Добавить("ИмяПоля");
			НомераОтобранныхСтрок = Построитель.Результат.Выгрузить();
			НомераОтобранныхСтрок.Индексы.Добавить("ИмяПоля");
		КонецЕсли; 
	КонецЕсли; 
	ИсторияДанныхМоя = Вычислить("ИсторияДанных");
	#Если Сервер И Не Сервер Тогда
		ИсторияДанныхМоя = ИсторияДанных;
	#КонецЕсли
	ОбъектМД = Метаданные.НайтиПоПолномуИмени(ЭлементыФормы.Типы.ТекущаяСтрока.ПолноеИмяМД);
	НастройкиИстории = ИсторияДанныхМоя.ПолучитьНастройки(ОбъектМД);
	Если НастройкиИстории = Неопределено Тогда 
		НастройкиИстории = Новый ("НастройкиИсторииДанных");
	КонецЕсли; 
	ИспользованиеПолей = Новый Соответствие;
	Для каждого СтрокаПоля из ВыделенныеСтроки Цикл
		Если Истина
			И НомераОтобранныхСтрок <> Неопределено
			И НомераОтобранныхСтрок.Найти(СтрокаПоля.ИмяПоля, "ИмяПоля") = Неопределено
		Тогда
			// Строка не отвечает отбору
			Продолжить;
		КонецЕсли;
		СтрокаПоля.Использование = НовоеЗначениеПометки;
		Если СтрокаПоля.ИспользованиеВМетаданных <> СтрокаПоля.Использование Тогда
			ИспользованиеПолей.Вставить(СтрокаПоля.ИмяПоля, СтрокаПоля.Использование);
		КонецЕсли; 
	КонецЦикла;
	НастройкиИстории.ИспользованиеПолей = ИспользованиеПолей;
	ИсторияДанныхМоя.УстановитьНастройки(ОбъектМД, НастройкиИстории);
	ОбновитьПредставлениеПолейВСтрокеТипа(НастройкиИстории, ОбъектМД);
	ТабличноеПоле.ОбновитьСтроки();

КонецПроцедуры

Процедура КППоляОтборБезЗначения(Кнопка)
	
	ирОбщий.ТабличноеПоле_ОтборБезЗначенияВТекущейКолонке_КнопкаЛкс(ЭлементыФормы.Поля);
	
КонецПроцедуры

Процедура ВыбратьДатуИзСписка(Элемент, СтандартнаяОбработка, Знач ПарнаяДата, Знак)
	
	СимволЗнака = ?(Знак = 1, "+", "-");
	ИмяПарнойДаты = ?(Знак = 1, "Начало", "Конец");
	СписокВыбора = Новый СписокЗначений;
	СписокВыбора.Добавить(1*60,          ИмяПарнойДаты + " " + СимволЗнака + " 1 минута");
	СписокВыбора.Добавить(10*60,       ИмяПарнойДаты + " " + СимволЗнака + " 10 минут");
	СписокВыбора.Добавить(2*60*60,       ИмяПарнойДаты + " " + СимволЗнака + " 2 часа");
	СписокВыбора.Добавить(1*24*60*60,    ИмяПарнойДаты + " " + СимволЗнака + " 1 день");
	СписокВыбора.Добавить(7*24*60*60,    ИмяПарнойДаты + " " + СимволЗнака + " 7 дней");
	СписокВыбора.Добавить(30*24*60*60,   ИмяПарнойДаты + " " + СимволЗнака + " 30 дней");
	РезультатВыбора = ЭтаФорма.ВыбратьИзСписка(СписокВыбора, Элемент);
	Если РезультатВыбора <> Неопределено Тогда
		Если Знак = -1 Тогда
			Если Не ЗначениеЗаполнено(ПарнаяДата) Тогда
				ПарнаяДата = ТекущаяДата();
			КонецЕсли; 
		КонецЕсли; 
		Элемент.Значение = ПарнаяДата + Знак * РезультатВыбора.Значение;
	КонецЕсли;
	СтандартнаяОбработка = Ложь;

КонецПроцедуры

Процедура КонецПериодаНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	
	ВыбратьДатуИзСписка(Элемент, СтандартнаяОбработка, НачалоПериода, 1);
	
КонецПроцедуры

Процедура НачалоПериодаНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	
	ВыбратьДатуИзСписка(Элемент, СтандартнаяОбработка, КонецПериода, -1);

КонецПроцедуры

Процедура КнопкаВыбораПериодаНажатие(Элемент)
	
	НастройкаПериода = Новый НастройкаПериода;
	НастройкаПериода.УстановитьПериод(НачалоПериода, ?(КонецПериода='0001-01-01', КонецПериода, КонецДня(КонецПериода)));
	НастройкаПериода.РедактироватьКакИнтервал = Истина;
	НастройкаПериода.РедактироватьКакПериод = Истина;
	НастройкаПериода.ВариантНастройки = ВариантНастройкиПериода.Период;
	Если НастройкаПериода.Редактировать() Тогда
		НачалоПериода = НастройкаПериода.ПолучитьДатуНачала();
		КонецПериода = НастройкаПериода.ПолучитьДатуОкончания();
	КонецЕсли;

КонецПроцедуры

Функция НайтиВерсию(КлючОбъекта, НомерВерсии) Экспорт 
	
	НайденнаяСтрока = Типы.Найти(Метаданные.НайтиПоТипу(ирОбщий.ТипОбъектаБДЛкс(КлючОбъекта)).ПолноеИмя(), "ПолноеИмяМД");
	Если НайденнаяСтрока = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли; 
	ЭлементыФормы.Типы.ТекущаяСтрока = НайденнаяСтрока;
	СтрокаВерсии = Версии.Найти(НомерВерсии, "НомерВерсии");
	Если СтрокаВерсии <> Неопределено Тогда
		ЭлементыФормы.Версии.ТекущаяСтрока = СтрокаВерсии;
	Иначе
		Сообщить("Версия не найдена по текущим условиям отбора");
	КонецЕсли; 
	
КонецФункции

Процедура КП_ДанныеМенеджерТабличногоПоля(Кнопка)
	
	ирОбщий.ОткрытьМенеджерТабличногоПоляЛкс(ЭлементыФормы.Версии, ЭтаФорма);
	
КонецПроцедуры

Процедура ПоляВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	Если Колонка = ЭлементыФормы.Поля.Колонки.ОписаниеТипов Тогда
		ирОбщий.ОткрытьЗначениеЛкс(мОписанияТиповПолей.Найти(ВыбраннаяСтрока.ИмяПоля, "Имя").ОписаниеТипов, Ложь, СтандартнаяОбработка);
	КонецЕсли; 
	
КонецПроцедуры

Процедура КП_ДанныеУдалитьВерсии(Кнопка)
	
	ТекущиеДанные = ЭлементыФормы.Версии.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	Ответ = Вопрос("Вы действительно хотите удалить все версии объектов этого типа данных старше выбранной версии?", РежимДиалогаВопрос.ОКОтмена);
	Если Ответ = КодВозвратаДиалога.ОК Тогда
		ИсторияДанныхМоя = Вычислить("ИсторияДанных");
		#Если Сервер И Не Сервер Тогда
			ИсторияДанныхМоя = ИсторияДанных;
		#КонецЕсли
		ИсторияДанныхМоя.УдалитьВерсии(Метаданные.НайтиПоПолномуИмени(ЭлементыФормы.Типы.ТекущаяСтрока.ПолноеИмяМД), ТекущиеДанные.Дата);
		КП_ОбновитьВерсии();
	КонецЕсли;
	
КонецПроцедуры

Процедура ГлавнаяКоманднаяПанельОчиститьИсторию(Кнопка)
	
	Ответ = Вопрос("Вы действительно хотите очистить всю историю данных?", РежимДиалогаВопрос.ОКОтмена);
	Если Ответ = КодВозвратаДиалога.ОК Тогда
		ИсторияДанныхМоя = Вычислить("ИсторияДанных");
		#Если Сервер И Не Сервер Тогда
			ИсторияДанныхМоя = ИсторияДанных;
		#КонецЕсли
		Для Каждого СтрокаТипа Из Типы Цикл
			ОбъектМД = Метаданные.НайтиПоПолномуИмени(СтрокаТипа.ПолноеИмяМД);
			Попытка
				ИсторияДанныхМоя.УдалитьВерсии(ОбъектМД);
			Исключение
				Сообщить("Ошибка удаления версий " + ОбъектМД.ПолноеИмя() + ": " + ОписаниеОшибки());
			КонецПопытки; 
		КонецЦикла;
		КПТипыОбновить();
	КонецЕсли;
	
КонецПроцедуры

Процедура КП_ДанныеИсследоватьВерсию(Кнопка)
	
	КлючОбъекта = КлючОбъектаВерсии();
	Если КлючОбъекта = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	ТекущиеДанные = ЭлементыФормы.Версии.ТекущиеДанные;
	ирОбщий.ИсследоватьВерсиюОбъектаДанныхЛкс(КлючОбъекта, ТекущиеДанные.НомерВерсии);
	
КонецПроцедуры

ирОбщий.ИнициализироватьФормуЛкс(ЭтаФорма, "Обработка.ирИсторияДанных.Форма.Форма");
МаксКоличествоВерсий = 1000;
ЭлементыФормы.МаксКоличествоВерсий.СписокВыбора.Добавить(10);
ЭлементыФормы.МаксКоличествоВерсий.СписокВыбора.Добавить(100);
ЭлементыФормы.МаксКоличествоВерсий.СписокВыбора.Добавить(1000);
ЭлементыФормы.МаксКоличествоВерсий.СписокВыбора.Добавить(10000);
