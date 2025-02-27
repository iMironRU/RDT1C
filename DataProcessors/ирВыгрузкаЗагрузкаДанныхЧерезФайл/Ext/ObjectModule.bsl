﻿//ирПортативный Перем ирПортативный Экспорт;
//ирПортативный Перем ирОбщий Экспорт;
//ирПортативный Перем ирСервер Экспорт;
//ирПортативный Перем ирКэш Экспорт;
//ирПортативный Перем ирПривилегированный Экспорт;

Перем мПоследнийПрочитанныйОбъект Экспорт;
Перем мСериализатор Экспорт;

Процедура ОбработатьИсключениеПоОбъекту(ОбъектБД, ОписаниеОшибки, ВывестиСообщение = Истина) Экспорт 
	
	СтрокаРезультата = РезультатОбработки.Добавить();
	СтрокаРезультата.Порядок = СтрокаРезультата.НомерСтроки;
	СтрокаРезультата.ОписаниеОшибки = ОписаниеОшибки;
	Если ТипЗнч(ОбъектБД)= Тип("Строка") Тогда 
		СтрокаРезультата.XML = ОбъектБД;
		СтрокаРезультата.КлючОбъекта = ОбъектБД;
	Иначе
		//СтрокаРезультата.XML = ирОбщий.ОбъектВСтрокуXMLЛкс(ОбъектБД, Ложь); // На перерасчетах ЗаписьXML ошибку выдает. Видимо ошибка платформы.
		СтрокаРезультата.XML = ирОбщий.ОбъектВСтрокуXMLЛкс(ОбъектБД, Истина);
		СтрокаРезультата.КлючОбъекта = ирОбщий.XMLКлючОбъектаБДЛкс(ОбъектБД, Истина);
		Если ТипЗнч(ОбъектБД) = Тип("УдалениеОбъекта") Тогда
			СтрокаРезультата.Таблица = ОбъектБД.Ссылка.Метаданные().ПолноеИмя();
		Иначе
			СтрокаРезультата.Таблица = ОбъектБД.Метаданные().ПолноеИмя();
		КонецЕсли; 
	КонецЕсли;
	Если ВывестиСообщение Тогда
		ирОбщий.СообщитьЛкс("Ошибка обработки объекта """ + СтрокаРезультата.КлючОбъекта + """: " + ОписаниеОшибки, СтатусСообщения.Внимание);
	КонецЕсли; 
	
КонецПроцедуры

Функция ВыполнитьВыгрузку(Параметры) Экспорт 

	РезультатОбработки.Очистить();
	ПараметрыОбработки = Новый Структура;
	ПередВыгрузкойВсех(ПараметрыОбработки);
	КоличествоОбъектов = ирОбщий.КоличествоИзмененийПоУзлуЛкс(УзелВыборкиДанных);
	Индикатор = ирОбщий.ПолучитьИндикаторПроцессаЛкс(КоличествоОбъектов, "Выборка");
	ВыборкаОбъектов = ПланыОбмена.ВыбратьИзменения(УзелВыборкиДанных, УзелВыборкиДанных.НомерОтправленного + 1);
	Пока ВыборкаОбъектов.Следующий() Цикл
		ирОбщий.ОбработатьИндикаторЛкс(Индикатор);
		ОбъектБД = ВыборкаОбъектов.Получить();
		ВыгрузитьОбъектВыборки(ОбъектБД, ПараметрыОбработки);
	КонецЦикла; 
	ирОбщий.ОсвободитьИндикаторПроцессаЛкс(, Истина);
	ДвоичныеДанные = ПослеВыгрузкиВсех(ПараметрыОбработки);
	Результат = Новый Структура;
	Результат.Вставить("ИмяФайла", ИмяФайла);
	Результат.Вставить("ДвоичныеДанные", ДвоичныеДанные);
	ЭтотОбъект.ДвоичныеДанные = Неопределено;
	Возврат Результат;

КонецФункции

Процедура ВыгрузитьОбъектВыборки(Знач ОбъектБД, Знач Параметры) Экспорт 
	
	ВыгрузитьОбъектБД(Параметры.ЗаписьXML, ОбъектБД, Параметры.СчетчикВыгруженныхОбъектов);
	Если Параметры.ВыгружатьДвиженияВместеСДокументами Тогда
		ОбъектМД = ирОбщий.МетаданныеОбъектаБДЛкс(ОбъектБД);
		Если ирОбщий.ЛиКорневойТипДокументаЛкс(ирОбщий.ПервыйФрагментЛкс(ОбъектМД.ПолноеИмя())) Тогда
			ОбъектыМД = ирОбщий.МетаданныеНаборовЗаписейПоРегистраторуЛкс(ОбъектМД);
			Для Каждого МетаРегистр Из ОбъектыМД Цикл
				ПолноеИмяМДРегистра = МетаРегистр.ПолноеИмя();
				ИмяТаблицыБДРегистра = ирКэш.ИмяТаблицыИзМетаданныхЛкс(ПолноеИмяМДРегистра);
				ИмяПоляОтбора = ирОбщий.ИмяПоляОтбораПодчиненногоНабораЗаписейЛкс(ИмяТаблицыБДРегистра);
				НаборЗаписей = ирОбщий.ОбъектБДПоКлючуЛкс(ПолноеИмяМДРегистра, Новый Структура(ИмяПоляОтбора, ОбъектБД.Ссылка));
				ВыгрузитьОбъектБД(Параметры.ЗаписьXML, НаборЗаписей.Методы, Параметры.СчетчикВыгруженныхОбъектов);
			КонецЦикла;
		КонецЕсли; 
	КонецЕсли;

КонецПроцедуры

Процедура ВыгрузитьОбъектБД(Знач ЗаписьXML, Знач ОбъектБД, СчетчикВыгруженныхОбъектов)
	
	Попытка
		Успех = Истина;
		ирОбщий.ОбъектВСтрокуXMLЛкс(ОбъектБД, ИспользоватьXDTO,,, ЗаписьXML, мСериализатор);
	Исключение
		Успех = Ложь;
		ОбработатьИсключениеПоОбъекту(ОбъектБД, ОписаниеОшибки());
		Если Не ПропускатьОшибки Тогда
			ВызватьИсключение;
		КонецЕсли; 
	КонецПопытки;
	Если Успех Тогда
		СчетчикВыгруженныхОбъектов = СчетчикВыгруженныхОбъектов + 1;
	КонецЕсли; 

КонецПроцедуры // ВыполнитьВыгрузку()

Функция ВыполнитьЗагрузку(Параметры) Экспорт 
	
	Если ДвоичныеДанные <> Неопределено Тогда
		ИмяФайлаИсточника = ПолучитьИмяВременногоФайла("zip");
		#Если Сервер И Не Сервер Тогда
			ДвоичныеДанные = Новый ДвоичныеДанные;
		#КонецЕсли
		ДвоичныеДанные.Записать(ИмяФайлаИсточника);
		ЭтотОбъект.ДвоичныеДанные = Неопределено;
	Иначе
		ИмяФайлаИсточника = ИмяФайла;
	КонецЕсли; 
	Попытка
		РезультатОбработки.Очистить();
		ИмяВременногоКаталога = ПолучитьИмяВременногоФайла();
		СоздатьКаталог(ИмяВременногоКаталога);
		ЧтениеZip = Новый ЧтениеZipФайла(ИмяФайлаИсточника);
		ЧтениеZip.ИзвлечьВсе(ИмяВременногоКаталога);
		ФайлИнфо = Новый файл(ИмяВременногоКаталога + "\Info.xml");
		Если Не ФайлИнфо.Существует() Тогда
			Если ИмяФайлаИсточника <> ИмяФайла Тогда
				УдалитьФайлы(ИмяФайлаИсточника);
			КонецЕсли; 
			РезультатМетода = "Неверный формат файла данных!";
			Перейти ~ЗаПопыткой;
		КонецЕсли; 
		ЧтениеXML = Новый ЧтениеXML;
		ЧтениеXML.ОткрытьФайл(ФайлИнфо.ПолноеИмя);
		ИнфоДанных = СериализаторXDTO.ПрочитатьXML(ЧтениеXML);
		#Если Сервер И Не Сервер Тогда
			ИнфоДанных = Новый Структура;
		#КонецЕсли
		ИмяФайлаДанных = ИмяВременногоКаталога + "\Data.xml";
		Если ИнфоДанных.ИспользоватьXDTO Тогда
			Если ИнфоДанных.Свойство("ПредопределенныеДанные") И ирКэш.НомерРежимаСовместимостиЛкс() >= 803003 Тогда
				ПредопределенныеДанные = ИнфоДанных.ПредопределенныеДанные;
				#Если Сервер И Не Сервер Тогда
					ПредопределенныеДанные = Новый ТаблицаЗначений;
				#КонецЕсли
				СоответствиеЗаменыСсылок = ЗагрузитьТаблицуПредопределенных(ПредопределенныеДанные);
				СсылкиДляПодмены = ПредопределенныеДанные.НайтиСтроки(Новый Структура("ТребуетЗамены", Истина));
				ирОбщий.СообщитьЛкс("В файле присутствуют ссылки на " + ПредопределенныеДанные.Количество() + " предопределенных элементов источника. Из них " + СсылкиДляПодмены.Количество() +  " имеют сопоставление (остальные совпадают).");
				Если СсылкиДляПодмены.Количество() > 0 Тогда
					Если СопоставлятьПредопределенные Тогда
						ирОбщий.СообщитьЛкс("При загрузке будет выполнена подмена ссылок сопоставленных предопределенных элементов.");
						ОбработатьСсылкиПредопределенных(ИмяФайлаДанных, СоответствиеЗаменыСсылок);
					Иначе
						ирОбщий.СообщитьЛкс("При загрузке НЕ будет выполнена подмена ссылок сопоставленных предопределенных элементов.");
					КонецЕсли; 
				КонецЕсли; 
			КонецЕсли; 
		Иначе
			Если СопоставлятьПредопределенные Тогда
				ирОбщий.СообщитьЛкс("Файл был выгружен без использования XDTO. Поэтому в нем отсутствует информация для сопоставления предопределенных элементов.");
			КонецЕсли; 
		КонецЕсли; 
		ФайлДанных = Новый файл(ИмяФайлаДанных);
		Если Не ФайлИнфо.Существует() Тогда
			Если ИмяФайлаИсточника <> ИмяФайла Тогда
				УдалитьФайлы(ИмяФайлаИсточника);
			КонецЕсли; 
			РезультатМетода = "Неверный формат файла данных!";
			Перейти ~ЗаПопыткой;
		КонецЕсли; 
		ЧтениеXML = Новый ЧтениеXML;
		ЧтениеXML.ОткрытьФайл(ФайлДанных.ПолноеИмя);
		ЧтениеXML.Прочитать();
		Если ЧтениеXML.ЛокальноеИмя <> "IRData" Тогда
			ЧтениеXML.Закрыть();
			УдалитьФайлы(ИмяВременногоКаталога);
			Если ИмяФайлаИсточника <> ИмяФайла Тогда
				УдалитьФайлы(ИмяФайлаИсточника);
			КонецЕсли; 
			РезультатМетода = "Неверный формат файла данных!";
			Перейти ~ЗаПопыткой;
		КонецЕсли; 
		ЧтениеXML.Прочитать();
		ирОбщий.СообщитьЛкс("В файле данных заявлено " + ИнфоДанных.КоличествоОбъектов + " объектов");
		Индикатор = ирОбщий.ПолучитьИндикаторПроцессаЛкс(ИнфоДанных.КоличествоОбъектов, "Загрузка");
		СчетчикСчитанныхОбъектов = 0;
		Пока Истина Цикл
			ирОбщий.ОбработатьИндикаторЛкс(Индикатор, СчетчикСчитанныхОбъектов);
			Если ИнфоДанных.ИспользоватьXDTO Тогда
				Если Не СериализаторXDTO.ВозможностьЧтенияXML(ЧтениеXML) Тогда
					Прервать;
				КонецЕсли; 
				ОбъектБД = СериализаторXDTO.ПрочитатьXML(ЧтениеXML);
			Иначе 
				Если Не ВозможностьЧтенияXML(ЧтениеXML) Тогда
					Если ЧтениеXML.ТипУзла = ТипУзлаXML.НачалоЭлемента Тогда 
						ОписаниеОшибки = "Неизвестный тип элемента XML: " + ЧтениеXML.Имя;
						Если Не ПропускатьОшибки Тогда 
							ВызватьИсключение ОписаниеОшибки;
						Иначе
							ОбработатьИсключениеПоОбъекту(ЧтениеXML.Имя, ОписаниеОшибки);
							ЧтениеXML.Пропустить();
							Если ЧтениеXML.ТипУзла = ТипУзлаXML.КонецЭлемента Тогда 
								ЧтениеXML.Прочитать();
							КонецЕсли;
							Продолжить;
						КонецЕсли;
					Иначе
						Прервать;
					КонецЕсли;
				КонецЕсли; 
				ОбъектБД = ПрочитатьXML(ЧтениеXML);
			КонецЕсли;
			СчетчикСчитанныхОбъектов = СчетчикСчитанныхОбъектов + 1;
			#Если Сервер И Не Сервер Тогда
				ОбъектБД = Справочники.ирАлгоритмы.СоздатьЭлемент();
			#КонецЕсли
			Попытка
				Отправитель = ОбъектБД.ОбменДанными.Отправитель;
			Исключение
				// Элемент плана обмена в 8.3.5+
				Отправитель = Неопределено;
			КонецПопытки;
			Если Отправитель <> Неопределено Тогда
				ОбъектБД.ОбменДанными.Отправитель = УзелОтправитель;
			КонецЕсли;
			ЭтотОбъект.мПоследнийПрочитанныйОбъект = ОбъектБД;
			Попытка
				ирОбщий.ЗаписатьОбъектЛкс(ОбъектБД,,,, Истина);
				Успех = Истина;
			Исключение
				Успех = Ложь;
				ОбработатьИсключениеПоОбъекту(ОбъектБД, ОписаниеОшибки());
				Если Не ПропускатьОшибки Тогда
					ВызватьИсключение;
				КонецЕсли; 
			КонецПопытки; 
		КонецЦикла;
		ЧтениеXML.Закрыть();
		ирОбщий.ОсвободитьИндикаторПроцессаЛкс(, Истина);
		УдалитьФайлы(ИмяВременногоКаталога);
		ЭтотОбъект.мПоследнийПрочитанныйОбъект = Неопределено;
		Если СчетчикСчитанныхОбъектов <> ИнфоДанных.КоличествоОбъектов Тогда
			Если ИмяФайлаИсточника <> ИмяФайла Тогда
				УдалитьФайлы(ИмяФайлаИсточника);
			КонецЕсли; 
			РезультатМетода = "Считано объектов " + XMLСтрока(СчетчикСчитанныхОбъектов) + " из " + XMLСтрока(ИнфоДанных.КоличествоОбъектов) + " заявленных!";
		КонецЕсли; 
	Исключение
		Если ИмяФайлаИсточника <> ИмяФайла Тогда
			УдалитьФайлы(ИмяФайлаИсточника);
		КонецЕсли; 
		ВызватьИсключение;
	КонецПопытки;
	РезультатМетода = Истина;
~ЗаПопыткой:
	Результат = Новый Структура;
	Результат.Вставить("Результат", РезультатМетода);
	Если Параметры.ЭтаФорма <> Неопределено Тогда
		Результат.Вставить("РезультатОбработки", РезультатОбработки);
	Иначе
		Результат.Вставить("РезультатОбработки", РезультатОбработки.Выгрузить());
	КонецЕсли;
	Возврат Результат;

КонецФункции

Процедура ПередВыгрузкойВсех(Параметры) Экспорт 

	#Если Сервер И Не Сервер Тогда
	    Параметры = Новый Структура;
	#КонецЕсли
	мСериализатор = Неопределено;
	Если ИспользоватьXDTO И ирКэш.НомерРежимаСовместимостиЛкс() >= 803003 Тогда
		ИнициализироватьСериализаторXDTOСАннотациейТипов();
	КонецЕсли; 
	ИмяВременногоКаталога = ПолучитьИмяВременногоФайла();
	СоздатьКаталог(ИмяВременногоКаталога);
	ФайлДанных = Новый файл(ИмяВременногоКаталога + "\Data.xml");
	ЗаписьXML = Новый ЗаписьXML;
	ЗаписьXML.ОткрытьФайл(ФайлДанных.ПолноеИмя, "UTF-8");
	ЗаписьXML.ЗаписатьОбъявлениеXML();
	ЗаписьXML.ЗаписатьНачалоЭлемента("IRData");
	//ЗаписьXML.ЗаписатьНачалоЭлемента("_1CV8DtUD", "http://www.1c.ru/V8/1CV8DtUD/");
	//ЗаписьXML.ЗаписатьСоответствиеПространстваИмен("V8Exch", "http://www.1c.ru/V8/1CV8DtUD/");
	ЗаписьXML.ЗаписатьСоответствиеПространстваИмен("xsi", "http://www.w3.org/2001/XMLSchema-instance");
	ЗаписьXML.ЗаписатьСоответствиеПространстваИмен("core", "http://v8.1c.ru/data");
	ЗаписьXML.ЗаписатьСоответствиеПространстваИмен("v8", "http://v8.1c.ru/8.1/data/enterprise/current-config");
	ЗаписьXML.ЗаписатьСоответствиеПространстваИмен("xs", "http://www.w3.org/2001/XMLSchema");
	СчетчикВыгруженныхОбъектов = 0;
	Если Не Параметры.Свойство("ИмяФайла") Тогда
		Параметры.Вставить("ИмяФайла", ИмяФайла);
	КонецЕсли; 
	Если Не Параметры.Свойство("ЗаписьXML") Тогда
		Параметры.Вставить("ЗаписьXML", ЗаписьXML);
	КонецЕсли; 
	Если Не Параметры.Свойство("ФайлДанных") Тогда
		Параметры.Вставить("ФайлДанных", ФайлДанных);
	КонецЕсли; 
	Если Не Параметры.Свойство("ВыгружатьДвиженияВместеСДокументами") Тогда
		Параметры.Вставить("ВыгружатьДвиженияВместеСДокументами", ВыгружатьДвиженияВместеСДокументами);
	КонецЕсли; 
	Если Не Параметры.Свойство("ИмяВременногоКаталога") Тогда
		Параметры.Вставить("ИмяВременногоКаталога", ИмяВременногоКаталога);
	КонецЕсли; 
	Если Не Параметры.Свойство("СчетчикВыгруженныхОбъектов") Тогда
		Параметры.Вставить("СчетчикВыгруженныхОбъектов", СчетчикВыгруженныхОбъектов);
	КонецЕсли; 
	Если Не Параметры.Свойство("мСериализатор") Тогда
		Параметры.Вставить("мСериализатор", мСериализатор);
	КонецЕсли; 
	#Если Клиент Тогда
		Пустышка = Новый ЗаписьТекста(Параметры.ИмяФайла);
	#КонецЕсли

КонецПроцедуры 

Функция ПослеВыгрузкиВсех(Параметры) Экспорт 

	#Если Сервер И Не Сервер Тогда
	    Параметры = Новый Структура;
	#КонецЕсли
	ИнфоДанных = Новый Структура;
	ИнфоДанных.Вставить("КоличествоОбъектов", Параметры.СчетчикВыгруженныхОбъектов);
	ИнфоДанных.Вставить("ИспользоватьXDTO", ИспользоватьXDTO);
	ирОбщий.СообщитьЛкс("Выгружено объектов " + XMLСтрока(Параметры.СчетчикВыгруженныхОбъектов));
	Параметры.ЗаписьXML.ЗаписатьКонецЭлемента();
	Параметры.ЗаписьXML.Закрыть();
	Если ИспользоватьXDTO И ирКэш.НомерРежимаСовместимостиЛкс() >= 803003 Тогда
		ТаблицаПредопределенных = ИнициализироватьТаблицуПредопределенных();
		#Если Сервер И Не Сервер Тогда
			ТаблицаПредопределенных = Новый ТаблицаЗначений;
		#КонецЕсли
		ОбработатьСсылкиПредопределенных(Параметры.ФайлДанных.ПолноеИмя,, ТаблицаПредопределенных);
		ТаблицаПредопределенных.Сортировать("ИмяТаблицы, ИмяПредопределенныхДанных");
		ТаблицаПредопределенных.Колонки.Удалить("Ссылка");
		ИнфоДанных.Вставить("ПредопределенныеДанные", ТаблицаПредопределенных);
	КонецЕсли; 
	ФайлИнфо = Новый файл(Параметры.ИмяВременногоКаталога + "\Info.xml");
	ЗаписьXML = Новый ЗаписьXML;
	ЗаписьXML.ОткрытьФайл(ФайлИнфо.ПолноеИмя);
	СериализаторXDTO.ЗаписатьXML(ЗаписьXML, ИнфоДанных);
	ЗаписьXML.Закрыть();
	#Если Клиент Тогда
		ИмяФайлаРезультата = Параметры.ИмяФайла;
	#Иначе
		ИмяФайлаРезультата = ПолучитьИмяВременногоФайла("zip");
	#КонецЕсли 
	ЗаписьZIP = Новый ЗаписьZipФайла(ИмяФайлаРезультата);
	ЗаписьZIP.Добавить(Параметры.ФайлДанных.ПолноеИмя);
	ЗаписьZIP.Добавить(ФайлИнфо.ПолноеИмя);
	ЗаписьZIP.Записать();
	УдалитьФайлы(Параметры.ИмяВременногоКаталога);
	ДвоичныеДанные = Новый ДвоичныеДанные(ИмяФайлаРезультата);
	УдалитьФайлы(ИмяФайлаРезультата);
	Возврат ДвоичныеДанные;

КонецФункции

// Возвращает СериализаторXDTO с аннотацией типов.
//
// Возвращаемое значение:
//	СериализаторXDTO - сериализатор.
//
Процедура ИнициализироватьСериализаторXDTOСАннотациейТипов()
	
	ТипыСАннотациейСсылок = ПредопределенныеТипыПриВыгрузке();
	Если ТипыСАннотациейСсылок.Количество() > 0 Тогда
		Фабрика = ПолучитьФабрикуСУказаниемТипов(ТипыСАннотациейСсылок);
		мСериализатор = Новый СериализаторXDTO(Фабрика);
	КонецЕсли;
	
КонецПроцедуры

Функция ПредопределенныеТипыПриВыгрузке()
	
	Типы = Новый Массив;
	Для Каждого ОбъектМетаданных Из Метаданные.Справочники Цикл
		Типы.Добавить(ОбъектМетаданных);
	КонецЦикла;
	Для Каждого ОбъектМетаданных Из Метаданные.ПланыСчетов Цикл
		Типы.Добавить(ОбъектМетаданных);
	КонецЦикла;
	Для Каждого ОбъектМетаданных Из Метаданные.ПланыВидовХарактеристик Цикл
		Типы.Добавить(ОбъектМетаданных);
	КонецЦикла;
	Для Каждого ОбъектМетаданных Из Метаданные.ПланыВидовРасчета Цикл
		Типы.Добавить(ОбъектМетаданных);
	КонецЦикла;
	Возврат Типы;
	
КонецФункции

// Возвращает фабрику с указанием типов.
//
// Параметры:
//	Типы - ФиксированныйМассив (Метаданные) - массив типов.
//
// Возвращаемое значение:
//	ФабрикаXDTO - фабрика.
//
Функция ПолучитьФабрикуСУказаниемТипов(Знач Типы)
	
	НаборСхем = ФабрикаXDTO.ЭкспортСхемыXML("http://v8.1c.ru/8.1/data/enterprise/current-config");
	Схема = НаборСхем[0];
	Схема.ОбновитьЭлементDOM();
	УказанныеТипы = Новый Соответствие;
	Для каждого Тип Из Типы Цикл
		УказанныеТипы.Вставить(ирОбщий.XMLТипСсылкиЛкс(Тип), Истина);
	КонецЦикла;
	ПространствоИмен = Новый Соответствие;
	ПространствоИмен.Вставить("xs", "http://www.w3.org/2001/XMLSchema");
	РазыменовательПространствИменDOM = Новый РазыменовательПространствИменDOM(ПространствоИмен);
	ТекстXPath = "/xs:schema/xs:complexType/xs:sequence/xs:element[starts-with(@type,'tns:')]";
	Запрос = Схема.ДокументDOM.СоздатьВыражениеXPath(ТекстXPath, РазыменовательПространствИменDOM);
	Результат = Запрос.Вычислить(Схема.ДокументDOM);
	Пока Истина Цикл
		УзелПоля = Результат.ПолучитьСледующий();
		Если УзелПоля = Неопределено Тогда
			Прервать;
		КонецЕсли;
		АтрибутТип = УзелПоля.Атрибуты.ПолучитьИменованныйЭлемент("type");
		ТипБезNSПрефикса = Сред(АтрибутТип.ТекстовоеСодержимое, СтрДлина("tns:") + 1);
		Если УказанныеТипы.Получить(ТипБезNSПрефикса) = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		УзелПоля.УстановитьАтрибут("nillable", "true");
		УзелПоля.УдалитьАтрибут("type");
	КонецЦикла;
	ЗаписьXML = Новый ЗаписьXML;
	ИмяФайлаСхемы = ПолучитьИмяВременногоФайла("xsd");
	ЗаписьXML.ОткрытьФайл(ИмяФайлаСхемы);
	ЗаписьDOM = Новый ЗаписьDOM;
	ЗаписьDOM.Записать(Схема.ДокументDOM, ЗаписьXML);
	ЗаписьXML.Закрыть();
	Фабрика = СоздатьФабрикуXDTO(ИмяФайлаСхемы);
	Попытка
		УдалитьФайлы(ИмяФайлаСхемы);
	Исключение
	КонецПопытки;
	Возврат Фабрика;
	
КонецФункции

Функция ИнициализироватьТаблицуПредопределенных()
	
	ТаблицаПредопределенных = Новый ТаблицаЗначений;
	ТаблицаПредопределенных.Колонки.Добавить("ИмяТаблицы");
	ТаблицаПредопределенных.Колонки.Добавить("Ссылка");
	ТаблицаПредопределенных.Колонки.Добавить("УИД", Новый ОписаниеТипов("Строка"));
	ТаблицаПредопределенных.Колонки.Добавить("ИмяПредопределенныхДанных");
	ТаблицаПредопределенных.Индексы.Добавить("Ссылка");
	Возврат ТаблицаПредопределенных;
	
КонецФункции

Функция ЗагрузитьТаблицуПредопределенных(ТаблицаПредопределенных)
	
	#Если Сервер И Не Сервер Тогда
		ТаблицаПредопределенных = Новый ТаблицаЗначений;
	#КонецЕсли
	СоответствиеЗаменыСсылок = Новый Соответствие;
	ИменаТаблицСсылок = ТаблицаПредопределенных.Скопировать(, "ИмяТаблицы");
	ИменаТаблицСсылок.Свернуть("ИмяТаблицы");
	ИменаТаблицСсылок = ИменаТаблицСсылок.ВыгрузитьКолонку(0);
	ТаблицаПредопределенных.Колонки.Добавить("ТребуетЗамены", Новый ОписаниеТипов("Булево"));
	Для Каждого ИмяТаблицы Из ИменаТаблицСсылок Цикл
		СтрокиСсылок = ТаблицаПредопределенных.НайтиСтроки(Новый Структура("ИмяТаблицы", ИмяТаблицы));
		ИменаПредопределенныхДанных = ТаблицаПредопределенных.Скопировать(СтрокиСсылок, "ИмяПредопределенныхДанных").ВыгрузитьКолонку(0);
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ Т.Ссылка, Т.ИмяПредопределенныхДанных ИЗ " + ИмяТаблицы + " КАК Т ГДЕ Т.ИмяПредопределенныхДанных в (&ИменаПредопределенныхДанных) И Т.Предопределенный";
		Запрос.УстановитьПараметр("ИменаПредопределенныхДанных", ИменаПредопределенныхДанных);
		ПредопределенныеСсылки = Запрос.Выполнить().Выгрузить();
		Для Каждого СтрокаСсылки Из СтрокиСсылок Цикл
			СтрокаПредопределенного = ПредопределенныеСсылки.Найти(СтрокаСсылки.ИмяПредопределенныхДанных, "ИмяПредопределенныхДанных");
			Если СтрокаПредопределенного = Неопределено Тогда
				Продолжить;
			КонецЕсли; 
			УИДНовый = "" + СтрокаПредопределенного.Ссылка.УникальныйИдентификатор();
			Если СтрокаСсылки.УИД <> УИДНовый Тогда
				СтрокаСсылки.ТребуетЗамены = Истина;
				XMLТип = ирОбщий.XMLТипСсылкиЛкс(СтрокаПредопределенного.Ссылка);
				СоответствиеТипа = СоответствиеЗаменыСсылок.Получить(XMLТип);
				Если СоответствиеТипа = Неопределено Тогда
					СоответствиеТипа = Новый Соответствие;
					СоответствиеТипа.Вставить(СтрокаСсылки.УИД, УИДНовый);
					СоответствиеЗаменыСсылок.Вставить(XMLТип, СоответствиеТипа);
				Иначе
					СоответствиеТипа.Вставить(СтрокаСсылки.УИД, УИДНовый);
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	Возврат СоответствиеЗаменыСсылок;
	
КонецФункции

Процедура ОбработатьСсылкиПредопределенных(ИмяФайла, СоответствиеЗаменыСсылок = Неопределено, ТаблицаПредопределенных = Неопределено)
	
	#Если Сервер И Не Сервер Тогда
		ТаблицаПредопределенных = Новый ТаблицаЗначений;
		СоответствиеЗаменыСсылок = Новый Соответствие;
	#КонецЕсли
	ПотокЧтения = Новый ЧтениеТекста(ИмяФайла);
	РежимЗаполненияТаблицы = СоответствиеЗаменыСсылок = Неопределено;
	Если Не РежимЗаполненияТаблицы Тогда
		ВременныйФайл = ПолучитьИмяВременногоФайла("xml");
		ПотокЗаписи = Новый ЗаписьТекста(ВременныйФайл);
	КонецЕсли; 
	НачалоТипа = "xsi:type=""v8:";
	ДлинаНачалаТипа = СтрДлина(НачалоТипа);
	КонецТипа = """>";
	ДлинаКонцаТипа = СтрДлина(КонецТипа);
	ИсходнаяСтрока = ПотокЧтения.ПрочитатьСтроку();
	Пока ИсходнаяСтрока <> Неопределено Цикл
		ОстатокСтроки = Неопределено;
		ТекущаяПозиция = 1;
		ПозицияТипа = Найти(ИсходнаяСтрока, НачалоТипа);
		Пока ПозицияТипа > 0 Цикл
			Если Не РежимЗаполненияТаблицы Тогда
				ПотокЗаписи.Записать(Сред(ИсходнаяСтрока, ТекущаяПозиция, ПозицияТипа - 1 + ДлинаНачалаТипа));
			КонецЕсли; 
			ОстатокСтроки = Сред(ИсходнаяСтрока, ТекущаяПозиция + ПозицияТипа + ДлинаНачалаТипа - 1);
			ТекущаяПозиция = ТекущаяПозиция + ПозицияТипа + ДлинаНачалаТипа - 1;
			ПозицияКонцаТипа = Найти(ОстатокСтроки, КонецТипа);
			Если ПозицияКонцаТипа = 0 Тогда
				Прервать;
			КонецЕсли;
			ИмяТипа = Лев(ОстатокСтроки, ПозицияКонцаТипа - 1);
			Если Не ирОбщий.ЛиКорневойТипОбъектаСПредопределеннымЛкс(ирОбщий.КорневойТипКонфигурацииЛкс(Тип(ИмяТипа))) Тогда
				Прервать;
			КонецЕсли; 
			ИсходнаяСсылкаXML = Сред(ОстатокСтроки, ПозицияКонцаТипа + ДлинаКонцаТипа, 36);
			Если РежимЗаполненияТаблицы Тогда
				Ссылка = СериализаторXDTO.XMLЗначение(Тип(ИмяТипа), ИсходнаяСсылкаXML);
				Если ЗначениеЗаполнено(Ссылка) И ТаблицаПредопределенных.Найти(Ссылка, "Ссылка") = Неопределено Тогда
					СтрокаПредопределенного = ТаблицаПредопределенных.Добавить();
					СтрокаПредопределенного.ИмяТаблицы = Ссылка.Метаданные().ПолноеИмя();
					СтрокаПредопределенного.Ссылка = Ссылка;
				КонецЕсли; 
			Иначе
				СоответствиеЗамены = СоответствиеЗаменыСсылок.Получить(ИмяТипа);
				Если СоответствиеЗамены = Неопределено Тогда
					ПозицияТипа = Найти(ОстатокСтроки, НачалоТипа);
					Продолжить;
				КонецЕсли;
				ПотокЗаписи.Записать(ИмяТипа);
				ПотокЗаписи.Записать(КонецТипа);
				НайденнаяСсылкаXML = СоответствиеЗамены.Получить(ИсходнаяСсылкаXML);
				Если НайденнаяСсылкаXML = Неопределено Тогда
					ПотокЗаписи.Записать(ИсходнаяСсылкаXML);
				Иначе
					ПотокЗаписи.Записать(НайденнаяСсылкаXML);
				КонецЕсли;
			КонецЕсли; 
			ТекущаяПозиция = ТекущаяПозиция + ПозицияКонцаТипа - 1 + ДлинаКонцаТипа + 36;
			ОстатокСтроки = Сред(ОстатокСтроки, ПозицияКонцаТипа + ДлинаКонцаТипа + 36);
			ПозицияТипа = Найти(ОстатокСтроки, НачалоТипа);
		КонецЦикла;
		Если Не РежимЗаполненияТаблицы Тогда
			Если ОстатокСтроки <> Неопределено Тогда
				ПотокЗаписи.ЗаписатьСтроку(ОстатокСтроки);
			Иначе
				ПотокЗаписи.ЗаписатьСтроку(ИсходнаяСтрока);
			КонецЕсли;
		КонецЕсли; 
		ИсходнаяСтрока = ПотокЧтения.ПрочитатьСтроку();
	КонецЦикла;
	ПотокЧтения.Закрыть();
	Если РежимЗаполненияТаблицы Тогда
		ИменаТаблицСсылок = ТаблицаПредопределенных.Скопировать(, "ИмяТаблицы");
		ИменаТаблицСсылок.Свернуть("ИмяТаблицы");
		ИменаТаблицСсылок = ИменаТаблицСсылок.ВыгрузитьКолонку(0);
		Для Каждого ИмяТаблицы Из ИменаТаблицСсылок Цикл
			СтрокиСсылок = ТаблицаПредопределенных.НайтиСтроки(Новый Структура("ИмяТаблицы", ИмяТаблицы));
			СсылкиВТаблице = ТаблицаПредопределенных.Скопировать(СтрокиСсылок, "Ссылка").ВыгрузитьКолонку(0);
			Запрос = Новый Запрос;
			Запрос.Текст = "ВЫБРАТЬ Т.Ссылка, Т.ИмяПредопределенныхДанных ИЗ " + ИмяТаблицы + " КАК Т ГДЕ Т.Ссылка в (&Ссылки) И Т.Предопределенный";
			Запрос.УстановитьПараметр("Ссылки", СсылкиВТаблице);
			ПредопределенныеСсылки = Запрос.Выполнить().Выгрузить();
			Для Каждого СтрокаСсылки Из СтрокиСсылок Цикл
				СтрокаПредопределенного = ПредопределенныеСсылки.Найти(СтрокаСсылки.Ссылка, "Ссылка");
				Если СтрокаПредопределенного = Неопределено Тогда
					ТаблицаПредопределенных.Удалить(СтрокаСсылки);
				Иначе
					СтрокаСсылки.ИмяПредопределенныхДанных = СтрокаПредопределенного.ИмяПредопределенныхДанных;
					СтрокаСсылки.УИД = СтрокаСсылки.Ссылка.УникальныйИдентификатор();
				КонецЕсли; 
			КонецЦикла;
		КонецЦикла;
	Иначе
		ПотокЗаписи.Закрыть();
		ИмяФайла = ВременныйФайл;
	КонецЕсли; 
	
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

ЭтотОбъект.ВыполнятьНаСервере = ирОбщий.ПолучитьРежимОбъектыНаСервереПоУмолчаниюЛкс(Ложь);
ЭтотОбъект.ИспользоватьXDTO = Истина;
