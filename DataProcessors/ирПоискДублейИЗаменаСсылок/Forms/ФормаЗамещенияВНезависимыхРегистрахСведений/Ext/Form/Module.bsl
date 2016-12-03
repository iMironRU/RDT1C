﻿//ирПортативный Перем ирПортативный Экспорт;
//ирПортативный Перем ирОбщий Экспорт;
//ирПортативный Перем ирСервер Экспорт;
//ирПортативный Перем ирКэш Экспорт;
//ирПортативный Перем ирПривилегированный Экспорт;

// <Описание процедуры>
//
// Параметры:
//  <Параметр1>  – <Тип.Вид> – <описание параметра>
//                 <продолжение описания параметра>;
//  <Параметр2>  – <Тип.Вид> – <описание параметра>
//                 <продолжение описания параметра>.
//
Процедура Записать()

	Для Каждого ЭлементРегистра Из СтруктураКоллизий Цикл
		Для Каждого СтрокаЗаписи Из ЭлементРегистра.Значение Цикл
			Если СтрокаЗаписи.Заменить Тогда
				СтрокаЗаписи.МенеджерЗамены.Записать();
			КонецЕсли;
			СтрокаЗаписи.МенеджерОригинала.Удалить();
		КонецЦикла;
	КонецЦикла;

КонецПроцедуры // Записать()

Процедура КнопкаВыполнитьНажатие(Кнопка)

	Записать();
	Закрыть();
	
КонецПроцедуры

Процедура ПриОткрытии()
	
	СтраницаШаблона = ЭлементыФормы.ОсновнаяПанель.Страницы.СтраницаШаблона;
	ТабличноеПолеШаблона = ЭлементыФормы.ТабличноеПолеШаблона;
	КолонкаШаблона = ТабличноеПолеШаблона.Колонки.КолонкаШаблона;
	
	Если СтруктураКоллизий <> Неопределено Тогда
		Для Каждого ЭлементРегистра Из СтруктураКоллизий Цикл
			МетаданныеРегистра = Метаданные.РегистрыСведений[ЭлементРегистра.Ключ];
			СтраницаРегистра = ЭлементыФормы.ОсновнаяПанель.Страницы.Добавить("Страница" + ЭлементРегистра.Ключ,
				МетаданныеРегистра.Представление(), ЭлементРегистра);
			ЭлементыФормы.ОсновнаяПанель.ТекущаяСтраница = СтраницаРегистра;
			ТабличноеПолеРегистра = ЭлементыФормы.Добавить(Тип("ТабличноеПоле"), "ТабличноеПоле" + ЭлементРегистра.Ключ, Истина, ЭлементыФормы.ОсновнаяПанель);
			ЗаполнитьЗначенияСвойств(ТабличноеПолеРегистра, ТабличноеПолеШаблона, "Ширина, Высота, Лево, Верх, ТолькоПросмотр, ИзменятьСоставСтрок");
			ТабличноеПолеРегистра.Значение = ЭлементРегистра.Значение;
			СтрокаСортировки = "";
			Для Каждого МетаИзмерение Из МетаданныеРегистра.Измерения Цикл
				СтрокаСортировки = СтрокаСортировки + "," + МетаИзмерение.Имя;
			КонецЦикла;
			ТабличноеПолеРегистра.Значение.Сортировать(Сред(СтрокаСортировки, 2));
			ТабличноеПолеРегистра.СоздатьКолонки();
			ирОбщий.СкопироватьПривязкиЛкс(ЭтаФорма, ТабличноеПолеРегистра, ТабличноеПолеШаблона);
			Для Каждого Колонка Из ТабличноеПолеРегистра.Колонки Цикл
				ЗаполнитьЗначенияСвойств(Колонка.ЭлементУправления, КолонкаШаблона.ЭлементУправления, 
					"ТолькоПросмотр, КнопкаОткрытия, КнопкаВыбора, КнопкаОчистки");
			КонецЦикла;
			КолонкаФлагаЗамены = ТабличноеПолеРегистра.Колонки.Заменить;
			КолонкаФлагаЗамены.РежимРедактирования = РежимРедактированияКолонки.Непосредственно;
			КолонкаФлагаЗамены.ДанныеФлажка = КолонкаФлагаЗамены.Данные;
			ТабличноеПолеРегистра.Колонки.МенеджерЗамены.Видимость            = Ложь;
			ТабличноеПолеРегистра.Колонки.МенеджерОригинала.Видимость         = Ложь;
			ТабличноеПолеРегистра.Колонки.МенеджерЗамены.ИзменятьВидимость    = Ложь;
			ТабличноеПолеРегистра.Колонки.МенеджерОригинала.ИзменятьВидимость = Ложь;
			ТабличноеПолеРегистра.УстановитьДействие("ПриПолученииДанных", ТабличноеПолеШаблона.ПолучитьДействие("ПриПолученииДанных"));
		КонецЦикла;
	КонецЕсли; 
	СтраницаШаблона.Видимость = Ложь;
	
КонецПроцедуры

Процедура КоманднаяПанельОбщаяВключитьВсе(Кнопка)
	
	ЭлементыФормы.ОсновнаяПанель.ТекущаяСтраница.Значение.Значение.ЗаполнитьЗначения(Истина, "Заменить");
	ЭтаФорма.Обновить();
	
КонецПроцедуры

Процедура КоманднаяПанельОбщаяВыключитьВсе(Кнопка)

	ЭлементыФормы.ОсновнаяПанель.ТекущаяСтраница.Значение.Значение.ЗаполнитьЗначения(Ложь, "Заменить");
	ЭтаФорма.Обновить();
	
КонецПроцедуры

Процедура ТабличноеПолеШаблонаПриПолученииДанных(Элемент, ОформленияСтрок)
	
	МетаданныеРегистра = Метаданные.РегистрыСведений[Сред(Элемент.Имя, СтрДлина("ТабличноеПоле") + 1)];
	МассивКоллекцийРеквизитов = Новый Массив;
	МассивКоллекцийРеквизитов.Добавить(МетаданныеРегистра.Ресурсы);
	МассивКоллекцийРеквизитов.Добавить(МетаданныеРегистра.Реквизиты);
	Для Каждого ОформлениеСтроки Из ОформленияСтрок Цикл
		Для Каждого КоллекцияРеквизитов Из МассивКоллекцийРеквизитов Цикл
			Для Каждого МетаРеквизит Из КоллекцияРеквизитов Цикл
				ИмяКолонки = МетаРеквизит.Имя;
				Если ОформлениеСтроки.ДанныеСтроки["Оригинал" + ИмяКолонки] <> ОформлениеСтроки.ДанныеСтроки["Замена" + ИмяКолонки] Тогда 
					ОформлениеСтроки.Ячейки["Замена" + ИмяКолонки].ЦветФона = WebЦвета.Бирюзовый;
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры

Процедура ОсновныеДействияФормыВсегдаОК(Кнопка)
	
	 КодВсегда = 1;
	 КнопкаВыполнитьНажатие(0);
	
КонецПроцедуры

Процедура ОсновныеДействияФормыВсегдаПропускать(Кнопка)
	
	 КодВсегда = 2;
	 Закрыть();
	
КонецПроцедуры

Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	
	Если КодВсегда = 1 Тогда
		Записать();
		Отказ = Истина;
	ИначеЕсли КодВсегда = 2 Тогда
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

Процедура СтруктураКоманднойПанелиНажатие(Кнопка)
	
	ирОбщий.ОткрытьСтруктуруКоманднойПанелиЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

//ирПортативный #Если Клиент Тогда
//ирПортативный Контейнер = Новый Структура();
//ирПортативный Оповестить("ирПолучитьБазовуюФорму", Контейнер);
//ирПортативный Если Не Контейнер.Свойство("ирПортативный", ирПортативный) Тогда
//ирПортативный 	ПолноеИмяФайлаБазовогоМодуля = ВосстановитьЗначение("ирПолноеИмяФайлаОсновногоМодуля");
//ирПортативный 	ирПортативный = ВнешниеОбработки.ПолучитьФорму(ПолноеИмяФайлаБазовогоМодуля);
//ирПортативный КонецЕсли; 
//ирПортативный ирОбщий = ирПортативный.ПолучитьОбщийМодульЛкс("ирОбщий");
//ирПортативный ирКэш = ирПортативный.ПолучитьОбщийМодульЛкс("ирКэш");
//ирПортативный ирСервер = ирПортативный.ПолучитьОбщийМодульЛкс("ирСервер");
//ирПортативный ирПривилегированный = ирПортативный.ПолучитьОбщийМодульЛкс("ирПривилегированный");
//ирПортативный #КонецЕсли

ирОбщий.ИнициализироватьФормуЛкс(ЭтаФорма, "Обработка.ирПоискДублейИЗаменаСсылок.Форма.ФормаЗамещенияВНезависимыхРегистрахСведений");


