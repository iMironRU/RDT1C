﻿
Процедура КнопкаОКНажатие(Кнопка)
	
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
	Если ТипЗнч(Приемник) = Тип("Массив") Тогда
		Результат = ирОбщий.СтрРазделитьЛкс(ЭлементыФормы.ПолеТекстовогоДокумента.ПолучитьТекст(), Разделитель, ОбрезатьКрайниеНепечатныеСимволы);
		Если ПропускатьПустые Тогда
			НачальноеКоличество = Результат.Количество(); 
			Для Счетчик = 1 По НачальноеКоличество Цикл
				Элемент = Результат[НачальноеКоличество - Счетчик];
				Если ПустаяСтрока(Элемент) Тогда
					Результат.Удалить(НачальноеКоличество - Счетчик);
				КонецЕсли;
			КонецЦикла;
		КонецЕсли; 
	Иначе
		Результат = ирОбщий.ПолучитьТаблицуИзСтрокиСРазделителемЛкс(ЭлементыФормы.ПолеТекстовогоДокумента.ПолучитьТекст(), Разделитель, ОбрезатьКрайниеНепечатныеСимволы, ИменаКолонокИзПервойСтроки, Приемник);
	КонецЕсли; 
	Закрыть(Результат);
	
КонецПроцедуры

Процедура ВариантРазделителяПриИзменении(Элемент)
	
	НастроитьЭлементыФормы();
	
КонецПроцедуры

Процедура НастроитьЭлементыФормы()
	
	ЭлементыФормы.Разделитель.Видимость = ВариантРазделителя = "Произвольный";
	ЭлементыФормы.ПропускатьПустые.Видимость = ТипЗнч(Приемник) = Тип("Массив");
	ЭлементыФормы.ИменаКолонокИзПервойСтроки.Видимость = ТипЗнч(Приемник) = Тип("ТаблицаЗначений");
	
КонецПроцедуры

Процедура КлсУниверсальнаяКомандаНажатие(Кнопка) Экспорт 
	
	ирОбщий.УниверсальнаяКомандаФормыЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура СтруктураКоманднойПанелиНажатие(Кнопка)
	
	ирОбщий.ОткрытьСтруктуруКоманднойПанелиЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура ПриОткрытии()
	
	Если Приемник = Неопределено Тогда
		Приемник = Новый Массив;
	КонецЕсли; 
	Если ЗначениеЗаполнено(Текст) Тогда
		ЭлементыФормы.ПолеТекстовогоДокумента.УстановитьТекст(Текст);
	КонецЕсли; 
	ирОбщий.ОбновитьТекстПослеМаркераВСтрокеЛкс(ЭтаФорма.Заголовок,, ТипЗнч(Приемник), " в ");
	НастроитьЭлементыФормы();
	
КонецПроцедуры

Процедура КоманднаяПанель1ЗагрузитьИзФайла(Кнопка)
	
	ПолноеИмяФайла = ирОбщий.ВыбратьФайлЛкс();
	Если ПолноеИмяФайла = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ЭлементыФормы.ПолеТекстовогоДокумента.Прочитать(ПолноеИмяФайла);

КонецПроцедуры

Процедура ВнешнееСобытие(Источник, Событие, Данные)
	
	ирОбщий.Форма_ВнешнееСобытиеЛкс(ЭтаФорма, Источник, Событие, Данные);

КонецПроцедуры

ирОбщий.ИнициализироватьФормуЛкс(ЭтаФорма, "Обработка.ирПлатформа.Форма.РазбивкаТекста");
ОбрезатьКрайниеНепечатныеСимволы = Истина;
ПропускатьПустые = Истина;