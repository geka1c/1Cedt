
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	//Схема=Обработки.ОбменСообщениями100СП.ПолучитьМакет("СКДПокупкиДляВыбора");
	//АдресСхемыКомпоновкиДанных = ПоместитьВоВременноеХранилище(Схема, УникальныйИдентификатор);
	//ИсточникНастроек = Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресСхемыКомпоновкиДанных);
	//
	//КомпоновщикНастроек.Инициализировать(ИсточникНастроек);
	//КомпоновщикНастроек.ЗагрузитьНастройки(Схема.НастройкиПоУмолчанию);
	
	тз = ПолучитьСписокПокупок(Параметры.Участник);
	СписокПокупок.Загрузить(ТЗ);
КонецПроцедуры


&НаСервере
Функция ПолучитьСписокПокупок(Участник)
	Схема=Обработки.ОбменСообщениями100СП.ПолучитьМакет("СКДПокупкиДляВыбора");
	АдресСхемыКомпоновкиДанных 	= ПоместитьВоВременноеХранилище(Схема, УникальныйИдентификатор);
    ИсточникНастроек 			= Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресСхемыКомпоновкиДанных);
	КомпоновщикНастроек.Инициализировать(ИсточникНастроек);
	КомпоновщикНастроек.ЗагрузитьНастройки(Схема.НастройкиПоУмолчанию);
	
	настройки=КомпоновщикНастроек.Настройки;
	
	параметрПериод=настройки.ПараметрыДанных.НайтиЗначениеПараметра(новый ПараметрКомпоновкиДанных("ТекущаяДата"));
	параметрПериод.Значение			= КонецДня(ТекущаяДата());
	параметрПериод.Использование	= Истина;
	
	параметрПериод=настройки.ПараметрыДанных.НайтиЗначениеПараметра(новый ПараметрКомпоновкиДанных("Участник"));
	параметрПериод.Значение			= Участник;
	параметрПериод.Использование	= Истина;
	
	КомпановщикМакета=Новый КомпоновщикМакетаКомпоновкиДанных;
	Макет=КомпановщикМакета.Выполнить(Схема,КомпоновщикНастроек.Настройки,,,Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	ПроцессорКомпоновки= новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(Макет);
	ПроцессорВывода=новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	ТЗ=новый ТаблицаЗначений;
	ПроцессорВывода.УстановитьОбъект(ТЗ);
	ПроцессорВывода.Вывести(ПроцессорКомпоновки,Истина);
	Возврат ТЗ;
КонецФункции

&НаКлиенте
Процедура Выбрать(Команда)
	Если Элементы.СписокПокупок.ТекущиеДанные <>Неопределено Тогда
		//ОповеститьОВыборе(Элементы.СписокПокупок.ТекущиеДанные.Покупка);
		Закрыть(Элементы.СписокПокупок.ТекущиеДанные.Покупка);
	Иначе	
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Необходимо выбрать покупку!");
	КонецЕсли;	
КонецПроцедуры
