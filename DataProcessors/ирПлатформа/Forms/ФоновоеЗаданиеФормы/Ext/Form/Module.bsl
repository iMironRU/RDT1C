﻿
Процедура ВладелецНажатие(Элемент)
	
	ВладелецФормы.Открыть();
	
КонецПроцедуры

Процедура ОбновитьСостояниеЗаданияБезПараметров() 
	Если Не Открыта() Тогда
		ПодключитьОбработчикОжидания("ОбновитьСостояниеЗаданияБезПараметров", 2, Истина);
	КонецЕсли; 
	ФоновоеЗадание = ФоновыеЗадания.НайтиПоУникальномуИдентификатору(ИдентификаторЗадания);
	Если ФоновоеЗадание = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	ОбновитьСостояниеЗадания(ФоновоеЗадание);
КонецПроцедуры

Процедура ОбновитьСостояниеЗадания(Знач ФоновоеЗадание) Экспорт 
	
	Конец = ФоновоеЗадание.Конец;
	Если Не ЗначениеЗаполнено(Конец) Тогда
		Конец = ТекущаяДата();
	КонецЕсли; 
	ЭтаФорма.Состояние = ирОбщий.ПредставлениеДлительностиЛкс(Конец - ФоновоеЗадание.Начало) + "с " + ФоновоеЗадание.Состояние;
	Если ФоновоеЗадание.Состояние = СостояниеФоновогоЗадания.Активно Тогда
		ЭлементыФормы.Состояние.ЦветТекста = ирОбщий.ЦветТекстаАктивностиЛкс();
		ПодключитьОбработчикОжидания("ОбновитьСостояниеЗаданияБезПараметров", 2, Истина);
	Иначе
		ЭтаФорма.Заголовок = "Фоновое задание формы - " + КраткоеПредставление;
		ЭлементыФормы.Состояние.ЦветТекста = WebЦвета.ТемноЗеленый;
		ЭлементыФормы.Отменить.Доступность = Ложь;
	КонецЕсли;

КонецПроцедуры

Процедура СостояниеНажатие(Элемент)
	
	ФормаФоновогоЗадания = ирОбщий.ПолучитьФормуЛкс("Обработка.ирКонсольЗаданий.Форма.ДиалогФоновогоЗадания",,, ИдентификаторЗадания);
	ФормаФоновогоЗадания.Идентификатор = ИдентификаторЗадания;
	ФормаФоновогоЗадания.Открыть();
	
КонецПроцедуры

Процедура ПриОткрытии()
	ирОбщий.Форма_ПриОткрытииЛкс(ЭтаФорма);
КонецПроцедуры

Процедура ПриЗакрытии()
	ирОбщий.Форма_ПриЗакрытииЛкс(ЭтаФорма);
КонецПроцедуры

Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник) Экспорт 
	ирОбщий.Форма_ОбработкаОповещенияЛкс(ЭтаФорма, ИмяСобытия, Параметр, Источник);
КонецПроцедуры

Процедура ВнешнееСобытие(Источник, Событие, Данные) Экспорт 
	ирОбщий.Форма_ВнешнееСобытиеЛкс(ЭтаФорма, Источник, Событие, Данные);
КонецПроцедуры

ирОбщий.ИнициализироватьФормуЛкс(ЭтаФорма, "Обработка.ирПлатформа.Форма.ФоновоеЗаданиеФормы");
ЗакрыватьПриЗакрытииВладельца = Истина;
