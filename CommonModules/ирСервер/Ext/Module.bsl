﻿//ирПортативный Перем ирПортативный Экспорт;
//ирПортативный Перем ирОбщий Экспорт;
//ирПортативный Перем ирСервер Экспорт;
//ирПортативный Перем ирКэш Экспорт;
//ирПортативный Перем ирПривилегированный Экспорт;

// Поместить строку соединения во временное хранилище
Функция ПоместитьСтрокуСоединенияВХранилищеЛкс(Адрес) Экспорт
	
	ПоместитьВоВременноеХранилище(СтрокаСоединенияИнформационнойБазы(), Адрес);
	
КонецФункции

// Получить строку соединения сервера
Функция ПолучитьСтрокуСоединенияСервераЛкс() Экспорт
	
	Если ирКэш.ЭтоФайловаяБазаЛкс() Тогда
		Результат = СтрокаСоединенияИнформационнойБазы();
	Иначе
		Если ирКэш.ЛиПортативныйРежимЛкс() Тогда
			Результат = СтрокаСоединенияИнформационнойБазы();
		Иначе
			// Антибаг https://partners.v8.1c.ru/forum/t/1361906/m/1361906
			//Если МонопольныйРежим() Тогда
			//	ВызватьИсключение "Невозможно определить строку соединения сервера в монопольном режиме";
			//КонецЕсли; 
			АдресХранилища = ПоместитьВоВременноеХранилище("");
			Параметры = Новый Массив();
			Параметры.Добавить(АдресХранилища);
			ФоновоеЗадание = ФоновыеЗадания.Выполнить("ирСервер.ПоместитьСтрокуСоединенияВХранилищеЛкс", Параметры,, "Получение строки соединения сервера (ИР)");
			ФоновоеЗадание.ОжидатьЗавершения();
			Результат = ПолучитьИзВременногоХранилища(АдресХранилища);
		КонецЕсли; 
	КонецЕсли; 
	Возврат Результат;
	
КонецФункции

/////////////////////////////////////////////
// БСП. Отладка внешних обработок

Процедура ПриПодключенииВнешнейОбработки(Ссылка, СтандартнаяОбработка, Результат) Экспорт
	
	#Если Сервер И Не Сервер Тогда
	    Ссылка = Справочники.ДополнительныеОтчетыИОбработки.ПустаяСсылка();
	#КонецЕсли
	СтандартнаяОбработка = Истина;
	ОтладкаВключена = ХранилищеСистемныхНастроек.Загрузить("ирОтладкаВнешнихОбработок", "СозданиеВнешнихОбработокЧерезФайл");
	Если ОтладкаВключена = Истина Тогда
		ПутьКФайлу = ПолноеИмяФайлаВнешнейОбработкиВФайловомКэшеЛкс(Ссылка);
	Иначе
		Результат = "";
		Возврат;
	КонецЕсли;
	Если Ложь
		Или Ссылка = Вычислить("Справочники.ДополнительныеОтчетыИОбработки.ПустаяСсылка()") 
		Или ТипЗнч(Ссылка) <> Вычислить("Тип(""СправочникСсылка.ДополнительныеОтчетыИОбработки"")") 
	Тогда
		Результат = Неопределено;
		Возврат;
	КонецЕсли;
	Если Ложь
		Или Ссылка.Вид = Вычислить("Перечисления.ВидыДополнительныхОтчетовИОбработок.Отчет") 
		Или Ссылка.Вид = Вычислить("Перечисления.ВидыДополнительныхОтчетовИОбработок.ДополнительныйОтчет") 
	Тогда
		Менеджер = ВнешниеОтчеты;
	Иначе
		Менеджер = ВнешниеОбработки;
	КонецЕсли;
	ФайлВнешнейОбработки = Новый Файл(ПутьКФайлу);
	Если Не ФайлВнешнейОбработки.Существует() Тогда
		Ссылка.ХранилищеОбработки.Получить().Записать(ФайлВнешнейОбработки.ПолноеИмя);
	КонецЕсли; 
	ВнешнийОбъект = Менеджер.Создать(ПутьКФайлу, Ложь);
	ИмяОбработки = ВнешнийОбъект.Метаданные().Имя;
	Результат = ИмяОбработки;
	СтандартнаяОбработка = Ложь;
	Возврат;

КонецПроцедуры

Функция ПолноеИмяФайлаВнешнейОбработкиВФайловомКэшеЛкс(Ссылка, КаталогФайловогоКэша = "") Экспорт 
	
	#Если Сервер И Не Сервер Тогда
	    Ссылка = Справочники.ДополнительныеОтчетыИОбработки.ПустаяСсылка();
	#КонецЕсли
	Если Не ЗначениеЗаполнено(КаталогФайловогоКэша) Тогда
		Обработчик = НайтиПерехватВнешнихОбработокБСПЛкс();
		Если Обработчик = Неопределено Тогда
			ВызватьИсключение "Перехват внеших обработок не включен";
		КонецЕсли; 
		КаталогФайловогоКэша = Обработчик.КаталогФайловогоКэша;
	КонецЕсли; 
	ИмяФайла = Ссылка.ИмяФайла;
	Если Не ЗначениеЗаполнено(ИмяФайла) Тогда
		ИмяФайла = "" + Ссылка.УникальныйИдентификатор() + ".epf";
	КонецЕсли; 
	ПутьКФайлу = КаталогФайловогоКэша + "\" + ИмяФайла;
	Возврат ПутьКФайлу;

КонецФункции

Процедура ВключитьПерехватВнешнихОбработокБСПЛкс(Знач КаталогФайловогоКэша) Экспорт
	
	Обработчики = ПолучитьОбработчикиПриПодключенииВнешнейОбработки();
	СтруктураОбработчика = Новый Структура("Модуль, Версия, Подсистема, КаталогФайловогоКэша", "ирСервер", "", "tormozit", КаталогФайловогоКэша);
	Обработчики.Добавить(СтруктураОбработчика);
	УстановитьОбработчикиПриПодключенииВнешнейОбработки(Обработчики);

КонецПроцедуры

Функция ПолучитьОбработчикиПриПодключенииВнешнейОбработки()
	
	ИмяОбработчика = "СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки\ПриПодключенииВнешнейОбработки";
	КонстантаПараметрыСлужебныхСобытий = Вычислить("Константы.ПараметрыСлужебныхСобытий");
	СтруктруаПараметрыСлужебныхСобытий = КонстантаПараметрыСлужебныхСобытий.Получить().Получить();
	ОбработчикиНаСервере = СтруктруаПараметрыСлужебныхСобытий.ОбработчикиСобытий.НаСервере;
	ОбработчикиСлужебныхСобытий = ОбработчикиНаСервере.ОбработчикиСлужебныхСобытий;
	Обработчики = ОбработчикиСлужебныхСобытий[ИмяОбработчика];
	Обработчики = Новый Массив(Обработчики);
	Возврат Обработчики;

КонецФункции

Процедура УстановитьОбработчикиПриПодключенииВнешнейОбработки(Обработчики)
	
	ИмяОбработчика = "СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки\ПриПодключенииВнешнейОбработки";
	КонстантаПараметрыСлужебныхСобытий = Вычислить("Константы.ПараметрыСлужебныхСобытий");
	СтруктруаПараметрыСлужебныхСобытий = КонстантаПараметрыСлужебныхСобытий.Получить().Получить();
	ОбработчикиНаСервере = СтруктруаПараметрыСлужебныхСобытий.ОбработчикиСобытий.НаСервере;
	ОбработчикиСлужебныхСобытий = Вычислить("Новый Соответствие(ОбработчикиНаСервере.ОбработчикиСлужебныхСобытий)");
	ОбработчикиСлужебныхСобытий[ИмяОбработчика] = Новый ФиксированныйМассив(Обработчики);
	ОбработчикиНаСервере.ОбработчикиСлужебныхСобытий = Новый ФиксированноеСоответствие(ОбработчикиСлужебныхСобытий);
	КонстантаПараметрыСлужебныхСобытий.Установить(Новый ХранилищеЗначения(СтруктруаПараметрыСлужебныхСобытий));
	ОбновитьПовторноИспользуемыеЗначения();

КонецПроцедуры

Функция НайтиПерехватВнешнихОбработокБСПЛкс(Выключить = Ложь) Экспорт
	
	Обработчики = ПолучитьОбработчикиПриПодключенииВнешнейОбработки();
	ОбновитьЗначениеКонстанты = Ложь;
	Для СчетчикОбработчики = - Обработчики.Количество() + 1 По 0 Цикл
		Индекс = -СчетчикОбработчики;
		Обработчик = Обработчики[Индекс];
		Если Обработчик.Модуль = "ирСервер" Тогда
			Если Не Выключить Тогда
				Возврат Обработчик;
			КонецЕсли; 
			Обработчики.Удалить(Индекс);
			ОбновитьЗначениеКонстанты = Истина;
		КонецЕсли;
	КонецЦикла;
	Если ОбновитьЗначениеКонстанты Тогда
		УстановитьОбработчикиПриПодключенииВнешнейОбработки(Обработчики);
	КонецЕсли;
	Возврат Неопределено;

КонецФункции


/////////////////////////////////////////////
// Редиректы

Функция ПолучитьКаталогНастроекПриложения1СЛкс(ИспользоватьОбщийКаталогНастроек = Истина, СоздатьЕслиОтсутствует = Ложь) Экспорт
	
	Результат = ирОбщий.ПолучитьКаталогНастроекПриложения1СЛкс(ИспользоватьОбщийКаталогНастроек, СоздатьЕслиОтсутствует);
	Возврат Результат;
	
КонецФункции

Функция ПолучитьИмяФайлаАктивнойНастройкиТехноЖурналаЛкс() Экспорт

	Результат = ирОбщий.ПолучитьИмяФайлаАктивнойНастройкиТехноЖурналаЛкс();
	Возврат Результат;

КонецФункции

Функция ЛиКаталогТехножурналаНедоступенЛкс(КаталогЖурнала) Экспорт

	Результат = ирОбщий.ЛиКаталогТехножурналаНедоступенЛкс(КаталогЖурнала);
	Возврат Результат;

КонецФункции

Функция ЗаписатьТекстВФайлЛкс(ПолноеИмяФайла, Текст, Кодировка = Неопределено) Экспорт
	
	Результат = ирОбщий.ЗаписатьТекстВФайлЛкс(ПолноеИмяФайла, Текст, Кодировка);
	Возврат Результат;
	
КонецФункции

Функция ПрочитатьТекстИзФайлаЛкс(ПолноеИмяФайла, Кодировка = Неопределено) Экспорт
	
	Результат = ирОбщий.ПрочитатьТекстИзФайлаЛкс(ПолноеИмяФайла, Кодировка);
	Возврат Результат;
	
КонецФункции

Функция НайтиИменаФайловЛкс(Путь, Маска = Неопределено, ИскатьВПодкаталогах = Истина) Экспорт
	
	Результат = ирОбщий.НайтиИменаФайловЛкс(Путь, Маска, ИскатьВПодкаталогах);
	Возврат Результат;
	
КонецФункции

Функция ВычислитьРазмерКаталогаЛкс(Каталог, ВключаяПодкаталоги = Истина) Экспорт
	
	Результат = ирОбщий.ВычислитьРазмерКаталогаЛкс(Каталог, ВключаяПодкаталоги);
	Возврат Результат;

КонецФункции

Функция ПолучитьТекущуюДатуЛкс() Экспорт
	
	Результат = ирОбщий.ПолучитьТекущуюДатуЛкс();
	Возврат Результат;
	
КонецФункции

Процедура ОчиститьКаталогТехножурналаЛкс(КаталогЖурнала, ВыводитьПредупрежденияИСообщения = Истина) Экспорт

	ирОбщий.ОчиститьКаталогТехножурналаЛкс(КаталогЖурнала, , ВыводитьПредупрежденияИСообщения);

КонецПроцедуры // ОчиститьКаталогТехножурналаЛкс()

Процедура ОбновитьМодульВнешнейОбработкиДляОтладкиЛкс(ИмяФайлаВнешнейОбработки, ИмяВнешнейОбработки, ТекстМодуля, ТекстМодуляТекущейВнешнейОбработки, ДатаИзмененияВнешнейОбработки) Экспорт 
	
	ирОбщий.ОбновитьМодульВнешнейОбработкиДляОтладкиЛкс(ИмяФайлаВнешнейОбработки, ИмяВнешнейОбработки, ТекстМодуля, ТекстМодуляТекущейВнешнейОбработки, ДатаИзмененияВнешнейОбработки);
	
КонецПроцедуры

Функция АдаптироватьРасширениеЛкс() Экспорт 

	Результат = ирОбщий.АдаптироватьРасширениеЛкс();
	Возврат Результат;
	
КонецФункции

Функция ВосстановитьЗначениеЛкс(Знач КлючНастроек) Экспорт 

	Возврат ирОбщий.ВосстановитьЗначениеЛкс(КлючНастроек);
	
КонецФункции

Функция СохранитьЗначениеЛкс(Знач КлючНастроек, Знач Значение) Экспорт 

	ирОбщий.СохранитьЗначениеЛкс(КлючНастроек, Значение);
	
КонецФункции

////////

Процедура ВыполнитьЗапросЛкс(ТекстЗапроса) Экспорт 
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.Выполнить();
	
КонецПроцедуры

Процедура ПереместитьФайлЛкс(ИмяИсточника, ИмяПриемника) Экспорт 

	ПереместитьФайл(ИмяИсточника, ИмяПриемника);

КонецПроцедуры // ПереместитьФайл()

Функция ЛиФайлСуществуетЛкс(ПолноеИмяФайла, выхДатаИзменения = Неопределено) Экспорт 

	Файл1 = Новый Файл(ПолноеИмяФайла);
	ФайлНайден = Файл1.Существует();
	Если ФайлНайден Тогда
		выхДатаИзменения = Файл1.ПолучитьВремяИзменения() + ирКэш.ПолучитьСмещениеВремениЛкс();
	КонецЕсли; 
	Возврат ФайлНайден;

КонецФункции // ЛиФайлСуществует()
 
// Выполняет текст алгоритма.
//
// Параметры:
//  ТекстДляВыполнения – Строка;
//  _АлгоритмОбъект - СправочникОбъект
//  *СтруктураПараметров - Структура, *Неопределено.
//
Функция ВыполнитьАлгоритм(_ТекстДляВыполнения, _АлгоритмОбъект = Null, _Режим  = Null,
	_П0 = Null, _П1 = Null, _П2 = Null, _П3 = Null, _П4 = Null, _П5 = Null, _П6 = Null, _П7 = Null, _П8 = Null, _П9 = Null) Экспорт 
	
	Перем Результат;
	Если Истина
		И ирКэш.ЛиПортативныйРежимЛкс()
		И ирПортативный.ЛиСерверныйМодульДоступенЛкс(Ложь)
	Тогда
		ПараметрыКоманды = Новый Структура("_ТекстДляВыполнения, _АлгоритмОбъект", _ТекстДляВыполнения, _АлгоритмОбъект);
		Результат = ирПортативный.ВыполнитьСерверныйМетодЛкс("ВыполнитьАлгоритм", ПараметрыКоманды);
	Иначе
		Результат = ирОбщий.ВыполнитьАлгоритм(_ТекстДляВыполнения, _АлгоритмОбъект);
	КонецЕсли; 
	Возврат Результат;
	
КонецФункции // ПозиционныйМетод()

Процедура ВыполнитьАлгоритмБезРезультата(_ТекстДляВыполнения) Экспорт 
	
	Выполнить(_ТекстДляВыполнения);
	
КонецПроцедуры

Функция ВычислитьВыражение(Выражение) Экспорт
	
	Возврат Вычислить(Выражение);
	
КонецФункции

Функция ВыполнитьАлгоритмЧерезВнешнююОбработкуЛкс(ИмяФайлаВнешнейОбработки, СтруктураПараметров, выхВремяНачала = Неопределено) Экспорт 
	
	Перем Результат;
	Если Истина
		И ирКэш.ЛиПортативныйРежимЛкс()
		И ирПортативный.ЛиСерверныйМодульДоступенЛкс(Ложь)
	Тогда
		ПараметрыКоманды = Новый Структура("ИмяФайлаВнешнейОбработки, СтруктураПараметров, выхВремяНачала", ИмяФайлаВнешнейОбработки, СтруктураПараметров, выхВремяНачала);
		Результат = ирПортативный.ВыполнитьСерверныйМетодЛкс("ВыполнитьАлгоритмЧерезВнешнююОбработкуЛкс", ПараметрыКоманды);
		выхВремяНачала = ПараметрыКоманды.выхВремяНачала;
	Иначе
		Результат = ирОбщий.ВыполнитьАлгоритмЧерезВнешнююОбработкуЛкс(ИмяФайлаВнешнейОбработки, СтруктураПараметров, выхВремяНачала);
	КонецЕсли; 
	Возврат Результат;
	
КонецФункции

Процедура ЗаписатьОбъектXMLЛкс(ОбъектXML, ДополнительныеСвойства, РежимЗаписи = Неопределено, РежимПроведения = Неопределено, ОтключатьКонтрольЗаписи = Неопределено,
	БезАвторегистрацииИзменений = Неопределено) Экспорт 
	
	Если Истина
		И ирКэш.ЛиПортативныйРежимЛкс()
		И ирПортативный.ЛиСерверныйМодульДоступенЛкс()
	Тогда
		ПараметрыКоманды = Новый Структура("ОбъектXML, ДополнительныеСвойства, РежимЗаписи, РежимПроведения, ОтключатьКонтрольЗаписи, БезАвторегистрацииИзменений",
			ОбъектXML, ДополнительныеСвойства, РежимЗаписи, РежимПроведения, ОтключатьКонтрольЗаписи, БезАвторегистрацииИзменений);
		ирПортативный.ВыполнитьСерверныйМетодЛкс("ЗаписатьОбъектXMLЛкс", ПараметрыКоманды);
		ДополнительныеСвойства = ПараметрыКоманды.ДополнительныеСвойства;
		ОбъектXML = ПараметрыКоманды.ОбъектXML;
	Иначе
		Объект = ирОбщий.ВосстановитьОбъектИзСтрокиXMLЛкс(ОбъектXML);
		ирОбщий.ВосстановитьДополнительныеСвойстваОбъектаЛкс(Объект, ДополнительныеСвойства);
		ирОбщий.ЗаписатьОбъектЛкс(Объект, Ложь, РежимЗаписи, РежимПроведения, ОтключатьКонтрольЗаписи, БезАвторегистрацииИзменений);
		ДополнительныеСвойства = ирОбщий.СериализоватьДополнительныеСвойстваОбъектаЛкс(Объект);
		ОбъектXML = ирОбщий.СохранитьОбъектВВидеСтрокиXMLЛкс(Объект);
	КонецЕсли; 
	
КонецПроцедуры

Процедура УдалитьОбъектЛкс(ХМЛ, СтруктураДополнительныхСвойств) Экспорт 
	
	Объект = ирОбщий.ВосстановитьОбъектИзСтрокиXMLЛкс(ХМЛ);
	Объект.Прочитать();
	ирОбщий.ВосстановитьДополнительныеСвойстваОбъектаЛкс(Объект, СтруктураДополнительныхСвойств);
	//Объект.Удалить();
	ирОбщий.УдалитьОбъектЛкс(Объект, Ложь);
	
КонецПроцедуры

Процедура УстановитьПометкуУдаленияОбъектаЛкс(ОбъектXML, СтруктураДополнительныхСвойств, ЗначениеПометки = Истина, БезАвторегистрацииИзменений = Неопределено) Экспорт 
	
	Объект = ирОбщий.ВосстановитьОбъектИзСтрокиXMLЛкс(ОбъектXML);
	Объект.Прочитать(); // Иначе объект будет модифицирован и возникнет ошибка
	ирОбщий.ВосстановитьДополнительныеСвойстваОбъектаЛкс(Объект, СтруктураДополнительныхСвойств);
	ирОбщий.УстановитьПометкуУдаленияОбъектаЛкс(Объект,, ЗначениеПометки, БезАвторегистрацииИзменений);
	ДополнительныеСвойства = ирОбщий.СериализоватьДополнительныеСвойстваОбъектаЛкс(Объект);
	ОбъектXML = ирОбщий.СохранитьОбъектВВидеСтрокиXMLЛкс(Объект);
	
КонецПроцедуры

Функция ПолучитьИмяКомпьютераЛкс() Экспорт
	
	Если ирКэш.ЛиПортативныйРежимЛкс() Тогда
		Результат = НСтр(СтрокаСоединенияИнформационнойБазы(), "Srvr");
	Иначе
		Результат = ИмяКомпьютера();
	КонецЕсли; 
	Возврат Результат;
	
КонецФункции

Функция ПолучитьИспользованиеСобытияЖурналаРегистрацииКакСтруктуру(ИмяСобытия) Экспорт
	
	Результат = Новый Структура("Использование, ОписаниеИспользования");
	
	ИспользованиеСобытия = ПолучитьИспользованиеСобытияЖурналаРегистрации(ИмяСобытия);
	Результат.Использование = ИспользованиеСобытия.Использование;
	
	Если ТипЗнч(ИспользованиеСобытия.ОписаниеИспользования) = Тип("Массив") И ИспользованиеСобытия.ОписаниеИспользования.Количество() > 0  Тогда
		
		ОписаниеИспользования = Новый Массив();
		
		Если ТипЗнч(ИспользованиеСобытия.ОписаниеИспользования[0]) = Тип("ОписаниеИспользованияСобытияДоступЖурналаРегистрации") Тогда
			
			СтрокаКлючей = "Объект, ПоляРегистрации, ПоляДоступа";
			
		ИначеЕсли ТипЗнч(ИспользованиеСобытия.ОписаниеИспользования[0]) = Тип("ОписаниеИспользованияСобытияОтказВДоступеЖурналаРегистрации") Тогда
			
			СтрокаКлючей = "Объект, ПоляРегистрации";
			
		Иначе
			
			//ВызватьИсключение "Неизвестный тип " + ТипЗнч(ИспользованиеСобытия.ОписаниеИспользования[0]);
			
		КонецЕсли;
		
		Для Каждого ЭлементОписания Из ИспользованиеСобытия.ОписаниеИспользования Цикл
		
			ЭлементМассива = Новый Структура(СтрокаКлючей);		
			ЗаполнитьЗначенияСвойств(ЭлементМассива, ЭлементОписания); 
			ОписаниеИспользования.Добавить(ЭлементМассива);
			
		КонецЦикла;
		
		Результат.ОписаниеИспользования = ОписаниеИспользования;
		
	Иначе
		
		Результат.ОписаниеИспользования = Неопределено;
		
	КонецЕсли; 	
		
	Возврат Результат;
	
КонецФункции

Процедура УстановитьИспользованиеСобытияЖурналаРегистрацииПоСтруктуре(ИмяСобытия, пИспользованиеСобытия) Экспорт
	
	ИспользованиеСобытия = Новый ИспользованиеСобытияЖурналаРегистрации;
	ИспользованиеСобытия.Использование = пИспользованиеСобытия.Использование;
	
	пОписаниеИспользования = Неопределено;
	пИспользованиеСобытия.Свойство("ОписаниеИспользования", пОписаниеИспользования);
	Если Истина
		 И ТипЗнч(пОписаниеИспользования) = Тип("Массив") 
		 И пОписаниеИспользования.Количество() > 0
		 И (Ложь
		 	Или ИмяСобытия = "_$Access$_.Access"
			Или ИмяСобытия = "_$Access$_.AccessDenied") Тогда
		
		ТипОписанияСтрокой = ?(ИмяСобытия = "_$Access$_.Access", "ОписаниеИспользованияСобытияДоступЖурналаРегистрации","ОписаниеИспользованияСобытияОтказВДоступеЖурналаРегистрации");			
		ОписаниеИспользования = Новый Массив();
		Для Каждого пЭлементОписания Из пОписаниеИспользования Цикл
			
			ЭлементОписания = Новый(ТипОписанияСтрокой);
			ЗаполнитьЗначенияСвойств(ЭлементОписания, пЭлементОписания); 
			ОписаниеИспользования.Добавить(ЭлементОписания);
			
		КонецЦикла; 			
		
		ИспользованиеСобытия.ОписаниеИспользования = ОписаниеИспользования;
				
	КонецЕсли; 
	
	УстановитьИспользованиеСобытияЖурналаРегистрации(ИмяСобытия, ИспользованиеСобытия)
	
КонецПроцедуры

Функция ПолучитьПараметрыПроцессаАгентаСервера(выхИдентификаторПроцесса = Неопределено, выхКомманднаяСтрока = Неопределено, выхИмяСлужбы = Неопределено) Экспорт 
	
	выхИмяСлужбы = Неопределено;
	РабочийПроцесс = ирОбщий.ПолучитьПроцессОСЛкс(ирКэш.Получить().ПолучитьИдентификаторПроцессаОС());
	Если ТипЗнч(РабочийПроцесс) = Тип("Строка") Тогда
		Сообщить("Ошибка обращения к процессу ОС рабочего процесса: " + РабочийПроцесс);
		Возврат Неопределено;
	КонецЕсли; 
	КомпьютерКластера = ирОбщий.ИмяКомпьютераКластераЛкс();
	Если Не ЗначениеЗаполнено(КомпьютерКластера) Тогда
		Возврат Неопределено;
	КонецЕсли; 
	Попытка
		WMIЛокатор = ирКэш.ПолучитьCOMОбъектWMIЛкс(КомпьютерКластера);
	Исключение
		Сообщить("У пользователя рабочего процесса нет прав на подключение к WMI кластера: " + ОписаниеОшибки());
		Возврат Неопределено;
	КонецПопытки; 
	выхИдентификаторПроцесса = РабочийПроцесс.ParentProcessId;
	ПроцессАгента = ирОбщий.ПолучитьПроцессОСЛкс(выхИдентификаторПроцесса,, КомпьютерКластера);
	Если ТипЗнч(ПроцессАгента) = Тип("COMОбъект") Тогда
		выхКомманднаяСтрока = ПроцессАгента.CommandLine;
		ТекстЗапросаWQL = "Select * from Win32_Service Where ProcessId = " + XMLСтрока(выхИдентификаторПроцесса);
		ВыборкаСистемныхСлужб = WMIЛокатор.ExecQuery(ТекстЗапросаWQL);
		Для Каждого лСистемнаяСлужба Из ВыборкаСистемныхСлужб Цикл
			СистемнаяСлужба = лСистемнаяСлужба;
			Прервать;
		КонецЦикла;
	КонецЕсли; 
	Если СистемнаяСлужба = Неопределено Тогда
		//Сообщить("Не удалось определить имя системной службы агента сервера приложений", СтатусСообщения.Внимание);
		Возврат Неопределено;
	КонецЕсли;
	выхИмяСлужбы = СистемнаяСлужба.Name;
	Возврат выхИдентификаторПроцесса;
	
КонецФункции

Функция ПриНачалеРаботыСистемыРасширениеЛкс() Экспорт 
	
	Если Истина
		И ПравоДоступа("Администрирование", Метаданные) 
		И ПравоДоступа("ТолстыйКлиент", Метаданные)
		И Не ПравоДоступа("Использование", Метаданные.Обработки.ирПортативный)
		И Не РольДоступна("ирПользователь")
	Тогда
		ТекущийПользователь = ПользователиИнформационнойБазы.ТекущийПользователь();
		ТекущийПользователь.Роли.Добавить(Метаданные.Роли.ирРазработчик);
		ТекущийПользователь.Роли.Добавить(Метаданные.Роли.ирПользователь);
		ТекущийПользователь.Записать();
		Возврат Истина;
	КонецЕсли;
	Возврат Ложь
	
КонецФункции

///////////////////////////////////////////////////
// Управляемые формы

// РежимИмяСиноним - Булево - Истина - Имя
Процедура НастроитьАвтоТаблицуФормыДинамическогоСпискаЛкс(ЭтаФорма, ОсновнойЭУ, РежимИмяСиноним = Ложь) Экспорт
	
	#Если Сервер И Не Сервер Тогда
	    ОсновнойЭУ = Элементы.ДинамическийСписок;
	#КонецЕсли
	ДинамическийСписок = ирОбщий.ДанныеЭлементаФормыЛкс(ОсновнойЭУ);
	ПолноеИмяТаблицы = ДинамическийСписок.ОсновнаяТаблица;
	ОбъектМД = ирОбщий.НайтиОбъектМетаданныхПоПолномуИмениТаблицыБДЛкс(ПолноеИмяТаблицы, Истина);
	ПолноеИмяМД = ОбъектМД.ПолноеИмя();
	ТипТаблицы = ирОбщий.ПолучитьТипТаблицыБДЛкс(ПолноеИмяТаблицы);
	КорневойТип = ирОбщий.ПолучитьПервыйФрагментЛкс(ПолноеИмяМД);
	
	////СтруктураХраненияПолей = ирКэш.ПолучитьСтруктуруХраненияБДЛкс().НайтиСтроки(Новый Структура("Назначение, Метаданные", "Основная", ПолноеИмяМД))[0].Поля;
	//ФильтрМетаданных = Новый Массив;
	//ФильтрМетаданных.Добавить(ПолноеИмяМД);
	//СтруктураХраненияТаблицы = ПолучитьСтруктуруХраненияБазыДанных(ФильтрМетаданных).НайтиСтроки(Новый Структура("Назначение, Метаданные", "Основная", ПолноеИмяМД))[0];
	//СтруктураХраненияПолей = СтруктураХраненияТаблицы.Поля;
	
	//ВерсияПлатформы = ирКэш.Получить().ВерсияПлатформы;
	КолонкиТП = ОсновнойЭУ.ПодчиненныеЭлементы;
	ПутьКДаннымСписка = ОсновнойЭУ.ПутьКДанным;
	ДинамическийСписок.ПроизвольныйЗапрос = Истина;
	ДинамическийСписок.ДинамическоеСчитываниеДанных = Истина;
	ТекстДопПоля = "";
	Если ирОбщий.ЛиКорневойТипСсылкиЛкс(ТипТаблицы) Тогда
		ТекстДопПоля = ТекстДопПоля + ", 0 КАК ИдентификаторСсылкиЛкс";
	КонецЕсли; 
	ДинамическийСписок.ТекстЗапроса = "ВЫБРАТЬ *" + ТекстДопПоля + " ИЗ " + ПолноеИмяТаблицы;
	ПоляТаблицы = ЭтаФорма.ПолучитьРеквизиты(ПутьКДаннымСписка);
	Пока ОсновнойЭУ.ПодчиненныеЭлементы.Количество() > 0 Цикл
		Попытка
			ЭтаФорма.Элементы.Удалить(ОсновнойЭУ.ПодчиненныеЭлементы[0]);
		Исключение
			Пустышка = 0; // Для отладки
		КонецПопытки;
	КонецЦикла;
	Для Каждого ПолеСписка Из ПоляТаблицы Цикл
		Если Ложь
			Или ПолеСписка.ТипЗначения.СодержитТип(Тип("Картинка"))
			Или ПолеСписка.ТипЗначения.СодержитТип(Тип("КомпоновщикНастроекКомпоновкиДанных"))
			Или ПолеСписка.ТипЗначения.СодержитТип(Тип("ПорядокКомпоновкиДанных"))
			Или ПолеСписка.ТипЗначения.СодержитТип(Тип("ОтборКомпоновкиДанных"))
			Или ПолеСписка.ТипЗначения.СодержитТип(Тип("ПоляГруппировкиКомпоновкиДанных"))
			Или ПолеСписка.ТипЗначения.СодержитТип(Тип("ЗначенияПараметровДанныхКомпоновкиДанных"))
			Или ПолеСписка.ТипЗначения.СодержитТип(Тип("УсловноеОформлениеКомпоновкиДанных"))
		Тогда
			Продолжить;
		КонецЕсли; 
		ИмяКолонки = ПолеСписка.Имя;
		ИмяПоля = ОсновнойЭУ.Имя + ИмяКолонки;
		Колонка = КолонкиТП.Найти(ИмяПоля);
		Если Колонка = Неопределено Тогда
			Колонка = ЭтаФорма.Элементы.Добавить(ИмяПоля, Тип("ПолеФормы"), ОсновнойЭУ);
			Колонка.Вид = ВидПоляФормы.ПолеНадписи;
			ПутьКДаннымПоля = ПутьКДаннымСписка + "." + ИмяКолонки;
			Попытка
				Колонка.ПутьКДанным = ПутьКДаннымПоля;
			Исключение
				// Например при ИмяКолонки = "ВерсияДанных"
			КонецПопытки; 
		КонецЕсли;
		//Колонка.ТекстШапки = ЭлементОтбора.Представление;
		//Если ТипТаблицы <> "Перечисление" Тогда
		//	ДанныеПодключены = Ложь;
		//	Если Истина
		//		И ЭлементОтбора.ТипЗначения.СодержитТип(Тип("Булево")) 
		//		И ЭлементОтбора.ТипЗначения.Типы().Количество() = 1
		//	Тогда
		//		Колонка.УстановитьЭлементУправления(Тип("Флажок"));
		//		Попытка
		//			Колонка.ДанныеФлажка = ИмяКолонки;
		//			ДанныеПодключены = Истина;
		//		Исключение
		//			ОписаниеОшибки = ОписаниеОшибки(); // Для отладки
		//		КонецПопытки;
		//	Иначе 
		//		Колонка.УстановитьЭлементУправления(Тип("ПолеВвода"));
		//		Попытка
		//			Колонка.Данные = ИмяКолонки;
		//			ДанныеПодключены = Истина;
		//		Исключение
		//			ОписаниеОшибки = ОписаниеОшибки(); // Для отладки
		//		КонецПопытки;
		//	КонецЕсли; 
		//	Если Не ДанныеПодключены Тогда
		//		Колонка.Видимость = Ложь;
		//	КонецЕсли; 
		//КонецЕсли;
		
		//// Закомментировал 13.02.2011
		////Если ЗначениеЗаполнено(Колонка.Данные) Тогда
		////            Колонка.Имя = Колонка.Данные;
		////КонецЕсли; 
		//МетаданныеПоля = ЭлементОтбора.Метаданные;
		//Если МетаданныеПоля <> Неопределено Тогда
		//	Попытка
		//		Колонка.ПодсказкаВШапке = МетаданныеПоля.Подсказка;
		//	Исключение
		//		// У графы журнала нет подсказки
		//	КонецПопытки;
		//КонецЕсли; 
		
		//// Антибаг платформы 8.2-8.3.6 https://partners.v8.1c.ru/forum/t/1337995/m/1337995
		//Если Истина
		//	И ВерсияПлатформы < 803008
		//	И ЭлементОтбора.ТипЗначения.СодержитТип(Тип("УникальныйИдентификатор")) 
		//Тогда
		//	Сообщить("Колонка """ + ИмяКолонки + """ типа УникальныйИдентификатор не будет отображаться из-за ошибки платформы");
		//	КолонкиТП.Удалить(Колонка);
		//	Продолжить;
		//КонецЕсли; 
	КонецЦикла;
	//НовыйПорядок = ирОбщий.ПолучитьСтрокуПорядкаКомпоновкиЛкс(ДинамическийСписок.КомпоновщикНастроек.ПользовательскиеНастройки.Порядок);
	//Если Не ЗначениеЗаполнено(НовыйПорядок) Тогда
	//	// Обязательную установку делаем, чтобы в шапках появились индикаторы сортировки и чтобы он стал виден другим механизмам
	//	ирОбщий.СкопироватьПорядокЛюбойЛкс(ДинамическийСписок.КомпоновщикНастроек.ПользовательскиеНастройки.Порядок, ДинамическийСписок.Порядок);
	//КонецЕсли; 
	НастроитьЗаголовкиАвтоТаблицыФормыДинамическогоСпискаЛкс(ОсновнойЭУ, РежимИмяСиноним);
	
КонецПроцедуры

Процедура НастроитьЗаголовкиАвтоТаблицыФормыДинамическогоСпискаЛкс(Знач ОсновнойЭУ, Знач РежимИмяСиноним) Экспорт 
	
	ДинамическийСписок = ирОбщий.ДанныеЭлементаФормыЛкс(ОсновнойЭУ);
	ПоляТаблицы = ирОбщий.ПолучитьПоляТаблицыМДЛкс(ДинамическийСписок.ОсновнаяТаблица);
	ПоляТаблицы = ПоляТаблицы.Скопировать();
	СтрокаПоляИденитификатора = ПоляТаблицы.Добавить();
	СтрокаПоляИденитификатора.Имя = "ИдентификаторСсылкиЛкс";
	СтрокаПоляИденитификатора.Заголовок = "Идентификатор ссылки";
	Для Каждого ПолеТаблицы Из ПоляТаблицы Цикл
		Колонка = ОсновнойЭУ.ПодчиненныеЭлементы.Найти(ОсновнойЭУ.Имя + ПолеТаблицы.Имя);
		Если Колонка = Неопределено Тогда
			Продолжить;
		КонецЕсли; 
		Если РежимИмяСиноним Тогда
			Колонка.Заголовок = ПолеТаблицы.Имя;
		Иначе
			Колонка.Заголовок = ПолеТаблицы.Заголовок;
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры // НастроитьАвтоТабличноеПолеДинамическогоСписка()

Процедура УправляемаяФорма_ПриСозданииЛкс(Знач ЭтаФорма, Отказ, СтандартнаяОбработка, Знач ПоляДляЗапоминанияТипов = Неопределено, Знач ПоляФормыСИсториейВыбора = Неопределено) Экспорт 
	
	Если ирКэш.ЛиПортативныйРежимЛкс() Тогда
		Сообщить("Управляемые формы инструментов не поддерживают работу в портативном режиме");
		Отказ = Истина;
		Возврат;
	КонецЕсли; 
	Если ПоляФормыСИсториейВыбора <> Неопределено Тогда
		Если ТипЗнч(ПоляФормыСИсториейВыбора) = Тип("Массив") Тогда
			МассивПолей = ПоляФормыСИсториейВыбора;
		Иначе
			МассивПолей = Новый Массив;
			МассивПолей.Добавить(ПоляФормыСИсториейВыбора);
		КонецЕсли;
		ПоляФормыСИсториейВыбора = МассивПолей;
		Для Каждого ПолеФормыСИсториейВыбора Из ПоляФормыСИсториейВыбора Цикл
			ирСервер.ПолеФормыСИсториейВыбора_ЗаполнитьСписокВыбораЛкс(ПолеФормыСИсториейВыбора, ЭтаФорма.ИмяФормы);
		КонецЦикла;
	КонецЕсли;
	ИмяКорневогоРеквизита = "мСлужебныеДанные";
	ДобавляемыеРеквизиты = Новый Массив();
	КорневойРеквизитФормы = Новый РеквизитФормы(ИмяКорневогоРеквизита, Новый ОписаниеТипов);
	ДобавляемыеРеквизиты.Добавить(КорневойРеквизитФормы);
	ЭтаФорма.ИзменитьРеквизиты(ДобавляемыеРеквизиты);
	УправляемаяФорма_ОбновитьСлужебныеДанныеЛкс(ЭтаФорма, ПоляДляЗапоминанияТипов, ПоляФормыСИсториейВыбора);
	
КонецПроцедуры

Процедура УправляемаяФорма_ОбновитьСлужебныеДанныеЛкс(Знач ЭтаФорма, Знач ПоляДляЗапоминанияТипов = Неопределено, Знач ПоляСИсториейВыбора = Неопределено) Экспорт 
	
	СтруктураПутиКДанным = Новый Структура();
	ЗаполнитьСоответствиеПутиКДаннымПодчиненныхЭлементовФормыЛкс(ЭтаФорма, СтруктураПутиКДанным);
	ФиксированнаяСтруктураПутиКДанным = Новый ФиксированнаяСтруктура(СтруктураПутиКДанным);
	
	СтруктураТипыЗначений = Новый Структура;
	МассивПолей = Новый Массив();
	Если ПоляДляЗапоминанияТипов <> Неопределено Тогда
		Если ТипЗнч(ПоляДляЗапоминанияТипов) = Тип("Массив") Тогда
			ирОбщий.СкопироватьУниверсальнуюКоллекциюЛкс(ПоляДляЗапоминанияТипов, МассивПолей);
		Иначе
			МассивПолей.Добавить(ПоляДляЗапоминанияТипов);
		КонецЕсли;
	КонецЕсли; 
	Если ТипЗнч(ПоляСИсториейВыбора) = Тип("Массив") Тогда
		ирОбщий.СкопироватьУниверсальнуюКоллекциюЛкс(ПоляСИсториейВыбора, МассивПолей);
	Иначе
		МассивПолей.Добавить(ПоляСИсториейВыбора);
	КонецЕсли;
	ПоляДляЗапоминанияТипов = МассивПолей;
	Для Каждого Поле Из ПоляДляЗапоминанияТипов Цикл
		СтруктураТипыЗначений.Вставить(Поле.Имя, ПолучитьТипЗначенияПоляФормыЛкс(Поле));
	КонецЦикла;
	ФиксированнаяСтруктураТипыЗначений = Новый ФиксированнаяСтруктура(СтруктураТипыЗначений);
	
	КорневыеРеквизиты = ЭтаФорма.ПолучитьРеквизиты();
	СтруктураСохраняемыеДанные = Новый Структура();
	ОсновныеТаблицыСписков = Новый Структура();
	Для Каждого КорневойРеквизит Из КорневыеРеквизиты Цикл
		Если КорневойРеквизит.СохраняемыеДанные Тогда
			СтруктураСохраняемыеДанные.Вставить(КорневойРеквизит.Имя);
		КонецЕсли; 
		Если КорневойРеквизит.ТипЗначения.СодержитТип(Тип("ДинамическийСписок")) Тогда
			ОсновныеТаблицыСписков.Вставить(КорневойРеквизит.Имя, ЭтаФорма[КорневойРеквизит.Имя].ОсновнаяТаблица);
		КонецЕсли; 
	КонецЦикла; 
	СтруктураСохраняемыеДанные = Новый ФиксированнаяСтруктура(СтруктураСохраняемыеДанные);
	ОсновныеТаблицыСписков = Новый ФиксированнаяСтруктура(ОсновныеТаблицыСписков);
	
	СтруктураКорневогоРеквизита = Новый Структура();
	СтруктураКорневогоРеквизита.Вставить("ПутиКДанным", ФиксированнаяСтруктураПутиКДанным);
	СтруктураКорневогоРеквизита.Вставить("СохраняемыеДанные", СтруктураСохраняемыеДанные);
	СтруктураКорневогоРеквизита.Вставить("ТипыЗначений", ФиксированнаяСтруктураТипыЗначений);
	СтруктураКорневогоРеквизита.Вставить("ОсновныеТаблицыСписков", ОсновныеТаблицыСписков);
	ЭтаФорма.мСлужебныеДанные = Новый ФиксированнаяСтруктура(СтруктураКорневогоРеквизита);

	// Преобразуем автозаголовки в статические заголовки для возможности поиска https://partners.v8.1c.ru/forum/topic/1074579
	СоответствиеРеквизитов = СоответствиеРеквизитовФормы(ЭтаФорма);
	Для Каждого ЭлементФормы Из ЭтаФорма.Элементы Цикл
		СтруктураСвойств = Новый Структура("ПутьКДанным, Заголовок");
		ЗаполнитьЗначенияСвойств(СтруктураСвойств, ЭлементФормы); 
		Если Истина
			И ЗначениеЗаполнено(СтруктураСвойств.ПутьКДанным) 
			И Не ЗначениеЗаполнено(СтруктураСвойств.Заголовок) 
		Тогда
			ЭлементФормы.Заголовок = СоответствиеРеквизитов[ЭлементФормы.ПутьКДанным].Заголовок;
		КонецЕсли; 
		Если Истина
			И Типзнч(ЭлементФормы) = Тип("КнопкаФормы")
			И ЗначениеЗаполнено(ЭлементФормы.ИмяКоманды) 
			И Не ЗначениеЗаполнено(ЭлементФормы.Заголовок) 
		Тогда
			КомандаФормы = ЭтаФорма.Команды.Найти(ЭлементФормы.Имя);
			Если КомандаФормы <> Неопределено Тогда
				ЭлементФормы.Заголовок = КомандаФормы.Заголовок;
			КонецЕсли; 
		КонецЕсли; 
	КонецЦикла;
	
КонецПроцедуры

Функция СоответствиеРеквизитовФормы(ЭтаФорма, Знач ПутьКРодителю = "", Знач СоответствиеРеквизитов = Неопределено) Экспорт 
	
	Если СоответствиеРеквизитов = Неопределено Тогда
		СоответствиеРеквизитов = Новый Соответствие;
	КонецЕсли;
	Попытка
		РеквизитыФормы = ЭтаФорма.ПолучитьРеквизиты(ПутьКРодителю);
	Исключение
		Возврат СоответствиеРеквизитов;
	КонецПопытки;
	Для Каждого РеквизитФормы Из РеквизитыФормы Цикл
		ПолноеИмяРеквизита = РеквизитФормы.Имя;
		Если ЗначениеЗаполнено(РеквизитФормы.Путь) Тогда
			ПолноеИмяРеквизита = РеквизитФормы.Путь + "." + ПолноеИмяРеквизита; 
		КонецЕсли; 
		СоответствиеРеквизитов.Вставить(ПолноеИмяРеквизита, РеквизитФормы);
		СоответствиеРеквизитовФормы(ЭтаФорма, ПолноеИмяРеквизита, СоответствиеРеквизитов);
	КонецЦикла;
	Возврат СоответствиеРеквизитов;

КонецФункции

//  Заполнить соответствие пути К данным подчиненных элементов формы иис
//
// Параметры:
//	НачальныйЭлемент - <тип> - 
//	СтруктураПутиКДанным - <тип> - 
//
Процедура ЗаполнитьСоответствиеПутиКДаннымПодчиненныхЭлементовФормыЛкс(НачальныйЭлемент, СтруктураПутиКДанным) Экспорт

	Для Каждого Поле Из НачальныйЭлемент.ПодчиненныеЭлементы Цикл
		Если ТипЗнч(Поле) = Тип("ПолеФормы") Тогда 
			Если Поле.ПутьКДанным <> "" Тогда
				ТаблицаФормы = ирОбщий.ПолучитьРодителяЭлементаУправляемойФормыЛкс(Поле, Тип("ТаблицаФормы"));
				Если ТаблицаФормы <> Неопределено Тогда
					СтруктураПутиКДанным.Вставить(Поле.Имя, "Элементы." + ТаблицаФормы.Имя + ".ТекущиеДанные." + ирОбщий.ПолучитьПоследнийФрагментЛкс(Поле.ПутьКДанным));
				Иначе
					СтруктураПутиКДанным.Вставить(Поле.Имя, Поле.ПутьКДанным);
				КонецЕсли; 
			КонецЕсли; 
		ИначеЕсли ТипЗнч(Поле) = Тип("ТаблицаФормы") Тогда
			Если Поле.ПутьКДанным <> "" Тогда
				СтруктураПутиКДанным.Вставить(Поле.Имя, Поле.ПутьКДанным);
			КонецЕсли; 
		КонецЕсли; 
		Если Ложь
			Или ТипЗнч(Поле) = Тип("ГруппаФормы") 
			Или ТипЗнч(Поле) = Тип("ТаблицаФормы")
		Тогда
			ЗаполнитьСоответствиеПутиКДаннымПодчиненныхЭлементовФормыЛкс(Поле, СтруктураПутиКДанным);
		КонецЕсли; 
	КонецЦикла;

КонецПроцедуры

Процедура ПолеФормыСИсториейВыбора_ЗаполнитьСписокВыбораЛкс(ПолеФормы, КлючИстории) Экспорт
	
	// Запоминать последние
	КлючНастройки = КлючИстории + "." + ПолеФормы.Имя + ".ПоследниеЗначения";
	ПоследниеЗначения = ирОбщий.ВосстановитьЗначениеЛкс(КлючНастройки);
	Если ТипЗнч(ПоследниеЗначения) = Тип("Массив") Тогда
		ПолеФормы.СписокВыбора.Очистить();
		Для Каждого Значение Из ПоследниеЗначения Цикл
			НовыйЭлемент = ПолеФормы.СписокВыбора.Добавить(Значение);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

//  Получить тип значения поля формы иис
//
// Параметры:
//	ПолеФормы - <тип> - 
//
// Возвращаемое значение:
//
Функция ПолучитьТипЗначенияПоляФормыЛкс(ПолеФормы) Экспорт
	
	ЭтаФорма = ирОбщий.ПолучитьРодителяЭлементаУправляемойФормыЛкс(ПолеФормы); 
	//Типы = ПолеФормы.ДоступныеТипы.Типы();
	ИмяРеквизита = ирОбщий.ПолучитьПоследнийФрагментЛкс(ПолеФормы.ПутьКДанным);
	ПутьКРодителю = ирОбщий.ПолучитьСтрокуБезКонцаЛкс(ПолеФормы.ПутьКДанным, СтрДлина(ИмяРеквизита + 1));
	Реквизиты = ЭтаФорма.ПолучитьРеквизиты(ПутьКРодителю); // затратная операция, а нужен всего лишь тип
	Реквизит = ирОбщий.НайтиЭлементКоллекцииПоЗначениюСвойстваЛкс(Реквизиты, "Имя", ИмяРеквизита);
	Типы = Реквизит.ТипЗначения.Типы();
	Если Типы.Количество() <> 1 Тогда
		Если ЗначениеЗаполнено(ПолеФормы.СвязьПоТипу.ПутьКДанным) Тогда
			ТипЗначения = Вычислить("ЭтаФорма." + ПолеФормы.СвязьПоТипу.ПутьКДанным);
		КонецЕсли; 
		Попытка
			ТипЗначения = ТипЗначения.ТипЗначения.Типы()[0]
		Исключение
		КонецПопытки;
		Если ТипЗнч(ТипЗначения) <> Тип("Тип") Тогда
			ТипЗначения = Неопределено;
		КонецЕсли; 
	Иначе
		ТипЗначения = Типы[0];
	КонецЕсли;
	Возврат ТипЗначения;
	
КонецФункции

