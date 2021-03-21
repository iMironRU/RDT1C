﻿Перем МассивУровнейЖурнала;
Перем СтруктураКолонокБезОтбора;
Перем СтарыйОтбор;

Функция СохраняемаяНастройкаФормы(выхНаименование, выхИменаСвойств) Экспорт 
	НастройкаФормы = ирОбщий.КопияОбъектаЛкс(ОписаниеВариантаОтбора());
	выхНаименование = ПредставлениеВариантаОтбора(НастройкаФормы);
	Возврат НастройкаФормы;
КонецФункции

Процедура ЗагрузитьНастройкуВФорме(НастройкаФормы, ДопПараметры) Экспорт 
	
	Если НастройкаФормы.Свойство("НачалоПериода") Тогда
		ЭтотОбъект.НачалоПериода = НастройкаФормы.НачалоПериода;
		ЭтотОбъект.КонецПериода = НастройкаФормы.КонецПериода;
	КонецЕсли; 
	ЭтотОбъект.МаксимальныйРазмерВыгрузки = НастройкаФормы.МаксимальныйРазмерВыгрузки;
	Если НастройкаФормы.Свойство("АлгоритмПередВыгрузкой") Тогда
		ЭтотОбъект.АлгоритмПередВыгрузкой = НастройкаФормы.АлгоритмПередВыгрузкой;
	КонецЕсли; 
	Отбор.Очистить();
	ирОбщий.ЗагрузитьВТаблицуЗначенийЛкс(НастройкаФормы.Отбор, Отбор);
	НастроитьЭлементыФормы();
	
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

Процедура ТаблицаВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	СтрокаТаблицыЗначений = ТаблицаЗначенийЖурнала.Найти(ВыбраннаяСтрока.ПорядокСтроки, "ПорядокСтроки");
	//ирОбщий.ЯчейкаТабличногоПоляРасширенногоЗначения_ВыборЛкс(ЭтаФорма, Элемент, СтандартнаяОбработка, СтрокаТаблицыЗначений[Колонка.Данные]);
	ФормаСобытия = ПолучитьФорму("ФормаСобытия",, ВыбраннаяСтрока.ПорядокСтроки);
	ФормаСобытия.НачальноеЗначениеВыбора = ВыбраннаяСтрока;
	ФормаСобытия.СтрокаТаблицыЗначений = СтрокаТаблицыЗначений;
	ФормаСобытия.Открыть();

КонецПроцедуры

Процедура ОбновитьТаблицуЖурнала() Экспорт
	
	#Если Сервер И Не Сервер Тогда
		ВыгрузкаЗавершитьВФорме();
	#КонецЕсли
	ЗагрузитьДанныеЖурнала(ЭтаФорма, ЭлементыФормы.ДействияФормы.Кнопки.Обновить, "ВыгрузкаЗавершитьВФорме");
	
КонецПроцедуры

// Предопределеный метод
Процедура ПроверкаЗавершенияФоновыхЗаданий() Экспорт 
	
	ирОбщий.ПроверитьЗавершениеФоновыхЗаданийФормыЛкс(ЭтаФорма);
	
КонецПроцедуры

Процедура ВыгрузкаЗавершитьВФорме(СостояниеЗадания = Неопределено, РезультатЗадания = Неопределено) Экспорт 
	
	Если Ложь
		Или СостояниеЗадания = Неопределено
		Или СостояниеЗадания = СостояниеФоновогоЗадания.Завершено 
	Тогда
		ирОбщий.СостояниеЛкс("Загрузка выгрузки журнала регистрации");
		Если ЭлементыФормы.ТаблицаЖурнала.ТекущаяСтрока <> Неопределено Тогда
			КлючТекущейСтроки = Новый Структура();
			Для Каждого Колонка Из Метаданные().ТабличныеЧасти.ТаблицаЖурнала.Реквизиты Цикл
				Если Колонка.Имя = "ПорядокСтроки" Тогда
					Продолжить;
				КонецЕсли; 
				КлючТекущейСтроки.Вставить(Колонка.Имя, ЭлементыФормы.ТаблицаЖурнала.ТекущаяСтрока[Колонка.Имя]);
			КонецЦикла;
		КонецЕсли;
		Если ЗначениеЗаполнено(СостояниеЗадания) Тогда
			ЭтотОбъект.ТаблицаЗначенийЖурнала = РезультатЗадания.ТаблицаЗначенийЖурнала;
		КонецЕсли;
		ТаблицаЖурнала.Загрузить(ТаблицаЗначенийЖурнала);
		ЭлементыФормы.ТаблицаЖурнала.Колонки.РазделениеДанныхСеанса.Видимость = ТаблицаЗначенийЖурнала.Колонки.Найти("РазделениеДанныхСеанса") <> Неопределено;
		ТекущаяСтрокаУстановлена = Ложь;
		Если КлючТекущейСтроки <> Неопределено Тогда
			НайденныеСтроки = ТаблицаЖурнала.НайтиСтроки(КлючТекущейСтроки);
			Если НайденныеСтроки.Количество() > 0 Тогда
				ЭлементыФормы.ТаблицаЖурнала.ТекущаяСтрока = НайденныеСтроки[0];
				ТекущаяСтрокаУстановлена = Истина;
			КонецЕсли; 
		КонецЕсли; 
		Если Не ТекущаяСтрокаУстановлена Тогда
			Если ТаблицаЖурнала.Количество() > 0 Тогда
				ЭлементыФормы.ТаблицаЖурнала.ТекущаяСтрока = ТаблицаЖурнала[ТаблицаЖурнала.Количество() - 1];
			КонецЕсли; 
		КонецЕсли; 
		ЭлементыФормы.ТаблицаЖурнала.Колонки.ДлительностьТранзакции.Видимость = РезультатЗадания.АнализироватьТранзакцииСУчастиемОбъекта;
		ЭтотОбъект.КоличествоСтрокЖурнала = ТаблицаЖурнала.Количество();
		Если МаксимальныйРазмерВыгрузки > 0 И МаксимальныйРазмерВыгрузки = ТаблицаЖурнала.Количество() Тогда
			ирОбщий.СообщитьЛкс("Выгрузка прервана по максимально допустимому количеству сообщений");
		КонецЕсли;
		ДлительностьСекунд = ТекущаяДата() - РезультатЗадания.МоментНачала;
		ДлительностьСтрока = ирОбщий.ПредставлениеДлительностиЛкс(ДлительностьСекунд);
		Если ВыводитьДлительностьВыгрузки Или ДлительностьСекунд > 5 Тогда
			ирОбщий.СообщитьЛкс("Выгрузка данных журнала завершена через " + ДлительностьСтрока + ". Отбор - " + РезультатЗадания.ПредставлениеОтбора);
		КонецЕсли;
		ирОбщий.СостояниеЛкс("");
	КонецЕсли; 

КонецПроцедуры

Процедура КоманднаяПанельЖурналРегистрацииОбновить(Кнопка)
	
	ОбновитьТаблицуЖурнала();
	
КонецПроцедуры

Процедура ОтборПередНачаломДобавления(Элемент, Отказ, Копирование)
	
	Отказ = Истина;
	Если Копирование Тогда
		Возврат;
	КонецЕсли; 
	СписокВыбора = Новый СписокЗначений;
	Для Каждого Колонка Из Метаданные().ТабличныеЧасти.ТаблицаЖурнала.Реквизиты Цикл
		Если Ложь
			Или Отбор.Найти(Колонка.Имя, "Поле") <> Неопределено 
			Или СтруктураКолонокБезОтбора.Свойство(Колонка.Имя)
		Тогда
			Продолжить;
		КонецЕсли; 
		СписокВыбора.Добавить(Колонка.Имя, Колонка.Представление());
	КонецЦикла;
	СписокВыбора.СортироватьПоЗначению();
	РезультатВыбора = СписокВыбора.ВыбратьЭлемент();
	Если РезультатВыбора <> Неопределено Тогда
		ПолеОтбора = РезультатВыбора.Значение;
		ТекущаяСтрока = ДобавитьЭлементОтбора(Отбор, ПолеОтбора);
		Элемент.ТекущаяСтрока = ТекущаяСтрока;
		//Элемент.ИзменитьСтроку();
		//ОтборЗначениеНачалоВыбора();
	КонецЕсли; 
	
КонецПроцедуры

Процедура ПриОткрытии()
	
	ирОбщий.Форма_ПриОткрытииЛкс(ЭтаФорма);
	ирОбщий.СоздатьМенеджерСохраненияНастроекФормыЛкс(ЭтаФорма);
	мАлгоритмПередВыгрузкойПараметры = ирОбщий.ТаблицаЗначенийИзТабличногоДокументаЛкс(ПолучитьМакет("АлгоритмПередВыгрузкой"),,,, Истина);
	Если НЕ ЗначениеЗаполнено(НачалоПериода) Тогда
		НачалоПериода = НачалоДня(ТекущаяДата());
	КонецЕсли;
	ДействияФормыОткрытьФайлЖурнала();
	ОбновитьПодменюПоследнихОтборов();
	ПроверитьИзменениеОтбораТабличногоПоляДляИстории("");

КонецПроцедуры

Процедура ПриЗакрытии()
	
	ирОбщий.Форма_ПриЗакрытииЛкс(ЭтаФорма);
	
КонецПроцедуры

Функция ПоследниеОтборыНажатие(Кнопка) Экспорт
	
	НастройкаКомпоновки = ирОбщий.ВыбранныйЭлементПоследнихЗначенийЛкс(ЭтаФорма, ЭлементыФормы.ТаблицаЖурнала, Кнопка, "Отборы", Истина);
	#Если Сервер И Не Сервер Тогда
		НастройкаКомпоновки = Новый НастройкиКомпоновкиДанных;
	#КонецЕсли
	ОтключитьОбработчикИзмененияДанных("ЭлементыФормы.ТаблицаЖурнала.Отбор");
	ирОбщий.СкопироватьОтборЛюбойЛкс(ЭлементыФормы.ТаблицаЖурнала.ОтборСтрок, НастройкаКомпоновки.Отбор);
	ПроверитьИзменениеОтбораТабличногоПоляДляИстории("");
	
КонецФункции

Процедура ОтборЗначениеПриИзменении(Элемент)
	
	ТекущаяСтрока = ЭлементыФормы.Отбор.ТекущаяСтрока;
	ПолеОтбора = ТекущаяСтрока.Поле;
	БазовоеОписаниеТипов = Метаданные().ТабличныеЧасти.ТаблицаЖурнала.Реквизиты[ПолеОтбора].Тип;
	ТекущаяСтрока.Использование = Истина;
	Если ТипЗнч(ТекущаяСтрока.Значение) = Тип("СписокЗначений") Тогда
		Если ПолеОтбора = "Сеанс" Тогда 
			ТекущаяСтрока.Значение.ТипЗначения = БазовоеОписаниеТипов;
		КонецЕсли;
	КонецЕсли; 
	
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

Процедура КоманднаяПанельЖурналРегистрацииНастроитьРегистрациюСобытия(Кнопка)
	
	Форма = ирОбщий.ПолучитьФормуЛкс("Обработка.ирНастройкаЖурналаРегистрации.Форма");
	Форма.Открыть();
	ТекущаяСтрока = ЭлементыФормы.ТаблицаЖурнала.ТекущаяСтрока;
	Если ТекущаяСтрока <> Неопределено Тогда
		СтрокаТаблицыЗначений = ТаблицаЗначенийЖурнала.Найти(ТекущаяСтрока.ПорядокСтроки, "ПорядокСтроки");
		лМетаданные = Неопределено;
		Если СтрокаТаблицыЗначений <> Неопределено Тогда
			лМетаданные = СтрокаТаблицыЗначений.Метаданные;
		КонецЕсли; 
		Форма.АктивизироватьСтрокуСобытия(ТекущаяСтрока.Событие, лМетаданные);
	КонецЕсли; 
	
КонецПроцедуры

Процедура ФиксированныйСписокПриИзмененииФлажка(Элемент)
	
	ЭлементыФормы.Отбор.ОбновитьСтроки();
	ЭлементыФормы.Отбор.ТекущиеДанные.Использование = Истина;
	
КонецПроцедуры

Процедура ОтборПриАктивизацииСтроки(Элемент = Неопределено)

	Если Элемент = Неопределено Тогда
		Элемент = ЭлементыФормы.Отбор;
	КонецЕсли; 
	ирОбщий.ТабличноеПолеПриАктивизацииСтрокиЛкс(ЭтаФорма, Элемент);
	ТекущиеДанные = ЭлементыФормы.Отбор.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		ЗначениеОтбора = Неопределено;
	Иначе
		ЗначениеОтбора = ТекущиеДанные.Значение;
	КонецЕсли; 
	ЭтоСписокЗначений = ТипЗнч(ЗначениеОтбора) = Тип("СписокЗначений");
	Элемент.Колонки.Значение.ТолькоПросмотр = ЭтоСписокЗначений;
	ЭлементыФормы.ФиксированныйСписок.Видимость = ЭтоСписокЗначений;
	ЭлементыФормы.КоманднаяПанельСписка.Видимость = ЭтоСписокЗначений;
	ЭлементыФормы.КоличествоЭлементовСписка.Видимость = ЭтоСписокЗначений;
	Если ЭтоСписокЗначений Тогда
		ЭтаФорма.КоличествоЭлементовСписка = ЗначениеОтбора.Количество();
	Иначе
		ЭтаФорма.КоличествоЭлементовСписка = 0;
	КонецЕсли; 
	
КонецПроцедуры

Процедура КоманднаяПанельСпискаСнятьФлажки(Кнопка)
	
	ЭлементыФормы.ФиксированныйСписок.Значение.ЗаполнитьПометки(Ложь);
	ЭлементыФормы.Отбор.ОбновитьСтроки();
	
КонецПроцедуры

Процедура КоманднаяПанельСпискаУстановитьФлажки(Кнопка)
	
	ЭлементыФормы.ФиксированныйСписок.Значение.ЗаполнитьПометки(Истина);
	ЭлементыФормы.Отбор.ОбновитьСтроки();

КонецПроцедуры

Процедура ДействияФормыАнализТехножурнала(Кнопка)
	
	АнализТехножурнала = ирОбщий.СоздатьОбъектПоПолномуИмениМетаданныхЛкс("Обработка.ирАнализТехножурнала");
	#Если Сервер И Не Сервер Тогда
		АнализТехножурнала = Обработки.ирАнализТехножурнала.Создать();
	#КонецЕсли
	АнализТехножурнала.ОткрытьСОтбором(НачалоПериода, КонецПериода);
	
КонецПроцедуры

Процедура ОтборПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Элемент.ТекущиеДанные.Значение = Элемент.ТекущиеДанные.ОписаниеТипов.ПривестиЗначение(Элемент.ТекущиеДанные.Значение);
	
КонецПроцедуры

Процедура КоманднаяПанельЖурналРегистрацииНайтиВОтбореВыгрузки(Кнопка)
	
	ПолеОтбора = ЭлементыФормы.ТаблицаЖурнала.ТекущаяКолонка.Данные;
	Если СтруктураКолонокБезОтбора.Свойство(ПолеОтбора) Тогда
		Если ЗначениеЗаполнено(СтруктураКолонокБезОтбора[ПолеОтбора]) Тогда
			ПолеОтбора = СтруктураКолонокБезОтбора[ПолеОтбора];
		КонецЕсли; 
	КонецЕсли; 
	ЗначениеОтбора = Неопределено;
	Если ЭлементыФормы.ТаблицаЖурнала.ТекущаяСтрока <> Неопределено Тогда
		ЗначениеОтбора = ЭлементыФормы.ТаблицаЖурнала.ТекущиеДанные[ПолеОтбора];
	КонецЕсли; 
	СтрокаОтбора = ДобавитьЭлементОтбора(Отбор, ПолеОтбора, ЗначениеОтбора);
	ЭлементыФормы.Отбор.ТекущаяСтрока = СтрокаОтбора;
	ТекущаяСтрокаСписка = ЭлементыФормы.ФиксированныйСписок.Значение.НайтиПоЗначению(ЗначениеОтбора);
	Если ТекущаяСтрокаСписка <> Неопределено Тогда
		ЭлементыФормы.ФиксированныйСписок.ТекущаяСтрока = ТекущаяСтрокаСписка;
	КонецЕсли; 
	ЭлементыФормы.Отбор.ОбновитьСтроки();
	
КонецПроцедуры

Процедура КоманднаяПанельОтборТекущийСеанс(Кнопка)
	
	ДобавитьЭлементОтбора(Отбор, "Сеанс", НомерСеансаИнформационнойБазы(),, Истина, Ложь);
	
КонецПроцедуры

Процедура СтруктураКоманднойПанелиНажатие(Кнопка)
	
	ирОбщий.ОткрытьСтруктуруКоманднойПанелиЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник) Экспорт
	
	ирОбщий.Форма_ОбработкаОповещенияЛкс(ЭтаФорма, ИмяСобытия, Параметр, Источник); 

КонецПроцедуры

Процедура ОтборЗначениеОкончаниеВводаТекста(Элемент, Текст, Значение, СтандартнаяОбработка)
	
	//ирОбщий.ПолеВвода_ОкончаниеВводаТекстаЛкс(Элемент, Текст, Значение, СтандартнаяОбработка, , Истина);
	ирОбщий.ПолеВвода_ОкончаниеВводаТекстаЛкс(Элемент, Текст, Значение, СтандартнаяОбработка);

КонецПроцедуры

Процедура КлсКомандаНажатие(Кнопка) Экспорт 
	
	ирОбщий.УниверсальнаяКомандаФормыЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура ОбработчикОжиданияСПараметрамиЛкс() Экспорт 
	
	ирОбщий.ОбработчикОжиданияСПараметрамиЛкс();

КонецПроцедуры

Процедура ОтборЗначениеНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	ирОбщий.ПолеВводаКолонкиРасширенногоЗначения_НачалоВыбораЛкс(ЭтаФорма, ЭлементыФормы.Отбор, СтандартнаяОбработка, , Истина);
	
КонецПроцедуры

Процедура КоманднаяПанельСпискаСортироватьПоВозрастанию(Кнопка)
	
	ЭлементыФормы.Отбор.ТекущиеДанные.Значение.СортироватьПоЗначению();
	
КонецПроцедуры

Процедура КоманднаяПанельСпискаСортироватьПоУбыванию(Кнопка)
	
	ЭлементыФормы.Отбор.ТекущиеДанные.Значение.СортироватьПоЗначению(НаправлениеСортировки.Убыв);

КонецПроцедуры

Процедура ДействияФормыОткрытьФайлЖурнала(Кнопка = Неопределено)
	
	Если Кнопка <> Неопределено Тогда
		Если ЗначениеЗаполнено(ИмяФайла) Тогда
			Ответ = Вопрос("Хотите открыть текущий журнал регистрации?", РежимДиалогаВопрос.ДаНет);
		Иначе
			Ответ = КодВозвратаДиалога.Нет;
		КонецЕсли; 
		Если Ответ = КодВозвратаДиалога.Да Тогда
			ИмяФайла = "";
		Иначе
			НовоеИмяФайла = ирОбщий.ВыбратьФайлЛкс(, "lgf",, ИмяФайла);
			Если НовоеИмяФайла <> Неопределено Тогда
				ИмяФайла = НовоеИмяФайла;
			Иначе
				Возврат;
			КонецЕсли; 
		КонецЕсли;
	КонецЕсли; 
	ирОбщий.ОбновитьТекстПослеМаркераВСтрокеЛкс(ЭтаФорма.Заголовок,, ИмяФайла, ": ");
	ЗаполнитьОтборВыгрузки();
	ТаблицаЖурнала.Очистить();
	ОтборПриАктивизацииСтроки();
	
КонецПроцедуры

Процедура КоманднаяПанельФормыОткрытьИТС(Кнопка)
	
	ирОбщий.ОткрытьСсылкуИТСЛкс("https://its.1c.ru/db/v?doc#bookmark:dev:TI000000823");
	
КонецПроцедуры

Процедура КоманднаяПанельСпискаРедактироватьЭлементОтбора(Кнопка = Неопределено)
	
	ФормаРедактора = ПолучитьФорму("РедакторСписка");
	ФормаРедактора.ПараметрСписок = ЭлементыФормы.Отбор.ТекущиеДанные.Значение;
	ФормаРедактора.ПараметрТекущаяСтрока = ЭлементыФормы.ФиксированныйСписок.ТекущаяСтрока;
	РезультатФормы = ФормаРедактора.ОткрытьМодально();
	Если РезультатФормы <> Неопределено Тогда
		ЭлементыФормы.Отбор.ТекущиеДанные.Использование = Истина;
	КонецЕсли; 
	
КонецПроцедуры

Процедура ОтборВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	Если КоличествоЭлементовСписка > 0 И ЭлементыФормы.Отбор.Колонки.Значение = Колонка Тогда
		СтандартнаяОбработка = Ложь;
		КоманднаяПанельСпискаРедактироватьЭлементОтбора();
	КонецЕсли; 
	
КонецПроцедуры

Процедура ФиксированныйСписокВыбор(Элемент, ЭлементСписка)
	
	КоманднаяПанельСпискаРедактироватьЭлементОтбора();
	
КонецПроцедуры

Процедура ОтборПриИзмененииФлажка(Элемент, Колонка)
	
	ирОбщий.ТабличноеПолеПриИзмененииФлажкаЛкс(Элемент, Колонка);

КонецПроцедуры

Процедура ТаблицаЖурналаПриАктивизацииСтроки(Элемент)
	
	ирОбщий.ТабличноеПолеПриАктивизацииСтрокиЛкс(ЭтаФорма, Элемент);

КонецПроцедуры

Процедура КоманднаяПанельФормыОтображатьОтбор(Кнопка)
	
	ПоказатьСвернутьОтбор(Не ЭлементыФормы.ДействияФормы.Кнопки.ОтображатьОтбор.Пометка);
	
КонецПроцедуры

Процедура ПоказатьСвернутьОтбор(Видимость = Истина)
	
	ЭлементыФормы.ДействияФормы.Кнопки.ОтображатьОтбор.Пометка = Видимость;
	ирОбщий.ИзменитьСвернутостьЛкс(ЭтаФорма, Видимость, ЭлементыФормы.ПанельОтбор, ЭлементыФормы.РазделительГоризонтальныйПодОтбором, ЭтаФорма.Панель, "верх");
	
КонецПроцедуры

Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Если Не Отказ Тогда
		ПоказатьСвернутьОтбор();
	КонецЕсли; 

КонецПроцедуры

Процедура ОбновлениеОтображения()
	
	ирОбщий.Форма_ОбновлениеОтображенияЛкс(ЭтаФорма);

КонецПроцедуры

Процедура ПроверитьИзменениеОтбораТабличногоПоляДляИстории(ПутьКДанным)
	
	ПодключитьОбработчикИзмененияДанных("ЭлементыФормы.ТаблицаЖурнала.Отбор", "ПроверитьИзменениеОтбораТабличногоПоляДляИстории", Истина);
	ПодключитьОбработчикОжидания("ПроверитьИзменениеОтбораТабличногоПоляДляИсторииОтложенно", 0.1, Истина);

КонецПроцедуры

Процедура ПроверитьИзменениеОтбораТабличногоПоляДляИсторииОтложенно()
	
	ДобавленВСписок = ирОбщий.ДобавитьОтборВИсториюТабличногоПоляЛкс(ЭтаФорма, ЭлементыФормы.ТаблицаЖурнала, ЭлементыФормы.ТаблицаЖурнала.ОтборСтрок, СтарыйОтбор);
	Если ДобавленВСписок Тогда
		ОбновитьПодменюПоследнихОтборов();
	КонецЕсли;

КонецПроцедуры

Процедура ОбновитьПодменюПоследнихОтборов()
	
	#Если Сервер И Не Сервер Тогда
		ПоследниеОтборыНажатие();
	#КонецЕсли
	ирОбщий.ПоследниеВыбранныеЗаполнитьПодменюЛкс(ЭтаФорма, ЭлементыФормы.КоманднаяПанельЖурналРегистрации.Кнопки.ПоследниеОтборы, ЭлементыФормы.ТаблицаЖурнала, Новый Действие("ПоследниеОтборыНажатие"), "Отборы");

КонецПроцедуры

Процедура КоманднаяПанельЖурналРегистрацииАнализПравДоступа(Кнопка)
	
	ВыбраннаяСтрока = ЭлементыФормы.ТаблицаЖурнала.ТекущаяСтрока;
	Если ВыбраннаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	СтрокаТаблицыЗначений = ТаблицаЗначенийЖурнала.Найти(ВыбраннаяСтрока.ПорядокСтроки, "ПорядокСтроки");
	ПолноеИмяМД = ВыбратьОбъектМетаданных(СтрокаТаблицыЗначений);
	Если ПолноеИмяМД = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	ФормаОтчета = ирОбщий.ПолучитьФормуЛкс("Отчет.ирАнализПравДоступа.Форма",,, ПолноеИмяМД);
	ФормаОтчета.Пользователь = СтрокаТаблицыЗначений.ИмяПользователя;
	ФормаОтчета.ОбъектМетаданных = ПолноеИмяМД;
	ФормаОтчета.ПараметрКлючВарианта = "ПоПользователям";
	ФормаОтчета.Открыть();
	
КонецПроцедуры

Процедура КоманднаяПанельЖурналРегистрацииОткрытьОбъектМетаданных(Кнопка)
	
	ВыбраннаяСтрока = ЭлементыФормы.ТаблицаЖурнала.ТекущаяСтрока;
	Если ВыбраннаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	СтрокаТаблицыЗначений = ТаблицаЗначенийЖурнала.Найти(ВыбраннаяСтрока.ПорядокСтроки, "ПорядокСтроки");
	ПолноеИмяМД = ВыбратьОбъектМетаданных(СтрокаТаблицыЗначений);
	Если ПолноеИмяМД = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	ирОбщий.ОткрытьОбъектМетаданныхЛкс(ПолноеИмяМД);
	
КонецПроцедуры

Процедура ВнешнееСобытие(Источник, Событие, Данные) Экспорт
	
	ирОбщий.Форма_ВнешнееСобытиеЛкс(ЭтаФорма, Источник, Событие, Данные);

КонецПроцедуры

Процедура ТаблицаЖурналаПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки) Экспорт 
	
	ОформлениеСтроки.Ячейки.Уровень.ОтображатьКартинку = Истина;
	ИндексКартинки = -1;
	//Если ДанныеСтроки.СтатусТранзакции = "" + СтатусТранзакцииЗаписиЖурналаРегистрации.Отменена тогда
	//	ИндексКартинки = 0;
	//Иначе
		ИндексКартинки = МассивУровнейЖурнала.Найти("" + ДанныеСтроки.Уровень);
		ИндексКартинки = ?(ИндексКартинки <> Неопределено, ИндексКартинки, -1);
	//КонецЕсли;
	Если ИндексКартинки >= 0 тогда
		ОформлениеСтроки.Ячейки.Уровень.ИндексКартинки = ИндексКартинки;
	КонецЕсли;
	Если ДанныеСтроки.Сеанс = НомерСеансаИнформационнойБазы() Тогда
		ОформлениеСтроки.ЦветФона = Новый Цвет(240, 255, 240);
	КонецЕсли; 
	//Если ДанныеСтроки.Данные = ВыбОбъект Тогда
	//	ОформлениеСтроки.ЦветФона = Новый Цвет(255, 250, 250);
	//КонецЕсли;
	СтрокаТаблицыЗначений = ТаблицаЗначенийЖурнала.Найти(ДанныеСтроки.ПорядокСтроки, "ПорядокСтроки");
	Если СтрокаТаблицыЗначений <> Неопределено Тогда
		Если ТаблицаЗначенийЖурнала.Колонки.Найти("РазделениеДанныхСеанса") <> Неопределено Тогда
			ирОбщий.ОформитьЯчейкуСРасширеннымЗначениемЛкс(ОформлениеСтроки.Ячейки.РазделениеДанныхСеанса, СтрокаТаблицыЗначений.РазделениеДанныхСеанса, Элемент.Колонки.РазделениеДанныхСеанса);
		КонецЕсли; 
		Если ТипЗнч(СтрокаТаблицыЗначений.Метаданные) = Тип("Строка") Тогда
			КартинкаКорневогоТипа = ирОбщий.КартинкаКорневогоТипаМДЛкс(ирОбщий.ПервыйФрагментЛкс(СтрокаТаблицыЗначений.Метаданные));
			Если КартинкаКорневогоТипа.Вид <> ВидКартинки.Пустая Тогда
				ОформлениеСтроки.Ячейки.Метаданные.УстановитьКартинку(КартинкаКорневогоТипа);
			КонецЕсли; 
		Иначе
			ирОбщий.ОформитьЯчейкуСРасширеннымЗначениемЛкс(ОформлениеСтроки.Ячейки.Метаданные, СтрокаТаблицыЗначений.Метаданные, Элемент.Колонки.Метаданные);
		КонецЕсли; 
		ирОбщий.ОформитьЯчейкуСРасширеннымЗначениемЛкс(ОформлениеСтроки.Ячейки.Данные, СтрокаТаблицыЗначений.Данные, Элемент.Колонки.Данные);
		ирОбщий.ТабличноеПолеПриВыводеСтрокиЛкс(ЭтаФорма, Элемент, ОформлениеСтроки, ДанныеСтроки,,,,, СтрокаТаблицыЗначений);
	КонецЕсли; 
	
КонецПроцедуры

Процедура ОтборПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки) Экспорт 
	
	ирОбщий.ТабличноеПолеПриВыводеСтрокиЛкс(ЭтаФорма, Элемент, ОформлениеСтроки, ДанныеСтроки);
	СтрокаОтбора = ДанныеСтроки;
	ИспользованиеСтрокиОтбора = ИспользованиеСтрокиОтбора(СтрокаОтбора);
	Если ТипЗнч(ДанныеСтроки.Значение) = Тип("СписокЗначений") Тогда
		Если ДанныеСтроки.Значение.ТипЗначения.Типы().Количество() = 0 Тогда
			КоличествоПомеченных = Неопределено;
			ПредставлениеСтрокиОтбора = ПредставлениеСтрокиОтбора(ДанныеСтроки, КоличествоПомеченных);
			ИспользованиеСтрокиОтбора = ИспользованиеСтрокиОтбора И ЗначениеЗаполнено(ПредставлениеСтрокиОтбора);
			ОформлениеСтроки.Ячейки.Значение.УстановитьТекст("(" + КоличествоПомеченных + " из " + ДанныеСтроки.Значение.Количество() + ") " + ПредставлениеСтрокиОтбора);
		КонецЕсли;
	КонецЕсли; 
	Если ДанныеСтроки.Поле = "Данные" Тогда
		ирОбщий.ОформитьЯчейкуСРасширеннымЗначениемЛкс(ОформлениеСтроки.Ячейки.Значение,,, Истина);
	КонецЕсли; 
	Если Не ИспользованиеСтрокиОтбора Тогда
		ОформлениеСтроки.ЦветТекста = ирОбщий.ЦветТекстаНеактивностиЛкс();
	КонецЕсли; 
	
КонецПроцедуры

Процедура ТабличноеПолеПриПолученииДанных(Элемент, ОформленияСтрок) Экспорт 
	
	ирОбщий.ТабличноеПолеПриПолученииДанныхЛкс(ЭтаФорма, Элемент, ОформленияСтрок);

КонецПроцедуры

Процедура КоманднаяПанельЖурналРегистрацииРедакторОбъектаБД(Кнопка)
	
	ТекущаяСтрока = ЭлементыФормы.ТаблицаЖурнала.ТекущаяСтрока;
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	СтрокаТаблицыЗначений = ТаблицаЗначенийЖурнала.Найти(ТекущаяСтрока.ПорядокСтроки, "ПорядокСтроки");
	Если Не ирОбщий.ЛиСсылкаНаОбъектБДЛкс(СтрокаТаблицыЗначений.Данные) Тогда
		Возврат
	КонецЕсли; 
	ирОбщий.ОткрытьСсылкуВРедактореОбъектаБДЛкс(СтрокаТаблицыЗначений.Данные);
	
КонецПроцедуры

Процедура КоманднаяПанельОтборАлгоритм(Кнопка)
	
	СтандартнаяОбработка = Ложь;
	СтруктураАлгоритма = ирОбщий.ВосстановитьОбъектИзСтрокиXMLЛкс(АлгоритмПередВыгрузкой);
	Результат = ирОбщий.РедактироватьАлгоритмЧерезСтруктуруЛкс(СтруктураАлгоритма, мАлгоритмПередВыгрузкойПараметры,,, "Алгоритм перед выгрузкой");
	Если Результат Тогда
		Если Не ЗначениеЗаполнено(СтруктураАлгоритма.ТекстАлгоритма) Тогда
			ЭтотОбъект.АлгоритмПередВыгрузкой = "";
		Иначе
			ЭтотОбъект.АлгоритмПередВыгрузкой = ирОбщий.СохранитьОбъектВВидеСтрокиXMLЛкс(СтруктураАлгоритма);
		КонецЕсли; 
	КонецЕсли;
	НастроитьЭлементыФормы();
	
КонецПроцедуры

Процедура НастроитьЭлементыФормы()
	
	ЭлементыФормы.КоманднаяПанельОтбор.Кнопки.Алгоритм.Пометка = ЗначениеЗаполнено(АлгоритмПередВыгрузкой);

КонецПроцедуры

ирОбщий.ИнициализироватьФормуЛкс(ЭтаФорма, "Обработка.ирАнализЖурналаРегистрации.Форма.Форма");
СписокВыбора = ЭлементыФормы.МаксимальныйРазмерВыгрузки.СписокВыбора;
СписокВыбора.Добавить(100);
СписокВыбора.Добавить(1000);
СписокВыбора.Добавить(10000);
СписокВыбора.Добавить(100000);
СписокВыбора.Добавить(500000);
РазделительДлительности = "-";

СтруктураКолонокБезОтбора = Новый Структура();
СтруктураКолонокБезОтбора.Вставить("ПредставлениеПриложения", "ИмяПриложения");
СтруктураКолонокБезОтбора.Вставить("ПредставлениеСобытия", "Событие");
СтруктураКолонокБезОтбора.Вставить("ИмяПользователя", "Пользователь");
СтруктураКолонокБезОтбора.Вставить("Дата");
СтруктураКолонокБезОтбора.Вставить("Соединение");
СтруктураКолонокБезОтбора.Вставить("ПредставлениеМетаданных", "Метаданные");

МассивУровнейЖурнала = Новый Массив();
МассивУровнейЖурнала.Добавить("" + УровеньЖурналаРегистрации.Примечание);
МассивУровнейЖурнала.Добавить("" + УровеньЖурналаРегистрации.Информация);
МассивУровнейЖурнала.Добавить("" + УровеньЖурналаРегистрации.Предупреждение);
МассивУровнейЖурнала.Добавить("" + УровеньЖурналаРегистрации.Ошибка);

