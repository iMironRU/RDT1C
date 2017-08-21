﻿
#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ФиксированныеНастройкиОтборВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле = Элементы.ФиксированныеНастройкиОтборПравоеЗначение Тогда
		ПоказатьЗначение(, КомпоновщикНастроек.ФиксированныеНастройки.Отбор.ПолучитьОбъектПоИдентификатору(ВыбраннаяСтрока).ПравоеЗначение);
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкиОтборВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле = Элементы.НастройкиОтборПравоеЗначение Тогда
		ПоказатьЗначение(, КомпоновщикНастроек.Настройки.Отбор.ПолучитьОбъектПоИдентификатору(ВыбраннаяСтрока).ПравоеЗначение);
	КонецЕсли; 

КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Представление = ПолучитьПредставлениеНастроек(Параметры.ФиксированныеНастройки);
	Элементы.ФиксированныеНастройки.Заголовок = Элементы.ФиксированныеНастройки.Заголовок + Представление;
	Представление = ПолучитьПредставлениеНастроек(Параметры.Настройки);
	Элементы.ОбычныеНастройки.Заголовок = Элементы.ОбычныеНастройки.Заголовок + Представление;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьПредставлениеНастроек(Знач Настройки)
	
	Представление = "";
	Если ЗначениеЗаполнено("" + Настройки.Отбор) Тогда 
		Представление = Представление + ",Отбор";
	КонецЕсли;
	Если ЗначениеЗаполнено("" + Настройки.Порядок) Тогда 
		Представление = Представление + ",Порядок";
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Представление) Тогда
		Представление = ",Нет";
	КонецЕсли; 
	Представление = "(" + Сред(Представление, 2) + ")";
	Возврат Представление;

КонецФункции

#КонецОбласти