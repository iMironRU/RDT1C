﻿// ПОСЛЕ КАЖДОГО ИЗМЕНЕНИЯ НУЖНО ОБНОВЛЯТЬ ВЕРСИЮ в функции СведенияОВнешнейОбработке
// ЗДЕСЬ НЕЛЬЗЯ ИСПОЛЬЗОВАТЬ ОБЩИЕ МОДУЛИ ПОДСИСТЕМЫ

// Интерфейс для регистрации обработки.
// Вызывается при добавлении обработки в справочник "ВнешниеОбработки"
//
// Возвращаемое значение:
// Структура:
// Вид - строка - возможные значения:	"ДополнительнаяОбработка"
//										"ДополнительныйОтчет"
//										"ЗаполнениеОбъекта"
//										"Отчет"
//										"ПечатнаяФорма"
//										"СозданиеСвязанныхОбъектов"
//
// Назначение - массив строк имен объектов метаданных в формате:
//			<ИмяКлассаОбъектаМетаданного>.[ * | <ИмяОбъектаМетаданных>]
//			Например, "Документ.СчетЗаказ" или "Справочник.*"
//			Прим. параметр имеет смысл только для назначаемых обработок
//
// Наименование - строка - наименование обработки, которым будет заполнено
//						наименование справочника по умолчанию - краткая строка для
//						идентификации обработки администратором
//
// Версия - строка - версия обработки в формате <старший номер>.<младший номер>
//					используется при загрузке обработок в информационную базу
// БезопасныйРежим – Булево – Если истина, обработка будет запущена в безопасном режиме.
//							Более подбробная информация в справке.
//
// Информация - Строка- краткая информация по обработке, описание обработки
//
// ВерсияБСП - Строка - Минимальная версия БСП, на которую рассчитывает код
// дополнительной обработки. Номер версии БСП задается в формате «РР.ПП.ВВ.СС»
// (РР – старший номер редакции; ПП – младший номер ре-дакции; ВВ – номер версии; СС – номер сборки).
//
// Команды - ТаблицаЗначений - команды, поставляемые обработкой, одная строка таблицы соотвествует
//							одной команде
//				колонки: 
//				 - Представление - строка - представление команды конечному пользователю
//				 - Идентификатор - строка - идентефикатор команды. В случае печатных форм
//											перечисление через запятую списка макетов
//				 - Использование - строка - варианты запуска обработки:
//						"ОткрытиеФормы" - открыть форму обработки
//						"ВызовКлиентскогоМетода" - вызов клиентского экспортного метода из формы обработки
//						"ВызовСерверногоМетода" - вызов серверного экспортного метода из модуля объекта обработки
//				 - ПоказыватьОповещение – Булево – если Истина, требуется оказывать оповещение при начале
//								и при окончании запуска обработки. Прим. Имеет смысл только
//								при запуске обработки без открытия формы.
//				 - Модификатор – строка - для печатных форм MXL, которые требуется
//										отображать в форме ПечатьДокументов подсистемы Печать
//										требуется установить как "ПечатьMXL"
//
// Предусмотрено 2 команды:
// 1. "Открыть форму обработки" для загрузки прайс-листа в диалоговом режиме
// 2. "Загрузить прайс-лист и сохранить протокол в файл" для загрузки прайс-листа по регламентному заданию и
// сохранения протокола в файл.
//
Функция СведенияОВнешнейОбработке() Экспорт
	
	РегистрационныеДанные = Новый Структура;
	РегистрационныеДанные.Вставить("Наименование", "ирПортативныйСервер");
	РегистрационныеДанные.Вставить("БезопасныйРежим", Ложь);
	РегистрационныеДанные.Вставить("Версия", "3.80.1"); // Здесь выполняется программная замена при выпуске портативной версии
	РегистрационныеДанные.Вставить("ВерсияБСП", "1.2.1.4");

	РегистрационныеДанные.Вставить("Вид", "ДополнительнаяОбработка");
	
	РегистрационныеДанные.Вставить("Информация", "");
	
	ТЗКоманд = Новый ТаблицаЗначений;
	ТЗКоманд.Колонки.Добавить("Идентификатор");
	ТЗКоманд.Колонки.Добавить("Представление");
	ТЗКоманд.Колонки.Добавить("Модификатор");
	ТЗКоманд.Колонки.Добавить("ПоказыватьОповещение");
	ТЗКоманд.Колонки.Добавить("Использование");
	
	СтрокаКоманды = тзКоманд.Добавить();
	СтрокаКоманды.Идентификатор = "ЗаписатьОбъектXMLЛкс";
	СтрокаКоманды.Представление = "ЗаписатьОбъектXMLЛкс";
	СтрокаКоманды.ПоказыватьОповещение = Ложь;
	СтрокаКоманды.Использование = "ВызовСерверногоМетода";
	
	СтрокаКоманды = тзКоманд.Добавить();
	СтрокаКоманды.Идентификатор = "УдалитьОбъектXMLЛкс";
	СтрокаКоманды.Представление = "УдалитьОбъектXMLЛкс";
	СтрокаКоманды.ПоказыватьОповещение = Ложь;
	СтрокаКоманды.Использование = "ВызовСерверногоМетода";
	
	СтрокаКоманды = тзКоманд.Добавить();
	СтрокаКоманды.Идентификатор = "ВыполнитьАлгоритм";
	СтрокаКоманды.Представление = "ВыполнитьАлгоритм";
	СтрокаКоманды.ПоказыватьОповещение = Ложь;
	СтрокаКоманды.Использование = "ВызовСерверногоМетода";
	
	СтрокаКоманды = тзКоманд.Добавить();
	СтрокаКоманды.Идентификатор = "ИнфоСервераПриложений";
	СтрокаКоманды.Представление = "ИнфоСервераПриложений";
	СтрокаКоманды.ПоказыватьОповещение = Ложь;
	СтрокаКоманды.Использование = "ВызовСерверногоМетода";
	
	СтрокаКоманды = тзКоманд.Добавить();
	СтрокаКоманды.Идентификатор = "ЗапуститьФоновоеЗадание";
	СтрокаКоманды.Представление = "ЗапуститьФоновоеЗадание";
	СтрокаКоманды.ПоказыватьОповещение = Ложь;
	СтрокаКоманды.Использование = "ВызовСерверногоМетода";
	
	РегистрационныеДанные.Вставить("Команды", ТЗКоманд);
	
	Возврат РегистрационныеДанные;
	
КонецФункции

// Параметры
// ОбъектыНазначения - массив -  ссылоки на объекты информационной базы, для которых требуется вызвать обработку
// ПараметрыВыполненияКоманды - структура - структура со свойством ДополнительнаяОбработкаСсылка (ссылка на
// элемент справочника ДополнительныеОтчетыИОбработки, который связан с данной дополнительной обработкой)
//
Процедура ВыполнитьКомандуНаСервере(ИдентификаторКоманды, ПараметрыКоманды) Экспорт
	
	Если ИдентификаторКоманды = "ЗаписатьОбъектXMLЛкс" Тогда
		ОбъектXML  = ПараметрыКоманды.ОбъектXML;
		ДополнительныеСвойства = ПараметрыКоманды.ДополнительныеСвойства;
		РежимЗаписи = ПараметрыКоманды.РежимЗаписи;
		ОтключатьКонтрольЗаписи = ПараметрыКоманды.ОтключатьКонтрольЗаписи;
		БезАвторегистрацииИзменений = ПараметрыКоманды.БезАвторегистрацииИзменений;
		ПривилегированныйРежим = ПараметрыКоманды.ПривилегированныйРежим;
		ЗаписатьОбъектXMLЛкс(ОбъектXML, ДополнительныеСвойства, РежимЗаписи, ОтключатьКонтрольЗаписи, БезАвторегистрацииИзменений, ПривилегированныйРежим);
		ПараметрыКоманды.ОбъектXML = ОбъектXML;
	ИначеЕсли ИдентификаторКоманды = "УдалитьОбъектXMLЛкс" Тогда
		ОбъектXML  = ПараметрыКоманды.ОбъектXML;
		ДополнительныеСвойства = ПараметрыКоманды.ДополнительныеСвойства;
		ОтключатьКонтрольЗаписи = ПараметрыКоманды.ОтключатьКонтрольЗаписи;
		БезАвторегистрацииИзменений = ПараметрыКоманды.БезАвторегистрацииИзменений;
		ПривилегированныйРежим = ПараметрыКоманды.ПривилегированныйРежим;
		УдалитьОбъектXMLЛкс(ОбъектXML, ДополнительныеСвойства, ОтключатьКонтрольЗаписи, БезАвторегистрацииИзменений, ПривилегированныйРежим);
		ПараметрыКоманды.ОбъектXML = ОбъектXML;
	ИначеЕсли ИдентификаторКоманды = "ВыполнитьАлгоритм" Тогда
		ВыполнитьАлгоритм(ПараметрыКоманды._ТекстДляВыполнения, ПараметрыКоманды._АлгоритмОбъект);
	ИначеЕсли ИдентификаторКоманды = "ИнфоСервераПриложений" Тогда
		ПараметрыКоманды.Результат = ИнфоСервераПриложений();
	ИначеЕсли ИдентификаторКоманды = "ЗапуститьФоновоеЗадание" Тогда
		ПараметрыКоманды.Результат = ЗапуститьФоновоеЗадание(ПараметрыКоманды.ИмяМетода, ПараметрыКоманды.Параметры, ПараметрыКоманды.КлючЗадания, ПараметрыКоманды.НаименованиеЗадания);
	КонецЕсли; 

КонецПроцедуры

// Обертка для ВыполнитьКомандуНаСервере
Процедура ВыполнитьКоманду(ИдентификаторКоманды, ПараметрыКоманды) Экспорт
	
	ВыполнитьКомандуНаСервере(ИдентификаторКоманды, ПараметрыКоманды);

КонецПроцедуры

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
	//Если Истина
	//	И ирКэш.ЛиПортативныйРежимЛкс()
	//	И ирПортативный.ЛиСерверныйМодульДоступенЛкс()
	//Тогда
	//	ирПортативный.ВыполнитьСерверныйМетодЛкс("ВыполнитьАлгоритм", _АлгоритмОбъект);
	//Иначе
		Выполнить(_ТекстДляВыполнения);
	//КонецЕсли; 
	Возврат Результат;
	
КонецФункции // ПозиционныйМетод()

Функция ВыполнитьАлгоритмЧерезВнешнююОбработкуЛкс(ИмяФайлаВнешнейОбработки, СтруктураПараметров, выхВремяНачала = Неопределено, ВерсияАлгоритма = Неопределено) Экспорт 
	
	ВнешняяОбработка = ВнешниеОбработки.Создать(ИмяФайлаВнешнейОбработки, Ложь);
	ОбщиеМодули = ПолучитьСтруктуруОсновныхОбщихМодулейЛкс();
	//выхВремяНачала = ПолучитьТекущееВремяВМиллисекундахЛкс();
	Попытка
		выхВремяНачала = Вычислить("ТекущаяУниверсальнаяДатаВМиллисекундах()");
	Исключение
	КонецПопытки;
	Если ВерсияАлгоритма <> Неопределено И ВнешняяОбработка.ВерсияАлгоритма() <> ВерсияАлгоритма Тогда
		Сообщить("Внешняя обработка не обновилась в кэше рабочего процесса 1С. Для ее обновления рекомендуется выполнить перезапуск рабочего процесса.", СтатусСообщения.Внимание);
	КонецЕсли; 
	ВнешняяОбработка.мМетод(СтруктураПараметров, ОбщиеМодули);
	//Возврат Результат;
	
КонецФункции

Функция ПолучитьСтруктуруОсновныхОбщихМодулейЛкс() 
	
	ОбщиеМодули = Новый Структура;
	ОбщиеМодули.Вставить("ирОбщий", Неопределено);
	ОбщиеМодули.Вставить("ирКэш", Неопределено);
	ОбщиеМодули.Вставить("ирСервер", Неопределено);
	Возврат ОбщиеМодули;

КонецФункции // ВыполнитьЛокально()

Функция ЛиПортативныйРежимЛкс()
	Возврат Ложь;
КонецФункции

Функция ИнфоСервераПриложений()
	СистемнаяИнформация = Новый СистемнаяИнформация;
	ИнфоСервера = "Сервер. ОС: " + СистемнаяИнформация.ТипПлатформы + " " + СистемнаяИнформация.ВерсияОС;
	Возврат ИнфоСервера;
КонецФункции

Функция ЗапуститьФоновоеЗадание(Знач ИмяМетода, Знач Параметры = Неопределено, Знач КлючЗадания = Неопределено, Знач НаименованиеЗадания = "")
	ФоновоеЗадание = ФоновыеЗадания.Выполнить(ИмяМетода, Параметры, КлючЗадания, НаименованиеЗадания);
	Возврат ФоновоеЗадание.УникальныйИдентификатор;
КонецФункции

// Записывает объект с параметризованным контекстом (клиент/сервер).
// Обеспечивает запись объекта с попытками. Позволяет обойти неинтенсивные дедлоки и превышения ожиданий блокировки.
// Также обеспечивает обход оптимистичных объектных блокировок в случае, если в БД пишутся точно те же данные объекта, что и актуальные.
// Эффективно для многопоточной записи объектов.
Процедура ЗаписатьОбъектЛкс(Объект, НаСервере = Ложь, РежимЗаписи = Неопределено, РежимПроведения = Неопределено, ОтключатьКонтрольЗаписи = Неопределено,
	БезАвторегистрацииИзменений = Неопределено, ПривилегированныйРежим = Неопределено) Экспорт 
	
	//Если НаСервере Тогда
	//	ДополнительныеСвойства = СериализоватьДополнительныеСвойстваОбъектаЛкс(Объект);
	//	ОбъектXML = СохранитьОбъектВВидеСтрокиXMLЛкс(Объект);
	//	ЗаписатьОбъектXMLЛкс(ОбъектXML, ДополнительныеСвойства, РежимЗаписи, ОтключатьКонтрольЗаписи, БезАвторегистрацииИзменений);
	//	Объект = ВосстановитьОбъектИзСтрокиXMLЛкс(ОбъектXML);
	//Иначе
		Если ПривилегированныйРежим = Истина Тогда
			УстановитьПривилегированныйРежим(Истина);
		КонецЕсли; 
		Если ТипЗнч(Объект) <> Тип("УдалениеОбъекта") Тогда
			НаборЗаписейПослеЗагрузкиИзТаблицыЗначенийЛкс(Объект);
		КонецЕсли; 
		НачалоПопыток = ТекущаяДата();
		// Для обхода дедлоков и оптимистичной объектной блокировки при высокой параллельности
		Если РежимЗаписи = Неопределено Тогда
			ПопытокЗаписиОбъекта = 5; 
		Иначе
			ПопытокЗаписиОбъекта = 3; 
		КонецЕсли; 
		ПредельнаяДлительность = 20;
		Для СчетчикПопыток = 1 По ПопытокЗаписиОбъекта Цикл
			УстановитьПараметрыЗаписиОбъектаЛкс(Объект, ОтключатьКонтрольЗаписи, БезАвторегистрацииИзменений);
			Попытка
				Если РежимЗаписи = Неопределено Тогда
					Объект.Записать();
				ИначеЕсли РежимЗаписи = "ПометкаУдаления" Тогда
					Объект.Записать();
					Объект.ОбменДанными.Загрузка = Ложь;
					Объект.УстановитьПометкуУдаления(Не Объект.ПометкаУдаления);
				ИначеЕсли Истина
					И ТипЗнч(РежимЗаписи) = Тип("РежимЗаписиДокумента") 
					И РежимЗаписи <> РежимЗаписиДокумента.Запись
				Тогда
					Объект.ОбменДанными.Загрузка = Ложь;
					Объект.Записать(РежимЗаписи, РежимПроведения);
				Иначе
					Объект.Записать(РежимЗаписи);
				КонецЕсли; 
				Прервать;
			Исключение
				НужноВызватьИсключение = Истина;
				ОписаниеОшибки = ОписаниеОшибки();
				НовоеОписаниеОшибки = "";
				Если ТранзакцияАктивна() Тогда 
					//НовоеОписаниеОшибки = "Транзакция активна" + Символы.ПС + ОписаниеОшибки;
				Иначе
					НОписаниеОшибки = НРег(ОписаниеОшибки);
					Если Истина
						И РежимЗаписи = Неопределено
						И (Ложь
							Или Найти(НОписаниеОшибки, "несоответствия версии или отсутствия записи базы данных") > 0
							Или Найти(НОписаниеОшибки, "version mismatch or lack of database record") > 0)
					Тогда
						НужноВызватьИсключение = Ложь;
						ТекущийXML = СохранитьОбъектВВидеСтрокиXMLЛкс(Объект, Ложь);
						//Объект.Прочитать(); // Чтение с блокировкой нам не нужно
						ОбъектДляСравнения = ПеречитатьОбъектЗапросомЛкс(Объект);
						Если Объект <> Неопределено Тогда
							НовыйXML = СохранитьОбъектВВидеСтрокиXMLЛкс(ОбъектДляСравнения, Ложь);
							Если ТекущийXML = НовыйXML Тогда
								Прервать;
							Иначе
								Попытка
									лРежимЗагрузка = Объект.ОбменДанными.Загрузка;
								Исключение
									лРежимЗагрузка = Неопределено;
								КонецПопытки;
								ПолноеИмяМД = Объект.Метаданные().ПолноеИмя();
								Если лРежимЗагрузка = Истина И СчетчикПопыток = 2 Тогда
									Сообщить("Возможно в обработчиках ПередЗаписью объекта " + ПолноеИмяМД + " в режиме Загрузка выполняется его нестабильная модификация");
								КонецЕсли; 
								НужноВызватьИсключение = СчетчикПопыток = ПопытокЗаписиОбъекта;
								Если НужноВызватьИсключение Тогда
									НовоеОписаниеОшибки = "Обход оптимистичной блокировки объекта " + ПолноеИмяМД + " отменен из-за его нестабильной модификации в обработчиках ПередЗаписью (Загрузка=" 
										+ XMLСтрока(лРежимЗагрузка) + ")" + Символы.ПС + ОписаниеОшибки;
								КонецЕсли;
							КонецЕсли; 
						КонецЕсли; 
					ИначеЕсли Ложь
						Или Найти(ОписаниеОшибки, "взаимоблокировк") > 0
						Или Найти(ОписаниеОшибки, "deadlock") > 0
					Тогда
						НужноВызватьИсключение = Ложь;
					КонецЕсли; 
				КонецЕсли; 
				Если Не НужноВызватьИсключение Тогда
					Если СчетчикПопыток = ПопытокЗаписиОбъекта Тогда 
						//НовоеОписаниеОшибки = "Кончились попытки записи" + Символы.ПС + ОписаниеОшибки;
						НужноВызватьИсключение = Истина;
					ИначеЕсли ТекущаяДата() - НачалоПопыток >= ПредельнаяДлительность Тогда
						//НовоеОписаниеОшибки = "Кончилось время записи" + Символы.ПС + ОписаниеОшибки;
						НужноВызватьИсключение = Истина;
					ИначеЕсли СчетчикПопыток = ПопытокЗаписиОбъекта Тогда 
						//НовоеОписаниеОшибки = "Кончились попытки записи" + Символы.ПС + ОписаниеОшибки;
						НужноВызватьИсключение = Истина;
					КонецЕсли; 
				КонецЕсли;
				Если НужноВызватьИсключение Тогда
					СостояниеОбъекта = ПолучитьПредставлениеДопСвойствОбъектаЛкс(Объект);
					Если ЗначениеЗаполнено(СостояниеОбъекта) Тогда
						Если ЗначениеЗаполнено(НовоеОписаниеОшибки) Тогда
							НовоеОписаниеОшибки = НовоеОписаниеОшибки + СостояниеОбъекта;
						Иначе
							НовоеОписаниеОшибки = ОписаниеОшибки + СостояниеОбъекта;
						КонецЕсли; 
					КонецЕсли; 
					Если ЗначениеЗаполнено(НовоеОписаниеОшибки) Тогда
						ВызватьИсключение НовоеОписаниеОшибки;
					Иначе
						ВызватьИсключение;
					КонецЕсли; 
				КонецЕсли; 
			КонецПопытки; 
		КонецЦикла;
	//КонецЕсли; 
	
КонецПроцедуры

Процедура УдалитьОбъектЛкс(Знач Объект, Знач НаСервере = Неопределено, Знач ОтключатьКонтрольЗаписи = Неопределено, Знач БезАвторегистрацииИзменений = Неопределено,
	ПривилегированныйРежим = Неопределено) Экспорт 
	
	УстановитьПараметрыЗаписиОбъектаЛкс(Объект, ОтключатьКонтрольЗаписи, БезАвторегистрацииИзменений);
	Если ПривилегированныйРежим Тогда
		УстановитьПривилегированныйРежим(Истина);
	КонецЕсли; 
	Объект.Удалить();
	
КонецПроцедуры

Функция ПолучитьПредставлениеДопСвойствОбъектаЛкс(Объект)
	
	Попытка
		ДополнительныеСвойства = Объект.ДополнительныеСвойства;
	Исключение
		ДополнительныеСвойства = Новый Структура;
	КонецПопытки;
	СостояниеОбъекта = "";
	Для Каждого КлючИЗначение Из ДополнительныеСвойства Цикл
		СостояниеОбъекта = СостояниеОбъекта + Символы.ПС + КлючИЗначение.Ключ + ": " + КлючИЗначение.Значение;
	КонецЦикла;
	Возврат СостояниеОбъекта;

КонецФункции

Процедура УстановитьПометкуУдаленияОбъектаЛкс(ХМЛ, СтруктураДополнительныхСвойств, ЗначениеПометки = Истина) Экспорт 
	
	Объект = ВосстановитьОбъектИзСтрокиXMLЛкс(ХМЛ);
	Объект.Прочитать(); // Иначе объект будет модифицирован и возникнет ошибка
	ВосстановитьДополнительныеСвойстваОбъектаЛкс(Объект, СтруктураДополнительныхСвойств);
	//Если РежимЗаписи = Неопределено Тогда
	//	Объект.УстановитьПометкуУдаления(ЗначениеПометки);
	//Иначе
		Объект.УстановитьПометкуУдаления(ЗначениеПометки);
	//КонецЕсли; 
	
КонецПроцедуры

// Позволяет перечитать объект грязным чтением, т.е. без учета блокировок. Не перечитывает свойство ВерсияДанных! 
// На выходе объект имеет модифицированноть. Для удаленного объекта возвращает Неопределено.
Функция ПеречитатьОбъектЗапросомЛкс(Знач Объект) Экспорт 
	
	ОбъектМД = Объект.Метаданные();
	Запрос = Новый Запрос; 
	Запрос.Текст = "ВЫБРАТЬ * ИЗ " + ОбъектМД.ПолноеИмя() + " КАК Т ГДЕ Т.Ссылка = &Ссылка";
	Запрос.УстановитьПараметр("Ссылка", Объект.Ссылка);
	ТаблицаОбъекта = Запрос.Выполнить().Выгрузить();
	Если ТаблицаОбъекта.Количество() > 0 Тогда
		СтрокаДанных = ТаблицаОбъекта[0];
		Для Каждого КолонкаТаблицы Из ТаблицаОбъекта.Колонки Цикл
			ЗначениеРеквизита = СтрокаДанных[КолонкаТаблицы.Имя];
			Если ЗначениеРеквизита = Null Тогда
				// Реквизит (но не табличная часть) недоступен по признаку ЭтоГруппа. Если к нему обратиться у объекта, то будет ошибка "Ошибка установки значения свойства '...': Реквизит недоступен для группы"
				Продолжить;
			КонецЕсли; 
			Пустышка = Объект[КолонкаТаблицы.Имя]; // Проверяем корректность вычисления выражения перед его использованием в попытке
			Если КолонкаТаблицы.ТипЗначения.СодержитТип(Тип("ТаблицаЗначений")) Тогда
				Попытка
					Объект[КолонкаТаблицы.Имя].Загрузить(ЗначениеРеквизита);
				Исключение
					// Табличная часть недоступна по признаку ЭтоГруппа. Выдается ошибка "Ошибка при вызове метода контекста (Загрузить): Объект недоступен для изменения"
				КонецПопытки;
			Иначе
				Попытка
					Объект[КолонкаТаблицы.Имя] = ЗначениеРеквизита;
				Исключение
					// Реквизит предназначен только для чтения
				КонецПопытки;
			КонецЕсли; 
		КонецЦикла;
	Иначе
		Объект = Неопределено;
	КонецЕсли;
	Возврат Объект;
	
КонецФункции

Процедура УстановитьПараметрыЗаписиОбъектаЛкс(Знач Объект, ОтключатьКонтрольЗаписи = Неопределено, БезАвторегистрацииИзменений = Неопределено) Экспорт
	
	Попытка
		ОбменДанными = Объект.ОбменДанными;
	Исключение
		// Элемент плана обмена в 8.3.4-
		ОбменДанными = Неопределено;
	КонецПопытки;  
	Если ОбменДанными <> Неопределено Тогда
		Если ОтключатьКонтрольЗаписи <> Неопределено Тогда
			ОбменДанными.Загрузка = ОтключатьКонтрольЗаписи;
		КонецЕсли; 
		Если БезАвторегистрацииИзменений <> Неопределено Тогда
			Попытка
				Получатели = ОбменДанными.Получатели;
			Исключение
				// Элемент плана обмена в 8.3.5+
				Получатели = Неопределено;
			КонецПопытки; 
			Если Получатели <> Неопределено Тогда
				Получатели.Автозаполнение = Не БезАвторегистрацииИзменений;
			КонецЕсли; 
		КонецЕсли; 
	КонецЕсли;
	
КонецПроцедуры

// Параметры:
//   Объект - 
//   ИспользоватьXDTO - 
//
Функция СохранитьОбъектВВидеСтрокиXMLЛкс(Знач Объект, Знач ИспользоватьXDTO = Истина, ИмяФайла = "") Экспорт
	
	Поток = Новый ЗаписьXML;
	Если ЗначениеЗаполнено(ИмяФайла) Тогда
		Поток.ОткрытьФайл(ИмяФайла);
	Иначе
		Поток.УстановитьСтроку();
	КонецЕсли; 
	Попытка
		Если ИспользоватьXDTO Тогда
			СериализаторXDTO.ЗаписатьXML(Поток, Объект);
		Иначе
			ЗаписатьXML(Поток, Объект);
		КонецЕсли;
	Исключение
		Поток.Закрыть();
		ВызватьИсключение;
	КонецПопытки; 
	Результат = Поток.Закрыть();
	Возврат Результат;
	
КонецФункции

// Копирует все элементы переданного массива, структуры, соответствия, списка значений или коллекции объектов метаданных
// в однотипную коллекцию приемник (для метаданных в массив). Если коллекция приемник не указана, она будет создана.
// Фиксированные коллекции превращаются в нефиксированные.
//
// Параметры:
//  КоллекцияИсходная - Массив, Структура, Соответствие, СписокЗначений, КоллекцияОбъектовМетаданных - исходная коллекция;
//  КоллекцияПриемник - Массив, Структура, Соответствие, СписокЗначений, КоллекцияОбъектовМетаданных, *Неопределено - коллекция приемник.
//
// Возвращаемое значение:
//  КоллекцияПриемник - Массив, Структура, Соответствие, СписокЗначений, КоллекцияОбъектовМетаданных - коллекция приемник.
//
Функция СкопироватьУниверсальнуюКоллекциюЛкс(КоллекцияИсходная, КоллекцияПриемник = Неопределено) Экспорт
	
	ТипКоллекции = ТипЗнч(КоллекцияИсходная);
	Если Ложь
		Или ТипКоллекции = Тип("Массив")
		Или ТипКоллекции = Тип("ФиксированныйМассив")
		#Если Не ТонкийКлиент И Не ВебКлиент Тогда
		Или ТипКоллекции = Тип("КоллекцияОбъектовМетаданных")
		#КонецЕсли 
	Тогда
		Если КоллекцияПриемник = Неопределено Тогда
			КоллекцияПриемник = Новый Массив;
		КонецЕсли;
		Для Каждого Элемент Из КоллекцияИсходная Цикл
			КоллекцияПриемник.Добавить(Элемент);
		КонецЦикла;
		Возврат КоллекцияПриемник;
		
	ИначеЕсли Ложь
		Или ТипКоллекции = Тип("Структура") 
		Или ТипКоллекции = Тип("ФиксированнаяСтруктура")
	Тогда
		Если КоллекцияПриемник = Неопределено Тогда
			КоллекцияПриемник = Новый Структура;
		КонецЕсли;
		Для Каждого Элемент Из КоллекцияИсходная Цикл
			КоллекцияПриемник.Вставить(Элемент.Ключ, Элемент.Значение);
		КонецЦикла;
		Возврат КоллекцияПриемник; 
		
	ИначеЕсли Ложь
		Или ТипКоллекции = Тип("Соответствие") 
		Или ТипКоллекции = Тип("ФиксированноеСоответствие")
	Тогда
		Если КоллекцияПриемник = Неопределено Тогда
			КоллекцияПриемник = Новый Соответствие;
		КонецЕсли;
		Для Каждого Элемент Из КоллекцияИсходная Цикл
			КоллекцияПриемник.Вставить(Элемент.Ключ, Элемент.Значение);
		КонецЦикла;
		Возврат КоллекцияПриемник;
		
	ИначеЕсли ТипКоллекции = Тип("СписокЗначений") Тогда
		Если КоллекцияПриемник = Неопределено Тогда
			КоллекцияПриемник = Новый СписокЗначений;
		КонецЕсли;
		Для Каждого Элемент Из КоллекцияИсходная Цикл
			ЗаполнитьЗначенияСвойств(КоллекцияПриемник.Добавить(), Элемент);
		КонецЦикла;
		Возврат КоллекцияПриемник;

	#Если Не ТонкийКлиент И Не ВебКлиент Тогда
	ИначеЕсли ТипКоллекции = Тип("ТаблицаЗначений") Тогда
		Если КоллекцияПриемник = Неопределено Тогда
			КоллекцияПриемник = КоллекцияИсходная.СкопироватьКолонки();
		КонецЕсли;
		ЗагрузитьВТаблицуЗначенийЛкс(КоллекцияИсходная, КоллекцияПриемник);
		Возврат КоллекцияПриемник;
	#КонецЕсли
	
	Иначе
		Сообщить("Неверный тип универсальной коллекции для копирования """ + ТипКоллекции + """");
		Возврат Неопределено;
		
	КонецЕсли;
	
КонецФункции // СкопироватьУниверсальнуюКоллекциюЛкс()

// Добавляет в таблицу значений строки из другой таблицы значений и 
// в них значения колонок с совпадающими наименованиями.
//
// Параметры:
//  ТаблицаИсточник - таблица значений, откуда берутся значения;
//  ТаблицаПриемник - таблица значений, куда добавляются строки;
//  *СтруктураЗначенийПоУмолчанию - Структура, *Неопределено - значения по умолчанию для добавляемых строк;
//  *СтруктураНовыхЗначений - Структура, *Неопределено - значения колонок для добавляемых строк, имеют высший приоритет.
//
Процедура ЗагрузитьВТаблицуЗначенийЛкс(ТаблицаИсточник, ТаблицаПриемник,
	СтруктураЗначенийПоУмолчанию = Неопределено, СтруктураНовыхЗначений = Неопределено) Экспорт

	СтрокаСовпадающихКолонок = "";
	Разделитель = ",";
	Если ТипЗнч(ТаблицаИсточник) = Тип("ТаблицаЗначений") Тогда
		КолонкиИсточника = ТаблицаИсточник.Колонки;
	Иначе
		КолонкиИсточника = Метаданные.НайтиПоТипу(ТипЗнч(ТаблицаИсточник)).Реквизиты;
	КонецЕсли; 
	ЛиПриемникТЧ = ТипЗнч(ТаблицаПриемник) <> Тип("ТаблицаЗначений");
	Если ЛиПриемникТЧ Тогда
		КолонкиПриемника = ТаблицаПриемник.ВыгрузитьКолонки().Колонки; 
	Иначе
		КолонкиПриемника = ТаблицаПриемник.Колонки;
	КонецЕсли; 
	
	Для каждого Колонка Из КолонкиПриемника Цикл
		Если СтруктураНовыхЗначений <> Неопределено Тогда
			Если СтруктураНовыхЗначений.Свойство(Колонка.Имя) Тогда
				Продолжить;
			КонецЕсли;
		КонецЕсли;
		Если Истина
			И (Ложь
				Или Не ЛиПриемникТЧ
				Или Колонка.Имя <> "НомерСтроки")
			И КолонкиИсточника.Найти(Колонка.Имя) <> Неопределено 
		Тогда
			СтрокаСовпадающихКолонок = СтрокаСовпадающихКолонок + Разделитель+ Колонка.Имя;
		КонецЕсли;
	КонецЦикла;
	СтрокаСовпадающихКолонок = Сред(СтрокаСовпадающихКолонок, СтрДлина(Разделитель) + 1);
	Для каждого СтрокаТаблицыИсточника Из ТаблицаИсточник Цикл
		СтрокаТаблицыПриемника = ТаблицаПриемник.Добавить();
		Если СтруктураЗначенийПоУмолчанию <> Неопределено Тогда
			ЗаполнитьЗначенияСвойств(СтрокаТаблицыПриемника, СтруктураЗначенийПоУмолчанию);
		КонецЕсли;
		// Заполним значения в совпадающих колонках.
		ЗаполнитьЗначенияСвойств(СтрокаТаблицыПриемника, СтрокаТаблицыИсточника, СтрокаСовпадающихКолонок);
		//Для каждого ЭлементМассива Из МассивСовпадающихКолонок Цикл
		//	СтрокаТаблицыПриемника[ЭлементМассива] = СтрокаТаблицыИсточника[ЭлементМассива];
		//КонецЦикла;
		Если СтруктураНовыхЗначений <> Неопределено Тогда
			ЗаполнитьЗначенияСвойств(СтрокаТаблицыПриемника, СтруктураНовыхЗначений);
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры // ЗагрузитьВТаблицуЗначенийЛкс()

Процедура ВосстановитьДополнительныеСвойстваОбъектаЛкс(Объект, СтруктураДополнительныхСвойств) Экспорт 
	
	Если СтруктураДополнительныхСвойств.Свойство("ОбменДанными") Тогда
		ОбменДанными = Объект.ОбменДанными;
		СтруктураОбменаДанными = СтруктураДополнительныхСвойств.ОбменДанными;
		ЗаполнитьЗначенияСвойств(ОбменДанными, СтруктураОбменаДанными);
		Если СтруктураОбменаДанными.Свойство("Получатели") Тогда
			ЗаполнитьЗначенияСвойств(ОбменДанными.Получатели, СтруктураОбменаДанными.Получатели);
			ОбменДанными.Получатели.Очистить();
			Для Каждого Получатель Из СтруктураОбменаДанными.Получатели.Узлы Цикл
				ОбменДанными.Получатели.Добавить(Получатель);
			КонецЦикла; 
		КонецЕсли; 
	КонецЕсли; 
	Если ТипЗнч(Объект) <> Тип("УдалениеОбъекта") Тогда
		ДополнительныеСвойства = ВосстановитьОбъектИзСтрокиXMLЛкс(СтруктураДополнительныхСвойств.ДополнительныеСвойстваXML);
		СкопироватьУниверсальнуюКоллекциюЛкс(ДополнительныеСвойства, Объект.ДополнительныеСвойства);
	КонецЕсли; 
	
КонецПроцедуры // ВосстановитьПараметрыОбменаДаннымиЛкс()

// Параметры:
//   XML - 
//   Тип - 
//   ИспользоватьXDTO - 
//   СообщатьОбОшибках - 
//
Функция ВосстановитьОбъектИзСтрокиXMLЛкс(Знач ФайлИлиXML = "", Знач Тип = "", Знач ИспользоватьXDTO = Истина, Знач СообщатьОбОшибках = Истина) Экспорт
	
	Если Ложь
		Или ТипЗнч(ФайлИлиXML) = Тип("Файл")
		Или ЗначениеЗаполнено(ФайлИлиXML) 
	Тогда
		ЧтениеXML = Новый ЧтениеXML;
		Если ТипЗнч(ФайлИлиXML) = Тип("Файл") Тогда
			ЧтениеXML.ОткрытьФайл(ФайлИлиXML);
		Иначе
			ЧтениеXML.УстановитьСтроку(ФайлИлиXML);
		КонецЕсли; 
		Попытка
			Если ИспользоватьXDTO Тогда
				Результат = СериализаторXDTO.ПрочитатьXML(ЧтениеXML);
			Иначе
				Результат = ПрочитатьXML(ЧтениеXML);
			КонецЕсли;
		Исключение
			Если СообщатьОбОшибках Тогда
				Сообщить(ОписаниеОшибки(), СтатусСообщения.Важное);
			КонецЕсли;
			ЧтениеXML.Закрыть();
		КонецПопытки;
		
		// Антибаг платформы 8.2-8.3.6 СериализаторXDTO некорректно восстанавливает пустую табличную часть поверх непустой https://partners.v8.1c.ru/forum/t/1329468/m/1329468
		Попытка
			Пустышка = Результат.Модифицированность();
			МетаТЧи = Результат.Метаданные().ТабличныеЧасти;
		Исключение
			МетаТЧи = Новый Массив;
		КонецПопытки; 
		Для Каждого МетаТЧ Из МетаТЧи Цикл
			ТЧ = Результат[МетаТЧ.Имя];
			Если ТЧ.Количество() = 0 Тогда 
				Попытка
					ТЧ.Вставить(0);
				Исключение
					// Недоступна по разделению группа/элемент с неадекватной ошибкой https://partners.v8.1c.ru/forum/t/1374212/m/1374212
					Продолжить;
				КонецПопытки; 
				ТЧ.Удалить(0);
			КонецЕсли; 
		КонецЦикла; 
	КонецЕсли;
	Если Результат = Неопределено Тогда
		Если ЗначениеЗаполнено(Тип) Тогда
			Результат = Новый (Тип);
		КонецЕсли; 
	КонецЕсли;
	Возврат Результат;
	
КонецФункции

Процедура ЗаписатьОбъектXMLЛкс(СтрокаХМЛ, ДополнительныеСвойства, РежимЗаписи = Неопределено, ОтключатьКонтрольЗаписи = Неопределено, БезАвторегистрацииИзменений = Неопределено,
	ПривилегированныйРежим = Неопределено) Экспорт 
	
	Объект = ВосстановитьОбъектИзСтрокиXMLЛкс(СтрокаХМЛ);
	ВосстановитьДополнительныеСвойстваОбъектаЛкс(Объект, ДополнительныеСвойства);
	ЗаписатьОбъектЛкс(Объект, Ложь, РежимЗаписи, , ОтключатьКонтрольЗаписи, БезАвторегистрацииИзменений, ПривилегированныйРежим);
	СтрокаХМЛ = СохранитьОбъектВВидеСтрокиXMLЛкс(Объект);
	
КонецПроцедуры

Процедура УдалитьОбъектXMLЛкс(СтрокаХМЛ, ДополнительныеСвойства, ОтключатьКонтрольЗаписи = Неопределено, БезАвторегистрацииИзменений = Неопределено,
	ПривилегированныйРежим = Неопределено) Экспорт 
	
	Объект = ВосстановитьОбъектИзСтрокиXMLЛкс(СтрокаХМЛ);
	ВосстановитьДополнительныеСвойстваОбъектаЛкс(Объект, ДополнительныеСвойства);
	Объект.Прочитать();
	УдалитьОбъектЛкс(Объект, Ложь, ОтключатьКонтрольЗаписи, БезАвторегистрацииИзменений, ПривилегированныйРежим);
	СтрокаХМЛ = СохранитьОбъектВВидеСтрокиXMLЛкс(Объект);
	
КонецПроцедуры

// Антибаг платформы https://partners.v8.1c.ru/forum/topic/1168440
Процедура НаборЗаписейПослеЗагрузкиИзТаблицыЗначенийЛкс(Знач НаборЗаписей) Экспорт 
	
	#Если Сервер И Не Сервер Тогда
	    НаборЗаписей = РегистрыБухгалтерии.Хозрасчетный.СоздатьНаборЗаписей();
	#КонецЕсли
	Данные = НаборЗаписей;
	ОбъектМД = НаборЗаписей.Метаданные();
	КорневойТип = ПолучитьПервыйФрагментЛкс(ОбъектМД.ПолноеИмя());
	Если КорневойТип = "РегистрБухгалтерии" Тогда
		Для Каждого Проводка Из Данные Цикл
			ОчиститьПоляРегистраБухгалтерииПоПризнакамУчетаЛкс(Проводка, ОбъектМД.Ресурсы, ОбъектМД);
			ОчиститьПоляРегистраБухгалтерииПоПризнакамУчетаЛкс(Проводка, ОбъектМД.Измерения, ОбъектМД);
		КонецЦикла;
	КонецЕсли; 
	
КонецПроцедуры

Процедура ОчиститьПоляРегистраБухгалтерииПоПризнакамУчетаЛкс(Проводка, КоллекцияПолей, ОбъектМД) Экспорт 
	
	#Если Сервер И Не Сервер Тогда
	    Проводка = РегистрыБухгалтерии.Хозрасчетный.СоздатьНаборЗаписей().Добавить();
		ОбъектМД = Метаданные.РегистрыБухгалтерии.Хозрасчетный;
	#КонецЕсли
	Для Каждого Поле Из КоллекцияПолей Цикл
		Если Истина 
			И Не Поле.Балансовый
			И Поле.ПризнакУчета <> Неопределено 
		Тогда
			ИмяПризнакаУчета = Поле.ПризнакУчета.Имя;
			Если ОбъектМД.Корреспонденция Тогда
				Если Не Проводка.СчетДт[ИмяПризнакаУчета] Тогда
					ПрисвоитьЕслиНеРавноЛкс(Проводка[Поле.Имя + "Дт"], Неопределено);
				КонецЕсли;
				Если Не Проводка.СчетКт[ИмяПризнакаУчета] Тогда
					ПрисвоитьЕслиНеРавноЛкс(Проводка[Поле.Имя + "Кт"], Неопределено);
				КонецЕсли;
			Иначе
				Если Не Проводка.Счет[ИмяПризнакаУчета] Тогда
					ПрисвоитьЕслиНеРавноЛкс(Проводка[Поле.Имя], Неопределено);
				КонецЕсли;
			КонецЕсли; 
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

// Присваивает первому параметру второй в случае их неравенства.
// Удобно использовать для избежания установки признака модифицированности
// объекта в случае присвоения реквизиту объекта его же значения.
//
// Параметры:
//  Переменная   – Произвольный – переменная, которой нужно присвоить значение;
//  Значение     – Произвольный – присваиваемое значение;
//
// Возвращаемое значение:
//  Переменная   – Произвольный - конечное значение переменной.
//
Функция ПрисвоитьЕслиНеРавноЛкс(Переменная, Значение, Модифицированность = Неопределено) Экспорт
	
	Если Переменная <> Значение Тогда
		Переменная = Значение;
		Модифицированность = Истина;
	КонецЕсли;
	Возврат Переменная;
	
КонецФункции

// Получает первый фрагмент, отделяемый разделителем от строки.
// Написана для оптимизации по скорости.
// 
// Параметры:
//  пСтрока      - Строка - которую разбиваем;
//  *пРазделитель - Строка, "." - символ-разделитель;
//  *пЛиИспользоватьГраницуЕслиМаркерНеНайден - Булево, *Истина.
//
// Возвращаемое значение:
//               - Строка - первый фрагмент строки;
//  Неопределено - в строке не обнаружен разделитель.
//
Функция ПолучитьПервыйФрагментЛкс(пСтрока, Разделитель = ".", ЛиИспользоватьГраницуЕслиМаркерНеНайден = Истина) Экспорт

	Позиция = Найти(пСтрока, Разделитель);
	Если Позиция > 0 Тогда
		Возврат Лев(пСтрока, Позиция - 1);
	Иначе
		Если ЛиИспользоватьГраницуЕслиМаркерНеНайден Тогда 
			Возврат пСтрока;
		Иначе
			Возврат "";
		КонецЕсли;
	КонецЕсли;

КонецФункции // ПолучитьПервыйФрагментЛкс()
