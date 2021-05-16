﻿Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	
	Отказ = Истина;
	Если ВладелецФормы = Неопределено Тогда
		Возврат;
	КонецЕсли;
	Ответ = Вопрос("Для каждого объекта сразу будет создана копия, которая будет назначена правильным элементом его группы дублей.
	|Крайне желательно сразу провести замену ссылок и удалить неправильные элементы.", РежимДиалогаВопрос.ОКОтмена);
	Если Ответ = КодВозвратаДиалога.Отмена Тогда
		Возврат;
	КонецЕсли;
	КопияСтрокиДляОбработки = СтрокиДляОбработки.Скопировать(Новый Структура(мИмяКолонкиПометки, Истина));
	Объекты = КопияСтрокиДляОбработки.ВыгрузитьКолонку("Ссылка");
	ирОбщий.ОткрытьДиалогЗаменыИдентификаторовОбъектовЛкс(Объекты);

КонецПроцедуры

Процедура ТабличноеПолеПриПолученииДанных(Элемент, ОформленияСтрок) Экспорт 
	
	ирОбщий.ТабличноеПолеПриПолученииДанныхЛкс(ЭтаФорма, Элемент, ОформленияСтрок);

КонецПроцедуры

ирОбщий.ИнициироватьФормуЛкс(ЭтаФорма, "Обработка.ирПодборИОбработкаОбъектов.Форма.ИзменитьИдентификаторы");
