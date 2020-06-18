перем  мОстанавливатьПриходПриОшибке экспорт;


#Область Обмен
Функция   	ВыгрузитьНаСайт() Экспорт
	СтоСПОбмен_Посылки_income.ВыгрузитьПоступления_income(ЭтотОбъект);
КонецФункции

#КонецОбласти



#Область Проведение

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	#Область ПравильноеПроведение
	ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	Документы.Приходная.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	ДополнительныеСвойства.Вставить("ЭтоНовый",ЭтоНовый());
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
//	СтоСПОбмен_Общий.ОтразитьСтоСПОбмен(ДополнительныеСвойства, Движения, Отказ);
	
	СтоСПОбмен_Общий.ОтразитьСтоСПОбмен_РН(ДополнительныеСвойства, Движения, Отказ);
	СП_ДвиженияСервер.ОтразитьНеВыгруженноНаСайт(ДополнительныеСвойства, Движения, Отказ);
	СтоСПОбмен_Общий.ОтразитьСтоСПОбмен_РН_Ошибки(ДополнительныеСвойства, Движения, Отказ);	
	СП_ДвиженияСервер.ОтразитьЗаказыВПосылках(ДополнительныеСвойства, Движения, Отказ);
	
	Если Константы.НовоеХранениеОстатков.Получить() Тогда
		СП_ДвиженияСервер.ОтразитьДвиженияПоРегистру("ОстаткиНаСкладе", ДополнительныеСвойства, Движения, Отказ);
	КонецЕсли;	
	
	СП_ДвиженияСервер.ОтразитьОстаткиТоваров(ДополнительныеСвойства, Движения, Отказ);
	СП_ДвиженияСервер.ОтразитьПриход(ДополнительныеСвойства, Движения, Отказ);
	СП_ДвиженияСервер.ОтразитьТранзит(ДополнительныеСвойства, Движения, Отказ);
	//СП_ДвиженияСервер.ОтразитьКПолучению(ДополнительныеСвойства, Движения, Отказ);	
	СП_ДвиженияСервер.ОтразитьДвиженияПоРегистру("ШтрафныеЗаказы", ДополнительныеСвойства, Движения, Отказ);
	#КонецОбласти
	
	
	//ДвиженияСпОбмен(Отказ, РежимПроведения);
	//ДвигаемПоступлениеТранзита();

	ДвигаемНегабаритЗначения();
	ДвигаемПокупкиОтдельнымМестом(Отказ, РежимПроведения);
	Если Транзит Тогда
		//ДвигаемПоступлениеНаТранзит();
		ДвиженияСтатусыДоставки(Отказ, РежимПроведения);
		ДвиженияСтатусыДоставкиСвернуто(Отказ, РежимПроведения);

	//Иначе
		//ДвигаемПоступлениеНаСклад(отказ);
	КонецЕсли;
КонецПроцедуры

Процедура ДвиженияСтатусыДоставки(Отказ, Режим)
	
	
	Движения.СтатусыДоставки.Записывать = Истина;
	Для каждого стр из Покупки Цикл 
		Если ТипЗнч(Стр.Покупка)<> Тип("СправочникСсылка.Коробки") Тогда Возврат КонецЕсли;
		Движение = Движения.СтатусыДоставки.Добавить();
		Движение.Период = Дата;
		Движение.Груз = Стр.Покупка;
		Движение.Статус = Перечисления.СтатусыОтправкиГруза.НаСкладе;
	КонецЦикла;
КонецПроцедуры

Процедура ДвиженияСтатусыДоставкиСвернуто(Отказ, Режим)
	Движения.СтатусыДоставкиСвернуто.Записывать = Истина;
	
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	    "ВЫБРАТЬ
	 |	ЗНАЧЕНИЕ(Документ.ЗаявкаВТранспортнуюКомпанию.ПустаяСсылка) КАК ЗаявкаВТК,
	 |	СУММА(1) КАК КоличествоГС,
	 |	СУММА(ПриходнаяПокупки.Покупка.Количество) КАК Количество,
	 |	ПриходнаяПокупки.Ссылка.Дата КАК Период,
	 |	ЗНАЧЕНИЕ(Перечисление.СтатусыОтправкиГруза.НаСкладе) КАК Статус,
	 |	СУММА(0) КАК КоличествоМест
	 |ИЗ
	 |	Документ.Приходная.Покупки КАК ПриходнаяПокупки
	 |ГДЕ
	 |	ПриходнаяПокупки.Ссылка = &Ссылка
	 |	И ТИПЗНАЧЕНИЯ(ПриходнаяПокупки.Покупка) = ТИП(Справочник.Коробки)
	 |
	 |СГРУППИРОВАТЬ ПО
	 |	ПриходнаяПокупки.Ссылка.Дата";
	Запрос.Параметры.Вставить("Ссылка",Ссылка);
	РезультатЗапроса = Запрос.Выполнить();
	Движения.СтатусыДоставкиСвернуто.Загрузить(РезультатЗапроса.Выгрузить());

	
КонецПроцедуры

Процедура ДвигаемНегабаритЗначения()
	Движения.НегабаритЗначения.Записывать = Истина;
	Для Каждого ТекСтрокаПокупки Из Покупки Цикл
		Если ТекСтрокаПокупки.Габарит.НеГабарит Тогда
			Движение = Движения.НегабаритЗначения.Добавить();
			Движение.Покупка = ТекСтрокаПокупки.Покупка;
			Движение.Участник = ТекСтрокаПокупки.Участник;
			Движение.Габарит = ТекСтрокаПокупки.Габарит;
			Движение.Вес = ТекСтрокаПокупки.Вес;
			Движение.объем = ТекСтрокаПокупки.объем;
			Движение.Партия=Ссылка;
		КонецЕсли;
	КонецЦикла;
	Для Каждого ТекСтрокаПокупки Из Посылки Цикл
		Если ТекСтрокаПокупки.Габарит.НеГабарит Тогда
			Движение = Движения.НегабаритЗначения.Добавить();
			Движение.Покупка = ТекСтрокаПокупки.Посылка;
			Движение.Участник = ТекСтрокаПокупки.Посылка.Участник;
			Движение.Габарит = ТекСтрокаПокупки.Габарит;
			Движение.Вес = ТекСтрокаПокупки.Вес;
			Движение.объем = ТекСтрокаПокупки.объем;
			Движение.Партия=Ссылка;
		КонецЕсли;
	КонецЦикла;	
КонецПроцедуры

Процедура ДвигаемПокупкиОтдельнымМестом(Отказ, Режим)
	Движения.ПокупкиОтдельнымМестом.Записывать = Истина;
		//{{КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПриходнаяПокупки.Ссылка.Дата КАК Период,
		|	ПриходнаяПокупки.Покупка,
		|	ПриходнаяПокупки.Участник,
		|	МАКСИМУМ(ПриходнаяПокупки.ОтдельнымМестом) КАК ОтдельнымМестом
		|ИЗ
		|	Документ.Приходная.Покупки КАК ПриходнаяПокупки
		|ГДЕ
		|	ПриходнаяПокупки.Ссылка = &Ссылка
		|
		|СГРУППИРОВАТЬ ПО
		|	ПриходнаяПокупки.Участник,
		|	ПриходнаяПокупки.Покупка,
		|	ПриходнаяПокупки.Ссылка.Дата";
	Запрос.Параметры.Вставить("Ссылка",Ссылка);
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Движения.ПокупкиОтдельнымМестом.Загрузить(РезультатЗапроса.Выгрузить());
	//}}КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА

	//Для Каждого ТекСтрокаПокупки Из Покупки Цикл
	//	Движение = Движения.ПокупкиОтдельнымМестом.Добавить();
	//	Движение.Участник = ТекСтрокаПокупки.Участник;
	//	Движение.Покупка = ТекСтрокаПокупки.Покупка;
	//	Движение.ОтдельнымМестом = ТекСтрокаПокупки.ОтдельнымМестом;
	//КонецЦикла;
КонецПроцедуры

#КонецОбласти


#Область СобытияОбъекта

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	Если Константы.ПроверятьОтветственногоПриРасходе.Получить() Тогда
		ПроверяемыеРеквизиты.Добавить("Ответственный");	
	КонецЕсли;	
	Если Транзит Тогда
		НеПроверять	= "Организатор";
	Иначе
	    НеПроверять	= "ТочкаНазначения";
	КонецЕсли;	
	инд=ПроверяемыеРеквизиты.Найти(НеПроверять);
	Если инд<>Неопределено Тогда ПроверяемыеРеквизиты.Удалить(инд); КонецЕсли;
	
	НеПроверятьОрга=Истина;
	Для каждого стр из Покупки Цикл
		Если ТипЗнч(стр.Покупка)=Тип("СправочникСсылка.Покупки") Тогда
			НеПроверятьОрга=Ложь;
		КонецЕсли;	
	КонецЦикла;
	Если НеПроверятьОрга Тогда
		инд=ПроверяемыеРеквизиты.Найти("Организатор");
		Если инд<>Неопределено Тогда ПроверяемыеРеквизиты.Удалить(инд); КонецЕсли;
	КонецЕсли;	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	мОстанавливатьПриходПриОшибке=Константы.ОстанавливатьПриходПриОшибке.Получить();
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	Если не ЗначениеЗаполнено(СвояТочка) Тогда
		СвояТочка=Константы.СвояТочка.Получить();
	Конецесли;	
	Если Транзит Тогда
		Точка=ПунктВыдачи;
	Иначе
		Точка=СвояТочка;
	КонецЕсли;	
	Если не ЗначениеЗаполнено(Точка) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю( "Не выбрана точка раздачи!");
		Возврат;
	КонецЕсли;
	
	Ошибки=Неопределено;

	Для каждого стр из Покупки Цикл
		Если не Транзит и ТипЗнч(стр.Покупка)=Тип("СправочникСсылка.Коробки")  Тогда
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки,"Объект.Покупки[%1].Покупка","Нельзя поставить на приход коробку.Нужно либо поставить на транзит, либо Разобрать коробку.",,стр.НомерСтроки,,стр.НомерСтроки-1);
		КонецЕсли;	
		
		Если ЗначениеЗаполнено(стр.ШК) Тогда Продолжить; КонецЕсли;
		стр.ШК	= СП_Штрихкоды.ПолучитьМегаордер(стр.Покупка,стр.Участник,Точка);
	КонецЦикла;
	ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки,отказ);
	
	массПосылки = Посылки.НайтиСтроки(новый Структура("Посылка",Справочники.Посылки.ПустаяСсылка()));
	Для каждого пос из массПосылки Цикл
		Посылки.Удалить(пос);
	КонецЦикла	
КонецПроцедуры

#КонецОбласти

