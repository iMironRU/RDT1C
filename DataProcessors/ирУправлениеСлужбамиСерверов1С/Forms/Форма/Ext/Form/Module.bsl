﻿
// Можно улучшить отсюда https://infostart.ru/public/818909/

Перем мИмяСлужбыСобственногоАгента;

Процедура КнопкаВыполнитьНажатие(Кнопка)
	// Вставить содержимое обработчика.
КонецПроцедуры

Процедура Применить(Кнопка)
	
	Если Не ПроверитьЗаполнение() Тогда 
		Возврат;
	КонецЕсли; 
	ПрименитьИзменения();
	ОбновитьДанные();
	
КонецПроцедуры

Процедура КомпьютерПриИзменении(Элемент)
	
	ирОбщий.ПолеВводаСИсториейВыбора_ПриИзмененииЛкс(Элемент, ЭтаФорма);
	ОбновитьДанные();
	
КонецПроцедуры

Процедура КомпьютерНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)

	ирОбщий.ПолеВводаСИсториейВыбора_НачалоВыбораИзСпискаЛкс(Элемент, ЭтаФорма);
	
КонецПроцедуры

Процедура ДействияФормыОбновить(Кнопка)
	
	Если Не ЗапроситьПодтверждение() Тогда
		Возврат;
	КонецЕсли; 
	ОбновитьДанные();

КонецПроцедуры

Процедура ОбновитьДанные()
	
	Заполнить();
	Для Каждого ТипСлужбы Из мТипыСлужб Цикл
		ТабличноеПоле = ЭлементыФормы[ТипСлужбы.Значение.ИмяТабличнойЧасти];
		ТабличноеПоле.Колонки.СборкаПлатформыНовая.ЭлементУправления.СписокВыбора = СписокСборокПлатформы(ТипСлужбы.Ключ);
	КонецЦикла;
	ЭтаФорма.Модифицированность = Ложь;
	
КонецПроцедуры

Функция СписокСборокПлатформы(ИмяКомпоненты)
	
	ОтборСтрок = Новый Структура(ИмяКомпоненты, Истина);
	СтрокиСборок = СборкиПлатформы.НайтиСтроки(ОтборСтрок);
		#Если Сервер И Не Сервер Тогда
		    СтрокиСборок = СборкиПлатформы;
		#КонецЕсли
	СписокСборок = Новый СписокЗначений;
	Для Каждого СтрокаСборки Из СтрокиСборок Цикл
		Если СписокСборок.НайтиПоЗначению(СтрокаСборки.КлючСборки) = Неопределено Тогда
			СписокСборок.Добавить(СтрокаСборки.КлючСборки);
		КонецЕсли; 
	КонецЦикла;
	Возврат СписокСборок;

КонецФункции

Функция ЗапроситьПодтверждение()
	
	Результат = Истина;
	Если Модифицированность Тогда
		Ответ = Вопрос("Вы не применили изменения. Продолжить?", РежимДиалогаВопрос.ОКОтмена);
		Результат = Ответ = КодВозвратаДиалога.ОК;
	КонецЕсли; 
	Возврат Результат;

КонецФункции

Процедура ДействияФормыПерезапустить(Кнопка)

	Если Не ЗапроситьПодтверждение() Тогда
		Возврат;
	КонецЕсли; 
	Для НомерПрохода = 1 По 2 Цикл
		ТабличноеПолеТекущегоТипаСлужб = ТабличноеПолеТекущегоТипаСлужб();
		Для Каждого ВыделеннаяСтрока Из ТабличноеПолеТекущегоТипаСлужб.ВыделенныеСтроки Цикл
			ДанныеСтроки = ВыделеннаяСтрока;
			Если ДанныеСтроки.ЭтоНоваяСлужба Тогда
				Продолжить;
			КонецЕсли; 
			ИмяСлужбы = ДанныеСтроки.Имя;
			Если мИмяСлужбыСобственногоАгента = ДанныеСтроки.Имя Тогда
				Если НомерПрохода = 2 Тогда 
					Сообщить("Перезапуск собственной службы на порте " + Формат(ДанныеСтроки.Порт, "ЧГ="));
					ТекстКомандногоФайла = "
					|net stop """ + ИмяСлужбы + """
					|net start """ + ИмяСлужбы + """";
					КомандныйФай = ирОбщий.СоздатьСамоудаляющийсяКомандныйФайлЛкс(ТекстКомандногоФайла);
					ЗапуститьПриложение(КомандныйФай);
				КонецЕсли; 
			Иначе
				Если НомерПрохода = 1 Тогда 
					Сообщить("Перезапуск службы на порте " + Формат(ДанныеСтроки.Порт, "ЧГ="));
					Служба = ПолучитьWMIОбъектСлужбы(ДанныеСтроки.Имя, Компьютер);
					Если Служба.State <> "Stopped" Тогда
						Если ОстановитьСлужбу(ДанныеСтроки) Тогда 
							ЖдатьСекунд = 20;
							НачальнаяДата = ТекущаяДата();
							Пока ТекущаяДата() - НачальнаяДата < ЖдатьСекунд Цикл
								ОбновитьДанные();
								СтрокиСлужбы = ТабличноеПолеТекущегоТипаСлужб.Значение.НайтиСтроки(Новый Структура("Имя", ИмяСлужбы));
								Если СтрокиСлужбы.Количество() = 0 Тогда
									Возврат;
								КонецЕсли;
								ДанныеСтроки = СтрокиСлужбы[0];
								ТабличноеПолеТекущегоТипаСлужб.ТекущаяСтрока = ДанныеСтроки;
								Если Не ЗначениеЗаполнено(ДанныеСтроки.ИдентификаторПроцесса) Тогда
									Прервать;
								КонецЕсли; 
							КонецЦикла;
						КонецЕсли; 
					КонецЕсли; 
					РезультатКоманды = Служба.StartService();
					Если РезультатКоманды <> 0 Тогда
						Если РезультатКоманды = 2 Тогда
							Сообщить("Недостаточно прав. Запустите приложение от имени администратора или используйте оснастку управления службами.", СтатусСообщения.Внимание);
						Иначе
							Сообщить("Код ошибки = " + РезультатКоманды + ",  https://msdn.microsoft.com/ru-ru/library/aa393660(v=vs.85).aspx", СтатусСообщения.Внимание);
						КонецЕсли; 
					КонецЕсли; 
				КонецЕсли; 
			КонецЕсли; 
		КонецЦикла;
	КонецЦикла;
	ОбновитьДанные();
	
КонецПроцедуры

Процедура ДействияФормыОстановить(Кнопка)

	Если Не ЗапроситьПодтверждение() Тогда
		Возврат;
	КонецЕсли; 
	Для Каждого ВыделеннаяСтрока Из ТабличноеПолеТекущегоТипаСлужб().ВыделенныеСтроки Цикл
		ДанныеСтроки = ВыделеннаяСтрока;
		Если ДанныеСтроки.ЭтоНоваяСлужба Тогда
			Прервать;;
		КонецЕсли; 
		Сообщить("Остановка службы на порте " + Формат(ДанныеСтроки.Порт, "ЧГ="));
		ОстановитьСлужбу(ДанныеСтроки);
	КонецЦикла;
	ОбновитьДанные();
	
КонецПроцедуры

Функция ТабличноеПолеТекущегоТипаСлужб()
	
	Возврат ЭлементыФормы[ЭлементыФормы.ПанельТипыСлужб.ТекущаяСтраница.Имя];

КонецФункции

Функция ОстановитьСлужбу(Знач ДанныеСтроки)
	
	Служба = ПолучитьWMIОбъектСлужбы(ДанныеСтроки.Имя, Компьютер);
	РезультатКоманды = Служба.StopService();
	Если РезультатКоманды <> 0 Тогда
		// Расшифровка кодов 
		Если РезультатКоманды = 2 Тогда
			Сообщить("Недостаточно прав", СтатусСообщения.Внимание);
		Иначе
			Сообщить("Код ошибки = " + РезультатКоманды + ", https://msdn.microsoft.com/ru-ru/library/aa393673(v=vs.85).aspx", СтатусСообщения.Внимание);
		КонецЕсли; 
		Возврат Ложь;
	Иначе
		Возврат Истина;
	КонецЕсли;
	
КонецФункции

Процедура ДействияФормыОПодсистеме(Кнопка)
	
	ирОбщий.ОткрытьСправкуПоПодсистемеЛкс(ЭтотОбъект);
	
КонецПроцедуры

Процедура ДействияФормыСтруктураФормы(Кнопка)
	
	ирОбщий.ОткрытьСтруктуруФормыЛкс(ЭтаФорма);
	
КонецПроцедуры

Процедура ПриОткрытии()
	
	ЭтаФорма.ОтАдминистратора = ирКэш.ВКОбщая().IsAdmin();
	ирСервер.ПолучитьПараметрыПроцессаАгентаСервера(1, 1, мИмяСлужбыСобственногоАгента);
	СписокВыбора = ЭлементыФормы.СлужбыАгентовСерверов.Колонки.РежимОтладки.ЭлементУправления.СписокВыбора;
	#Если Сервер И Не Сервер Тогда
	    СписокВыбора = Новый СписокЗначений;
	#КонецЕсли
	СписокВыбора.Добавить("нет");
	СписокВыбора.Добавить("tcp");
	СписокВыбора.Добавить("http");
	Для Каждого ТипСлужбы Из мТипыСлужб Цикл
		ТипСлужбы = ТипСлужбы.Значение;
		ТабличноеПоле = ЭлементыФормы[ТипСлужбы.ИмяТабличнойЧасти];
		СписокВыбора = ТабличноеПоле.Колонки.Порт.ЭлементУправления.СписокВыбора;
		#Если Сервер И Не Сервер Тогда
		    СписокВыбора = Новый СписокЗначений;
		#КонецЕсли
		СписокВыбора.Добавить(ТипСлужбы.ПортПоУмолчанию);
		СписокВыбора.Добавить(ТипСлужбы.ПортПоУмолчанию + 1000);
		СписокВыбора.Добавить(ТипСлужбы.ПортПоУмолчанию + 2000);
		СписокВыбора.Добавить(ТипСлужбы.ПортПоУмолчанию + 3000);
		СписокВыбора.Добавить(ТипСлужбы.ПортПоУмолчанию + 4000);
	КонецЦикла;
	ОбновитьДанные();
	
КонецПроцедуры

Процедура СлужбыПередУдалением(Элемент, Отказ)
	
	Отказ = Не Элемент.ТекущиеДанные.ЭтоНоваяСлужба;
	Если Отказ Тогда
		Ответ = Вопрос("Вы действительно хотите пометить службу """ + Элемент.ТекущиеДанные.Имя + """ на удаление?", РежимДиалогаВопрос.ОКОтмена);
		Если Ответ = КодВозвратаДиалога.ОК Тогда
			Элемент.ТекущиеДанные.Удалить = Истина;
		КонецЕсли;
	КонецЕсли; 

КонецПроцедуры

Процедура СлужбыАгентовСерверов1СПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока Тогда
		ОписаниеТипаСлужба = мТипыСлужб.АгентСервера;
		Элемент.ТекущиеДанные.ТипСлужбы = ОписаниеТипаСлужба.ТипСлужбы;
		Элемент.ТекущиеДанные.РежимОтладки = "tcp";
		Элемент.ТекущиеДанные.КаталогКонфигурации = "<Авто>";
		Элемент.ТекущиеДанные.НачальныйПортРабочихПроцессов = "<Авто>";
		Элемент.ТекущиеДанные.КонечныйПортРабочихПроцессов = "<Авто>";
		
		Элемент.ТекущиеДанные.ЭтоНоваяСлужба = Истина;
		Элемент.ТекущиеДанные.Автозапуск = Истина;
		Элемент.ТекущиеДанные.Имя = "<Авто>";
		Элемент.ТекущиеДанные.Представление = "<Авто>";
		Элемент.ТекущиеДанные.Порт = ОписаниеТипаСлужба.ПортПоУмолчанию;
	КонецЕсли; 

КонецПроцедуры

Процедура СтруктураКоманднойПанелиНажатие(Кнопка)
	
	ирОбщий.ОткрытьСтруктуруКоманднойПанелиЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура СлужбыАгентовСерверов1СПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	
	Если ДанныеСтроки.Имя = мИмяСлужбыСобственногоАгента Тогда
		ОформлениеСтроки.ЦветФона = WebЦвета.СветлоНебесноГолубой;
	КонецЕсли; 
	ОформлениеСтроки.Ячейки.ПарольПользователя.УстановитьТекст("*****");
	ОформлениеСтроки.Ячейки.СерверОтладкиПароль.УстановитьТекст("*****");
	ОформлениеСтроки.Ячейки.ГруппаСборкаПлатформы.Видимость = Ложь;
	ОформлениеСтроки.Ячейки.ГруппаПортыРабочихПроцессов.Видимость = Ложь;
	ОформлениеСтроки.Ячейки.ГруппаОтладка.Видимость = Ложь;
	
КонецПроцедуры

Процедура КаталогНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	Если Не ирОбщий.ЭтоИмяЛокальногоСервераЛкс(Компьютер) Тогда
		Сообщить("Выбор файлов доступен только при локальном выполнении");
	Иначе
		ирОбщий.ВыбратьКаталогВФормеЛкс(Элемент.Значение, ЭтаФорма);
	КонецЕсли; 
	
КонецПроцедуры

Процедура СлужбыАгентовСерверов1СИмяПользователяНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ФормаВыбораПользователяWindows = ирКэш.Получить().ПолучитьФорму("ВыборПользователяWindows",, ЭтаФорма);
	ФормаВыбораПользователяWindows.ВыбранныйПользовательWindows = СтрЗаменить(Элемент.Значение, ".\", "\\" + ИмяКомпьютера() + "\");
	Результат = ФормаВыбораПользователяWindows.ОткрытьМодально();
	Если Результат <> Неопределено Тогда
		Результат = СтрЗаменить(Результат, "\\" + ИмяКомпьютера() + "\", ".\");
		Элемент.Значение = Результат;
	КонецЕсли; 
	
КонецПроцедуры

Процедура ДействияФормыОткрытьОснасткуУправленияСлужбами(Кнопка)
	
	ирОбщий.ПолучитьТекстРезультатаКомандыОСЛкс("services.msc",,, Истина);

КонецПроцедуры

Процедура СлужбыАгентовСерверов1ССборкаПлатформыНоваяНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	НовыйКаталог = ирОбщий.ВыбратьКаталогВФормеЛкс(Элемент.Значение);
	Если ЗначениеЗаполнено(НовыйКаталог) Тогда
		ирОбщий.ИнтерактивноЗаписатьВЭлементУправленияЛкс(Элемент, НовыйКаталог);
	КонецЕсли; 
	
КонецПроцедуры

Процедура ДействияФормыЗапуститьОтАдминистратора(Кнопка)
	
	ирОбщий.ЗапуститьСеансПодПользователемЛкс(ИмяПользователя(),,, "ОбычноеПриложение",,,,,,,, Истина);

КонецПроцедуры

Процедура СлужбыАгентовСерверов1СПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	ОбновитьСтрокуЗапускаСлужбы(Элемент.ТекущаяСтрока);
	
КонецПроцедуры

Процедура СлужбыАдминистрированияСерверовПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	ОбновитьСтрокуЗапускаСлужбы(Элемент.ТекущаяСтрока);

КонецПроцедуры

Процедура СлужбыСерверовОтладкиПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	ОбновитьСтрокуЗапускаСлужбы(Элемент.ТекущаяСтрока);

КонецПроцедуры

Процедура СлужбыХранилищКонфигурацийПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	ОбновитьСтрокуЗапускаСлужбы(Элемент.ТекущаяСтрока);
	
КонецПроцедуры

Процедура ДействияФормыКонсольСерверов(Кнопка)
	
	ТаблицаСерверов = СлужбыАгентовСерверов.Выгрузить();
	ТаблицаСерверов.Колонки.Добавить("Компьютер");
	ТаблицаСерверов.ЗаполнитьЗначения(ИмяКомпьютера(), "Компьютер");
	Если ЭлементыФормы.СлужбыАгентовСерверов.ТекущаяСтрока <> Неопределено Тогда
		ТекущаяСтрока = ТаблицаСерверов[СлужбыАгентовСерверов.Индекс(ЭлементыФормы.СлужбыАгентовСерверов.ТекущаяСтрока)];
	КонецЕсли; 
	ОткрытьКонсольСерверов1С(ТаблицаСерверов, ТекущаяСтрока);
	
КонецПроцедуры

Процедура ОбновлениеОтображения()
	
	ирОбщий.ОбновитьЗаголовкиСтраницПанелейЛкс(ЭтаФорма);
	
КонецПроцедуры

Процедура СлужбыАдминистрированияСерверовПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	
	ОформлениеСтроки.Ячейки.ПарольПользователя.УстановитьТекст("*****");
	ОформлениеСтроки.Ячейки.ГруппаСборкаПлатформы.Видимость = Ложь;

КонецПроцедуры

Процедура СлужбыАдминистрированияСерверовПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока Тогда
		ЗаполнитьНовуюСтрокуСлужбы(Элемент, мТипыСлужб.СерверАдминистрирования);
		Элемент.ТекущиеДанные.РежимКластера = Истина;
	КонецЕсли; 

КонецПроцедуры

Процедура СлужбыСерверовОтладкиПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока Тогда
		ЗаполнитьНовуюСтрокуСлужбы(Элемент, мТипыСлужб.СерверОтладки);
	КонецЕсли; 
	
КонецПроцедуры

Процедура СлужбыХранилищКонфигурацийПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока Тогда
		ЗаполнитьНовуюСтрокуСлужбы(Элемент, мТипыСлужб.СерверХранилища);
	КонецЕсли; 
	
КонецПроцедуры

Процедура ЗаполнитьНовуюСтрокуСлужбы(Элемент, ОписаниеТипаСлужба)
	
	Элемент.ТекущиеДанные.ТипСлужбы = ОписаниеТипаСлужба.ТипСлужбы;
	Элемент.ТекущиеДанные.ЭтоНоваяСлужба = Истина;
	Элемент.ТекущиеДанные.Автозапуск = Истина;
	Элемент.ТекущиеДанные.Имя = "<Авто>";
	Элемент.ТекущиеДанные.Представление = "<Авто>";
	Элемент.ТекущиеДанные.Порт = ОписаниеТипаСлужба.ПортПоУмолчанию;

КонецПроцедуры

Процедура КоманднаяПанельСборкиПлатформыОбновить(Кнопка)
	
	ирОбщий.ЗаполнитьДоступныеСборкиПлатформыЛкс(СборкиПлатформы, Компьютер);
	Для Каждого ТипСлужбы Из мТипыСлужб Цикл
		ТипСлужбы = ТипСлужбы.Значение;
		ТабличноеПоле = ЭлементыФормы[ТипСлужбы.ИмяТабличнойЧасти];
		ТабличноеПоле.Колонки.СборкаПлатформыНовая.ЭлементУправления.СписокВыбора = СписокСборокПлатформы(ТипСлужбы.ТипСлужбы);
	КонецЦикла;
	
КонецПроцедуры

Процедура СлужбыХранилищКонфигурацийКаталогХранилищаОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если ирОбщий.ЭтоИмяЛокальногоСервераЛкс(Компьютер) И ЗначениеЗаполнено(Элемент.Значение) Тогда
		ЗапуститьПриложение(Элемент.Значение);
	КонецЕсли; 
	
КонецПроцедуры

Процедура СлужбыАгентовСерверовКаталогКонфигурацииОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если ирОбщий.ЭтоИмяЛокальногоСервераЛкс(Компьютер) И ЗначениеЗаполнено(Элемент.Значение) Тогда
		ЗапуститьПриложение(Элемент.Значение);
	КонецЕсли; 

КонецПроцедуры

Процедура СлужбыСерверовАдминистрированияСтрокаСоединенияАгентаСервераНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	
	Если ирОбщий.ЭтоИмяЛокальногоСервераЛкс(Компьютер) Тогда
		СписокВыбора = Новый СписокЗначений;
		Для Каждого СтрокаАгента Из СлужбыАгентовСерверов.НайтиСтроки(Новый Структура("Удалить", Ложь)) Цикл
			СписокВыбора.Добавить(Компьютер + ":" + XMLСтрока(ПортСтрокиСлужбы(СтрокаАгента)));
		КонецЦикла;
		Элемент.СписокВыбора = СписокВыбора;
	КонецЕсли; 

КонецПроцедуры

Процедура СборкиПлатформыВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	Если ирОбщий.ЭтоИмяЛокальногоСервераЛкс(Компьютер) И ВыбраннаяСтрока.ФайлыСуществуют Тогда
		ЗапуститьПриложение(ВыбраннаяСтрока.Каталог);
	КонецЕсли; 
	
КонецПроцедуры

ирОбщий.ИнициализироватьФормуЛкс(ЭтаФорма, "Обработка.ирУправлениеСлужбамиСерверов1С.Форма.Форма");
