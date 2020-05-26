Процедура ЗаполнитьЗаказамиДруихТочек() Экспорт
	стрВозврата=СтоСПОбмен_ГруппыДоставки.ЗаказыДругихТочек_ПроверитьОстатки();	
	Если стрВозврата.Авторизация Тогда
		ПокупкиТранзит.Загрузить(стрВозврата.ЗаказыДругихТочек);
		ВидОперации=Перечисления.ВидыОпераций_ДвижениеТранзита.ТранзитНаТранзит;
		Комментарий="Друнгая точка сбора. Автоматически.";
	КонецЕсли
КонецПроцедуры


Процедура ЗаполнитьЗаказамиДляВозврата(МассДляОтправления) Экспорт
	Если МассДляОтправления.Количество()=0 Тогда
		Возврат;
	КонецЕсли; 	
	ГД=МассДляОтправления[0];
	//Перепроводим Документы по группам из которых удаляли заказы чтоб они вернулись на транзит
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ОтправлениеТранзита.Ссылка КАК Ссылка
		|ИЗ
		|	Документ.ОтправлениеТранзита КАК ОтправлениеТранзита
		|ГДЕ
		|	ОтправлениеТранзита.Проведен
		|	И ОтправлениеТранзита.Коробка = &ГД";
	
	Запрос.УстановитьПараметр("ГД", ГД);
	РезультатЗапроса = Запрос.Выполнить();
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		об=Выборка.Ссылка.ПолучитьОбъект();
		Попытка
			об.Записать(РежимЗаписиДокумента.Проведение);
		Исключение
			ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(ОписаниеОшибки());
		КонецПопытки;
	КонецЦикла;
	
	//Находим что удаляли из данной группы
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЗапросыГруппДоставкиЗапросыИсключения.Покупка КАК Покупка,
		|	ЗапросыГруппДоставкиЗапросыИсключения.Участник КАК Участник
		|ПОМЕСТИТЬ Заказы
		|ИЗ
		|	Документ.ЗапросыГруппДоставки.ЗапросыИсключения КАК ЗапросыГруппДоставкиЗапросыИсключения
		|ГДЕ
		|	ЗапросыГруппДоставкиЗапросыИсключения.Успех
		|	И ЗапросыГруппДоставкиЗапросыИсключения.ГруппаДоставки = &ГД
		|
		|СГРУППИРОВАТЬ ПО
		|	ЗапросыГруппДоставкиЗапросыИсключения.Покупка,
		|	ЗапросыГруппДоставкиЗапросыИсключения.Участник
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Заказы.Покупка КАК Покупка,
		|	Заказы.Участник КАК Участник,
		|	ТранзитОстатки.Габарит КАК Габарит,
		|	ТранзитОстатки.МестоХранения КАК МестоХранения,
		|	ТранзитОстатки.Партия КАК Партия,
		|	ТранзитОстатки.Точка КАК Точка,
		|	ТранзитОстатки.КоличествоОстаток КАК Количество
		|ИЗ
		|	Заказы КАК Заказы
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.Транзит.Остатки КАК ТранзитОстатки
		|		ПО Заказы.Покупка = ТранзитОстатки.ПокупкаСсылка
		|			И Заказы.Участник = ТранзитОстатки.Участник";
	
	Запрос.УстановитьПараметр("ГД", ГД);
	
	РезультатЗапроса = Запрос.Выполнить();
	
    ПокупкиТранзит.Загрузить(РезультатЗапроса.Выгрузить());
	ВидОперации	= Перечисления.ВидыОпераций_ДвижениеТранзита.ТранзитНаВозврат;
	Для каждого стр из ПокупкиТранзит Цикл
		стр.Организатор	= СП_РаботаСоСправочниками.ПолучитьОрганизатораПо_Коду(стр.Покупка.Организатор.Код);		
	КонецЦикла;
	Комментарий="Возврат удаленных из группы. Автоматически.";
КонецПроцедуры	



Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	#Область ПравильноеПроведение
	
	ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	Документы.ДвижениеТранзита.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	ДополнительныеСвойства.Вставить("ЭтоНовый",ЭтоНовый());
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	

	СП_ДвиженияСервер.ОтразитьДвиженияПоРегистру("Транзит",ДополнительныеСвойства, Движения, Отказ);
	СП_ДвиженияСервер.ОтразитьДвиженияПоРегистру("Возвраты",ДополнительныеСвойства, Движения, Отказ);
	СП_ДвиженияСервер.ОтразитьДвиженияПоРегистру("ОстаткиТоваров",ДополнительныеСвойства, Движения, Отказ);
	#КонецОбласти	
	
	
	
КонецПроцедуры





Процедура ЗаполнитьПоОтбору(Параметры) Экспорт
	
	Схема	= ПолучитьМакет("СКДОтбор");
	КомпоновщикНастроек		= Новый КомпоновщикНастроекКомпоновкиДанных;
	КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(Схема));
	КомпоновщикНастроек.ЗагрузитьНастройки(Схема.ВариантыНастроек["Основной"].Настройки);
	
	настройки=КомпоновщикНастроек.Настройки;
	
	Для Каждого Элем из Параметры Цикл
		Если ТипЗнч(элем.Значение) 	<> Тип("Структура") Тогда Продолжить; КонецЕсли;
		полеОтбора		= КомпоновщикНастроек.Настройки.Отбор.ДоступныеПоляОтбора.Элементы.Найти(Элем.Ключ);
		Если ПолеОтбора = Неопределено Тогда Продолжить; КонецЕсли;
		
		НовыйОтбор 					= настройки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		НовыйОтбор.ЛевоеЗначение	= полеОтбора.Поле;
		ЗаполнитьЗначенияСвойств(НовыйОтбор, элем.Значение);
	КонецЦикла;
	
	
	
	
	КомпоновщикНастроек.ЗагрузитьФиксированныеНастройки(настройки);
	
	КомпановщикМакета=Новый КомпоновщикМакетаКомпоновкиДанных;
	Макет	=	КомпановщикМакета.Выполнить(Схема,КомпоновщикНастроек.Настройки,,,Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	ПроцессорКомпоновки= новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(Макет);
	ПроцессорВывода=новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	ТЗ=новый ТаблицаЗначений;
	ПроцессорВывода.УстановитьОбъект(ТЗ);
	ПроцессорВывода.Вывести(ПроцессорКомпоновки,Истина);

	Если Параметры.Свойство("Дата") Тогда
		Дата			= Параметры.Дата;
	КонецЕсли;
	Если Параметры.Свойство("ВидОперации") Тогда
		ВидОперации		= Перечисления.ВидыОпераций_ДвижениеТранзита[Параметры.ВидОперации];
	КонецЕсли;
	ПокупкиТранзит.Загрузить(ТЗ);
КонецПроцедуры	