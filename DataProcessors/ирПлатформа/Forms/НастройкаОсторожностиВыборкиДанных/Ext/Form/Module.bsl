﻿Процедура КнопкаОКНажатие(Кнопка)
	
	ирОбщий.СохранитьЗначениеЛкс("ир_ВыполнятьПредварительныйЗапрос", ВыполнятьПредварительныйЗапрос);
	ирОбщий.СохранитьЗначениеЛкс("ир_БезопасныйПорогКоличестваСтрок", БезопасныйПорогКоличестваСтрок);
	Закрыть();
	
КонецПроцедуры

Процедура ОбновитьДоступность()

	ЭлементыФормы.БезопасныйПорогКоличестваСтрок.Доступность = ВыполнятьПредварительныйЗапрос;

КонецПроцедуры // ОбновитьДоступность()

Процедура ПриОткрытии()
	
	ВыполнятьПредварительныйЗапрос = ирОбщий.ВосстановитьЗначениеЛкс("ир_ВыполнятьПредварительныйЗапрос");
	БезопасныйПорогКоличестваСтрок = ирОбщий.ВосстановитьЗначениеЛкс("ир_БезопасныйПорогКоличестваСтрок");
	ОбновитьДоступность();
	
КонецПроцедуры

Процедура ВыполнятьПредварительныйЗапросПриИзменении(Элемент)
	
	ОбновитьДоступность();

КонецПроцедуры

Процедура ТабличноеПолеПриПолученииДанных(Элемент, ОформленияСтрок) Экспорт 
	
	ирОбщий.ТабличноеПолеПриПолученииДанныхЛкс(ЭтаФорма, Элемент, ОформленияСтрок);

КонецПроцедуры

ирОбщий.ИнициироватьФормуЛкс(ЭтаФорма, "Обработка.ирПлатформа.Форма.НастройкаОсторожностиВыборкиДанных");
