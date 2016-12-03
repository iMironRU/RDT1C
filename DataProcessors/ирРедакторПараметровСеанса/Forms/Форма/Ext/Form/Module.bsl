﻿//Запомним ограничение типа
Перем МассивНередактируемыхТипов;

Процедура КнопкаВыполнитьНажатие(Кнопка)
	// Вставить содержимое обработчика.
КонецПроцедуры

Процедура КоманднаяПанель1ЗаписатьПараметрыСеанса(Кнопка)
	
	Для каждого Стр Из ТаблицаПараметровСеанса Цикл
		
		Если НЕ Стр.ПризнакМодификации Тогда
		
			Продолжить;
		                                                                               
		КонецЕсли;
		
		Если ПравоДоступа("Установка", Метаданные.ПараметрыСеанса[Стр.ИдентификаторПараметраСеанса], ПользователиИнформационнойБазы.ТекущийПользователь()) Тогда
		
			ПараметрыСеанса[Стр.ИдентификаторПараметраСеанса] = Стр.Значение;
			ЗаписьЖурналаРегистрации("Редактирование параметра сеанса", УровеньЖурналаРегистрации.Информация,
				Метаданные.ПараметрыСеанса[Стр.ИдентификаторПараметраСеанса], Стр.ЗначениеПараметраСеанса);
			Стр.ПризнакМодификации = Ложь;
			
		КонецЕсли; 
		
	КонецЦикла;
	Модифицированность = Ложь;
	
КонецПроцедуры

Процедура ПрочитатьПараметрыСеансаИзБазы()

	Если ЭлементыФормы.ТаблицаПараметровСеанса.ТекущаяСтрока <> Неопределено Тогда
		ИмяТекущегоПараметра = ЭлементыФормы.ТаблицаПараметровСеанса.ТекущаяСтрока.ИдентификаторПараметраСеанса;
	КонецЕсли; 
	ТаблицаПараметровСеанса.Очистить();
	Для каждого ПарамСеанса Из Метаданные.ПараметрыСеанса Цикл
		Если НЕ ПравоДоступа("Чтение", ПарамСеанса, ПользователиИнформационнойБазы.ТекущийПользователь()) Тогда
			Продолжить;
		КонецЕсли;
		Если ПарамСеанса.Тип.Типы()[0] = Тип("ХранилищеЗначения") Тогда
			Продолжить;
		КонецЕсли; 
		НоваяСтрока = ТаблицаПараметровСеанса.Добавить();
		НоваяСтрока.ИдентификаторПараметраСеанса = ПарамСеанса.Имя;
		НоваяСтрока.СинонимПараметраСеанса = ПарамСеанса.Синоним;
		НоваяСтрока.ОписаниеТипов = ПарамСеанса.Тип;
		Попытка
			НоваяСтрока.Значение = ПараметрыСеанса[ПарамСеанса.Имя];
			НоваяСтрока.ЗначениеПараметраСеанса = ПараметрыСеанса[ПарамСеанса.Имя];
		Исключение
			НоваяСтрока.ЗначениеПараметраСеанса = "<Не инициализирован>";
			НоваяСтрока.Значение = НоваяСтрока.ЗначениеПараметраСеанса;
		КонецПопытки; 
		ирОбщий.ОбновитьТипЗначенияИзОписанияТиповЛкс(НоваяСтрока);
		НоваяСтрока.РазрешеноИзменение = Истина
			И ПравоДоступа("Изменение", ПарамСеанса, ПользователиИнформационнойБазы.ТекущийПользователь())
	КонецЦикла;
	Если ИмяТекущегоПараметра <> Неопределено Тогда
		НоваяТекущаяСтрока = ТаблицаПараметровСеанса.Найти(ИмяТекущегоПараметра, "ИдентификаторПараметраСеанса");
		Если НоваяТекущаяСтрока <> Неопределено Тогда
			ЭлементыФормы.ТаблицаПараметровСеанса.ТекущаяСтрока = НоваяТекущаяСтрока
		КонецЕсли; 
	КонецЕсли;
	Модифицированность = Ложь;
	
КонецПроцедуры

Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	ПрочитатьПараметрыСеансаИзБазы();
КонецПроцедуры

Процедура ТаблицаПараметровСеансаПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	
	Если ДанныеСтроки.ПризнакМодификации = Истина Тогда
		ОформлениеСтроки.ЦветТекста = WebЦвета.КожаноКоричневый;
	КонецЕсли; 
	Если Истина
		И ДанныеСтроки.РазрешеноИзменение
		И ТипЗнч(ДанныеСтроки.ЗначениеПараметраСеанса) = Тип("Булево") 
	Тогда
		ОформлениеСтроки.Ячейки.ЗначениеПараметраСеанса.УстановитьФлажок(ДанныеСтроки.ЗначениеПараметраСеанса);
	КонецЕсли; 
	
	Если Ложь
		Или НЕ ДанныеСтроки.РазрешеноИзменение
	Тогда
		ОформлениеСтроки.Ячейки.ЗначениеПараметраСеанса.ТолькоПросмотр = Ложь;
		ОформлениеСтроки.Ячейки.ОформлениеЯчейки.ЦветФона = WebЦвета.СеребристоСерый;
	КонецЕсли;
	
	ирОбщий.ТабличноеПолеПриВыводеСтрокиЛкс(Элемент, ОформлениеСтроки, ДанныеСтроки,, "ЗначениеПараметраСеанса", Новый Структура("ЗначениеПараметраСеанса", "Значение"), Истина);

КонецПроцедуры

// <Описание функции>
//
// Параметры:
//  <Параметр1>  – <Тип.Вид> – <описание параметра>
//                 <продолжение описания параметра>;
//  <Параметр2>  – <Тип.Вид> – <описание параметра>
//                 <продолжение описания параметра>.
//
// Возвращаемое значение:
//               – <Тип.Вид> – <описание значения>
//                 <продолжение описания значения>;
//  <Значение2>  – <Тип.Вид> – <описание значения>
//                 <продолжение описания значения>.
//
Функция ПроверкаМодифицированностиФормы()

	Если ЭтаФорма.Модифицированность Тогда
		Ответ = Вопрос("Данные в форме были изменены. Сохранить изменения?", РежимДиалогаВопрос.ДаНетОтмена);
		Если Ответ = КодВозвратаДиалога.Отмена Тогда
			Возврат Ложь;
		ИначеЕсли Ответ = КодВозвратаДиалога.Да Тогда
			КоманднаяПанель1ЗаписатьПараметрыСеанса(0);
		КонецЕсли;
	КонецЕсли;
	Возврат Истина;

КонецФункции // ПроверкаМодифицированностиФормы()

Процедура КоманднаяПанель1Перечиать(Кнопка)
	
	Если Не ПроверкаМодифицированностиФормы() Тогда
		Возврат;
	КонецЕсли;
	ПрочитатьПараметрыСеансаИзБазы();
	
КонецПроцедуры

Процедура ТаблицаПараметровСеансаПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	ТекДанные = Элемент.ТекущиеДанные;
	Элемент.Колонки.ЗначениеПараметраСеанса.ЭлементУправления.ОграничениеТипа = Метаданные.ПараметрыСеанса[Элемент.ТекущиеДанные.ИдентификаторПараметраСеанса].Тип;
КонецПроцедуры

Процедура правка(Кнопка)
	// Вставить содержимое обработчика.
КонецПроцедуры

Процедура ПриОткрытии()
	
	Если ЗначениеЗаполнено(НачальноеЗначениеВыбора) Тогда
		ТекущаяСтрока = ТаблицаПараметровСеанса.Найти(НачальноеЗначениеВыбора, "ИдентификаторПараметраСеанса");
		Если ТекущаяСтрока <> Неопределено Тогда
			ЭтаФорма.ЭлементыФормы.ТаблицаПараметровСеанса.ТекущаяСтрока = ТекущаяСтрока;
		КонецЕсли; 
	КонецЕсли; 
	
КонецПроцедуры

Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Отказ = Не ПроверкаМодифицированностиФормы();
	
КонецПроцедуры

Процедура КоманднаяПанель1ОПодсистеме(Кнопка)
	ирОбщий.ОткрытьСправкуПоПодсистемеЛкс(ЭтотОбъект);
КонецПроцедуры

Процедура КоманднаяПанель1Исследовать(Кнопка)
	
	ирОбщий.ИсследоватьЛкс(ТаблицаПараметровСеанса,, Истина);
	
КонецПроцедуры

Процедура ТаблицаПараметровСеансаЗначениеПараметраСеансаОткрытие(Элемент, СтандартнаяОбработка)
	
	ВыбраннаяСтрока = ЭлементыФормы.ТаблицаПараметровСеанса.ТекущаяСтрока;
	Если МассивНередактируемыхТипов.Найти(ТипЗнч(ВыбраннаяСтрока.Значение)) <> Неопределено Тогда
		ирОбщий.ИсследоватьЛкс(ВыбраннаяСтрока.Значение);
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	
КонецПроцедуры

Процедура ТаблицаПараметровСеансаЗначениеПараметраСеансаПриИзменении(Элемент)
	
	ВыбраннаяСтрока = ЭлементыФормы.ТаблицаПараметровСеанса.ТекущаяСтрока;
	ВыбраннаяСтрока.Значение = Элемент.Значение;
	ПриИзмененииЗначенияПараметраСеанса()
	
КонецПроцедуры

Процедура ТаблицаПараметровСеансаПриИзмененииФлажка(Элемент, Колонка)
	
	ирОбщий.ИнтерактивноЗаписатьВКолонкуТабличногоПоляЛкс(Элемент, Колонка, Не Элемент.ТекущаяСтрока[Колонка.Данные]);

КонецПроцедуры

Процедура ТаблицаПараметровСеансаЗначениеПараметраСеансаОкончаниеВводаТекста(Элемент, Текст, Значение, СтандартнаяОбработка)
	
	ирОбщий.ПолеВвода_ОкончаниеВводаТекстаЛкс(Элемент, Текст, Значение, СтандартнаяОбработка, ЭлементыФормы.ТаблицаПараметровСеанса.ТекущаяСтрока.Значение);
	
КонецПроцедуры

Процедура КоманднаяПанель1ЖурналРегистрации(Кнопка)
	
	ТекущаяСтрока = ЭлементыФормы.ТаблицаПараметровСеанса.ТекущаяСтрока;
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	АнализЖурналаРегистрации = ирОбщий.ПолучитьОбъектПоПолномуИмениМетаданныхЛкс("Обработка.ирАнализЖурналаРегистрации");
	#Если Сервер И Не Сервер Тогда
		АнализЖурналаРегистрации = Обработки.ирАнализЖурналаРегистрации.Создать();
	#КонецЕсли
	АнализЖурналаРегистрации.ОткрытьСПараметром("Метаданные", "ПараметрСеанса." + ТекущаяСтрока.ИдентификаторПараметраСеанса);

КонецПроцедуры

Процедура ТаблицаПараметровСеансаЗначениеПараметраСеансаНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	ЗначениеИзменено = ирОбщий.ПолеВводаКолонкиРасширенногоЗначения_НачалоВыбораЛкс(ЭлементыФормы.ТаблицаПараметровСеанса, СтандартнаяОбработка,
		ЭлементыФормы.ТаблицаПараметровСеанса.ТекущаяСтрока.Значение);
	Если ЗначениеИзменено Тогда
		ПриИзмененииЗначенияПараметраСеанса();
	КонецЕсли; 
	
КонецПроцедуры

Процедура ПриИзмененииЗначенияПараметраСеанса()
	
	ВыбраннаяСтрока = ЭлементыФормы.ТаблицаПараметровСеанса.ТекущаяСтрока;
	ВыбраннаяСтрока.ПризнакМодификации = Истина;
	ЭтаФорма.Модифицированность = Истина;
	ирОбщий.ОбновитьТипЗначенияИзОписанияТиповЛкс(ВыбраннаяСтрока);

КонецПроцедуры

Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	ирОбщий.ФормаОбработкаОповещенияЛкс(ЭтаФорма, ИмяСобытия, Параметр, Источник); 

КонецПроцедуры

Процедура КлсУниверсальнаяКомандаНажатие(Кнопка) Экспорт 
	
	ирОбщий.УниверсальнаяКомандаФормыЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура ОбработчикОжиданияСПараметрамиЛкс() Экспорт 
	
	ирОбщий.ОбработчикОжиданияСПараметрамиЛкс();

КонецПроцедуры

Процедура ТаблицаПараметровСеансаВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	Если ирОбщий.ЯчейкаТабличногоПоляРасширенногоЗначения_ВыборЛкс(Элемент, СтандартнаяОбработка, ВыбраннаяСтрока.Значение) Тогда 
		ПриИзмененииЗначенияПараметраСеанса();
	КонецЕсли; 
	
КонецПроцедуры

ирОбщий.ИнициализироватьФормуЛкс(ЭтаФорма, "Обработка.ирРедакторПараметровСеанса.Форма.Форма");
МассивНередактируемыхТипов = Новый массив;
МассивНередактируемыхТипов.Добавить(Тип("ФиксированныйМассив"));
МассивНередактируемыхТипов.Добавить(Тип("ФиксированнаяСтруктура"));
МассивНередактируемыхТипов.Добавить(Тип("ФиксированноеСоответствие"));
МассивНередактируемыхТипов.Добавить(Тип("ХранилищеЗначения"));
МассивНередактируемыхТипов.Добавить(Тип("УникальныйИдентификатор"));

ТаблицаПараметровСеанса.Колонки.Добавить("Значение");
