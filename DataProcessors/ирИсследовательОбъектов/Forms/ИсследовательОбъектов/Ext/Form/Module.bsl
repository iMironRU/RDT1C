﻿Перем КорневаяСтрока;
Перем БазовоеВыражение Экспорт;
Перем _Значение_ Экспорт;
Перем МаркерСловаЗначения;
Перем СтруктураТипаЗначения;
Перем мСписокПоследнихИспользованныхВыражений;
Перем ИмяТекущегоСвойства Экспорт;
Перем мАвтоКонтекстнаяПомощь;
Перем ИсследуемоеЗначениеЗаменено; // Признак того, что исследуемое значение (ссылка на объект в памяти) было заменено (в результате редактирования в спец. редакторе)
Перем мПлатформа;

Процедура УстановитьИсследуемоеЗначение(пЗначение, пПутьКДанным = Неопределено, пСтруктураТипа = Неопределено) Экспорт 

	ИсследуемоеЗначениеЗаменено = Ложь;
	БазовоеВыражение = пПутьКДанным;
	ЭтаФорма[МаркерСловаЗначения] = пЗначение;
	Если БазовоеВыражение = Неопределено Тогда
		Выражение = МаркерСловаЗначения;
	Иначе
		Выражение = БазовоеВыражение;
	КонецЕсли;
	СтруктураТипаЗначения = пСтруктураТипа;
	ЭтаФорма.ЭлементыФормы.Выражение.ТолькоПросмотр = БазовоеВыражение <> Неопределено;
	ЭтаФорма.ЭлементыФормы.КоманднаяПанельДерева.Кнопки.ГлобальныйКонтекст.Доступность = (БазовоеВыражение = Неопределено);

КонецПроцедуры // УстановитьИсследуемоеЗначение()

//Процедура УстановитьСписокПоследнихИспользованныхВыражений()

//	мСписокПоследнихИспользованныхВыражений = ВосстановитьЗначение("ирИсследовательОбъектов.СписокПоследнихИспользованныхВыражений");
//	Если мСписокПоследнихИспользованныхВыражений = Неопределено Тогда
//		мСписокПоследнихИспользованныхВыражений = Новый СписокЗначений;
//	КонецЕсли;
//	ЭлементыФормы.Выражение.СписокВыбора = мСписокПоследнихИспользованныхВыражений;

//КонецПроцедуры // УстановитьСписокПоследнихИспользованныхВыражений()

//Процедура ОбновитьСписокПоследнихИспользованныхВыражений()

//	Если мСписокПоследнихИспользованныхВыражений.Количество() > 0 Тогда
//		Если мСписокПоследнихИспользованныхВыражений[0] = Выражение Тогда
//			Возврат;
//		КонецЕсли;
//	КонецЕсли;
//	мСписокПоследнихИспользованныхВыражений.Вставить(0, Выражение);
//	Если мСписокПоследнихИспользованныхВыражений.Количество() > 40 Тогда
//		мСписокПоследнихИспользованныхВыражений.Удалить(мСписокПоследнихИспользованныхВыражений.Количество() - 1);
//	КонецЕсли;
//	СохранитьЗначение("ирИсследовательОбъектов.СписокПоследнихИспользованныхВыражений", мСписокПоследнихИспользованныхВыражений);

//КонецПроцедуры // ОбновитьСписокПоследнихИспользованныхВыражений()

Функция ПолучитьПолныйПуть(СтрокаДерева, Знач КромеВерхнего = Ложь)

	Результат = "";
	Если СтрокаДерева = Неопределено Тогда
	ИначеЕсли Истина
		И КромеВерхнего
		И СтрокаДерева.Родитель = Неопределено
	Тогда
	Иначе
		ПолныйПутьКРодителю = ПолучитьПолныйПуть(СтрокаДерева.Родитель, КромеВерхнего);
		Если ПолныйПутьКРодителю <> "" Тогда
			Результат = ПолныйПутьКРодителю;
		КонецЕсли;
		Если СтрокаДерева.ТипСлова <> "Группа" Тогда
			Если Результат <> "" Тогда
				Результат = Результат + ".";
			КонецЕсли; 
			Результат = Результат + СтрокаДерева.Слово; 
			Если СтрокаДерева.ТипСлова = "Метод" Тогда
				Результат = Результат + "()";
			КонецЕсли;
		КонецЕсли; 
	КонецЕсли;
	Возврат Результат;

КонецФункции // ПолучитьПолныйПуть()

Процедура ЗаполнитьСтрокуСлова(СтрокаДерева)

	СтрокаДерева.Строки.Очистить();
	ЗначениеСтроки = СтрокаДерева.Значение;
	Если Не СтрокаДерева.Успех Тогда 
		Если СтрокаДерева.ТипСлова <> "Метод" Тогда
			ТекстРодителя = "";
			Если СтрокаДерева.Родитель <> Неопределено Тогда
				ЗначениеРодителя = СтрокаДерева.Родитель.Значение;
				//Если НРег(ЗначениеРодителя) <> НРег("<ГлобальныйКонтекст>") Тогда
				Если СтрокаДерева.Родитель.ТипСлова <> "Группа" Тогда
					ТекстРодителя = "ЗначениеРодителя.";
				КонецЕсли; 
			КонецЕсли;
			Попытка
				ДочернееЗначение = Вычислить(ТекстРодителя + СтрокаДерева.Слово);
				НовыйУспех = Истина;
			Исключение
				ДочернееЗначение = ОписаниеОшибки();
				НовыйУспех = Ложь;
			КонецПопытки;
		Иначе
			НовыйУспех = Неопределено;
		КонецЕсли; 
	Иначе
		НовыйУспех = Истина;
		ДочернееЗначение = ЗначениеСтроки;
	КонецЕсли; 
	УстановитьЗначениеСловаВСтроке(СтрокаДерева, НовыйУспех, ДочернееЗначение);
	
	Если СтрокаДерева.ТипСлова <> "Группа" Тогда
		Если Ложь
			Или Не СтрокаДерева.Успех 
			Или СтрокаДерева.Значение = Неопределено
			Или СтрокаДерева.Значение = Null
		Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли; 
	
	Если СтрокаДерева.СтруктураТипа = Неопределено Тогда 
		Если Истина
			И СтрокаДерева.ТаблицаСтруктурТипов <> Неопределено
			И СтрокаДерева.ТаблицаСтруктурТипов.Количество() = 1 
		Тогда
			СтрокаДерева.СтруктураТипа = СтрокаДерева.ТаблицаСтруктурТипов[0];
		Иначе
			СтруктураТипаЗначения = мПлатформа.ПолучитьСтруктуруТипаИзЗначения(СтрокаДерева.Значение, ,
				Новый Структура("Метаданные", СтрокаДерева.Значение));
			Если СтрокаДерева.ТаблицаСтруктурТипов <> Неопределено Тогда
				НайденоСовпадение = Ложь;
				Для Каждого СтруктураТипа Из СтрокаДерева.ТаблицаСтруктурТипов Цикл
					Если Истина
						И СтруктураТипаЗначения.ИмяОбщегоТипа = СтруктураТипа.ИмяОбщегоТипа 
					Тогда
						СтрокаДерева.СтруктураТипа = СтруктураТипа;
						НайденоСовпадение = Истина;
					КонецЕсли;
				КонецЦикла;
				Если Не НайденоСовпадение Тогда
					СтрокаДерева.СтруктураТипа = СтруктураТипаЗначения;
				КонецЕсли; 
			КонецЕсли; 
		КонецЕсли;
	КонецЕсли;
	
	Если Истина
		И СтрокаДерева.СтруктураТипа <> Неопределено
		И (Ложь
			Или СтрокаДерева.СтруктураТипа.Метаданные = Неопределено
			// "метаданные = метаданные" дает ложь
			Или ТипЗнч(СтрокаДерева.СтруктураТипа.Метаданные) = Тип("ОбъектМетаданныхКонфигурация"))
		И (Ложь
			Или мПлатформа.мМассивТиповВключающихМетаданные.Найти(СтрокаДерева.ТипЗначения) <> Неопределено
			Или мПлатформа.мМассивТиповЭлементовУправления.Найти(СтрокаДерева.ТипЗначения) <> Неопределено)
	Тогда
		СтрокаДерева.СтруктураТипа.Метаданные = СтрокаДерева.Значение;
	КонецЕсли;
	ЭтоАгрегатноеЗначение = Истина;
	//Если Выражение <> "<ГлобальныйКонтекст>" Тогда
	Если СтрокаДерева.ТипСлова <> "Группа" Тогда
		// %%%% Опасный прием
		СтрокаДерева.СтруктураТипа = мПлатформа.ПолучитьСтруктуруТипаИзЗначения(СтрокаДерева.Значение, Ложь, СтрокаДерева.СтруктураТипа);
		
		// Способ 1
		Попытка
			Пустышка = СтрокаДерева.Значение.а;
		Исключение
			ОписаниеОшибки = ОписаниеОшибки();
			Если Найти(ОписаниеОшибки, "объектного типа") > 0 Тогда
				ЭтоАгрегатноеЗначение = Ложь;
			КонецЕсли; 
		КонецПопытки; 
		
		//// Способ 2
		//КоличествоДочерних = ПолучитьТаблицуИнформатора(ДочернееЗначение, , ФЛАГ_ЗАПОЛНЕНИЯ_ПРОВЕРИТЬ_СУЩЕСТВОВАНИЕ_СВОЙСТВ_И_МЕТОДОВ);
		//ЭтоАгрегатноеЗначение = (КоличествоДочерних > 0);
	КонецЕсли; 
	
	Если ЭтоАгрегатноеЗначение Тогда 
		СтрокаДерева.Строки.Добавить();
	КонецЕсли; 

КонецПроцедуры // ЗаполнитьСтрокуСлова()

Процедура мВычислитьВыражение() 

	//ОбновитьСписокПоследнихИспользованныхВыражений();
	ДеревоЗначений.Строки.Очистить();
	КорневаяСтрока = ДеревоЗначений.Строки.Добавить();
	КорневаяСтрока.Слово = Выражение;
	Если Выражение = "<ГлобальныйКонтекст>" Тогда
		Значение = Выражение;
		КорневаяСтрока.ТипСлова = "Группа";
	Иначе
		КорневаяСтрока.ТипСлова = "Свойство";
		Если Истина
			И БазовоеВыражение <> Неопределено
			И Найти(Выражение, БазовоеВыражение) = 1
		Тогда
			ВыражениеДляВычисления = "_Значение_" + Сред(Выражение, СтрДлина(БазовоеВыражение) + 1);
		Иначе
			ВыражениеДляВычисления = Выражение;
		КонецЕсли; 
		Попытка
			Значение = Вычислить(ВыражениеДляВычисления);
		Исключение
			//КорневаяСтрока.ПредставлениеЗначения = ирОбщий.ПолучитьИнформациюОбОшибкеБезВерхнегоМодуляЛкс(ИнформацияОбОшибке());
			ИнформацияОбОшибке = ИнформацияОбОшибке();
			Если ИнформацияОбОшибке.Причина <> Неопределено Тогда
				ОписаниеОшибки = ИнформацияОбОшибке.Описание + ": " + ПодробноеПредставлениеОшибки(ИнформацияОбОшибке.Причина);
			Иначе
				ОписаниеОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке);
			КонецЕсли; 
			КорневаяСтрока.ПредставлениеЗначения = ОписаниеОшибки;
			КорневаяСтрока.ПредставлениеТипаЗначения = "<Ошибка>";
			ЭлементыФормы.ДеревоЗначений.Колонки.ПредставлениеЗначения.ВысотаЯчейки = 10;
			Возврат;
		КонецПопытки;
	КонецЕсли; 
	Если СтруктураТипаЗначения <> Неопределено Тогда
		КорневаяСтрока.СтруктураТипа = СтруктураТипаЗначения;
	Иначе
		ШаблонСтруктуры = Новый Структура;
		лТипЗначения = ТипЗнч(Значение);
		Если Ложь
			Или мПлатформа.мМассивТиповВключающихМетаданные.Найти(лТипЗначения) <> Неопределено
			Или мПлатформа.мМассивТиповЭлементовУправления.Найти(лТипЗначения) <> Неопределено
		Тогда 
			ШаблонСтруктуры.Вставить("Метаданные", Значение);
		КонецЕсли;
		КорневаяСтрока.СтруктураТипа = мПлатформа.ПолучитьСтруктуруТипаИзЗначения(Значение, , ШаблонСтруктуры);
	КонецЕсли;
	//КорневаяСтрока.ПредставлениеТипаЗначения = ТипЗнч(Значение);
	//КорневаяСтрока.ТипЗначения = ТипЗнч(Значение);
	//КорневаяСтрока.ПредставлениеЗначения = ирОбщий.ПолучитьРасширенноеПредставлениеЗначенияЛкс(Значение);
	Если КорневаяСтрока.ТипСлова <> "Группа" Тогда
		КорневаяСтрока.Значение = Значение;
	КонецЕсли; 
	КорневаяСтрока.Успех = Истина;
	ЗаполнитьСтрокуСлова(КорневаяСтрока);
	УстановитьЗначениеСловаВСтроке(КорневаяСтрока, Истина, Значение);
	ТекущаяСтрока = КорневаяСтрока;
	Если КорневаяСтрока.Строки.Количество() > 0 Тогда 
		НоваяВысотаЯчейки = 1;
		Если ЗначениеЗаполнено(ИмяТекущегоСвойства) Тогда
			ЭлементыФормы.ДеревоЗначений.Развернуть(КорневаяСтрока);
			СтрокаСвойства = КорневаяСтрока.Строки.Найти(ИмяТекущегоСвойства, "Слово");
			Если СтрокаСвойства <> Неопределено Тогда
				ТекущаяСтрока = СтрокаСвойства;
			КонецЕсли; 
			ИмяТекущегоСвойства = "";
		КонецЕсли; 
	Иначе
		НоваяВысотаЯчейки = 10;
	КонецЕсли; 
	ЭлементыФормы.ДеревоЗначений.Колонки.ПредставлениеЗначения.ВысотаЯчейки = НоваяВысотаЯчейки;
	ЭлементыФормы.ДеревоЗначений.ТекущаяСтрока = ТекущаяСтрока;

КонецПроцедуры // Вычислить()

Процедура ВыражениеОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	СтруктураТипаЗначения = Неопределено;
	мВычислитьВыражение();
	
КонецПроцедуры

Процедура ПриОткрытии()
	
	//УстановитьСписокПоследнихИспользованныхВыражений();
	Если Выражение <> "" Тогда
		мВычислитьВыражение();
	Иначе
		УстановитьГлобальныйКонтекст();
	КонецЕсли;
	
КонецПроцедуры

Процедура ДеревоЗначенийПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	
	ЯчейкаЗначения = ОформлениеСтроки.Ячейки.ПредставлениеЗначения;
	Если Истина
		И ДанныеСтроки.ТипСлова = "Метод" 
		И ДанныеСтроки.Успех = Ложь
	Тогда
		ЯчейкаЗначения.ЦветТекста = Новый Цвет(100, 100, 100);
	КонецЕсли;
	ЯчейкаКартинки = ОформлениеСтроки.Ячейки.Слово;
	ЯчейкаКартинки.ОтображатьКартинку = Истина;
	ЯчейкаКартинки.ИндексКартинки = ирОбщий.ПолучитьИндексКартинкиСловаПодсказкиЛкс(ДанныеСтроки);
	
	Если ДанныеСтроки.Успех Тогда
		ирОбщий.ОформитьЯчейкуСРасширеннымЗначениемЛкс(ОформлениеСтроки.Ячейки.ПредставлениеЗначения, ДанныеСтроки.Значение, Элемент.Колонки.ПредставлениеЗначения);
	КонецЕсли; 
	Если ДанныеСтроки.КоличествоЭлементов <> Неопределено Тогда
		КоличествоЭлементов = ОформлениеСтроки.Ячейки.КоличествоЭлементов;
		КоличествоЭлементов.ЦветФона = Новый Цвет(230, 240, 240);
	КонецЕсли; 

КонецПроцедуры

Процедура ДеревоЗначенийПередРазворачиванием(Элемент, СтрокаДерева, Отказ)
	
	Если Истина
		И СтрокаДерева.ТипСлова = "Группа" 
		И СтрокаДерева.Слово <> "<ГлобальныйКонтекст>"
	Тогда
		Возврат;
	КонецЕсли; 
	Отказ = Истина;
	СтрокаДерева.Строки.Очистить();
	ВнутренняяТаблицаСлов = мПлатформа.ПолучитьТаблицуСловСтруктурыТипа(СтрокаДерева.СтруктураТипа);
	ВнутренняяТаблицаСлов.Сортировать("Слово, ТипСлова");
	Индикатор = ирОбщий.ПолучитьИндикаторПроцессаЛкс(ВнутренняяТаблицаСлов.Количество());
	СтрокаМетодов = Неопределено;
	Для Каждого ВнутренняяСтрокаСлова Из ВнутренняяТаблицаСлов Цикл
		ирОбщий.ОбработатьИндикаторЛкс(Индикатор);
		Если ВнутренняяСтрокаСлова.ТипСлова = "Метод" Тогда 
			Если СтрокаМетодов = Неопределено Тогда
				СтрокаМетодов = СтрокаДерева.Строки.Вставить(0);
				СтрокаМетодов.Слово = "<Методы>";
				СтрокаМетодов.ТипСлова = "Группа";
			КонецЕсли; 
			НоваяСтрока = СтрокаМетодов.Строки.Добавить();
			НоваяСтрока.ПредставлениеЗначения = "<Двойной клик для вычисления>";
		Иначе
			НоваяСтрока = СтрокаДерева.Строки.Добавить();
		КонецЕсли;
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ВнутренняяСтрокаСлова);
		СтрокаПредставления = "";
		Если ВнутренняяСтрокаСлова.ТаблицаСтруктурТипов <> Неопределено Тогда
			НоваяСтрока.ТаблицаСтруктурТипов = ВнутренняяСтрокаСлова.ТаблицаСтруктурТипов;
			Для Каждого СтруктураТипа Из НоваяСтрока.ТаблицаСтруктурТипов Цикл
				СтрокаПредставления = СтрокаПредставления + ", " + мПлатформа.ПолучитьСтрокуКонкретногоТипа(СтруктураТипа);
			КонецЦикла;
			НоваяСтрока.ПредставлениеДопустимыхТипов = Сред(СтрокаПредставления, 3);
		КонецЕсли; 
		ЗаполнитьСтрокуСлова(НоваяСтрока);
	КонецЦикла;
	ирОбщий.ОсвободитьИндикаторПроцессаЛкс();
	// Дополнительные свойства от информатора
	//ЗначениеДляИнформатора = СтрокаДерева.Слово = "<ГлобальныйКонтекст>", Платформа.СТРОКА_ГЛОБАЛЬНЫЙ_КОНТЕКСТ, СтрокаДерева.Значение);
	ЗначениеДляИнформатора = СтрокаДерева.Значение;
	Если ТипЗнч(ЗначениеДляИнформатора) <> Тип("COMОбъект") Тогда // На некоторых (WScript.Shell) падает
		МетодыОтИнформатора = мПлатформа.ПолучитьТаблицуСвойствОбъектаИнформатором(ЗначениеДляИнформатора, "Метод");
		Для Каждого СтрокаОписанияМетода Из МетодыОтИнформатора Цикл
			Если СтрокаМетодов = Неопределено Тогда
				СтрокаМетодов = СтрокаДерева.Строки.Вставить(0);
				СтрокаМетодов.Слово = "<Методы>";
				СтрокаМетодов.ТипСлова = "Группа";
			КонецЕсли; 
			НоваяСтрока = СтрокаМетодов.Строки.Найти(СтрокаОписанияМетода.Name, "Слово");
			Если НоваяСтрока <> Неопределено Тогда
				Если СтрокаОписанияМетода.Val = 0 Тогда
					НоваяСтрока.ПредставлениеЗначения = "<Недоступно>";
				КонецЕсли; 
				Продолжить;
			КонецЕсли; 
			НоваяСтрока = СтрокаМетодов.Строки.Добавить();
			НоваяСтрока.Слово = СтрокаОписанияМетода.Name;
			НоваяСтрока.ТипСлова = "Метод";
			НоваяСтрока.Определение = "Локальный";
			НоваяСтрока.ТаблицаСтруктурТипов = мПлатформа.ПолучитьНовуюТаблицуСтруктурТипа();
			Если СтрокаОписанияМетода.Val > 0 Тогда
				НоваяСтрока.ПредставлениеЗначения = "<Двойной клик для вычисления>";
				СтруктураТипа = мПлатформа.ПолучитьНовуюСтруктуруТипа();
				СтруктураТипа.ИмяОбщегоТипа = "Произвольный";
				ЗаполнитьЗначенияСвойств(НоваяСтрока.ТаблицаСтруктурТипов.Добавить(), СтруктураТипа);
			Иначе
				НоваяСтрока.ПредставлениеЗначения = "<Недоступно>";
			КонецЕсли; 
			ЗаполнитьСтрокуСлова(НоваяСтрока);
		КонецЦикла; 
		СвойстваОтИнформатора = мПлатформа.ПолучитьТаблицуСвойствОбъектаИнформатором(ЗначениеДляИнформатора, "Свойство");
		Для Каждого СтрокаОписанияСвойства Из СвойстваОтИнформатора Цикл
			НоваяСтрока = СтрокаДерева.Строки.Найти(СтрокаОписанияСвойства.Name, "Слово");
			Если НоваяСтрока <> Неопределено Тогда
				Продолжить;
			КонецЕсли; 
			Если СтрокаДерева.Слово = "<ГлобальныйКонтекст>" Тогда
				Попытка
					 ЗначениеСвойства = Вычислить(СтрокаОписанияСвойства.Name);
				 Исключение
					 Продолжить;
				КонецПопытки; 
			Иначе
				Попытка
					 ЗначениеСвойства = Вычислить("СтрокаДерева.Значение." + СтрокаОписанияСвойства.Name);
				 Исключение
					 Продолжить;
				КонецПопытки; 
			КонецЕсли; 
			НоваяСтрока = СтрокаДерева.Строки.Добавить();
			НоваяСтрока.ТаблицаСтруктурТипов = мПлатформа.ПолучитьНовуюТаблицуСтруктурТипа();
			НоваяСтрока.Слово = СтрокаОписанияСвойства.Name;
			НоваяСтрока.ТипСлова = "Свойство";
			НоваяСтрока.Определение = "Локальный";
			НоваяСтрока.Значение = ЗначениеСвойства;
			ЗаполнитьСтрокуСлова(НоваяСтрока);
		КонецЦикла; 
		СтрокаДерева.Строки.Сортировать("Слово");
		Если СтрокаМетодов <> Неопределено Тогда
			СтрокаМетодов.Строки.Сортировать("Слово");
		КонецЕсли; 
	КонецЕсли; 
	// КОНЕЦ.ДОБАВЛЕНИЕ.Информатор
	
	Отказ = Ложь;
	
КонецПроцедуры

Процедура ВыражениеПриИзменении(Элемент)

	СтруктураТипаЗначения = Неопределено;
	мВычислитьВыражение();
	ирОбщий.ПолеВводаСИсториейВыбора_ПриИзмененииЛкс(Элемент, Метаданные().Имя, 40);
	
КонецПроцедуры

Процедура ДеревоЗначенийПриАктивизацииСтроки(Элемент = Неопределено)
	
	Элемент = ЭлементыФормы.ДеревоЗначений;
	Если Элемент.ТекущаяСтрока <> Неопределено Тогда
		Выражение = ПолучитьПолныйПуть(Элемент.ТекущаяСтрока);
	КонецЕсли;
	Элемент.Колонки.ПредставлениеЗначения.ТолькоПросмотр = Ложь
		Или Элемент.ТекущаяСтрока = Неопределено
		//Или Элемент.ТекущаяСтрока.Родитель = Неопределено
		Или Элемент.ТекущаяСтрока.ТипСлова = "Метод";
	//ЭтаФорма.ЭлементыФормы.КоманднаяПанельДерева.Кнопки.КонсольКода.Доступность = Истина
	//	И Элемент.ТекущаяСтрока <> Неопределено
	//	И Элемент.ТекущаяСтрока.ТипСлова = "Метод";
	Если мАвтоКонтекстнаяПомощь Тогда
		КоманднаяПанельДереваСправка();
	КонецЕсли; 
	
КонецПроцедуры

Процедура УстановитьЗначениеСловаВСтроке(СтрокаДерева, Успех, НовоеЗначение)
	
	СтрокаДерева.Успех = Успех;
	Если СтрокаДерева.ТипСлова = "Группа" Тогда
		Возврат;
	КонецЕсли;
	Если Успех = Истина Тогда
		СтрокаДерева.Значение = НовоеЗначение;
		//СтрокаДерева.ПредставлениеЗначения = ирОбщий.ПолучитьРасширенноеПредставлениеЗначенияЛкс(НовоеЗначение);
		СтрокаДерева.ПредставлениеЗначения = НовоеЗначение;
		СтрокаДерева.ТипЗначения = ТипЗнч(НовоеЗначение);
		СтрокаДерева.КоличествоЭлементов = ирОбщий.ПолучитьКоличествоЭлементовКоллекцииЛкс(НовоеЗначение);
		СтрокаДерева.ПредставлениеТипаЗначения = ТипЗнч(НовоеЗначение);
	ИначеЕсли Успех = Ложь Тогда 
		СтрокаДерева.Значение = НовоеЗначение;
		СтрокаДерева.ПредставлениеЗначения = НовоеЗначение;
		СтрокаДерева.ТипЗначения = "<Ошибка>";
		СтрокаДерева.КоличествоЭлементов = Неопределено;
		СтрокаДерева.ПредставлениеТипаЗначения = СтрокаДерева.ТипЗначения;
	КонецЕсли;
	
КонецПроцедуры	//УстановитьЗначениеСловаВСтроке

Процедура ДеревоЗначенийВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если ВыбраннаяСтрока.Успех Тогда
		ОткрытьТекущийЭлемент(Колонка = Элемент.Колонки.КоличествоЭлементов);
	ИначеЕсли ВыбраннаяСтрока.ТипСлова = "Метод" Тогда
		ЗначениеРодителя = ВыбраннаяСтрока.Родитель.Родитель.Значение;
		ТекстРодителя = "";
		//Если НРег(ЗначениеРодителя) <> НРег("<ГлобальныйКонтекст>") Тогда
		Если ВыбраннаяСтрока.Родитель.Родитель.ТипСлова <> "Группа" Тогда
			ТекстРодителя = "ЗначениеРодителя.";
		КонецЕсли; 
		Попытка
			ДочернееЗначение = Вычислить(ТекстРодителя + ВыбраннаяСтрока.Слово + "()");
			Успех = Истина;
		Исключение
			//ИнформацияОбОшибке = ИнформацияОбОшибке();
			//Если ИнформацияОбОшибке.Причина <> Неопределено Тогда
			//	ИнформацияОбОшибке = ИнформацияОбОшибке.Причина;
			//КонецЕсли; 
			//ДочернееЗначение = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке);
			ДочернееЗначение = ирОбщий.ПолучитьИнформациюОбОшибкеБезВерхнегоМодуляЛкс(ИнформацияОбОшибке());
			Успех = Ложь;
		КонецПопытки;
		УстановитьЗначениеСловаВСтроке(ВыбраннаяСтрока, Успех, ДочернееЗначение);
		ЗаполнитьСтрокуСлова(ВыбраннаяСтрока);
	Иначе
		ОткрытьТекущийЭлемент(Колонка = Элемент.Колонки.КоличествоЭлементов);
    КонецЕсли;
	
КонецПроцедуры

Процедура ОткрытьТекущийЭлемент(ПредпочитатьИсследовательКоллекций = Ложь)

	ТекущаяСтрока = ЭлементыФормы.ДеревоЗначений.ТекущаяСтрока;
	Если Ложь
		Или ТекущаяСтрока = Неопределено 
		Или ТекущаяСтрока.ТипСлова = "Группа"
	Тогда
		Возврат;
	КонецЕсли; 
	Если Ложь
		//Или ТекущаяСтрока.ТипЗначения = Тип("Строка")
		Или Не ТекущаяСтрока.Успех 
	Тогда
		//ирОбщий.ОткрытьТекстЛкс(ТекущаяСтрока.Значение,,, Истина);
		ирОбщий.ОткрытьТекстЛкс(ТекущаяСтрока.ПредставлениеЗначения, , , Истина);
		Возврат;
	КонецЕсли;
	Если Ложь
		Или ТекущаяСтрока.ТипЗначения = Тип("Запрос")
		Или ТекущаяСтрока.ТипЗначения = Тип("ПостроительЗапроса")
		Или ТекущаяСтрока.ТипЗначения = Тип("ПостроительОтчета")
		Или ТекущаяСтрока.ТипЗначения = Тип("СхемаКомпоновкиДанных")
		Или ТекущаяСтрока.ТипЗначения = Тип("ДинамическийСписок")
	Тогда
		ирОбщий.ОтладитьЛкс(ТекущаяСтрока.Значение);
		Возврат;
	КонецЕсли;
	XMLТип = XMLТип(ТипЗнч(ТекущаяСтрока.Значение));
	Если Истина
		И XMLТип <> Неопределено
		И Найти(XMLТип.ИмяТипа, "Ref.") > 0
	Тогда
		ирОбщий.ОткрытьСсылкуВРедактореОбъектаБДЛкс(ТекущаяСтрока.Значение);
		Возврат;
	КонецЕсли; 
	Если Ложь
		Или ТекущаяСтрока.ТипЗначения = Тип("МоментВремени")
		Или ТекущаяСтрока.ТипЗначения = Тип("Граница")
		Или ТекущаяСтрока.ТипЗначения = Тип("УникальныйИдентификатор")
		Или ТекущаяСтрока.ТипЗначения = Тип("Строка")
		Или ТекущаяСтрока.ТипЗначения = Тип("ТабличныйДокумент")
		Или ТекущаяСтрока.ТипЗначения = Тип("ДеревоЗначений")
		Или (Истина
			И Не ПредпочитатьИсследовательКоллекций
			И ТекущаяСтрока.ТипЗначения = Тип("Массив"))
		Или (Истина
			И Не ПредпочитатьИсследовательКоллекций
			И ТекущаяСтрока.ТипЗначения = Тип("ТаблицаЗначений"))
	Тогда
		ирОбщий.ЯчейкаТабличногоПоляРасширенногоЗначения_ВыборЛкс(ЭлементыФормы.ДеревоЗначений, , ТекущаяСтрока.Значение);
		УстановитьЗначениеСловаВСтроке(ТекущаяСтрока, Истина, ТекущаяСтрока.Значение);
		Возврат;
	КонецЕсли;
	Если ТекущаяСтрока.СтруктураТипа = Неопределено Тогда
		Возврат;
	КонецЕсли;
	СтрокаОписанияСлова = ТекущаяСтрока.СтруктураТипа.СтрокаОписания;
	Если СтрокаОписанияСлова = Неопределено Тогда
		Возврат;
	КонецЕсли;
	Если СтрокаОписанияСлова.Владелец().Колонки.Найти("ТипЭлементаКоллекции") = Неопределено Тогда
		ПолучитьСтруктуруТипаИзЗначения = Истина;
		Если ЗначениеЗаполнено(СтрокаОписанияСлова.ТипЗначения) Тогда
			СтруктураКлюча = Новый Структура("БазовыйТип, ЯзыкПрограммы", СтрокаОписанияСлова.ТипЗначения, 0);
			НайденныеСтроки = мПлатформа.ТаблицаОбщихТипов.НайтиСтроки(СтруктураКлюча);
			Если НайденныеСтроки.Количество() > 0 Тогда
				СтрокаОписанияСлова = НайденныеСтроки[0];
				ПолучитьСтруктуруТипаИзЗначения = Ложь;
			КонецЕсли;
		КонецЕсли; 
		Если ПолучитьСтруктуруТипаИзЗначения Тогда
			СтруктураКонкретногоТипа = мПлатформа.ПолучитьСтруктуруТипаИзЗначения(ТекущаяСтрока.Значение);
			Если Не ирОбщий.СтрокиРавныЛкс(ирОбщий.ПолучитьПервыйФрагментЛкс(СтруктураКонкретногоТипа.ИмяОбщегоТипа), "COMОбъект") Тогда
				СтруктураКлюча = Новый Структура("Слово, ЯзыкПрограммы", СтруктураКонкретногоТипа.ИмяОбщегоТипа, 0);
				НайденныеСтроки = мПлатформа.ТаблицаОбщихТипов.НайтиСтроки(СтруктураКлюча);
				Если НайденныеСтроки.Количество() > 0 Тогда
					СтрокаОписанияСлова = НайденныеСтроки[0];
				Иначе
					Возврат;
				КонецЕсли;
			КонецЕсли; 
		КонецЕсли;
	КонецЕсли;
	
	ЭтоКоллекция = ирОбщий.ЭтоКоллекцияЛкс(ТекущаяСтрока.Значение);
	СтруктураТипаКоллекции = мПлатформа.ПолучитьНовуюСтруктуруТипа();
	ЗаполнитьЗначенияСвойств(СтруктураТипаКоллекции, ТекущаяСтрока.СтруктураТипа, , "СтрокаОписания");
	СтруктураТипаКоллекции.СтрокаОписания = СтрокаОписанияСлова;
	//Если СтрокаОписанияСлова.ТипЭлементаКоллекции <> "" Тогда 
	Если ЭтоКоллекция Тогда 
		Форма = ПолучитьФорму("ИсследовательКоллекций", ЭтаФорма, Выражение);
		Форма.УстановитьИсследуемоеЗначение(ТекущаяСтрока.Значение, Выражение, СтруктураТипаКоллекции);
		Форма.Открыть();
	КонецЕсли;

КонецПроцедуры // ОткрытьТекущийЭлемент()

Процедура КоманднаяПанельДереваОткрыть(Кнопка)
	
	ОткрытьТекущийЭлемент();
	
КонецПроцедуры

Процедура КоманднаяПанельДереваСправка(Кнопка = Неопределено)
	
	ТекущаяСтрока = ЭлементыФормы.ДеревоЗначений.ТекущаяСтрока;
	Если Ложь
		Или ТекущаяСтрока = Неопределено 
		Или ТекущаяСтрока.ТипСлова = "Группа"
	Тогда
		Возврат;
	КонецЕсли;
	Если Не ТекущаяСтрока.Успех Тогда
		СтруктураЦикла = Новый Соответствие;
		СтруктураЦикла.Вставить("Фактические типы:", ТекущаяСтрока.ТаблицаСтруктурТипов);
		мПлатформа.ВыбратьСтрокуОписанияИзМассиваСтруктурТипов(СтруктураЦикла, , ЭтаФорма);
	Иначе
		СтруктураТипа = ТекущаяСтрока.СтруктураТипа;
		Если СтруктураТипа = Неопределено Тогда
			Если ТекущаяСтрока.ТаблицаСтруктурТипов.Количество() > 0 Тогда
				СтруктураТипа = ТекущаяСтрока.ТаблицаСтруктурТипов[0];
			КонецЕсли; 
		КонецЕсли; 
		Если СтруктураТипа <> Неопределено Тогда
			СтрокаОписания = СтруктураТипа.СтрокаОписания;
			Если СтрокаОписания <> Неопределено Тогда
				ирОбщий.ОткрытьСтраницуСинтаксПомощникаЛкс(СтрокаОписания.ПутьКОписанию, , ЭтаФорма);
			КонецЕсли; 
		КонецЕсли; 
	КонецЕсли;

КонецПроцедуры

Процедура ДеревоЗначенийПередНачаломИзменения(Элемент, Отказ)
	
	//Отказ = Истина;
	ЭлементыФормы.ДеревоЗначений.ТекущаяКолонка = ЭлементыФормы.ДеревоЗначений.Колонки.ПредставлениеЗначения;
	ДеревоЗначенийПредставлениеЗначенияНачалоВыбора(ЭлементыФормы.ДеревоЗначений.Колонки.ПредставлениеЗначения.ЭлементУправления, Истина);
	
КонецПроцедуры

Процедура КоманднаяПанельДереваОПодсистеме(Кнопка)
	ирОбщий.ОткрытьСправкуПоПодсистемеЛкс(ЭтотОбъект);
КонецПроцедуры

Процедура КоманднаяПанельДереваОтображениеXML(Кнопка)
	
	ЗаписьХмл = Новый ЗаписьXML;
	ЗаписьХмл.УстановитьСтроку();
	Попытка
		СериализаторXDTO.ЗаписатьXML(ЗаписьХмл, ЭтаФорма.ЭлементыФормы.ДеревоЗначений.ТекущаяСтрока.Значение);
	Исключение
		Сообщить(ПодробноеПредставлениеОшибки(ИнформацияОбОшибке().Причина));
		Возврат;
	КонецПопытки; 
	Текст = ЗаписьХмл.Закрыть();
	ирОбщий.ОткрытьТекстЛкс(Текст, "HTML", , Истина);
	
КонецПроцедуры

Процедура ДеревоЗначенийПредставлениеЗначенияПриИзменении(Элемент)
	
	ТекущиеДанные = ЭлементыФормы.ДеревоЗначений.ТекущиеДанные;
	Родитель = ТекущиеДанные.Родитель;
	Если Родитель = Неопределено Тогда
		_Значение_ = Элемент.Значение;
		ИсследуемоеЗначениеЗаменено = Истина;
	Иначе
		Попытка
			Родитель.Значение[ТекущиеДанные.Слово] = Элемент.Значение;
			БылаОшибка = Ложь;
		Исключение
			БылаОшибка = Истина;
			Сообщить(ирОбщий.ПолучитьИнформациюОбОшибкеБезВерхнегоМодуляЛкс(ИнформацияОбОшибке(), 1), СтатусСообщения.Внимание);
		КонецПопытки;
		Элемент.Значение = Родитель.Значение[ТекущиеДанные.Слово];
	КонецЕсли; 
	УстановитьЗначениеСловаВСтроке(ТекущиеДанные, Истина, Элемент.Значение);
	
КонецПроцедуры

Процедура КоманднаяПанельДереваКонсольКода(Кнопка)
	
	ТекущаяСтрока = ЭлементыФормы.ДеревоЗначений.ТекущаяСтрока;
	Если Ложь
		Или ТекущаяСтрока = Неопределено 
		Или ТекущаяСтрока.ТипСлова = "Группа"
	Тогда
		Возврат;
	КонецЕсли; 
	СтруктураПараметров = Новый Структура();
	Если ТекущаяСтрока.ТипСлова = "Метод" Тогда
		ТипКонтекста = ТекущаяСтрока.Родитель.Родитель.СтруктураТипа.ИмяОбщегоТипа;
		СтрокиПараметров = мПлатформа.ТаблицаПараметров.Скопировать(Новый Структура("ТипКонтекста, Слово, ЯзыкПрограммы", ТипКонтекста, ТекущаяСтрока.Слово, 0));
		СтрокиПараметров.Сортировать("Номер");
		ТекстПараметров = "";
		Для Каждого СтрокаПараметра Из СтрокиПараметров Цикл
			ИмяПараметра = СтрокаПараметра.Параметр;
			ИмяПараметра = СтрЗаменить(ИмяПараметра, "&lt;", "");
			ИмяПараметра = СтрЗаменить(ИмяПараметра, "&gt;", "");
			ИмяПараметра = мПлатформа.ПолучитьИдентификаторИзПредставления(ИмяПараметра);
			Если ТекстПараметров <> "" Тогда
				ТекстПараметров = ТекстПараметров + ", ";
			КонецЕсли; 
			ТекстПараметров = ТекстПараметров + ИмяПараметра;
			Попытка
				Тип = Новый ОписаниеТипов(СтрокаПараметра.ТипЗначения);
			Исключение
				Тип = Новый ОписаниеТипов();
			КонецПопытки; 
			СтруктураПараметров.Вставить(ИмяПараметра, Тип.ПривестиЗначение(Неопределено));
		КонецЦикла;
	КонецЕсли; 
	ТекстПрограммы = "";
	РодительскийПуть = "";
	Если ЗначениеЗаполнено(БазовоеВыражение) Тогда
		РодительскийПуть = "_Значение_.";
	ИначеЕсли Ложь
		Или Найти(Нрег(СокрЛ(Выражение)), НРег("Новый")) = 1
		Или Найти(Нрег(СокрЛ(Выражение)), НРег("Новый(")) = 1
	Тогда
		ТекстПрограммы = ТекстПрограммы + "Объект = " + ПолучитьПолныйПуть(ТекущаяСтрока.Владелец().Строки[0]) + ";" + Символы.ПС;
		РодительскийПуть = "Объект.";
	КонецЕсли; 
	Если ЗначениеЗаполнено(ТекущаяСтрока.ПредставлениеДопустимыхТипов) Тогда
		ТекстПрограммы = ТекстПрограммы + "Результат = ";
	КонецЕсли;
	ОтносительныйПуть = ПолучитьПолныйПуть(ТекущаяСтрока.Родитель, РодительскийПуть <> "");
	Если ЗначениеЗаполнено(ОтносительныйПуть) Тогда
		РодительскийПуть = РодительскийПуть + ОтносительныйПуть + ".";
	КонецЕсли; 
	ТекстПрограммы = ТекстПрограммы + РодительскийПуть; 
	//Если РодительскийПуть <> "" Тогда
	//	ТекстПрограммы = ТекстПрограммы + ".";
	//КонецЕсли; 
	ТекстПрограммы = ТекстПрограммы + ТекущаяСтрока.Слово;
	Если ТекущаяСтрока.ТипСлова = "Метод" Тогда
		 ТекстПрограммы = ТекстПрограммы + "(" + ТекстПараметров + ")";
	КонецЕсли; 
	//Если Найти(Выражение, КорневаяСтрока.Слово) = 1 Тогда
	//	СтруктураПараметров.Вставить(КорневаяСтрока.Слово, _Значение_); 
	//КонецЕсли; 
	//Если Найти(Выражение, "_Значение_") = 1 Тогда
	Если Ложь
		Или Найти(РодительскийПуть, "_Значение_") = 1
		Или (Истина
			И ирОбщий.СтрокиРавныЛкс(ТекущаяСтрока.Слово, "_Значение_")
			И ТекущаяСтрока.Родитель = Неопределено)
	Тогда
		СтруктураПараметров.Вставить("_Значение_", _Значение_); 
	КонецЕсли; 
	ирОбщий.ОперироватьСтруктуройЛкс(ТекстПрограммы, , СтруктураПараметров);
	
КонецПроцедуры

Процедура ДеревоЗначенийПредставлениеЗначенияОкончаниеВводаТекста(Элемент, Текст, Значение, СтандартнаяОбработка)
	
	ирОбщий.ПолеВвода_ОкончаниеВводаТекстаЛкс(Элемент, Текст, Значение, СтандартнаяОбработка, ЭлементыФормы.ДеревоЗначений.ТекущаяСтрока.Значение);

КонецПроцедуры

Процедура УстановитьГлобальныйКонтекст() Экспорт 
	
	Выражение = "<ГлобальныйКонтекст>";
	СтруктураТипаЗначения = мПлатформа.ПолучитьНовуюСтруктуруТипа();
	СтруктураТипаЗначения.ИмяОбщегоТипа = "Глобальный контекст";
	СтруктураТипаЗначения.Метаданные = Метаданные;
	мВычислитьВыражение();

КонецПроцедуры

Процедура КоманднаяПанельДереваГлобальныйКонтекст(Кнопка)
	
	УстановитьГлобальныйКонтекст();
	
КонецПроцедуры

Процедура КоманднаяПанельДереваНовоеОкно(Кнопка)
	
	ирОбщий.ОткрытьНовоеОкноОбработкиЛкс(ЭтотОбъект);
	
КонецПроцедуры

Процедура КоманднаяПанельДереваАвтоКонтекстнаяПомощь(Кнопка)
	
	мАвтоКонтекстнаяПомощь = Не Кнопка.Пометка;
	Кнопка.Пометка = мАвтоКонтекстнаяПомощь;
	Если мАвтоКонтекстнаяПомощь Тогда
		ДеревоЗначенийПриАктивизацииСтроки();
	КонецЕсли; 
	
КонецПроцедуры

Процедура ДеревоЗначенийПредставлениеЗначенияНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	ТекущиеДанные = ЭлементыФормы.ДеревоЗначений.ТекущиеДанные;
	Попытка
		ЗначениеИзменено = ирОбщий.ПолеВводаРасширенногоЗначения_НачалоВыбораЛкс(ЭлементыФормы.ДеревоЗначений, СтандартнаяОбработка, ТекущиеДанные.Значение);
	Исключение
		Сообщить(ирОбщий.ПолучитьИнформациюОбОшибкеБезВерхнегоМодуляЛкс(ИнформацияОбОшибке()), СтатусСообщения.Внимание);
		Возврат;
	КонецПопытки;
	Если ЗначениеИзменено Тогда
		Родитель = ТекущиеДанные.Родитель;
		Если Родитель = Неопределено Тогда
			_Значение_ = ТекущиеДанные.Значение;
			ИсследуемоеЗначениеЗаменено = Истина;
		Иначе
			Попытка
				Родитель.Значение[ТекущиеДанные.Слово] = ТекущиеДанные.Значение;
				БылаОшибка = Ложь;
			Исключение
				БылаОшибка = Истина;
				Сообщить(ирОбщий.ПолучитьИнформациюОбОшибкеБезВерхнегоМодуляЛкс(ИнформацияОбОшибке(), 1), СтатусСообщения.Внимание);
			КонецПопытки;
			ТекущиеДанные.Значение = Родитель.Значение[ТекущиеДанные.Слово];
		КонецЕсли; 
		УстановитьЗначениеСловаВСтроке(ТекущиеДанные, Истина, ТекущиеДанные.Значение);
	КонецЕсли; 
	
КонецПроцедуры

Процедура КоманднаяПанельДереваЗначениеВСтрокуВнутр(Кнопка)

	Текст = ЗначениеВСтрокуВнутр(ЭтаФорма.ЭлементыФормы.ДеревоЗначений.ТекущаяСтрока.Значение);
	ирОбщий.ОткрытьТекстЛкс(Текст, , , Истина);
	
КонецПроцедуры

Процедура КоманднаяПанельДереваОтображениеXDTO(Кнопка)

	Попытка
		ОбъектXDTO = СериализаторXDTO.ЗаписатьXDTO(ЭтаФорма.ЭлементыФормы.ДеревоЗначений.ТекущаяСтрока.Значение);
	Исключение
		Сообщить(ПодробноеПредставлениеОшибки(ИнформацияОбОшибке().Причина));
		Возврат;
	КонецПопытки;
	ирОбщий.ИсследоватьЛкс(ОбъектXDTO);
	
КонецПроцедуры

Процедура КоманднаяПанельДереваМенеджерТабличногоПоля(Кнопка)
	
	 ирОбщий.ПолучитьФормуЛкс("Обработка.ирМенеджерТабличногоПоля.Форма",, ЭтаФорма, ).УстановитьСвязь(ЭлементыФормы.ДеревоЗначений);

КонецПроцедуры

Процедура ВыражениеНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	
	ирОбщий.ПолеВводаСИсториейВыбора_НачалоВыбораИзСпискаЛкс(Элемент, Метаданные().Имя);

КонецПроцедуры

Процедура ПриЗакрытии()
	
	Если ИсследуемоеЗначениеЗаменено Тогда
		ОповеститьОВыборе(_Значение_);
	КонецЕсли; 
	ИсследуемоеЗначениеЗаменено = Ложь;
	
КонецПроцедуры

Процедура СтруктураКоманднойПанелиНажатие(Кнопка)
	
	ирОбщий.ОткрытьСтруктуруКоманднойПанелиЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

ирОбщий.ИнициализироватьФормуЛкс(ЭтаФорма, "Обработка.ирИсследовательОбъектов.Форма.ИсследовательОбъектов");

мПлатформа = ирКэш.Получить();
ИсследуемоеЗначениеЗаменено = Ложь;
мАвтоКонтекстнаяПомощь = Ложь;
МаркерСловаЗначения = "_Значение_";
ДеревоЗначений.Колонки.Добавить("Значение");
ДеревоЗначений.Колонки.Добавить("ТипЗначения");
ДеревоЗначений.Колонки.Добавить("СтруктураТипа");
ДеревоЗначений.Колонки.Добавить("ТаблицаСтруктурТипов");
ЭлементыФормы.ДеревоЗначений.Колонки.ПредставлениеЗначения.АвтоВысотаЯчейки = Истина;


