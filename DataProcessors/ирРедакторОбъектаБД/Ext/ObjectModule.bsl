﻿//ирПортативный Перем ирПортативный Экспорт;
//ирПортативный Перем ирОбщий Экспорт;
//ирПортативный Перем ирСервер Экспорт;
//ирПортативный Перем ирКэш Экспорт;
//ирПортативный Перем ирПривилегированный Экспорт;

// Заново заполняет табличное поле НайденныйСсылки.
//
// Параметры:
//  Нет.
//
Процедура ОбновитьНайденныеСсылки(МассивСсылок) Экспорт

	тзНайденныеСсылки = Новый ТаблицаЗначений;
	#Если Клиент Тогда
	Состояние("Поиск ссылок...");
	#КонецЕсли 
	ирПривилегированный.НайтиПоСсылкамЛкс(МассивСсылок, тзНайденныеСсылки);
	#Если Клиент Тогда
	Состояние("");
	#КонецЕсли 
	СсылкиНаОбъект.Очистить();
	Для Каждого Строка Из тзНайденныеСсылки Цикл
		СтрокаТЧ = СсылкиНаОбъект.Добавить();
		НайденнаяСсылка = ЗначениеИзСтрокиВнутр(Строка.Данные);
		СтрокаТЧ.Метаданные = Строка.Метаданные;
		КорневойТипСсылки = ирОбщий.ПолучитьПервыйФрагментЛкс(СтрокаТЧ.Метаданные);
		Если КорневойТипСсылки = "РегистрСведений" Тогда 
			СтрокаТЧ.Данные = Строка.Данные;
		Иначе
			СтрокаТЧ.Данные = НайденнаяСсылка;
		КонецЕсли;
		Если НайденнаяСсылка = Неопределено Тогда
			НайденнаяСсылка = СтрокаТЧ.Метаданные;
		КонецЕсли; 
		МетаданныеСсылки = Метаданные.НайтиПоПолномуИмени(СтрокаТЧ.Метаданные);
		СтрокаТЧ.ТипДанных = МетаданныеСсылки.Представление();
		СтрокаТЧ.Ссылка = Строка.Ссылка;
		СтрокаТЧ.ТипМетаданных = ирОбщий.ПолучитьПервыйФрагментЛкс(СтрокаТЧ.Метаданные);
		СтрокаТЧ.Пометка = 1;
	КонецЦикла;
	
КонецПроцедуры // ОбновитьНайденныеСсылки()

Процедура ОткрытьСсылающийсяОбъектВРедактореОбъектаБД(ТекущаяСтрока) Экспорт
	
	Если ирОбщий.ЛиКорневойТипСсылочногоОбъектаБДЛкс(ТекущаяСтрока.ТипМетаданных) Тогда
		КлючОбъекта = ТекущаяСтрока.Данные;
	ИначеЕсли ирОбщий.ЛиКорневойТипКонстантыЛкс(ТекущаяСтрока.ТипМетаданных) Тогда
		КлючОбъекта = Новый (СтрЗаменить(ТекущаяСтрока.Метаданные, ".", "МенеджерЗначения."));
	Иначе // Регистр сведений
		КлючОбъекта = ирОбщий.ПолучитьНаборЗаписейПоКлючуЛкс(ТекущаяСтрока.Метаданные, ЗначениеИзСтрокиВнутр(ТекущаяСтрока.Данные));
	КонецЕсли; 
	//ирОбщий.ОткрытьСсылкуВРедактореОбъектаБДЛкс(КлючОбъекта, Объект);
	ирОбщий.ОткрытьСсылкуВРедактореОбъектаБДЛкс(КлючОбъекта, ТекущаяСтрока.Ссылка);

КонецПроцедуры

//ирПортативный лФайл = Новый Файл(ИспользуемоеИмяФайла);
//ирПортативный ПолноеИмяФайлаБазовогоМодуля = Лев(лФайл.Путь, СтрДлина(лФайл.Путь) - СтрДлина("Модули\")) + "ирПортативный.epf";
//ирПортативный #Если Клиент Тогда
//ирПортативный 	Контейнер = Новый Структура();
//ирПортативный 	Оповестить("ирПолучитьБазовуюФорму", Контейнер);
//ирПортативный 	Если Не Контейнер.Свойство("ирПортативный", ирПортативный) Тогда
//ирПортативный 		ирПортативный = ВнешниеОбработки.ПолучитьФорму(ПолноеИмяФайлаБазовогоМодуля);
//ирПортативный 		ирПортативный.Открыть();
//ирПортативный 	КонецЕсли; 
//ирПортативный #Иначе
//ирПортативный 	ирПортативный = ВнешниеОбработки.Создать(ПолноеИмяФайлаБазовогоМодуля, Ложь); // Это будет второй экземпляр объекта
//ирПортативный #КонецЕсли
//ирПортативный ирОбщий = ирПортативный.ПолучитьОбщийМодульЛкс("ирОбщий");
//ирПортативный ирКэш = ирПортативный.ПолучитьОбщийМодульЛкс("ирКэш");
//ирПортативный ирСервер = ирПортативный.ПолучитьОбщийМодульЛкс("ирСервер");
//ирПортативный ирПривилегированный = ирПортативный.ПолучитьОбщийМодульЛкс("ирПривилегированный");

ЭтотОбъект.ПараметрПрочитатьОбъект = Истина;
ЭтотОбъект.ЗаписьНаСервере = ирОбщий.ПолучитьРежимЗаписиНаСервереПоУмолчаниюЛкс();
ЭтотОбъект.СвязиИПараметрыВыбора = Истина;