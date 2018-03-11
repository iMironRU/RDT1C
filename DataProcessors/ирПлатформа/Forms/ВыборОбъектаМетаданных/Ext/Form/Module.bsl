﻿Перем мОтображатьВиртуальныеТаблицы;
Перем мОтображатьТаблицыИзменений;
Перем мОтображатьТабличныеЧасти;
Перем мОтображатьРегистры;
Перем мОтображатьПеречисления;
Перем мОтображатьПоследовательности;
Перем мОтображатьОбработки;
Перем мОтображатьОтчеты;
Перем мОтображатьСсылочныеОбъекты;
Перем мОтображатьВнешниеИсточникиДанных;
Перем мОтображатьВыборочныеТаблицы;
Перем мОтображатьПерерасчеты;
Перем мОтображатьКонстанты;
Перем мОтображатьРегламентныеЗадания;
Перем мНеОтображатьПланыОбмена;
Перем мДоступныеОбъекты; // Соответствие полных имен метаданных
Перем мМножественныйВыбор;
Перем мМножественныйВыборТолькоДляОднотипныхТаблиц;
Перем мЗапретитьВыбиратьСсылочныеОбъекты;
Перем мТолькоИспользованиеПолнотекстовогоПоиска;
Перем мСтрокаТипаТабличнойЧасти;
Перем мСтрокаТипаВнешнегоИсточникаДанных;
Перем мОтображатьКоличество;
Перем мМассивДоступныхОбъектов;
Перем мФильтрКорневыхТипов;
Перем мТолькоПомеченные;
Перем мТипТаблицы;
Перем мСоответствиеПометок;
Перем мСтруктураКлючаТаблицы;
Перем мПоследнийФильтр;

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ 

// Процедура передает сделанные настройки в главную форму отчета.
//
Процедура мВыбрать()

	ТекущаяСтрока = ЭлементыФормы.ДеревоИсточников.ТекущаяСтрока;
	Если Не мМножественныйВыбор Тогда 
		УровеньДерева = ТекущаяСтрока.Уровень();
		Если Истина 
			//И ТекущаяСтрока.Строки.Количество() = 0 
			И УровеньДерева > 0 
			И ЗначениеЗаполнено(ТекущаяСтрока.ПолноеИмяОбъекта)
		Тогда
			ТипТаблицы = ирОбщий.ПолучитьТипТаблицыБДЛкс(ТекущаяСтрока.ПолноеИмяОбъекта);
			Если Ложь
				Или мЗапретитьВыбиратьСсылочныеОбъекты <> Истина
				Или Не ирОбщий.ЛиКорневойТипСсылочногоОбъектаБДЛкс(ТипТаблицы)
			Тогда
				Результат = Новый Структура("ПолноеИмяОбъекта, Представление");
				Результат.ПолноеИмяОбъекта = ТекущаяСтрока.ПолноеИмяОбъекта;
				Результат.Представление = ТекущаяСтрока.Представление;
				ирОбщий.ПоследниеВыбранныеДобавитьЛкс(ЭтаФорма, Результат.ПолноеИмяОбъекта);
			КонецЕсли; 
		КонецЕсли; 
	Иначе
		Результат = ПолучитьКлючиПомеченныхСтрок();
		ирОбщий.ПоследниеВыбранныеДобавитьЛкс(ЭтаФорма, Результат);
	КонецЕсли;
	Если Результат <> Неопределено Тогда
		ирОбщий.ПрименитьИзмененияИЗакрытьФормуЛкс(ЭтаФорма, Результат);
	КонецЕсли; 

КонецПроцедуры // мВыбрать()

Функция ПолучитьКлючиПомеченныхСтрок(ТолькоПервыйКлюч = Ложь) 
	
	Результат = Новый Массив;
	Если ТолькоПервыйКлюч Тогда
		СтрокаСоответствия = мСоответствиеПометок.Найти(Истина, "Пометка");
		Если СтрокаСоответствия <> Неопределено Тогда
			Результат.Добавить(СтрокаСоответствия.СреднееИмяМД);
		КонецЕсли; 
	Иначе
		Для Каждого СтрокаСоответствия Из мСоответствиеПометок.НайтиСтроки(Новый Структура("Пометка", Истина)) Цикл
			Результат.Добавить(СтрокаСоответствия.СреднееИмяМД);
		КонецЦикла;
	КонецЕсли; 
	Возврат Результат;

КонецФункции

///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

// Процедура - обработчик события "При открытии" формы.
//
Процедура ПриОткрытии()

	лРежимИмяСиноним = ирОбщий.ВосстановитьЗначениеЛкс("ВыборОбъектаМетаданных.РежимИмяСиноним");
	Если лРежимИмяСиноним <> Неопределено Тогда
		РежимИмяСиноним = лРежимИмяСиноним;
		ЭлементыФормы.ДействияФормы.Кнопки.ИмяСиноним.Пометка = РежимИмяСиноним;
	КонецЕсли; 
	ирОбщий.ТабличноеПоле_ОбновитьКолонкиИмяСинонимЛкс(ЭлементыФормы.ДеревоИсточников, РежимИмяСиноним);
	РежимВыбора = Истина;
	Если Истина
		И Не МодальныйРежим
		И ТипЗнч(ВладелецФормы) = Тип("Форма")
	Тогда
		ВладелецФормы.Панель.Доступность = Ложь;
	КонецЕсли; 

	СтруктураПараметров = НачальноеЗначениеВыбора;

	МассивДоступныхОбъектов = Неопределено;
	мФильтрКорневыхТипов = Неопределено;
	Если ТипЗнч(СтруктураПараметров) = Тип("Структура") Тогда
		НачальноеЗначениеВыбора = Неопределено;
		ФильтрКорневыхТипов = Неопределено;
		СтруктураПараметров.Свойство("МножественныйВыбор", мМножественныйВыбор);
		СтруктураПараметров.Свойство("МножественныйВыборТолькоДляОднотипныхТаблиц", мМножественныйВыборТолькоДляОднотипныхТаблиц);
		СтруктураПараметров.Свойство("ОтображатьВиртуальныеТаблицы", мОтображатьВиртуальныеТаблицы);
		СтруктураПараметров.Свойство("ОтображатьТаблицыИзменений", мОтображатьТаблицыИзменений);
		СтруктураПараметров.Свойство("ОтображатьТабличныеЧасти", мОтображатьТабличныеЧасти);
		СтруктураПараметров.Свойство("ОтображатьРегистры", мОтображатьРегистры);
		СтруктураПараметров.Свойство("ОтображатьПоследовательности", мОтображатьПоследовательности);
		СтруктураПараметров.Свойство("ОтображатьПеречисления", мОтображатьПеречисления);
		СтруктураПараметров.Свойство("ОтображатьОбработки", мОтображатьОбработки);
		СтруктураПараметров.Свойство("ОтображатьОтчеты", мОтображатьОтчеты);
		СтруктураПараметров.Свойство("ОтображатьРегламентныеЗадания", мОтображатьРегламентныеЗадания);
		СтруктураПараметров.Свойство("ОтображатьСсылочныеОбъекты", мОтображатьСсылочныеОбъекты);
		СтруктураПараметров.Свойство("ОтображатьВнешниеИсточникиДанных", мОтображатьВнешниеИсточникиДанных);
		СтруктураПараметров.Свойство("ОтображатьПерерасчеты", мОтображатьПерерасчеты);
		СтруктураПараметров.Свойство("ОтображатьКонстанты", мОтображатьКонстанты);
		СтруктураПараметров.Свойство("ОтображатьКоличество", мОтображатьКоличество);
		СтруктураПараметров.Свойство("ОтображатьВыборочныеТаблицы", мОтображатьВыборочныеТаблицы);
		СтруктураПараметров.Свойство("НеОтображатьПланыОбмена", мНеОтображатьПланыОбмена);
		СтруктураПараметров.Свойство("ДоступныеОбъекты", мМассивДоступныхОбъектов);
		СтруктураПараметров.Свойство("ЗапретитьВыбиратьСсылочныеОбъекты", мЗапретитьВыбиратьСсылочныеОбъекты);
		СтруктураПараметров.Свойство("ТолькоИспользованиеПолнотекстовогоПоиска", мТолькоИспользованиеПолнотекстовогоПоиска);
		СтруктураПараметров.Свойство("НачальноеЗначениеВыбора", НачальноеЗначениеВыбора);
		СтруктураПараметров.Свойство("ФильтрКорневыхТипов", ФильтрКорневыхТипов);
		Если ТипЗнч(ФильтрКорневыхТипов) = Тип("Строка") И ЗначениеЗаполнено(ФильтрКорневыхТипов) Тогда
			мФильтрКорневыхТипов = ирОбщий.ПолучитьМассивИзСтрокиСРазделителемЛкс(ФильтрКорневыхТипов, ",", Истина);
		ИначеЕсли ТипЗнч(ФильтрКорневыхТипов) = Тип("Массив") Тогда
			мФильтрКорневыхТипов = ФильтрКорневыхТипов;
		КонецЕсли; 
	КонецЕсли; 
	
	Если мМножественныйВыбор = Неопределено Тогда
		мМножественныйВыбор = Ложь;
	КонецЕсли; 
	//ЭлементыФормы.ДействияФормы.Кнопки.УстановитьПометки.Доступность = мМножественныйВыбор; // На подменю это не действует
	ЭлементыФормы.ДействияФормы.Кнопки.СнятьПометки.Доступность = мМножественныйВыбор;
	Если мМножественныйВыбор Тогда
		ЭлементыФормы.ДеревоИсточников.РежимВыделения = РежимВыделенияТабличногоПоля.Множественный;
	КонецЕсли; 
	ЭлементыФормы.ДействияФормы.Кнопки.СнятьПометки.Доступность = мМножественныйВыбор;
	ЭлементыФормы.ДействияФормы.Кнопки.УстановитьПометки.Кнопки.УстановитьПометки.Доступность = мМножественныйВыбор;
	ЭлементыФормы.ДействияФормы.Кнопки.УстановитьПометки.Кнопки.УстановитьПометкиСоВсемиПотомками.Доступность = мМножественныйВыбор;
	ЭлементыФормы.ДействияФормы.Кнопки.УстановитьПометки.Кнопки.ПометитьПоРегистратору.Доступность = мМножественныйВыбор;
	ЭлементыФормы.ДействияФормы.Кнопки.ТолькоПомеченные.Доступность = мМножественныйВыбор;
	
	мСоответствиеПометок = Новый ТаблицаЗначений;
	мСоответствиеПометок.Колонки.Добавить("СреднееИмяМД");
	мСоответствиеПометок.Индексы.Добавить("СреднееИмяМД");
	мСоответствиеПометок.Колонки.Добавить("Пометка");
	мСоответствиеПометок.Колонки.Добавить("Известный", Новый ОписаниеТипов("Булево"));
	Если ТипЗнч(НачальноеЗначениеВыбора) = Тип("Массив") Тогда
		Если НачальноеЗначениеВыбора.Количество() = 1 Тогда
			ПолноеИмяТекущейСтроки = НачальноеЗначениеВыбора[0];
		КонецЕсли; 
		Если мМассивДоступныхОбъектов <> Неопределено Тогда
			Для Каждого СреднееИмяМД Из мМассивДоступныхОбъектов Цикл
				СтрокаПометки = мСоответствиеПометок.Добавить();
				СтрокаПометки.СреднееИмяМД = СреднееИмяМД;
			КонецЦикла; 
		КонецЕсли; 
		//ТаблицаВсехТаблицБД = ирКэш.ПолучитьТаблицуВсехТаблицБДЛкс();
		Для Каждого СреднееИмяМД Из НачальноеЗначениеВыбора Цикл
			//КорневойТип = ирОбщий.ПолучитьПервыйФрагментЛкс(СреднееИмяМД);
			//Если Не ирОбщий.ЛиКорневойТипТаблицыБДЛкс(КорневойТип) Тогда
			//	ОбъектМДСуществует = Метаданные.НайтиПоПолномуИмени(СреднееИмяМД) <> Неопределено;
			//Иначе
			//	ОбъектМДСуществует = ТаблицаВсехТаблицБД.Найти(СреднееИмяМД, "ПолноеИмя") <> Неопределено;
			//КонецЕсли; 
			//Если ОбъектМДСуществует Тогда
				СтрокаПометки = мСоответствиеПометок.Найти(СреднееИмяМД, "СреднееИмяМД");
				Если СтрокаПометки = Неопределено Тогда
					СтрокаПометки = мСоответствиеПометок.Добавить();
					СтрокаПометки.СреднееИмяМД = СреднееИмяМД;
				КонецЕсли; 
				СтрокаПометки.Пометка = Истина;
			//КонецЕсли; 
		КонецЦикла; 
	Иначе
		ПолноеИмяТекущейСтроки = НачальноеЗначениеВыбора;
	КонецЕсли;
	
	мТолькоПомеченные = Истина
		//И мМножественныйВыбор
		И ТипЗнч(НачальноеЗначениеВыбора) = Тип("Массив")
		И мСоответствиеПометок.Количество() > 0;
	ЗаполнитьДеревоИсточников(, ?(мТолькоПомеченные, НачальноеЗначениеВыбора, Неопределено));
	ЭлементыФормы.ДействияФормы.Кнопки.КнопкаОК.Доступность = ДеревоИсточников.Строки.Количество() > 0 Или мСоответствиеПометок.Количество() > 0;
	
	НоваяТекущаяСтрока = ДеревоИсточников.Строки.Найти(ПолноеИмяТекущейСтроки, "ПолноеИмяОбъекта", Истина);
	Если НоваяТекущаяСтрока <> Неопределено Тогда
		ЭлементыФормы.ДеревоИсточников.ТекущаяСтрока = НоваяТекущаяСтрока;
	КонецЕсли;
	ирОбщий.ПоследниеВыбранныеЗаполнитьПодменюЛкс(ЭтаФорма, ЭлементыФормы.ДействияФормы.Кнопки.ПоследниеВыбранные);

КонецПроцедуры // ПриОткрытии()

// Процедура - обработчик выбора строки таблицы.
//
Процедура ДеревоВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если мМножественныйВыбор Тогда 
		УстановитьЗначениеФлажкаСтроки(Элемент.ТекущаяСтрока, Истина);
		НачальноеЗначениеВыбора = ПолучитьКлючиПомеченныхСтрок();
	КонецЕсли; 
	мВыбрать();

КонецПроцедуры // ТабличноеПолеВыбор()

Процедура ПриЗакрытии()
	
	Если Истина
		И Не МодальныйРежим
		И ТипЗнч(ВладелецФормы) = Тип("Форма")
	Тогда
		ВладелецФормы.Панель.Доступность = Истина;
	КонецЕсли; 
	
КонецПроцедуры

Функция ДобавитьСтрокуТабличнойЧасти(ГлавнаяСтрока, ПолноеИмяТаблицы, Имя, Представление, ИмяТекущейКолонки, Подстроки, ЭтоТабличнаяЧасть = Истина) 
	
	СтруктураСвойств = Новый Структура("Имя, Представление", Имя, Представление);
	Если Ложь
		Или Не ирОбщий.ЛиСтрокаСодержитВсеПодстрокиЛкс(СтруктураСвойств[ИмяТекущейКолонки], Подстроки) 
		Или (Истина
			И мДоступныеОбъекты <> Неопределено
			И мДоступныеОбъекты[ПолноеИмяТаблицы] = Неопределено)
	Тогда
		Возврат Неопределено;
	КонецЕсли; 
	ДочерняяТаблица = ГлавнаяСтрока.Строки.Добавить();
	ЗаполнитьЗначенияСвойств(ДочерняяТаблица, СтруктураСвойств); 
	ДочерняяТаблица.ПолноеИмяОбъекта = ПолноеИмяТаблицы;
	//Если ЭтоТабличнаяЧасть Тогда
		ИндексКартинки = мСтрокаТипаТабличнойЧасти.ИндексКартинкиЕдинственное;
	//КонецЕсли; 
	ДочерняяТаблица.ИндексКартинки = ИндексКартинки;
	ЗаполнитьСтрокуДерева(ДочерняяТаблица);
	Возврат ДочерняяТаблица;
	
КонецФункции

Процедура ЗаполнитьСтрокуДерева(СтрокаДерева, УстановитьПометкиРодителей = Истина, УстановитьИзвестность = Истина)
	
	Если Истина
		И мМножественныйВыбор
		И ТипЗнч(НачальноеЗначениеВыбора) = Тип("Массив")
	Тогда
		СтрокаСоответствия = мСоответствиеПометок.Найти(СтрокаДерева.ПолноеИмяОбъекта, "СреднееИмяМД");
		Если СтрокаСоответствия <> Неопределено Тогда
			СтрокаСоответствия.Известный = УстановитьИзвестность;
			Если СтрокаСоответствия.Пометка = Истина Тогда
				СтрокаДерева.Пометка = Истина;
				ПроверитьУстановитьФильтрПоТипуТаблицы(СтрокаДерева);
				Если УстановитьПометкиРодителей Тогда
					ирОбщий.УстановитьПометкиРодителейЛкс(СтрокаДерева.Родитель); // Неоптимально
				КонецЕсли; 
			КонецЕсли; 
		КонецЕсли; 
	КонецЕсли;
	ОписаниеТаблицы = ирОбщий.ПолучитьОписаниеТаблицыБДИис(СтрокаДерева.ПолноеИмяОбъекта);
	Если Истина
		И ОписаниеТаблицы <> Неопределено 
		И ОписаниеТаблицы.КоличествоСтрок <> Неопределено
	Тогда
		ирОбщий.ДобавитьКоличествоСтрокРодителюЛкс(СтрокаДерева, ОписаниеТаблицы.КоличествоСтрок);
	КонецЕсли; 
	
КонецПроцедуры

// Процедура предназначена для заполнения дерева таблиц, которые
// могут служить источниками данных.
//
Процедура ЗаполнитьДеревоИсточников(Знач Фильтр = Неопределено, МассивДоступныхОбъектов = Неопределено, Принудительно = Ложь) Экспорт
	
	Если МассивДоступныхОбъектов = Неопределено Тогда
		Если мМножественныйВыбор Тогда
			ПомеченныеСтроки = ПолучитьКлючиПомеченныхСтрок();
			Для Каждого ПолноеИмяМД Из ПомеченныеСтроки Цикл
				Если НачальноеЗначениеВыбора.Найти(ПолноеИмяМД) = Неопределено Тогда
					НачальноеЗначениеВыбора.Добавить(ПолноеИмяМД);
				КонецЕсли; 
			КонецЦикла;
		КонецЕсли;
		Если мТолькоПомеченные Тогда
			МассивДоступныхОбъектов = НачальноеЗначениеВыбора;
		Иначе
			МассивДоступныхОбъектов = мМассивДоступныхОбъектов;
		КонецЕсли;
	КонецЕсли;
	мДоступныеОбъекты = Неопределено;
	Если МассивДоступныхОбъектов <> Неопределено Тогда
		мДоступныеОбъекты = Новый Соответствие();
		Для Каждого ДоступныйОбъект Из МассивДоступныхОбъектов Цикл
			мДоступныеОбъекты.Вставить(ДоступныйОбъект, 1);
		КонецЦикла; 
	КонецЕсли; 
	Если Фильтр = Неопределено Тогда
		Фильтр = ФильтрИмен;
	КонецЕсли;
	Если Истина
		И ЗначениеЗаполнено(мПоследнийФильтр)
		И мПоследнийФильтр = Фильтр 
		И Не Принудительно
	Тогда
		Возврат;
	КонецЕсли; 
	мПоследнийФильтр = Фильтр;
	ЭлементыФормы.ДействияФормы.Кнопки.ТолькоПомеченные.Пометка = мТолькоПомеченные;
	ТабличноеПолеДерева = ЭлементыФормы.ДеревоИсточников;
	Если ТабличноеПолеДерева.ТекущаяСтрока <> Неопределено Тогда
		КлючТекущейСтроки = ТабличноеПолеДерева.ТекущаяСтрока.ПолноеИмяОбъекта;
	Иначе
		КлючТекущейСтроки = Неопределено;
	КонецЕсли; 
	ПодстрокиФильтра = ирОбщий.ПолучитьМассивИзСтрокиСРазделителемЛкс(НРег(Фильтр), " ", Истина);
	ТекущаяКолонкаТП = ирОбщий.ОпределитьВедущуюСтроковуюКолонкуТабличногоПоляЛкс(ТабличноеПолеДерева);
	ИмяТекущейКолонки = ТекущаяКолонкаТП.Данные;
	
	ДеревоИсточников.Строки.Очистить();
	КоллекцияКорневыхТипов = Новый Массив;
	СтрокиМетаОбъектов = ирКэш.Получить().ТаблицаТиповМетаОбъектов.НайтиСтроки(Новый Структура("Категория", 0));
	Для Каждого СтрокаТаблицыМетаОбъектов Из СтрокиМетаОбъектов Цикл
		Единственное = СтрокаТаблицыМетаОбъектов.Единственное;
		Если Ложь
			Или (Истина
				И мФильтрКорневыхТипов <> Неопределено
				И мФильтрКорневыхТипов.Найти(Единственное) <> Неопределено)
			Или (Истина
				И мОтображатьПоследовательности = Истина
				И Единственное = "Последовательность")
			Или (Истина
				И мОтображатьВыборочныеТаблицы = Истина
				И (Ложь
					//Или Единственное = "КритерийОтбора" // там обязательный параметр
					Или Единственное = "ЖурналДокументов"))
			Или (Истина
				И мОтображатьСсылочныеОбъекты = Истина
				И ирОбщий.ЛиКорневойТипСсылочногоОбъектаБДЛкс(Единственное)
				И (Ложь
					Или мНеОтображатьПланыОбмена <> Истина
					Или Единственное <> "ПланОбмена"))
			Или (Истина
				И мОтображатьПеречисления = Истина
				И ирОбщий.ЛиКорневойТипПеречисленияЛкс(Единственное))
			Или (Истина
				И мОтображатьРегистры = Истина
				И ирОбщий.ЛиКорневойТипРегистраБДЛкс(Единственное, Ложь))
		Тогда
			КоллекцияКорневыхТипов.Добавить(Единственное);
		КонецЕсли;
	КонецЦикла;
	Если Истина 
		И мОтображатьВнешниеИсточникиДанных = Истина
		И ирКэш.Получить().ВерсияПлатформы >= 802014 
	Тогда
		Если Ложь
			Или мОтображатьСсылочныеОбъекты = Истина
			Или мОтображатьРегистры = Истина
		Тогда
			Для Каждого МетаВнешнийИсточникДанных Из Метаданные.ВнешниеИсточникиДанных Цикл
				КоллекцияКорневыхТипов.Добавить(МетаВнешнийИсточникДанных.ПолноеИмя());
			КонецЦикла; 
		КонецЕсли; 
	КонецЕсли; 
	Если мОтображатьОтчеты = Истина Тогда
		КоллекцияКорневыхТипов.Добавить("Отчет");
	КонецЕсли;
	Если мОтображатьОбработки = Истина Тогда
		КоллекцияКорневыхТипов.Добавить("Обработка");
	КонецЕсли; 
	Если мОтображатьКонстанты = Истина Тогда
		КоллекцияКорневыхТипов.Добавить("Константа");
	КонецЕсли;
	Если мОтображатьРегламентныеЗадания = Истина Тогда
		КоллекцияКорневыхТипов.Добавить("РегламентноеЗадание");
	КонецЕсли; 
	
	Для Каждого КорневойТип Из КоллекцияКорневыхТипов Цикл
		СтрокаКорневогоТипа = ПолучитьСтрокуТипаМетаОбъектов(КорневойТип);
		Если СтрокаКорневогоТипа = Неопределено Тогда
			СтрокаКорневогоТипа = мСтрокаТипаВнешнегоИсточникаДанных;
			ОбъектМДКорневогоТипа = Метаданные.НайтиПоПолномуИмени(КорневойТип);
			КоллекцияМетаданных = ОбъектМДКорневогоТипа.Таблицы;
			ПредставлениеКатегории = ирОбщий.ПолучитьПредставлениеИзИдентификатораЛкс(СтрокаКорневогоТипа.Множественное) + "." + ОбъектМДКорневогоТипа.Представление();
			МножественноеКорневогоТипа = КорневойТип;
		Иначе
			МножественноеКорневогоТипа = СтрокаКорневогоТипа.Множественное;
			ПредставлениеКатегории = ирОбщий.ПолучитьПредставлениеИзИдентификатораЛкс(МножественноеКорневогоТипа);
			Если КорневойТип = "Перерасчет" Тогда 
				КоллекцияМетаданных = Новый Массив;
				Если мОтображатьПерерасчеты <> Ложь Тогда
					Для Каждого МетаРегистрРасчета Из Метаданные.РегистрыРасчета Цикл
						Для Каждого Перерасчет Из МетаРегистрРасчета.Перерасчеты Цикл
							КоллекцияМетаданных.Добавить(Перерасчет);
						КонецЦикла;
					КонецЦикла;
				КонецЕсли; 
			Иначе
				КоллекцияМетаданных = Метаданные[МножественноеКорневогоТипа];
			КонецЕсли; 
		КонецЕсли; 
		//Если мДоступныеОбъекты <> Неопределено Тогда
		//            ДоступныеОбъектыТипа = мДоступныеОбъекты[НРег(СтрокаКорневогоТипа.Единственное)];
		//            Если ДоступныеОбъектыТипа = Неопределено Тогда
		//                           Продолжить;
		//            КонецЕсли; 
		//КонецЕсли; 
		Если КоллекцияМетаданных.Количество() = 0 Тогда
			Продолжить;
		КонецЕсли;
		НовыйИсточник = ДеревоИсточников.Строки.Добавить();
		НовыйИсточник.Представление = ПредставлениеКатегории;
		НовыйИсточник.Имя = МножественноеКорневогоТипа;
		НовыйИсточник.ПолноеИмяОбъекта = МножественноеКорневогоТипа;
		НовыйИсточник.ИндексКартинки = СтрокаКорневогоТипа.ИндексКартинкиМножественное;
		Для Каждого МетаИсточник Из КоллекцияМетаданных Цикл
			ПолноеИмяМД = МетаИсточник.ПолноеИмя();
			//Если ДоступныеОбъектыТипа <> Неопределено Тогда
			//            Если ДоступныеОбъектыТипа[НРег(МетаИсточник.Имя)] = Неопределено Тогда
			//                           Продолжить;
			//            КонецЕсли; 
			//КонецЕсли;
			//
			Если Ложь
				Или (Истина
					И мТолькоИспользованиеПолнотекстовогоПоиска = Истина
					И (Ложь
						Или КорневойТип = "Перерасчет"
						Или КорневойТип = "Константа"
						Или МетаИсточник.ПолнотекстовыйПоиск = Метаданные.СвойстваОбъектов.ИспользованиеПолнотекстовогоПоиска.НеИспользовать))
				Или (Истина
					И мФильтрКорневыхТипов = Неопределено
					И мОтображатьСсылочныеОбъекты <> Истина
					И ирОбщий.ЛиСсылочныйОбъектМетаданных(МетаИсточник))
				Или (Истина
					И мФильтрКорневыхТипов = Неопределено
					И мОтображатьРегистры <> Истина
					И ирОбщий.ЛиРегистровыйОбъектМетаданных(МетаИсточник))
			Тогда
				Продолжить;
			КонецЕсли;
			ГлавнаяСтрока = НовыйИсточник.Строки.Добавить();
			ГлавнаяСтрока.ПолноеИмяОбъекта = ирОбщий.ПолучитьИмяТаблицыИзМетаданныхЛкс(ПолноеИмяМД,, Ложь);
			ГлавнаяСтрока.Имя = МетаИсточник.Имя;
			ГлавнаяСтрока.Представление = МетаИсточник.Представление();
			Если КорневойТип = "Перерасчет" Тогда
				МетаРегистрРасчета = МетаИсточник.Родитель();
				ГлавнаяСтрока.Имя = МетаРегистрРасчета.Имя + "." + ГлавнаяСтрока.Имя;
				ГлавнаяСтрока.Представление = МетаРегистрРасчета.Представление() + "." + ГлавнаяСтрока.Представление;
			КонецЕсли; 
			ГлавнаяСтрока.ИндексКартинки = СтрокаКорневогоТипа.ИндексКартинкиЕдинственное;
			ЗаполнитьСтрокуДерева(ГлавнаяСтрока, Ложь);
			Если мОтображатьТабличныеЧасти = Истина Тогда
				Если ирОбщий.ЛиКорневойТипСсылочногоОбъектаБДЛкс(КорневойТип) Тогда
					СтруктураТЧ = ирОбщий.ПолучитьТабличныеЧастиОбъектаЛкс(МетаИсточник);
					Для Каждого КлючИЗначение Из СтруктураТЧ Цикл
						ДобавитьСтрокуТабличнойЧасти(ГлавнаяСтрока, ГлавнаяСтрока.ПолноеИмяОбъекта + "." + КлючИЗначение.Ключ,
							КлючИЗначение.Ключ, КлючИЗначение.Значение, ИмяТекущейКолонки, ПодстрокиФильтра);
					КонецЦикла;
				КонецЕсли; 
			КонецЕсли;
			Если мОтображатьПеречисления = Истина Тогда
				Если КорневойТип = "БизнесПроцесс" Тогда 
					ДобавитьСтрокуТабличнойЧасти(ГлавнаяСтрока, ГлавнаяСтрока.ПолноеИмяОбъекта + ".Точки", "Точки", "Точки", ИмяТекущейКолонки, ПодстрокиФильтра);
				КонецЕсли; 
			КонецЕсли; 
			Если мОтображатьТаблицыИзменений = Истина Тогда
				Если ирОбщий.ЕстьТаблицаИзмененийОбъектаМетаданных(МетаИсточник) Тогда
					ДобавитьСтрокуТабличнойЧасти(ГлавнаяСтрока, ГлавнаяСтрока.ПолноеИмяОбъекта + ".Изменения", "Изменения", "Изменения", ИмяТекущейКолонки, ПодстрокиФильтра);
				КонецЕсли;
			КонецЕсли;
			Если мОтображатьВиртуальныеТаблицы = Истина Тогда
				Если КорневойТип = "РегистрСведений" Тогда 
					Если МетаИсточник.ПериодичностьРегистраСведений <> Метаданные.СвойстваОбъектов.ПериодичностьРегистраСведений.Непериодический Тогда
						ДобавитьСтрокуТабличнойЧасти(ГлавнаяСтрока, МетаИсточник.ПолноеИмя() + ".СрезПоследних", МетаИсточник.Имя + ".СрезПоследних",
							МетаИсточник.Представление() + ": срез последних", ИмяТекущейКолонки, ПодстрокиФильтра); 
						ДобавитьСтрокуТабличнойЧасти(ГлавнаяСтрока, МетаИсточник.ПолноеИмя() + ".СрезПервых", МетаИсточник.Имя + ".СрезПервых",
							МетаИсточник.Представление() + ": срез первых", ИмяТекущейКолонки, ПодстрокиФильтра); 
					КонецЕсли;
				ИначеЕсли КорневойТип = "РегистрНакопления" Тогда 
					ДобавитьСтрокуТабличнойЧасти(ГлавнаяСтрока, МетаИсточник.ПолноеИмя() + ".Обороты", МетаИсточник.Имя + ".Обороты",
						МетаИсточник.Представление() + ": Обороты", ИмяТекущейКолонки, ПодстрокиФильтра);  
					Если МетаИсточник.ВидРегистра = Метаданные.СвойстваОбъектов.ВидРегистраНакопления.Остатки Тогда
						ДобавитьСтрокуТабличнойЧасти(ГлавнаяСтрока, МетаИсточник.ПолноеИмя() + ".Остатки", МетаИсточник.Имя + ".Остатки",
							МетаИсточник.Представление() + ": Остатки", ИмяТекущейКолонки, ПодстрокиФильтра);  
						ДобавитьСтрокуТабличнойЧасти(ГлавнаяСтрока, МетаИсточник.ПолноеИмя() + ".ОстаткиИОбороты", МетаИсточник.Имя + ".ОстаткиИОбороты",
							МетаИсточник.Представление() + ": Остатки и обороты", ИмяТекущейКолонки, ПодстрокиФильтра);  
					КонецЕсли;
				ИначеЕсли КорневойТип = "РегистрБухгалтерии" Тогда 
					ДобавитьСтрокуТабличнойЧасти(ГлавнаяСтрока, МетаИсточник.ПолноеИмя() + ".Обороты", МетаИсточник.Имя + ".Обороты",
						МетаИсточник.Представление() + ": Обороты", ИмяТекущейКолонки, ПодстрокиФильтра);  
					Если МетаИсточник.Корреспонденция Тогда
						ДобавитьСтрокуТабличнойЧасти(ГлавнаяСтрока, МетаИсточник.ПолноеИмя() + ".ОборотыДтКт", МетаИсточник.Имя + ".ОборотыДтКт",
							МетаИсточник.Представление() + ": Обороты Дт Кт", ИмяТекущейКолонки, ПодстрокиФильтра);  
					КонецЕсли;
					ДобавитьСтрокуТабличнойЧасти(ГлавнаяСтрока, МетаИсточник.ПолноеИмя() + ".ДвиженияССубконто", МетаИсточник.Имя + ".ДвиженияССубконто",
						МетаИсточник.Представление() + ": Движения с субконто", ИмяТекущейКолонки, ПодстрокиФильтра);  
					ДобавитьСтрокуТабличнойЧасти(ГлавнаяСтрока, МетаИсточник.ПолноеИмя() + ".Субконто", МетаИсточник.Имя + ".Субконто",
						МетаИсточник.Представление() + ": Субконто", ИмяТекущейКолонки, ПодстрокиФильтра);  
					ДобавитьСтрокуТабличнойЧасти(ГлавнаяСтрока, МетаИсточник.ПолноеИмя() + ".Остатки", МетаИсточник.Имя + ".Остатки",
						МетаИсточник.Представление() + ": Остатки", ИмяТекущейКолонки, ПодстрокиФильтра);  
					ДобавитьСтрокуТабличнойЧасти(ГлавнаяСтрока, МетаИсточник.ПолноеИмя() + ".ОстаткиИОбороты", МетаИсточник.Имя + ".ОстаткиИОбороты",
						МетаИсточник.Представление() + ": Остатки и обороты", ИмяТекущейКолонки, ПодстрокиФильтра);  
				ИначеЕсли КорневойТип = "Последовательность" Тогда 
					ДобавитьСтрокуТабличнойЧасти(ГлавнаяСтрока, МетаИсточник.ПолноеИмя() + ".Границы", МетаИсточник.Имя + ".Границы",
						МетаИсточник.Представление() + ": Границы", ИмяТекущейКолонки, ПодстрокиФильтра);  
				КонецЕсли;
			КонецЕсли;
			Если ГлавнаяСтрока.Строки.Количество() = 0 Тогда
				Если Ложь
					Или Не ирОбщий.ЛиСтрокаСодержитВсеПодстрокиЛкс(ГлавнаяСтрока[ИмяТекущейКолонки], ПодстрокиФильтра) 
					Или (Истина
						И мДоступныеОбъекты <> Неопределено
						И мДоступныеОбъекты[ГлавнаяСтрока.ПолноеИмяОбъекта] = Неопределено)
				Тогда
					ГлавнаяСтрока.Родитель.Строки.Удалить(ГлавнаяСтрока);
				КонецЕсли; 
			КонецЕсли;
		КонецЦикла;
		Если Истина
			И НовыйИсточник.Строки.Количество() = 0
			//И Не ирОбщий.ЛиСтрокаСодержитВсеПодстрокиЛкс(НовыйИсточник[ИмяТекущейКолонки], ПодстрокиФильтра) 
		Тогда
			ДеревоИсточников.Строки.Удалить(НовыйИсточник);
		Иначе
			ирОбщий.УстановитьПометкиРодителейЛкс(НовыйИсточник);
		КонецЕсли; 
	КонецЦикла;
	
	НовыйИсточник = ДеревоИсточников.Строки.Добавить();
	НовыйИсточник.Представление = "Неизвестные";
	НовыйИсточник.Имя = "Неизвестные";
	НовыйИсточник.ПолноеИмяОбъекта = НовыйИсточник.Имя;
	Для Каждого СтрокаНеизвестногоМД Из мСоответствиеПометок.НайтиСтроки(Новый Структура("Известный", Ложь)) Цикл
		ГлавнаяСтрока = НовыйИсточник.Строки.Добавить();
		ГлавнаяСтрока.ПолноеИмяОбъекта = СтрокаНеизвестногоМД.СреднееИмяМД;
		ГлавнаяСтрока.Имя = СтрокаНеизвестногоМД.СреднееИмяМД;
		ГлавнаяСтрока.Представление = СтрокаНеизвестногоМД.СреднееИмяМД;
		ЗаполнитьСтрокуДерева(ГлавнаяСтрока, Ложь, Ложь);
		Если Ложь
			Или Не ирОбщий.ЛиСтрокаСодержитВсеПодстрокиЛкс(ГлавнаяСтрока[ИмяТекущейКолонки], ПодстрокиФильтра) 
			Или (Истина
				И мДоступныеОбъекты <> Неопределено
				И мДоступныеОбъекты[ГлавнаяСтрока.ПолноеИмяОбъекта] = Неопределено)
		Тогда
			ГлавнаяСтрока.Родитель.Строки.Удалить(ГлавнаяСтрока);
		КонецЕсли; 
	КонецЦикла;  
	Если Истина
		И НовыйИсточник.Строки.Количество() = 0
		//И Не ирОбщий.ЛиСтрокаСодержитВсеПодстрокиЛкс(НовыйИсточник[ИмяТекущейКолонки], ПодстрокиФильтра) 
	Тогда
		ДеревоИсточников.Строки.Удалить(НовыйИсточник);
	Иначе
		ирОбщий.УстановитьПометкиРодителейЛкс(НовыйИсточник);
	КонецЕсли; 
	
	Если мОтображатьКоличество = Истина Тогда
		ирОбщий.ОбновитьКоличествоСтрокТаблицВДеревеМетаданныхЛкс(ДеревоИсточников);
	КонецЕсли;
	ТекущаяСтрокаУстановлена = Ложь;
	Если КлючТекущейСтроки <> Неопределено Тогда
		НоваяТекущаяСтрока = ДеревоИсточников.Строки.Найти(КлючТекущейСтроки, "ПолноеИмяОбъекта", Истина);
		Если НоваяТекущаяСтрока <> Неопределено Тогда
			ЭлементыФормы.ДеревоИсточников.ТекущаяСтрока = НоваяТекущаяСтрока;
			ТекущаяСтрокаУстановлена = Истина;
		КонецЕсли; 
	КонецЕсли;
	СортироватьДерево();
	
	ирОбщий.ТабличноеПолеДеревоЗначений_АвтоРазвернутьВсеСтрокиЛкс(ТабличноеПолеДерева, , ТекущаяСтрокаУстановлена);
	
КонецПроцедуры

Процедура ДобавитьКоличествоСтрокРодителюЛкс(Знач НовыйИсточник, Родитель, Знач ИмяСуммируемойКолонки= "КоличествоСтрок")
	
	Если ТипЗнч(НовыйИсточник[ИмяСуммируемойКолонки]) <> Тип("Число") Тогда
		Родитель[ИмяСуммируемойКолонки] = "?";
	КонецЕсли; 
	КоличествоРодителя = Родитель[ИмяСуммируемойКолонки];
	Если КоличествоРодителя = "?" Тогда
		Возврат;
	КонецЕсли; 
	Если ТипЗнч(КоличествоРодителя) <> Тип("Число") Тогда
		КоличествоРодителя = 0;
	КонецЕсли; 
	Родитель[ИмяСуммируемойКолонки] = КоличествоРодителя + НовыйИсточник[ИмяСуммируемойКолонки];

КонецПроцедуры

Процедура СортироватьДерево()
	
	Если РежимИмяСиноним Тогда
		ИмяКолонкиСортировки = "Имя";
	Иначе
		ИмяКолонкиСортировки = "Представление";
	КонецЕсли;
	ДеревоИсточников.Строки.Сортировать(ИмяКолонкиСортировки, Истина);
	//Для Каждого КорневаяСтрока Из ДеревоИсточников.Строки Цикл
	//	КорневаяСтрока.Строки.Сортировать(ИмяКолонкиСортировки);
	//КонецЦикла;

КонецПроцедуры

Процедура ДеревоИсточниковПриИзмененииФлажка(Элемент, Колонка)
	
	ТекущаяСтрока = Элемент.ТекущиеДанные;
	ИмяКолонкиПометки = "Пометка";
	НовоеЗначениеПометки = ТекущаяСтрока[ИмяКолонкиПометки];
	НовоеЗначениеПометки = НовоеЗначениеПометки -1;
	Если НовоеЗначениеПометки < 0 Тогда
		НовоеЗначениеПометки = 1;
	КонецЕсли;
	УстановитьЗначениеФлажкаСтроки(ТекущаяСтрока, НовоеЗначениеПометки);
	Если мМножественныйВыбор Тогда
		НачальноеЗначениеВыбора = ПолучитьКлючиПомеченныхСтрок();
	КонецЕсли; 
	
КонецПроцедуры

Процедура УстановитьЗначениеФлажкаСтроки(ТекущаяСтрока, НовоеЗначениеПометки, ОбновлятьРодителя = Неопределено, СоВсемиПотоками = Ложь)
	
	ИмяКолонкиПометки = "Пометка";
	КлючСовпадает = ЛиКлючТаблицыПодходит(ТекущаяСтрока);
	Если Не КлючСовпадает И НовоеЗначениеПометки > 0 Тогда
	Иначе
		ТекущаяСтрока[ИмяКолонкиПометки] = НовоеЗначениеПометки;
		СтароеЗначениеПометки = Неопределено;
		Если ТекущаяСтрока.Уровень() > 0 Тогда
			СтрокаСоответствия = мСоответствиеПометок.Найти(ТекущаяСтрока.ПолноеИмяОбъекта, "СреднееИмяМД");
			Если СтрокаСоответствия <> Неопределено Тогда
				СтароеЗначениеПометки = СтрокаСоответствия.Пометка;
			Иначе
				СтрокаСоответствия = мСоответствиеПометок.Добавить();
				СтрокаСоответствия.СреднееИмяМД = ТекущаяСтрока.ПолноеИмяОбъекта;
			КонецЕсли; 
			СтрокаСоответствия.Пометка = НовоеЗначениеПометки > 0; //
		КонецЕсли; 
	КонецЕсли; 
	Если КлючСовпадает Тогда
		Если ОбновлятьРодителя = Неопределено Тогда
			ирОбщий.УстановитьПометкиРодителейЛкс(ТекущаяСтрока.Родитель);
		Иначе
			ОбновлятьРодителя = Истина;
		КонецЕсли; 
		Если ТекущаяСтрока.Уровень() > 0 Тогда
			Если НовоеЗначениеПометки = 0 Тогда
				ПроверитьОтключитьФильтрПоТипуТаблицы();
			Иначе 
				ПроверитьУстановитьФильтрПоТипуТаблицы(ТекущаяСтрока);
			КонецЕсли; 
		КонецЕсли; 
	Иначе
		Если СтароеЗначениеПометки <> НовоеЗначениеПометки Тогда
			ПроверитьОтключитьФильтрПоТипуТаблицы();
		КонецЕсли; 
	КонецЕсли; 
	ОбновлятьРодителяСнизу = Ложь;
	Если Ложь
		Или ТекущаяСтрока.Уровень() = 0
		Или НовоеЗначениеПометки = 0
		Или СоВсемиПотоками
	Тогда
		Для Каждого СтрокаДерева Из ТекущаяСтрока.Строки Цикл
			УстановитьЗначениеФлажкаСтроки(СтрокаДерева, НовоеЗначениеПометки, ОбновлятьРодителяСнизу, СоВсемиПотоками);
		КонецЦикла;  
	КонецЕсли; 
	Если ОбновлятьРодителяСнизу Тогда
		ирОбщий.УстановитьПометкиРодителейЛкс(ТекущаяСтрока);
		ПроверитьОтключитьФильтрПоТипуТаблицы();
	КонецЕсли; 

КонецПроцедуры

Процедура ПроверитьОтключитьФильтрПоТипуТаблицы()
	
	КлючПомеченных = ПолучитьКлючиПомеченныхСтрок(Истина);
	Если КлючПомеченных.Количество() = 0 Тогда
		мТипТаблицы = Неопределено;
	КонецЕсли;

КонецПроцедуры

Функция ПроверитьУстановитьФильтрПоТипуТаблицы(ТекущаяСтрока)

	Если мМножественныйВыборТолькоДляОднотипныхТаблиц = Истина Тогда
		Если мТипТаблицы = Неопределено Тогда
			мТипТаблицы = ирОбщий.ПолучитьТипТаблицыБДЛкс(ТекущаяСтрока.ПолноеИмяОбъекта);
			мСтруктураКлючаТаблицы = ирОбщий.ПолучитьСтруктуруКлючаТаблицыБДЛкс(ТекущаяСтрока.ПолноеИмяОбъекта);
		КонецЕсли; 
	КонецЕсли; 
	Возврат Неопределено;

КонецФункции

Функция ЛиКлючТаблицыПодходит(СтрокаДерева)

	КлючСовпадает = Истина;
	Если мТипТаблицы <> Неопределено Тогда
		КлючСовпадает = Ложь;
		Если мТипТаблицы = ирОбщий.ПолучитьТипТаблицыБДЛкс(СтрокаДерева.ПолноеИмяОбъекта) Тогда
			КлючСовпадает = Истина;
			СтруктураКлючаТаблицы = ирОбщий.ПолучитьСтруктуруКлючаТаблицыБДЛкс(СтрокаДерева.ПолноеИмяОбъекта);
			Если мСтруктураКлючаТаблицы.Количество() <> СтруктураКлючаТаблицы.Количество() Тогда
				КлючСовпадает = Ложь;
			Иначе
				Для Каждого КлючИзначение Из СтруктураКлючаТаблицы Цикл
					Если Не мСтруктураКлючаТаблицы.Свойство(КлючИзначение.Ключ) Тогда
						КлючСовпадает = Ложь;
						Прервать;
					КонецЕсли; 
				КонецЦикла; 
			КонецЕсли; 
		КонецЕсли; 
	КонецЕсли;

	Возврат КлючСовпадает;

КонецФункции

Процедура ДеревоИсточниковПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	
	ирОбщий.ТабличноеПоле_ОформитьЯчейкиИмяСинонимЛкс(Элемент, ОформлениеСтроки,,,, ?(мМножественныйВыбор, "Пометка", ""));
	//Если ДанныеСтроки.Строки.Количество() = 0 Тогда
	Если ДанныеСтроки.Уровень() > 0 Тогда
		КлючСовпадает = ЛиКлючТаблицыПодходит(ДанныеСтроки);
	ИначеЕсли ДанныеСтроки.Строки.Количество() > 0 Тогда 
		КлючСовпадает = ЛиКлючТаблицыПодходит(ДанныеСтроки.Строки[0]);
	Иначе
		КлючСовпадает = Ложь;
	КонецЕсли; 
	Если Не КлючСовпадает Тогда
		ОформлениеСтроки.Ячейки.Представление.ОтображатьФлажок = Ложь;
		ОформлениеСтроки.Ячейки.Имя.ОтображатьФлажок = Ложь;
	КонецЕсли; 
	Если ДанныеСтроки.КоличествоСтрок = Неопределено Тогда
		ОформлениеСтроки.Ячейки.КоличествоСтрок.УстановитьТекст("?");
	КонецЕсли; 
	
КонецПроцедуры

Процедура ДействияФормыОбновить(Кнопка)
	
	ирОбщий.ВычислитьКоличествоСтрокТаблицВДеревеМетаданныхЛкс(ДеревоИсточников);
	ирОбщий.ЗаполнитьКоличествоСтрокТаблицВДеревеМетаданныхЛкс(ДеревоИсточников);
	ЭлементыФормы.ДеревоИсточников.Колонки.КоличествоСтрок.Видимость = Истина;
	
КонецПроцедуры

Процедура ДействияФормыФормаСписка(Кнопка)
	
	ТекущаяСтрока = ЭлементыФормы.ДеревоИсточников.ТекущаяСтрока;
	Если ТекущаяСтрока <> Неопределено Тогда
		ТипТаблицы = ирОбщий.ПолучитьТипТаблицыБДЛкс(ТекущаяСтрока.ПолноеИмяОбъекта);
		Если Ложь
			Или ирОбщий.ЛиКорневойТипСсылочногоОбъектаБДЛкс(ТипТаблицы) 
			Или ирОбщий.ЛиКорневойТипРегистраБДЛкс(ТипТаблицы)
		Тогда
			ОткрытьФорму(ТекущаяСтрока.ПолноеИмяОбъекта + ".ФормаСписка");
		КонецЕсли; 
	КонецЕсли; 
	
КонецПроцедуры

Процедура ДействияФормыУстановитьПометки(Кнопка)
	
	ИзменитьПометкиВыделенныхСтрок(Истина);
	
КонецПроцедуры

Процедура ДействияФормыСнятьПометки(Кнопка)
	
	ИзменитьПометкиВыделенныхСтрок(Ложь);

КонецПроцедуры

Процедура ИзменитьПометкиВыделенныхСтрок(НовоеЗначениеПометки, СоВсемиПотоками = Ложь)
	
	ВыделенныеСтроки = ЭлементыФормы.ДеревоИсточников.ВыделенныеСтроки;
	Если Не СоВсемиПотоками И ВыделенныеСтроки.Количество() < 2 Тогда
		ВыделенныеСтроки = ЭлементыФормы.ДеревоИсточников.Значение.Строки;
	КонецЕсли; 
	Для Каждого СтрокаДерева Из ВыделенныеСтроки Цикл
		Если ЛиКлючТаблицыПодходит(СтрокаДерева) Или Не НовоеЗначениеПометки Тогда
			УстановитьЗначениеФлажкаСтроки(СтрокаДерева, НовоеЗначениеПометки, , СоВсемиПотоками);
		КонецЕсли; 
	КонецЦикла;
	Если мМножественныйВыбор Тогда
		НачальноеЗначениеВыбора = ПолучитьКлючиПомеченныхСтрок();
	КонецЕсли;

КонецПроцедуры

Процедура ДействияФормыОтборПоПодсистеме(Кнопка)
	
	//ФормаВыбора = ирОбщий.ПолучитьФормуЛкс("Обработка.ирПлатформа.Форма.ВыборПодсистемы");
	//ФормаВыбора.РежимВыбора = Истина;
	//ВыбранноеЗначение = ФормаВыбора.ОткрытьМодально();
	
КонецПроцедуры

Процедура ДействияФормыИмяСиноним(Кнопка)
	
	РежимИмяСиноним = Не Кнопка.Пометка;
	ирОбщий.СохранитьЗначениеЛкс("ВыборОбъектаМетаданных.РежимИмяСиноним", РежимИмяСиноним);
	Кнопка.Пометка = РежимИмяСиноним;
	ирОбщий.ТабличноеПоле_ОбновитьКолонкиИмяСинонимЛкс(ЭлементыФормы.ДеревоИсточников, РежимИмяСиноним);
	ЗаполнитьДеревоИсточников(,, Истина);
	
КонецПроцедуры

Процедура ФильтрИменПриИзменении(Элемент)
	
	СтандартнаяОбработка = Ложь;
	Если мТолькоПомеченные Тогда
		ДействияФормыТолькоПомеченные();
	КонецЕсли; 
	//ирОбщий.НайтиСтрокуТабличногоПоляДереваЗначенийСоСложнымФильтромЛкс(ЭлементыФормы.ДеревоИсточников, ЭлементыФормы.ФильтрИмен);
	ЗаполнитьДеревоИсточников();
	ирОбщий.ПолеВводаСИсториейВыбора_ПриИзмененииЛкс(Элемент, ЭтаФорма);

КонецПроцедуры

Процедура ФильтрИменНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	
	ирОбщий.ПолеВводаСИсториейВыбора_НачалоВыбораИзСпискаЛкс(Элемент, ЭтаФорма);
	
КонецПроцедуры

Процедура ФильтрИменОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	//ирОбщий.НайтиСтрокуТабличногоПоляДереваЗначенийСоСложнымФильтромЛкс(ЭлементыФормы.ДеревоИсточников, ЭлементыФормы.ФильтрИмен);
	ЗаполнитьДеревоИсточников();
	
КонецПроцедуры

Процедура ФильтрИменАвтоПодборТекста(Элемент, Текст, ТекстАвтоПодбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	//ирОбщий.НайтиСтрокуТабличногоПоляДереваЗначенийСоСложнымФильтромЛкс(ЭлементыФормы.ДеревоИсточников, ЭлементыФормы.ФильтрИмен, Текст);
	ЗаполнитьДеревоИсточников(Текст);
	
КонецПроцедуры

Процедура КнопкаОкНажатие(Кнопка)
	
	мВыбрать();
	
КонецПроцедуры

Процедура ДействияФормыТолькоПомеченные(Кнопка = Неопределено)
	
	Кнопка = ЭлементыФормы.ДействияФормы.Кнопки.ТолькоПомеченные;
	мТолькоПомеченные = Не Кнопка.Пометка;
	ЗаполнитьДеревоИсточников();
	
КонецПроцедуры

Процедура СтруктураКоманднойПанелиНажатие(Кнопка)
	
	ирОбщий.ОткрытьСтруктуруКоманднойПанелиЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	ирОбщий.ФормаОбработкаОповещенияЛкс(ЭтаФорма, ИмяСобытия, Параметр, Источник); 

КонецПроцедуры

Процедура ДействияФормыПометитьПоРегистратору(Кнопка)
	
	Форма = ирКэш.Получить().ПолучитьФорму("ВыборОбъектаМетаданных", ЭтаФорма, ЭтаФорма);
	лСтруктураПараметров = Новый Структура;
	лСтруктураПараметров.Вставить("ОтображатьРегистры", Истина);
	лСтруктураПараметров.Вставить("ОтображатьСсылочныеОбъекты", Ложь);
	Форма.НачальноеЗначениеВыбора = лСтруктураПараметров;
	ЗначениеВыбора = Форма.ОткрытьМодально();
	Если ЗначениеВыбора <> Неопределено Тогда
		ОбъектМД = Метаданные.НайтиПоПолномуИмени(ЗначениеВыбора.ПолноеИмяОбъекта);
		ПостроительЗапроса = Новый ПостроительЗапроса("ВЫБРАТЬ Т.* ИЗ " + ЗначениеВыбора.ПолноеИмяОбъекта + " КАК Т");
		ПостроительЗапроса.ЗаполнитьНастройки();
		ПоляТаблицы = ПостроительЗапроса.ДоступныеПоля;
		Если ПоляТаблицы.Найти("Регистратор") <> Неопределено Тогда
			Массив = Новый Массив;
			Для Каждого ТипРегистратора Из ПоляТаблицы.Регистратор.ТипЗначения.Типы() Цикл
				Регистратор = Метаданные.НайтиПоТипу(ТипРегистратора);
				СтрокаДерева = ДеревоИсточников.Строки.Найти(Регистратор.ПолноеИмя(), "ПолноеИмяОбъекта", Истина);
				Если СтрокаДерева <> Неопределено И ЛиКлючТаблицыПодходит(СтрокаДерева) Тогда
					УстановитьЗначениеФлажкаСтроки(СтрокаДерева, Истина);
				КонецЕсли; 
			КонецЦикла; 
			НачальноеЗначениеВыбора = ПолучитьКлючиПомеченныхСтрок();
		КонецЕсли; 
	КонецЕсли; 

КонецПроцедуры

Процедура ДействияФормыУстановитьПометкиСоВсемиПотомками(Кнопка)
	
	ИзменитьПометкиВыделенныхСтрок(Истина, Истина);
	
КонецПроцедуры

Процедура ДействияФормыОткрытьМетаданные(Кнопка)
	
	ТекущаяСтрока = ЭлементыФормы.ДеревоИсточников.ТекущаяСтрока;
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	ирОбщий.ОткрытьОбъектМетаданныхЛкс(ТекущаяСтрока.ПолноеИмяОбъекта);

КонецПроцедуры

Функция ПоследниеВыбранныеНажатие(Кнопка) Экспорт
	
	ирОбщий.ПоследниеВыбранныеНажатиеЛкс(ЭтаФорма, ЭлементыФормы.ДеревоИсточников, ДеревоИсточников.Колонки.ПолноеИмяОбъекта.Имя, Кнопка);
	
КонецФункции

ирОбщий.ИнициализироватьФормуЛкс(ЭтаФорма, "Обработка.ирПлатформа.Форма.ВыборОбъектаМетаданных");

мМножественныйВыборТолькоДляОднотипныхТаблиц = Ложь;
мОтображатьСсылочныеОбъекты = Истина;
мОтображатьРегистры = Истина;
мОтображатьПоследовательности = Истина;
мОтображатьТабличныеЧасти = Истина;
мСтрокаТипаТабличнойЧасти = ПолучитьСтрокуТипаМетаОбъектов("ТабличнаяЧасть", , 2);
мСтрокаТипаВнешнегоИсточникаДанных = ПолучитьСтрокуТипаМетаОбъектов("ВнешнийИсточникДанных", , 0);

//ДеревоИсточников.Колонки.Добавить("Пометка", Новый ОписаниеТипов("Число"));
//ДеревоИсточников.Колонки.Добавить("ПолноеИмяОбъекта");
