
Функция  Догрузить() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Покупки.Ссылка КАК Покупка
		|ИЗ
		|	Справочник.Покупки КАК Покупки
		|ГДЕ
		|	Покупки.Догрузить
		|	И НЕ Покупки.ПометкаУдаления";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	списокПокупок	= новый СписокЗначений;
	
	списокПокупок.ЗагрузитьЗначения(РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("Покупка"));
	возврат Загрузить(списокПокупок);	
КонецФункции	

Функция Загрузить(КоллекцияПокупок) Экспорт
	хмл_отправили	= ПолучитьХМЛ(КоллекцияПокупок);
	хмл_получили 	= СтоСПОбмен_Общий.Загрузить(хмл_отправили);
	
	Если хмл_получили	= Неопределено Тогда
		Возврат Неопределено;	
	Иначе	
		возврат Разбор(хмл_получили);
	КонецЕсли;
КонецФункции

Функция ЗагрузитьПоДате(ДатаЗагрузки = Неопределено)
	
	

	
КонецФункции	



#Область ЗагрузкаПосылкиПоКодам

Функция ПолучитьХМЛ(СписокПокупок)
	Тип_distributors		= ФабрикаXDTO.Тип("http://www.100sp.ru/out","distributors");
	Тип_purchases			= ФабрикаXDTO.Тип("http://www.100sp.ru/out","distributors.purchases");
	
	Объект_distributors		= ФабрикаXDTO.Создать(Тип_distributors);
	Объект_purchases		= ФабрикаXDTO.Создать(Тип_purchases);
	
	Для каждого элем из СписокПокупок Цикл
		Объект_purchases.purchase.Добавить(элем.Значение.Код);
	КонецЦикла;
	
	Объект_distributors.purchases = Объект_purchases;
	
	Запись = Новый ЗаписьXML;
	Запись.УстановитьСтроку(); 
	ФабрикаXDTO.ЗаписатьXML(Запись, Объект_distributors);
	ДанныеXML 	= Запись.Закрыть();
	ДанныеXML	= "<?xml version=""1.0"" encoding=""UTF-8""?> "+СтрЗаменить(ДанныеXML,"xmlns=""http://www.100sp.ru/out"" ","");
	Возврат ДанныеXML; 
КонецФункции

	

Функция Разбор(ПолученныеДанные) 
	пространствоИмен	= "http://www.100sp.ru/api/distributor/upload/back";
	ПолученныеДанные	= СтрЗаменить(ПолученныеДанные,"http://www.100sp.ru",пространствоИмен);
	ПолученныеДанные	= СтрЗаменить(ПолученныеДанные, "<id>",		 "<pid>");
	ПолученныеДанные 	= СтрЗаменить(ПолученныеДанные, "</id>",	"</pid>");	

	авторизацияВыполнена=ложь;
	
	
	Тип_distributors=ФабрикаXDTO.Тип(пространствоИмен, "distributors");
	
	ЧтениеXML = Новый ЧтениеXML;
	ЧтениеXML.УстановитьСтроку(ПолученныеДанные);
	
	Объект_distributors= ФабрикаXDTO.ПрочитатьXML(ЧтениеXML,Тип_distributors);
	Если Объект_distributors.auth.result="ok" Тогда
		авторизацияВыполнена=истина;
	КонецЕсли;
	Если Объект_distributors.purchases	= Неопределено Тогда
		Возврат авторизацияВыполнена;
	КонецЕсли;	
	
	
	
	свойстваДаты =Новый Массив();
	свойстваДаты.Добавить("modified");
	тзВнешняя		=	СтоСПОбмен_Общий.ТЗ_поСпискуXDTO(Объект_distributors.purchases.purchase);
	
	строкиСОшибками	= тзВнешняя.НайтиСтроки(Новый структура("result", "error"));
	Для каждого элем из строкиСОшибками Цикл
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("при загрузке покупки с кодом: "+элем.id+" возникла ошибка: " +элем.message);
		тзВнешняя.Удалить(элем);
	КонецЦикла;	
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	тзФ.id 			КАК Код,
		|	тзФ.name 		КАК Наименование,
		|	тзФ.modified 	КАК ДатаМодификации,
		|	тзФ.city_id		КАК КодГорода,
		|	тзФ.secureCode 	КАК secureCode,
		|	тзФ.orgid 		КАК КодОрганизатора
		|ПОМЕСТИТЬ Ф
		|ИЗ
		|	&тзВнешняя КАК тзФ
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Ф.Код 				КАК Код,
		|	Ф.Наименование 		КАК Наименование,
		|	Ф.КодОрганизатора 	КАК КодОрганизатора,
		|	Ф.ДатаМодификации 	КАК ДатаМодификации,
		|	Ф.КодГорода 		КАК КодГорода,
		|	Ф.secureCode 		КАК secureCode,
		|	Участники.Ссылка 	КАК УчастникСсылка,
		|	ГородаСП.Ссылка 	КАК ГородСсылка,
		|	Покупки.Ссылка 		КАК СсылкаПокупка
		|ПОМЕСТИТЬ Сбор
		|ИЗ
		|	Ф КАК Ф
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Покупки 		КАК Покупки
		|						ПО Ф.Код = Покупки.Код
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ГородаСП 		КАК ГородаСП
		|						ПО ((ВЫРАЗИТЬ(Ф.КодГорода КАК СТРОКА(9))) = (ВЫРАЗИТЬ(ГородаСП.Код КАК СТРОКА(9))))
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Участники КАК Участники
		|						ПО Ф.КодОрганизатора = Участники.Код
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Итоговая.Код 					КАК Код,
		|	Итоговая.Наименование 			КАК Наименование,
		|	Итоговая.КодОрганизатора 		КАК КодОрганизатора,
		|	Итоговая.ДатаМодификации 		КАК ДатаМодификации,
		|	Итоговая.КодГорода 				КАК КодГорода,
		|	Итоговая.secureCode 			КАК secureCode,
		|	Итоговая.УчастникСсылка 		КАК УчастникСсылка,
		|	Итоговая.ГородСсылка 			КАК ГородСсылка,
		|	Итоговая.СсылкаПокупка 			КАК ПокупкаСсылка
		|ПОМЕСТИТЬ Итоговая
		|ИЗ
		|	Сбор КАК Итоговая
		|ГДЕ
		|		   (	Итоговая.СсылкаПокупка.Догрузить
		|			ИЛИ Итоговая.СсылкаПокупка.Организатор 	<> ЕСТЬNULL(Итоговая.УчастникСсылка, ЗНАЧЕНИЕ(Справочник.Участники.ПустаяСсылка))
		|			ИЛИ Итоговая.СсылкаПокупка.secureCode 	<> (ВЫРАЗИТЬ(Итоговая.secureCode КАК СТРОКА(8)))
		|			ИЛИ Итоговая.СсылкаПокупка.Наименование <> (ВЫРАЗИТЬ(Итоговая.Наименование КАК СТРОКА(150)))
		|			ИЛИ Итоговая.СсылкаПокупка.Владелец 	<> ЕСТЬNULL(Итоговая.УчастникСсылка, ЗНАЧЕНИЕ(Справочник.Участники.ПустаяСсылка))
		|			ИЛИ Итоговая.СсылкаПокупка.ГородСП 		<> ЕСТЬNULL(Итоговая.ГородСсылка, ЗНАЧЕНИЕ(Справочник.ГородаСП.ПустаяСсылка))
		|			ИЛИ Итоговая.УчастникСсылка 		ЕСТЬ NULL
		|			ИЛИ Итоговая.ГородСсылка 			ЕСТЬ NULL)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Итоговая.Код 				КАК Код,
		|	Итоговая.Наименование 		КАК Наименование,
		|	Итоговая.КодОрганизатора 	КАК КодОрганизатора,
		|	Итоговая.ДатаМодификации 	КАК ДатаМодификации,
		|	Итоговая.КодГорода 			КАК КодГорода,
		|	Итоговая.secureCode 		КАК secureCode,
		|	Итоговая.УчастникСсылка 	КАК УчастникСсылка,
		|	Итоговая.ГородСсылка 		КАК ГородСсылка,
		|	Итоговая.ПокупкаСсылка 		КАК ПокупкаСсылка
		|ИЗ
		|	Итоговая КАК Итоговая
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Посылки.Ссылка КАК Посылка
		|ИЗ
		|	Справочник.Посылки КАК Посылки
		|ГДЕ
		|	Посылки.Покупка В
		|			(ВЫБРАТЬ
		|				Итоговая.ПокупкаСсылка КАК ПокупкаСсылка
		|			ИЗ
		|				Итоговая КАК Итоговая)
		|	И Посылки.Перезаполнить";
	
	Запрос.Параметры.Вставить("тзВнешняя",тзВнешняя);
	
	результат					= Запрос.ВыполнитьПакет();	
	
	////Покупки
	
	ВыборкаИзменилисьПокупки	= результат[3].Выбрать();
	счетчик		 				= 0;
	ВсегоЭлементов				= ВыборкаИзменилисьПокупки.Количество();

	Пока ВыборкаИзменилисьПокупки.Следующий() Цикл

		Если ЗначениеЗаполнено(ВыборкаИзменилисьПокупки.УчастникСсылка) Тогда
			Участник_Ссылка	= ВыборкаИзменилисьПокупки.УчастникСсылка;
		Иначе
			Участник_Ссылка	= СП_РаботаСоСправочниками.ПолучитьУчастникаПо_Коду(ВыборкаИзменилисьПокупки.КодОрганизатора);
		КонецЕсли;	
		
		Если ЗначениеЗаполнено(ВыборкаИзменилисьПокупки.ГородСсылка) Тогда
			Город_Ссылка		= ВыборкаИзменилисьПокупки.ГородСсылка;
		Иначе
			Город_Ссылка		= СП_РаботаСоСправочниками.ПолучитьГородПокупкиПо_Коду(ВыборкаИзменилисьПокупки.КодГорода);
		КонецЕсли;			
		
		Если ЗначениеЗаполнено(ВыборкаИзменилисьПокупки.ПокупкаСсылка) Тогда
			Покупка_Ссылка		= ВыборкаИзменилисьПокупки.ПокупкаСсылка;
		Иначе
			Покупка_Ссылка		= СП_РаботаСоСправочниками.ПолучитьПокупкуПо_Коду(ВыборкаИзменилисьПокупки.Код);
		КонецЕсли;			
		
		
		параметрыПокупки	= новый Структура;
		параметрыПокупки.Вставить("Владелец",			Участник_Ссылка);
		параметрыПокупки.Вставить("Наименование",		ВыборкаИзменилисьПокупки.Наименование);
		параметрыПокупки.Вставить("Организатор",		Участник_Ссылка);
		параметрыПокупки.Вставить("ГородСП",			Город_Ссылка);
		параметрыПокупки.Вставить("Догрузить",			Ложь);
		параметрыПокупки.Вставить("ДатаЗагрузки",		ТекущаяДата());
		параметрыПокупки.Вставить("ДатаМодификации",	ВыборкаИзменилисьПокупки.ДатаМодификации);
		параметрыПокупки.Вставить("secureCode",			ВыборкаИзменилисьПокупки.secureCode);
		
		СП_РаботаСоСправочниками.ОбновитьПокупку(Покупка_Ссылка, параметрыПокупки);
		

		//ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Загрузка Покупок: " + счетчик + " из " + ВсегоЭлементов ,,строка(счетчик),строка(ВсегоЭлементов));
		
	КонецЦикла;
	////Посылки
	ВыборкаИзменилисьПосылки	= результат[4].Выбрать();
	счетчик		 				= 0;
	ВсегоЭлементов				= ВыборкаИзменилисьПосылки.Количество();
	
	СписокПосылок				= новый СписокЗначений;
	Пока ВыборкаИзменилисьПосылки.Следующий() Цикл
		ПосылкаОбъект = ВыборкаИзменилисьПосылки.Посылка.ПолучитьОбъект();
		Попытка
			ПосылкаОбъект.Записать();
			СписокПосылок.Добавить(ВыборкаИзменилисьПосылки.Посылка);
		Исключение
			ТекстСообщения = "При обновлениии Посылки:"+ВыборкаИзменилисьПосылки.Посылка+" (измениоась покупка), произошла ошибка: "+Символы.ПС+ОписаниеОшибки();
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);		
		КонецПопытки;
	КонецЦикла;	


	Возврат новый Структура ("авторизацияВыполнена,СписокПосылок",авторизацияВыполнена,СписокПосылок);
КонецФункции
	

#КонецОбласти





