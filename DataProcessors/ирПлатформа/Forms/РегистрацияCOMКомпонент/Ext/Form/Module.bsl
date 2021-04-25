﻿Процедура КнопкаВыполнитьНажатие(Кнопка)

	Платформа = ирКэш.Получить();
	#Если Сервер И Не Сервер Тогда
		Платформа = Обработки.ирПлатформа.Создать();
	#КонецЕсли
	НуженПерезапускПроцесса = Ложь;
	Для Каждого Строка Из ТаблицаCOMКомпонент Цикл 
		Если Не Строка.Пометка Тогда
			Продолжить;
		КонецЕсли; 
		ИмяКомпоненты = Строка.Идентификатор;
		Если ИмяКомпоненты = "GoldParser" Тогда
			Путь = "SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full";
			РеестрОС = ПолучитьCOMОбъект("winmgmts:{impersonationLevel=impersonate}!\\.\root\default:StdRegProv");
			НомерВерсииNET = 0;
			РеестрОС.GetDWORDValue(, Путь, "Release", НомерВерсииNET);
			Если Не ЗначениеЗаполнено(НомерВерсииNET) Или НомерВерсииNET < 378389 Тогда
				ирОбщий.СообщитьЛкс("Для установки компоненты " + ИмяКомпоненты + " необходимо установить NET Framework 4.5", СтатусСообщения.Внимание);
				Продолжить;
			КонецЕсли; 
		КонецЕсли; 
		ФайлКомпоненты = Новый Файл(КаталогУстановки + "\" + ИмяКомпоненты + ".dll");
		ДвоичныеДанные = Платформа.ПолучитьМакет(ИмяКомпоненты);
		Если ТипЗнч(ДвоичныеДанные) = Тип("ДвоичныеДанные") Тогда
			ФайлКомпоненты = Платформа.ПроверитьЗаписатьКомпонентуИзМакетаВФайл(ИмяКомпоненты, КаталогУстановки, "dll");
			Если ФайлКомпоненты = Неопределено Тогда 
				Продолжить;
			КонецЕсли; 
		КонецЕсли; 
		Если Не ФайлКомпоненты.Существует() Тогда
			ирОбщий.СообщитьЛкс("Для компоненты " + ИмяКомпоненты + " не обнаружен файл """ + ФайлКомпоненты.ПолноеИмя + """. ", СтатусСообщения.Внимание);
			Продолжить;
		КонецЕсли; 
		Если Не Строка.ВспомогательныйФайл Тогда
			Результат = Платформа.ЗарегистрироватьПолучитьCOMОбъект(Строка.ProgID, ФайлКомпоненты.ПолноеИмя, Истина, Строка.ИмяТипаВК, ИмяКомпоненты);
			Если Результат = Неопределено Тогда
				НуженПерезапускПроцесса = Истина;
			КонецЕсли; 
		КонецЕсли; 
	КонецЦикла;
	ОбновитьТаблицу();
	ОбновитьПовторноИспользуемыеЗначения();
	Если НуженПерезапускПроцесса Тогда
		Ответ = Вопрос("Для перехода к использованию новых версий компонент может требоваться перезапуск приложения. Выполнить?", РежимДиалогаВопрос.ОКОтмена);
		Если Ответ = КодВозвратаДиалога.ОК Тогда
			ПараметрыЗапуска = "";
			Если ирКэш.ЛиПортативныйРежимЛкс() Тогда
				ИмяФайлаБазовогоМодуля = ирПортативный.ИспользуемоеИмяФайла;
				Если ЗначениеЗаполнено(ИмяФайлаБазовогоМодуля) Тогда
					ПараметрыЗапуска = ПараметрыЗапуска + " /Execute""" + ИмяФайлаБазовогоМодуля + """";
				КонецЕсли; 
			КонецЕсли; 
			ПараметрыЗапуска = ПараметрыЗапуска + " " + ирОбщий.ПараметрыЗапускаСеансаТекущиеЛкс();
			ЗавершитьРаботуСистемы(, Истина, ПараметрыЗапуска);
		КонецЕсли;
	КонецЕсли; 
	
КонецПроцедуры

Процедура ОбновитьТаблицу()
	
	Платформа = ирКэш.Получить();
	#Если Сервер И Не Сервер Тогда
	    Платформа = Обработки.ирПлатформа.Создать();
	#КонецЕсли
	ирОбщий.ЗагрузитьВТаблицуЗначенийЛкс(ирОбщий.ТаблицаЗначенийИзТабличногоДокументаЛкс(ПолучитьМакет("УстанавливаемыеCOMКомпоненты"),,,, Истина), ТаблицаCOMКомпонент,,, Истина);
	Для Каждого Строка Из ТаблицаCOMКомпонент Цикл
		Макет = Платформа.ПолучитьДвоичныеДанныеКомпоненты(Строка.Идентификатор);
		МетаМакет = Платформа.Метаданные().Макеты.Найти(Строка.Идентификатор);
		Строка.Описание = МетаМакет.Комментарий;
		Строка.ИмяФайла = Строка.Идентификатор + ".dll";
		Если ЗначениеЗаполнено(Строка.ProgID) Тогда
			Пустышка = Платформа.ПолучитьПроверитьCOMОбъект(Строка.ProgID, Строка.ИмяТипаВК);
			Строка.Установлена = (Пустышка <> Неопределено);
		КонецЕсли; 
		Файл = Новый Файл(КаталогУстановки + "\" + Строка.ИмяФайла);
		Строка.ФайлОбнаружен = Ложь
			Или ТипЗнч(Платформа.ПолучитьМакет(Строка.Идентификатор)) = Тип("ДвоичныеДанные")
			Или Файл.Существует()
			;
		Строка.Пометка = Истина
			И Не Строка.Установлена 
			И (ЛОжь
				Или Не x64Текущая 
				Или Строка.Версия64)
			//И Строка.ФайлОбнаружен
			;
		Пустышка = Неопределено;
	КонецЦикла;

КонецПроцедуры

Процедура ПутьУстановкиНачалоВыбора(Элемент, СтандартнаяОбработка)

	ВыборФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога);
	ВыборФайла.Каталог = Элемент.Значение;
	Если Не ВыборФайла.Выбрать() Тогда
		Возврат;
	КонецЕсли; 
	Элемент.Значение = ВыборФайла.Каталог;
	КаталогУстановкиПриИзменении(Элемент);
	
КонецПроцедуры

Процедура ПриОткрытии()
	
	ирОбщий.Форма_ПриОткрытииЛкс(ЭтаФорма);
	ЭтаФорма.x64Текущая = ирКэш.Это64битныйПроцессЛкс();
	ЭлементыФормы.НадписьРекомендуется32.Видимость = x64Текущая;
	КаталогУстановки = КаталогПрограммы();
	Фрагменты = ирОбщий.СтрРазделитьЛкс(КаталогУстановки, "\");
	Для Счетчик = 1 По 3 Цикл
		Фрагменты.Удалить(Фрагменты.ВГраница());
	КонецЦикла;
	Фрагменты.Добавить("Common");
	КаталогУстановки = ирОбщий.СтрСоединитьЛкс(Фрагменты, "\");
	ОбновитьТаблицу();
	ЭтаФорма.ОтАдминистратора = ирКэш.ВКОбщаяЛкс().IsAdmin();
	
КонецПроцедуры

Процедура ПутьУстановкиОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ЗапуститьПриложение(Элемент.Значение);
	
КонецПроцедуры

Процедура ТаблицаCOMКомпонентПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки) Экспорт
	
	ОформлениеСтроки.Ячейки.Пометка.ТолькоПросмотр = x64Текущая И Не ДанныеСтроки.Версия64;
	Если Не ДанныеСтроки.Установлена Тогда
		ОформлениеСтроки.ЦветФона = Новый Цвет(255, 240, 240);
	КонецЕсли;
	Если ОформлениеСтроки.Ячейки.Пометка.ТолькоПросмотр Тогда
		ОформлениеСтроки.Ячейки.Пометка.УстановитьТекст("недоступно 64-bit");
		ОформлениеСтроки.Ячейки.Пометка.ЦветТекста = ирОбщий.ЦветТекстаНеактивностиЛкс();
	КонецЕсли; 
	ирОбщий.ТабличноеПолеПриВыводеСтрокиЛкс(ЭтаФорма, Элемент, ОформлениеСтроки, ДанныеСтроки);
	
КонецПроцедуры

Процедура КаталогУстановкиПриИзменении(Элемент)
	
	ирОбщий.ПолеВводаСИсториейВыбора_ПриИзмененииЛкс(Элемент, ЭтаФорма);
	ОбновитьТаблицу();
	
КонецПроцедуры

Процедура КаталогУстановкиНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	
	ирОбщий.ПолеВводаСИсториейВыбора_НачалоВыбораИзСпискаЛкс(Элемент, ЭтаФорма);
	
КонецПроцедуры

Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник) Экспорт
	
	ирОбщий.Форма_ОбработкаОповещенияЛкс(ЭтаФорма, ИмяСобытия, Параметр, Источник); 

КонецПроцедуры

Процедура КлсКомандаНажатие(Кнопка) Экспорт 
	ирОбщий.УниверсальнаяКомандаФормыЛкс(ЭтаФорма, Кнопка);
КонецПроцедуры

Процедура КоманднаяПанель1ЗапуститьОтАдминистратора(Кнопка)
	
	ирОбщий.ПерезапуститьСеансОтИмениАдминистратораОСЛкс(ЭтаФорма);
	
КонецПроцедуры

Процедура ТаблицаCOMКомпонентПриИзмененииФлажка(Элемент, Колонка)
	
	ирОбщий.ТабличноеПолеПриИзмененииФлажкаЛкс(Элемент, Колонка);

КонецПроцедуры

Процедура ТаблицаCOMКомпонентПриАктивизацииСтроки(Элемент)
	
	ирОбщий.ТабличноеПолеПриАктивизацииСтрокиЛкс(ЭтаФорма, Элемент);

КонецПроцедуры

Процедура ВнешнееСобытие(Источник, Событие, Данные) Экспорт
	
	ирОбщий.Форма_ВнешнееСобытиеЛкс(ЭтаФорма, Источник, Событие, Данные);

КонецПроцедуры

Процедура ТабличноеПолеПриПолученииДанных(Элемент, ОформленияСтрок) Экспорт 
	
	ирОбщий.ТабличноеПолеПриПолученииДанныхЛкс(ЭтаФорма, Элемент, ОформленияСтрок);

КонецПроцедуры

Процедура ПриЗакрытии()
	
	ирОбщий.Форма_ПриЗакрытииЛкс(ЭтаФорма);

КонецПроцедуры

Процедура ОсновныеДействияФормыРазрегистрировать(Кнопка)
	
	Платформа = ирКэш.Получить();
	#Если Сервер И Не Сервер Тогда
		Платформа = Обработки.ирПлатформа.Создать();
	#КонецЕсли
	Для Каждого Строка Из ТаблицаCOMКомпонент Цикл 
		Если Не Строка.Пометка Тогда
			Продолжить;
		КонецЕсли; 
		ИмяКомпоненты = Строка.Идентификатор;
		ФайлКомпоненты = Новый Файл(КаталогУстановки + "\" + ИмяКомпоненты + ".dll");
		ДвоичныеДанные = Платформа.ПолучитьМакет(ИмяКомпоненты);
		Если ТипЗнч(ДвоичныеДанные) = Тип("ДвоичныеДанные") Тогда
			ФайлКомпоненты = Платформа.ПроверитьЗаписатьКомпонентуИзМакетаВФайл(ИмяКомпоненты, КаталогУстановки, "dll");
			Если ФайлКомпоненты = Неопределено Тогда 
				Продолжить;
			КонецЕсли; 
		КонецЕсли; 
		Если Не ФайлКомпоненты.Существует() Тогда
			ирОбщий.СообщитьЛкс("Для компоненты " + ИмяКомпоненты + " не обнаружен файл """ + ФайлКомпоненты.ПолноеИмя + """. ", СтатусСообщения.Внимание);
			Продолжить;
		КонецЕсли; 
		Если Истина
			И Не Строка.ВспомогательныйФайл 
			//И Строка.РазрешитьРазрегистрацию 
		Тогда
			Результат = Платформа.ЗарегистрироватьПолучитьCOMОбъект(Строка.ProgID, ФайлКомпоненты.ПолноеИмя, Истина, Строка.ИмяТипаВК, ИмяКомпоненты, Ложь);
		КонецЕсли; 
	КонецЦикла;
	ОбновитьТаблицу();
	ирОбщий.СообщитьЛкс("Для прекращения использования разрегистрированных компонент может требоваться перезапуск приложения");
	
КонецПроцедуры

Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	ирОбщий.ПроверитьПлатформаНеWindowsЛкс(Отказ);
КонецПроцедуры

ирОбщий.ИнициализироватьФормуЛкс(ЭтаФорма, "Обработка.ирПлатформа.Форма.РегистрацияCOMКомпонент");
