﻿
Процедура СтруктураКоманднойПанелиНажатие(Кнопка)
	
	ирОбщий.ОткрытьСтруктуруКоманднойПанелиЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура ПриОткрытии()
	
	ЭтаФорма.ФайлСписокПользователя = ирОбщий.ИмяФайлаСпискаИнфобазПользователяОСЛкс();
	ЭтаФорма.ФайлСписокОбщийПользователя = ирОбщий.ИмяФайлаОбщегоСпискаИнфобазТекущегоПользователяОСЛкс(УказательОбщийВсехПользователей);
	ЭтаФорма.ФайлСписокОбщийВсехПользователей = ирОбщий.ИмяФайлаОбщегоСпискаИнфобазВсехПользователейОСЛкс(УказательОбщийПользователя);
	ОбновитьСписок();
	Если НачальноеЗначениеВыбора <> Неопределено Тогда
		СтрокаСписка = СписокБазПользователя.Найти(НРег(НачальноеЗначениеВыбора), "КлючСтроки");
		Если СтрокаСписка = Неопределено Тогда
			СтрокаСписка = СписокБазПользователя.Найти(НРег(НачальноеЗначениеВыбора), "НСтрокаСоединения");
		КонецЕсли; 
		Если СтрокаСписка <> Неопределено Тогда
			ЭлементыФормы.СписокБазПользователя.ТекущаяСтрока = СтрокаСписка;
		КонецЕсли; 
	КонецЕсли; 
	
КонецПроцедуры

Процедура ОбновитьСписок()
	
	Если ЭлементыФормы.СписокБазПользователя.ТекущаяСтрока <> Неопределено Тогда
		ИДТекущейБазы = ЭлементыФормы.СписокБазПользователя.ТекущаяСтрока.ID;
	КонецЕсли; 
	СписокБазПользователя.Очистить();
	ТаблицаБазКлиента = ирОбщий.ПолучитьСписокБазПользователяОСЛкс(, Истина, Истина);
	#Если Сервер И Не Сервер Тогда
		ТаблицаБазКлиента = Обработки.ирПлатформа.Создать().СписокБазПользователя;
	#КонецЕсли
	Для Каждого СтрокаТаблицы Из ТаблицаБазКлиента Цикл
		СтрокаТЧ = СписокБазПользователя.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаТЧ, СтрокаТаблицы);
	КонецЦикла;
	СписокБазПользователя.Сортировать("Наименование");
	Если ИДТекущейБазы <> Неопределено Тогда
		ЭлементыФормы.СписокБазПользователя.ТекущаяСтрока = СписокБазПользователя.Найти(ИДТекущейБазы, "ID");
	КонецЕсли; 

КонецПроцедуры

Процедура СписокБазПользователяПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки) Экспорт
	
	#Если Сервер И Не Сервер Тогда
		ДанныеСтроки = СписокБазПользователя.Добавить();
	#КонецЕсли
	ирОбщий.ТабличноеПолеПриВыводеСтрокиЛкс(ЭтаФорма, Элемент, ОформлениеСтроки, ДанныеСтроки);
	Если Ложь
		Или (Истина
			И ЗначениеЗаполнено(ирКэш.КлючБазыВСпискеПользователяИзКоманднойСтрокиЛкс())
			И ДанныеСтроки.КлючСтроки = НРег(ирКэш.КлючБазыВСпискеПользователяИзКоманднойСтрокиЛкс()))
		Или (Истина
			И Не ЗначениеЗаполнено(ирКэш.КлючБазыВСпискеПользователяИзКоманднойСтрокиЛкс())
			И ДанныеСтроки.НСтрокаСоединения = НРег(СтрокаСоединенияИнформационнойБазы()))
	Тогда
		ОформлениеСтроки.ЦветФона = ирОбщий.ЦветФонаАкцентаЛкс(); 
	КонецЕсли; 
	Если ДанныеСтроки.ФайлСписка <> ФайлСписокПользователя Тогда
		ОформлениеСтроки.ЦветТекста = WebЦвета.ТемноФиолетовый; 
	КонецЕсли; 

КонецПроцедуры

Процедура ДействияФормыОбновить(Кнопка)
	
	ОбновитьСписок();
	
КонецПроцедуры

Процедура СписокБазПользователяВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	Если РежимВыбора И ЗначениеЗаполнено(ЭлементыФормы.СписокБазПользователя.ТекущаяСтрока.Connect) Тогда
		Закрыть(ЭлементыФормы.СписокБазПользователя.ТекущаяСтрока);
	КонецЕсли; 
	
КонецПроцедуры

Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник) Экспорт
	
	ирОбщий.Форма_ОбработкаОповещенияЛкс(ЭтаФорма, ИмяСобытия, Параметр, Источник); 

КонецПроцедуры

Процедура ДействияФормыОткрытьКаталогКэша(Кнопка)
	
	Если ЭлементыФормы.СписокБазПользователя.ТекущаяСтрока <> Неопределено Тогда
		ЗапуститьПриложение(ЭлементыФормы.СписокБазПользователя.ТекущаяСтрока.КаталогКэша);
	КонецЕсли; 
	
КонецПроцедуры

Процедура ДействияФормыОчиститьКаталогКэша(Кнопка)
	
	Для Каждого ВыделеннаяСтрока Из ЭлементыФормы.СписокБазПользователя.ВыделенныеСтроки Цикл
		КаталогКэша = ВыделеннаяСтрока.КаталогКэша;
		Попытка
			УдалитьФайлы(КаталогКэша);
		Исключение
			ирОбщий.СообщитьЛкс(ОписаниеОшибки());
		КонецПопытки; 
	КонецЦикла;
	ОбновитьСписок();
	
КонецПроцедуры

Процедура ОткрытьФайлВПроводнике(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ирОбщий.ОткрытьФайлВПроводникеЛкс(Элемент.Значение);
	
КонецПроцедуры

Процедура ДействияФормыИТС(Кнопка)
	
	ЗапуститьПриложение("https://its.1c.ru/db/v8314doc/bookmark/adm/TI000000120");
	
КонецПроцедуры

Процедура КлсКомандаНажатие(Кнопка)
	
	ирОбщий.УниверсальнаяКомандаФормыЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура СписокБазПользователяПриАктивизацииСтроки(Элемент)
	
	ирОбщий.ТабличноеПолеПриАктивизацииСтрокиЛкс(ЭтаФорма, Элемент);

КонецПроцедуры

Процедура ВнешнееСобытие(Источник, Событие, Данные) Экспорт
	
	ирОбщий.Форма_ВнешнееСобытиеЛкс(ЭтаФорма, Источник, Событие, Данные);

КонецПроцедуры

Процедура ТабличноеПолеПриПолученииДанных(Элемент, ОформленияСтрок) Экспорт 
	
	ирОбщий.ТабличноеПолеПриПолученииДанныхЛкс(ЭтаФорма, Элемент, ОформленияСтрок);

КонецПроцедуры

Процедура ДействияФормыЗапуститьКлиентскоеПриложение(Кнопка)
	
	ЗапуститьПриложение1С(Ложь);
	
КонецПроцедуры

Процедура ДействияФормыЗапуститьКонфигуратор(Кнопка)
	
	ЗапуститьПриложение1С(Истина);
	
КонецПроцедуры

Процедура ЗапуститьПриложение1С(РежимКонфигуратора)
	ТекущаяСтрока = ЭлементыФормы.СписокБазПользователя.ТекущаяСтрока;
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	ИмяВСпискеБазПользователя = ТекущаяСтрока.Наименование;
	Если СписокБазПользователя.НайтиСтроки(Новый Структура("Наименование", ИмяВСпискеБазПользователя)).Количество() > 1 Тогда
		ИмяВСпискеБазПользователя = "";
	КонецЕсли; 
	ирОбщий.ЗапуститьПриложение1СЛкс(РежимКонфигуратора, ТекущаяСтрока.Connect, ТекущаяСтрока.Наименование);
КонецПроцедуры

ирОбщий.ИнициироватьФормуЛкс(ЭтаФорма, "Обработка.ирПлатформа.Форма.СписокБазПользователяОС");
