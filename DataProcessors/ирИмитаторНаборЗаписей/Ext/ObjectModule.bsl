﻿Перем _СчитанныйСнимок Экспорт;
Перем _Тип Экспорт;
Перем _Построитель;

Процедура Конструктор(Объект) Экспорт 
	
	ЭтотОбъект.ДополнительныеСвойства = Объект.ДополнительныеСвойства;
	ЭтотОбъект.ОбменДанными = ирОбщий.СтруктураОбменаДаннымиОбъектаЛкс(Объект);
	ЭтотОбъект._Тип = ТипЗнч(Объект);
	ЭтотОбъект.Данные = Объект.Выгрузить();
	
	//ЭтотОбъект.Отбор = Новый Структура;
	//Для Каждого ЭлементОтбора Из Объект.Отбор Цикл
	//	Имитатор = Новый Структура("Имя, Использование, Значение");
	//	ЗаполнитьЗначенияСвойств(Имитатор, ЭлементОтбора); 
	//	Отбор.Вставить(ЭлементОтбора.Имя, Имитатор);
	//КонецЦикла;
	_Построитель = Новый ПостроительЗапроса();
	ЭтотОбъект.Отбор = _Построитель.Отбор;
	ДоступныеПоляОтбора = Отбор.ПолучитьДоступныеПоля();
	Для Каждого ЭлементОтбора Из Объект.Отбор Цикл
		Поле = ДоступныеПоляОтбора.Добавить(ЭлементОтбора.Имя,, ЭлементОтбора.ТипЗначения);
		Поле.Отбор = Истина;
	КонецЦикла;
	Отбор.УстановитьДоступныеПоля(ДоступныеПоляОтбора);
	ирОбщий.СкопироватьОтборПостроителяЛкс(Отбор, Объект.Отбор);
	Если Не Объект.Модифицированность() Тогда
		ЭтотОбъект._СчитанныйСнимок = Снимок(Истина);
	Иначе
		ЭтотОбъект._СчитанныйСнимок = ""; // Для экономии размера снимка
	КонецЕсли; 
	
КонецПроцедуры

Процедура КонструкторПоКлючу(ИмяОсновнойТаблицы, КлючОбъекта = Неопределено) Экспорт 
	
	ЭтотОбъект.ДополнительныеСвойства = Новый Структура;
	ЭтотОбъект.ОбменДанными = ирОбщий.СтруктураОбменаДаннымиОбъектаЛкс();
	ЭтотОбъект._Тип = Тип(ирОбщий.ПолучитьИмяТипаДанныхТаблицыРегистраЛкс(ИмяОсновнойТаблицы));
	ЭтотОбъект.Данные = Новый ТаблицаЗначений;
	#Если Сервер И Не Сервер Тогда
	    Данные = Новый ТаблицаЗначений;
	#КонецЕсли
	ПоляТаблицы = ирКэш.ПоляТаблицыБДЛкс(ИмяОсновнойТаблицы);
	Для Каждого ПолеТаблицы Из ПоляТаблицы Цикл
		Данные.Колонки.Добавить(ПолеТаблицы.Имя, ПолеТаблицы.ТипЗначения);
	КонецЦикла;
	_Построитель = Новый ПостроительЗапроса();
	Отбор = _Построитель.Отбор;
	ДоступныеПоляОтбора = Отбор.ПолучитьДоступныеПоля();
	ЭталонныйНаборЗаписей = ирКэш.ЭталонныйНаборЗаписейЛкс(ИмяОсновнойТаблицы);
	#Если Сервер И Не Сервер Тогда
	    ЭталонныйНаборЗаписей = РегистрыСведений.КурсыВалют.СоздатьНаборЗаписей();
	#КонецЕсли
	Для Каждого ЭлементОтбора Из ЭталонныйНаборЗаписей.Отбор Цикл
		Поле = ДоступныеПоляОтбора.Добавить(ЭлементОтбора.Имя,, ЭлементОтбора.ТипЗначения);
		Поле.Отбор = Истина;
	КонецЦикла;
	Отбор.УстановитьДоступныеПоля(ДоступныеПоляОтбора);
	ирОбщий.СкопироватьОтборПостроителяЛкс(Отбор, ЭталонныйНаборЗаписей.Отбор);
	Если КлючОбъекта <> Неопределено Тогда
		ирОбщий.ЗаполнитьОтборПоКлючуЛкс(Отбор, КлючОбъекта);
	КонецЕсли; 
	ЭтотОбъект._СчитанныйСнимок = ""; // Для экономии размера снимка
	
КонецПроцедуры

Функция Снимок(ТолькоДанные = Ложь, РезультатВВидеСтроки = Истина) Экспорт 
	
	СтруктураОтбора = Новый Структура;
	Для Каждого ЭлементОтбора Из Отбор Цикл
		Имитатор = Новый Структура("Использование, Значение, ТипЗначения");
		ЗаполнитьЗначенияСвойств(Имитатор, ЭлементОтбора); 
		СтруктураОтбора.Вставить(ЭлементОтбора.Имя, Имитатор);
	КонецЦикла;
	СтруктураОбъекта = Новый Структура;
	Если Не ТолькоДанные Тогда
		СтруктураОбъекта.Вставить("ОбменДанными", ОбменДанными);
		СтруктураОбъекта.Вставить("ДополнительныеСвойства", ДополнительныеСвойства);
		СтруктураОбъекта.Вставить("_СчитанныйСнимок", _СчитанныйСнимок);
	КонецЕсли; 
	СтруктураОбъекта.Вставить("_Тип", _Тип);
	СтруктураОбъекта.Вставить("Отбор", СтруктураОтбора);
	СтруктураОбъекта.Вставить("Данные", Данные);
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
		СтрокаЗагружаемыхСвойств = "_Тип, Отбор";
	Иначе
		СтрокаЗагружаемыхСвойств = "_Тип, Отбор, ОбменДанными, ДополнительныеСвойства, _СчитанныйСнимок";
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
		ирОбщий.ЗагрузитьВТаблицуЗначенийЛкс(СтруктураОбъекта.Данные, Данные);
	Иначе
		ЭтотОбъект.Данные = СтруктураОбъекта.Данные;
	КонецЕсли; 
	_Построитель = Новый ПостроительЗапроса();
	ЭтотОбъект.Отбор = _Построитель.Отбор;
	ДоступныеПоляОтбора = Отбор.ПолучитьДоступныеПоля();
	Для Каждого КлючИЗначение Из СтруктураОбъекта.Отбор Цикл
		Поле = ДоступныеПоляОтбора.Добавить(КлючИЗначение.Ключ, КлючИЗначение.Ключ, КлючИЗначение.Значение.ТипЗначения);
		Поле.Отбор = Истина;
	КонецЦикла;
	Отбор.УстановитьДоступныеПоля(ДоступныеПоляОтбора);
	Для Каждого КлючИЗначение Из СтруктураОбъекта.Отбор Цикл
		ЭлементОтбора = Отбор.Добавить(КлючИЗначение.Ключ);
		ЗаполнитьЗначенияСвойств(ЭлементОтбора, КлючИЗначение.Значение); 
	КонецЦикла;
	
КонецПроцедуры

Функция КлючОбъекта()
	
	#Если Сервер И Не Сервер Тогда
	    Пустышка = Новый ПостроительЗапроса;
		Отбор = Пустышка.Отбор;
	#КонецЕсли
	Результат = Новый Структура;
	Для Каждого ЭлементОтбора Из Отбор Цикл
		Если ЭлементОтбора.Использование Тогда
			Результат.Вставить(ЭлементОтбора.Имя, ЭлементОтбора.Значение); 
		КонецЕсли; 
	КонецЦикла;
	Возврат Результат;
	
КонецФункции

Функция ОбъектБД() Экспорт 
	
	КлючОбъекта = КлючОбъекта();
	ПолноеИмяТаблицы = ирОбщий.ИмяТаблицыИзМетаданныхЛкс(Метаданные.НайтиПоТипу(_Тип));
	Результат = ирОбщий.ОбъектБДПоКлючуЛкс(ПолноеИмяТаблицы, КлючОбъекта,, Ложь, Ложь).Данные;
	Если ДополнительныеСвойства <> Неопределено Тогда
		ирОбщий.СкопироватьУниверсальнуюКоллекциюЛкс(ДополнительныеСвойства, Результат.ДополнительныеСвойства);
	КонецЕсли; 
	ирОбщий.ВосстановитьСтруктуруОбменаДаннымиОбъектаЛкс(Результат, ОбменДанными);
	Результат.Загрузить(Данные); 
	//ирОбщий.НаборЗаписейПослеЗагрузкиИзТаблицыЗначенийЛкс(Результат); //Теперь это делается в ирОбщий.ЗаписатьОбъектЛкс()
	Возврат Результат;
	
КонецФункции

Функция Модифицированность() Экспорт 
	
	Результат = _СчитанныйСнимок <> Снимок(Истина);
	Возврат Результат;
	
КонецФункции

Функция Выгрузить() Экспорт 
	
	// Порядок номеров субконто может не совпадать с порядком в счете https://partners.v8.1c.ru/forum/t/1168440/m/1711008
	Результат = Данные.Скопировать();
	Возврат Результат;
	
КонецФункции

Функция ВыгрузитьКолонки() Экспорт 
	
	Результат = Данные.СкопироватьКолонки();
	Возврат Результат;
	
КонецФункции

Функция Количество() Экспорт 
	
	Возврат Данные.Количество();
	
КонецФункции

Процедура Загрузить(НовыеДанные) Экспорт 
	
	Данные.Очистить();
	ирОбщий.ЗагрузитьВТаблицуЗначенийЛкс(НовыеДанные, Данные);
	
КонецПроцедуры

Процедура Прочитать(НаСервере = Неопределено, Блокировать = Истина) Экспорт 
	
	ОбъектБД = Метаданные.НайтиПоТипу(_Тип);
	ПолноеИмяМД = ОбъектБД.ПолноеИмя();
	КорневойТип = ирОбщий.ПолучитьПервыйФрагментЛкс(ПолноеИмяМД);
	ИмяТаблицы = ирОбщий.ИмяТаблицыИзМетаданныхЛкс(ПолноеИмяМД);
	Если Блокировать Тогда
		ирОбщий.ЗаблокироватьНаборЗаписейПоОтборуЛкс(ЭтотОбъект, Истина, РежимБлокировкиДанных.Разделяемый);
	КонецЕсли; 
	Запрос = Новый Запрос;
	Если Истина
		И КорневойТип = "РегистрСведений" 
		И ОбъектБД.РежимЗаписи = Метаданные.СвойстваОбъектов.РежимЗаписиРегистра.Независимый
	Тогда
		Запрос.Текст = "
		|ВЫБРАТЬ Т.*
		|ИЗ " + ИмяТаблицы + " КАК Т ГДЕ ИСТИНА";
		#Если Сервер И Не Сервер Тогда
		    Пустышка = Новый ПостроительЗапроса;
			Отбор = Пустышка.Отбор;
		#КонецЕсли
		Для Каждого ЭлементОтбора Из Отбор Цикл
			Если ЭлементОтбора.Использование Тогда
				Запрос.Текст = Запрос.Текст + "
				|И Т." + ЭлементОтбора.Имя + " = &" + ЭлементОтбора.Имя;
				Запрос.УстановитьПараметр(ЭлементОтбора.Имя, ЭлементОтбора.Значение);
			КонецЕсли; 
		КонецЦикла;
		НовыеДанные = Запрос.Выполнить().Выгрузить();
	ИначеЕсли КорневойТип = "РегистрБухгалтерии" Тогда
		// Чтобы в таблице правильно расставились субконто https://partners.v8.1c.ru/forum/t/1168440/m/1711008
		Запрос.УстановитьПараметр("Регистратор", Отбор[0].Значение);
		Запрос.Текст = "
		|ВЫБРАТЬ Т.*
		|ИЗ " + ИмяТаблицы + "(,, " + Отбор[0].Имя + " = &Регистратор) КАК Т
		|УПОРЯДОЧИТЬ ПО НомерСтроки
		|";
		// Избавиться от NULL в колонках видов субконто надо, чтобы потом метод Загрузить не выдавал ошибку
		НовыеДанные = ирОбщий.ПолучитьТаблицуСКолонкамиБезТипаNullЛкс(Запрос.Выполнить().Выгрузить());
	Иначе
		Запрос.УстановитьПараметр("Регистратор", Отбор[0].Значение);
		Запрос.Текст = "
		|ВЫБРАТЬ Т.*
		|ИЗ " + ИмяТаблицы + " КАК Т ГДЕ Т." + Отбор[0].Имя + " = &Регистратор 
		|УПОРЯДОЧИТЬ ПО НомерСтроки";
		НовыеДанные = Запрос.Выполнить().Выгрузить();
	КонецЕсли; 
	Данные.Очистить();
	ирОбщий.ЗагрузитьВТаблицуЗначенийЛкс(НовыеДанные, Данные); // Созданная изначально таблица Данные должна оставаться, т.к. на нее ссылаются снаружи
	ЭтотОбъект._СчитанныйСнимок = Снимок(Истина);
	
КонецПроцедуры

Процедура Записать(Замещать = Истина) Экспорт
	
	#Если Не Сервер Тогда
		Снимок = Снимок();
		ирСервер.ЗаписатьОбъектXMLЛкс(Снимок,,,,,, ТипЗнч(ЭтотОбъект));
		ЗагрузитьСнимок(Снимок);
	#Иначе
		ОбъектБД = ОбъектБД();
		ирОбщий.НаборЗаписейПослеЗагрузкиИзТаблицыЗначенийЛкс(ОбъектБД);
		ОбъектБД.Записать(Замещать);
		Конструктор(ОбъектБД);
	#КонецЕсли 
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ОбъектБД = ОбъектБД();
	Отказ = Не ОбъектБД.ПроверитьЗаполнение();
	Конструктор(ОбъектБД);
	
КонецПроцедуры

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
