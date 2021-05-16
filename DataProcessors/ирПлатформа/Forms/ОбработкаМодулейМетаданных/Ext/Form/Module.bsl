﻿Функция СохраняемаяНастройкаФормы(выхНаименование, выхИменаСвойств) Экспорт 
	выхИменаСвойств = "Форма.Папка, Форма.ТипЗамены, Форма.Маска";
	Результат = Новый Структура;
	Результат.Вставить("ЧтоЗаменять", ЭлементыФормы.ПолеЧтоЗаменять.ПолучитьТекст());
	Результат.Вставить("НаЧтоЗаменять", ЭлементыФормы.ПолеНаЧтоЗаменять.ПолучитьТекст());
	Возврат Результат;
КонецФункции

Процедура ЗагрузитьНастройкуВФорме(НастройкаФормы, ДопПараметры) Экспорт 
	
	ирОбщий.ЗагрузитьНастройкуФормыЛкс(ЭтаФорма, НастройкаФормы); 
	НовыйЧтоЗаменять = "";
	НовыйНаЧтоЗаменять = "";
	Если НастройкаФормы <> Неопределено Тогда
		НовыйЧтоЗаменять = НастройкаФормы.ЧтоЗаменять;
		НовыйНаЧтоЗаменять = НастройкаФормы.НаЧтоЗаменять;
	КонецЕсли; 
	ЭлементыФормы.ПолеЧтоЗаменять.УстановитьТекст(НовыйЧтоЗаменять);
	ЭлементыФормы.ПолеНаЧтоЗаменять.УстановитьТекст(НовыйНаЧтоЗаменять);
	НастроитьЭлементыФормы();
	
КонецПроцедуры

Процедура ПриОткрытии()
	
	ирОбщий.Форма_ПриОткрытииЛкс(ЭтаФорма);
	ирОбщий.СоздатьМенеджерСохраненияНастроекФормыЛкс(ЭтаФорма);

КонецПроцедуры

Процедура ОбновитьИнфоПапки()
	
	КонтрольныйФайл = КонтрольныйФайл();
	#Если Сервер И Не Сервер Тогда
		КонтрольныйФайл = Новый файл;
	#КонецЕсли
	Если КонтрольныйФайл.Существует() Тогда
		ЭтаФорма.ДатаОбновленияФайлов = КонтрольныйФайл.ПолучитьВремяИзменения();
	Иначе
		ЭтаФорма.ДатаОбновленияФайлов = Неопределено;
	КонецЕсли; 

КонецПроцедуры

Процедура ВнешнееСобытие(Источник, Событие, Данные) Экспорт 
	
	ирОбщий.Форма_ВнешнееСобытиеЛкс(ЭтаФорма, Источник, Событие, Данные);

КонецПроцедуры

Процедура ДействияФормыВыгрузить(Кнопка)
	
	УдалитьФайлы(Папка, "*");
	ТекстЛога = "";
	Успех = ирОбщий.ВыполнитьКомандуКонфигуратораЛкс("/DumpConfigFiles """ + Папка + """ -Module", СтрокаСоединенияИнформационнойБазы(), ТекстЛога, Истина, "Выгрузка модулей конфигурации");
	Если Не Успех Тогда 
		Сообщить(ТекстЛога);
		Возврат;
	КонецЕсли;
	КонтрольныйФайл = КонтрольныйФайл();
	#Если Сервер И Не Сервер Тогда
		КонтрольныйФайл = Новый Файл;
	#КонецЕсли
	ТекстовыйДокумент = Новый ТекстовыйДокумент;
	ТекстовыйДокумент.Записать(КонтрольныйФайл.ПолноеИмя);
	ОбновитьИнфоПапки();
	
КонецПроцедуры

Функция КонтрольныйФайл()
	
	Возврат Новый Файл(Папка + "base.cnt");

КонецФункции

Процедура ДействияФормыЗагрузить(Кнопка)
	
	Ответ = Вопрос("После загрузки обязательно сделайте сравнение/объединение с конфигурацией БД, чтобы убедиться, что изменения корректны. Продолжить?", РежимДиалогаВопрос.ОКОтмена);
	Если Ответ = КодВозвратаДиалога.Отмена Тогда
		Возврат;
	КонецЕсли;
	КонтрольныйФайл = КонтрольныйФайл();
	#Если Сервер И Не Сервер Тогда
		КонтрольныйФайл = Новый Файл;
	#КонецЕсли
	Если Не КонтрольныйФайл.Существует() Тогда
		ирОбщий.СообщитьЛкс("Контрольный файл """ + КонтрольныйФайл.ПолноеИмя + """ не найден в папке");
		Возврат;
	КонецЕсли; 
	ДатаКонтрольная = КонтрольныйФайл.ПолучитьВремяИзменения();
	ФайлыПапки = НайтиФайлы(Папка, "*Модул*");
	КраткоеИмяПапкиНеизменных = "Unchanged";
	ПолноеИмяПапкиНеизменных = Папка + КраткоеИмяПапкиНеизменных + "\";
	СоздатьКаталог(ПолноеИмяПапкиНеизменных);
	СчетчикНеизменных = 0;
	Для Каждого ФайлМодуля Из ФайлыПапки Цикл
		#Если Сервер И Не Сервер Тогда
			ФайлМодуля = Новый Файл;
		#КонецЕсли
		Если ДатаКонтрольная >= ФайлМодуля.ПолучитьВремяИзменения() Тогда
			ПереместитьФайл(ФайлМодуля.ПолноеИмя, ПолноеИмяПапкиНеизменных + ФайлМодуля.Имя);
			СчетчикНеизменных = СчетчикНеизменных + 1;
		КонецЕсли; 
	КонецЦикла; 
	ирОбщий.СообщитьЛкс("" + СчетчикНеизменных + " неизменных файлов спрятаны в папку .\" + КраткоеИмяПапкиНеизменных);
	ТекстЛога = "";
	Успех = ирОбщий.ВыполнитьКомандуКонфигуратораЛкс("/LoadConfigFiles """ + Папка + """ -Module", СтрокаСоединенияИнформационнойБазы(), ТекстЛога, Истина, "Загрузка модулей конфигурации");
	ФайлыПапки = НайтиФайлы(ПолноеИмяПапкиНеизменных, "*Модул*");
	Для Каждого ФайлМодуля Из ФайлыПапки Цикл
		#Если Сервер И Не Сервер Тогда
			ФайлМодуля = Новый Файл;
		#КонецЕсли
		ПереместитьФайл(ФайлМодуля.ПолноеИмя, Папка + ФайлМодуля.Имя);
	КонецЦикла; 
	ирОбщий.СообщитьЛкс("" + СчетчикНеизменных + " неизменных файлов возвращены в папку модулей");
	УдалитьФайлы(ПолноеИмяПапкиНеизменных);
	Если Не Успех Тогда 
		Сообщить(ТекстЛога);
		Возврат;
	КонецЕсли;
	ЗапуститьСистему("CONFIG");
	
КонецПроцедуры

Процедура ПапкаОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ЗапуститьПриложение(Элемент.Значение);

КонецПроцедуры

Процедура ПапкаНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	НоваяПапка = ирОбщий.ВыбратьКаталогВФормеЛкс(Элемент.Значение,, "Выберите папку хранения модулей");
	Если НоваяПапка <> Неопределено Тогда
		Элемент.Значение = НоваяПапка;
	КонецЕсли;
	НастроитьЭлементыФормы();

КонецПроцедуры

Процедура НастроитьЭлементыФормы()
	ОбновитьИнфоПапки();
КонецПроцедуры

Процедура КлсКомандаНажатие(Кнопка)
	ирОбщий.УниверсальнаяКомандаФормыЛкс(ЭтаФорма, Кнопка);
КонецПроцедуры

Процедура ПриЗакрытии()
	
	ирОбщий.Форма_ПриЗакрытииЛкс(ЭтаФорма);
	
КонецПроцедуры

Процедура ДействияФормыЗаменить(Кнопка)
	
	ВыполнитьЗамену(Ложь);
	
КонецПроцедуры

Процедура ВыполнитьЗамену(Знач РежимТеста)
	
	Если Не РежимТеста И ТекущаяДата() - ДатаОбновленияФайлов > 600 Тогда
		Ответ = Вопрос("Файлы были выгружены более 10 минут назад. Уверены что хотите продолжить?", РежимДиалогаВопрос.ОКОтмена);
		Если Ответ <> КодВозвратаДиалога.ОК Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли; 
	ЧтоЗаменять = ЭлементыФормы.ПолеЧтоЗаменять.ПолучитьТекст();
	ФайлыПапки = НайтиФайлы(Папка, Маска);
	СчетчикИзменных = 0;
	ТекстовыйДокумент = Новый ТекстовыйДокумент;
	Индикатор = ирОбщий.ПолучитьИндикаторПроцессаЛкс(ФайлыПапки.Количество(), "Замена в файлах");
	Для Каждого ФайлМодуля Из ФайлыПапки Цикл
		#Если Сервер И Не Сервер Тогда
			ФайлМодуля = Новый Файл;
		#КонецЕсли
		ирОбщий.ОбработатьИндикаторЛкс(Индикатор);
		ТекстовыйДокумент.Прочитать(ФайлМодуля.ПолноеИмя);
		ТекстМодуля = ТекстовыйДокумент.ПолучитьТекст();
		ЧислоВхождений = СтрЧислоВхождений(ТекстМодуля, ЧтоЗаменять);
		Если ЧислоВхождений = 0 Тогда
			Продолжить;
		КонецЕсли; 
		НаЧтоЗаменять = ЭлементыФормы.ПолеНаЧтоЗаменять.ПолучитьТекст();
		Если ТипЗамены = "МестоПеред" Тогда
			НаЧтоЗаменять = НаЧтоЗаменять + ЧтоЗаменять;
		ИначеЕсли ТипЗамены = "МестоПосле" Тогда
			НаЧтоЗаменять = НаЧтоЗаменять + ЧтоЗаменять;
		ИначеЕсли ТипЗамены = "МестоВместо" Тогда
			//
		Иначе
			ВызватьИсключение "Некорректный тип замены - " + ТипЗамены;
		КонецЕсли; 
		ТекстМодуля = СтрЗаменить(ТекстМодуля, ЧтоЗаменять, НаЧтоЗаменять);
		Если РежимТеста Тогда
			ирОбщий.СообщитьЛкс("Показан тест замены в файле """ + ФайлМодуля.Имя + """");
			ирОбщий.СравнитьЗначенияВФормеЛкс(ТекстовыйДокумент.ПолучитьТекст(), ТекстМодуля,, "Оригинал", "Замена");
			Возврат;
		КонецЕсли; 
		ТекстовыйДокумент.УстановитьТекст(ТекстМодуля);
		ТекстовыйДокумент.Записать(ФайлМодуля.ПолноеИмя);
		ирОбщий.СообщитьЛкс(Формат(ЧислоВхождений, "ЧЦ=4; ЧДЦ=0; ЧВН=") + " вхождений - " + ФайлМодуля.ИмяБезРасширения);
		СчетчикИзменных = СчетчикИзменных + 1;
	КонецЦикла;
	Если РежимТеста Тогда
		ирОбщий.СообщитьЛкс("Подходящих файлов для замены не найдено");
		Возврат;
	КонецЕсли; 
	ирОбщий.ОсвободитьИндикаторПроцессаЛкс(, Истина);
	ирОбщий.СообщитьЛкс("Изменено " + СчетчикИзменных + " файлов");

КонецПроцедуры

Процедура ДействияФормыТестЗамены(Кнопка)
	
	ВыполнитьЗамену(Истина);
	
КонецПроцедуры

Процедура ТабличноеПолеПриПолученииДанных(Элемент, ОформленияСтрок) Экспорт 
	
	ирОбщий.ТабличноеПолеПриПолученииДанныхЛкс(ЭтаФорма, Элемент, ОформленияСтрок);

КонецПроцедуры

Процедура МаскаОчистка(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ЭтаФорма.Маска = "*";
КонецПроцедуры

Процедура МаскаПриИзменении(Элемент)
	
	ирОбщий.ПолеВводаСИсториейВыбора_ПриИзмененииЛкс(Элемент, ЭтаФорма);

КонецПроцедуры

Процедура МаскаНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	
	ирОбщий.ПолеВводаСИсториейВыбора_НачалоВыбораИзСпискаЛкс(Элемент, ЭтаФорма);

КонецПроцедуры

Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	ирОбщий.Форма_ОбработкаОповещенияЛкс(ЭтаФорма, ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

ирОбщий.ИнициироватьФормуЛкс(ЭтаФорма, "Обработка.ирПлатформа.Форма.ОбработкаМодулейМетаданных");
Маска = "*";