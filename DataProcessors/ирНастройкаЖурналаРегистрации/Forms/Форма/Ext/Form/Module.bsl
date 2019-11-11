﻿
////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ МОДУЛЯ

Перем мСоответствияСобытий;
Перем мУровниСобытий;
Перем мГруппыСобытий;

Перем мНастройки;  

Перем мМассивУровнейРегистрацийПоВажности;

Перем мМенялисьНастройкиДоступа;
Перем мМенялисьНастройкиОтказаВДоступе;
Перем мЛиОтображатьИмена;
Перем мКартинкиУровнейСобытий;

Перем констСобытиеДоступ_Доступ;
Перем констСобытиеДоступ_ОтказВДоступе;
Перем констСтрокаДереваДоступ_Доступ;
Перем констСтрокаДереваДоступ_ОтказВДоступе;
Перем констОбычныйШрифт;
Перем констЖирныйШрифт;

////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Процедура АктивизироватьСтрокуСобытия(ИмяСобытия, Метаданные = Неопределено) Экспорт
	
	СтрокаСобытия = ДеревоСобытий.Строки.Найти(ИмяСобытия, "ИмяСобытия", Истина);
	Если СтрокаСобытия <> Неопределено Тогда
		ЭлементыФормы.ДеревоСобытий.ТекущаяСтрока = СтрокаСобытия;
		ОткрытьНастройкуДоступа(СтрокаСобытия, Метаданные);
	КонецЕсли; 
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ УПРАВЛЕНИЯ ВНЕШНИМ ВИДОМ ФОРМЫ

Процедура УстановитьОбщиеФлажки(ОбщийФлажок = Истина, ФлажокГруппы = Истина)
	
	Если ОбщийФлажок Тогда
		
		ВсеСобытия = Истина;
		
		Для Каждого КлючИЗначение Из мСоответствияСобытий Цикл
			
			Если НЕ мНастройки[КлючИЗначение.Ключ] Тогда
				
				ВсеСобытия = Ложь;
				Прервать;
				
			КонецЕсли; 
			
		КонецЦикла; 
		
	КонецЕсли; 
	
	Если ФлажокГруппы Тогда
		
		ВсеСобытияТекущейГруппы = Истина;
		
	КонецЕсли; 
	
КонецПроцедуры // УстановитьОбщиеФлажки()

Процедура ОформитьСобытияПоУровнюРегистрации()
	
	ЦветСерый = WebЦвета.Серый;
	ЦветЧерный = WebЦвета.Черный;
	Для Каждого КлючИЗначение Из мУровниСобытий Цикл
		
		ИмяРеквизита = КлючИЗначение.Ключ;
		УровеньСобытия = КлючИЗначение.Значение;
		Инд = мМассивУровнейРегистрацийПоВажности.Найти(УровеньСобытия);
		Если (Инд + 1) <= УровеньРегистрации Тогда
			ЭлементыФормы[ИмяРеквизита].ЦветТекста = ЦветЧерный;
			ЭлементыФормы[ИмяРеквизита + "_Картинка"].Доступность = Истина; 
		Иначе
			ЭлементыФормы[ИмяРеквизита].ЦветТекста = ЦветСерый;
			ЭлементыФормы[ИмяРеквизита + "_Картинка"].Доступность = Ложь;
		КонецЕсли;            		
		
	КонецЦикла; 
	
КонецПроцедуры

Процедура ОформитьУровниРегистрацииЖР(ПередОткрытием = Ложь)
	
	ТекущийУровень = мНастройки["УровеньРегистрации"];
	ЖирныйШрифт = Новый Шрифт( , , Истина);
	ОбычныйШрифт = Новый Шрифт;
	Для А = 0 По 4 Цикл
		
		ЭлементыФормы["ПереключательУровеньРегистрации" + А].Шрифт = ?(ТекущийУровень = А, ЖирныйШрифт, ОбычныйШрифт);
		ЭлементыФормы["ПереключательУровеньРегистрации" + А].Подсказка = ?(ТекущийУровень = А, "Текущий уровень регистрации", "");
		
	КонецЦикла; 
	
	Если ПередОткрытием Тогда
		
		Макет = ПолучитьМакет("СобытияЖР");
		ТабДок_Картинки = Макет.ПолучитьОбласть("КартинкиУровней");
		
		Для А = 1 По 4 Цикл
			
			Если А = 1 Тогда
				
				УровеньСобытияТекст = "Примечание";
				
			ИначеЕсли А = 2 Тогда 
				
				УровеньСобытияТекст = "Информация";
				
			ИначеЕсли А = 3 Тогда 
				
				УровеньСобытияТекст = "Предупреждение";
				
			ИначеЕсли А = 4 Тогда 
				
				УровеньСобытияТекст = "Ошибка";
				
			КонецЕсли; 
			
			Для В = 0 По 4 Цикл
				
				ЭлементыФормы["КартинкаУровеньРегистрации" + В + А].Картинка = ТабДок_Картинки.Рисунки[УровеньСобытияТекст].Картинка; 
				ЭлементыФормы["КартинкаУровеньРегистрации" + В + А].Видимость = (А + В) >= 5; 			 
				
			КонецЦикла; 		 	
			
		КонецЦикла;  		
		
	КонецЕсли; 
	
КонецПроцедуры

Процедура ОформитьФормуПоВидуОтображения(ПередОткрытием = Ложь)
	
	ОформитьУровниРегистрацииЖР(ПередОткрытием);
	ЗаполнитьДеревоСобытий();
	ЭлементыФормы.ДеревоСобытий.НачальноеОтображениеДерева = НачальноеОтображениеДерева.РаскрыватьВерхнийУровень; 

	ОтобразитьИменаИлиСинонимыСобытий();
	УстановитьОбщиеФлажки(Истина, Ложь);
	
КонецПроцедуры

Процедура ОтобразитьИменаИлиСинонимыСобытий()
	
	Для Каждого СтрокаГруппа Из ДеревоСобытий.Строки[0].Строки Цикл
		Для Каждого СтрокаСобытие Из СтрокаГруппа.Строки Цикл
			СтрокаСобытие.Событие = ?(мЛиОтображатьИмена, мСоответствияСобытий[СтрокаСобытие.ИмяРеквизита].Имя,
				мСоответствияСобытий[СтрокаСобытие.ИмяРеквизита].Синоним);
		КонецЦикла; 
	КонецЦикла; 
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

Процедура ИнициализироватьИнформациюОСобытиях()
	
	мСоответствияСобытий = Новый Структура;
	мУровниСобытий = Новый Структура;
	мГруппыСобытий = Новый Структура;
	мКартинкиУровнейСобытий = Новый Соответствие;
	
	мСоответствияИменСинонимов = Новый ТаблицаЗначений;
	
	Макет = ПолучитьМакет("СобытияЖР");
	ТабДок_События = Макет.ПолучитьОбласть("СобытияЖР");
	ТабДок_Картинки = Макет.ПолучитьОбласть("КартинкиУровней");
	
	Для Каждого Рисунок Из ТабДок_Картинки.Рисунки Цикл
		
		мКартинкиУровнейСобытий.Вставить(УровеньЖурналаРегистрации[Рисунок.Имя], Рисунок.Картинка);
		
	КонецЦикла; 
	
	КоличествоЭлементов = ТабДок_События.ВысотаТаблицы;
	Для А = 1 По КоличествоЭлементов Цикл
		
		ИмяРеквизита = ТабДок_События.Область(А,1).Текст;
		ИмяСобытия = ТабДок_События.Область(А,2).Текст;
		СинонимСобытия = ТабДок_События.Область(А,3).Текст;
		УровеньСобытияТекст = ТабДок_События.Область(А,4).Текст;
		УровеньСобытия = УровеньЖурналаРегистрации[УровеньСобытияТекст];
		ГруппаСобытия = СтрЗаменить(ТабДок_События.Область(А,5).Текст, " ", "");
		ВесСобытия = Число(ТабДок_События.Область(А,6).Текст);
		
		Если НЕ мГруппыСобытий.Свойство(ГруппаСобытия) Тогда
			
			мГруппыСобытий.Вставить(ГруппаСобытия, Новый Массив);
			
		КонецЕсли;
		
		мГруппыСобытий[ГруппаСобытия].Добавить(ИмяРеквизита); 			
		
		мСоответствияСобытий.Вставить(ИмяРеквизита, Новый Структура("Имя, Синоним", ИмяСобытия, СинонимСобытия));
		мУровниСобытий.Вставить(ИмяРеквизита, УровеньСобытия);
		
		СтрокаГруппа = НайтиСоздатьГруппуВДеревеСобытий(ГруппаСобытия);
		СтрокаСобытие = СтрокаГруппа.Строки.Добавить();
		СтрокаСобытие.Событие = ?(мЛиОтображатьИмена, ИмяСобытия, СинонимСобытия);
		СтрокаСобытие.ИмяСобытия = ИмяСобытия;
		СтрокаСобытие.ИмяРеквизита = ИмяРеквизита;
		СтрокаСобытие.Вес = ВесСобытия;
		Если ИмяСобытия = констСобытиеДоступ_Доступ ИЛИ ИмяСобытия = констСобытиеДоступ_ОтказВДоступе Тогда
			Если ИмяСобытия = констСобытиеДоступ_Доступ Тогда
				констСтрокаДереваДоступ_Доступ = СтрокаСобытие;
			Иначе
				констСтрокаДереваДоступ_ОтказВДоступе = СтрокаСобытие;	
			КонецЕсли; 
			СтрокаСобытие.ДополнительнаяНастройка = "настроить";
		КонецЕсли; 
		
	КонецЦикла; 
	
КонецПроцедуры

Процедура ЗаполнитьПервоначальныеНастройки()
	
	мНастройки = Новый Структура;
	МассивРегистрация = ПолучитьИспользованиеЖурналаРегистрации();
	УровеньРегистрации = МассивРегистрация.Количество();
	мНастройки.Вставить("УровеньРегистрации", УровеньРегистрации);
	Для Каждого КлючИЗначение Из мСоответствияСобытий Цикл
		ИмяРеквизита = КлючИЗначение.Ключ;
		ИмяСобытия = КлючИЗначение.Значение.Имя;       
		//Антибаг (?) платформы 8.2.14-8.2.16 http://partners.v8.1c.ru/forum/thread.jsp?id=1080713  
		//метод ПолучитьИспользованиеЖурналаРегистрации не применим, так как Тип ИспользованиеСобытияЖурналаРегистрации не поддерживает обмен между клиентом и сервером
		ИспользованиеСобытия = ирСервер.ПолучитьИспользованиеСобытияЖурналаРегистрацииКакСтруктуру(ИмяСобытия);
		мНастройки.Вставить(ИмяРеквизита, ИспользованиеСобытия.Использование);
		Если ИмяСобытия = констСобытиеДоступ_Доступ Тогда
			ЭтаФорма.НастройкиДоступа = ИспользованиеСобытия.ОписаниеИспользования;
		ИначеЕсли ИмяСобытия = констСобытиеДоступ_ОтказВДоступе Тогда 
			ЭтаФорма.НастройкиОтказаВДоступе = ИспользованиеСобытия.ОписаниеИспользования;
		КонецЕсли;
	КонецЦикла; 
	
КонецПроцедуры

Процедура НастроитьДоступ(ЛиДоступ, Метаданные = Неопределено)
	
	ФормаНастройки = ПолучитьФорму("ФормаНастройкиДоступа", ЭтаФорма);
	ФормаНастройки.ЛиДоступ = ЛиДоступ;
	ФормаНастройки.ПереданныеНастройки = ?(ЛиДоступ, НастройкиДоступа, НастройкиОтказаВДоступе);
	Если Метаданные <> Неопределено Тогда
		ФормаНастройки.ТекущийОбъектМД = Метаданные[0];
	КонецЕсли; 
	Результат = ФормаНастройки.ОткрытьМодально();
	Если Результат <> Неопределено Тогда
		Модифицированность = Истина;
		Если Результат.Количество() = 0 Тогда
			Результат = Неопределено;
		КонецЕсли; 
		Если ЛиДоступ Тогда
			ЭтаФорма.НастройкиДоступа = Результат;
		Иначе
			ЭтаФорма.НастройкиОтказаВДоступе = Результат;
		КонецЕсли;
		УстановитьФлажкиДляСобытийДоступа();
	КонецЕсли;
	
КонецПроцедуры

Функция ПрименитьИзменившиесяНастройки()
	
	БылиОшибки = Ложь;
	ОчиститьСообщения();
	Если УровеньРегистрации <> мНастройки["УровеньРегистрации"]  Тогда
		Попытка
			Попытка
				УстановитьМонопольныйРежим(Истина);
			Исключение
				ВызватьИсключение;
			КонецПопытки;
			МассивУровней = Новый Массив();
			Для А = 0 По УровеньРегистрации - 1 Цикл
				МассивУровней.Добавить(мМассивУровнейРегистрацийПоВажности[А]); 
			КонецЦикла; 
			УстановитьИспользованиеЖурналаРегистрации(МассивУровней);
			мНастройки["УровеньРегистрации"] = УровеньРегистрации;
		Исключение
			СообщитьСТекущимВременем("Не удалось установить монопольный режим для изменения уровня регистрации событий!", СтатусСообщения.Важное);
			СообщитьСТекущимВременем(КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
			БылиОшибки = Истина;
		КонецПопытки;
	КонецЕсли; 
	Для Каждого КлючИЗначение Из мСоответствияСобытий Цикл
		ИмяРеквизита = КлючИЗначение.Ключ;
		ИмяСобытия = КлючИЗначение.Значение.Имя;
		ИспользованиеСобытия = Новый Структура("Использование, ОписаниеИспользования", мНастройки[ИмяРеквизита], Неопределено);
		Если Истина
			И мНастройки[ИмяРеквизита] 
			И ИмяСобытия = констСобытиеДоступ_Доступ
			//И мМенялисьНастройкиДоступа 
		Тогда
			ИспользованиеСобытия.ОписаниеИспользования = НастройкиДоступа;
		ИначеЕсли Истина
			И мНастройки[ИмяРеквизита] 
			И ИмяСобытия = констСобытиеДоступ_ОтказВДоступе 
			//И мМенялисьНастройкиОтказаВДоступе 
		Тогда
			ИспользованиеСобытия.ОписаниеИспользования = НастройкиОтказаВДоступе;
		КонецЕсли; 
		Попытка
			//Антибаг (?) платформы 8.2.14-8.2.16 http://partners.v8.1c.ru/forum/thread.jsp?id=1080713  
			//метод УстановитьИспользованиеСобытияЖурналаРегистрации не применим, так как Тип ИспользованиеСобытияЖурналаРегистрации не поддерживает обмен между клиентом и сервером
			ирСервер.УстановитьИспользованиеСобытияЖурналаРегистрацииПоСтруктуре(ИмяСобытия, ИспользованиеСобытия);
		Исключение
			БылиОшибки = Истина;
			СообщитьСТекущимВременем("Не удалось " + ?(мНастройки[ИмяРеквизита], "установить", "сбросить") + " использование события " + ИмяСобытия, СтатусСообщения.Важное);
			СообщитьСТекущимВременем(ОписаниеОшибки());
		КонецПопытки
	КонецЦикла; 
	
	Возврат НЕ БылиОшибки;
	
КонецФункции

Процедура СообщитьСТекущимВременем(Сообщение, Статус = Неопределено)
	
	Сообщить(Сообщение + " (" + Формат(ТекущаяДата(), "ДФ=HH:MM:ss") + ")", ?(Статус = Неопределено, СтатусСообщения.БезСтатуса, Статус));
	
КонецПроцедуры

Процедура ОчиститьНастройкиДоступаОтНеизвестныхМетаданных(пНастройкиДоступа)
	
	Если НЕ (ТипЗнч(пНастройкиДоступа) = Тип("Массив") И пНастройкиДоступа.Количество() > 1) Тогда
		пНастройкиДоступа = Неопределено;
	Иначе
		А = пНастройкиДоступа.ВГраница();
		Пока А > 0 Цикл
			Если НЕ ЕстьОбъектМетаданныхВКонфигурации(пНастройкиДоступа[А].Объект) Тогда
				пНастройкиДоступа.Удалить(А);
			КонецЕсли; 
			А = А - 1;
		КонецЦикла; 
		Если пНастройкиДоступа.Количество() = 0 Тогда
			пНастройкиДоступа = Неопределено;
		КонецЕсли; 
	КонецЕсли; 
	
КонецПроцедуры

Функция ЕстьОбъектМетаданныхВКонфигурации(ПолноеИмяОбъекта)
	
	Возврат Метаданные.НайтиПоПолномуИмени(ПолноеИмяОбъекта) <> Неопределено;
	
КонецФункции

Функция НайтиСоздатьГруппуВДеревеСобытий(ИмяГруппы)
	
	СтрокаГруппа = ДеревоСобытий.Строки[0].Строки.Найти(ИмяГруппы, "Событие");
	Если СтрокаГруппа = Неопределено Тогда		
		СтрокаГруппа = ДеревоСобытий.Строки[0].Строки.Добавить();
		СтрокаГруппа.Событие = ИмяГруппы; 		
	КонецЕсли; 
	
	Возврат СтрокаГруппа;
	
КонецФункции

Процедура ЗаполнитьДеревоСобытий()
	
	Для Каждого КлючИЗначение Из мСоответствияСобытий Цикл
		
		СтрокаДерева = ДеревоСобытий.Строки.Найти(КлючИЗначение.Ключ, "ИмяРеквизита", Истина);
		СтрокаДерева.Метка = мНастройки[КлючИЗначение.Ключ];
		
	КонецЦикла; 
	
	УстановитьФлажокСтрокиПоПодчиненным(ДеревоСобытий.Строки[0], Истина);
	
КонецПроцедуры

Процедура НадписьНастроитьДоступНажатие(Элемент)
	
	НастроитьДоступ(Истина);	
	
КонецПроцедуры

Процедура НадписьНастроитьОтказДоступаНажатие(Элемент)
	
	НастроитьДоступ(Ложь);
	
КонецПроцедуры

Процедура УстановитьФлажкиДляСобытийДоступа()
	
	Если НастройкиДоступа <> Неопределено Тогда
		мНастройки.Событие_Доступ_Доступ = Истина;
		констСтрокаДереваДоступ_Доступ.Метка = 1;
		УстановитьФлажкиРодителей(констСтрокаДереваДоступ_Доступ, Истина);
		УстановитьФлажкиПотомков(констСтрокаДереваДоступ_Доступ);
	КонецЕсли; 
	Если НастройкиОтказаВДоступе <> Неопределено Тогда
		мНастройки.Событие_Доступ_ОтказВДоступе = Истина;
		констСтрокаДереваДоступ_ОтказВДоступе.Метка = 1;
		УстановитьФлажкиРодителей(констСтрокаДереваДоступ_Доступ, Истина);
		УстановитьФлажкиПотомков(констСтрокаДереваДоступ_Доступ);
	КонецЕсли; 
		
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Если Модифицированность Тогда
		
		Ответ = Вопрос(НСтр("ru = 'Настройки были изменены. Уверены?'"), РежимДиалогаВопрос.ДаНет, 60);
		Отказ = (Ответ = КодВозвратаДиалога.Нет);	
		
	КонецЕсли;  
	
КонецПроцедуры

Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	
	Отказ = Не ПравоДоступа("Администрирование", Метаданные);
	Если Отказ Тогда
		Предупреждение("Настраивать журнал регистрации могут только пользователи с правом ""Администрирование""!");
		Возврат;
	КонецЕсли;  
	мЛиОтображатьИмена = ирОбщий.ВосстановитьЗначениеЛкс(Строка(Метаданные()) + ".Форма/ОтображатьИмена");
	Если мЛиОтображатьИмена = Неопределено Тогда
		мЛиОтображатьИмена = Ложь;		
	КонецЕсли; 
	ДеревоСобытий.Строки.Добавить().Событие = "Все события";
	ЭлементыФормы.ДеревоСобытий.Колонки.Событие.ОтображатьИерархию = Истина;
	ИнициализироватьИнформациюОСобытиях();
	ЗаполнитьПервоначальныеНастройки();		 
	ОформитьФормуПоВидуОтображения(Истина);
	
КонецПроцедуры

Процедура ПриЗакрытии()
	
	ирОбщий.СохранитьЗначениеЛкс(Строка(Метаданные()) + ".Форма/ОтображатьИмена", мЛиОтображатьИмена);
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ДЕЙСТВИЯ КОМАНДНЫХ ПАНЕЛЕЙ ФОРМЫ

Процедура КоманднаяПанель1ПеречитатьНастройки(Кнопка)
	
	Если Модифицированность Тогда
		Ответ = Вопрос(НСтр("ru = 'Будут перечитаны текущие настройки журнала. Уверены?'"), РежимДиалогаВопрос.ДаНет, 60);
		Если Ответ = КодВозвратаДиалога.Да Тогда
			ЗаполнитьПервоначальныеНастройки();
			Модифицированность = Ложь;
			ОформитьФормуПоВидуОтображения(); 
		КонецЕсли; 
	КонецЕсли; 
	
КонецПроцедуры

Процедура ОсновныеДействияФормыОсновныеДействияФормыПрименить(Кнопка)
	
	Если Не Модифицированность Тогда
		Возврат;
	КонецЕсли; 
	Если ПрименитьИзменившиесяНастройки() Тогда
		Модифицированность = Ложь;
		СообщитьСТекущимВременем("Настройки успешно применены!");
	Иначе
		Предупреждение("Не удалось применить некоторые настройки. Подробности в окне сообщений");
	КонецЕсли;  
	ОформитьУровниРегистрацииЖР();
	Обновить();
	
КонецПроцедуры

Процедура КоманднаяПанель1ПрочитатьИзФайла(Кнопка)
	
	Перем ИспользованиеСобытия;
	Перем лНастройкиДоступа;
	Перем лНастройкиОтказаВДоступе;
	Перем лУровеньРегистрации;
	
	Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	Диалог.ПолноеИмяФайла = "";
	Диалог.Фильтр = ирОбщий.ПолучитьСтрокуФильтраДляВыбораФайлаЛкс("xml", "Настройка журнала регистрации");
		
	Если Не Диалог.Выбрать() Тогда
		Возврат;		
	КонецЕсли;
	
	ОчиститьСообщения();
	
	БылаМодифицированность = Модифицированность;
	БылиНастройки = Новый Структура();
	
	Попытка
		
		ЧтениеХМЛ = Новый ЧтениеXML;
		ЧтениеХМЛ.ОткрытьФайл(Диалог.ПолноеИмяФайла);
		СтруктураИзФайла = СериализаторXDTO.ПрочитатьXML(ЧтениеХМЛ);
		Если СтруктураИзФайла <> Неопределено Тогда
			
			СтруктураИзФайла.Свойство("УровеньРегистрации", лУровеньРегистрации);
			Если лУровеньРегистрации <> Неопределено Тогда
				
				Модифицированность = УровеньРегистрации <> лУровеньРегистрации ИЛИ Модифицированность; 
				БылиНастройки.Вставить("УровеньРегистрации", УровеньРегистрации);
				УровеньРегистрации = лУровеньРегистрации;
				
			КонецЕсли;
			
			Для Каждого КлючИЗначение Из мСоответствияСобытий Цикл
				
				СтруктураИзФайла.Свойство(КлючИЗначение.Ключ, ИспользованиеСобытия);
				Если ИспользованиеСобытия <> Неопределено Тогда
					
					Модифицированность = мНастройки[КлючИЗначение.Ключ] <> ИспользованиеСобытия ИЛИ Модифицированность; 
					БылиНастройки.Вставить(КлючИЗначение.Ключ, мНастройки[КлючИЗначение.Ключ]);
					мНастройки[КлючИЗначение.Ключ] = ИспользованиеСобытия;
					
				КонецЕсли; 
				
				СтруктураИзФайла.Свойство("НастройкиДоступа", лНастройкиДоступа);
				БылиНастройки.Вставить("НастройкиДоступа", НастройкиДоступа);
				мМенялисьНастройкиДоступа = Ложь
											Или мМенялисьНастройкиДоступа
											Или НЕ (Истина 
												И НастройкиДоступа = Неопределено
												И лНастройкиДоступа = Неопределено);
				Модифицированность =  Модифицированность Или мМенялисьНастройкиДоступа;
				ЭтаФорма.НастройкиДоступа = лНастройкиДоступа;
				ОчиститьНастройкиДоступаОтНеизвестныхМетаданных(НастройкиДоступа);
				
				СтруктураИзФайла.Свойство("НастройкиОтказаВДоступе", лНастройкиОтказаВДоступе);
				БылиНастройки.Вставить("НастройкиОтказаВДоступе", НастройкиОтказаВДоступе);
				мМенялисьНастройкиОтказаВДоступе = Ложь
													Или мМенялисьНастройкиОтказаВДоступе 
													Или НЕ (Истина 
															И НастройкиОтказаВДоступе = Неопределено
															И лНастройкиОтказаВДоступе = Неопределено);
				Модифицированность = Модифицированность Или мМенялисьНастройкиОтказаВДоступе; 
				ЭтаФорма.НастройкиОтказаВДоступе = лНастройкиОтказаВДоступе;
				ОчиститьНастройкиДоступаОтНеизвестныхМетаданных(НастройкиОтказаВДоступе);
				
			КонецЦикла; 
			
		Иначе
			
			ВызватьИсключение "Неверный формат файла";
			
		КонецЕсли; 
		СообщитьСТекущимВременем("Настройки успешно прочитаны из файла", СтатусСообщения.Информация);
		ОформитьФормуПоВидуОтображения();
		
	Исключение
		
		ЧтениеХМЛ.Закрыть();
		СообщитьСТекущимВременем(ОписаниеОшибки());
		Модифицированность = БылаМодифицированность;
		ЗаполнитьЗначенияСвойств(ЭтаФорма, БылиНастройки); 
		Предупреждение("Не удалось прочитать настройки из файла!");
		
	КонецПопытки;
	
КонецПроцедуры

Процедура КоманднаяПанель1СохранитьВФайл(Кнопка)
	
	Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Сохранение);
	Диалог.ПолноеИмяФайла = "";
	Диалог.Фильтр = ирОбщий.ПолучитьСтрокуФильтраДляВыбораФайлаЛкс("xml", "Настройка журнала регистрации");
	
	Если Не Диалог.Выбрать() Тогда
		Возврат;		
	КонецЕсли;
	
	ОчиститьСообщения();
	
	Попытка
		
		ЗаписьХМЛ = Новый ЗаписьXML;
		ЗаписьХМЛ.ОткрытьФайл(Диалог.ПолноеИмяФайла);
		ЗаписьХМЛ.ЗаписатьОбъявлениеXML();
		СтруктураСобытий = Новый Структура;
		
		СтруктураСобытий.Вставить("УровеньРегистрации", УровеньРегистрации);
		
		Для Каждого КлючИЗначение Из мСоответствияСобытий Цикл
			
			СтруктураСобытий.Вставить(КлючИЗначение.Ключ, мНастройки[КлючИЗначение.Ключ]);
			
		КонецЦикла; 
		
		СтруктураСобытий.Вставить("НастройкиДоступа", НастройкиДоступа);
		СтруктураСобытий.Вставить("НастройкиОтказаВДоступе", НастройкиОтказаВДоступе);
		
		СериализаторXDTO.ЗаписатьXML(ЗаписьХМЛ, СтруктураСобытий);
		ЗаписьХМЛ.Закрыть();
		
		СообщитьСТекущимВременем("Настройки успешно сохранены в файл!", СтатусСообщения.Информация);
		
	Исключение
		
		ЗаписьХМЛ.Закрыть();
		СообщитьСТекущимВременем(ОписаниеОшибки());
		
	КонецПопытки;
	
КонецПроцедуры

Процедура КоманднаяПанель1ИмяИлиСиноним(Кнопка)
	
	мЛиОтображатьИмена = НЕ мЛиОтображатьИмена;
	ОтобразитьИменаИлиСинонимыСобытий();
	
КонецПроцедуры

Процедура КоманднаяПанельФормаОПодсистеме(Кнопка)
	ирОбщий.ОткрытьСправкуПоПодсистемеЛкс(ЭтотОбъект);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

Процедура СобытиеПриИзменении(Элемент)
	
	УстановитьОбщиеФлажки();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЧНЫХ ПОЛЕЙ ФОРМЫ

Процедура ДеревоСобытийПриИзмененииФлажка(Элемент, Колонка)
	
	ТекущаяСтрока = ЭлементыФормы.ДеревоСобытий.ТекущаяСтрока;
	Если ТекущаяСтрока <> Неопределено Тогда
		НоваяПометка = ?(ТекущаяСтрока.Метка = 0 ИЛИ ТекущаяСтрока.Метка = 2, 1, 0);
		УстановитьПометкуСтроки(ТекущаяСтрока, НоваяПометка);
	КонецЕсли;
	
КонецПроцедуры

Процедура УстановитьПометкуСтроки(Знач ТекущаяСтрока, НоваяПометка)
	
	Если ЭтоНеизменяемаяСтрока(ТекущаяСтрока) Тогда 
		Возврат;
	КонецЕсли; 
	ТекущаяСтрока.Метка = НоваяПометка;
	
	УстановитьФлажкиРодителей(ТекущаяСтрока, Истина);
	УстановитьФлажкиПотомков(ТекущаяСтрока);
	
	Для Каждого СтрокаГруппа Из ДеревоСобытий.Строки[0].Строки Цикл
		
		Для Каждого СтрокаСобытие Из СтрокаГруппа.Строки Цикл
			
			мНастройки[СтрокаСобытие.ИмяРеквизита] = СтрокаСобытие.Метка;	
			
		КонецЦикла; 
		
	КонецЦикла; 
	
	ЭтаФорма.Модифицированность = Истина;

КонецПроцедуры

Процедура ДеревоСобытийВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	Если Колонка = ЭлементыФормы.ДеревоСобытий.Колонки.ДополнительнаяНастройка Тогда
		СтандартнаяОбработка = Ложь;
		ОткрытьНастройкуДоступа(ВыбраннаяСтрока);
	КонецЕсли; 
	
КонецПроцедуры

Функция ОткрытьНастройкуДоступа(ВыбраннаяСтрока, Метаданные = Неопределено)

	Если ВыбраннаяСтрока = констСтрокаДереваДоступ_Доступ Тогда
		НастроитьДоступ(Истина, Метаданные);
	ИначеЕсли ВыбраннаяСтрока = констСтрокаДереваДоступ_ОтказВДоступе Тогда
		НастроитьДоступ(Ложь, Метаданные);
	КонецЕсли;
	Возврат Неопределено;

КонецФункции

Процедура ДеревоСобытийПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	
	ЦветСерый = WebЦвета.Серый;
	ЦветЧерный = WebЦвета.Черный;
	
	ОформлениеСтроки.Ячейки.Событие.УстановитьФлажок(ДанныеСтроки.Метка);
	Если ДанныеСтроки.ИмяРеквизита <> "" Тогда
		ОформлениеСтроки.Ячейки.Событие.УстановитьКартинку(мКартинкиУровнейСобытий[мУровниСобытий[ДанныеСтроки.ИмяРеквизита]]);		
		УровеньСобытия = мУровниСобытий[ДанныеСтроки.ИмяРеквизита]; 
		Инд = мМассивУровнейРегистрацийПоВажности.Найти(УровеньСобытия);
		Если (Инд + 1) <= УровеньРегистрации Тогда
			ОформлениеСтроки.Ячейки.Событие.ЦветТекста = ЦветЧерный;
		Иначе
			ОформлениеСтроки.Ячейки.Событие.ЦветТекста = ЦветСерый;
		КонецЕсли;            		
	КонецЕсли;

	Если ДанныеСтроки = констСтрокаДереваДоступ_Доступ Тогда
		ОформлениеСтроки.Ячейки.ДополнительнаяНастройка.ЦветТекста = ирОбщий.ПолучитьЦветСтиляЛкс("ирТекстИнформационнойНадписи");
		ОформлениеСтроки.Ячейки.ДополнительнаяНастройка.УстановитьТекст("настроить" + " (" + ?(НастройкиДоступа = Неопределено, "0", НастройкиДоступа.Количество()) + ")");
		ОформлениеСтроки.Ячейки.Событие.УстановитьТекст(ДанныеСтроки.Событие + ?(НастройкиДоступа <> Неопределено, " (регистрировать с отбором)", " (не регистрировать все)"));
	ИначеЕсли ДанныеСтроки = констСтрокаДереваДоступ_ОтказВДоступе Тогда
		ОформлениеСтроки.Ячейки.ДополнительнаяНастройка.ЦветТекста = ирОбщий.ПолучитьЦветСтиляЛкс("ирТекстИнформационнойНадписи");
		ОформлениеСтроки.Ячейки.ДополнительнаяНастройка.УстановитьТекст("настроить" + " (" + ?(НастройкиОтказаВДоступе = Неопределено, "0", НастройкиОтказаВДоступе.Количество()) + ")");
		ОформлениеСтроки.Ячейки.Событие.УстановитьТекст(ДанныеСтроки.Событие + ?(НастройкиОтказаВДоступе <> Неопределено, " (регистрировать с отбором)", " (регистрировать все)"));
	КонецЕсли; 
	Если ЭтоНеизменяемаяСтрока(ДанныеСтроки) Тогда
		ОформлениеСтроки.Ячейки.Событие.ТолькоПросмотр = Истина;
		ОформлениеСтроки.Ячейки.Событие.Флажок = Истина;
	КонецЕсли; 
	
КонецПроцедуры

Функция ЭтоНеизменяемаяСтрока(Знач ДанныеСтроки)

	// Антибан платформы. Эти события отключаются только при отключении уровня журнала регистрации Информация
	// http://devtool1c.ucoz.ru/forum/2-621-1
	// https://partners.v8.1c.ru/forum/t/1072717/m/1076891
	Возврат Ложь
		Или Найти(ДанныеСтроки.ИмяСобытия, "_$Transaction$_") > 0
		Или ДанныеСтроки.Событие = "Транзакция";

КонецФункции

Процедура ДеревоСобытийПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	
КонецПроцедуры   

Процедура КП_ДеревоСобытийАнализЖурнала(Кнопка)
	
	СтрокаДерева = ЭлементыФормы.ДеревоСобытий.ТекущаяСтрока;
	Если СтрокаДерева = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	Если СтрокаДерева.Строки.Количество() > 0 Тогда
		Возврат;
	КонецЕсли; 
	СтруктураОтбора = Новый Структура();
	СтруктураОтбора.Вставить("Событие", СтрокаДерева.ИмяСобытия);
	АнализЖурналаРегистрации = ирОбщий.ПолучитьОбъектПоПолномуИмениМетаданныхЛкс("Обработка.ирАнализЖурналаРегистрации");
	#Если Сервер И Не Сервер Тогда
		АнализЖурналаРегистрации = Обработки.ирАнализЖурналаРегистрации.Создать();
	#КонецЕсли
	АнализЖурналаРегистрации.ОткрытьСОтбором(, , СтруктураОтбора);
	
КонецПроцедуры

Процедура СтруктураКоманднойПанелиНажатие(Кнопка)
	
	ирОбщий.ОткрытьСтруктуруКоманднойПанелиЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	ирОбщий.ФормаОбработкаОповещенияЛкс(ЭтаФорма, ИмяСобытия, Параметр, Источник); 

КонецПроцедуры

Процедура КлсУниверсальнаяКомандаНажатие(Кнопка) Экспорт 
	
	ирОбщий.УниверсальнаяКомандаФормыЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура ОбработчикОжиданияСПараметрамиЛкс() Экспорт 
	
	ирОбщий.ОбработчикОжиданияСПараметрамиЛкс();

КонецПроцедуры

Процедура КоманднаяПанель1СтруктураФормы(Кнопка)
	
	ирОбщий.ОткрытьСтруктуруФормыЛкс(ЭтаФорма);
	
КонецПроцедуры

Процедура НастроитьПоВесу(МеньшеВеса)
	
	Для Каждого КорневаяСтрока Из ДеревоСобытий.Строки[0].Строки Цикл
		Для Каждого СтрокаСобытия Из КорневаяСтрока.Строки Цикл
			УстановитьПометкуСтроки(СтрокаСобытия, ?(СтрокаСобытия.Вес < МеньшеВеса, 1, 0));
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры

Процедура КП_ДеревоСобытийТяжелая(Кнопка)
	
	НастроитьПоВесу(9);
	
КонецПроцедуры

Процедура КП_ДеревоСобытийСредняя(Кнопка)
	
	НастроитьПоВесу(6);
	
КонецПроцедуры

Процедура КП_ДеревоСобытийЛегкая(Кнопка)
	
	НастроитьПоВесу(3);
	
КонецПроцедуры

Процедура КоманднаяПанельФормыОткрытьИТС(Кнопка)
	
	ирОбщий.ОткрытьСсылкуИТСЛкс("https://its.1c.ru/db/v?doc#bookmark:dev:TI000000823");
	
КонецПроцедуры

ирОбщий.ИнициализироватьФормуЛкс(ЭтаФорма, "Обработка.ирНастройкаЖурналаРегистрации.Форма.Форма");

констСобытиеДоступ_Доступ = "_$Access$_.Access";
констСобытиеДоступ_ОтказВДоступе = "_$Access$_.AccessDenied";

мМассивУровнейРегистрацийПоВажности = Новый Массив;
мМассивУровнейРегистрацийПоВажности.Добавить(УровеньЖурналаРегистрации.Ошибка);
мМассивУровнейРегистрацийПоВажности.Добавить(УровеньЖурналаРегистрации.Предупреждение);
мМассивУровнейРегистрацийПоВажности.Добавить(УровеньЖурналаРегистрации.Информация);
мМассивУровнейРегистрацийПоВажности.Добавить(УровеньЖурналаРегистрации.Примечание); 

констЖирныйШрифт = Новый Шрифт(, , Истина);
констОбычныйШрифт = Новый Шрифт;

