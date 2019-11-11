﻿
// Переменная хранит обладает ли пользователь правами администрирования или нет
Перем мЕстьПраваАдминистрирования;

Перем мЗакрытиеФормыИнициированоПользователем;
Перем мФормаМодифицирована;
Перем мПлатформа;
Перем мЗаменаНепустогоПароля;

Процедура мСообщитьОбОшибке(Текст)
	
	Сообщить(Текст, СтатусСообщения.Внимание);
	
КонецПроцедуры

// нажатие на ОК в форме пользователя БД
Процедура ОсновныеДействияФормыОК(Кнопка)
	
	РезультатЗаписи = ЗаписатьПользователя();
	Если РезультатЗаписи = Истина Тогда
		мЗакрытиеФормыИнициированоПользователем = Истина;
		ЭтаФорма.Закрыть(Истина);
	КонецЕсли;
	
КонецПроцедуры

// отмена
Процедура ОсновныеДействияФормыОтмена(Кнопка)
	
	мЗакрытиеФормыИнициированоПользователем = Истина;
	ЭтаФорма.Закрыть(Ложь);
	
КонецПроцедуры

// Процедура заполняет информацию о пользователе БД
Процедура ОбновитьДанныеПользователяБД(ПользовательНастроек, Знач ОтображатьИмя = Истина)
	
	Если ПользовательНастроек = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	#Если Сервер И Не Сервер Тогда
	    ПользовательНастроек = ПользователиИнформационнойБазы.ТекущийПользователь();
	#КонецЕсли
	Если ОтображатьИмя Тогда
		
		ЭтаФорма.Имя = ПользовательНастроек.Имя;
		ЭтаФорма.ПолноеИмя = ПользовательНастроек.ПолноеИмя;
		
	КонецЕсли;
	
	ЭтаФорма.Язык = ПользовательНастроек.Язык;
	ЭтаФорма.ОсновнойИнтерфейс = ПользовательНастроек.ОсновнойИнтерфейс;
	
	ЭтаФорма.АутентификацияСтандартная = ПользовательНастроек.АутентификацияСтандартная;
	ЭтаФорма.ПарольУстановлен = ПользовательНастроек.ПарольУстановлен;
	ЭтаФорма.СохраняемоеЗначениеПароля = ПользовательНастроек.СохраняемоеЗначениеПароля;
	ЭтаФорма.ВариантПароля = 2;

	Попытка
		ЭтаФорма.ПользовательОС = ПользовательНастроек.ПользовательОС;
	Исключение
		ЭтаФорма.ПользовательОС = "<Неверные данные>";
	КонецПопытки; 

 	ЭтаФорма.ПоказыватьВСпискеВыбора = ПользовательНастроек.ПоказыватьВСпискеВыбора;
	ЭтаФорма.АутентификацияОС = ПользовательНастроек.АутентификацияОС;
	ЭтаФорма.АутентификацияOpenID = ПользовательНастроек.АутентификацияOpenID;
	
	Для Каждого СтрокаСпискаДоступныхРолей Из РолиПользователя Цикл
		СтрокаСпискаДоступныхРолей.Включена = ПользовательНастроек.Роли.Содержит(Метаданные.Роли[СтрокаСпискаДоступныхРолей.Роль]);
	КонецЦикла; 
	
	Для Каждого СтрокаРазделителя Из РазделениеДанных Цикл
		СтрокаРазделителя.ЗначениеСтрока = "";
		//СтрокаРазделителя.Значение = Неопределено;
		СтрокаРазделителя.Включена = ПользовательНастроек.РазделениеДанных.Свойство(СтрокаРазделителя.Разделитель); 
		Если СтрокаРазделителя.Включена Тогда
			СтрокаРазделителя.ЗначениеСтрока = ПользовательНастроек.РазделениеДанных[СтрокаРазделителя.Разделитель];
			//СтрокаРазделителя.Значение = ЗначениеРазделителяИзСтроки(СтрокаРазделителя.Разделитель, СтрокаРазделителя.ЗначениеСтрока);
		КонецЕсли; 
	КонецЦикла; 
	
	ЭтаФорма.РежимЗапуска = ПользовательНастроек.РежимЗапуска;
	Если ирКэш.ДоступнаЗащитаОтОпасныхДействийЛкс() Тогда
		ЭтаФорма.ЗащитаОтОпасныхДействий = ПользовательНастроек.ЗащитаОтОпасныхДействий.ПредупреждатьОбОпасныхДействиях;
	КонецЕсли; 
	
	ОбновитьДоступность();
	
КонецПроцедуры

Функция _ЗначениеРазделителяИзСтроки(ИмяРазделителя, СтрокаЗначения)
	
	МетаРазделитель = Метаданные.ОбщиеРеквизиты.Найти(ИмяРазделителя);
	Если Ложь
		Или МетаРазделитель.ТипЗначения.СодержитТип(Тип("Булево")) 
		Или МетаРазделитель.ТипЗначения.СодержитТип(Тип("Число")) 
		Или МетаРазделитель.ТипЗначения.СодержитТип(Тип("Дата")) 
		Или МетаРазделитель.ТипЗначения.СодержитТип(Тип("Строка"))
	Тогда
		Результат = МетаРазделитель.ТипЗначения.ПривестиЗначение(СтрокаЗначения);
	Иначе
		ОбъектМД = Метаданные.НайтиПоТипу(МетаРазделитель.ТипЗначения.Типы()[0]);
		Менеджер = ирОбщий.ПолучитьМенеджерЛкс(ОбъектМД);
	КонецЕсли; 
	
КонецФункции

///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ ДЛЯ РАБОТЫ С ИНФОРМАЦИЕЙ О ПОЛЬЗОВАТЕЛЕ БД

// Процедура - обработчик "При изменении" АутентификацияСтандартная
Процедура АутентификацияСтандартнаяПриИзменении(Элемент)
	
	ОбновитьДоступность();
	
КонецПроцедуры

// Процедура - обработчик "При изменении" АутентификацияОС
Процедура АутентификацияОСПриИзменении(Элемент)
	
	ОбновитьДоступность();
	
КонецПроцедуры

// Процедура заполняет списки выбора атрибутов для пользователя БД
Процедура ИнициализироватьЭлементыРедактированияПользователяБД()
	
	ЗаполнитьСписокВыбораЯзыка(ЭлементыФормы.Язык.СписокВыбора);
	ЗаполнитьСписокВыбораИнтерфейса(ЭлементыФормы.ОсновнойИнтерфейс.СписокВыбора);
	ЗаполнитьСписокВыбораРежимаЗапуска(ЭлементыФормы.РежимЗапуска.СписокВыбора);
	
КонецПроцедуры

// Процедура выполняет запись пользователя ИБ
Функция ЗаписатьПользователя()
	
	Если ПользовательБД = Неопределено Тогда
		//Возврат Ложь;
		ПользовательБД = ПользователиИнформационнойБазы.СоздатьПользователя();
	КонецЕсли;
	Имя = СокрЛП(Имя);
	Если НЕ ЗначениеЗаполнено(Имя) Тогда
		мСообщитьОбОшибке("Не заполнено имя пользователя базы данных!");
		Возврат Ложь;
	КонецЕсли;
	
	//проверим что бы было указано то что нужно
	Если Истина
		И АутентификацияОС
		И ПустаяСтрока(ПользовательОС) 
	Тогда
		мСообщитьОбОшибке("Укажите пользователя Windows или запретите Windows-аутентификацию!");
		Возврат Ложь;
	КонецЕсли;
	
	ПользовательБД.Имя = Имя;
	ПользовательБД.ПолноеИмя = ПолноеИмя;
	ПользовательБД.ПользовательОС = ПользовательОС;
	Если ВариантПароля = 0 Тогда
		Если Пароль <> ПодтверждениеПароля Тогда
			мСообщитьОбОшибке("Пароль и подтверждение пароля не совпадают!!!"); 
			Возврат Ложь;
		КонецЕсли;
		ПользовательБД.Пароль = Пароль;
	ИначеЕсли ВариантПароля = 1 Тогда
		ПользовательБД.СохраняемоеЗначениеПароля = СохраняемоеЗначениеПароля;
	КонецЕсли; 
	
	ПользовательБД.АутентификацияСтандартная = АутентификацияСтандартная;
	ПользовательБД.ПоказыватьВСпискеВыбора = ПоказыватьВСпискеВыбора;
	ПользовательБД.АутентификацияОС = АутентификацияОС;
	ПользовательБД.АутентификацияOpenID = АутентификацияOpenID;
	ПользовательБД.Язык = Язык;
	ПользовательБД.ОсновнойИнтерфейс = ОсновнойИнтерфейс;
	Если РежимЗапуска <> Неопределено Тогда
		ПользовательБД.РежимЗапуска = РежимЗапуска;
	КонецЕсли; 
	Если ирКэш.ДоступнаЗащитаОтОпасныхДействийЛкс() Тогда
		ПользовательБД.ЗащитаОтОпасныхДействий.ПредупреждатьОбОпасныхДействиях = ЭтаФорма.ЗащитаОтОпасныхДействий;
	КонецЕсли; 
	
	// Роли сохраняем
	Для Каждого СтрокаСпискаДоступныхРолей Из РолиПользователя Цикл
		мРоль = Метаданные.Роли[СтрокаСпискаДоступныхРолей.Роль];
		СодержитРоль = ПользовательБД.Роли.Содержит(мРоль);
		Если СодержитРоль И Не СтрокаСпискаДоступныхРолей.Включена Тогда
			ПользовательБД.Роли.Удалить(мРоль);
		ИначеЕсли Не СодержитРоль И СтрокаСпискаДоступныхРолей.Включена Тогда
			ПользовательБД.Роли.Добавить(мРоль);
		КонецЕсли; 
	КонецЦикла;
	
	Если РазделениеДанных.Количество() > 0 Тогда
		ПользовательБД.РазделениеДанных.Очистить();
		Для Каждого СтрокаРазделителя Из РазделениеДанных Цикл
			Если СтрокаРазделителя.Включена Тогда
				ПользовательБД.РазделениеДанных.Вставить(СтрокаРазделителя.Разделитель, СтрокаРазделителя.ЗначениеСтрока);
			КонецЕсли; 
		КонецЦикла;
	КонецЕсли; 
	
	// запись пользователя БД
	Попытка
		ПользовательБД.Записать();
	Исключение
		мСообщитьОбОшибке("Ошибка при сохранении данных пользователя инфобазы. " + ОписаниеОшибки());
		Возврат Ложь;
	КонецПопытки;
	
	ирОбщий.ОбновитьТекстПослеМаркераВСтрокеЛкс(ЭтаФорма.Заголовок,, Имя, ": ");
	// удачно записан пользователь БД
	Оповестить("ИзмененПользовательБД", ПользовательБД, ЭтаФорма); 
	Возврат Истина;
		
КонецФункции

//Процедура - обаботчик события, при нажатии на кнопку "Снять флажки" Командной панели "КоманднаяПанельСпискаДоступныхРолей"
Процедура КоманднаяПанельСпискаДоступныхРолейСнятьФлажки(Кнопка)
	
	ТекущаяСтрока = ЭлементыФормы.РолиПользователя.ТекущаяСтрока;
	ирОбщий.ИзменитьПометкиВыделенныхИлиОтобранныхСтрокЛкс(ЭлементыФормы.РолиПользователя, "Включена", Ложь);
	Если РолиПользователя.Найти(Истина, "Включена") = Неопределено Тогда
		УстановитьОтборТолькоВключенные(Ложь);
		ЭлементыФормы.РолиПользователя.ТекущаяСтрока = ТекущаяСтрока;
	КонецЕсли; 
	
КонецПроцедуры

//Процедура - обаботчик события, при нажатии на кнопку "Установить флажки" Командной панели "КоманднаяПанельСпискаДоступныхРолей"
Процедура КоманднаяПанельСпискаДоступныхРолейУстановитьФлажки(Кнопка)
	
	ирОбщий.ИзменитьПометкиВыделенныхИлиОтобранныхСтрокЛкс(ЭлементыФормы.РолиПользователя, "Включена", Истина);
	
КонецПроцедуры

//Процедура - обработчик события "НачалоВыбора" в: Поле ввода "ПользовательОС"
Процедура ПользовательОСНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ФормаВыбораПользователяWindows = ирКэш.Получить().ПолучитьФорму("ВыборПользователяWindows",, ЭтаФорма);
	ФормаВыбораПользователяWindows.ВыбранныйПользовательWindows = ПользовательОС;
	Результат = ФормаВыбораПользователяWindows.ОткрытьМодально();
	Если Результат <> Неопределено Тогда
		ПользовательОС = Результат;
	КонецЕсли; 
	
КонецПроцедуры

//Процедура - обаботчик события, "При изменении" у имени пользователя БД
Процедура ИмяПриИзменении(Элемент)
	
	Элемент.Значение = СокрЛП(Имя);
	
	// полное имя пользователя БД тоже ставим если оно пустое
	Если НЕ ЗначениеЗаполнено(ПолноеИмя) Тогда
		ПолноеИмя = Элемент.Значение
	КонецЕсли;
	
КонецПроцедуры

// перед открытием
Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	
	мПлатформа = ирКэш.Получить();
	ИнициализироватьЭлементыРедактированияПользователяБД();
	ОбновитьДоступныеРоли();
	Если ПользовательДляКопированияНастроек = Неопределено Тогда
		ОбновитьДанныеПользователяБД(ПользовательБД);
	Иначе
		ОбновитьДанныеПользователяБД(ПользовательДляКопированияНастроек, Ложь);
	КонецЕсли;
	ирОбщий.ОбновитьТекстПослеМаркераВСтрокеЛкс(ЭтаФорма.Заголовок,, Имя, ": ");
	ЭтаФорма.ТолькоПросмотр = НЕ мЕстьПраваАдминистрирования;
	мФормаМодифицирована = Модифицированность;
		
КонецПроцедуры

// перед закрытием
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Если мЗакрытиеФормыИнициированоПользователем Тогда
		
		мЗакрытиеФормыИнициированоПользователем = Ложь;
		Возврат;
		
	КонецЕсли;
	
	// форму принудительно пытаются закрыть	
	Если Модифицированность Тогда
		
		// есть права на изменение пользователя БД
		ОтветПользователя = Вопрос("Настройки пользователя БД были изменены. Сохранить?", РежимДиалогаВопрос.ДаНетОтмена, ,
			КодВозвратаДиалога.Да);
			
		Если ОтветПользователя = КодВозвратаДиалога.Да Тогда
			
			// записываем внесенные изменения
			РезультатЗаписи = ЗаписатьПользователя();
			Отказ = Не РезультатЗаписи;
			
			Если Не Отказ Тогда
				мЗакрытиеФормыИнициированоПользователем = Истина;
				Закрыть(Истина);
			КонецЕсли;			
				
		ИначеЕсли ОтветПользователя = КодВозвратаДиалога.Нет Тогда	
			
			// ничего делать не надо
			
		Иначе	
			
			Отказ = Истина;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриОткрытии()
	
	ЭлементыФормы.ЗащитаОтОпасныхДействий.Доступность = ирКэш.ДоступнаЗащитаОтОпасныхДействийЛкс();
	Модифицированность = мФормаМодифицирована;
	Если ПользовательБД <> Неопределено Тогда
		УстановитьОтборТолькоВключенные(Истина);
	КонецЕсли; 
	
КонецПроцедуры

// копирование настроек пользователя БД
Процедура КоманднаяПанельОбщаяСкопироватьНастройки(Кнопка)
	
	СписокВыбора = Новый СписокЗначений;
	
	МассивПользователей = ПользователиИнформационнойБазы.ПолучитьПользователей();
	
	Для каждого ВремПользователь Из МассивПользователей Цикл
		
		СписокВыбора.Добавить(ВремПользователь.УникальныйИдентификатор, ВремПользователь.Имя);
								
	КонецЦикла; 
	
	СписокВыбора.СортироватьПоЗначению();
		
	ВыбранныйПользователь = СписокВыбора.ВыбратьЭлемент("Выберите пользователя, от которого копировать настройки", 
		СписокВыбора);
		
	Если ВыбранныйПользователь = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ВыбранныйПользовательБД = ПользователиИнформационнойБазы.НайтиПоУникальномуИдентификатору(ВыбранныйПользователь.Значение);
	
	// настройки устанавливаются на форму
	ОбновитьДанныеПользователяБД(ВыбранныйПользовательБД, Ложь);
	
КонецПроцедуры

Процедура КоманднаяПанельСпискаДоступныхРолейТолькоВключенные(Кнопка)
	
	УстановитьОтборТолькоВключенные(Не Кнопка.Пометка);
	
КонецПроцедуры 

Процедура УстановитьОтборТолькоВключенные(НовоеЗначение)
	
	ЭлементыФормы.КоманднаяПанельСпискаДоступныхРолей.Кнопки.ТолькоВключенные.Пометка = НовоеЗначение;
	ЭлементыФормы.РолиПользователя.ОтборСтрок.Включена.ВидСравнения = ВидСравнения.Равно;
	ЭлементыФормы.РолиПользователя.ОтборСтрок.Включена.Использование = НовоеЗначение;
	ЭлементыФормы.РолиПользователя.ОтборСтрок.Включена.Значение = Истина;
	
КонецПроцедуры

Процедура СтруктураКоманднойПанелиНажатие(Кнопка)
	
	ирОбщий.ОткрытьСтруктуруКоманднойПанелиЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Функция СгенерироватьПароль(ДлинаСлучайногоПароля = 10)
	
	ЗапрещенныеСимволы = Новый СписокЗначений();
	ЗапрещенныеСимволы.Добавить(" ");
	НовыйПароль = "";
	Генератор = Новый ГенераторСлучайныхЧисел();
	Счетчик = 0;
	Пока Счетчик < ДлинаСлучайногоПароля цикл
		КодСимвола = Генератор.СлучайноеЧисло(33, 126);
		Символ = Символ(КодСимвола);
		НовыйПароль = НовыйПароль + Символ;
		Счетчик = Счетчик + 1;
	КонецЦикла;
	Возврат НовыйПароль;
	
КонецФункции

Процедура СгенерироватьНажатие(Элемент)
	
	НовыйПароль = СгенерироватьПароль();
	ЭтаФорма.Пароль = НовыйПароль;
	ЭтаФорма.ПодтверждениеПароля = НовыйПароль;
	ирОбщий.ПоместитьТекстВБуферОбменаОСЛкс(НовыйПароль);
	Предупреждение("Новый пароль установлен в форме и помещен в буфер обмена");
	
КонецПроцедуры

Процедура ВариантПароляСохраняемоеЗначениеПриИзменении(Элемент)
	
	ОбновитьДоступность();
	
КонецПроцедуры

Процедура ВариантПароляЯвныйПриИзменении(Элемент)
	
	ОбновитьДоступность();
	Если Пароль = мЗаменаНепустогоПароля Тогда
		ЭтаФорма.Пароль = "";
		ЭтаФорма.ПодтверждениеПароля = "";
	КонецЕсли; 
	
КонецПроцедуры

Процедура ОбновитьДоступность()
	ЭлементыФормы.СохраняемоеЗначениеПароля.ТолькоПросмотр = ВариантПароля <> 1;
	ЭлементыФормы.Пароль.ТолькоПросмотр = ВариантПароля <> 0;
	ЭлементыФормы.ПодтверждениеПароля.ТолькоПросмотр = ВариантПароля <> 0;
	ЭлементыФормы.Сгенерировать.Доступность = АутентификацияСтандартная И ВариантПароля = 0;
	ЭлементыФормы.Пароль.Доступность              			= АутентификацияСтандартная;
	ЭлементыФормы.ВариантПароляЯвный.Доступность 	= АутентификацияСтандартная;
	ЭлементыФормы.ПодтверждениеПароля.Доступность 			= АутентификацияСтандартная;
	ЭлементыФормы.НадписьПодтверждениеПароляБД.Доступность	= АутентификацияСтандартная;
	ЭлементыФормы.ВариантПароляСохраняемоеЗначение.Доступность = АутентификацияСтандартная;
	ЭлементыФормы.ВариантПароляНеМенять.Доступность 		= АутентификацияСтандартная;
	ЭлементыФормы.СохраняемоеЗначениеПароля.Доступность = АутентификацияСтандартная;
	ЭлементыФормы.ПоказыватьВСпискеВыбора.Доступность 		= АутентификацияСтандартная;
	ЭлементыФормы.ПользовательОС.Доступность 				= АутентификацияОС;
	ЭлементыФормы.НадписьПользовательОС.Доступность 		= АутентификацияОС;
	Если ВариантПароля <> 0 Тогда
		Если ПарольУстановлен Тогда
			ЭтаФорма.Пароль = мЗаменаНепустогоПароля;
			ЭтаФорма.ПодтверждениеПароля = мЗаменаНепустогоПароля;
		Иначе
			ЭтаФорма.Пароль = "";
			ЭтаФорма.ПодтверждениеПароля = "";
		КонецЕсли; 
	КонецЕсли; 

КонецПроцедуры

Процедура ПарольОчистка(Элемент, СтандартнаяОбработка)
	
	ПодтверждениеПароля = "";
	
КонецПроцедуры

Процедура КоманднаяПанельОбщаяНайтиВСписке(Кнопка)
	
	Форма = ирОбщий.ПолучитьФормуЛкс("Обработка.ирРедакторПользователей.Форма");
	Форма.ПараметрИмяПользователя = Имя;
	Форма.Открыть();
	
КонецПроцедуры

Процедура ОсновныеДействияФормыЗаписать(Кнопка)
	
	ЗаписатьПользователя();
	
КонецПроцедуры

ирОбщий.ИнициализироватьФормуЛкс(ЭтаФорма, "Обработка.ирРедакторПользователей.Форма.ПользовательИнфобазы");
мЕстьПраваАдминистрирования = ПравоДоступа("Администрирование", Метаданные);
мЗаменаНепустогоПароля = "****************";
//Заполняем параметры пользователя БД
мЗакрытиеФормыИнициированоПользователем = Ложь;
ПользовательДляКопированияНастроек = Неопределено;
