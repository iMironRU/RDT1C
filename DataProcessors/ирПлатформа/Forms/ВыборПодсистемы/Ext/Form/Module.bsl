﻿Процедура ДобавитьПодсистему(СтрокиДереваПодсистем, Подсистема)

	стрПодсистема = СтрокиДереваПодсистем.Добавить();
	ПолноеИмяПодсистемы = СтрЗаменить(Подсистема.ПолноеИмя(), "Подсистема.", "");
	стрПодсистема.ПолноеИмя = ПолноеИмяПодсистемы;
	стрПодсистема.Имя = Подсистема.Имя;
	стрПодсистема.Представление = ?(ПустаяСтрока(Подсистема.Синоним), Подсистема.Имя, Подсистема.Синоним);
	стрПодсистема.ОбъектМД = Подсистема;
	
	Для каждого ДочерняяПодсистема из Подсистема.Подсистемы цикл
		ДобавитьПодсистему(стрПодсистема.Строки, ДочерняяПодсистема);
	КонецЦикла;
	//Если СтрокиДереваПодсистем.Родитель = Неопределено Тогда
	//	стрПодсистема = СтрокиДереваПодсистем.Добавить();
	//	стрПодсистема.ПолноеИмя = "<Не входящие в подсистемы>";
	//	стрПодсистема.Имя = Подсистема.Имя;
	//	стрПодсистема.Представление = ?(ПустаяСтрока(Подсистема.Синоним), Подсистема.Имя, Подсистема.Синоним);
	//	стрПодсистема.ОбъектМД = Неопределено;
	//КонецЕсли; 
	
КонецПроцедуры // ДобавитьПодсистему

// + Анатолий Ясень [20.11.12] (Фильтрация дерева подсистем по указанному объекту) {
Процедура ФильтроватьПодсистемыПоОбъектуМетаданных(СтрокиДереваПодсистем)

	КоличествоСтрокДереваПодсистем = СтрокиДереваПодсистем.Количество();
	Для сч = 1 По КоличествоСтрокДереваПодсистем Цикл
		ДочерняяПодсистема = СтрокиДереваПодсистем[КоличествоСтрокДереваПодсистем - сч];
		Если ДочерняяПодсистема.Строки.Количество() = 0 Тогда
			МДПодсистема = Метаданные.НайтиПополномуИмени("Подсистема."+СтрЗаменить(ДочерняяПодсистема.ПолноеИмя, ".", ".Подсистема."));
			Если НЕ МДПодсистема.Состав.Содержит(МДОбъект) Тогда
				СтрокиДереваПодсистем.Удалить(ДочерняяПодсистема);				
			КонецЕсли;
		Иначе
			ФильтроватьПодсистемыПоОбъектуМетаданных(ДочерняяПодсистема.Строки);
			МДПодсистема = Метаданные.НайтиПополномуИмени("Подсистема."+СтрЗаменить(ДочерняяПодсистема.ПолноеИмя, ".", ".Подсистема."));
			Если ДочерняяПодсистема.Строки.Количество() = 0 И НЕ МДПодсистема.Состав.Содержит(МДОбъект) Тогда
				// Все вложенные подсистемы не содержат объекта. Сама подсистема тоже
				СтрокиДереваПодсистем.Удалить(ДочерняяПодсистема);				
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;		

КонецПроцедуры
// + Анатолий Ясень [20.11.12]}

Процедура ПриОткрытии()
	
	Если НачальноеЗначениеВыбора = Неопределено Тогда
		Если ТипЗнч(ВладелецФормы) = Тип("ПолеВвода") Тогда
			НачальноеЗначениеВыбора = ВладелецФормы.Значение;
		КонецЕсли; 
	КонецЕсли; 
	Если ЗначениеЗаполнено(НачальноеЗначениеВыбора) Тогда
		СтрокаДерева = ДеревоПодсистем.Строки.Найти(НачальноеЗначениеВыбора, "ПолноеИмя", Истина);
		Если СтрокаДерева <> Неопределено Тогда
			ЭлементыФормы.ДеревоПодсистем.ТекущаяСтрока = СтрокаДерева;
		КонецЕсли; 
	КонецЕсли; 
	// + Анатолий Ясень [20.11.12] - фильтрация дерева подсистем по указанному объекту {
	Если ТипЗнч(МДОбъект)=Тип("ОбъектМетаданных") Тогда
		ФильтроватьПодсистемыПоОбъектуМетаданных(ДеревоПодсистем.Строки);
	КонецЕсли;
	// + Анатолий Ясень [20.11.12]}
		
КонецПроцедуры

Процедура КоманднаяПанель1ИмяСиноним(Кнопка)
	
	РежимИмяСиноним = Не Кнопка.Пометка;
	Кнопка.Пометка = РежимИмяСиноним;
	ирОбщий.ТабличноеПоле_ОбновитьКолонкиИмяСинонимЛкс(ЭлементыФормы.ДеревоПодсистем, РежимИмяСиноним);
	
КонецПроцедуры

Процедура ДеревоПодсистемВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	Если РежимВыбора Тогда
		ОповеститьОВыборе(ВыбраннаяСтрока.ПолноеИмя);
	КонецЕсли; 
	
КонецПроцедуры

ирОбщий.ИнициализироватьФормуЛкс(ЭтаФорма, "Обработка.ирПлатформа.Форма.ВыборПодсистемы");
ДобавитьПодсистему(ДеревоПодсистем.Строки, Метаданные);
