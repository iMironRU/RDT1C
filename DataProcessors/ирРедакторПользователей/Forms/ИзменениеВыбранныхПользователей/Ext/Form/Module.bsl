﻿Перем ИменаНастроекУправляемогоПриложения;
Перем ИменаСвойствПользователя;

Процедура ОсновныеДействияФормыОК(Кнопка)
	
	МассивНастроек = ирОбщий.СтрРазделитьЛкс(ИменаНастроекУправляемогоПриложения, ",", Истина);
	МассивСвойств = ирОбщий.СтрРазделитьЛкс(ИменаСвойствПользователя, ",", Истина);
	Индикатор = ирОбщий.ПолучитьИндикаторПроцессаЛкс(ПараметрИменаПользователей.Количество());
	Для Каждого ИмяПользователя Из ПараметрИменаПользователей Цикл
		ирОбщий.ОбработатьИндикаторЛкс(Индикатор);
		Если ЭлементыФормы.ПанельНастроекУправляемогоПриложения.Доступность Тогда
			НастройкиКлиентскогоПриложения = ХранилищеСистемныхНастроек.Загрузить("Общее/НастройкиКлиентскогоПриложения",,, ИмяПользователя);
			Если НастройкиКлиентскогоПриложения = Неопределено Тогда
				НастройкиКлиентскогоПриложения = Новый НастройкиКлиентскогоПриложения;
			КонецЕсли;
			БылиИзменения = Ложь;
			Для Каждого ИмяСвойства Из МассивНастроек Цикл
				Если Не ЭтаФорма[ИмяСвойства + "Установить"] Тогда
					Продолжить;
				КонецЕсли; 
				ЗначениеСвойства = ЭтаФорма[ИмяСвойства + "Значение"];
				Если ТипЗнч(ЗначениеСвойства) = Тип("Булево") Тогда
					НастройкиКлиентскогоПриложения[ИмяСвойства] = ЗначениеСвойства;
				Иначе
					НастройкиКлиентскогоПриложения[ИмяСвойства] = Вычислить(ИмяСвойства + "." + ЗначениеСвойства);
				КонецЕсли; 
				БылиИзменения = Истина;
			КонецЦикла;
			Если БылиИзменения Тогда
				ХранилищеСистемныхНастроек.Сохранить("Общее/НастройкиКлиентскогоПриложения", "", НастройкиКлиентскогоПриложения, , ИмяПользователя);
			КонецЕсли; 
		КонецЕсли; 
		ПользовательИБ = ПользователиИнформационнойБазы.НайтиПоИмени(ИмяПользователя);
		БылиИзменения = Ложь;
		Для Каждого ИмяСвойства Из МассивСвойств Цикл
			Если Не ЭтаФорма[ИмяСвойства + "Установить"] Тогда
				Продолжить;
			КонецЕсли; 
			ПользовательИБ[ИмяСвойства] = ЭтаФорма[ИмяСвойства]; 
			БылиИзменения = Истина;
		КонецЦикла;
		Если ЗащитаОтОпасныхДействийУстановить Тогда
			ПользовательИБ.ЗащитаОтОпасныхДействий.ПредупреждатьОбОпасныхДействиях = ЗащитаОтОпасныхДействий;
			БылиИзменения = Истина;
		КонецЕсли;
		Если УдаляемаяРольУстановить Тогда
			МетаРоль = Метаданные.Роли.Найти(УдаляемаяРоль);
			Если ПользовательИБ.Роли.Содержит(МетаРоль) Тогда
				ПользовательИБ.Роли.Удалить(МетаРоль);
				БылиИзменения = Истина;
			КонецЕсли; 
		КонецЕсли; 
		Если ДобавляемаяРольУстановить Тогда
			МетаРоль = Метаданные.Роли.Найти(ДобавляемаяРоль);
			Если Не ПользовательИБ.Роли.Содержит(МетаРоль) Тогда
				ПользовательИБ.Роли.Добавить(МетаРоль);
				БылиИзменения = Истина;
			КонецЕсли; 
		КонецЕсли; 
		Если ПарольУстановить Тогда
			ПользовательИБ.Пароль = Пароль;
			БылиИзменения = Истина;
		КонецЕсли; 
		Если БылиИзменения Тогда
			ПользовательИБ.Записать();
		КонецЕсли; 
	КонецЦикла;
	ирОбщий.ОсвободитьИндикаторПроцессаЛкс();
	Закрыть();

КонецПроцедуры

Процедура ОбновитьДоступность()
	
	ЭлементыФормы.ВариантИнтерфейсаКлиентскогоПриложенияТакси.Доступность = ВариантИнтерфейсаКлиентскогоПриложенияУстановить;
	ЭлементыФормы.ВариантИнтерфейсаКлиентскогоПриложенияВерсия8_2.Доступность = ВариантИнтерфейсаКлиентскогоПриложенияУстановить;
	ЭлементыФормы.ВариантМасштабаФормКлиентскогоПриложенияАвто.Доступность = ВариантМасштабаФормКлиентскогоПриложенияУстановить;
	ЭлементыФормы.ВариантМасштабаФормКлиентскогоПриложенияКомпактный.Доступность = ВариантМасштабаФормКлиентскогоПриложенияУстановить;
	ЭлементыФормы.ВариантМасштабаФормКлиентскогоПриложенияОбычный.Доступность = ВариантМасштабаФормКлиентскогоПриложенияУстановить;
	ЭлементыФормы.РежимОткрытияФормПриложенияОтдельныеОкна.Доступность = РежимОткрытияФормПриложенияУстановить;
	ЭлементыФормы.РежимОткрытияФормПриложенияЗакладки.Доступность = РежимОткрытияФормПриложенияУстановить;
	ЭлементыФормы.ОтображатьПанелиНавигацииИДействий.Доступность = ОтображатьПанелиНавигацииИДействийУстановить;
	ЭлементыФормы.ОтображатьПанельРазделов.Доступность = ОтображатьПанельРазделовУстановить;
	
	МассивСвойств = ирОбщий.СтрРазделитьЛкс(ИменаСвойствПользователя, ",", Истина);
	Для Каждого ИмяСвойства Из МассивСвойств Цикл
		ЭлементыФормы[ИмяСвойства].Доступность = ЭтаФорма[ИмяСвойства + "Установить"];
	КонецЦикла;
	ЭлементыФормы.УдаляемаяРоль.Доступность = УдаляемаяРольУстановить;
	ЭлементыФормы.ДобавляемаяРоль.Доступность = ДобавляемаяРольУстановить;
	ЭлементыФормы.Пароль.Доступность = ПарольУстановить;
	ЭлементыФормы.ЗащитаОтОпасныхДействий.Доступность = ЗащитаОтОпасныхДействийУстановить;
	
КонецПроцедуры

Процедура ПриОткрытии()
	
	ЭлементыФормы.ПанельНастроекУправляемогоПриложения.Доступность = ирКэш.НомерВерсииПлатформыЛкс() >= 803001;
	ЭлементыФормы.ЗащитаОтОпасныхДействийУстановить.Доступность = ирКэш.ДоступнаЗащитаОтОпасныхДействийЛкс();
	ЗагрузитьСписокВыбораРоли(ЭлементыФормы.УдаляемаяРоль.СписокВыбора);
	ЗагрузитьСписокВыбораРоли(ЭлементыФормы.ДобавляемаяРоль.СписокВыбора);
	ЗаполнитьСписокВыбораИнтерфейса(ЭлементыФормы.ОсновнойИнтерфейс.СписокВыбора);
	ЗаполнитьСписокВыбораЯзыка(ЭлементыФормы.Язык.СписокВыбора);
	ЗаполнитьСписокВыбораРежимаЗапуска(ЭлементыФормы.РежимЗапуска.СписокВыбора);
	ЭтаФорма.ДобавляемаяРоль = ирОбщий.ВосстановитьЗначениеЛкс(ПрефиксХраненияНастроекФормы() + "ДобавляемаяРоль");
	ЭтаФорма.УдаляемаяРоль = ирОбщий.ВосстановитьЗначениеЛкс(ПрефиксХраненияНастроекФормы() + "УдаляемаяРоль");
	Если ЗначениеЗаполнено(ПараметрИмяПользователя) Тогда
		Если ЭлементыФормы.ПанельНастроекУправляемогоПриложения.Доступность Тогда
			НастройкиКлиентскогоПриложения = ХранилищеСистемныхНастроек.Загрузить("Общее/НастройкиКлиентскогоПриложения",,, ПараметрИмяПользователя);
			Если НастройкиКлиентскогоПриложения = Неопределено Тогда
				НастройкиКлиентскогоПриложения = Новый НастройкиКлиентскогоПриложения;
			КонецЕсли;
			ЭтаФорма.ВариантМасштабаФормКлиентскогоПриложенияЗначение = ирОбщий.ИдентификаторИзПредставленияЛкс(НастройкиКлиентскогоПриложения.ВариантМасштабаФормКлиентскогоПриложения);
			ЭтаФорма.ВариантИнтерфейсаКлиентскогоПриложенияЗначение = ирОбщий.ИдентификаторИзПредставленияЛкс(НастройкиКлиентскогоПриложения.ВариантИнтерфейсаКлиентскогоПриложения);
			ЭтаФорма.РежимОткрытияФормПриложенияЗначение = ирОбщий.ИдентификаторИзПредставленияЛкс(НастройкиКлиентскогоПриложения.РежимОткрытияФормПриложения);
			ЭтаФорма.ОтображатьПанельРазделовЗначение = НастройкиКлиентскогоПриложения.ОтображатьПанельРазделов;
			ЭтаФорма.ОтображатьПанелиНавигацииИДействийЗначение = НастройкиКлиентскогоПриложения.ОтображатьПанелиНавигацииИДействий;
		КонецЕсли; 
		ПользовательИБ = ПользователиИнформационнойБазы.НайтиПоИмени(ПараметрИмяПользователя);
		ЗаполнитьЗначенияСвойств(ЭтаФорма, ПользовательИБ, ИменаСвойствПользователя); 
		Если ЭлементыФормы.ЗащитаОтОпасныхДействийУстановить.Доступность Тогда
			ЭтаФорма.ЗащитаОтОпасныхДействий = ПользовательИБ.ЗащитаОтОпасныхДействий.ПредупреждатьОбОпасныхДействиях;
		КонецЕсли; 
	КонецЕсли;  
	ОбновитьДоступность();
	
КонецПроцедуры

Процедура ЗагрузитьСписокВыбораРоли(Знач СписокВыбора)
	
	Для Каждого СтрокаРоли Из РолиПользователя Цикл
		СписокВыбора.Добавить(СтрокаРоли.Роль, СтрокаРоли.Представление);
	КонецЦикла;

КонецПроцедуры

Процедура ПриИзмененииФлажка(Элемент)
	ОбновитьДоступность();
КонецПроцедуры

Процедура ПриЗакрытии()
	
	ирОбщий.СохранитьЗначениеЛкс(ПрефиксХраненияНастроекФормы() + "ДобавляемаяРоль", ДобавляемаяРоль);
	ирОбщий.СохранитьЗначениеЛкс(ПрефиксХраненияНастроекФормы() + "УдаляемаяРоль", УдаляемаяРоль);

КонецПроцедуры

Функция ПрефиксХраненияНастроекФормы()
	
	Возврат "ирРедакторПользователей.ИзменениеВыбранныхПользователей.";

КонецФункции


ЭтаФорма.ВариантИнтерфейсаКлиентскогоПриложенияЗначение = "Такси";
ЭтаФорма.ВариантМасштабаФормКлиентскогоПриложенияЗначение = "Авто";
ЭтаФорма.ОтображатьПанелиНавигацииИДействийЗначение = Истина;
ЭтаФорма.ОтображатьПанельРазделовЗначение = Истина;
ЭтаФорма.РежимОткрытияФормПриложенияЗначение = "ОтдельныеОкна";
ИменаНастроекУправляемогоПриложения = "ВариантИнтерфейсаКлиентскогоПриложения, ВариантМасштабаФормКлиентскогоПриложения, ОтображатьПанелиНавигацииИДействий, ОтображатьПанельРазделов, РежимОткрытияФормПриложения";
ИменаСвойствПользователя = "АутентификацияOpenID, АутентификацияОС, АутентификацияСтандартная, ОсновнойИнтерфейс, ПоказыватьВСпискеВыбора, РежимЗапуска, Язык";