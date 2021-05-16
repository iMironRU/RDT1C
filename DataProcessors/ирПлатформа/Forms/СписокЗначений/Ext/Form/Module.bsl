﻿Перем РасширениеФайла;

Функция ПолучитьРезультат()
	
	Результат = Новый СписокЗначений;
	Результат.ТипЗначения = ОписаниеТипов;
	Для Каждого СтрокаТаблицы Из Таблица Цикл
		ЭлементСписка = Результат.Добавить();
		ЗаполнитьЗначенияСвойств(ЭлементСписка, СтрокаТаблицы); 
	КонецЦикла; 
	Возврат Результат;

КонецФункции

Процедура ОсновныеДействияФормыОК(Кнопка = Неопределено)
	
	Модифицированность = Ложь;
	ирОбщий.ПрименитьИзмененияИЗакрытьФормуЛкс(ЭтаФорма, ПолучитьРезультат());
	
КонецПроцедуры

Процедура УстановитьРедактируемоеЗначение(НовоеЗначение, РазрешитьПропускНеуникальных = Истина)
	
	ОписаниеТипов = НовоеЗначение.ТипЗначения;
	ЗагрузитьЭлементыСписка(НовоеЗначение,, РазрешитьПропускНеуникальных);
	ОбновитьВидимостьКолонок();
	
КонецПроцедуры

Процедура ЗагрузитьЭлементыСписка(НовоеЗначение, ОчиститьПередЗагрузкой = Истина, РазрешитьПропускНеуникальных = Истина)

	Если ОчиститьПередЗагрузкой Тогда
		Таблица.Очистить();
	КонецЕсли; 
	ЕстьПометки = Ложь;
	ЕстьПредставление = Ложь;
	ПропускатьНеуникальные = РазрешитьПропускНеуникальных = Истина И Уникальные И НовоеЗначение.Количество() < 1000;
	Для Индекс = 0 По НовоеЗначение.Количество() - 1 Цикл
		ЗначениеЭлемента = НовоеЗначение[Индекс];
		Если ПропускатьНеуникальные Тогда 
			СтрокаТаблицы = Таблица.Найти(ЗначениеЭлемента.Значение, "Значение");
			Если СтрокаТаблицы <> Неопределено Тогда
				Продолжить;
			КонецЕсли; 
		КонецЕсли;
	    НоваяСтрока = Таблица.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ЗначениеЭлемента); 
		ОбновитьПредставлениеИТипЗначенияВСтроке(НоваяСтрока);
		Если НоваяСтрока.Пометка Тогда
			ЕстьПометки = Истина;
		КонецЕсли; 
		Если ЗначениеЗаполнено(НоваяСтрока.Представление) Тогда
			ЕстьПредставление = Истина;
		КонецЕсли; 
		Если НачальныйЭлементСписка = ЗначениеЭлемента Тогда
			ЭлементыФормы.Таблица.ТекущаяСтрока = НоваяСтрока;
		КонецЕсли; 
	КонецЦикла;
	ЭлементыФормы.Таблица.Колонки.Пометка.Видимость = ЕстьПометки;
	ЭлементыФормы.Таблица.Колонки.Представление.Видимость = ЕстьПредставление;

КонецПроцедуры

Процедура ПриОткрытии()
	
	ирОбщий.Форма_ПриОткрытииЛкс(ЭтаФорма);
	Если ТипЗнч(НачальноеЗначениеВыбора) <> Тип("СписокЗначений") Тогда
		НачальноеЗначениеВыбора = Новый СписокЗначений();
	КонецЕсли;
	Если Не МодальныйРежим Тогда
		ирОбщий.ОбновитьТекстПослеМаркераВСтрокеЛкс(ЭтаФорма.Заголовок,, ирОбщий.ПоследнийФрагментЛкс(ТекущаяДата(), " "), ":");
	КонецЕсли; 
	УстановитьРедактируемоеЗначение(НачальноеЗначениеВыбора, Ложь);
	ЭлементыФормы.Таблица.ТолькоПросмотр = ТолькоПросмотр; // Чтобы открытие ссылок из ячеек работало
	ЭтаФорма.Модифицированность = Ложь;

КонецПроцедуры

Процедура ТабличноеПоле1ПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки) Экспорт
	
	ирОбщий.ТабличноеПолеПриВыводеСтрокиЛкс(ЭтаФорма, Элемент, ОформлениеСтроки, ДанныеСтроки);
	ОформлениеСтроки.Ячейки.ТипЗначения.УстановитьТекст(ТипЗнч(ДанныеСтроки.Значение));
	ОформлениеСтроки.Ячейки.Номер.УстановитьТекст(Элемент.Значение.Индекс(ДанныеСтроки) + 1);
	ирОбщий.ОформитьЯчейкуСРасширеннымЗначениемЛкс(ОформлениеСтроки.Ячейки.ПредставлениеЗначения, ДанныеСтроки.Значение, Элемент.Колонки.ПредставлениеЗначения);

КонецПроцедуры

Процедура ОсновныеДействияФормыИсследовать()
	
	ирОбщий.ИсследоватьЛкс(ПолучитьРезультат());
	
КонецПроцедуры

Процедура ОбновлениеОтображения()
	
	Количество = Таблица.Количество();
	
КонецПроцедуры

Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Ответ = ирОбщий.ЗапроситьСохранениеДанныхФормыЛкс(ЭтаФорма);
	Если Ответ = КодВозвратаДиалога.Отмена Тогда
		Отказ = Истина;
		Возврат;
	ИначеЕсли Ответ = КодВозвратаДиалога.Да Тогда
		Модифицированность = Ложь;
		ОсновныеДействияФормыОК();
	КонецЕсли;

КонецПроцедуры

Процедура ОбновитьВидимостьКолонок()
	
	ЛиПростойСписок = ОписаниеТипов.Типы().Количество() = 1;
	ЭлементыФормы.Таблица.Колонки.ТипЗначения.Видимость = Не ЛиПростойСписок;
	
КонецПроцедуры

Процедура ОписаниеТиповНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	РезультатВыбора = ирОбщий.РедактироватьОписаниеРедактируемыхТиповЛкс(Элемент);
	Если РезультатВыбора <> Неопределено Тогда
		Элемент.Значение = РезультатВыбора;
		ОбновитьВидимостьКолонок();
	КонецЕсли; 
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

Процедура КоманднаяПанель1ЗагрузитьИзФайла(Кнопка)
	
	 Результат = ирОбщий.ЗагрузитьЗначениеИзФайлаИнтерактивноЛкс(РасширениеФайла);
	 Если ТипЗнч(Результат) = Тип("СписокЗначений") Тогда
		 УстановитьРедактируемоеЗначение(Результат, Истина);
	 КонецЕсли; 
	 
КонецПроцедуры

Процедура КоманднаяПанель1СохранитьВФайл(Кнопка)
	
	ирОбщий.СохранитьЗначениеВФайлИнтерактивноЛкс(ПолучитьРезультат(), РасширениеФайла);
	
КонецПроцедуры

Процедура КоманднаяПанель1Подбор(Кнопка)
	
	ТекущаяСтрока = ЭлементыФормы.Таблица.ТекущаяСтрока;
	Если ТекущаяСтрока <> Неопределено Тогда
		НачальноеЗначениеВыбораЛ = ТекущаяСтрока.Значение;
	КонецЕсли;
	ирОбщий.ОткрытьПодборСВыборомТипаЛкс(ЭлементыФормы.Таблица, ОписаниеТипов, НачальноеЗначениеВыбораЛ,, Истина);

КонецПроцедуры

Процедура ТаблицаОбработкаВыбора(Элемент = Неопределено, ВыбранноеЗначение, СтандартнаяОбработка = Неопределено)
	
	Если Истина
		И ТипЗнч(ВыбранноеЗначение) <> Тип("Массив") 
		И ТипЗнч(ВыбранноеЗначение) <> Тип("Структура")
	Тогда
		лЗначение = ВыбранноеЗначение;
		ВыбранноеЗначение = Новый Массив();
		ВыбранноеЗначение.Добавить(лЗначение);
	КонецЕсли; 
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Массив") Тогда 
		ЛиПроизвольныйТип = ОписаниеТипов.Типы().Количество() = 0;
		ПроверятьУникальность = Уникальные И ВыбранноеЗначение.Количество() < 1000;
		Для Каждого лЗначение Из ВыбранноеЗначение Цикл
			Если Ложь
				Или ЛиПроизвольныйТип
				Или ОписаниеТипов.СодержитТип(ТипЗнч(лЗначение)) 
			Тогда
				Если ПроверятьУникальность Тогда 
					СтрокаТаблицы = Таблица.Найти(лЗначение, "Значение");
				Иначе
					СтрокаТаблицы = Неопределено;
				КонецЕсли;
				Если СтрокаТаблицы = Неопределено Тогда
					СтрокаТаблицы = Таблица.Добавить();
					СтрокаТаблицы.Значение = лЗначение;
					ОбновитьПредставлениеИТипЗначенияВСтроке(СтрокаТаблицы);
					ЭтаФорма.Модифицированность = Истина;
				КонецЕсли; 
			КонецЕсли; 
		КонецЦикла;
		Если СтрокаТаблицы <> Неопределено Тогда
			ЭлементыФормы.Таблица.ТекущаяСтрока = СтрокаТаблицы;
		КонецЕсли; 
	КонецЕсли; 
	
КонецПроцедуры

Процедура ОсновныеДействияФормыРедактироватьКопию(Кнопка)
	
	ирОбщий.ПредложитьЗакрытьМодальнуюФормуЛкс(ЭтаФорма);
	ирОбщий.ОткрытьЗначениеЛкс(ПолучитьРезультат(),,,, Ложь);

КонецПроцедуры

Процедура ТаблицаПредставлениеЗначенияПриИзменении(Элемент)
	
	ТабличноеПоле = ЭтаФорма.ЭлементыФормы.Таблица;
	ТабличноеПоле.ТекущиеДанные.Значение = Элемент.Значение;
	ОбновитьПредставлениеИТипЗначенияВСтроке();

КонецПроцедуры

Процедура ТаблицаПредставлениеЗначенияНачалоВыбора(Элемент, СтандартнаяОбработка)

	ирОбщий.ПолеВводаКолонкиРасширенногоЗначения_НачалоВыбораЛкс(ЭтаФорма, ЭлементыФормы.Таблица, СтандартнаяОбработка, ЭлементыФормы.Таблица.ТекущаяСтрока.Значение, Истина);
	ОбновитьПредставлениеИТипЗначенияВСтроке();

КонецПроцедуры

Процедура ТаблицаПредставлениеЗначенияОкончаниеВводаТекста(Элемент, Текст, Значение, СтандартнаяОбработка)
	
	ирОбщий.ПолеВвода_ОкончаниеВводаТекстаЛкс(Элемент, Текст, Значение, СтандартнаяОбработка, ЭлементыФормы.Таблица.ТекущаяСтрока.Значение);

КонецПроцедуры

Процедура ОбновитьПредставлениеИТипЗначенияВСтроке(СтрокаТаблицы = Неопределено)
	
	Если СтрокаТаблицы = Неопределено Тогда
		СтрокаТаблицы = ЭлементыФормы.Таблица.ТекущиеДанные;
	КонецЕсли; 
	//СтрокаТаблицы.ТипЗначения = ТипЗнч(СтрокаТаблицы.Значение);
	СтрокаТаблицы.ПредставлениеЗначения = СтрокаТаблицы.Значение;
	
КонецПроцедуры

Процедура ТаблицаПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если Истина
		И НоваяСтрока 
		И Не Копирование
	Тогда
		СтрокаТаблицы = ЭлементыФормы.Таблица.ТекущиеДанные;
		СтрокаТаблицы.Значение = ОписаниеТипов.ПривестиЗначение(Неопределено);
		СтрокаТаблицы.ПредставлениеЗначения = СтрокаТаблицы.Значение;
	КонецЕсли; 
	
КонецПроцедуры

Процедура СтруктураКоманднойПанелиНажатие(Кнопка)
	
	ирОбщий.ОткрытьСтруктуруКоманднойПанелиЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура КоманднаяПанель1ЗаполнитьЗапросом(Кнопка)
	
	КоллекцияДляЗаполнения = Новый ТаблицаЗначений;
	КоллекцияДляЗаполнения.Колонки.Добавить("Значение", ОписаниеТипов);
	КонсольЗапросов = ирОбщий.СоздатьОбъектПоПолномуИмениМетаданныхЛкс("Обработка.ирКонсольЗапросов");
	#Если Сервер И Не Сервер Тогда
		КонсольЗапросов = Обработки.ирКонсольЗапросов.Создать();
	#КонецЕсли
	РезультатЗапроса = КонсольЗапросов.ОткрытьДляЗаполненияКоллекции(КоллекцияДляЗаполнения);
	Если РезультатЗапроса = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ОчиститьТаблицу = Ложь;
	Если Таблица.Количество() > 0 Тогда
		Ответ = Вопрос("Очистить строки таблицы перед загрузкой результата запроса?", РежимДиалогаВопрос.ДаНет);
		Если Ответ = КодВозвратаДиалога.Да Тогда
			ОчиститьТаблицу = Истина;
		КонецЕсли;
	КонецЕсли; 
	ЗагрузитьЭлементыСписка(РезультатЗапроса, ОчиститьТаблицу);
	
КонецПроцедуры

Процедура КлсКомандаНажатие(Кнопка) Экспорт 
	
	ирОбщий.УниверсальнаяКомандаФормыЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура ОбработчикОжиданияСПараметрамиЛкс() Экспорт 
	
	ирОбщий.ОбработчикОжиданияСПараметрамиЛкс();

КонецПроцедуры

Процедура КоманднаяПанель1РедакторОбъектаБД(Кнопка)
	
	ирОбщий.ПредложитьЗакрытьМодальнуюФормуЛкс(ЭтаФорма);
	ирОбщий.ОткрытьСсылкуЯчейкиВРедактореОбъектаБДЛкс(ЭлементыФормы.Таблица, "Значение");
	
КонецПроцедуры

Процедура КоманднаяПанель1ВМассив(Кнопка)
	
	ирОбщий.ОткрытьЗначениеЛкс(ПолучитьРезультат().ВыгрузитьЗначения(),,,, Ложь);
	
КонецПроцедуры

Процедура КоманднаяПанель1ИзМассива(Кнопка)
	
	Результат = ирОбщий.ЗагрузитьЗначениеИзФайлаИнтерактивноЛкс("VA_");
	Если ТипЗнч(Результат) = Тип("Массив") Тогда
		Список = Новый СписокЗначений;
		Список.ЗагрузитьЗначения(Результат);
		УстановитьРедактируемоеЗначение(Список);
	КонецЕсли; 
	
КонецПроцедуры

Процедура КоманднаяПанель1КонсольОбработки(Кнопка)
	
	ирОбщий.ПредложитьЗакрытьМодальнуюФормуЛкс(ЭтаФорма);
	ирОбщий.ОткрытьОбъектыИзВыделенныхЯчеекВПодбореИОбработкеОбъектовЛкс(ЭлементыФормы.Таблица, "Значение", ЭтаФорма);
	
КонецПроцедуры

Процедура КоманднаяПанель1ВТаблицу(Кнопка)
	
	ТаблицаЛ = Новый ТаблицаЗначений;
	ТаблицаЛ.Колонки.Добавить("Значение", ОписаниеТипов);
	ТаблицаЛ.Колонки.Добавить("Представление", Новый ОписаниеТипов("Строка"));
	Для Каждого СтрокаСписка Из Таблица Цикл
		ЗаполнитьЗначенияСвойств(ТаблицаЛ.Добавить(), СтрокаСписка); 
	КонецЦикла;
	ирОбщий.ОткрытьЗначениеЛкс(ТаблицаЛ,,,, Ложь);
	
КонецПроцедуры

Процедура КоманднаяПанель1ИзТекста(Кнопка)
	
	ФормаРазбивки = ПолучитьФорму("РазбивкаТекста");
	РезультатФормы = ФормаРазбивки.ОткрытьМодально();
	Если РезультатФормы <> Неопределено Тогда
		#Если Сервер И Не Сервер Тогда
			РезультатФормы = Новый Массив;
		#КонецЕсли
		Если Истина
			И ОписаниеТипов.Типы().Количество() = 1 
			И Не ОписаниеТипов.СодержитТип(Тип("Строка")) 
		Тогда
			ЗагрузкаТабличныхДанных = ирОбщий.СоздатьОбъектПоПолномуИмениМетаданныхЛкс("Обработка.ирЗагрузкаТабличныхДанных");
			#Если Сервер И Не Сервер Тогда
			    ЗагрузкаТабличныхДанных = Обработки.ирЗагрузкаТабличныхДанных.Создать();
			#КонецЕсли
			Форма = ЗагрузкаТабличныхДанных.ПолучитьФорму();
			ТаблицаЗначений = Новый ТаблицаЗначений;
			ТаблицаЗначений.Колонки.Добавить("Значение", ОписаниеТипов);
			Форма.ТаблицаЗначений = ТаблицаЗначений;
			ТабличныйДокумент = Новый ТабличныйДокумент;
			ТабличныйДокумент.Область(1, 1).Текст = "Значение";
			ТабличныйДокумент.Область(1, 1).Шрифт = Новый Шрифт(,, Истина);
			Для Счетчик = 1 По РезультатФормы.Количество() Цикл
				ТабличныйДокумент.Область(Счетчик + 1, 1).Текст = РезультатФормы[Счетчик - 1];
			КонецЦикла;
			Форма.ПараметрТабличныйДокумент = ТабличныйДокумент;
			Форма.РежимРедактора = Истина;
			РезультатКонвертации = Форма.ОткрытьМодально();
			Если РезультатКонвертации <> Неопределено Тогда
				РезультатФормы = Форма.ТаблицаЗначений.ВыгрузитьКолонку("Значение");
			КонецЕсли; 
		КонецЕсли;
		Список = Новый СписокЗначений;
		Список.ТипЗначения = ОписаниеТипов;
		Список.ЗагрузитьЗначения(РезультатФормы);
		УстановитьРедактируемоеЗначение(Список);
	КонецЕсли; 
	
КонецПроцедуры

Процедура ТаблицаВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	Если РежимВыбора Тогда
		ирОбщий.ПрименитьИзмененияИЗакрытьФормуЛкс(ЭтаФорма, ВыбраннаяСтрока);
	Иначе
		Если Колонка = ЭлементыФормы.Таблица.Колонки.ПредставлениеЗначения Тогда 
			ирОбщий.ЯчейкаТабличногоПоляРасширенногоЗначения_ВыборЛкс(ЭтаФорма, Элемент, СтандартнаяОбработка, ВыбраннаяСтрока.Значение);
		КонецЕсли; 
	КонецЕсли; 

КонецПроцедуры

Процедура ТаблицаПриИзмененииФлажка(Элемент, Колонка)
	
	ирОбщий.ТабличноеПолеПриИзмененииФлажкаЛкс(ЭтаФорма, Элемент, Колонка);

КонецПроцедуры

Процедура ТаблицаПриАктивизацииСтроки(Элемент)
	
	ирОбщий.ТабличноеПолеПриАктивизацииСтрокиЛкс(ЭтаФорма, Элемент);

КонецПроцедуры

Процедура ВнешнееСобытие(Источник, Событие, Данные) Экспорт
	
	ирОбщий.Форма_ВнешнееСобытиеЛкс(ЭтаФорма, Источник, Событие, Данные);

КонецПроцедуры

Процедура КоманднаяПанель1УстановитьФлажки(Кнопка)
	
	ирОбщий.ИзменитьПометкиВыделенныхИлиОтобранныхСтрокЛкс(ЭлементыФормы.Таблица,, Истина,,, Ложь);

КонецПроцедуры

Процедура КоманднаяПанель1СнятьФлажки(Кнопка)
	
	ирОбщий.ИзменитьПометкиВыделенныхИлиОтобранныхСтрокЛкс(ЭлементыФормы.Таблица,, Ложь,,, Ложь);

КонецПроцедуры

Процедура ТабличноеПолеПриПолученииДанных(Элемент, ОформленияСтрок) Экспорт 
	
	ирОбщий.ТабличноеПолеПриПолученииДанныхЛкс(ЭтаФорма, Элемент, ОформленияСтрок);

КонецПроцедуры

Процедура УникальныеПриИзменении(Элемент)
	
	Если Уникальные Тогда
		СостояниеСтрок = ирОбщий.ТабличноеПолеСостояниеСтрокЛкс(ЭлементыФормы.Таблица, "Значение");
		ЗагрузитьЭлементыСписка(ПолучитьРезультат());
		ирОбщий.ТабличноеПолеВосстановитьСостояниеСтрокЛкс(ЭлементыФормы.Таблица, СостояниеСтрок);
	КонецЕсли; 
	
КонецПроцедуры

Процедура ПриЗакрытии()
	ирОбщий.Форма_ПриЗакрытииЛкс(ЭтаФорма);
КонецПроцедуры

Процедура КоманднаяПанель1ВБуферОбмена(Кнопка)
	
	ирОбщий.БуферОбмена_УстановитьЗначениеЛкс(ПолучитьРезультат());
	
КонецПроцедуры

Процедура КоманднаяПанель1ИзБуферОбмена(Кнопка)
	
	ОбъектИзБуфера = ирОбщий.БуферОбмена_ПолучитьЗначениеЛкс();
	Если ТипЗнч(ОбъектИзБуфера) = Тип("СписокЗначений") Тогда
		УстановитьРедактируемоеЗначение(ОбъектИзБуфера);
		ЭтаФорма.Модифицированность = Истина;
	ИначеЕсли ТипЗнч(ОбъектИзБуфера) = Тип("Массив") Тогда
		Список = Новый СписокЗначений;
		Список.ЗагрузитьЗначения(ОбъектИзБуфера);
		УстановитьРедактируемоеЗначение(Список);
		ЭтаФорма.Модифицированность = Истина;
	КонецЕсли; 
	
КонецПроцедуры

ирОбщий.ИнициироватьФормуЛкс(ЭтаФорма, "Обработка.ирПлатформа.Форма.СписокЗначений");

РасширениеФайла = "VL_";
Уникальные = Истина;
ОписаниеТипов = Новый ОписаниеТипов();
Таблица.Колонки.Добавить("Значение", ОписаниеТипов);
