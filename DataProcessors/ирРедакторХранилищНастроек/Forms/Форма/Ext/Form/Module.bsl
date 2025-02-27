﻿Перем СтарыйОтбор;

Процедура ПриОткрытии()
	
	ирОбщий.Форма_ПриОткрытииЛкс(ЭтаФорма);
	ЭлементыФормы.ПанельРазделаНастроек.Страницы.ХранилищеВариантовОтчетов.Доступность = ТипЗнч(ХранилищеВариантовОтчетов) = Тип("СтандартноеХранилищеНастроекМенеджер");
	ЭтотОбъект.ТаблицаФормыИБ = ФормыИБ.ВыгрузитьКолонки(); // Не используем ТЧ, т.к. в ней нельзя добавить индекс
	ТаблицаФормыИБ.Индексы.Добавить("ПолноеИмяОбъекта");
	ЗаполнитьСписокПользователей();
	ОбновитьДеревоПользователей();
	Если Не ЗначениеЗаполнено(Пользователь) Тогда
		Пользователь = ИмяПользователя();
	КонецЕсли; 
	Если ЗначениеЗаполнено(Пользователь) Тогда
		СтрокаДерева = ДеревоПользователей.Строки.Найти(Пользователь, "ИмяПользователя", Истина);
		Если СтрокаДерева <> Неопределено Тогда 
			ЭлементыФормы.ДеревоПользователей.ТекущаяСтрока = СтрокаДерева;
		КонецЕсли;
	КонецЕсли;
	//ПолучитьСписокФорм();
	//ОбновитьДеревоФорм();
	ОбновитьСписокОписанийНастроек();
	Если ЗначениеЗаполнено(ЭлементыФормы.ОписаниеНастроек.ОтборСтрок.ИмяОбъекта.Значение) Тогда
		ЭлементыФормы.ОписаниеНастроек.ОтборСтрок.ИмяОбъекта.Использование = Истина;
	КонецЕсли; 
	Если ЗначениеЗаполнено(ЭлементыФормы.ОписаниеНастроек.ОтборСтрок.КлючНастроек.Значение) Тогда
		ЭлементыФормы.ОписаниеНастроек.ОтборСтрок.КлючНастроек.Использование = Истина;
	КонецЕсли; 
	ОбновитьПодменюПоследнихОтборов();

КонецПроцедуры

Процедура ОбновитьПодменюПоследнихОтборов()
	
	ирОбщий.ОбновитьПодменюПоследнихОтборовЛкс(ЭтаФорма, ЭлементыФормы.КоманднаяПанельНастроек, ЭлементыФормы.ОписаниеНастроек);

КонецПроцедуры

Процедура ПроверитьИзменениеОтбораДляИсторииОтложенно()
	
	ДобавленВСписок = ирОбщий.ДобавитьОтборВИсториюТабличногоПоляЛкс(ЭтаФорма, ЭлементыФормы.ОписаниеНастроек, ЭлементыФормы.ОписаниеНастроек.ОтборСтрок, СтарыйОтбор);
	Если ДобавленВСписок Тогда
		ОбновитьПодменюПоследнихОтборов();
	КонецЕсли;

КонецПроцедуры

Процедура ОбработчикИзмененияДанных(ПутьКДанным) Экспорт 
	
	ПутьКДаннымОтбораНайденных = "ЭлементыФормы." + ЭлементыФормы.ОписаниеНастроек.Имя + ".Отбор";
	Если ирОбщий.СтрНачинаетсяСЛкс(ПутьКДанным, ПутьКДаннымОтбораНайденных) Тогда
		#Если Сервер И Не Сервер Тогда
			ПроверитьИзменениеОтбораДляИсторииОтложенно();
		#КонецЕсли
		ПодключитьОбработчикОжидания("ПроверитьИзменениеОтбораДляИсторииОтложенно", 0.1, Истина);
		ПодключитьОбработчикИзмененияДанных(ПутьКДаннымОтбораНайденных, "ОбработчикИзмененияДанных", Истина);
	КонецЕсли; 

КонецПроцедуры

Процедура ОбновитьНажатие(Элемент)
	
	ОбновитьСписокОписанийНастроек();
	
КонецПроцедуры

Процедура ОбновитьСписокОписанийНастроек()

	ТабличноеПоле = ЭлементыФормы.ОписаниеНастроек;
	СостояниеТабличногоПоля = ирОбщий.ТабличноеПолеСостояниеСтрокЛкс(ТабличноеПоле, "ТипНастройки, ИмяОбъекта, КлючНастроек, ИмяПользователя");
	ПользователиНазначения = Новый Массив;
	Если Не ЭлементыФормы.ДеревоПользователей.ВыделенныеСтроки.Содержит(ДеревоПользователей.Строки[0]) Тогда
		ПолучитьВыделеныхПользователей(ПользователиНазначения, ЭлементыФормы.ДеревоПользователей.ВыделенныеСтроки);
	КонецЕсли; 
	Если ПользователиНазначения.Количество() > 0 Тогда
		ЭтаФорма.ОтборЗагрузкиПользователи = ирОбщий.РасширенноеПредставлениеЗначенияЛкс(ПользователиНазначения,, Ложь);
	Иначе
		ЭтаФорма.ОтборЗагрузкиПользователи = "Все";
	КонецЕсли; 
	ФормыНазначения = Новый Массив;
	Если Истина
		И ДеревоФорм.Строки.Количество() > 0
		И Не ЭлементыФормы.ДеревоФорм.ВыделенныеСтроки.Содержит(ДеревоФорм.Строки[0]) 
	Тогда
		ПолучитьВыделеныеФормы(ФормыНазначения, ЭлементыФормы.ДеревоФорм.ВыделенныеСтроки);
	КонецЕсли; 
	Если ФормыНазначения.Количество() > 0 Тогда
		ЭтаФорма.ОтборЗагрузкиМетаданные = ирОбщий.РасширенноеПредставлениеЗначенияЛкс(ФормыНазначения,, Ложь);
	Иначе
		ЭтаФорма.ОтборЗагрузкиМетаданные = "Все";
	КонецЕсли; 
	ПолучитьОписаниеНастроек(ПользователиНазначения, ФормыНазначения, ЭлементыФормы.ПанельРазделаНастроек.ТекущаяСтраница.Имя);
	ЭтаФорма.Количество = ОписаниеНастроек.Количество();
	ирОбщий.ТабличноеПолеВосстановитьСостояниеСтрокЛкс(ТабличноеПоле, СостояниеТабличногоПоля);

КонецПроцедуры

Процедура ПолучитьВыделеныхПользователей(ПользователиНазначения, СтрокиДерева)

	Для каждого Строка Из СтрокиДерева Цикл
		Если Строка.ЭтоПользователь = Истина Тогда
			ПользователиНазначения.Добавить(Строка.ИмяПользователя);
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры // ПолучитьВыделеныхПользователей()

Процедура ПолучитьВыделеныеФормы(ФормыНазначения, СтрокиДерева)

	Для каждого Строка Из СтрокиДерева Цикл
		Если Строка.ЭтоОбъект = Истина Тогда
			ФормыНазначения.Добавить(Строка.ПолноеИмяОбъекта);
		КонецЕсли;
		ПолучитьВыделеныеФормы(ФормыНазначения, Строка.Строки);
	КонецЦикла;

КонецПроцедуры //

Процедура ОбновитьДеревоПользователей()

	ДеревоПользователей.Строки.Очистить();
	ВсеПользователи = ДеревоПользователей.Строки.Добавить();
	ВсеПользователи.ИмяПользователя = "Все";
	Для каждого Строка Из ПользователиИБ Цикл
		ВеткаГруппы = ВсеПользователи;
		СтрокаПользователя = ВеткаГруппы.Строки.Добавить();
		СтрокаПользователя.ИмяПользователя = СокрЛП(Строка.ИмяПользователя);
		СтрокаПользователя.ЭтоПользователь = Истина;
	КонецЦикла; 
	ЭлементыФормы.ДеревоПользователей.Развернуть(ВсеПользователи, Истина);
	
КонецПроцедуры

Процедура ОбновитьДеревоФорм()

	#Если Сервер И Не Сервер Тогда
		ТаблицаФормыИБ = ФормыИБ;
	#КонецЕсли
	ДеревоФорм.Строки.Очистить();
	СтрокаВсе = ДеревоФорм.Строки.Добавить();
	СтрокаВсе.ИмяОбъекта = "Все";
	СтрокаВсе.ПолноеИмяОбъекта = "Все";
	СтрокаВсе.ПредставлениеОбъекта = "Все";
	Для каждого Строка Из ТаблицаФормыИБ Цикл
		ВеткаТипа = СтрокаВсе.Строки.Найти(Строка.ТипОбъекта, "ИмяОбъекта", Ложь);
		Если ВеткаТипа = Неопределено Тогда
			ВеткаТипа = СтрокаВсе.Строки.Добавить();
			ВеткаТипа.ИмяОбъекта = Строка.ТипОбъекта;
			ВеткаТипа.ПредставлениеОбъекта = Строка.ТипОбъекта;
			ВеткаТипа.ТипОбъекта = Строка.ТипОбъекта;
		КонецЕсли;
		ВеткаВида = ВеткаТипа.Строки.Найти(Строка.ВидОбъекта, "ИмяОбъекта", Ложь);
		Если ВеткаВида = Неопределено Тогда
			ВеткаВида = ВеткаТипа.Строки.Добавить();
			ВеткаВида.ИмяОбъекта = Строка.ВидОбъекта;
			ВеткаВида.ПолноеИмяОбъекта = Строка.ВидОбъекта;
			ВеткаВида.ПредставлениеОбъекта = Строка.ВидОбъекта;
			ВеткаВида.ТипОбъекта = Строка.ТипОбъекта;
			ВеткаВида.ЭтоОбъект = Истина;
		КонецЕсли;
		СтрокаФормы = ВеткаВида.Строки.Добавить();
		СтрокаФормы.ИмяОбъекта = Строка.ИмяОбъекта;
		СтрокаФормы.ПолноеИмяОбъекта = Строка.ПолноеИмяОбъекта;
		СтрокаФормы.ПредставлениеОбъекта = Строка.ПредставлениеОбъекта;
		СтрокаФормы.ТипОбъекта = Строка.ТипОбъекта;
		СтрокаФормы.ЭтоОбъект = Истина;
	КонецЦикла; 
	СтрокаПрочие = СтрокаВсе.Строки.Добавить();
	СтрокаПрочие.ИмяОбъекта = "Прочие";
	СтрокаПрочие.ПолноеИмяОбъекта = "Прочие";
	СтрокаПрочие.ПредставлениеОбъекта = "Прочие";
	СтрокаПрочие.ЭтоОбъект = Истина;
	ЭлементыФормы.ДеревоФорм.Развернуть(СтрокаВсе, Ложь);
	
КонецПроцедуры

Процедура ДеревоФормПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки) Экспорт
	
	ОформлениеСтроки.Ячейки.ИмяОбъекта.ОтображатьКартинку = ЗначениеЗаполнено(ДанныеСтроки.ТипОбъекта);
	Если ДанныеСтроки.Строки.Количество() = 0 Тогда
		ОформлениеСтроки.Ячейки.ИмяОбъекта.Картинка = БиблиотекаКартинок.Форма;
	Иначе
		ОформлениеСтроки.Ячейки.ИмяОбъекта.Картинка = КартинкаПоТипуОбъекта(ДанныеСтроки.ТипОбъекта);
	КонецЕсли; 
	
КонецПроцедуры

Процедура ДеревоПользователейПриАктивизацииСтроки(Элемент)
	
	ОбновитьСписокОписанийНастроек();
	
КонецПроцедуры

Процедура ДеревоФормПриАктивизацииСтроки(Элемент)
	
	ОбновитьСписокОписанийНастроек();
	
КонецПроцедуры

Процедура КоманднаяПанельНастроекУдалитьНастройки(Кнопка = Неопределено)

	УдалитьНастройкиВыделенныхСтрок(ЭлементыФормы.ОписаниеНастроек.ВыделенныеСтроки, Ложь);
	
КонецПроцедуры

Процедура КоманднаяПанельНастроекФормУдалитьНастройки(Кнопка)

	УдалитьНастройкиВыделенныхСтрок(ЭлементыФормы.ОписаниеНастроекФорм.ВыделенныеСтроки, Истина);
	
КонецПроцедуры

Процедура УдалитьНастройкиВыделенныхСтрок(ТекВыделенныеСтроки, ДопКлюч)

	ТабКУдалению = Новый ТаблицаЗначений;
	ТабКУдалению.Колонки.Добавить("КлючОбъекта");
	ТабКУдалению.Колонки.Добавить("КлючНастроек");
	ТабКУдалению.Колонки.Добавить("Пользователь");
	Для каждого Строка Из ТекВыделенныеСтроки Цикл
		СтрокаТаб = ТабКУдалению.Добавить();
		СтрокаТаб.КлючОбъекта = Строка.ИмяОбъекта + ?(ДопКлюч = Истина  И ЗначениеЗаполнено(Строка.Ключ), "/"+Строка.Ключ, "");
		СтрокаТаб.КлючНастроек = Строка.КлючНастроек;
		СтрокаТаб.Пользователь = Строка.ИмяПользователя;
	КонецЦикла; 
	Если ТабКУдалению.Количество() > 0 Тогда
		ТекстВопроса = НСтр("ru = 'Вы действительно хотите удалить выделенные настройки?'");
		Ответ = Вопрос(ТекстВопроса, РежимДиалогаВопрос.ДаНет,, КодВозвратаДиалога.Да);
		Если Ответ = КодВозвратаДиалога.Нет Тогда
			Возврат;
		КонецЕсли;
		УдалитьНастройкиПользователей(ТабКУдалению, ЭлементыФормы.ПанельРазделаНастроек.ТекущаяСтраница.Имя);
		ирОбщий.СообщитьЛкс(НСтр("ru = 'Настройки удалены'"));
		ОбновитьСписокОписанийНастроек();
	Иначе
		ирОбщий.СообщитьЛкс("Нет выделенных настроек.");
	КонецЕсли;

КонецПроцедуры

Процедура КоманднаяПанельНастроекСкопироватьНастройки(Кнопка)

	СкопироватьНастройкиВыделенныхСтрок(ЭлементыФормы.ОписаниеНастроек.ВыделенныеСтроки, Ложь);
	
КонецПроцедуры

Процедура КоманднаяПанельНастроекФормСкопироватьНастройки(Кнопка)

	СкопироватьНастройкиВыделенныхСтрок(ЭлементыФормы.ОписаниеНастроекФорм.ВыделенныеСтроки, Истина);	
	
КонецПроцедуры

Процедура СкопироватьНастройкиВыделенныхСтрок(ТекВыделенныеСтроки, ДопКлюч)

	Если ТекВыделенныеСтроки.Количество() = 0 Тогда
		Предупреждение(НСтр("ru = 'Для копирования нужно выделить настройки, которые требуется скопировать.'"));
		Возврат;
	КонецЕсли;
	
	СписокПользователей = Новый СписокЗначений;
	Для каждого СтрокаП Из ПользователиИБ Цикл
		СписокПользователей.Добавить(СтрокаП.ИмяПользователя, "" + СтрокаП.ИмяПользователя );
	КонецЦикла; 
	
	Если СписокПользователей.ОтметитьЭлементы(НСтр("ru = 'Отметьте пользователей, которым нужно скопировать настройки'")) Тогда
		ПользователиПриемник = Новый Массив;
		Для Каждого Элемент Из СписокПользователей Цикл
			Если Элемент.Пометка Тогда
				ПользователиПриемник.Добавить(Элемент.Значение);
			КонецЕсли;
		КонецЦикла;
		
		Если ПользователиПриемник.Количество() = 0 Тогда
			Предупреждение(НСтр("ru = 'Для копирования нужно отметить пользователей, которым требуется скопировать настройки.'"));
			Возврат;
		КонецЕсли;
		
		ТекстВопроса = НСтр("ru = 'Существующие одноименные настройки выбранных пользователей будут потеряны. 
		|Вы действительно хотите скопировать настройки выбранным пользователям?'");
		Ответ = Вопрос(ТекстВопроса, РежимДиалогаВопрос.ДаНет,, КодВозвратаДиалога.Да);
		Если Ответ = КодВозвратаДиалога.Нет Тогда
			Возврат;
		КонецЕсли;
		
		///
		ТабОписаний = Новый ТаблицаЗначений;
		ТабОписаний.Колонки.Добавить("КлючОбъекта");
		ТабОписаний.Колонки.Добавить("КлючНастроек");
		ТабОписаний.Колонки.Добавить("Пользователь");
		
		Для каждого Строка Из ТекВыделенныеСтроки Цикл
			СтрокаТаб = ТабОписаний.Добавить();
			СтрокаТаб.КлючОбъекта = Строка.ИмяОбъекта + ?(ДопКлюч = Истина И ЗначениеЗаполнено(Строка.Ключ), "/"+Строка.Ключ, "");
			СтрокаТаб.КлючНастроек = Строка.КлючНастроек;
			СтрокаТаб.Пользователь = Строка.ИмяПользователя;
		КонецЦикла; 
		
		СкопироватьНастройкиПользователей(ТабОписаний, ПользователиПриемник, ЭлементыФормы.ПанельРазделаНастроек.ТекущаяСтраница.Имя);
		///
		
		ирОбщий.СообщитьЛкс(НСтр("ru = 'Настройки скопированы'"));
		ОбновитьСписокОписанийНастроек();
		
	КонецЕсли;	

КонецПроцедуры

Процедура ПанельРазделаНастроекПриСменеСтраницы(Элемент, ТекущаяСтраница)
	
	ОбновитьСписокОписанийНастроек();
	
КонецПроцедуры

Процедура КоманднаяПанельНастроекОткрытьНастройку(Кнопка)
	
	ОткрытьТекНастройку(ЭлементыФормы.ОписаниеНастроек.ТекущиеДанные, Ложь);
	
КонецПроцедуры

Процедура ОткрытьТекНастройку(Знач ТекДанные = Неопределено, Исследовать = Ложь)
	
	Если ТекДанные = Неопределено Тогда
		ТекДанные = ЭлементыФормы.ОписаниеНастроек.ТекущиеДанные;
	КонецЕсли;
	ОткрытьЗначНастройки(ТекДанные, ЭлементыФормы.ПанельРазделаНастроек.ТекущаяСтраница.Имя, Исследовать);

КонецПроцедуры

Процедура ОписаниеНастроекВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОткрытьТекНастройку();
	
КонецПроцедуры

Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	
	Если НЕ ПравоДоступа("Администрирование", Метаданные) Тогда
		Отказ = Истина;
		ирОбщий.СообщитьЛкс("Недостаточно прав.");
	КонецЕсли;
	Если ТипЗнч(ХранилищеНастроекДанныхФорм) <> Тип("СтандартноеХранилищеНастроекМенеджер") Тогда
		ирОбщий.СообщитьЛкс("Поддерживается работа только со стандартным хранилищем настроек форм");
		Отказ = Истина;
	КонецЕсли; 
	
КонецПроцедуры

Процедура КоманднаяПанельНастроекИсследовать(Кнопка)
	
	ОткрытьТекНастройку();
	
КонецПроцедуры

Процедура ФильтрИмяОбъектаОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Элемент.Значение = "";
	ЭлементыФормы.ОписаниеНастроек.ОтборСтрок.ИмяОбъекта.Использование = Ложь; // Так надо делать, чтобы пустые значения тоже отбирались при пустом фильтре
	
КонецПроцедуры

Процедура ФильтрИмяОбъектаНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)

	ирОбщий.ПолеВводаСИсториейВыбора_НачалоВыбораИзСпискаЛкс(Элемент, ЭтаФорма);
	
КонецПроцедуры

Процедура ФильтрИмяОбъектаПриИзменении(Элемент)
	
	ЭлементыФормы.ОписаниеНастроек.ОтборСтрок.ИмяОбъекта.Использование = Истина; 
	ирОбщий.ПолеВводаСИсториейВыбора_ПриИзмененииЛкс(Элемент, ЭтаФорма);
	
КонецПроцедуры

Процедура ФильтрКлючНастроекАвтоПодборТекста(Элемент, Текст, ТекстАвтоПодбора, СтандартнаяОбработка)
	
	ОтключитьОбработчикИзмененияДанных("ЭлементыФормы.ОписаниеНастроек.Отбор");
	ЭлементыФормы.ОписаниеНастроек.ОтборСтрок.КлючНастроек.Использование = Истина; 
	ирОбщий.ПромежуточноеОбновлениеСтроковогоЗначенияПоляВводаЛкс(Элемент, Текст);
	
КонецПроцедуры

Процедура Панель1ПриСменеСтраницы(Элемент, ТекущаяСтраница)
	
	Если ЭлементыФормы.ПанельОтборЗагрузки.ТекущаяСтраница = ЭлементыФормы.ПанельОтборЗагрузки.Страницы.Метаданные Тогда
		Если ДеревоФорм.Строки.Количество() = 0 Тогда
			ПолучитьСписокФорм();
			ОбновитьДеревоФорм();
		КонецЕсли; 
	КонецЕсли; 
	
КонецПроцедуры

Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник) Экспорт
	
	ирОбщий.Форма_ОбработкаОповещенияЛкс(ЭтаФорма, ИмяСобытия, Параметр, Источник); 

КонецПроцедуры

Процедура КлсКомандаНажатие(Кнопка) Экспорт 
	
	ирОбщий.УниверсальнаяКомандаФормыЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура ОбработчикОжиданияСПараметрамиЛкс() Экспорт 
	
	ирОбщий.ОбработчикОжиданияСПараметрамиЛкс();

КонецПроцедуры

Процедура СтруктураКоманднойПанелиНажатие(Кнопка)
	
	ирОбщий.ОткрытьСтруктуруКоманднойПанелиЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура ПриЗакрытии()
	
	ирОбщий.Форма_ПриЗакрытииЛкс(ЭтаФорма);

КонецПроцедуры

Процедура ФильтрКлючНастроекПриИзменении(Элемент)
	
	ЭлементыФормы.ОписаниеНастроек.ОтборСтрок.КлючНастроек.Использование = Истина; 
	ирОбщий.ПолеВводаСИсториейВыбора_ПриИзмененииЛкс(Элемент, ЭтаФорма);

КонецПроцедуры

Процедура ФильтрИмяОбъектаАвтоПодборТекста(Элемент, Текст, ТекстАвтоПодбора, СтандартнаяОбработка)
	
	ОтключитьОбработчикИзмененияДанных("ЭлементыФормы.ОписаниеНастроек.Отбор");
	ЭлементыФормы.ОписаниеНастроек.ОтборСтрок.ИмяОбъекта.Использование = Истина; 
	ирОбщий.ПромежуточноеОбновлениеСтроковогоЗначенияПоляВводаЛкс(Элемент, Текст);

КонецПроцедуры

Процедура ФильтрКлючНастроекОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Элемент.Значение = "";
	ЭлементыФормы.ОписаниеНастроек.ОтборСтрок.КлючНастроек.Использование = Ложь; // Так надо делать, чтобы пустые значения тоже отбирались при пустом фильтре

КонецПроцедуры

Процедура КоманднаяПанельНастроекВыгрузитьВФайл(Кнопка)
	
	КоличествоДляВыгрузки = ЭлементыФормы.ОписаниеНастроек.ВыделенныеСтроки.Количество();
	Если КоличествоДляВыгрузки <= 2 Тогда
		Ответ = Вопрос("Будет выгружено " + КоличествоДляВыгрузки + " настроек. Продолжить?", РежимДиалогаВопрос.ОКОтмена);
		Если Ответ <> КодВозвратаДиалога.ОК Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли; 
	ТабОписаний = ирОбщий.НоваяТаблицаНастроекСтандартногоХранилищаЛкс();
	МенеджерХранилища = ПолучитьМенеджерХранилищаПоИмени(ЭлементыФормы.ПанельРазделаНастроек.ТекущаяСтраница.Имя);
	#Если Сервер И Не Сервер Тогда
	    МенеджерХранилища = ХранилищеОбщихНастроек;
	#КонецЕсли
	Для каждого ВыделеннаяСтрока Из ЭлементыФормы.ОписаниеНастроек.ВыделенныеСтроки Цикл
		ЗначениеНастройки = МенеджерХранилища.Загрузить(ВыделеннаяСтрока.ИмяОбъекта, ВыделеннаяСтрока.КлючНастроек, , ВыделеннаяСтрока.ИмяПользователя);
		Если ЗначениеНастройки = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		СтрокаТаб = ТабОписаний.Добавить();
		СтрокаТаб.ИмяХранилища = ЭлементыФормы.ПанельРазделаНастроек.ТекущаяСтраница.Имя;
		СтрокаТаб.ИмяОбъекта = ВыделеннаяСтрока.ИмяОбъекта;
		СтрокаТаб.КлючНастроек = ВыделеннаяСтрока.КлючНастроек;
		СтрокаТаб.Настройка = Новый ХранилищеЗначения(ЗначениеНастройки);
		СтрокаТаб.ИмяПользователя = ВыделеннаяСтрока.ИмяПользователя;
		СтрокаТаб.Описание = ВыделеннаяСтрока.Описание;
	КонецЦикла; 
	ирОбщий.СохранитьЗначениеВФайлИнтерактивноЛкс(ТабОписаний, , "Настройки пользователей");
	
КонецПроцедуры

Процедура КоманднаяПанельНастроекЗагрузитьИзФайла(Кнопка)
	
	ТабОписаний = ирОбщий.ЗагрузитьЗначениеИзФайлаИнтерактивноЛкс(, "Настройки пользователей");
	Если ТабОписаний = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	Ответ = Вопрос("Загружать настройки для выбранных пользователей (Да) или с именами пользователей (Нет)?
	|Существующие одноименные настройки пользователей будут потеряны.", РежимДиалогаВопрос.ДаНетОтмена);
	Если Ответ = КодВозвратаДиалога.Отмена Тогда
		Возврат;
	КонецЕсли;
	СИменамиПользователей = Ответ = КодВозвратаДиалога.Нет;
	Счетчик = 0;
	НенайденныеПользователи = Новый Соответствие;
	Индикатор = ирОбщий.ПолучитьИндикаторПроцессаЛкс(ТабОписаний.Количество());
	Для Каждого СтрокаНастройки Из ТабОписаний Цикл
		ирОбщий.ОбработатьИндикаторЛкс(Индикатор);
		ИменаПользователей = Новый Массив;
		Если СИменамиПользователей Тогда
			Если НенайденныеПользователи[СтрокаНастройки.ИмяПользователя] <> Неопределено Тогда
				Продолжить;
			КонецЕсли; 
			Если ПользователиИБ.Найти(СтрокаНастройки.ИмяПользователя) = Неопределено Тогда
				НенайденныеПользователи[СтрокаНастройки.ИмяПользователя] = 1;
				ирОбщий.СообщитьЛкс("Пользователь с именем """ + СтрокаНастройки.ИмяПользователя + """ отсутствует в этой базе. Его настройки не будут загружены.");
				Продолжить;
			Иначе
				ИменаПользователей.Добавить(СтрокаНастройки.ИмяПользователя);
			КонецЕсли; 
		Иначе
			Для Каждого ВыбранныйПользователь Из ЭлементыФормы.ДеревоПользователей.ВыделенныеСтроки Цикл
				ИменаПользователей.Добавить(ВыбранныйПользователь.ИмяПользователя);
			КонецЦикла;
		КонецЕсли; 
		МенеджерХранилища = ПолучитьМенеджерХранилищаПоИмени(СтрокаНастройки.ИмяХранилища);
		#Если Сервер И Не Сервер Тогда
		    МенеджерХранилища = ХранилищеОбщихНастроек;
		#КонецЕсли
		Для Каждого ИмяПользователя Из ИменаПользователей Цикл
			НовоеОписаниеНастроек = Новый ОписаниеНастроек;
			НовоеОписаниеНастроек.Представление = СтрокаНастройки.Описание;
			МенеджерХранилища.Сохранить(СтрокаНастройки.ИмяОбъекта, СтрокаНастройки.КлючНастроек, СтрокаНастройки.Настройка.Получить(), НовоеОписаниеНастроек, ИмяПользователя);
		КонецЦикла;
		Счетчик = Счетчик + 1;
	КонецЦикла;
	ирОбщий.ОсвободитьИндикаторПроцессаЛкс();
	ирОбщий.СообщитьЛкс("Загружено " + Счетчик + " настроек");
	ОбновитьСписокОписанийНастроек();
	
КонецПроцедуры

Процедура КоманднаяПанельНастроекОтобратьНастройкиИнструментов(Кнопка)
	
	ЭлементыФормы.ПанельРазделаНастроек.ТекущаяСтраница = ЭлементыФормы.ПанельРазделаНастроек.Страницы.ХранилищеОбщихНастроек;
	ЭлементыФормы.ОписаниеНастроек.ОтборСтрок.ИмяОбъекта.Значение = ирОбщий.ИмяПродуктаЛкс();
	ЭлементыФормы.ОписаниеНастроек.ОтборСтрок.ИмяОбъекта.Использование = Истина; 
	
КонецПроцедуры

Процедура ОписаниеНастроекПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	КоманднаяПанельНастроекУдалитьНастройки();
	
КонецПроцедуры

Процедура ОписаниеНастроекПередНачаломДобавления(Элемент, Отказ, Копирование)
	
	Отказ = Истина;
	
КонецПроцедуры

Процедура ОписаниеНастроекПриАктивизацииСтроки(Элемент)
	
	ирОбщий.ТабличноеПолеПриАктивизацииСтрокиЛкс(ЭтаФорма, Элемент);

КонецПроцедуры

Процедура ОписаниеНастроекПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки) Экспорт
	
	ирОбщий.ТабличноеПолеПриВыводеСтрокиЛкс(ЭтаФорма, Элемент, ОформлениеСтроки, ДанныеСтроки);
	
КонецПроцедуры

Процедура ОбновлениеОтображения()
	
	ирОбщий.Форма_ОбновлениеОтображенияЛкс(ЭтаФорма);

КонецПроцедуры

Процедура ВнешнееСобытие(Источник, Событие, Данные) Экспорт
	
	ирОбщий.Форма_ВнешнееСобытиеЛкс(ЭтаФорма, Источник, Событие, Данные);

КонецПроцедуры

Процедура ТабличноеПолеПриПолученииДанных(Элемент, ОформленияСтрок) Экспорт 
	
	ирОбщий.ТабличноеПолеПриПолученииДанныхЛкс(ЭтаФорма, Элемент, ОформленияСтрок);

КонецПроцедуры

Функция ЗаписатьЗначениеНастройкиСтроки(Знач СтрокаТаб, Знач ИмяРаздела, НовоеЗначение = Неопределено) Экспорт 
	
	МенеджерХранилища = ПолучитьМенеджерХранилищаПоИмени(ИмяРаздела);
	#Если Сервер И Не Сервер Тогда
		СтрокаТаб = ОписаниеНастроек.Добавить();
		МенеджерХранилища = ХранилищеОбщихНастроек;
	#КонецЕсли
	МенеджерХранилища.Сохранить(СтрокаТаб.ИмяОбъекта, СтрокаТаб.КлючНастроек, НовоеЗначение,, СтрокаТаб.ИмяПользователя);
	УстановитьЗначениеНастройкиВСтроке(СтрокаТаб, НовоеЗначение);

КонецФункции

Процедура ОписаниеНастроекНастройкаНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	ОписаниеТипов = ирОбщий.ОписаниеТиповВсеРедактируемыеТипыЛкс();
	#Если Сервер И Не Сервер Тогда
		ОписаниеТипов = Новый ОписаниеТипов;
	#КонецЕсли
	ТабличноеПоле = ЭлементыФормы.ОписаниеНастроек;
	ЗначениеНастройки = ЗначениеНастройкиСтроки(ТабличноеПоле.ТекущиеДанные, ЭлементыФормы.ПанельРазделаНастроек.ТекущаяСтраница.Имя);
	Если ОписаниеТипов.СодержитТип(Типзнч(ЗначениеНастройки)) Тогда
		ЗначениеИзменено = ирОбщий.ПолеВводаКолонкиРасширенногоЗначения_НачалоВыбораЛкс(ЭтаФорма, ТабличноеПоле, СтандартнаяОбработка, ЗначениеНастройки);
		Если ЗначениеИзменено Тогда
			ЗаписатьЗначениеНастройкиСтроки(ТабличноеПоле.ТекущиеДанные, ЭлементыФормы.ПанельРазделаНастроек.ТекущаяСтраница.Имя, ЗначениеНастройки);
		Иначе
			УстановитьЗначениеНастройкиВСтроке(ТабличноеПоле.ТекущиеДанные, ЗначениеНастройки); // Для восстановления расширенного представления
		КонецЕсли; 
	КонецЕсли; 
	
КонецПроцедуры

Процедура ОписаниеНастроекНастройкаПриИзменении(Элемент)
	ТабличноеПоле = ЭлементыФормы.ОписаниеНастроек;
	ЗаписатьЗначениеНастройкиСтроки(ТабличноеПоле.ТекущиеДанные, ЭлементыФормы.ПанельРазделаНастроек.ТекущаяСтраница.Имя, Элемент.Значение);
КонецПроцедуры

Процедура ОписаниеНастроекНастройкаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

ирОбщий.ИнициироватьФормуЛкс(ЭтаФорма, "Обработка.ирРедакторХранилищНастроек.Форма.Форма");
ЭлементыФормы.ОписаниеНастроек.ОтборСтрок.ИмяОбъекта.ВидСравнения = ВидСравнения.Содержит; 
ЭлементыФормы.ОписаниеНастроек.ОтборСтрок.КлючНастроек.ВидСравнения = ВидСравнения.Содержит; 
ОтборЗагрузкиМетаданные = "Все";
ОтборЗагрузкиПользователи = "Все";
// Антибаг платформы. Очищаются свойство данные, если оно указывает на отбор табличной части
ЭлементыФормы.ФильтрИмяОбъекта.Данные = "ЭлементыФормы.ОписаниеНастроек.Отбор.ИмяОбъекта.Значение";
ЭлементыФормы.ФильтрИмяОбъекта.КнопкаСпискаВыбора = Истина;
ЭлементыФормы.ФильтрИмяОбъекта.КнопкаОчистки = Истина;
ЭлементыФормы.ФильтрКлючНастроек.Данные = "ЭлементыФормы.ОписаниеНастроек.Отбор.КлючНастроек.Значение";
ЭлементыФормы.ФильтрКлючНастроек.КнопкаСпискаВыбора = Истина;
ЭлементыФормы.ФильтрКлючНастроек.КнопкаОчистки = Истина;
