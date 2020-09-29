﻿Перем СтарыйПротокол;

Процедура КнопкаВыполнитьНажатие(Кнопка = Неопределено)
	
	ПротоколПриИзменении();
	ирОбщий.СохранитьЗначениеЛкс("ИнтернетПрокси", Протоколы);
	Закрыть();
	
КонецПроцедуры

Процедура ПриОткрытии()
	
	НовыеПротоколы = ирОбщий.ВосстановитьЗначениеЛкс("ИнтернетПрокси");
	Если НовыеПротоколы <> Неопределено Тогда
		ЭтаФорма.Протоколы = НовыеПротоколы;
	КонецЕсли; 
	СписокВыбора = ЭлементыФормы.Протокол.СписокВыбора;
	СписокВыбора.Добавить("HTTP");
	СписокВыбора.Добавить("HTTPS");
	ЭтаФорма.Протокол = "HTTP";
	Если ЗначениеЗаполнено(ПараметрПротокол) Тогда
		ЭтаФорма.Протокол = ВРег(ПараметрПротокол);
	КонецЕсли; 
	ПротоколПриИзменении();
	
КонецПроцедуры

Процедура ОсновныеДействияФормыУстановить(Кнопка)
	
	ИнтернетПрокси = Новый ИнтернетПрокси(Истина);
	ИнтернетПрокси.Установить(Протокол, Сервер, Порт, Пользователь, Пароль, АутентификацияОС);
	
КонецПроцедуры

Процедура ПротоколПриИзменении(Элемент = Неопределено)
	
	ИменаСвойств = "Сервер, Порт, Пользователь, Пароль, АутентификацияОС";
	НастройкиПрокси = Новый Структура(ИменаСвойств);
	Если СтарыйПротокол <> Неопределено Тогда
		ЗаполнитьЗначенияСвойств(НастройкиПрокси, ЭтаФорма, ИменаСвойств); 
		Протоколы.Вставить(СтарыйПротокол, НастройкиПрокси);
	КонецЕсли;
	СтарыйПротокол = Протокол;
	НастройкиПрокси = Новый Структура(ИменаСвойств);
	НастройкиПрокси.АутентификацияОС = Истина;
	ЗаполнитьЗначенияСвойств(ЭтаФорма, НастройкиПрокси, ИменаСвойств); 
	Если Протоколы.Свойство(Протокол) Тогда
		ЗаполнитьЗначенияСвойств(НастройкиПрокси, Протоколы[Протокол]); 
		ЗаполнитьЗначенияСвойств(ЭтаФорма, НастройкиПрокси, ИменаСвойств); 
	КонецЕсли; 
	
КонецПроцедуры

Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Ответ = ирОбщий.ЗапроситьСохранениеДанныхФормыЛкс(ЭтаФорма);
	Отказ = Ответ = КодВозвратаДиалога.Отмена;
	Если Ответ = КодВозвратаДиалога.Да Тогда
		КнопкаВыполнитьНажатие();
	КонецЕсли; 

КонецПроцедуры

Процедура ВнешнееСобытие(Источник, Событие, Данные)
	
	ирОбщий.Форма_ВнешнееСобытиеЛкс(ЭтаФорма, Источник, Событие, Данные);

КонецПроцедуры

Протоколы = Новый Структура;