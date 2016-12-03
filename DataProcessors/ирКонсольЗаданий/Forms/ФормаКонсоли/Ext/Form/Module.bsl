﻿////////////////////////////////////////////////////////////////////////////////
// Переменные
//

// Соответствие по ключу идентификатор регламентного задания
Перем РегламентныеЗаданияСоответствие;
// Соответствие по ключу идентификатор фонового задания
Перем ФоновыеЗаданияСоответствие;
// Признак блокировки обновления фоновых и регламентных заданий при открытии модальных диалогов
Перем БлокироватьОбновление;
Перем ТаблицаАктивныхФоновыхЗаданий;

////////////////////////////////////////////////////////////////////////////////
// Процедуры и функции
//

Функция ПолучитьДлительностьВыполнения(ФоновоеЗадание)
	#Если _ Тогда
		ФоновоеЗадание = ФоновыеЗадания.НайтиПоУникальномуИдентификатору();
	#КонецЕсли
	Если Не ЗначениеЗаполнено(ФоновоеЗадание.Конец) Тогда
		Длительность = ТекущаяДата() - ФоновоеЗадание.Начало;
	Иначе
		Длительность = ФоновоеЗадание.Конец - ФоновоеЗадание.Начало;
	КонецЕсли; 
	Возврат Длительность;
	
КонецФункции

Процедура ОбновитьАктивныеФоновыеЗадания()
	
	Сеансы = ПолучитьСеансыИнформационнойБазы();
	ТаблицаСеансовФоновыхЗаданий = Новый ТаблицаЗначений;
	ТаблицаСеансовФоновыхЗаданий.Колонки.Добавить("НомерСеанса");
	ТаблицаСеансовФоновыхЗаданий.Колонки.Добавить("НомерСоединения");
	ТаблицаСеансовФоновыхЗаданий.Колонки.Добавить("НачалоСеанса", Новый ОписаниеТипов("Дата"));
	ТаблицаСеансовФоновыхЗаданий.Индексы.Добавить("НачалоСеанса");
	Для Каждого Сеанс Из Сеансы Цикл
		Если ирОбщий.СтрокиРавныЛкс(Сеанс.ИмяПриложения, "BackgroundJob") Тогда
			СтрокаСеанса = ТаблицаСеансовФоновыхЗаданий.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаСеанса, Сеанс);
		КонецЕсли; 
	КонецЦикла;
	ПостроительСеансов = Новый ПостроительЗапроса;
	ПостроительСеансов.ИсточникДанных = Новый ОписаниеИсточникаДанных(ТаблицаСеансовФоновыхЗаданий);
	ПостроительСеансов.Порядок.Установить("НачалоСеанса");
	ЭлементОтбораНачалаСеанса = ПостроительСеансов.Отбор.Добавить("НачалоСеанса");
	ЭлементОтбораНачалаСеанса.Использование = Истина;
	ЭлементОтбораНачалаСеанса.ВидСравнения = ВидСравнения.ИнтервалВключаяГраницы;
	АктивныеФоновыеЗадания = ФоновыеЗадания.ПолучитьФоновыеЗадания(Новый Структура("Состояние", СостояниеФоновогоЗадания.Активно));
	ТаблицаАктивныхФоновыхЗаданий = Новый ТаблицаЗначений;
	ТаблицаАктивныхФоновыхЗаданий.Колонки.Добавить("Идентификатор");
	ТаблицаАктивныхФоновыхЗаданий.Колонки.Добавить("Начало", Новый ОписаниеТипов("Дата"));
	ТаблицаАктивныхФоновыхЗаданий.Колонки.Добавить("НомерСеанса");
	ТаблицаАктивныхФоновыхЗаданий.Колонки.Добавить("НомерСоединения");
	Для Каждого АктивноеФоновоеЗадание Из АктивныеФоновыеЗадания Цикл
		СтрокаАктивногоЗадания = ТаблицаАктивныхФоновыхЗаданий.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаАктивногоЗадания, АктивноеФоновоеЗадание); 
		СтрокаАктивногоЗадания.Идентификатор = АктивноеФоновоеЗадание.УникальныйИдентификатор;
	КонецЦикла;
	ТаблицаАктивныхФоновыхЗаданий.Сортировать("Начало");
	Для Каждого СтрокаАктивногоЗадания Из ТаблицаАктивныхФоновыхЗаданий Цикл
		ЭлементОтбораНачалаСеанса.ЗначениеС = СтрокаАктивногоЗадания.Начало;
		ЭлементОтбораНачалаСеанса.ЗначениеПо = СтрокаАктивногоЗадания.Начало + 3; // Размер допустимой задержки между началом сеанса и началом задания
		СеансыКандидаты = ПостроительСеансов.Результат.Выгрузить();
		Для Каждого СеансКандидат Из СеансыКандидаты Цикл
			ЗанятаяСтрока = ТаблицаАктивныхФоновыхЗаданий.Найти(СеансКандидат.НомерСеанса, "НомерСеанса");
			Если ЗанятаяСтрока = Неопределено Тогда
				СтрокаАктивногоЗадания.НомерСеанса = СеансКандидат.НомерСеанса;
				СтрокаАктивногоЗадания.НомерСоединения = СеансКандидат.НомерСоединения;
				Прервать;
			КонецЕсли; 
		КонецЦикла;
	КонецЦикла;

КонецПроцедуры

// Обновить список регламентных заданий
//
Процедура ОбновитьСписокРегламентныхЗаданий()
	Перем ТекущийИдентификатор;
	
	Если БлокироватьОбновление Тогда
		Возврат;
	КонецЕсли;
	
	ТекущаяСтрока = ЭлементыФормы.СписокРегламентныхЗаданий.ТекущаяСтрока;
	Если ТекущаяСтрока <> Неопределено Тогда
		ТекущийИдентификатор = ТекущаяСтрока.Идентификатор;
	КонецЕсли;
	
	Идентификаторы = Новый Массив;
	
	ВыделенныеСтроки = ЭлементыФормы.СписокРегламентныхЗаданий.ВыделенныеСтроки;
	Для Каждого ВыделеннаяСтрока из ВыделенныеСтроки Цикл
		Идентификаторы.Добавить(ВыделеннаяСтрока.Идентификатор);
	КонецЦикла;
	
	СписокРегламентныхЗаданий.Очистить();
	Отбор = Неопределено;
	Если ОтборРегламентныхЗаданийВключен = Истина Тогда
		Отбор = ОтборРегламентныхЗаданий;
	КонецЕсли;
	ЭлементыФормы.КоманднаяПанельРегламентныеЗадания.Кнопки.ОтключитьОтбор.Доступность = (ОтборРегламентныхЗаданийВключен = Истина);
	Регламентные = РегламентныеЗадания.ПолучитьРегламентныеЗадания(Отбор);
	РегламентныеЗаданияСоответствие.Очистить();
	ОбновитьАктивныеФоновыеЗадания();
	Для Каждого Регламентное из Регламентные Цикл
		НоваяСтрока = СписокРегламентныхЗаданий.Добавить();
		НоваяСтрока.Метаданные = Регламентное.Метаданные.Представление();
		НоваяСтрока.Наименование = Регламентное.Наименование;
		НоваяСтрока.Ключ = Регламентное.Ключ;
		НоваяСтрока.Расписание = Регламентное.Расписание;
		НоваяСтрока.Пользователь = Регламентное.ИмяПользователя;
		НоваяСтрока.Предопределенное = Регламентное.Предопределенное;
		НоваяСтрока.Использование = Регламентное.Использование;
		НоваяСтрока.Идентификатор = Регламентное.УникальныйИдентификатор;
		
		РегламентныеЗаданияСоответствие[Строка(Регламентное.УникальныйИдентификатор)] = Регламентное;
		
		ПоследнееЗадание = ПолучитьПоследнееЗаданиеРегламентногоЗадания(Регламентное);
		Если ПоследнееЗадание <> Неопределено Тогда
			НоваяСтрока.Выполнялось = ПоследнееЗадание.Начало;
			НоваяСтрока.Состояние = ПоследнееЗадание.Состояние;
			НоваяСтрока.СостояниеЗадания = ПоследнееЗадание.Состояние;
			НоваяСтрока.Длительность = ПолучитьДлительностьВыполнения(ПоследнееЗадание);
			Если ПоследнееЗадание.Состояние = СостояниеФоновогоЗадания.Активно Тогда
				СтрокаАктивногоФоновогоЗадания = ТаблицаАктивныхФоновыхЗаданий.Найти(ПоследнееЗадание.УникальныйИдентификатор, "Идентификатор");
				Если СтрокаАктивногоФоновогоЗадания <> Неопределено Тогда
					НоваяСтрока.НомерСеанса = СтрокаАктивногоФоновогоЗадания.НомерСеанса;
					НоваяСтрока.НомерСоединения = СтрокаАктивногоФоновогоЗадания.НомерСоединения;
				КонецЕсли; 
			КонецЕсли; 
		КонецЕсли; 
	КонецЦикла;
	СписокРегламентныхЗаданий.Сортировать("Метаданные, Наименование, Ключ");
	РазмерСпискаРегламентныхЗаданий = СписокРегламентныхЗаданий.Количество();
	СтрокапустогоРегламентногоЗадания = СписокРегламентныхЗаданий.Добавить();
	СтрокапустогоРегламентногоЗадания.Метаданные = "<Неопределено>";
	СтрокапустогоРегламентногоЗадания.Наименование = "<Для отбора фоновых заданий запущенных из кода>";
	СтрокапустогоРегламентногоЗадания.Предопределенное = Истина;
	СтрокапустогоРегламентногоЗадания.Использование = Ложь;
	
    Если ТекущийИдентификатор <> Неопределено Тогда
		Строка = СписокРегламентныхЗаданий.Найти(ТекущийИдентификатор, "Идентификатор");
		Если Строка <> Неопределено Тогда
			СтарыйОтборПоРегламентному = ОтборПоТекущемуРегламентномуЗаданию;
			ОтборПоТекущемуРегламентномуЗаданию = Ложь;
			ЭлементыФормы.СписокРегламентныхЗаданий.ТекущаяСтрока = Строка;
			ОтборПоТекущемуРегламентномуЗаданию = СтарыйОтборПоРегламентному;
		КонецЕсли;
	КонецЕсли;

	Если Идентификаторы.Количество() > 0 Тогда
		ВыделенныеСтроки.Очистить();
	КонецЕсли;
	
	Для Каждого Идентификатор из Идентификаторы Цикл
		Строка = СписокРегламентныхЗаданий.Найти(Идентификатор, "Идентификатор");
		Если Строка <> Неопределено Тогда
			ВыделенныеСтроки.Добавить(Строка);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

// Обновить список фоновых заданий
//
Процедура ОбновитьСписокФоновыхЗаданий(ВызовВнутриОбновленияРегламентныхЗаданий = Ложь)
	Перем ТекущийИдентификатор;
	
	Если БлокироватьОбновление Тогда
		Возврат;
	КонецЕсли;
	
	ТекущаяСтрока = ЭлементыФормы.СписокФоновыхЗаданий.ТекущаяСтрока;
	Если ТекущаяСтрока <> Неопределено Тогда
		ТекущийИдентификатор = ТекущаяСтрока.Идентификатор;
	КонецЕсли;
	
	Идентификаторы = Новый Массив;
	
	ВыделенныеСтроки = ЭлементыФормы.СписокФоновыхЗаданий.ВыделенныеСтроки;
	Для Каждого ВыделеннаяСтрока из ВыделенныеСтроки Цикл
		Идентификаторы.Добавить(ВыделеннаяСтрока.Идентификатор);
	КонецЦикла;
	
	СписокФоновыхЗаданий.Очистить();
	
	Отбор = Новый Структура;
	Если ОтборФоновыхЗаданийВключен = Истина Тогда
		Отбор = ОтборФоновыхЗаданий;
	КонецЕсли;
	ЭлементыФормы.КоманднаяПанельФоновыеЗадания.Кнопки.ОтключитьОтбор.Доступность = (ОтборФоновыхЗаданийВключен = Истина);
	
	ОтборПоПустомуРегламентномуЗаданию = Ложь;
	Если Не ирКэш.Получить().ЭтоФайловаяБаза Тогда
		КонечныйОтбор = ирОбщий.ПолучитьКопиюОбъектаЛкс(Отбор);
		РегламентноеЗадание = Неопределено;
		Если Истина
			И Отбор.Свойство("РегламентноеЗадание", РегламентноеЗадание) 
			И РегламентноеЗадание = Неопределено
		Тогда
			ОтборПоПустомуРегламентномуЗаданию = Истина;
			КонечныйОтбор.Удалить("РегламентноеЗадание");
		КонецЕсли; 
		Фоновые = ФоновыеЗадания.ПолучитьФоновыеЗадания(КонечныйОтбор);
	Иначе
		Фоновые = Новый Массив;
	КонецЕсли; 
	ФоновыеЗаданияСоответствие.Очистить();
	Если Не ВызовВнутриОбновленияРегламентныхЗаданий Тогда
		ОбновитьАктивныеФоновыеЗадания();
	КонецЕсли; 
	Индикатор = ирОбщий.ПолучитьИндикаторПроцессаЛкс(Фоновые.Количество(), "Чтение фоновых заданий");
	Для Каждого Фоновое из Фоновые Цикл
		#Если _ Тогда
		    Фоновое = ФоновыеЗадания.НайтиПоУникальномуИдентификатору();
		#КонецЕсли
		ирОбщий.ОбработатьИндикаторЛкс(Индикатор);
		РегламентноеЗадание = Фоновое.РегламентноеЗадание;
		Если Истина
			И ОтборПоПустомуРегламентномуЗаданию
			И РегламентноеЗадание <> Неопределено
		Тогда
			Продолжить;
		КонецЕсли; 
		Длительность = ПолучитьДлительностьВыполнения(Фоновое);
		Если Истина
			И Отбор.Свойство("ДлительностьМин") 
		Тогда
			Если Ложь
				Или Отбор.ДлительностьМин > Длительность
				Или (Истина
					И Отбор.ДлительностьМакс > 0
					И Отбор.ДлительностьМакс < Длительность)
			Тогда
				Продолжить;
			КонецЕсли; 
		КонецЕсли; 
		
		НоваяСтрока = СписокФоновыхЗаданий.Добавить();
		Если РегламентноеЗадание <> Неопределено Тогда
			Строка = РегламентноеЗадание.Метаданные.Представление();
			Если РегламентноеЗадание.Наименование <> "" Тогда
				Строка = Строка + ":" + РегламентноеЗадание.Наименование;
			КонецЕсли;
			НоваяСтрока.Регламентное = Строка;
		КонецЕсли;
			
		НоваяСтрока.Наименование = Фоновое.Наименование;
		НоваяСтрока.Ключ = Фоновое.Ключ;
		НоваяСтрока.Метод = Фоновое.ИмяМетода;
		НоваяСтрока.Состояние = Фоновое.Состояние;
		НоваяСтрока.Начало = Фоновое.Начало;
		НоваяСтрока.Конец = Фоновое.Конец;
		НоваяСтрока.Длительность = Длительность;
		НоваяСтрока.Сервер = Фоновое.Расположение;
		
		Если Фоновое.ИнформацияОбОшибке <> Неопределено Тогда
			НоваяСтрока.Ошибки = ПодробноеПредставлениеОшибки(Фоновое.ИнформацияОбОшибке);
		КонецЕсли;
		Если Фоновое.Состояние = СостояниеФоновогоЗадания.Активно Тогда
			СтрокаАктивногоФоновогоЗадания = ТаблицаАктивныхФоновыхЗаданий.Найти(Фоновое.УникальныйИдентификатор, "Идентификатор");
			Если СтрокаАктивногоФоновогоЗадания <> Неопределено Тогда
				НоваяСтрока.НомерСеанса = СтрокаАктивногоФоновогоЗадания.НомерСеанса;
				НоваяСтрока.НомерСоединения = СтрокаАктивногоФоновогоЗадания.НомерСоединения;
			КонецЕсли; 
		КонецЕсли; 
		Если ПолучатьСообщенияПользователю Тогда
			МассивСообщений = Фоновое.ПолучитьСообщенияПользователю();
			Если МассивСообщений <> Неопределено Тогда
				НоваяСтрока.СообщенияПользователю = МассивСообщений.Количество();
			КонецЕсли; 
		КонецЕсли; 
		НоваяСтрока.Идентификатор = Фоновое.УникальныйИдентификатор;
		НоваяСтрока.СостояниеЗадания = Фоновое.Состояние;
		
		ФоновыеЗаданияСоответствие[Строка(Фоновое.УникальныйИдентификатор)] = Фоновое;
	КонецЦикла;
	ирОбщий.ОсвободитьИндикаторПроцессаЛкс();
	РазмерСпискаФоновыхЗаданий = СписокФоновыхЗаданий.Количество();
	
	Если ТекущийИдентификатор <> Неопределено Тогда
		Строка = СписокФоновыхЗаданий.Найти(ТекущийИдентификатор, "Идентификатор");
		Если Строка <> Неопределено Тогда
			ЭлементыФормы.СписокФоновыхЗаданий.ТекущаяСтрока = Строка;
		КонецЕсли;
	КонецЕсли;
	
	Если Идентификаторы.Количество() > 0 Тогда
		ВыделенныеСтроки.Очистить();
	КонецЕсли;
		
	Для Каждого Идентификатор из Идентификаторы Цикл
		Строка = СписокФоновыхЗаданий.Найти(Идентификатор, "Идентификатор");
		Если Строка <> Неопределено Тогда
			ВыделенныеСтроки.Добавить(Строка);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Функция ПреобразоватьОтборДляСохраненияЗначения(СтарыйОтбор)
	
	Если СтарыйОтбор = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	НовыйОтбор = Новый Структура;
	Для Каждого Свойство Из СтарыйОтбор Цикл
		НовыйОтбор.Вставить(Свойство.Ключ, ?(Свойство.Ключ = "Метаданные", Свойство.Значение.Имя, Свойство.Значение));
	КонецЦикла;
	
	Возврат НовыйОтбор;
	
КонецФункции

Функция ПреобразоватьОтборПослеВосстановленияЗначений(СтарыйОтбор)
	
	Если СтарыйОтбор = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	НовыйОтбор = Новый Структура;
	Для Каждого Свойство Из СтарыйОтбор Цикл
		Если (Свойство.Ключ = "Метаданные") И (ТипЗнч(Свойство.Значение) = Тип("Строка")) Тогда
			НовыйОтбор.Вставить(Свойство.Ключ, Метаданные.РегламентныеЗадания[Свойство.Значение]);
		Иначе
			НовыйОтбор.Вставить(Свойство.Ключ, Свойство.Значение);
		КонецЕсли;
	КонецЦикла;
	
	Возврат НовыйОтбор;
	
КонецФункции


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ
//

Процедура ОбновитьРегламентныеНажатие(Кнопка)
	
	Попытка
		ОбновитьСписокРегламентныхЗаданий();
	Исключение
		Сообщить(ОписаниеОшибки());
	КонецПопытки;
	
КонецПроцедуры

Процедура РасписаниеНажатие(Кнопка)
	
	ВыделенныеСтроки = ЭлементыФормы.СписокРегламентныхЗаданий.ВыделенныеСтроки;
	Если ВыделенныеСтроки.Количество() > 0 Тогда
		
		БлокироватьОбновление = Истина;
		
		Строка = ВыделенныеСтроки.Получить(0);
		РегламентноеЗадание = РегламентныеЗаданияСоответствие.Получить(Строка.Идентификатор);
		Диалог = Новый ДиалогРасписанияРегламентногоЗадания(РегламентноеЗадание.Расписание);
		
		Если Диалог.ОткрытьМодально() Тогда
			РегламентноеЗадание.Расписание = Диалог.Расписание;
			РегламентноеЗадание.Записать();
			
			Строка.Расписание = РегламентноеЗадание.Расписание;
		КонецЕсли;
		
		БлокироватьОбновление = Ложь;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриОткрытии()
	
	Попытка
		ОтборФоновыхЗаданий = ВосстановитьЗначение("ФоновыеЗадания.Отбор");
		ОтборФоновыхЗаданийВключен = ВосстановитьЗначение("ФоновыеЗадания.ОтборВключен");
		ОтборРегламентныхЗаданий = ПреобразоватьОтборПослеВосстановленияЗначений(ВосстановитьЗначение("РегламентныеЗадания.Отбор"));
		ОтборРегламентныхЗаданийВключен = ВосстановитьЗначение("РегламентныеЗадания.ОтборВключен");
		
		ОтборПоТекущемуРегламентномуЗаданию = ВосстановитьЗначение("ФоновыеЗадания.ОтборПоТекущемуРегламентномуЗаданию");
		Если ОтборПоТекущемуРегламентномуЗаданию = Неопределено Тогда
			ОтборПоТекущемуРегламентномуЗаданию = Истина;
		КонецЕсли; 
		Кнопка = ЭлементыФормы.КоманднаяПанельФоновыеЗадания.Кнопки.ОтборПоТекущему;
		Кнопка.Пометка = ОтборПоТекущемуРегламентномуЗаданию;

		АвтообновлениеСпискаРегламентныхЗаданий = ВосстановитьЗначение("РегламентныеЗадания.АвтообновлениеСписка");
		ЭлементыФормы.КоманднаяПанельРегламентныеЗадания.Кнопки.НастройкаОбновления.Пометка = АвтообновлениеСпискаРегламентныхЗаданий;
		ПериодАвтообновленияСпискаРегламентныхЗаданий = ВосстановитьЗначение("РегламентныеЗадания.ПериодАвтообновленияСписка");
		
		АвтообновлениеСпискаФоновыхЗаданий = ВосстановитьЗначение("ФоновыеЗадания.АвтообновлениеСписка");
		ПериодАвтообновленияСпискаФоновыхЗаданий = ВосстановитьЗначение("ФоновыеЗадания.ПериодАвтообновленияСписка");
		ЭлементыФормы.КоманднаяПанельФоновыеЗадания.Кнопки.НастройкаОбновления.Пометка = АвтообновлениеСпискаФоновыхЗаданий;
		
		ПолучатьСообщенияПользователю = ВосстановитьЗначение("ФоновыеЗадания.ПолучатьСообщенияПользователю");
		ЭлементыФормы.КоманднаяПанельФоновыеЗадания.Кнопки.ПолучатьСообщенияПользователю.Пометка = ПолучатьСообщенияПользователю;
		Если АвтообновлениеСпискаРегламентныхЗаданий = Истина Тогда
			ПодключитьОбработчикОжидания("ОбновитьСписокРегламентныхЗаданий", ПериодАвтообновленияСпискаРегламентныхЗаданий);
		КонецЕсли;		
		
		Если АвтообновлениеСпискаФоновыхЗаданий = Истина Тогда
			ПодключитьОбработчикОжидания("ОбновитьФоновыеЗадания", ПериодАвтообновленияСпискаФоновыхЗаданий);
		КонецЕсли;		
		
		ОбновитьСписокРегламентныхЗаданий();
		Если Не ОтборПоТекущемуРегламентномуЗаданию Тогда
			ОбновитьСписокФоновыхЗаданий();
		КонецЕсли; 
	Исключение
		ПоказатьИнформациюОбОшибке(ИнформацияОбОшибке());
	КонецПопытки;
	//ЭлементыФормы.КоманднаяПанельРегламентныеЗадания.Кнопки.ПодменюВыполнить.Кнопки.ВыполнитьРегламентноеЗаданиеНаСервере.Доступность = ирКэш.Получить().ЭтоФайловаяБаза;
	ЭлементыФормы.КоманднаяПанельРегламентныеЗадания.Кнопки.ПодменюВыполнить.Кнопки.ВыполнитьРегламентноеЗаданиеВФоновомЗадании.Доступность = Не ирКэш.Получить().ЭтоФайловаяБаза;
	//ЭлементыФормы.ПанельФоновыеЗадания.Доступность = Не ирКэш.Получить().ЭтоФайловаяБаза;
	ЭлементыФормы.КоманднаяПанельРегламентныеЗадания.Кнопки.РаботатьДиспетчером.Доступность = ирКэш.ЭтоФайловаяБазаЛкс();
	ЭлементыФормы.КоманднаяПанельФоновыеЗадания.Кнопки.ОтладчикФоновыхЗаданий.Доступность = Не ирКэш.ЛиПортативныйРежимЛкс() Или ирКэш.ЭтоФайловаяБазаЛкс();
	
КонецПроцедуры

Процедура СписокРегламентныхЗаданийПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	ВыделенныеСтроки = ЭлементыФормы.СписокРегламентныхЗаданий.ВыделенныеСтроки;
	Ответ = Вопрос("Вы уверены, что хотите удалить " + ВыделенныеСтроки.Количество() + " регламентных заданий?", РежимДиалогаВопрос.ОКОтмена);
	Если Ответ <> КодВозвратаДиалога.ОК Тогда
		Возврат;
	КонецЕсли;
	 
	Для Каждого Строка из ВыделенныеСтроки Цикл
		РегламентноеЗадание = РегламентныеЗаданияСоответствие.Получить(Строка.Идентификатор);
		Если Не ЗначениеЗаполнено(Строка.Идентификатор) Тогда
			Продолжить;
		КонецЕсли; 
		Если РегламентноеЗадание.Предопределенное Тогда
			Сообщить("Нельзя удалить предопределенное регламентное задание: " + РегламентноеЗадание.Метаданные + "." + РегламентноеЗадание.Наименование,
				СтатусСообщения.Внимание);
		Иначе
			РегламентноеЗадание.Удалить();
		КонецЕсли;
	КонецЦикла;
	
	ОбновитьСписокРегламентныхЗаданий();
	
КонецПроцедуры

Процедура СписокРегламентныхЗаданийПередНачаломДобавления(Элемент, Отказ, Копирование)
	Отказ = Истина;
	Диалог = ОбработкаОбъект.ПолучитьФорму("ДиалогРегламентногоЗадания");
	Если Диалог.ОткрытьМодально() = Истина Тогда
		
		Строка = СписокРегламентныхЗаданий.Добавить();
		РегламентноеЗадание = Диалог.РегламентноеЗадание;
		
		Строка.Метаданные = РегламентноеЗадание.Метаданные.Представление();
		Строка.Предопределенное = РегламентноеЗадание.Предопределенное;
		Строка.Идентификатор = РегламентноеЗадание.УникальныйИдентификатор;
		
		Строка.Наименование = РегламентноеЗадание.Наименование;
		Строка.Ключ = РегламентноеЗадание.Ключ;
		Строка.Расписание = РегламентноеЗадание.Расписание;
		Строка.Пользователь = РегламентноеЗадание.ИмяПользователя;
		Строка.Предопределенное = РегламентноеЗадание.Предопределенное;
		Строка.Использование = РегламентноеЗадание.Использование;
		Строка.Идентификатор = РегламентноеЗадание.УникальныйИдентификатор;
		
		ПоследнееЗадание = ПолучитьПоследнееЗаданиеРегламентногоЗадания(РегламентноеЗадание);
		Если ПоследнееЗадание <> Неопределено Тогда
			Строка.Выполнялось = ПоследнееЗадание.Начало;
			Строка.Состояние = ПоследнееЗадание.Состояние;
		КонецЕсли;
		
		РегламентныеЗаданияСоответствие[Строка(РегламентноеЗадание.УникальныйИдентификатор)] = РегламентноеЗадание;
	КонецЕсли;
КонецПроцедуры

Функция ПолучитьПоследнееЗаданиеРегламентногоЗадания(РегламентноеЗадание)
	
	Если Не ирКэш.Получить().ЭтоФайловаяБаза Тогда // Антибаг платформы 8.2.15 http://partners.v8.1c.ru/forum/thread.jsp?id=1005239#1005239
		ПоследнееЗадание = РегламентноеЗадание.ПоследнееЗадание;
	КонецЕсли;
	Возврат ПоследнееЗадание;

КонецФункции

Процедура ОбновитьФоновыеЗадания()
	
	Попытка
		ОбновитьСписокФоновыхЗаданий(Ложь);
	Исключение
		Сообщить("Ошибка обновления списка фоновых заданий: " + ОписаниеОшибки());
	КонецПопытки;

КонецПроцедуры


Процедура ОбновитьФоновыеНажатие(Кнопка)
	
	ОбновитьФоновыеЗадания();
	
КонецПроцедуры

Процедура ОтменитьФоновоеНажатие(Кнопка)
	
	Отказ = Истина;
	Попытка
		ВыделенныеСтроки = ЭлементыФормы.СписокФоновыхЗаданий.ВыделенныеСтроки;
		Для Каждого Строка из ВыделенныеСтроки Цикл
			ФоновоеЗадание = ФоновыеЗаданияСоответствие.Получить(Строка.Идентификатор);
			ФоновоеЗадание.Отменить();
		КонецЦикла;
		
		ОбновитьСписокФоновыхЗаданий();
	Исключение	
		ПоказатьИнформациюОбОшибке(ИнформацияОбОшибке());
	КонецПопытки;
	
КонецПроцедуры

Процедура СписокФоновыхЗаданийПередНачаломДобавления(Элемент, Отказ, Копирование)
	
	Попытка
		ФоновыеЗадания.НайтиПоУникальномуИдентификатору(Новый УникальныйИдентификатор());
	Исключение
		ПоказатьИнформациюОбОшибке(ИнформацияОбОшибке());
		Возврат;
	КонецПопытки; 
	
	Отказ = Истина;
	БлокироватьОбновление = Истина;
	Попытка
		Диалог = ОбработкаОбъект.ПолучитьФорму("ДиалогФоновогоЗадания");
		мРегламентное = "";
		Если Копирование Тогда
			ТекущиеДанные = Элемент.ТекущиеДанные;
			
			Если ТекущиеДанные <> Неопределено Тогда 
				
				Диалог.ИмяМетода    = ТекущиеДанные.Метод;
				Диалог.Ключ         = ТекущиеДанные.Ключ;
				Диалог.Наименование = ТекущиеДанные.Наименование;
				
				ФоновоеЗадание = ФоновыеЗаданияСоответствие.Получить(ТекущиеДанные.Идентификатор);
				
				Если ФоновоеЗадание <> Неопределено Тогда
					
					РегламентноеЗадание = ФоновоеЗадание.РегламентноеЗадание;
					
					Если РегламентноеЗадание <> Неопределено Тогда	
						
						Диалог.мРегламентноеЗадание = РегламентноеЗадание;
						
					КонецЕсли;
					
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЕсли;
		Если Диалог.ОткрытьМодально() = Истина Тогда
			ОбновитьСписокФоновыхЗаданий();
		КонецЕсли;
	Исключение
		ПоказатьИнформациюОбОшибке(ИнформацияОбОшибке());
	КонецПопытки;	
	БлокироватьОбновление = Ложь;
	
КонецПроцедуры

Процедура СписокФоновыхЗаданийПередНачаломИзменения(Элемент, Отказ)
	Отказ = Истина;
КонецПроцедуры

Процедура СписокФоновыхЗаданийПередУдалением(Элемент, Отказ)
	Отказ = Истина;
КонецПроцедуры

Процедура ОтключитьОтборФоновыхЗаданий(Кнопка)
	
	ОтборФоновыхЗаданий = Неопределено;
	ФоновыеЗаданияУстановитьОтбор(Ложь);
	
КонецПроцедуры

Процедура ФоновыеЗаданияУстановитьОтбор(пОтборФоновыхЗаданийВключен = Истина) Экспорт
	
	ОтборФоновыхЗаданийВключен = пОтборФоновыхЗаданийВключен;
	СохранитьЗначение("ФоновыеЗадания.Отбор", ОтборФоновыхЗаданий);
	СохранитьЗначение("ФоновыеЗадания.ОтборВключен", ОтборФоновыхЗаданийВключен);
	СохранитьЗначение("ФоновыеЗадания.ОтборПоТекущемуРегламентномуЗаданию", ОтборПоТекущемуРегламентномуЗаданию);
	Если Не ОтборФоновыхЗаданийВключен Тогда
		ОтборПоТекущемуРегламентномуЗаданию = Ложь;
		ЭлементыФормы.КоманднаяПанельФоновыеЗадания.Кнопки.ОтборПоТекущему.Пометка = ОтборПоТекущемуРегламентномуЗаданию;
	КонецЕсли; 
	ОбновитьСписокФоновыхЗаданий();
	
КонецПроцедуры

Процедура РегламентныеЗаданияУстановитьОтбор(пОтборРегламентныхЗаданийВключен = Истина)
	
	ОтборРегламентныхЗаданийВключен = пОтборРегламентныхЗаданийВключен;
	СохранитьЗначение("РегламентныеЗадания.Отбор", ПреобразоватьОтборДляСохраненияЗначения(ОтборРегламентныхЗаданий));
	СохранитьЗначение("РегламентныеЗадания.ОтборВключен", ОтборРегламентныхЗаданийВключен);
	//Если Не ОтборФоновыхЗаданийВключен Тогда
	//	ОтборПоТекущемуРегламентномуЗаданию = Ложь;
	//	ЭлементыФормы.КоманднаяПанельФоновыеЗадания.Кнопки.ОтборПоТекущему.Пометка = ОтборПоТекущемуРегламентномуЗаданию;
	//КонецЕсли; 
	ОбновитьСписокРегламентныхЗаданий();
	
КонецПроцедуры

Процедура УстановитьОтборФоновыхЗаданий(Кнопка)
	
	Диалог = ОбработкаОбъект.ПолучитьФорму("ДиалогОтбораФоновогоЗадания");
	Диалог.Отбор = ОтборФоновыхЗаданий;
	Если Диалог.ОткрытьМодально() = Истина Тогда
		ОтборФоновыхЗаданий = Диалог.Отбор;
		ФоновыеЗаданияУстановитьОтбор();
	КонецЕсли;
	
КонецПроцедуры

Процедура ОформитьСтрокуЗадания(ОформлениеСтроки, ДанныеСтроки)

	Если ДанныеСтроки.СостояниеЗадания = СостояниеФоновогоЗадания.Активно Тогда
		ОформлениеСтроки.ЦветТекста = Новый Цвет(0, 0, 200);
	ИначеЕсли ДанныеСтроки.СостояниеЗадания = СостояниеФоновогоЗадания.Завершено Тогда
	ИначеЕсли ДанныеСтроки.СостояниеЗадания = СостояниеФоновогоЗадания.ЗавершеноАварийно Тогда	
		ОформлениеСтроки.ЦветТекста = Новый Цвет(128, 0, 0);
	ИначеЕсли ДанныеСтроки.СостояниеЗадания = СостояниеФоновогоЗадания.Отменено Тогда	
		ОформлениеСтроки.ЦветТекста = Новый Цвет(128, 128, 0);
	КонецЕсли;
	
КонецПроцедуры // ОформитьСтрокуЗадания()
 

Процедура СписокФоновыхЗаданийПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	
	ОформитьСтрокуЗадания(ОформлениеСтроки, ДанныеСтроки);
	Если ДанныеСтроки.Регламентное <> "" Тогда
		ОформлениеСтроки.Ячейки[0].Картинка = БиблиотекаКартинок.РегламентноеЗадание;
		ОформлениеСтроки.Ячейки[0].ОтображатьКартинку = Истина;
	КонецЕсли;
	
КонецПроцедуры

Процедура УстановитьОтборРегламентныхЗаданий(Кнопка)
	
	Диалог = ОбработкаОбъект.ПолучитьФорму("ДиалогОтбораРегламентногоЗадания");
	Диалог.Отбор = ОтборРегламентныхЗаданий;
	Если Диалог.ОткрытьМодально() = Истина Тогда
		ОтборРегламентныхЗаданий = Диалог.Отбор;
		РегламентныеЗаданияУстановитьОтбор();
	КонецЕсли;
	
КонецПроцедуры

Процедура ОтключитьОтборРегламентныхЗаданий(Кнопка)
	
	РегламентныеЗаданияУстановитьОтбор(Ложь);
	
КонецПроцедуры

Процедура КоманднаяПанель4Действие3(Кнопка)
	
	Диалог = ОбработкаОбъект.ПолучитьФорму("ДиалогНастройкиОбновленияСписка");
	Диалог.Автообновление = АвтообновлениеСпискаРегламентныхЗаданий;
	Диалог.ПериодАвтообновления = ПериодАвтообновленияСпискаРегламентныхЗаданий;
	Если Диалог.ОткрытьМодально() = Истина Тогда	
		АвтообновлениеСпискаРегламентныхЗаданий = Диалог.Автообновление;
		ПериодАвтообновленияСпискаРегламентныхЗаданий = Диалог.ПериодАвтообновления;
		СохранитьЗначение("РегламентныеЗадания.АвтообновлениеСписка", 
			АвтообновлениеСпискаРегламентныхЗаданий);
		Кнопка.Пометка = АвтообновлениеСпискаРегламентныхЗаданий;
		СохранитьЗначение("РегламентныеЗадания.ПериодАвтообновленияСписка", 
			ПериодАвтообновленияСпискаРегламентныхЗаданий);
			
		ОтключитьОбработчикОжидания("ОбновитьСписокРегламентныхЗаданий");
		Если АвтообновлениеСпискаРегламентныхЗаданий = Истина Тогда
			ПодключитьОбработчикОжидания("ОбновитьСписокРегламентныхЗаданий", ПериодАвтообновленияСпискаРегламентныхЗаданий);
		КонецЕсли;		
	КонецЕсли;
	БлокироватьОбновление = Ложь;
	
КонецПроцедуры

Процедура КоманднаяПанель5Действие3(Кнопка)
	
	Диалог = ОбработкаОбъект.ПолучитьФорму("ДиалогНастройкиОбновленияСписка");
	Диалог.Автообновление = АвтообновлениеСпискаФоновыхЗаданий;
	Диалог.ПериодАвтообновления = ПериодАвтообновленияСпискаФоновыхЗаданий;
	Если Диалог.ОткрытьМодально() = Истина Тогда	
		АвтообновлениеСпискаФоновыхЗаданий = Диалог.Автообновление;
		Кнопка.Пометка = АвтообновлениеСпискаФоновыхЗаданий;
		ПериодАвтообновленияСпискаФоновыхЗаданий = Диалог.ПериодАвтообновления;
		СохранитьЗначение("ФоновыеЗадания.АвтообновлениеСписка", 
			АвтообновлениеСпискаФоновыхЗаданий);
		СохранитьЗначение("ФоновыеЗадания.ПериодАвтообновленияСписка", 
			ПериодАвтообновленияСпискаФоновыхЗаданий);
			
		ОтключитьОбработчикОжидания("ОбновитьФоновыеЗадания");
		Если АвтообновлениеСпискаФоновыхЗаданий = Истина Тогда
			ПодключитьОбработчикОжидания("ОбновитьФоновыеЗадания", ПериодАвтообновленияСпискаФоновыхЗаданий);
		КонецЕсли;		
	КонецЕсли;
	БлокироватьОбновление = Ложь;
	
КонецПроцедуры

Процедура КоманднаяПанельФоновыеЗаданияОтборПоТекущему(Кнопка)
	
	ОтборПоТекущемуРегламентномуЗаданию = Не Кнопка.Пометка;
	Кнопка.Пометка = ОтборПоТекущемуРегламентномуЗаданию;
	ОбновитьОтборФоновыхЗаданийПоТекущемуРегламентному();
	
КонецПроцедуры

Процедура ОбновитьОтборФоновыхЗаданийПоТекущемуРегламентному()
	
	Если ОтборФоновыхЗаданий = Неопределено Тогда
		ОтборФоновыхЗаданий = Новый Структура;
	КонецЕсли; 
	Если ОтборПоТекущемуРегламентномуЗаданию Тогда
		Если ЭлементыФормы.СписокРегламентныхЗаданий.ТекущаяСтрока <> Неопределено Тогда
			Идентификатор = ЭлементыФормы.СписокРегламентныхЗаданий.ТекущаяСтрока.Идентификатор;
			Если ЗначениеЗаполнено(Идентификатор) Тогда
				УИ = Новый УникальныйИдентификатор(Идентификатор);
				ОтборФоновыхЗаданий.Вставить("РегламентноеЗадание", РегламентныеЗадания.НайтиПоУникальномуИдентификатору(УИ));
				ОтборФоновыхЗаданий.Вставить("Ключ", ЭлементыФормы.СписокРегламентныхЗаданий.ТекущаяСтрока.Ключ);
			Иначе
				ОтборФоновыхЗаданий.Вставить("РегламентноеЗадание", Неопределено);
				Если ОтборФоновыхЗаданий.Свойство("Ключ") Тогда
					ОтборФоновыхЗаданий.Удалить("Ключ");
				КонецЕсли; 
			КонецЕсли; 
		КонецЕсли; 
	Иначе
		Если ОтборФоновыхЗаданий.Свойство("РегламентноеЗадание") Тогда
			ОтборФоновыхЗаданий.Удалить("РегламентноеЗадание");
		КонецЕсли; 
		Если ОтборФоновыхЗаданий.Свойство("Ключ") Тогда
			ОтборФоновыхЗаданий.Удалить("Ключ");
		КонецЕсли; 
	КонецЕсли; 
	ФоновыеЗаданияУстановитьОтбор();

КонецПроцедуры

Процедура СписокРегламентныхЗаданийПриАктивизацииСтроки(Элемент)
	
	Если ОтборПоТекущемуРегламентномуЗаданию Тогда
		ОбновитьОтборФоновыхЗаданийПоТекущемуРегламентному();
	КонецЕсли; 
	
КонецПроцедуры

Процедура ВыполнитьРегламентноеЗаданиеВЭтомСеансе(НаСервере = Ложь)
	
	ТекущиеДанные = ЭлементыФормы.СписокРегламентныхЗаданий.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;  
	РегламентноеЗадание = РегламентныеЗаданияСоответствие.Получить(ТекущиеДанные.Идентификатор);
	СтрокаПараметров = "";
	Индекс = 0;
	Пока Индекс < РегламентноеЗадание.Параметры.Количество() Цикл
		СтрокаПараметров = СтрокаПараметров + "_АлгоритмОбъект[" + Индекс + "]";
		Если Индекс < (РегламентноеЗадание.Параметры.Количество()-1) Тогда
			СтрокаПараметров = СтрокаПараметров + ",";
		КонецЕсли;
		Индекс = Индекс + 1;
	КонецЦикла;
	ТекстПрограммы = "" + РегламентноеЗадание.Метаданные.ИмяМетода + "(" + СтрокаПараметров + ");";
	ПараметрыЗадания = ирОбщий.СкопироватьУниверсальнуюКоллекциюЛкс(РегламентноеЗадание.Параметры);
	Если НаСервере Тогда
		ирСервер.ВыполнитьАлгоритм(ТекстПрограммы, ПараметрыЗадания);
	Иначе
		ирОбщий.ВыполнитьАлгоритм(ТекстПрограммы, ПараметрыЗадания);
	КонецЕсли; 

КонецПроцедуры

Процедура КоманднаяПанельРегламентныеЗаданияВыполнитьРегламентноеЗаданиеНаСервере(Кнопка)
	
	ВыполнитьРегламентноеЗаданиеВЭтомСеансе(Истина);
	
КонецПроцедуры

Процедура КоманднаяПанельРегламентныеЗаданияВыполнитьРегламентноеЗаданиеНаКлиенте(Кнопка)
	
	ВыполнитьРегламентноеЗаданиеВЭтомСеансе();
	
КонецПроцедуры

Процедура КоманднаяПанельРегламентныеЗаданияВыполнитьРегламентноеЗаданиеВФоновомЗадании(Кнопка)
	
	Для Каждого ВыделеннаяСтрока Из ЭлементыФормы.СписокРегламентныхЗаданий.ВыделенныеСтроки Цикл
		РегламентноеЗадание = РегламентныеЗаданияСоответствие.Получить(ВыделеннаяСтрока.Идентификатор);
		ИмяМетода    = РегламентноеЗадание.Метаданные.ИмяМетода;
		Параметры    = РегламентноеЗадание.Параметры;
		КлючЗадания  = РегламентноеЗадание.Ключ;
		НаименованиеЗадания = """" + РегламентноеЗадание.Наименование + """, пользователь " + ИмяПользователя();
		ФоновоеЗадание = ФоновыеЗадания.Выполнить(ИмяМетода, Параметры, КлючЗадания, НаименованиеЗадания);
	КонецЦикла; 
	ОбновитьСписокФоновыхЗаданий();
	
КонецПроцедуры

Процедура КоманднаяПанельРегламентныеЗаданияРаботатьДиспетчером(Кнопка)
	
	Пока Истина Цикл
		Состояние("Работаю диспетчером заданий... CTRL+Break для прерывания");
		ВыполнитьОбработкуЗаданий();
		ОбработкаПрерыванияПользователя();
	КонецЦикла; 
	
КонецПроцедуры

Процедура КоманднаяПанельРегламентныеЗаданияНовоеОкно(Кнопка)
	
	ирОбщий.ОткрытьНовоеОкноОбработкиЛкс(ЭтотОбъект);
	
КонецПроцедуры

Процедура СписокФоновыхЗаданийПриАктивизацииСтроки(Элемент)
	
	#Если _ Тогда
	    Элемент = ЭлементыФормы.СписокФоновыхЗаданий;
	#КонецЕсли
	ЭлементыФормы.КоманднаяПанельФоновыеЗадания.Кнопки.Отменить.Доступность = Истина
		И Элемент.ТекущаяСтрока <> Неопределено
		И Найти(Элемент.ТекущаяСтрока.Состояние, "ыполняется") > 0;
	
КонецПроцедуры

Процедура КоманднаяПанельРегламентныеЗаданияВКонсолиКода(Кнопка)
	
	ТекущиеДанные = ЭлементыФормы.СписокРегламентныхЗаданий.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;  
	РегламентноеЗадание = РегламентныеЗаданияСоответствие.Получить(ТекущиеДанные.Идентификатор);
	СтрокаПараметров = "";
	Индекс = 0;
	СтруктураПараметров = Новый Структура;
	Пока Индекс < РегламентноеЗадание.Параметры.Количество() Цикл
		ИмяПараметра = "П" + (Индекс + 1);
		СтрокаПараметров = СтрокаПараметров + ИмяПараметра;
		Если Индекс < (РегламентноеЗадание.Параметры.Количество()-1) Тогда
			СтрокаПараметров = СтрокаПараметров + ",";
		КонецЕсли;
		СтруктураПараметров.Вставить(ИмяПараметра, РегламентноеЗадание.Параметры[Индекс]);
		Индекс = Индекс + 1;
	КонецЦикла;
	ТекстПрограммы = "" + РегламентноеЗадание.Метаданные.ИмяМетода + "(" + СтрокаПараметров + ");";
	ирОбщий.ОперироватьСтруктуройЛкс(ТекстПрограммы, ,СтруктураПараметров);
	
КонецПроцедуры

Процедура КоманднаяПанельРегламентныеЗаданияМенеджерТабличногоПоля(Кнопка)
	
	 ирОбщий.ПолучитьФормуЛкс("Обработка.ирМенеджерТабличногоПоля.Форма",, ЭтаФорма, ).УстановитьСвязь(ЭлементыФормы.СписокРегламентныхЗаданий);
	
КонецПроцедуры

Процедура КоманднаяПанельФоновыеЗаданияМенеджерТабличногоПоля(Кнопка)
	
	ирОбщий.ПолучитьФормуЛкс("Обработка.ирМенеджерТабличногоПоля.Форма",, ЭтаФорма, ).УстановитьСвязь(ЭлементыФормы.СписокФоновыхЗаданий);

КонецПроцедуры

Процедура СписокРегламентныхЗаданийВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(ВыбраннаяСтрока.Идентификатор) Тогда
		Возврат;
	КонецЕсли; 
	БлокироватьОбновление = Истина;
	Строка = ВыбраннаяСтрока;
	РегламентноеЗадание = РегламентныеЗаданияСоответствие.Получить(Строка.Идентификатор);
	Диалог = ОбработкаОбъект.ПолучитьФорму("ДиалогРегламентногоЗадания");
	Диалог.РегламентноеЗадание = РегламентноеЗадание;
	Диалог.ОткрытьМодально();
		
	Строка.Наименование = РегламентноеЗадание.Наименование;
	Строка.Ключ = РегламентноеЗадание.Ключ;
	Строка.Расписание = РегламентноеЗадание.Расписание;
	Строка.Пользователь = РегламентноеЗадание.ИмяПользователя;
	Строка.Предопределенное = РегламентноеЗадание.Предопределенное;
	Строка.Использование = РегламентноеЗадание.Использование;
	Строка.Идентификатор = РегламентноеЗадание.УникальныйИдентификатор;
	
	ПоследнееЗадание = ПолучитьПоследнееЗаданиеРегламентногоЗадания(РегламентноеЗадание);
	Если ПоследнееЗадание <> Неопределено Тогда
		Строка.Выполнялось = ПоследнееЗадание.Начало;
		Строка.Состояние = ПоследнееЗадание.Состояние;
	КонецЕсли;
	БлокироватьОбновление = Ложь;
	
КонецПроцедуры

Процедура СписокРегламентныхЗаданийПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;

КонецПроцедуры

Процедура СписокРегламентныхЗаданийПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	
    ОформитьСтрокуЗадания(ОформлениеСтроки, ДанныеСтроки);
	Если Не ДанныеСтроки.Использование Тогда
		ОформлениеСтроки.ЦветТекста = Новый Цвет(128, 128, 128);
	КонецЕсли; 
	
КонецПроцедуры

Процедура КоманднаяПанельФоновыеЗаданияПоказатьСообщенияПользователю(Кнопка)

	ПолучатьСообщенияПользователю = Не Кнопка.Пометка;
	Кнопка.Пометка = ПолучатьСообщенияПользователю;
	СохранитьЗначение("ФоновыеЗадания.ПолучатьСообщенияПользователю", ПолучатьСообщенияПользователю);
	Если ПолучатьСообщенияПользователю Тогда
		ОбновитьСписокФоновыхЗаданий();
	КонецЕсли; 
	
КонецПроцедуры

Процедура СписокФоновыхЗаданийВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	Если Колонка = Элемент.Колонки.СообщенияПользователю Тогда
		Идентификатор = ЭлементыФормы.СписокФоновыхЗаданий.ТекущаяСтрока.Идентификатор;
		ФоновоеЗадание = ФоновыеЗадания.НайтиПоУникальномуИдентификатору(Новый УникальныйИдентификатор(Идентификатор));
		СообщенияПользователю = ФоновоеЗадание.ПолучитьСообщенияПользователю();
		// Антибаг платформы 8.2.14
		Если СообщенияПользователю = Неопределено Тогда
			Возврат;
		КонецЕсли; 
		Сообщить("--Сообщения пользователю от фонового задания " + Идентификатор);
		Для Каждого СообщениеПользователю Из СообщенияПользователю Цикл
			СообщениеПользователю.Сообщить();
		КонецЦикла; 
	ИначеЕсли Колонка = Элемент.Колонки.Ошибки Тогда
		ТекстЯчейки = ВыбраннаяСтрока[Колонка.Данные];
		Если ЗначениеЗаполнено(ТекстЯчейки) Тогда
			ирОбщий.ОткрытьТекстЛкс(ТекстЯчейки, , "Обычный", Истина, ВыбраннаяСтрока.Ключ);
		КонецЕсли; 
	КонецЕсли; 
	
КонецПроцедуры

Процедура КоманднаяПанельРегламентныеЗаданияЖурналРегистрации(Кнопка)
	
	ТекущаяСтрока = ЭлементыФормы.СписокРегламентныхЗаданий.ТекущаяСтрока;
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	Если Не ЗначениеЗаполнено(ТекущаяСтрока.НомерСеанса) Тогда
		Сообщить("Текущий сеанс регламентного задания не найден");
		Возврат;
	КонецЕсли; 
	СтруктураОтбора = Новый Структура;
	СтруктураОтбора.Вставить("ИмяПриложения", "BackgroundJob");
	СтруктураОтбора.Вставить("Сеанс", ТекущаяСтрока.НомерСеанса); // сомнительно
	АнализЖурналаРегистрации = ирОбщий.ПолучитьОбъектПоПолномуИмениМетаданныхЛкс("Обработка.ирАнализЖурналаРегистрации");
	#Если _ Тогда
		АнализЖурналаРегистрации = Обработки.ирАнализЖурналаРегистрации.Создать();
	#КонецЕсли
	АнализЖурналаРегистрации.ОткрытьСОтбором(,, СтруктураОтбора);
	
КонецПроцедуры

Процедура КоманднаяПанельФоновыеЗаданияЖурналРегистрации(Кнопка)
	
	ТекущаяСтрока = ЭлементыФормы.СписокФоновыхЗаданий.ТекущаяСтрока;
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	ФоновоеЗадание = ФоновыеЗаданияСоответствие.Получить(ТекущаяСтрока.Идентификатор);
	СтруктураОтбора = Новый Структура;
	СтруктураОтбора.Вставить("ИмяПриложения", "BackgroundJob");
	Если ЗначениеЗаполнено(ТекущаяСтрока.НомерСеанса) Тогда
		СтруктураОтбора.Вставить("Сеанс", ТекущаяСтрока.НомерСеанса);
	КонецЕсли; 
	АнализЖурналаРегистрации = ирОбщий.ПолучитьОбъектПоПолномуИмениМетаданныхЛкс("Обработка.ирАнализЖурналаРегистрации");
	#Если _ Тогда
		АнализЖурналаРегистрации = Обработки.ирАнализЖурналаРегистрации.Создать();
	#КонецЕсли
	АнализЖурналаРегистрации.ОткрытьСОтбором(ФоновоеЗадание.Начало, ФоновоеЗадание.Конец, СтруктураОтбора);
	
КонецПроцедуры

Процедура СтруктураКоманднойПанелиНажатие(Кнопка)
	
	ирОбщий.ОткрытьСтруктуруКоманднойПанелиЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура КоманднаяПанельРегламентныеЗаданияВключить(Кнопка)
	
	УстановитьИспользованиеВыделенныхРегламентныхЗаданий(Истина);
	
КонецПроцедуры

Процедура УстановитьИспользованиеВыделенныхРегламентныхЗаданий(НовоеИспользование)
	Для Каждого ВыделеннаяСтрока Из ЭлементыФормы.СписокРегламентныхЗаданий.ВыделенныеСтроки Цикл
		Если Не ЗначениеЗаполнено(ВыделеннаяСтрока.Идентификатор) Тогда
			Продолжить;
		КонецЕсли; 
		РегламентноеЗадание = РегламентныеЗаданияСоответствие.Получить(ВыделеннаяСтрока.Идентификатор);
		РегламентноеЗадание.Использование = НовоеИспользование;
		РегламентноеЗадание.Записать();
	КонецЦикла;
	ОбновитьСписокРегламентныхЗаданий();
КонецПроцедуры

Процедура КоманднаяПанельРегламентныеЗаданияВыключить(Кнопка)
	
	УстановитьИспользованиеВыделенныхРегламентныхЗаданий(Ложь);

КонецПроцедуры

Процедура КоманднаяПанельФоновыеЗаданияОтладчикФоновыхЗаданий(Кнопка)
	
	СтрокаСоединения = ирСервер.ПолучитьСтрокуСоединенияСервераЛкс();
	ПараметрыЗапуска = ирОбщий.ПолучитьПараметрыЗапускаПриложения1СТекущейБазыЛкс(,,, Истина,,,,,, СтрокаСоединения);
	ЗапуститьСистему(ПараметрыЗапуска);
	
КонецПроцедуры

Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	ирОбщий.ФормаОбработкаОповещенияЛкс(ЭтаФорма, ИмяСобытия, Параметр, Источник); 

КонецПроцедуры

ирОбщий.ИнициализироватьФормуЛкс(ЭтаФорма, "Обработка.ирКонсольЗаданий.Форма.ФормаКонсоли");

РегламентныеЗаданияСоответствие = Новый Соответствие;
ФоновыеЗаданияСоответствие = Новый Соответствие;
БлокироватьОбновление = Ложь;
СписокРегламентныхЗаданий.Колонки.Добавить("СостояниеЗадания");
СписокРегламентныхЗаданий.Индексы.Добавить("НомерСеанса");
СписокФоновыхЗаданий.Колонки.Добавить("СостояниеЗадания");