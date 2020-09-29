﻿Перем мСвязанныйРедакторОбъектаБД;
Перем Построитель;
Перем ЭтоПеречисление;
Перем ПараметрТекущаяКолонка Экспорт;
//Перем ФормаРезультатФоновогоЗадания;

Процедура КнопкаВыполнитьНажатие(Кнопка)
	// Вставить содержимое обработчика.
КонецПроцедуры

Функция УстановитьОбъектМетаданных(НовоеПолноеИмяТаблицы = Неопределено) Экспорт

	Если НовоеПолноеИмяТаблицы <> Неопределено Тогда
		ЗначениеИзменено = Ложь;
		ирОбщий.ПрисвоитьЕслиНеРавноЛкс(фОбъект.ПолноеИмяТаблицы, НовоеПолноеИмяТаблицы, ЗначениеИзменено);
		Если Не ЗначениеИзменено Тогда
			Возврат Ложь;
		КонецЕсли; 
	КонецЕсли; 
	фОбъект.КоличествоСтрокВОбластиПоиска = "...";
	Если Не ирКэш.ЛиПортативныйРежимЛкс() И Не ирКэш.ЭтоФайловаяБазаЛкс() Тогда
		ирОбщий.ОтменитьФоновоеЗаданиеЛкс(фОбъект.ИДФоновогоЗадания);
		//ФормаРезультатФоновогоЗадания = ирОбщий.ФормаРезультатаФоновогоЗаданияЛкс();
		//фОбъект.АдресХранилищаКоличестваСтрок = ПоместитьВоВременноеХранилище(Неопределено, ФормаРезультатФоновогоЗадания.УникальныйИдентификатор);
		фОбъект.АдресХранилищаКоличестваСтрок = ПоместитьВоВременноеХранилище(Null, Новый УникальныйИдентификатор);
		ПараметрыЗапуска = Новый Массив;
		ПараметрыЗапуска.Добавить(фОбъект.ПолноеИмяТаблицы);
		ПараметрыЗапуска.Добавить(фОбъект.АдресХранилищаКоличестваСтрок);
		#Если Сервер И Не Сервер Тогда
			ирОбщий.КоличествоСтрокВТаблицеБДЛкс();
		#КонецЕсли
		ФоновоеЗадание = ФоновыеЗадания.Выполнить("ирОбщий.КоличествоСтрокВТаблицеБДЛкс", ПараметрыЗапуска,, "ИР. Вычисление количества строк в таблице " + фОбъект.ПолноеИмяТаблицы);
		фОбъект.ИДФоновогоЗадания = ФоновоеЗадание.УникальныйИдентификатор;
	КонецЕсли; 
	#Если Сервер И Не Сервер Тогда
		ОбновитьКоличествоСтрок();
	#КонецЕсли
	ПодключитьОбработчикОжидания("ОбновитьКоличествоСтрок", 0.1, Истина);
	Если Не ирОбщий.ЛиТаблицаБДСуществуетЛкс(фОбъект.ПолноеИмяТаблицы) Тогда
		фОбъект.ПолноеИмяТаблицы = Неопределено;
		Возврат Ложь;
	КонецЕсли; 
	ТипТаблицыБД = ирОбщий.ТипТаблицыБДЛкс(фОбъект.ПолноеИмяТаблицы);
	ЭлементыФормы.ДинамическийСписок.ИзменятьСоставСтрок = Истина;
	МассивФрагментов = ирОбщий.СтрРазделитьЛкс(фОбъект.ПолноеИмяТаблицы);
	ОсновнойЭУ = ЭлементыФормы.ДинамическийСписок;
	ИмяТипаСписка = ирОбщий.ИмяТипаИзПолногоИмениТаблицыБДЛкс(фОбъект.ПолноеИмяТаблицы, "Список");
	ОбъектМД = ирКэш.ОбъектМДПоПолномуИмениЛкс(фОбъект.ПолноеИмяТаблицы);
	ЕстьОграниченияДоступа = ирОбщий.ЕстьОграниченияДоступаКСтрокамТаблицыНаЧтениеЛкс(ОбъектМД);
	ЭлементыФормы.НадписьПраваДоступаКСтрокам.Заголовок = "RLS: " + Формат(ЕстьОграниченияДоступа, "БЛ=Нет; БИ=Да");
	ЭлементыФормы.НадписьПраваДоступаКСтрокам.Гиперссылка = ЕстьОграниченияДоступа;
	Если ЗначениеЗаполнено(ИмяТипаСписка) Тогда
		Если Истина
			И ЭтаФорма.Открыта()
			И ирОбщий.ЛиКорневойТипРегистраСведенийЛкс(МассивФрагментов[0]) 
			И ОбъектМД.Измерения.Количество() = 0
			И ОбъектМД.ПериодичностьРегистраСведений = Метаданные.СвойстваОбъектов.ПериодичностьРегистраСведений.Непериодический
			И ОбъектМД.РежимЗаписи = Метаданные.СвойстваОбъектов.РежимЗаписиРегистра.Независимый
		Тогда
			// Антибаг платформы 8.3 Приложение аварийно завершалось
			ОсновнойЭУ.ТипЗначения = Новый ОписаниеТипов("ТаблицаЗначений");
			Сообщить("Списки независимых непериодических регистров сведений без измерений после открытия формы не подключаются из-за ошибки платформы");
		Иначе
			Попытка
				ОсновнойЭУ.ТипЗначения = Новый ОписаниеТипов(ИмяТипаСписка);
			Исключение
				Сообщить("Динамический список для таблицы """ + фОбъект.ПолноеИмяТаблицы + """ недоступен");
				фОбъект.ПолноеИмяТаблицы = Неопределено;
				Возврат Ложь;
			КонецПопытки; 
			//ТекстЗапросаКоличестваСтрок = "ВЫБРАТЬ СУММА(Количество) ИЗ (" + ТекстЗапросаКоличестваСтрок + ") КАК Т";
			//ЗапросКоличестваСтрок = Новый Запрос(мТекстЗапросаКоличестваСтрок);
			//КоличествоСтрокВТаблицеБД = ЗапросКоличестваСтрок.Выполнить().Выгрузить()[0][0];
			ирОбщий.НастроитьАвтоТабличноеПолеДинамическогоСпискаЛкс(ОсновнойЭУ, фОбъект.РежимИмяСиноним);
			ЭтаФорма.Отбор = ЭлементыФормы.ДинамическийСписок.Значение.Отбор;
		КонецЕсли; 
	Иначе
		ТекстЗапроса = "ВЫБРАТЬ ПЕРВЫЕ 100000 РАЗРЕШЕННЫЕ Т.* ИЗ " + фОбъект.ПолноеИмяТаблицы + " КАК Т";
		ОсновнойЭУ.ТипЗначения = Новый ОписаниеТипов("ТаблицаЗначений");
		Построитель.Текст = ТекстЗапроса;
		ОсновнойЭУ.Значение = Построитель.Результат.Выгрузить();
		ОсновнойЭУ.СоздатьКолонки();
		ОсновнойЭУ.ИзменятьСоставСтрок = Ложь;
		Для Каждого КолонкаТП Из ОсновнойЭУ.Колонки Цикл
			КолонкаТП.ТолькоПросмотр = Истина;
		КонецЦикла;
		Построитель.ЗаполнитьНастройки();
		КолонкаИдентификатора = ОсновнойЭУ.Колонки.Добавить("ИдентификаторСсылкиЛкс");
		КолонкаИдентификатора.ТекстШапки = "Идентификатор ссылки";
		ЭтаФорма.Отбор = Построитель.Отбор;
	КонецЕсли;
	ПредставлениеТаблицы = ирОбщий.ПредставлениеТаблицыБДЛкс(фОбъект.ПолноеИмяТаблицы);
	Для Каждого КолонкаТП Из ОсновнойЭУ.Колонки Цикл
		Если ТипЗнч(КолонкаТП.ЭлементУправления) = Тип("ПолеВвода") Тогда
			КолонкаТП.ЭлементУправления.УстановитьДействие("ОкончаниеВводаТекста", Новый Действие("ПолеВводаКолонкиСписка_ОкончаниеВводаТекста"));
			КолонкаТП.ЭлементУправления.УстановитьДействие("НачалоВыбора", Новый Действие("ПолеВводаКолонкиСписка_НачалоВыбора"));
		КонецЕсли; 
	КонецЦикла;
	ирОбщий.ОбновитьТекстПослеМаркераВСтрокеЛкс(ЭтаФорма.Заголовок,, ПредставлениеТаблицы, ": ");
	ирОбщий.ДописатьРежимВыбораВЗаголовокФормыЛкс(ЭтаФорма);
	ЭтоПеречисление = ирОбщий.ЛиКорневойТипПеречисленияЛкс(ТипТаблицыБД);
	фОбъект.ВместоОсновной = ирОбщий.ПолучитьИспользованиеДинамическогоСпискаВместоОсновнойФормыЛкс(фОбъект.ПолноеИмяТаблицы);
	Попытка
		ЭлементыФормы.ДинамическийСписок.Колонки.Наименование.ОтображатьИерархию = Истина;
		ЭлементыФормы.ДинамическийСписок.Колонки.Картинка.ОтображатьИерархию = Ложь;
		ЭлементыФормы.ДинамическийСписок.Колонки.Картинка.Видимость = Ложь;
	Исключение
	КонецПопытки;
	ЭлементыФормы.КоманднаяПанельПереключателяДерева.Кнопки.РежимДерева.Доступность = ирОбщий.ЛиМетаданныеИерархическогоОбъектаЛкс(ОбъектМД);
	ЭлементыФормы.КП_Список.Кнопки.НайтиВыбратьПоID.Доступность = ирОбщий.ЛиКорневойТипСсылочногоОбъектаБДЛкс(ТипТаблицыБД);
	ирОбщий.НастроитьТабличноеПолеЛкс(ОсновнойЭУ);
	ЗагрузитьНастройкиСписка();
	фОбъект.СтарыйОбъектМетаданных = фОбъект.ПолноеИмяТаблицы;
	ирОбщий.ПоследниеВыбранныеЗаполнитьПодменюЛкс(ЭтаФорма, ЭлементыФормы.КП_Список.Кнопки.ПоследниеВыбранные, ЭлементыФормы.ДинамическийСписок);
	Возврат Истина;
	
КонецФункции

Процедура СохранитьНастройкиСписка()
	
	Если Не ЗначениеЗаполнено(фОбъект.СтарыйОбъектМетаданных) Тогда
		Возврат;
	КонецЕсли; 
	фОбъект.НастройкиКолонок.Очистить();
	Для Каждого КолонкаТП Из ЭлементыФормы.ДинамическийСписок.Колонки Цикл
		ОписаниеКолонки = фОбъект.НастройкиКолонок.Добавить();
		ЗаполнитьЗначенияСвойств(ОписаниеКолонки, КолонкаТП); 
	КонецЦикла;
	СтруктураНастроек = Новый Структура;
	СтруктураНастроек.Вставить("НастройкиКолонок", фОбъект.НастройкиКолонок.Выгрузить());
	Попытка
		ПорядокСписка = ЭлементыФормы.ДинамическийСписок.Значение.Порядок;
	Исключение
		ПорядокСписка = Неопределено;
	КонецПопытки; 
	Если ПорядокСписка <> Неопределено Тогда
		СтрокаПорядка = ирОбщий.ПолучитьСтрокуПорядкаЛкс(ПорядокСписка);
		Если ЗначениеЗаполнено(СтрокаПорядка) Тогда
			СтруктураНастроек.Вставить("Порядок", СтрокаПорядка);
		КонецЕсли; 
	КонецЕсли; 
	ирОбщий.СохранитьЗначениеЛкс("ДинамическийСписок." + фОбъект.СтарыйОбъектМетаданных + "." + РежимВыбора, СтруктураНастроек);
	
КонецПроцедуры

Процедура ЗагрузитьНастройкиСписка()
	
	СохраненныеНастройки = ирОбщий.ВосстановитьЗначениеЛкс("ДинамическийСписок." + ПолноеИмяТаблицы + "." + РежимВыбора);
	Если СохраненныеНастройки = Неопределено Тогда
		Возврат;
	КонецЕсли; 
		#Если Сервер И Не Сервер Тогда
		    СохраненныеНастройки = Новый Структура;
		#КонецЕсли
	Если ТипЗнч(СохраненныеНастройки) = Тип("Структура") Тогда
		фОбъект.НастройкиКолонок.Загрузить(СохраненныеНастройки.НастройкиКолонок);
		Если СохраненныеНастройки.Свойство("Порядок") И ЗначениеЗаполнено(СохраненныеНастройки.Порядок) Тогда
			НовыйПорядок = СохраненныеНастройки.Порядок;
			ПорядокДинамическогоСписка = ЭлементыФормы.ДинамическийСписок.Значение.Порядок;
			Попытка
				ПорядокДинамическогоСписка.Установить(НовыйПорядок);
			Исключение
			КонецПопытки; 
		КонецЕсли; 
	КонецЕсли; 
	ПрименитьНастройкиКолонок();
	
КонецПроцедуры

Процедура ПрименитьНастройкиКолонок()
	
	НачальноеКоличество = фОбъект.НастройкиКолонок.Количество(); 
	КолонкиТП = ЭлементыФормы.ДинамическийСписок.Колонки;
	Для Счетчик = 1 По НачальноеКоличество Цикл
		ОписаниеКолонки = фОбъект.НастройкиКолонок[НачальноеКоличество - Счетчик];
		КолонкаТП = КолонкиТП.Найти(ОписаниеКолонки.Имя);
		Если КолонкаТП <> Неопределено Тогда
			КолонкиТП.Сдвинуть(КолонкаТП, -КолонкиТП.Индекс(КолонкаТП));
			ЗаполнитьЗначенияСвойств(КолонкаТП, ОписаниеКолонки,, "Имя, ВысотаЯчейки"); 
			КолонкаТП.ВысотаЯчейки = Макс(1, ОписаниеКолонки.ВысотаЯчейки);
		КонецЕсли; 
	КонецЦикла;

КонецПроцедуры

Процедура НайтиСсылкуВСписке(КлючСтроки, УстановитьОбъектМетаданных = Истина) Экспорт

	МетаданныеТаблицы = Метаданные.НайтиПоТипу(ирОбщий.ТипОбъектаБДЛкс(КлючСтроки));
	Если УстановитьОбъектМетаданных Тогда
		УстановитьОбъектМетаданных(МетаданныеТаблицы.ПолноеИмя());
	КонецЕсли; 
	ИмяXMLТипа = СериализаторXDTO.XMLТипЗнч(КлючСтроки).ИмяТипа;
	Если Ложь
		Или Найти(ИмяXMLТипа, "Ref.") > 0
		Или Найти(ИмяXMLТипа, "RecordKey.") > 0
	Тогда
		ЭлементыФормы.ДинамическийСписок.ТекущаяСтрока = КлючСтроки;
	Иначе
		ирОбщий.СкопироватьОтборЛюбойЛкс(ЭлементыФормы.ДинамическийСписок.Значение.Отбор, КлючСтроки.Методы.Отбор);
	КонецЕсли; 

КонецПроцедуры

Процедура ОбъектМетаданныхОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;

КонецПроцедуры

Процедура КП_СписокОткрытьУниверсальныйОтбор(Кнопка)
	
	ирОбщий.ОткрытьМенеджерТабличногоПоляЛкс(ЭлементыФормы.ДинамическийСписок, ЭтаФорма);

КонецПроцедуры

Процедура КП_СписокСжатьКолонки(Кнопка)
	
	ирОбщий.СжатьКолонкиТабличногоПоляЛкс(ЭлементыФормы.ДинамическийСписок);
	
КонецПроцедуры

Процедура ПриОткрытии()
	
	ИмяПоляСсылка = ирОбщий.ПеревестиСтроку("Ссылка");
	ЭтаФорма.СвязиИПараметрыВыбора = Истина;
	Если КлючУникальности <> Неопределено Тогда
		НовоеИмяТаблицы = ирОбщий.ПервыйФрагментЛкс(КлючУникальности, ";");
		ОбъектМД = ирКэш.ОбъектМДПоПолномуИмениЛкс(НовоеИмяТаблицы);
		Если ОбъектМД <> Неопределено Тогда
			УстановитьОбъектМетаданных(НовоеИмяТаблицы);
		КонецЕсли;
	КонецЕсли; 
	Если Истина
		И ЗначениеЗаполнено(фОбъект.ПолноеИмяТаблицы)
		И НачальноеЗначениеВыбора <> Неопределено 
		И ЗначениеЗаполнено(НачальноеЗначениеВыбора) 
	Тогда
		Если Ложь
			Или ирОбщий.ЛиСсылкаНаОбъектБДЛкс(НачальноеЗначениеВыбора)
			Или ирОбщий.ЛиСсылкаНаПеречислениеЛкс(НачальноеЗначениеВыбора)
			Или ирОбщий.ЛиКлючЗаписиРегистраЛкс(НачальноеЗначениеВыбора)
		Тогда
			ЭлементыФормы.ДинамическийСписок.ТекущаяСтрока = НачальноеЗначениеВыбора;
		ИначеЕсли ирОбщий.ЛиСсылкаНаОбъектБДЛкс(НачальноеЗначениеВыбора, Ложь) Тогда 
			ДанныеСписка = ЭлементыФормы.ДинамическийСписок.Значение;
			ТекущаяСтрока = ДанныеСписка.Найти(НачальноеЗначениеВыбора, ИмяПоляСсылка);
			Если ТекущаяСтрока <> Неопределено Тогда
				ЭлементыФормы.ДинамическийСписок.ТекущаяСтрока = ТекущаяСтрока;
			КонецЕсли; 
		КонецЕсли; 
	КонецЕсли;
	Если ЗначениеЗаполнено(фОбъект.ПолноеИмяТаблицы) Тогда
		ЭтаФорма.ТекущийЭлемент = ЭлементыФормы.ДинамическийСписок;
	КонецЕсли; 
	ЭлементыФормы.ДинамическийСписок.РежимВыбора = РежимВыбора;
	Если ПараметрТекущаяКолонка <> Неопределено Тогда
		КолонкаСписка = ЭлементыФормы.ДинамическийСписок.Колонки.Найти(ПараметрТекущаяКолонка);
		Если КолонкаСписка <> Неопределено Тогда
			ЭлементыФормы.ДинамическийСписок.ТекущаяКолонка = КолонкаСписка;
		КонецЕсли; 
		ЭтаФорма.ПараметрТекущаяКолонка = "";
	КонецЕсли; 
	ирОбщий.ПолеВводаСИсториейВыбора_ПриИзмененииЛкс(ЭлементыФормы.ОбъектМетаданных, ЭтаФорма);
	
КонецПроцедуры

Процедура КП_СписокШиринаКолонок(Кнопка)
	
	ирОбщий.РасширитьКолонкиТабличногоПоляЛкс(ЭлементыФормы.ДинамическийСписок);
	
КонецПроцедуры

Процедура ИзменитьСтрокуЧерезРедакторОбъектаБД(Кнопка)
	
	ирОбщий.ОткрытьТекущуюСтрокуТабличногоПоляТаблицыБДВРедактореОбъектаБДЛкс(ЭлементыФормы.ДинамическийСписок, ПолноеИмяТаблицы,,,,, Ложь);
	
КонецПроцедуры

Процедура КП_СписокОПодсистеме(Кнопка)
	
	ирОбщий.ОткрытьСправкуПоПодсистемеЛкс(ЭтотОбъект);

КонецПроцедуры

Процедура ГлавнаяКоманднаяПанельНовоеОкно(Кнопка)
	
	ирОбщий.ОткрытьНовоеОкноОбработкиЛкс(ЭтотОбъект);
	
КонецПроцедуры

Процедура ДинамическийСписокПриПолученииДанных(Элемент, ОформленияСтрок)
	
	ИмяПоляСсылка = ирОбщий.ПеревестиСтроку("Ссылка");
	ИмяПоляЭтоГруппа = ирОбщий.ПеревестиСтроку("ЭтоГруппа");
	ИмяПоляИмяПредопределенныхДанных = ирОбщий.ПеревестиСтроку("ИмяПредопределенныхДанных");
	КолонкаИдентификатор = Элемент.Колонки.Найти("ИдентификаторСсылкиЛкс");
	Если КолонкаИдентификатор <> Неопределено Тогда
		КолонкаИдентификатораВидима = КолонкаИдентификатор.Видимость;
	Иначе
		КолонкаИдентификатораВидима = Ложь;
	КонецЕсли; 
	КолонкаИмяПредопределенного = Элемент.Колонки.Найти(ИмяПоляИмяПредопределенныхДанных);
	Если КолонкаИмяПредопределенного <> Неопределено Тогда
		КолонкаИмяПредопределенногоВидима = КолонкаИмяПредопределенного.Видимость;
	Иначе
		КолонкаИмяПредопределенногоВидима = Ложь;
	КонецЕсли; 
	КолонкаЭтоГруппа = Элемент.Колонки.Найти(ИмяПоляЭтоГруппа);
	Если Истина
		И КолонкаЭтоГруппа <> Неопределено 
		И КолонкаЭтоГруппа.Данные = ""
		И КолонкаЭтоГруппа.ДанныеФлажка = ""
	Тогда
		// Антибаг платформы 8.2-8.3.9 В свойство Данные и ДанныеФлажка нельзя записать "ЭтоГруппа", поэтому выводим значение в ячейки сами
		КолонкаЭтоГруппаВидима = КолонкаЭтоГруппа.Видимость;
	Иначе
		КолонкаЭтоГруппаВидима = Ложь;
	КонецЕсли;
	Для каждого ОформлениеСтроки Из ОформленияСтрок Цикл
		ДанныеСтроки = ОформлениеСтроки.ДанныеСтроки;
		ирОбщий.ТабличноеПолеПриВыводеСтрокиЛкс(ЭтаФорма, Элемент, ОформлениеСтроки, ДанныеСтроки, ЭлементыФормы.КП_Список.Кнопки.Идентификаторы);
		Если ДанныеСтроки = неопределено Тогда
			Продолжить;
		КонецЕсли;
		Если КолонкаИдентификатораВидима Тогда
			ЯчейкаИдентификатора = ОформлениеСтроки.Ячейки["ИдентификаторСсылкиЛкс"];
			Если ЭтоПеречисление Тогда
				ИдентификаторСсылки = "" + XMLСтрока(ДанныеСтроки);
			Иначе
				ИдентификаторСсылки = "" + ирОбщий.ПолучитьИдентификаторСсылкиЛкс(ДанныеСтроки[ИмяПоляСсылка]);
			КонецЕсли; 
			ЯчейкаИдентификатора.УстановитьТекст(ИдентификаторСсылки);
		КонецЕсли;
		Если КолонкаИмяПредопределенногоВидима Тогда
			ЯчейкаИмяПредопределенного = ОформлениеСтроки.Ячейки[ИмяПоляИмяПредопределенныхДанных];
			Если ЗначениеЗаполнено(ПолноеИмяТаблицы) Тогда
				ИмяПредопределенного = ирОбщий.ПолучитьМенеджерЛкс(ПолноеИмяТаблицы).ПолучитьИмяПредопределенного(ДанныеСтроки[ИмяПоляСсылка]);
				ЯчейкаИмяПредопределенного.УстановитьТекст(ИмяПредопределенного);
			КонецЕсли; 
		КонецЕсли;
		Если КолонкаЭтоГруппаВидима Тогда
			ЯчейкаИдентификатора = ОформлениеСтроки.Ячейки[ИмяПоляЭтоГруппа];
			ЯчейкаИдентификатора.Значение = ДанныеСтроки[ИмяПоляЭтоГруппа];
		КонецЕсли;
		Если Истина
			И Не ЭтоПеречисление
			И Элемент.Значение.Колонки.Найти("Активность") <> Неопределено
			И ДанныеСтроки.Активность = Ложь 
		Тогда
			ОформлениеСтроки.ЦветТекста = ирОбщий.ЦветТекстаНеактивностиЛкс();
		КонецЕсли; 
	КонецЦикла;

КонецПроцедуры

Процедура КП_СписокОбработатьОбъекты(Кнопка)
	
	ирОбщий.ПредложитьЗакрытьМодальнуюФормуЛкс(ЭтаФорма);
	ирОбщий.ОткрытьПодборИОбработкуОбъектовИзТабличногоПоляДинамическогоСпискаЛкс(ЭлементыФормы.ДинамическийСписок);

КонецПроцедуры

Процедура КП_СписокОтборБезЗначенияВТекущейКолонке(Кнопка)
	
	ирОбщий.ТабличноеПолеОтборБезЗначенияВТекущейКолонке_КнопкаЛкс(ЭлементыФормы.ДинамическийСписок);

КонецПроцедуры

Процедура ОбъектМетаданныхПриИзменении(Элемент)
	
	СохранитьНастройкиСписка();
	ЭтаФорма.КлючУникальности = фОбъект.ПолноеИмяТаблицы;
	Если УстановитьОбъектМетаданных() Тогда 
		ирОбщий.ПолеВводаСИсториейВыбора_ПриИзмененииЛкс(Элемент, ЭтаФорма);
	КонецЕсли; 
	
КонецПроцедуры

Процедура ОбъектМетаданныхНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	
	ирОбщий.ПолеВводаСИсториейВыбора_НачалоВыбораИзСпискаЛкс(Элемент, ЭтаФорма);

КонецПроцедуры

Функция ПараметрыВыбораОбъектаМетаданных()
	Возврат ирОбщий.ПараметрыВыбораОбъектаМетаданныхЛкс(Истина, Истина, Истина,,,,,,,, Истина);
КонецФункции

Процедура ОбъектМетаданныхНачалоВыбора(Элемент, СтандартнаяОбработка)
	ирОбщий.ОбъектМетаданныхНачалоВыбораЛкс(Элемент, ПараметрыВыбораОбъектаМетаданных(), СтандартнаяОбработка);
КонецПроцедуры

Процедура ОбъектМетаданныхОкончаниеВводаТекста(Элемент, Текст, Значение, СтандартнаяОбработка)
	ирОбщий.ОбъектМетаданныхОкончаниеВводаТекстаЛкс(Элемент, ПараметрыВыбораОбъектаМетаданных(), Текст, Значение, СтандартнаяОбработка);
КонецПроцедуры

Процедура КП_СписокСколькоСтрок(Кнопка)
	
	ирОбщий.ТабличноеПолеИлиТаблицаФормы_СколькоСтрокЛкс(ЭлементыФормы.ДинамическийСписок);

КонецПроцедуры

Процедура СтруктураКоманднойПанелиНажатие(Кнопка)
	
	ирОбщий.ОткрытьСтруктуруКоманднойПанелиЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура ПослеВосстановленияЗначений()
	
	УстановитьОбъектМетаданных();
	
КонецПроцедуры

Процедура ОбновлениеОтображения()
	
	ЗначениеТабличногоПоля = ЭлементыФормы.ДинамическийСписок.Значение;
	Попытка
		Отбор = ЗначениеТабличногоПоля.Отбор;
	Исключение
		Отбор = "";
	КонецПопытки; 
	ЭлементыФормы.НадписьОтбор.Заголовок = "Отбор: " + ирОбщий.ПредставлениеОтбораЛкс(Отбор);
	
КонецПроцедуры

Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ЗаписанОбъект" Тогда
		Если ТипЗнч(Параметр) = Тип("Тип") Тогда
			ОбъектМД = Метаданные.НайтиПоТипу(Параметр);
		ИначеЕсли ТипЗнч(Параметр) = Тип("Строка") Тогда
			ОбъектМД = ирКэш.ОбъектМДПоПолномуИмениЛкс(Параметр);
		Иначе
			ОбъектМД = Метаданные.НайтиПоТипу(ТипЗнч(Параметр));
		КонецЕсли; 
		Если Ложь
			Или Параметр = Неопределено
			Или (Истина
				И ОбъектМД <> Неопределено 
				И ОбъектМД.ПолноеИмя() = фОбъект.ПолноеИмяТаблицы)
		Тогда
			ЭлементыФормы.ДинамическийСписок.Значение.Обновить();
		КонецЕсли; 
	КонецЕсли; 
	ирОбщий.ФормаОбработкаОповещенияЛкс(ЭтаФорма, ИмяСобытия, Параметр, Источник); 

КонецПроцедуры

Процедура ДинамическийСписокВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	Если РежимВыбора Тогда
		ИмяПоляСсылка = ирОбщий.ПеревестиСтроку("Ссылка");
		Если ирОбщий.ТипТаблицыБДЛкс(ПолноеИмяТаблицы) = "Точки" Тогда
			Если ТипЗнч(ВыбраннаяСтрока) = Тип("Массив") Тогда
				Массив = Новый Массив;
				Для Каждого ЭлементМассива Из ВыбраннаяСтрока Цикл
					Массив.Добавить(ЭлементМассива[ИмяПоляСсылка]);
				КонецЦикла;
			Иначе
				Массив = ВыбраннаяСтрока[ИмяПоляСсылка];
			КонецЕсли; 
			ВыбраннаяСтрока = Массив;
		КонецЕсли; 
		ирОбщий.ПоследниеВыбранныеДобавитьЛкс(ЭтаФорма, ВыбраннаяСтрока);
		ОповеститьОВыборе(ВыбраннаяСтрока);
		СтандартнаяОбработка = Ложь;
	КонецЕсли; 
	
КонецПроцедуры

Процедура КП_СписокВыбратьНужноеКоличество(Кнопка)
	
	Количество = 10;
	Если Не ВвестиЧисло(Количество, "Введите количество", 6, 0) Тогда
		Возврат;
	КонецЕсли; 
	Если Количество = 0 Тогда
		Возврат;
	КонецЕсли; 
	ирОбщий.ВыделитьПервыеСтрокиДинамическогоСпискаЛкс(ЭлементыФормы.ДинамическийСписок, Количество);
	
КонецПроцедуры

Процедура КлсУниверсальнаяКомандаНажатие(Кнопка) Экспорт 
	
	ирОбщий.УниверсальнаяКомандаФормыЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура ОбработчикОжиданияСПараметрамиЛкс() Экспорт 
	
	ирОбщий.ОбработчикОжиданияСПараметрамиЛкс();

КонецПроцедуры

Процедура КП_СписокКопироватьСсылку(Кнопка)
	
	ТекущийЭлементФормы = ЭлементыФормы.ДинамическийСписок;
	ТекущаяСтрока = ТекущийЭлементФормы.ТекущаяСтрока;
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ирОбщий.БуферОбмена_УстановитьЗначениеЛкс(ТекущаяСтрока);
	
КонецПроцедуры

Процедура КП_СписокЗначенияКолонки(Кнопка)
	
	ирОбщий.ОткрытьРазличныеЗначенияКолонкиЛкс(ЭлементыФормы.ДинамическийСписок);
	
КонецПроцедуры

Процедура КП_СписокИдентификаторы(Кнопка)
	
	ирОбщий.КнопкаОтображатьПустыеИИдентификаторыНажатиеЛкс(Кнопка);
	ЭлементыФормы.ДинамическийСписок.ОбновитьСтроки();
	
КонецПроцедуры

Процедура ДинамическийСписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель = Неопределено, ЭтоГруппа = Неопределено)
	
	Ответ = Вопрос("Использовать редактор объекта БД?", РежимДиалогаВопрос.ДаНет,, КодВозвратаДиалога.Нет);
	Если Ответ = КодВозвратаДиалога.Да Тогда
		Отказ = Истина;
		ДобавитьСтрокуЧерезРедакторОбъектаБД(, Копирование, ЭтоГруппа);
	КонецЕсли;
	
КонецПроцедуры

Процедура КП_СписокСтруктураФормы(Кнопка)
	
	ирОбщий.ОткрытьСтруктуруФормыЛкс(ЭтаФорма);
	
КонецПроцедуры

Процедура ПолеВводаКолонкиСписка_НачалоВыбора(Элемент, СтандартнаяОбработка)
	
	ТабличноеПоле = ЭлементыФормы.ДинамическийСписок;
	Если СвязиИПараметрыВыбора Тогда
		ИмяПоляТаблицы = ТабличноеПоле.ТекущаяКолонка.Имя;
		ПоляТаблицыБД = ирКэш.ПоляТаблицыБДЛкс(ПолноеИмяТаблицы);
		МетаРеквизит = ПоляТаблицыБД.Найти(ИмяПоляТаблицы, "Имя").Метаданные;
		СтруктураОтбора = ирОбщий.ПолучитьСтруктуруОтбораПоСвязямИПараметрамВыбораЛкс(ТабличноеПоле.ТекущиеДанные, МетаРеквизит);
	КонецЕсли; 
	ирОбщий.ПолеВводаКолонкиРасширенногоЗначения_НачалоВыбораЛкс(ЭтаФорма, ТабличноеПоле, СтандартнаяОбработка,, Истина, СтруктураОтбора);

КонецПроцедуры

Процедура ПолеВводаКолонкиСписка_ОкончаниеВводаТекста(Элемент, Текст, Значение, СтандартнаяОбработка)
	
	ирОбщий.ПолеВвода_ОкончаниеВводаТекстаЛкс(Элемент, Текст, Значение, СтандартнаяОбработка);

КонецПроцедуры

Процедура ПриЗакрытии()
	
	ирОбщий.ОтменитьФоновоеЗаданиеЛкс(фОбъект.ИДФоновогоЗадания);
	СохранитьНастройкиСписка();
	ирОбщий.Форма_ПриЗакрытииЛкс(ЭтаФорма);
	
КонецПроцедуры

Процедура КП_СписокРедакторОбъектаБДЯчейки(Кнопка)
	
	ирОбщий.ОткрытьСсылкуЯчейкиВРедактореОбъектаБДЛкс(ЭлементыФормы.ДинамическийСписок);
	
КонецПроцедуры

Функция Отбор() Экспорт 
	Возврат Отбор;
КонецФункции

Функция ПользовательскийОтбор() Экспорт 
	Возврат Отбор;
КонецФункции

Процедура КП_СписокОсновнаяФорма(Кнопка)
	
	Если Не ЗначениеЗаполнено(фОбъект.ПолноеИмяТаблицы) Тогда
		Возврат;
	КонецЕсли; 
	Если РежимВыбора Тогда
		Закрыть();
	КонецЕсли; 
	ДинамическийСписок = ЭлементыФормы.ДинамическийСписок.Значение;
	Попытка
		Отбор = ДинамическийСписок.Отбор;
	Исключение
		Отбор = Неопределено;
	КонецПопытки;
	Форма = ирОбщий.ОткрытьФормуСпискаЛкс(фОбъект.ПолноеИмяТаблицы, Отбор, Ложь, ВладелецФормы, РежимВыбора, МножественныйВыбор, ЭлементыФормы.ДинамическийСписок.ТекущаяСтрока);
	Если Форма = Неопределено Тогда
		ЭтаФорма.Открыть();
	КонецЕсли; 
	
КонецПроцедуры

Процедура ВместоОсновнойПриИзменении(Элемент)
	
	ирОбщий.СохранитьЗначениеЛкс("ирДинамическийСписок.ВместоОсновной." + ПолноеИмяТаблицы, фОбъект.ВместоОсновной);

КонецПроцедуры

Процедура КП_СписокСвязанныйРедакторОбъектаБДСтроки(Кнопка)

	Если ЭлементыФормы.ДинамическийСписок.ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	ОткрытьСвязанныйРедакторОбъектаБДСтроки();
	
КонецПроцедуры

Процедура ДинамическийСписокПриАктивизацииСтроки(Элемент)
	
	ирОбщий.ТабличноеПолеПриАктивизацииСтрокиЛкс(ЭтаФорма, Элемент);
	Если мСвязанныйРедакторОбъектаБД <> Неопределено И мСвязанныйРедакторОбъектаБД.Открыта() Тогда
		ОткрытьСвязанныйРедакторОбъектаБДСтроки();
	КонецЕсли; 
	
КонецПроцедуры

Процедура ОткрытьСвязанныйРедакторОбъектаБДСтроки()
	
	ирОбщий.ОткрытьТекущуюСтрокуТабличногоПоляТаблицыБДВРедактореОбъектаБДЛкс(ЭлементыФормы.ДинамическийСписок, ПолноеИмяТаблицы,, Истина, мСвязанныйРедакторОбъектаБД,, Ложь);

КонецПроцедуры

Процедура КП_СписокРежимДерева(Кнопка)
	
	Кнопка.Пометка = Не Кнопка.Пометка;
	Если Кнопка.Пометка Тогда
		Попытка
			ЭлементыФормы.ДинамическийСписок.ИерархическийПросмотр = Истина;
		Исключение
		КонецПопытки;
	КонецЕсли;
	Попытка
		Если ЭлементыФормы.ДинамическийСписок.Дерево <> Кнопка.Пометка Тогда
			ЭлементыФормы.ДинамическийСписок.Дерево = Кнопка.Пометка;
		КонецЕсли;
	Исключение
	КонецПопытки;
	Попытка
		ЭлементыФормы.ДинамическийСписок.ИерархическийПросмотр = Истина;
	Исключение
	КонецПопытки;
	
КонецПроцедуры

Процедура КП_СписокОбновить(Кнопка)
	
	ЭлементыФормы.ДинамическийСписок.Значение.Обновить();
	
КонецПроцедуры

Процедура КП_СписокСправкаМетаданного(Кнопка)
	
	ОткрытьСправку(ирКэш.ОбъектМДПоПолномуИмениЛкс(фОбъект.ПолноеИмяТаблицы));
	
КонецПроцедуры

Процедура КП_СписокИмяСиноним(Кнопка)
	
	Если Не ЗначениеЗаполнено(фОбъект.ПолноеИмяТаблицы) Тогда
		Возврат;
	КонецЕсли; 
	фОбъект.РежимИмяСиноним = Не Кнопка.Пометка;
	Кнопка.Пометка = фОбъект.РежимИмяСиноним;
	ирОбщий.НастроитьЗаголовкиАвтоТабличногоПоляДинамическогоСпискаЛкс(ЭлементыФормы.ДинамическийСписок, фОбъект.РежимИмяСиноним);
	
КонецПроцедуры

Процедура КП_СписокОткрытьОбъектМетаданных(Кнопка)
	
	ирОбщий.ПредложитьЗакрытьМодальнуюФормуЛкс(ЭтаФорма);
	ирОбщий.ОткрытьОбъектМетаданныхЛкс(фОбъект.ПолноеИмяТаблицы);
	
КонецПроцедуры

Процедура КП_СписокСброситьНастройкиСписка(Кнопка)
	
	ирОбщий.СохранитьЗначениеЛкс("ДинамическийСписок." + фОбъект.СтарыйОбъектМетаданных + "." + РежимВыбора, Неопределено);
	УстановитьОбъектМетаданных();
	СохранитьНастройкиСписка();
	
КонецПроцедуры

Процедура КП_СписокСравнить(Кнопка)
	
	ирОбщий.СравнитьСодержимоеЭлементаУправленияЛкс(ЭтаФорма, ЭлементыФормы.ДинамическийСписок);
	
КонецПроцедуры

Процедура КП_СписокВывестиВТабличныйДокумент(Кнопка)
	
	ирОбщий.ВывестиСтрокиТабличногоПоляИПоказатьЛкс(ЭлементыФормы.ДинамическийСписок);

КонецПроцедуры

Функция ПоследниеВыбранныеНажатие(Кнопка) Экспорт
	
	ирОбщий.ПоследниеВыбранныеНажатиеЛкс(ЭтаФорма, ЭлементыФормы.ДинамическийСписок, , Кнопка);
	
КонецФункции

Процедура ОбъектМетаданныхОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ирОбщий.ОткрытьОбъектМетаданныхЛкс(ПолноеИмяТаблицы);
	
КонецПроцедуры

Процедура ОбновитьКоличествоСтрок()
	
	Если Истина
		И Не ирКэш.ЛиПортативныйРежимЛкс() 
		И Не ирКэш.ЭтоФайловаяБазаЛкс()
	Тогда
		ФоновоеЗадание = ФоновыеЗадания.НайтиПоУникальномуИдентификатору(фОбъект.ИДФоновогоЗадания);
		Если ФоновоеЗадание.Состояние = СостояниеФоновогоЗадания.Активно Тогда
			ПодключитьОбработчикОжидания("ОбновитьКоличествоСтрок", 2, Истина);
		Иначе
			//// Антибаг 8.3.13  В обычной форме в клиент-серверном режиме из временного хранилища возвращается Неопределено https://partners.v8.1c.ru/forum/t/1768363/m/1768363
			//ФормаРезультатФоновогоЗадания.ОбновитьВременноеХранилище(фОбъект.АдресХранилищаКоличестваСтрок);
			Результат = ПолучитьИзВременногоХранилища(фОбъект.АдресХранилищаКоличестваСтрок);
			УдалитьИзВременногоХранилища(фОбъект.АдресХранилищаКоличестваСтрок);
		КонецЕсли; 
	Иначе
		// www.hostedredmine.com/issues/884199
	КонецЕсли;
	Если Результат <> Неопределено Тогда
		фОбъект.КоличествоСтрокВОбластиПоиска = Результат;
	КонецЕсли; 

КонецПроцедуры

Процедура НастройкаКолонок(Команда)
	
	СохранитьНастройкиСписка();
	ФормаНастроек = ирОбщий.ПолучитьФормуЛкс("Обработка.ирДинамическийСписок.Форма.НастройкиКолонок",, ЭтаФорма);
	ЗаполнитьЗначенияСвойств(ФормаНастроек, фОбъект); 
	ФормаНастроек.ОбработкаОбъектСлужебная.НастройкиКолонок.Загрузить(НастройкиКолонок.Выгрузить());
	ПоляТаблицы = ирКэш.ПоляТаблицыБДЛкс(ПолноеИмяТаблицы);
	#Если Сервер И Не Сервер Тогда
		ПоляТаблицы = Новый ТаблицаЗначений;
	#КонецЕсли
	Для Каждого СтрокаНастройкиКолонки Из ФормаНастроек.ОбработкаОбъектСлужебная.НастройкиКолонок Цикл
		ДоступноеПоле = ПоляТаблицы.Найти(СтрокаНастройкиКолонки.Имя, "Имя");
		Если ДоступноеПоле = Неопределено Тогда
			Продолжить;
		КонецЕсли; 
		СтрокаНастройкиКолонки.ТипЗначения = ДоступноеПоле.ТипЗначения;
	КонецЦикла;
	Если ЭлементыФормы.ДинамическийСписок.ТекущаяКолонка <> Неопределено Тогда
		ФормаНастроек.ПараметрИмяТекущейКолонки = ЭлементыФормы.ДинамическийСписок.ТекущаяКолонка.Имя;
	КонецЕсли; 
	ВыбранноеЗначение = ФормаНастроек.ОткрытьМодально();
	ОбработатьВыборНастроекКолонок(ВыбранноеЗначение);
	
КонецПроцедуры

Процедура ОбработатьВыборНастроекКолонок(Знач ВыбранноеЗначение)
	
	СтарыеНастройки = фОбъект.НастройкиКолонок.Выгрузить();
	Если ВыбранноеЗначение <> Неопределено Тогда
			#Если Сервер И Не Сервер Тогда
			    ВыбранноеЗначение = Новый Структура;
			#КонецЕсли
		Если ВыбранноеЗначение.Свойство("НастройкиКолонок") Тогда
			Если ВыбранноеЗначение.ПрименятьПорядок Тогда
				фОбъект.НастройкиКолонок.Загрузить(ВыбранноеЗначение.НастройкиКолонок);
			Иначе
				Для Каждого СтрокаКолонки Из фОбъект.НастройкиКолонок Цикл
					СтрокаНастройки = ВыбранноеЗначение.НастройкиКолонок.Найти(СтрокаКолонки.Имя, "Имя");
					ЗаполнитьЗначенияСвойств(СтрокаКолонки, СтрокаНастройки,, "Имя"); 
				КонецЦикла;
			КонецЕсли; 
		КонецЕсли; 
		Если ВыбранноеЗначение.Свойство("ТекущаяКолонка") Тогда
			ЭлементыФормы.ДинамическийСписок.ТекущаяКолонка = ЭлементыФормы.ДинамическийСписок.Колонки.Найти(ВыбранноеЗначение.ТекущаяКолонка);
		КонецЕсли; 
	КонецЕсли;
	ПрименитьНастройкиКолонок();
	Если ВыбранноеЗначение <> Неопределено И ВыбранноеЗначение.Свойство("Сохранить") И ВыбранноеЗначение.Сохранить Тогда
		СохранитьНастройкиСписка();
	Иначе
		фОбъект.НастройкиКолонок.Загрузить(СтарыеНастройки);
	КонецЕсли; 

КонецПроцедуры

Процедура ОбработкаВыбора(ВыбранноеЗначение, Источник)
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Структура") Тогда
		ОбработатьВыборНастроекКолонок(ВыбранноеЗначение);
	КонецЕсли; 
	
КонецПроцедуры

Процедура НадписьПраваДоступаКСтрокамНажатие(Элемент)
	
	Форма = ирОбщий.ПолучитьФормуЛкс("Отчет.ирАнализПравДоступа.Форма",,, фОбъект.ПолноеИмяТаблицы);
	Форма.ОбъектМетаданных = фОбъект.ПолноеИмяТаблицы;
	Форма.Пользователь = ИмяПользователя();
	Форма.ПараметрКлючВарианта = "ПоПользователям";
	Форма.Открыть();
	
КонецПроцедуры

Процедура ДобавитьСтрокуЧерезРедакторОбъектаБД(Кнопка = Неопределено, Копирование = Неопределено, ЭтоГруппа = Ложь)
	
	ИмяПоляСсылка = ирОбщий.ПеревестиСтроку("Ссылка");
	ИмяПоляЭтоГруппа = ирОбщий.ПеревестиСтроку("ЭтоГруппа");
	Если Копирование = Неопределено Тогда
		Если ЭлементыФормы.ДинамическийСписок.ТекущаяСтрока <> Неопределено Тогда
			Ответ = Вопрос("Хотите скопировать текущую строку?", РежимДиалогаВопрос.ДаНет,, КодВозвратаДиалога.Нет);
			Копирование = Ответ = КодВозвратаДиалога.Да;
		Иначе
			Копирование = Ложь;
		КонецЕсли; 
	КонецЕсли; 
	ОбъектМД = ирКэш.ОбъектМДПоПолномуИмениЛкс(фОбъект.ПолноеИмяТаблицы);
	Если ирОбщий.ЛиКорневойТипСсылочногоОбъектаБДЛкс(ирОбщий.ПервыйФрагментЛкс(фОбъект.ПолноеИмяТаблицы)) Тогда
		Если ПравоДоступа("Добавление", ОбъектМД) Тогда
			ЭлементОтбораЭтоГруппа = ЭлементыФормы.ДинамическийСписок.Значение.Отбор.Найти(ИмяПоляЭтоГруппа);
			Если Копирование Тогда
				СтруктураОбъекта = ирОбщий.ОбъектБДПоКлючуЛкс(фОбъект.ПолноеИмяТаблицы, ЭлементыФормы.ДинамическийСписок.ТекущаяСтрока);
				СтруктураОбъекта = ирОбщий.КопияОбъектаБДЛкс(СтруктураОбъекта);
			Иначе
				ЭтоГруппа = Ложь
					Или ЭтоГруппа = Истина
					Или (Истина
						И ирОбщий.ЛиМетаданныеОбъектаСГруппамиЛкс(ОбъектМД)
						И ЭлементОтбораЭтоГруппа <> Неопределено
						И ЭлементОтбораЭтоГруппа.Использование = Истина
						И ЭлементОтбораЭтоГруппа.ВидСравнения = ВидСравнения.Равно
						И ЭлементОтбораЭтоГруппа.Значение = Истина);
				СтруктураОбъекта = ирОбщий.ОбъектБДПоКлючуЛкс(фОбъект.ПолноеИмяТаблицы, ЭтоГруппа);
			КонецЕсли; 
			ирОбщий.УстановитьЗначенияРеквизитовПоОтборуЛкс(СтруктураОбъекта.Данные, ЭлементыФормы.ДинамическийСписок.Значение.Отбор);
			ирОбщий.ОткрытьОбъектВРедактореОбъектаБДЛкс(СтруктураОбъекта);
		Иначе
			ирОбщий.ОткрытьОбъектВРедактореОбъектаБДЛкс(Новый(ирОбщий.ИмяТипаИзПолногоИмениТаблицыБДЛкс(фОбъект.ПолноеИмяТаблицы, "Ссылка")));
		КонецЕсли; 
	Иначе
		КлючОбъекта = ирОбщий.СтруктураКлючаТаблицыБДЛкс(фОбъект.ПолноеИмяТаблицы, Ложь);
		Для Каждого КлючИЗначение Из КлючОбъекта Цикл
			Если Копирование Тогда
				КлючОбъекта[КлючИЗначение.Ключ] = ЭлементыФормы.ДинамическийСписок.ТекущаяСтрока[КлючИЗначение.Ключ];
			Иначе
				КлючОбъекта[КлючИЗначение.Ключ] = Неопределено;
			КонецЕсли; 
		КонецЦикла;
		СтруктураОбъекта = ирОбщий.ОбъектБДПоКлючуЛкс(фОбъект.ПолноеИмяТаблицы, КлючОбъекта);
		ирОбщий.ОткрытьСсылкуВРедактореОбъектаБДЛкс(СтруктураОбъекта);
	КонецЕсли; 
	
КонецПроцедуры

Процедура КП_СписокНайтиВыбратьПоID(Кнопка)
	
	Если Не ЗначениеЗаполнено(фОбъект.ПолноеИмяТаблицы) Тогда
		Возврат;
	КонецЕсли; 
	ирОбщий.НайтиВыбратьСсылкуВДинамическомСпискеПоIDЛкс(ЭлементыФормы.ДинамическийСписок, ЭтаФорма);
	
КонецПроцедуры

Процедура КоличествоСтрокВОбластиПоискаОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	фОбъект.КоличествоСтрокВОбластиПоиска = ирОбщий.КоличествоСтрокВТаблицеБДЛкс(фОбъект.ПолноеИмяТаблицы);
	
КонецПроцедуры

Процедура ВнешнееСобытие(Источник, Событие, Данные)
	
	ирОбщий.Форма_ВнешнееСобытиеЛкс(ЭтаФорма, Источник, Событие, Данные);

КонецПроцедуры

ирОбщий.ИнициализироватьФормуЛкс(ЭтаФорма, "Обработка.ирДинамическийСписок.Форма.Форма");
Если КлючУникальности = "Связанный" Тогда
	ЭтаФорма.Заголовок = ЭтаФорма.Заголовок + " (связанный)";
КонецЕсли;
Построитель = Новый ПостроительЗапроса;
