﻿
Процедура ОсновныеДействияФормыОК(Кнопка)
	
	СтруктураВозврата = Новый Структура("МинимальнаяДата, МаксимальнаяДата");
	ЗаполнитьЗначенияСвойств(СтруктураВозврата, ЭтаФорма);
	Закрыть(СтруктураВозврата);
	
КонецПроцедуры // ОсновныеДействияФормыОК()

Процедура ПриОткрытии()
	
	Если Не ЗначениеЗаполнено(МаксимальнаяДата) Тогда
		МаксимальнаяДата = КонецМесяца(ДобавитьМесяц(ТекущаяДата(), -1));
	КонецЕсли; 
	Если Не ЗначениеЗаполнено(МинимальнаяДата) Тогда
		МинимальнаяДата = КонецМесяца(ДобавитьМесяц(ТекущаяДата(), -12*2));
	КонецЕсли;
	ЭлементыФормы.МинимальнаяДата.Доступность = Не ирОбщий.РежимСовместимостиМеньше8_3_4Лкс();
	
КонецПроцедуры // ПриОткрытии()

Процедура МинимальнаяДатаПриИзменении(Элемент)
	
	ЭтаФорма.МаксимальнаяДата = КонецМесяца(МаксимальнаяДата);
	
КонецПроцедуры // РегистрыНакопленияПериодИтоговПриИзменении

Процедура МаксимальнаяДатаПриИзменении(Элемент)
	
	ЭтаФорма.МинимальнаяДата = КонецМесяца(МинимальнаяДата);
	
КонецПроцедуры // РегистрыБухгалтерииПериодИтоговПриИзменении

Процедура ВнешнееСобытие(Источник, Событие, Данные) Экспорт
	
	ирОбщий.Форма_ВнешнееСобытиеЛкс(ЭтаФорма, Источник, Событие, Данные);

КонецПроцедуры

Процедура ТабличноеПолеПриПолученииДанных(Элемент, ОформленияСтрок) Экспорт 
	
	ирОбщий.ТабличноеПолеПриПолученииДанныхЛкс(ЭтаФорма, Элемент, ОформленияСтрок);

КонецПроцедуры

ирОбщий.ИнициироватьФормуЛкс(ЭтаФорма, "Обработка.ирУправлениеИтогамиРегистров.Форма.УстановитьГраницыИтогов");
