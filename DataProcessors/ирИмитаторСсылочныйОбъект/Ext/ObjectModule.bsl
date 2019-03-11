﻿//Перем ДополнительныеСвойства Экспорт;
//Перем ОбменДанными Экспорт;
Перем _СчитанныйСнимок Экспорт;
Перем _Тип Экспорт;
Перем _СсылкаНового Экспорт;

Процедура Конструктор(Объект) Экспорт 
	
	ЭтотОбъект.ДополнительныеСвойства = Объект.ДополнительныеСвойства;
	ЭтотОбъект.ОбменДанными = ирОбщий.СтруктураОбменаДаннымиОбъектаЛкс(Объект);
	ЭтотОбъект.Ссылка = Объект.Ссылка;
	ЭтотОбъект._Тип = ТипЗнч(Объект);
	Если Объект.Ссылка.Пустая() Тогда
		ЭтотОбъект._СсылкаНового = Объект.ПолучитьСсылкуНового();
	КонецЕсли; 
	
	ОбъектМД = Объект.Метаданные();
	ЕстьЭтоГруппа = ирОбщий.ЛиМетаданныеОбъектаСГруппамиЛкс(ОбъектМД);
	ПоляТаблицыБД = ирОбщий.ПолучитьПоляТаблицыМДЛкс(ОбъектМД,,,, Ложь);
	Данные = Новый Структура;
	ПоляШапки = Новый Массив;

	// Пассивный оригинал расположенного ниже однострочного кода. Выполняйте изменения синхронно в обоих вариантах.
	#Если Сервер И Не Сервер Тогда
	Для Каждого СтрокаПоля Из ПоляТаблицыБД Цикл
		Если Истина
			И ЕстьЭтоГруппа 
			И СтрокаПоля.Метаданные <> Неопределено 
			И ОбъектМД.Реквизиты.Найти(СтрокаПоля.Метаданные.Имя) <> Неопределено
		Тогда 
			МетаРеквизит = СтрокаПоля.Метаданные;
			Если Ложь
				Или (Истина
					И Не Объект.ЭтоГруппа
					И МетаРеквизит.Использование = Метаданные.СвойстваОбъектов.ИспользованиеРеквизита.ДляГруппы)
				Или (Истина
					И Объект.ЭтоГруппа
					И МетаРеквизит.Использование = Метаданные.СвойстваОбъектов.ИспользованиеРеквизита.ДляЭлемента)
			Тогда 
				Продолжить;
			КонецЕсли; 
		КонецЕсли; 
		Данные.Вставить(СтрокаПоля.Имя);
		Если СтрокаПоля.ТипЗначения.СодержитТип(Тип("ТаблицаЗначений")) Тогда
			Данные.Вставить(СтрокаПоля.Имя, Объект[СтрокаПоля.Имя].Выгрузить());
		Иначе
			ПоляШапки.Добавить(СтрокаПоля.Имя);
		КонецЕсли; 
	КонецЦикла; 
	#КонецЕсли
	// Однострочный код использован для ускорения. Выше расположен оригинал. Выполняйте изменения синхронно в обоих вариантах. Преобразовано консолью кода из подсистемы "Инструменты разработчика" (http://devtool1c.ucoz.ru)
	Для Каждого СтрокаПоля Из ПоляТаблицыБД Цикл  		Если Истина  			И ЕстьЭтоГруппа  			И СтрокаПоля.Метаданные <> Неопределено  			И ОбъектМД.Реквизиты.Найти(СтрокаПоля.Метаданные.Имя) <> Неопределено  		Тогда  			МетаРеквизит = СтрокаПоля.Метаданные;  			Если Ложь  				Или (Истина  					И Не Объект.ЭтоГруппа  					И МетаРеквизит.Использование = Метаданные.СвойстваОбъектов.ИспользованиеРеквизита.ДляГруппы)  				Или (Истина  					И Объект.ЭтоГруппа  					И МетаРеквизит.Использование = Метаданные.СвойстваОбъектов.ИспользованиеРеквизита.ДляЭлемента)  			Тогда  				Продолжить;  			КонецЕсли;  		КонецЕсли;  		Данные.Вставить(СтрокаПоля.Имя);  		Если СтрокаПоля.ТипЗначения.СодержитТип(Тип("ТаблицаЗначений")) Тогда  			Данные.Вставить(СтрокаПоля.Имя, Объект[СтрокаПоля.Имя].Выгрузить());  		Иначе  			ПоляШапки.Добавить(СтрокаПоля.Имя);  		КонецЕсли;  	КонецЦикла;  

	ЗаполнитьЗначенияСвойств(Данные, Объект, ирОбщий.ПолучитьСтрокуСРазделителемИзМассиваЛкс(ПоляШапки)); 
	ЭтотОбъект.Данные = Данные;
	
	Если Не Объект.Модифицированность() И Не Объект.Ссылка.Пустая() Тогда
		ЭтотОбъект._СчитанныйСнимок = Снимок(Истина);
	Иначе
		ЭтотОбъект._СчитанныйСнимок = ""; // Для экономии размера снимка
	КонецЕсли; 

КонецПроцедуры

Функция Снимок(ТолькоДанные = Ложь, РезультатВВидеСтроки = Истина) Экспорт 
	
	СтруктураОбъекта = Новый Структура;
	Если Не ТолькоДанные Тогда
		СтруктураОбъекта.Вставить("ОбменДанными", ОбменДанными);
		СтруктураОбъекта.Вставить("ДополнительныеСвойства", ДополнительныеСвойства);
		СтруктураОбъекта.Вставить("_СчитанныйСнимок", _СчитанныйСнимок);
	КонецЕсли; 
	СтруктураОбъекта.Вставить("_Тип", _Тип);
	СтруктураОбъекта.Вставить("Данные", Данные);
	СтруктураОбъекта.Вставить("Ссылка", Ссылка);
	СтруктураОбъекта.Вставить("_СсылкаНового", _СсылкаНового);
	Если РезультатВВидеСтроки Тогда
	    ЗаписьXML = Новый ЗаписьXML;
		ЗаписьXML.УстановитьСтроку();
		Попытка
			СериализаторXDTO.ЗаписатьXML(ЗаписьXML, СтруктураОбъекта, НазначениеТипаXML.Явное);
		Исключение
			Если Не ТолькоДанные Тогда
				ирОбщий.УдалитьМутабельныеЗначенияВСтруктуреЛкс(СтруктураОбъекта.ДополнительныеСвойства);
			КонецЕсли; 
			СериализаторXDTO.ЗаписатьXML(ЗаписьXML, СтруктураОбъекта, НазначениеТипаXML.Явное);
		КонецПопытки;
		Результат = ЗаписьXML.Закрыть();
	Иначе
		Если Не ТолькоДанные Тогда
			ирОбщий.УдалитьМутабельныеЗначенияВСтруктуреЛкс(СтруктураОбъекта.ДополнительныеСвойства);
		КонецЕсли; 
		Результат = СтруктураОбъекта;
	КонецЕсли; 
	Возврат Результат;
	
КонецФункции

Процедура ЗагрузитьСнимок(Снимок, ТолькоДанные = Ложь) Экспорт 
	
	Если ТолькоДанные Тогда
		СтрокаЗагружаемыхСвойств = "_Тип, Ссылка";
	Иначе
		СтрокаЗагружаемыхСвойств = "_Тип, Ссылка, ОбменДанными, ДополнительныеСвойства, _СсылкаНового, _СчитанныйСнимок";
	КонецЕсли;
	Если ТипЗнч(Снимок) = Тип("Строка") Тогда
	    ЧтениеXML = Новый ЧтениеXML;
		ЧтениеXML.УстановитьСтроку(Снимок);
		СтруктураОбъекта = СериализаторXDTO.ПрочитатьXML(ЧтениеXML);
		ЧтениеXML.Закрыть();
	Иначе
		СтруктураОбъекта = Снимок;
	КонецЕсли; 
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, СтруктураОбъекта, СтрокаЗагружаемыхСвойств); 
	Если Данные <> Неопределено Тогда
		Данные.Очистить();
		ирОбщий.СкопироватьУниверсальнуюКоллекциюЛкс(СтруктураОбъекта.Данные, Данные);
	Иначе
		ЭтотОбъект.Данные = СтруктураОбъекта.Данные;
	КонецЕсли; 
	
КонецПроцедуры

Функция КлючОбъекта()
	
	Результат = Ссылка;
	Если Истина
		И Не ЗначениеЗаполнено(Результат) 
		И Данные.Свойство("ЭтоГруппа")
		И Данные.ЭтоГруппа
	Тогда
		Результат = Истина;
	КонецЕсли; 
	Возврат Результат;
	
КонецФункции

Функция ОбъектБД(ВосстановитьДанные = Истина) Экспорт 
	
	КлючОбъекта = КлючОбъекта();
	ПолноеИмяТаблицы = ирОбщий.ПолучитьИмяТаблицыИзМетаданныхЛкс(Метаданные.НайтиПоТипу(_Тип));

	//Если ВосстановитьДанные И ЗначениеЗаполнено(Ссылка) Тогда
	//	// Здесь происходит обращение к БД через ПрочитатьXML() и оно похоже дольше чем ПолучитьОбъект() 
	//	Результат = ирОбщий.СоздатьСсылочныйОбъектПоМетаданнымЛкс(Метаданные.НайтиПоТипу(_Тип),, Ссылка.УникальныйИдентификатор());
	//Иначе
		// Здесь происходит чтение из БД через ПолучитьОбъект()
		Результат = ирОбщий.ОбъектБДПоКлючуЛкс(ПолноеИмяТаблицы, КлючОбъекта,, Ложь, Ложь).Данные;
	//КонецЕсли; 

	Если ДополнительныеСвойства <> Неопределено Тогда
		ирОбщий.СкопироватьУниверсальнуюКоллекциюЛкс(ДополнительныеСвойства, Результат.ДополнительныеСвойства);
	КонецЕсли; 
	ирОбщий.ВосстановитьСтруктуруОбменаДаннымиОбъектаЛкс(Результат, ОбменДанными);
	Если ВосстановитьДанные Тогда
		Если Результат.Ссылка.Пустая() И ЗначениеЗаполнено(_СсылкаНового)  Тогда
			Результат.УстановитьСсылкуНового(_СсылкаНового);
			//Результат.ДополнительныеСвойства.Вставить("СсылкаНового", Ссылка); // Для обхода кривого кода в конфигурациях фиры 1С https://www.forum.mista.ru/topic.php?id=826103#58
		КонецЕсли; 
		ЗаполнитьЗначенияСвойств(Результат, Данные); 
		СтруктураТЧ = ирОбщий.ПолучитьТабличныеЧастиОбъектаЛкс(Результат);
		Для Каждого КлючИЗначение Из СтруктураТЧ Цикл
			Результат[КлючИЗначение.Ключ].Загрузить(Данные[КлючИЗначение.Ключ]);
		КонецЦикла;
	КонецЕсли; 
	Возврат Результат;
	
КонецФункции

Функция ПолучитьСсылкуНового() Экспорт 
	Возврат _СсылкаНового;
КонецФункции

Функция Модифицированность() Экспорт 
	
	Результат = _СчитанныйСнимок <> Снимок(Истина);
	Возврат Результат;
	
КонецФункции

Функция ЭтоНовый() Экспорт 
	
	Результат = Данные[ирОбщий.ПеревестиСтроку("Ссылка")].Пустая();
	Возврат Результат;
	
КонецФункции

Функция ПолучитьКартуМаршрута() Экспорт 
	
	ОбъектБД = ОбъектБД();
	Результат = ОбъектБД.ПолучитьКартуМаршрута();
	Возврат Результат;
	
КонецФункции

Процедура Прочитать(НаСервере = Неопределено) Экспорт 
	
	Если НаСервере = Неопределено Тогда
		НаСервере = ирКэш.ПараметрыЗаписиОбъектовЛкс().ОбъектыНаСервере;
	КонецЕсли; 
	Если НаСервере Тогда
		Снимок = Снимок(Истина, Ложь);
		ирСервер.ПрочитатьОбъектЧерезИмитаторЛкс(Снимок, ТипЗнч(ЭтотОбъект));
		ЗагрузитьСнимок(Снимок, Истина);
		//ЭтотОбъект._СчитанныйСнимок = Снимок;
		ЭтотОбъект._СчитанныйСнимок = Снимок(Истина);
	Иначе
		ОбъектБД = ОбъектБД();
		ОбъектБД.Прочитать();
		Конструктор(ОбъектБД);
	КонецЕсли; 
	
КонецПроцедуры

Функция Скопировать(НаСервере = Неопределено) Экспорт 
	
	Если НаСервере = Неопределено Тогда
		НаСервере = ирКэш.ПараметрыЗаписиОбъектовЛкс().ОбъектыНаСервере;
	КонецЕсли; 
	Если НаСервере Тогда
		Снимок = Снимок();
		Снимок = ирСервер.СкопироватьОбъектЧерезИмитаторЛкс(Снимок, ТипЗнч(ЭтотОбъект));
		ИмитаторКопия = Новый (ТипЗнч(ЭтотОбъект));
		ИмитаторКопия.ЗагрузитьСнимок(Снимок);
		Результат = Новый Структура;
		Результат.Вставить("Методы", ИмитаторКопия);
		Результат.Вставить("Данные", ИмитаторКопия.Данные);
	Иначе
		ОбъектБД = ОбъектБД();
		ОбъектКопия = ОбъектБД.Скопировать();
		ИмитаторКопия = Новый (ТипЗнч(ЭтотОбъект));
		ИмитаторКопия.Конструктор(ОбъектКопия);
		Результат = ИмитаторКопия;
	КонецЕсли; 
	Возврат Результат;
	
КонецФункции

Функция ДанныеВСтрокуXMLЧерезXDTO(Знач ИспользоватьXDTO = Истина, ВызыватьИсключение = Истина) Экспорт
	
	#Если Не Сервер Тогда
		Снимок = Снимок(Истина);
		Результат = ирСервер.ОбъектБДИзИмитатораВСтрокуXMLЛкс(Снимок, ТипЗнч(ЭтотОбъект), ИспользоватьXDTO, ВызыватьИсключение);
	#Иначе
		ОбъектБД = ОбъектБД();
		Результат = ирОбщий.СохранитьОбъектВВидеСтрокиXMLЛкс(ОбъектБД, ИспользоватьXDTO, , ВызыватьИсключение);
	#КонецЕсли 
	Возврат Результат;
	
КонецФункции

Процедура ДанныеИзСтрокиXMLЧерезXDTO(СтрокаXML, Знач ИспользоватьXDTO = Истина, СообщатьОбОшибках = Истина) Экспорт
	
	#Если Не Сервер Тогда
		Снимок = ирСервер.ОбъектБДВИмитаторИзСтрокиXML(СтрокаXML, ТипЗнч(ЭтотОбъект), ИспользоватьXDTO, СообщатьОбОшибках);
		ЗагрузитьСнимок(Снимок);
	#Иначе
		ОбъектБД = ирОбщий.ВосстановитьОбъектИзСтрокиXMLЛкс(СтрокаXML,, ИспользоватьXDTO, СообщатьОбОшибках);
		Конструктор(ОбъектБД);
	#КонецЕсли 
	
КонецПроцедуры

Процедура Записать(РежимЗаписи = Неопределено, РежимПроведения = Неопределено) Экспорт
	
	#Если Не Сервер Тогда
		Снимок = Снимок(, Ложь);
		ирСервер.ЗаписатьОбъектXMLЛкс(Снимок,, РежимЗаписи, РежимПроведения,,, ТипЗнч(ЭтотОбъект));
		ЗагрузитьСнимок(Снимок);
	#Иначе
		ОбъектБД = ОбъектБД();
		Если РежимЗаписи <> Неопределено Тогда
			ОбъектБД.Записать(РежимЗаписи, РежимПроведения);
		Иначе
			ОбъектБД.Записать();
		КонецЕсли; 
		Конструктор(ОбъектБД);
	#КонецЕсли 
	
КонецПроцедуры

Процедура УстановитьПометкуУдаления(НоваяПометка) Экспорт
	
	Если НоваяПометка = Данные.ПометкаУдаления Тогда
		Возврат;
	КонецЕсли; 
	#Если Не Сервер Тогда
		Снимок = Снимок();
		ирСервер.ЗаписатьОбъектXMLЛкс(Снимок,, "ПометкаУдаления",,,, ТипЗнч(ЭтотОбъект));
		ЗагрузитьСнимок(Снимок);
	#Иначе
		ОбъектБД = ОбъектБД(Ложь);
		//Если ОбъектБД.Модифицированность() Тогда
		//	ОбъектБД.Прочитать(); // Сделать: Надо найти и убрать установку модифированности
		//КонецЕсли; 
		ОбъектБД.УстановитьПометкуУдаления(НоваяПометка);
		Конструктор(ОбъектБД);
	#КонецЕсли 
	
КонецПроцедуры

Процедура Удалить() Экспорт
	
	#Если Не Сервер Тогда
		Снимок = Снимок();
		ирСервер.УдалитьОбъектXMLЛкс(Снимок,, ТипЗнч(ЭтотОбъект));
	#Иначе
		ОбъектБД = ОбъектБД(Ложь);
		ОбъектБД.Удалить();
		СброситьМодифицированность();
	#КонецЕсли 
	
КонецПроцедуры

Процедура СброситьМодифицированность() Экспорт 
	
	ЭтотОбъект._СчитанныйСнимок = Снимок(Истина);

КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ОбъектБД = ОбъектБД();
	Отказ = Не ОбъектБД.ПроверитьЗаполнение();
	Конструктор(ОбъектБД);
	
КонецПроцедуры

Функция ЗаменитьИдентификаторОбъекта() Экспорт 
	
	
	
КонецФункции

Процедура УстановитьНовыйКод(ПрефиксКода) Экспорт 
	
	#Если Не Сервер Тогда
		Снимок = Снимок();
		ирСервер.УстановитьНовыйКодXMLЛкс(Снимок, ПрефиксКода, ТипЗнч(ЭтотОбъект));
		ЗагрузитьСнимок(Снимок);
	#Иначе
		ОбъектБД = ОбъектБД();
		ОбъектБД.УстановитьНовыйКод(ПрефиксКода);
		Конструктор(ОбъектБД);
	#КонецЕсли 
	
КонецПроцедуры

Процедура УстановитьНовыйНомер(ПрефиксНомера) Экспорт 
	
	#Если Не Сервер Тогда
		Снимок = Снимок();
		ирСервер.УстановитьНовыйКодXMLЛкс(Снимок, ПрефиксНомера, ТипЗнч(ЭтотОбъект));
		ЗагрузитьСнимок(Снимок);
	#Иначе
		ОбъектБД = ОбъектБД();
		ОбъектБД.УстановитьНовыйКод(ПрефиксНомера);
		Конструктор(ОбъектБД);
	#КонецЕсли 
	
КонецПроцедуры
