﻿Процедура ОсновныеДействияФормыОК(Кнопка)
	
	Закрыть(Истина);
	
КонецПроцедуры

Процедура ОсновныеДействияФормыОтмена(Кнопка)
	
	Закрыть();
	
КонецПроцедуры

Процедура ВнешнееСобытие(Источник, Событие, Данные)
	
	ирОбщий.Форма_ВнешнееСобытиеЛкс(ЭтаФорма, Источник, Событие, Данные);

КонецПроцедуры

ирОбщий.ИнициализироватьФормуЛкс(ЭтаФорма, "Обработка.ирРедакторИзмененийНаУзлах.Форма.ФормаВыбораОбновленияРегистрации");
ОбновлятьТолькоДляЭлементовСАвтоРегистрацией = Истина;