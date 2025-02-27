﻿Функция СохраняемаяНастройкаФормы(выхНаименование, выхИменаСвойств) Экспорт 
	выхИменаСвойств = "Форма.ВариантРазделителя, Форма.Разделитель, Форма.ОбрезатьКрайниеНепечатныеСимволы, Форма.ПропускатьПустые, Форма.ИменаКолонокИзПервойСтроки, Форма.РазворачиватьКавычки";
	Возврат Неопределено;
КонецФункции

Процедура КнопкаОКНажатие(Кнопка)
	
	Результат = РассчитатьРезультат();
	Закрыть(Результат);
	Если ОткрытьПриемникПриЗакрытии Тогда
		ирОбщий.ОткрытьЗначениеЛкс(Результат);
	КонецЕсли; 
	
КонецПроцедуры

Функция РассчитатьРезультат(Знач Текст = "")
	
	ВременныйПриемник = Новый (ТипЗнч(Приемник));
	Если Не ЗначениеЗаполнено(Текст) Тогда
		Текст = ЭлементыФормы.ПолеТекста.ПолучитьТекст();
		ВременныйПриемник = Приемник;
	КонецЕсли; 
	Если ВариантРазделителя = "Запятая" Тогда
		Разделитель = ",";
	ИначеЕсли ВариантРазделителя = "ТочкаСЗапятой" Тогда
		Разделитель = ";";
	ИначеЕсли ВариантРазделителя = "Пробел" Тогда
		Разделитель = " ";
	ИначеЕсли ВариантРазделителя = "КонецСтроки" Тогда
		Разделитель = Символы.ПС;
	ИначеЕсли ВариантРазделителя = "Табуляция" Тогда
		Разделитель = Символы.Таб;
	КонецЕсли; 
	Если ТипЗнч(ВременныйПриемник) = Тип("Массив") Тогда
		Результат = ирОбщий.СтрРазделитьЛкс(Текст, Разделитель, ОбрезатьКрайниеНепечатныеСимволы И Не РазворачиватьКавычки);
		Если ПропускатьПустые Или РазворачиватьКавычки Тогда
			НачальноеКоличество = Результат.Количество(); 
			ВнутриСоставногоЭлемента = Ложь;
			ТекстЭлемента = "";
			Для Счетчик = 1 По НачальноеКоличество Цикл
				ИндексЭлемента = НачальноеКоличество - Счетчик;
				Элемент = Результат[ИндексЭлемента];
				Если ПропускатьПустые И ПустаяСтрока(Элемент) Тогда
					Результат.Удалить(ИндексЭлемента);
				ИначеЕсли РазворачиватьКавычки Тогда 
					ТекстЭлемента = Элемент + ТекстЭлемента;
					Если СтрЧислоВхождений(Элемент, """") % 2 = 1 Тогда
						ВнутриСоставногоЭлемента = Не ВнутриСоставногоЭлемента;
					КонецЕсли; 
					Если Не ВнутриСоставногоЭлемента Тогда
						ТекстЭлемента = ирОбщий.СтрокаИзВыраженияВстроенногоЯзыкаЛкс(ТекстЭлемента);
						Если ОбрезатьКрайниеНепечатныеСимволы Тогда
							ТекстЭлемента = СокрЛП(ТекстЭлемента);
						КонецЕсли; 
						Результат[НачальноеКоличество - Счетчик] = ТекстЭлемента;
						ТекстЭлемента = "";
					Иначе
						Результат.Удалить(ИндексЭлемента);
						ТекстЭлемента = Разделитель + ТекстЭлемента;
					КонецЕсли; 
				КонецЕсли;
			КонецЦикла;
		КонецЕсли; 
	Иначе
		Результат = ирОбщий.ТаблицаИзСтрокиСРазделителемЛкс(Текст, Разделитель, ОбрезатьКрайниеНепечатныеСимволы, ИменаКолонокИзПервойСтроки, ВременныйПриемник,, РазворачиватьКавычки);
	КонецЕсли;
	Возврат Результат;

КонецФункции

Процедура ВариантРазделителяПриИзменении(Элемент)
	
	НастроитьЭлементыФормы();
	ОбновитьТаблицуПримера();
	
КонецПроцедуры

Процедура НастроитьЭлементыФормы()
	
	ЭлементыФормы.Разделитель.Видимость = ВариантРазделителя = "Произвольный";
	ЭлементыФормы.ПропускатьПустые.Видимость = ТипЗнч(Приемник) = Тип("Массив");
	ЭлементыФормы.ИменаКолонокИзПервойСтроки.Видимость = ТипЗнч(Приемник) = Тип("ТаблицаЗначений");
	
КонецПроцедуры

Процедура КлсКомандаНажатие(Кнопка) Экспорт 
	
	ирОбщий.УниверсальнаяКомандаФормыЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура СтруктураКоманднойПанелиНажатие(Кнопка)
	
	ирОбщий.ОткрытьСтруктуруКоманднойПанелиЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура ПриОткрытии()
	
	ирОбщий.Форма_ПриОткрытииЛкс(ЭтаФорма);
	ирОбщий.СоздатьМенеджерСохраненияНастроекФормыЛкс(ЭтаФорма);
	Если Приемник = Неопределено Тогда
		Приемник = Новый Массив;
	КонецЕсли; 
	Если ЗначениеЗаполнено(Текст) Тогда
		ЭлементыФормы.ПолеТекста.УстановитьТекст(Текст);
	КонецЕсли; 
	ирОбщий.ОбновитьТекстПослеМаркераВСтрокеЛкс(ЭтаФорма.Заголовок,, ТипЗнч(Приемник), " в ");
	НастроитьЭлементыФормы();
	ОбновитьТаблицуПримера();
	
КонецПроцедуры

Процедура КоманднаяПанель1ЗагрузитьИзФайла(Кнопка)
	
	ПолноеИмяФайла = ирОбщий.ВыбратьФайлЛкс();
	Если ПолноеИмяФайла = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ЭлементыФормы.ПолеТекста.Прочитать(ПолноеИмяФайла);

КонецПроцедуры

Процедура ВнешнееСобытие(Источник, Событие, Данные) Экспорт
	
	ирОбщий.Форма_ВнешнееСобытиеЛкс(ЭтаФорма, Источник, Событие, Данные);
	Если Источник = "KeyboardHook" И ирОбщий.Форма_ВводДоступенЛкс(ЭтаФорма) И ЭтаФорма.ТекущийЭлемент = ЭлементыФормы.ПолеТекста Тогда
		ПодключитьОбработчикОжидания("ОбновитьТаблицуПримера", 0.1, Истина);
	КонецЕсли; 

КонецПроцедуры

Процедура ПриЗакрытии()
	
	ирОбщий.Форма_ПриЗакрытииЛкс(ЭтаФорма);

КонецПроцедуры

Процедура ТабличноеПолеПриПолученииДанных(Элемент, ОформленияСтрок) Экспорт 
	
	ирОбщий.ТабличноеПолеПриПолученииДанныхЛкс(ЭтаФорма, Элемент, ОформленияСтрок);

КонецПроцедуры

Процедура ОбрезатьКрайниеНепечатныеСимволыПриИзменении(Элемент)
	
	ОбновитьТаблицуПримера();
	
КонецПроцедуры

Процедура РазделительПриИзменении(Элемент)
	
	ОбновитьТаблицуПримера();

КонецПроцедуры

Процедура РазворачиватьКавычкиПриИзменении(Элемент)
	
	ОбновитьТаблицуПримера();

КонецПроцедуры

Процедура ИменаКолонокИзПервойСтрокиПриИзменении(Элемент)
	
	ОбновитьТаблицуПримера();

КонецПроцедуры

Процедура ОбновитьТаблицуПримера()
	
	Результат = РассчитатьРезультат(Лев(ЭлементыФормы.ПолеТекста.ПолучитьТекст(), 2000));
	Если ТипЗнч(Результат) = Тип("Массив") Тогда
		ЭтаФорма.ТаблицаПримера = Новый ТаблицаЗначений;
		ТаблицаПримера.Колонки.Добавить("Элемент");
		Для Каждого Элемент Из Результат Цикл
			ТаблицаПримера.Добавить();
		КонецЦикла;
		ТаблицаПримера.ЗагрузитьКолонку(Результат, 0);
	Иначе
		ЭтаФорма.ТаблицаПримера = Результат;
	КонецЕсли; 
	ЭлементыФормы.ТаблицаПримера.СоздатьКолонки();
	
КонецПроцедуры

Процедура ДействияФормыОбновитьПримерРазбивки(Кнопка)
	
	ОбновитьТаблицуПримера();
	
КонецПроцедуры

Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник) Экспорт
	
	ирОбщий.Форма_ОбработкаОповещенияЛкс(ЭтаФорма, ИмяСобытия, Параметр, Источник); 

КонецПроцедуры

ирОбщий.ИнициироватьФормуЛкс(ЭтаФорма, "Обработка.ирПлатформа.Форма.РазбивкаТекста");
ОбрезатьКрайниеНепечатныеСимволы = Истина;
ПропускатьПустые = Истина;