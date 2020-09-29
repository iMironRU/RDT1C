﻿Перем мИмяСлужебногоПоля;
Перем мПредставленияТиповВыражений;
Перем ДиалектSQL Экспорт;
Перем ПараметрыДиалектаSQL;
Перем мТекстПолейГруппировки;

// @@@.КЛАСС.ПолеТекстовогоДокументаСКонтекстнойПодсказкой
Процедура КлсПолеТекстовогоДокументаСКонтекстнойПодсказкойНажатие(Кнопка)
	
	#Если Сервер И Не Сервер Тогда
		ПодсказкаПоляТекстаВыражения = Обработки.ирКлсПолеТекстовогоДокументаСКонтекстнойПодсказкой.Создать();
	#КонецЕсли
	Если Кнопка = ирОбщий.ПолучитьКнопкуКоманднойПанелиЭкземпляраКомпонентыЛкс(ПодсказкаПоляТекстаВыражения, "ПерейтиКОпределению") Тогда
		ТекущееВыражение = ПодсказкаПоляТекстаВыражения.ПолучитьТекущееОбъектноеВыражение();
		Если Лев(ТекущееВыражение, 1) = "&" Тогда
			ИмяПараметра = Сред(ТекущееВыражение, 2);
			ДоступныйПараметр = ЭлементыФормы.ДоступныеПоля.Значение.НайтиПоле(Новый ПолеКомпоновкиДанных("ПараметрыДанных." + ИмяПараметра));
			Если ДоступныйПараметр <> Неопределено Тогда
				ЭлементыФормы.ДоступныеПоля.ТекущаяСтрока = ДоступныйПараметр;
				ПараметрСхемы = Параметры.Найти(ирОбщий.ПоследнийФрагментЛкс(ДоступныйПараметр.Поле));
				Если ПараметрСхемы <> Неопределено Тогда
					//Если ПараметрСхемы.Выражение <> "" Тогда
					//	Попытка 
					//		ЗначениеПараметра = Вычислить(ПараметрСхемы.Выражение);
					//		ОткрытьЗначение(ЗначениеПараметра);
					//	Исключение
					//		ирОбщий.СообщитьСУчетомМодальностиЛкс("Ошибка при вычислении параметра """ + ПараметрСхемы.ИмяПараметра + """"
					//			+ Символы.ПС + ОписаниеОшибки(), МодальныйРежим, СтатусСообщения.Важное);
					//	КонецПопытки;
					//Иначе
						ЗначениеПараметра = ПараметрСхемы.Значение;
						ОткрытьЗначение(ЗначениеПараметра);
					//КонецЕсли;
				КонецЕсли; 
			КонецЕсли;
			Возврат;
		Иначе
			ДоступноеПоле = ЭлементыФормы.ДоступныеПоля.Значение.НайтиПоле(Новый ПолеКомпоновкиДанных(ТекущееВыражение));
			Если ДоступноеПоле <> Неопределено Тогда
				ЭлементыФормы.ДоступныеПоля.ТекущаяСтрока = ДоступноеПоле;
			КонецЕсли; 
		КонецЕсли; 
	ИначеЕсли Кнопка = ирОбщий.ПолучитьКнопкуКоманднойПанелиЭкземпляраКомпонентыЛкс(ПодсказкаПоляТекстаВыражения, "КонструкторЗапросовИР") Тогда
		Если ПустаяСтрока(ЭлементыФормы.ПолеТекстаВыражения.ВыделенныйТекст) Тогда
			ПодсказкаПоляТекстаВыражения.ПолучитьНомерТекущейСтроки();
			КонструкторВложенногоЗапроса = ПолучитьКонструкторВложенногоЗапроса("ВЫБРАТЬ *");
			РезультатФормы = КонструкторВложенногоЗапроса.ОткрытьМодально();
			Если РезультатФормы <> Неопределено Тогда
				ЭлементыФормы.ПолеТекстаВыражения.ВыделенныйТекст = "(" + КонструкторВложенногоЗапроса.Текст + ")";
				ЭтаФорма.Модифицированность = Истина;
				КоманднаяПанельТекстаОбновитьЗапросы();
			КонецЕсли;
		Иначе
			Сообщить("Эта кнопка здесь служит только для создания запросов. Для открытия существующего запроса используйте список запросов");
		КонецЕсли; 
		Возврат;
	КонецЕсли;
	ПодсказкаПоляТекстаВыражения.Нажатие(Кнопка);
	
КонецПроцедуры

// @@@.КЛАСС.ПолеТекстовогоДокументаСКонтекстнойПодсказкой
Процедура ВнешнееСобытие(Источник, Событие, Данные)
	
	#Если Сервер И Не Сервер Тогда
	    ПодсказкаПоляТекстаВыражения = Обработки.ирКлсПолеТекстовогоДокументаСКонтекстнойПодсказкой.Создать();
	#КонецЕсли
	ПодсказкаПоляТекстаВыражения.ВнешнееСобытиеОбъекта(Источник, Событие, Данные);
	
КонецПроцедуры

Процедура ПриОткрытии()
	
	ирКэш.Получить().ИнициализацияОписанияМетодовИСвойств();
	// +++.КЛАСС.ПолеТекстовогоДокументаСКонтекстнойПодсказкой
	ПодсказкаПоляТекстаВыражения.Инициализировать(,
		ЭтаФорма, ЭлементыФормы.ПолеТекстаВыражения, ЭлементыФормы.КоманднаяПанельТекста, 1, "ПроверитьВыражение", ЭтаФорма, "Выражение");
	#Если Сервер И Не Сервер Тогда
		ПодсказкаПоляТекстаВыражения = Обработки.ирКлсПолеТекстовогоДокументаСКонтекстнойПодсказкой.Создать();
	#КонецЕсли
	//ПодсказкаПоляТекстаВыражения.ЭтоЧастичныйЗапрос = Истина;
	ирОбщий.ЗагрузитьВТаблицуЗначенийЛкс(ОбработкаОбъект.ДоступныеТаблицы, ПодсказкаПоляТекстаВыражения.ДоступныеТаблицы);
	// ---.КЛАСС.ПолеТекстовогоДокументаСКонтекстнойПодсказкой
	
	СтрокаПредставленияТипаВыражения = мПредставленияТиповВыражений.НайтиПоЗначению(ТипВыражения);
	Если СтрокаПредставленияТипаВыражения <> Неопределено Тогда
		ирОбщий.ОбновитьТекстПослеМаркераВСтрокеЛкс(ЭтаФорма.Заголовок,, СтрокаПредставленияТипаВыражения.Представление);
	КонецЕсли; 
	Если мДиалектыSQL <> Неопределено Тогда
		ПараметрыДиалектаSQL = мДиалектыSQL.Найти(ДиалектSQL, "Диалект");
		ЭлементыФормы.КПЗапросы.Кнопки.ПеренестиВоВременнуюТаблицу.Доступность = Истина
			И ПараметрыДиалектаSQL.ВременныеТаблицы 
			И ПараметрыДиалектаSQL.Пакет;
	КонецЕсли; 
	УстановитьСхемуКомпоновки();
	//мПлатформа = ирКэш.Получить();
	Если ирОбщий.СтрокиРавныЛкс(мДиалектSQL, "1С") Тогда
		СтруктураТипаКонтекста = мПлатформа.НоваяСтруктураТипа();
		СтруктураТипаКонтекста.ИмяОбщегоТипа = "Локальный";
		СписокСлов = мПлатформа.ПолучитьВнутреннююТаблицуПредопределенныхСлов(СтруктураТипаКонтекста,,,,1);
		//ТаблицаСлов = мПлатформа.ПолучитьВнутреннююТаблицуПредопределенныхСлов(СтруктураТипа, 1);
		Для Каждого СтрокаСлова Из СписокСлов Цикл
			Если Не ирОбщий.СтрокиРавныЛкс(СтрокаСлова.ТипСлова, "Метод") Тогда
				Продолжить;
			КонецЕсли; 
			СтрокаФункции = ТаблицаФункций.Добавить();
			СтрокаФункции.Функция = СтрокаСлова.Слово;
			СтрокаФункции.СтруктураТипа = СтрокаСлова.ТаблицаСтруктурТипов[0];
		КонецЦикла;
	КонецЕсли; 
	Если ТипЗнч(ВладелецФормы) = Тип("Форма") Тогда
		ВладелецФормы.Панель.Доступность = Ложь;
	КонецЕсли;
	ДоступныеПоляГруппировки = Новый Массив;
	Для Каждого ПапкаДоступныхПолей Из КомпоновщикНастроек.Настройки.ДоступныеПоляГруппировок.Элементы Цикл
		Для Каждого ДоступноеПоле Из ПапкаДоступныхПолей.Элементы Цикл
			Если Истина
				И ДоступноеПоле.ТипЗначения.СодержитТип(Тип("Строка"))
				И ДоступноеПоле.ТипЗначения.КвалификаторыСтроки.Длина = 0
			Тогда
				// По логике таких тут быть не должно, но они почему то есть
				Продолжить;
			КонецЕсли; 
			ДоступныеПоляГруппировки.Добавить("" + ДоступноеПоле.Поле);
		КонецЦикла;
	КонецЦикла;
	мТекстПолейГруппировки = ирОбщий.СтрСоединитьЛкс(ДоступныеПоляГруппировки, ", ");
	ЭлементыФормы.ПолеТекстаВыражения.УстановитьТекст(Выражение);
	ДоступноеПоле = КомпоновщикНастроек.Настройки.ДоступныеПоляОтбора.НайтиПоле(Новый ПолеКомпоновкиДанных(Выражение));
	Если ДоступноеПоле <> Неопределено Тогда
		ЭлементыФормы.ДоступныеПоля.ТекущаяСтрока = ДоступноеПоле;
		// https://partners.v8.1c.ru/forum/t/1625925/m/1625925
		ПодключитьОбработчикОжидания("УстановитьВыделениеОтложенно", 0.1, Истина);
	КонецЕсли; 
	КоманднаяПанельТекстаОбновитьЗапросы();

КонецПроцедуры

Процедура УстановитьВыделениеОтложенно()
	
	ирОбщий.ЗаменитьИВыделитьВыделенныйТекстПоляЛкс(ЭтаФорма, ЭлементыФормы.ПолеТекстаВыражения);
	
КонецПроцедуры

Функция УстановитьСхемуКомпоновки()
	
	ТекстПроверочногоЗапроса = ПолучитьТекстПроверочногоЗапроса(, Истина);
	Если ТекстПроверочногоЗапроса = Неопределено Тогда
		ОбновитьКонтекстнуюПодсказку();
		Возврат Неопределено;
	КонецЕсли;
	КомпоновщикНастроек = Новый КомпоновщикНастроекКомпоновкиДанных;
	СхемаКомпоновки = Новый СхемаКомпоновкиДанных;
	ИсточникДанных = ирОбщий.ДобавитьЛокальныйИсточникДанныхЛкс(СхемаКомпоновки);
	НаборДанных = СхемаКомпоновки.НаборыДанных.Добавить(Тип("НаборДанныхЗапросСхемыКомпоновкиДанных"));
	НаборДанных.ИсточникДанных = ИсточникДанных.Имя;
	НаборДанных.Запрос = ТекстПроверочногоЗапроса;
	НаборДанных.АвтоЗаполнениеДоступныхПолей = Истина;
	ПолеНабора = НаборДанных.Поля.Добавить(Тип("ПолеНабораДанныхСхемыКомпоновкиДанных"));
	ПолеНабора.Поле = мИмяСлужебногоПоля;
	ПолеНабора.ПутьКДанным = мИмяСлужебногоПоля;
	ПолеНабора.ОграничениеИспользования.Условие = Истина;
	Если Параметры = Неопределено Тогда
		ирОбщий.СообщитьСУчетомМодальностиЛкс("Не передана таблица параметров", МодальныйРежим, СтатусСообщения.Внимание);
		Возврат Неопределено;
	КонецЕсли; 
	Для Каждого CтрокаПараметра Из Параметры Цикл
		ПараметрСхемы = СхемаКомпоновки.Параметры.Добавить();
		ПараметрСхемы.Имя = CтрокаПараметра.Имя;
		ПараметрСхемы.ТипЗначения = CтрокаПараметра.ТипЗначения;
	КонецЦикла;
	Попытка
		КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(СхемаКомпоновки));
	Исключение
		ОписаниеОшибки = ОписаниеОшибки(); // Чтобы в отладчике сразу была понятна причина ошибки
	КонецПопытки; 
	ОбновитьКонтекстнуюПодсказку();
	
КонецФункции

Процедура ОбновитьКонтекстнуюПодсказку()
	
	ПодсказкаПоляТекстаВыражения.ОбновитьКонтекстВыраженияЗапросаПоНастройкеКомпоновкиЛкс(КомпоновщикНастроек.Настройки);
	
КонецПроцедуры

Процедура ПриЗакрытии()
	
	// +++.КЛАСС.ПолеТекстовогоДокументаСКонтекстнойПодсказкой
	ПодсказкаПоляТекстаВыражения.Уничтожить();
	// ---.КЛАСС.ПолеТекстовогоДокументаСКонтекстнойПодсказкой
	
	Если ТипЗнч(ВладелецФормы) = Тип("Форма") Тогда
		ВладелецФормы.Панель.Доступность = Истина;
	КонецЕсли;
	
КонецПроцедуры

Функция СохранитьИзменения()

	Если Не ПодсказкаПоляТекстаВыражения.ПроверитьПрограммныйКод() Тогда 
		Ответ = Вопрос("Выражение содержит ошибки. Продолжить?", РежимДиалогаВопрос.ОКОтмена);
		Если Ответ <> КодВозвратаДиалога.ОК Тогда
			Возврат Ложь;
		КонецЕсли;
	КонецЕсли; 
	Текст = ЭлементыФормы.ПолеТекстаВыражения.ПолучитьТекст();
	Если Не МодальныйРежим Тогда
		ирОбщий.ПоместитьТекстВБуферОбменаОСЛкс(Текст, "ЯзыкЗапросов");
	КонецЕсли;
	Модифицированность = Ложь;
	Закрыть(Текст);
	Возврат Истина;

КонецФункции // СохранитьИзменения()

Процедура ОсновныеДействияФормыОК(Кнопка)
	
	СохранитьИзменения();
	
КонецПроцедуры

// Выполняет программный код в контексте.
//
// Параметры:
//  ТекстДляВыполнения – Строка;
//  *ЛиСинтаксическийКонтроль - Булево, *Ложь - признак вызова только для синтаксического контроля.
//
Функция ПроверитьВыражение(ТекстДляПроверки, ЛиСинтаксическийКонтроль = Ложь) Экспорт
	
	КоманднаяПанельТекстаОбновитьЗапросы();
	Если мДиалектSQL = "1С" Тогда
		ПроверочныйЗапрос = Новый Запрос;
		ПроверочныйЗапрос.Текст = ПолучитьТекстПроверочногоЗапроса(ТекстДляПроверки);
		ПроверочныйЗапрос.НайтиПараметры(); // Здесь будет возникать ошибка
	КонецЕсли; 

КонецФункции // ВычислитьВФорме()

Функция ПолучитьТекстПроверочногоЗапроса(Знач ТекстДляПроверки = "", ДляСхемы = Ложь)
	
	Если Истина
		И ДляСхемы
		И КомпоновщикНастроек.Настройки.ДоступныеПоляОтбора.Элементы.Количество() > 0
	Тогда
		Возврат Неопределено;
	КонецЕсли; 
	Если Не ЗначениеЗаполнено(ТекстДляПроверки) Тогда
		ТекстДляПроверки = ЭлементыФормы.ПолеТекстаВыражения.ПолучитьТекст();
	КонецЕсли; 

	Если ТипВыражения = "ПараметрВиртуальнойТаблицы" Тогда
		Если Не ЗначениеЗаполнено(ШаблонПолноеИмяТаблицы) Тогда
			ВызватьИсключение "Не задан параметр ""ШаблонПолноеИмяТаблицы""";
		КонецЕсли; 
		Если Не ЗначениеЗаполнено(ШаблонНомерПараметра) Тогда
			ВызватьИсключение "Не задан параметр ""ШаблонНомерПараметра""";
		КонецЕсли; 
		Запятые = ирОбщий.СтрокаПовторомЛкс(",", ШаблонНомерПараметра - 1);
		ТекстЗапроса = "ВЫБРАТЬ 1 КАК " + мИмяСлужебногоПоля + " ИЗ " + ШаблонПолноеИмяТаблицы + "(" + Запятые + "
		|" + ТекстДляПроверки + "
		|) КАК Т";
	ИначеЕсли ТипВыражения = "УсловиеОтбора" Тогда
		Если ШаблонТекстИЗ = Неопределено Тогда
			ВызватьИсключение "Не задан параметр ""ШаблонТекстИЗ""";
		КонецЕсли; 
		Если Истина
			И ДляСхемы
			И Не ЗначениеЗаполнено(ТекстДляПроверки) 
		Тогда
			ТекстДляПроверки = "1=1";
		КонецЕсли; 
		ТекстЗапроса = "ВЫБРАТЬ 1 ";
		Если ЗначениеЗаполнено(ШаблонТекстИЗ) Тогда
			ТекстЗапроса = ТекстЗапроса + "ИЗ " + ШаблонТекстИЗ;
		КонецЕсли;
		Если ЕстьАгрегаты И Не АгрегатыЗапрещены Тогда
			ТекстЗапроса = ТекстЗапроса + " 
			|СГРУППИРОВАТЬ ПО " + мТекстПолейГруппировки + "
			|ИМЕЮЩИЕ ";
		Иначе
			ТекстЗапроса = ТекстЗапроса + " 
			|ГДЕ ";
		КонецЕсли; 
		ТекстЗапроса = ТекстЗапроса + " 
		|(" + ТекстДляПроверки + ")";
	ИначеЕсли ТипВыражения = "ВыбранноеПоле" Тогда
		Если ШаблонТекстИЗ = Неопределено Тогда
			ВызватьИсключение "Не задан параметр ""ШаблонТекстИЗ""";
		КонецЕсли; 
		Если Истина
			И ДляСхемы
			И Не ЗначениеЗаполнено(ТекстДляПроверки) 
		Тогда
			ТекстДляПроверки = "1";
		КонецЕсли; 
		ТекстЗапроса = "ВЫБРАТЬ 
		|(" + ТекстДляПроверки + ") 
		|КАК " + мИмяСлужебногоПоля + " ";
		Если ЗначениеЗаполнено(ШаблонТекстИЗ) Тогда
			ТекстЗапроса = ТекстЗапроса + "ИЗ " + ШаблонТекстИЗ;
		КонецЕсли; 
	ИначеЕсли ТипВыражения = "ПолеИтога" Тогда
		//Если Не ЗначениеЗаполнено(ШаблонТекстЗапроса) Тогда
		//	ВызватьИсключение "Не задан параметр ""ШаблонТекстЗапроса""";
		//КонецЕсли; 
		//ТекстЗапроса = ШаблонТекстЗапроса + " ИТОГИ
		ТекстЗапроса = "ВЫБРАТЬ 1 КАК " + мИмяСлужебногоПоля + " ИТОГИ
		|(" + ТекстДляПроверки + ")
		| КАК " + мИмяСлужебногоПоля + " ПО ОБЩИЕ";
	Иначе
		ТекстЗапроса = "";
	КонецЕсли; 
	Возврат ТекстЗапроса;

КонецФункции

Процедура ДоступныеПоляНачалоПеретаскивания(Элемент, ПараметрыПеретаскивания, Выполнение)
	
	ЗначениеПеретаскивания = ВыражениеДоступногоПоля();
	Если ЗначениеЗаполнено(ЗначениеПеретаскивания) Тогда
		ПараметрыПеретаскивания.Значение = ЗначениеПеретаскивания;
	Иначе
		ПараметрыПеретаскивания.ДопустимыеДействия = ДопустимыеДействияПеретаскивания.НеОбрабатывать;
	КонецЕсли; 
	
КонецПроцедуры

Функция ВыражениеДоступногоПоля()
	
	Элемент = ЭлементыФормы.ДоступныеПоля;
	НрегПервыйФрагмент = ирОбщий.ПервыйФрагментЛкс(НРег(Элемент.ТекущаяСтрока.Поле));
	Если НрегПервыйФрагмент = НРег("ПараметрыДанных") Тогда
		ЗначениеПеретаскивания = ПараметрыДиалектаSQL.ПрефиксПараметра + ирОбщий.ПоследнийФрагментЛкс(Элемент.ТекущаяСтрока.Поле);
	ИначеЕсли Истина
		И ТипВыражения <> "ПолеИтога"
		И НрегПервыйФрагмент = НРег("СистемныеПоля") 
	Тогда
		//
	Иначе
		ЗначениеПеретаскивания = Элемент.ТекущаяСтрока.Поле;
	КонецЕсли;
	Возврат ЗначениеПеретаскивания;

КонецФункции

Процедура КоманднаяПанельТекстаСсылкаНаОбъектБД(Кнопка)
	
	//ПолеВстроенногоЯзыка.ВставитьСсылкуНаОбъектБД(СхемаКомпоновки, "");
	
КонецПроцедуры

Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Ответ = ирОбщий.ЗапроситьСохранениеДанныхФормыЛкс(ЭтаФорма);
	Отказ = Ответ = КодВозвратаДиалога.Отмена;
	Если Ответ = КодВозвратаДиалога.Да Тогда
		Отказ = Не СохранитьИзменения();
	КонецЕсли;
	
КонецПроцедуры

Процедура КонтекстноеМенюФункцийСинтаксПомощник(Кнопка)
	
	ТекущаяСтрокаФункций = ЭлементыФормы.ТаблицаФункций.ТекущаяСтрока;
	Если ТекущаяСтрокаФункций = Неопределено Тогда
		Возврат;
	КонецЕсли;
	СтруктураТипа = ТекущаяСтрокаФункций.СтруктураТипа;
	Если СтруктураТипа <> Неопределено Тогда
		СтрокаОписания = СтруктураТипа.СтрокаОписания;
		Если СтрокаОписания <> Неопределено Тогда
			ирОбщий.ОткрытьСтраницуСинтаксПомощникаЛкс(СтрокаОписания.ПутьКОписанию, , ЭтаФорма);
		КонецЕсли; 
	КонецЕсли; 

КонецПроцедуры

Процедура ТаблицаФункцийНачалоПеретаскивания(Элемент, ПараметрыПеретаскивания, Выполнение)
	
	ПараметрыПеретаскивания.Значение = Элемент.ТекущаяСтрока.Функция + "()";
	
КонецПроцедуры

Процедура ПриПолученииДанныхДоступныхПолей(Элемент, ОформленияСтрок)

	ирОбщий.ПриПолученииДанныхДоступныхПолейКомпоновкиЛкс(ОформленияСтрок);

КонецПроцедуры // ПриПолученииДанныхДоступныхПолей()

Процедура КоманднаяПанельТекстаОбновитьЗапросы(Кнопка = Неопределено)
	
	//ТекстПроверочногоЗапроса = ПолучитьТекстПроверочногоЗапроса();
	ТекстВыражения = ЭлементыФормы.ПолеТекстаВыражения.ПолучитьТекст();
	Если ПустаяСтрока(ТекстВыражения) Тогда
		ТекстВыражения = "1";
	КонецЕсли; 
	ТекстПроверочногоЗапроса = "ВЫБРАТЬ 
	|" + ТекстВыражения;
	СлужебноеПолеТекстовогоДокумента.УстановитьТекст(ТекстПроверочногоЗапроса);
	НачальныйТокен = РазобратьТекстЗапроса(ТекстПроверочногоЗапроса,,, СлужебноеПолеТекстовогоДокумента); // Здесь важно получать полное, а не сокращенное дерево, т.к. нужно ЕстьАгрегаты
	Запросы.Очистить();
	Если НачальныйТокен <> Неопределено Тогда
		ЗаполнитьСписокЗапросовПоТокену(НачальныйТокен);
		ЭтаФорма.ЕстьАгрегаты = Ложь;
		Попытка
			КонструкторЗапроса.СобратьВыражениеЗапроса(НачальныйТокен,,,,,, ЕстьАгрегаты);
		Исключение
			// если не ловить исключение, то при открытии некорректного текста с расширенной проверкой форма не показывается и сразу закрывается
			ОписаниеОшибки = ОписаниеОшибки();
		КонецПопытки; 
	КонецЕсли; 
	
КонецПроцедуры

Функция ЗаполнитьСписокЗапросовПоТокену(Знач Токен) Экспорт
	
	Данные = Токен.Data;
	Если Данные = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	ИмяПравила = Данные.ParentRule.RuleNonterminal.Text;
	Если ИмяПравила = "<EmbeddedRoot>" Тогда
		CтрокаЗапроса = Запросы.Добавить();
		CтрокаЗапроса.Номер = Запросы.Количество();
		CтрокаЗапроса.Текст = ПолучитьТекстИзТокена(Токен, CтрокаЗапроса.НачальнаяСтрока, CтрокаЗапроса.НачальнаяКолонка,
			CтрокаЗапроса.КонечнаяСтрока, CтрокаЗапроса.КонечнаяКолонка);
	Иначе
		Для ИндексТокена = 0 По Данные.TokenCount - 1 Цикл
			ТокенВниз = Данные.Tokens(Данные.TokenCount - 1 - ИндексТокена);
			Если ТокенВниз.Kind = 0 Тогда
				ПсевдонимСнизу = ЗаполнитьСписокЗапросовПоТокену(ТокенВниз);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли; 
	
КонецФункции

Процедура ЗапросыВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	ИндексТекущейСтроки = Запросы.Индекс(ВыбраннаяСтрока);
	КоманднаяПанельТекстаОбновитьЗапросы();
	Если ИндексТекущейСтроки >= Запросы.Количество() Тогда
		Возврат;
	КонецЕсли; 
	ВыбраннаяСтрока = Запросы[ИндексТекущейСтроки];
	КонструкторВложенногоЗапроса = ПолучитьКонструкторВложенногоЗапроса(ВыбраннаяСтрока.Текст);
	РезультатФормы = КонструкторВложенногоЗапроса.ОткрытьМодально();
	Если РезультатФормы <> Неопределено Тогда
		ЭлементыФормы.ПолеТекстаВыражения.УстановитьГраницыВыделения(ВыбраннаяСтрока.НачальнаяСтрока - 1, ВыбраннаяСтрока.НачальнаяКолонка,
			ВыбраннаяСтрока.КонечнаяСтрока - 1, ВыбраннаяСтрока.КонечнаяКолонка);
		ЭлементыФормы.ПолеТекстаВыражения.ВыделенныйТекст = КонструкторВложенногоЗапроса.Текст;
		ЭтаФорма.Модифицированность = Истина;
		КоманднаяПанельТекстаОбновитьЗапросы();
	КонецЕсли; 
	
КонецПроцедуры

Функция ПолучитьКонструкторВложенногоЗапроса(Знач Текст = "")
	
	КонструкторВложенногоЗапроса = ПолучитьФорму("КонструкторЗапроса");
	ЗагрузитьТекстВКонструктор(Текст, КонструкторВложенногоЗапроса);
	Если КонструкторЗапроса <> Неопределено Тогда
		ЗаполнитьЗначенияСвойств(КонструкторВложенногоЗапроса, КонструкторЗапроса, "РасширеннаяПроверка, Английский1С, ТабличноеПолеКорневогоПакета, ПоказыватьИндексы");
	КонецЕсли;
	Возврат КонструкторВложенногоЗапроса;

КонецФункции

Процедура КПЗапросыПеренестиВоВременнуюТаблицу(Кнопка)

	ВыбраннаяСтрока = ЭлементыФормы.Запросы.ТекущаяСтрока;
	Если ВыбраннаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	КонструкторВложенногоЗапроса = ПолучитьКонструкторВложенногоЗапроса(ВыбраннаяСтрока.Текст);
	Если Не КонструкторЗапроса.ЛиПакетныйЗапрос Тогда
		КонструкторЗапроса.ЛиПакетныйЗапрос = Истина;
		КонструкторЗапроса.ЛиПакетныйЗапросПриИзменении();
	КонецЕсли; 
	ЗапросПакета = КонструкторЗапроса.ЗапросыПакета.Вставить(КонструкторЗапроса.ЗапросыПакета.Индекс(КонструкторЗапроса.ЭлементыФормы.ЗапросыПакета.ТекущаяСтрока));
	ЗаполнитьЗначенияСвойств(ЗапросПакета, КонструкторВложенногоЗапроса.ЗапросыПакета[0]);
	КонструкторЗапроса.ОбновитьНаименованиеЗапроса(ЗапросПакета);
	ЗапросПакета.ТипЗапроса = 1;
	ЗапросПакета.ИмяОсновнойТаблицы = мПлатформа.ИдентификаторИзПредставленияЛкс(ЗапросПакета.Имя);
	КонструкторЗапроса.ОбновитьДоступныеВременныеТаблицы();
	ТекстВыбор = "";
	Для Каждого ВыбранноеПоле Из ЗапросПакета.ЧастиОбъединения[0].ВыбранныеПоля Цикл
		Если ТекстВыбор <> "" Тогда
			ТекстВыбор = ТекстВыбор + ", ";
		КонецЕсли; 
		ТекстВыбор = ТекстВыбор + ЗапросПакета.ИмяОсновнойТаблицы + "." + ВыбранноеПоле.Имя;
	КонецЦикла; 
	ЭлементыФормы.ПолеТекстаВыражения.УстановитьГраницыВыделения(ВыбраннаяСтрока.НачальнаяСтрока - 1, ВыбраннаяСтрока.НачальнаяКолонка,
		ВыбраннаяСтрока.КонечнаяСтрока - 1, ВыбраннаяСтрока.КонечнаяКолонка);
	ЭлементыФормы.ПолеТекстаВыражения.ВыделенныйТекст = 
		КонструкторЗапроса.ПолучитьСловоЯзыкаЗапросов("SELECT") + " " + ТекстВыбор + " " + КонструкторЗапроса.ПолучитьСловоЯзыкаЗапросов("FROM") + " " 
		+ ЗапросПакета.ИмяОсновнойТаблицы + " " + КонструкторЗапроса.ПолучитьСловоЯзыкаЗапросов("AS") + " " + ЗапросПакета.ИмяОсновнойТаблицы;
	КоманднаяПанельТекстаОбновитьЗапросы();
	
КонецПроцедуры

Процедура СтруктураКоманднойПанелиНажатие(Кнопка)
	
	ирОбщий.ОткрытьСтруктуруКоманднойПанелиЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура ОсновныеДействияФормыСтруктураФормы(Кнопка)
	
	ирОбщий.ОткрытьСтруктуруФормыЛкс(ЭтаФорма);
	
КонецПроцедуры

Процедура ДоступныеПоляВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ирОбщий.ЗаменитьИВыделитьВыделенныйТекстПоляЛкс(ЭтаФорма, ЭлементыФормы.ПолеТекстаВыражения, ВыражениеДоступногоПоля());
	
КонецПроцедуры

Процедура КоманднаяПанельТекстаВыделитьВсе(Кнопка)
	
	ЭлементыФормы.ПолеТекстаВыражения.УстановитьГраницыВыделения(1, 1 + СтрДлина(ЭлементыФормы.ПолеТекстаВыражения.ПолучитьТекст()));
	ЭтаФорма.ТекущийЭлемент = ЭлементыФормы.ПолеТекстаВыражения;
	
КонецПроцедуры

Процедура ТаблицаФункцийВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	Если ВыбраннаяСтрока.Функция = "ЕСТЬNULL" Тогда
		ВыделенныйТекст = ЭлементыФормы.ПолеТекстаВыражения.ВыделенныйТекст;
		ВыделенныйТекст = СтрЗаменить(ВыделенныйТекст, мПараметрыДиалектаSQL.ПрефиксПараметра, "ПараметрыДанных.");
		ДоступноеПоле = КомпоновщикНастроек.Настройки.ДоступныеПоляОтбора.НайтиПоле(Новый ПолеКомпоновкиДанных(ВыделенныйТекст));
		Если ДоступноеПоле <> Неопределено Тогда
			ПустоеЗначениеПоля = ДоступноеПоле.ТипЗначения.ПривестиЗначение();
			НовыйТекст = "ЕСТЬNULL(" + ЭлементыФормы.ПолеТекстаВыражения.ВыделенныйТекст + ", " + ирОбщий.ПустоеЗначениеПоТипуНаЯзыкеЗапросовЛкс(ТипЗнч(ПустоеЗначениеПоля), ДоступноеПоле.ТипЗначения) + ")";
			ирОбщий.ЗаменитьИВыделитьВыделенныйТекстПоляЛкс(ЭтаФорма, ЭлементыФормы.ПолеТекстаВыражения, НовыйТекст);
			Возврат;
		КонецЕсли; 
	КонецЕсли; 
	ирОбщий.ЗаменитьИВыделитьВыделенныйТекстПоляЛкс(ЭтаФорма, ЭлементыФормы.ПолеТекстаВыражения, ВыбраннаяСтрока.Функция + "(" + ЭлементыФормы.ПолеТекстаВыражения.ВыделенныйТекст + ")");
	
КонецПроцедуры

#Если Сервер И Не Сервер Тогда
	ПриПолученииДанныхДоступныхПолей();
#КонецЕсли
ирОбщий.ПодключитьОбработчикиСобытийДоступныхПолейКомпоновкиЛкс(ЭлементыФормы.ДоступныеПоля);

Запросы.Колонки.Добавить("НачальнаяКолонка", Новый ОписаниеТипов("Число"));
Запросы.Колонки.Добавить("НачальнаяСтрока", Новый ОписаниеТипов("Число"));
Запросы.Колонки.Добавить("КонечнаяКолонка", Новый ОписаниеТипов("Число"));
Запросы.Колонки.Добавить("КонечнаяСтрока", Новый ОписаниеТипов("Число"));
ЭтаФорма.ТипВыражения = "Параметр";
мПредставленияТиповВыражений = Новый СписокЗначений;
мПредставленияТиповВыражений.Добавить("УсловиеОтбора", "Отбор");
мПредставленияТиповВыражений.Добавить("ПараметрВиртуальнойТаблицы", "Параметр таблицы");
мПредставленияТиповВыражений.Добавить("УсловиеСвязи", "Связь таблиц");
мПредставленияТиповВыражений.Добавить("ВыбранноеПоле", "Выбранное поле");
мПредставленияТиповВыражений.Добавить("Группировка", "Группировка");
мПредставленияТиповВыражений.Добавить("ПолеИтога", "Итоги");

ТаблицаФункций.Колонки.Добавить("СтруктураТипа");
мИмяСлужебногоПоля = "_СлужебноеПоле48198";

ирОбщий.ИнициализироватьФормуЛкс(ЭтаФорма, "Обработка.ирКлсПолеТекстовогоДокументаСКонтекстнойПодсказкой.Форма.КонструкторВыраженияЗапроса");
