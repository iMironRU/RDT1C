﻿
Процедура ПриОткрытии()
	
	Текст = ПолучитьМакет("ОПодсистеме").ПолучитьТекст();
	Если ирКэш.ЛиПортативныйРежимЛкс() Тогда
		ЭтаФорма.Версия = "Инструменты разработчика " + ирПортативный.мВерсия;
		Текст = СтрЗаменить(Текст, "Подсистема", "Портативные");
	Иначе
		ЭтаФорма.Версия = Метаданные.Подсистемы.ИнструментыРазработчика.Синоним;
	КонецЕсли; 
	ЭлементыФормы.ПолеHTMLДокумента.УстановитьТекст(Текст);
	
КонецПроцедуры

ирОбщий.ИнициализироватьФормуЛкс(ЭтаФорма, "Обработка.ирПлатформа.Форма.ОПодсистеме");
