#Область программныйИнтерфейс

Процедура Загрузить_ПосылкиПоДате(ПоследняяДатаЗагрузки = Неопределено) Экспорт
	Если ПоследняяДатаЗагрузки = Неопределено Тогда
		ПоследняяДатаЗагрузки = Справочники.ПараметрыОбмена.Посылки.ДатаЗагрузки;
	КонецЕсли;
	
	ПунктВыдачи_АнтейТранзит = Справочники.ТочкиРаздачи.НайтиПоКоду("0039");
	ПунктВыдачи_АнтейТранзит = Ложь;
	СвойПунктВылачи			 = Константы.СвояТочка.Получить();
	Если ПунктВыдачи_АнтейТранзит = СвойПунктВылачи Тогда
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ТочкиРаздачи.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.ТочкиРаздачи КАК ТочкиРаздачи";
		
		РезультатЗапроса = Запрос.Выполнить();
		
		Выборка = РезультатЗапроса.Выбрать();
		
		Пока Выборка.Следующий() Цикл
			АвторизацияВыполнена = Загрузить_ПосылкиПоДатеИПунктуВыдачи(ПоследняяДатаЗагрузки, Выборка.ссылка); 	
			Если не АвторизацияВыполнена Тогда
				Прервать;
			КонецЕсли;	
		КонецЦикла;
	Иначе
		АвторизацияВыполнена = Загрузить_ПосылкиПоДатеИПунктуВыдачи(ПоследняяДатаЗагрузки, СвойПунктВылачи); 
	КонецЕсли;	
	Если АвторизацияВыполнена тогда
		СтоСПОбмен_Общий.УстановитьДатуЗагрузки(Справочники.ПараметрыОбмена.Посылки);
	КонецЕсли;	
КонецПроцедуры


Функция  Загрузить_ПосылкиПоДатеИПунктуВыдачи(ПоследняяДатаЗагрузки, ПунктВыдачи) 
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Получаем с сайта: Посылки",,0,100);
	хмл_отправили			= ПолучитьХМЛ_ПосылкиПоДате(ПоследняяДатаЗагрузки, ПунктВыдачи);
	хмл_получили 			= ПолученныеДанные_ПосылкиПоДате(хмл_отправили);
	хмл_получили 			= СтрЗаменить(хмл_получили,"<firstPid></firstPid>","<firstPid>0</firstPid>");
	
	авторизацияВыполнена	= Ложь;
	
	Если хмл_получили	= Неопределено Тогда 
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("При загрузек посылок по дате, Не удалось соединиться с сайтом!");
	ИначеЕсли	хмл_получили	= "" Тогда
		
	Иначе	
		авторизацияВыполнена = Разбор_ПосылкиПоДате(хмл_получили);
	КонецЕсли;
	
	Если авторизацияВыполнена Тогда
		//объект_ПунктВыдачи = ПунктВыдачи.ПолучитьОбъект();		
		//объект_ПунктВыдачи.ДатаЗагрузкиПосылки = ТекущаяДата();
		//объект_ПунктВыдачи.Записать();
	Иначе
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("При загрузке посылок по дате, не пройдена авторизация!");	
	КонецЕсли;	
	Возврат авторизацияВыполнена;
КонецФункции


Функция Загрузить_СоставПосылки_ПоПризнакуДогрузить() экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Посылки.Ссылка КАК Посылка
		|ИЗ
		|	Справочник.Посылки КАК Посылки
		|ГДЕ
		|	НЕ Посылки.ПометкаУдаления и
		|	Посылки.Догрузить";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	списокПосылок = Новый СписокЗначений;
	списокПосылок.ЗагрузитьЗначения(РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("Посылка"));
	Возврат Загрузить_СоставПосылкиПоКодам(списокПосылок);
	
КонецФункции


Функция Загрузить_СоставПосылкиПоКодам(СписокКодовПараметр) Экспорт
	если ТипЗнч(СписокКодовПараметр) = Тип("Строка") или
		 ТипЗнч(СписокКодовПараметр) = Тип("Число") или
		 ТипЗнч(СписокКодовПараметр) = Тип("СправочникСсылка.Посылки") Тогда 
		СписокКодов = новый СписокЗначений;
		СписокКодов.Добавить(СписокКодовПараметр);
	иначе	
		СписокКодов = СписокКодовПараметр
	КонецЕсли;
	Если СписокКодов.Количество() = 0 Тогда Возврат Истина; КонецЕсли;
	хмл_отправили = ПолучитьХМЛ_СоставПосылкиПоКодам(СписокКодов);
	хмл_получили  = ПолученныеДанные_СоставПосылкиПоКодам(хмл_отправили);
	
	ТЗ=Новый ТаблицаЗначений;
	ТЗ.Колонки.Добавить("Ошибка");
	Если хмл_получили=Неопределено Тогда 
		стр=тз.Добавить();
		стр.Ошибка="Не удалось соединиться с сайтом";
	Иначе	
		результат =	Разбор_СоставПосылкиПоКодам(ТЗ,хмл_получили);
		
		СписокПосылок = Новый СписокЗначений();
		СписокПокупок = Новый СписокЗначений();
		Для каждого элем из Результат.результат  Цикл
			Если ЗначениеЗаполнено(элем.Посылка.Покупка) и  элем.Посылка.Покупка.Догрузить Тогда
				СписокПокупок.Добавить(элем.Посылка.Покупка);
				СписокПосылок.Добавить(элем.Посылка);
			КонецЕсли
		КонецЦикла;
		СтоСПОбмен_Покупки.Загрузить(СписокПокупок);	
		Для каждого элем из СписокПосылок Цикл
			об = элем.Значение.ПолучитьОбъект();
			об.Записать();	
		КонецЦикла;	
		возврат результат;
	КонецЕсли;
	Возврат новый Структура("Ошибки",ТЗ);
КонецФункции



#КонецОбласти


#Область ЗагрузкаСоставаПосылкиПоКодам

Функция ПолучитьХМЛ_СоставПосылкиПоКодам(СписокКодов)
	Тип_packages			= ФабрикаXDTO.Тип("http://www.100sp.ru/out","distributors.packages");
	Тип_distributors		= ФабрикаXDTO.Тип("http://www.100sp.ru/out","distributors");
	
	Объект_packages			= ФабрикаXDTO.Создать(Тип_packages);
	Для каждого элем из СписокКодов Цикл
		Если ТипЗнч(элем.Значение) = Тип("СправочникСсылка.Посылки") Тогда
			Объект_packages.package.Добавить(элем.Значение.Код);
		Иначе	
			Объект_packages.package.Добавить(элем.Значение);
		КонецЕсли;	
	КонецЦикла;
	
	Объект_distributors=ФабрикаXDTO.Создать(Тип_distributors);
	Объект_distributors.packages=Объект_packages;
	
	Запись = Новый ЗаписьXML;
	Запись.УстановитьСтроку(); 
	ФабрикаXDTO.ЗаписатьXML(Запись, Объект_distributors);
	ДанныеXML = Запись.Закрыть();
	ДанныеXML="<?xml version=""1.0"" encoding=""UTF-8""?> "+СтрЗаменить(ДанныеXML,"xmlns=""http://www.100sp.ru/out"" ","");
	Возврат ДанныеXML; 
КонецФункции

Функция ПолучитьХМЛ_ПосылкиПоДате(ПоследняяДатаЗагрузки, ПунктВыдачи )
	Тип_dataByDates			=ФабрикаXDTO.Тип("http://www.100sp.ru/out","dataByDates");
	Тип_distributors		=ФабрикаXDTO.Тип("http://www.100sp.ru/out","distributors");
	
	Объект_dataByDates=ФабрикаXDTO.Создать(Тип_dataByDates);
	Объект_dataByDates.packageOrders=?(ПунктВыдачи.ДатаЗагрузкиПосылки > ПоследняяДатаЗагрузки, ПунктВыдачи.ДатаЗагрузкиПосылки,ПоследняяДатаЗагрузки);
	Если ПунктВыдачи =  Неопределено Тогда
		Объект_dataByDates.distributorCode = Число(Константы.СвояТочка.Получить());
	Иначе	
		Объект_dataByDates.distributorCode = Число(ПунктВыдачи.Код);
	КонецЕсли;	
	Объект_distributors=ФабрикаXDTO.Создать(Тип_distributors);
	Объект_distributors.dataByDates=Объект_dataByDates;
	
	Запись = Новый ЗаписьXML;
	Запись.УстановитьСтроку(); 
	ФабрикаXDTO.ЗаписатьXML(Запись, Объект_distributors);
	ДанныеXML = Запись.Закрыть();
	ДанныеXML="<?xml version=""1.0"" encoding=""UTF-8""?> "+СтрЗаменить(ДанныеXML,"xmlns=""http://www.100sp.ru/out"" ","");
	Возврат ДанныеXML; 
КонецФункции



Функция ПолученныеДанные_СоставПосылкиПоКодам(ДанныеXML) 
	Параметры    = новый Структура;
	Параметры.Вставить("token",Константы.Токен.Получить());
	Параметры.Вставить("xml", ДанныеXML);
	АдресСкрипта = Константы.АдресЗагрузкиССайта.Получить();

	ПолученныйФайл=СтоСПОбмен_Общий.ПолучитьПостЗапросом(Параметры,АдресСкрипта);
	Если ПолученныйФайл=Неопределено Тогда Возврат Неопределено КонецЕсли;

	ПолученныеДанные=СтоСПОбмен_Общий.ФайлВСтроку(ПолученныйФайл);
	Возврат ПолученныеДанные;
КонецФункции	

Функция ПолученныеДанные_ПосылкиПоДате(ДанныеXML) 
	Параметры    = новый Структура;
	Параметры.Вставить("token",Константы.Токен.Получить());
	Параметры.Вставить("xml", ДанныеXML);
	АдресСкрипта = Константы.АдресЗагрузкиССайта.Получить();

	ПолученныйФайл=СтоСПОбмен_Общий.ПолучитьПостЗапросом(Параметры,АдресСкрипта);
	Если ПолученныйФайл=Неопределено Тогда Возврат Неопределено КонецЕсли;

	ПолученныеДанные=СтоСПОбмен_Общий.ФайлВСтроку(ПолученныйФайл);
	Возврат ПолученныеДанные;
КонецФункции	


Функция Разбор_СоставПосылкиПоКодам(ТЗЗаказов,ПолученныеДанные) 
	пространствоИмен		= "http://www.100sp.ru/api/distributor/upload/back";
	ПолученныеДанные		= СтрЗаменить(ПолученныеДанные,"http://www.100sp.ru",пространствоИмен);
	авторизацияВыполнена	= ложь;
	
	ЧтениеXML 				= Новый ЧтениеXML;
	ЧтениеXML.УстановитьСтроку(ПолученныеДанные);
	
	Тип_distributors		= ФабрикаXDTO.Тип(пространствоИмен, "distributors");
	Объект_distributors		= ФабрикаXDTO.ПрочитатьXML(ЧтениеXML,Тип_distributors);
	
	Если Объект_distributors.auth.result="ok" Тогда
		авторизацияВыполнена=истина;
	КонецЕсли;
	Если Объект_distributors.packages=Неопределено Тогда
		Возврат авторизацияВыполнена;
	КонецЕсли;	
	
	тз_результат			= новый ТаблицаЗначений;
	тз_результат.Колонки.Добавить("Посылка");
	тз_результат.Колонки.Добавить("Загружена");
	
	Для каждого посылка из Объект_distributors.packages.package Цикл
		ответ = ОбновитьСоставПосылки(посылка);
		Если ответ<>неопределено Тогда
			стрОтвета	= тз_результат.Добавить();
			ЗаполнитьЗначенияСвойств(стрОтвета,ответ);
		КонецЕсли;	
	КонецЦикла;
	Возврат новый Структура ("авторизацияВыполнена,результат",авторизацияВыполнена,тз_результат);
КонецФункции

Функция Разбор_ПосылкиПоДате(ПолученныеДанные) 
	пространствоИмен		= "http://www.100sp.ru/api/distributor/upload/back";
	ПолученныеДанные		= СтрЗаменить(ПолученныеДанные,"http://www.100sp.ru",пространствоИмен);
	авторизацияВыполнена	= ложь;

	ЧтениеXML 				= Новый ЧтениеXML;
	ЧтениеXML.УстановитьСтроку(ПолученныеДанные);
	
	Тип_distributors		= ФабрикаXDTO.Тип(пространствоИмен, "distributors");	
	Объект_distributors		= ФабрикаXDTO.ПрочитатьXML(ЧтениеXML,Тип_distributors);
	
	Если Объект_distributors.auth.result="ok" Тогда
		авторизацияВыполнена	= истина;
	КонецЕсли;
	Если Объект_distributors.dataByDates = Неопределено Тогда
		Возврат авторизацияВыполнена;
	КонецЕсли;	
	
	Если Объект_distributors.dataByDates.packageOrders.packageOrder.Количество()=0 Тогда Возврат авторизацияВыполнена; КонецЕсли;
	тз_Посылки = СтоСПОбмен_Общий.ТЗ_поСпискуXDTO(Объект_distributors.dataByDates.packageOrders.packageOrder);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	тз_Посылки.destinationDistributorCode КАК destinationDistributorCode,
		|	тз_Посылки.did КАК did,
		|	тз_Посылки.firstPid КАК firstPid,
		|	тз_Посылки.packageCreatorUid КАК packageCreatorUid,
		|	тз_Посылки.packageId КАК packageId,
		|	тз_Посылки.secureCode КАК secureCode,
		|	тз_Посылки.uid КАК uid
		|ПОМЕСТИТЬ втПосылки
		|ИЗ
		|	&тз_Посылки КАК тз_Посылки
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	втПосылки.destinationDistributorCode КАК destinationDistributorCode,
		|	втПосылки.did КАК did,
		|	втПосылки.firstPid КАК firstPid,
		|	втПосылки.packageCreatorUid КАК packageCreatorUid,
		|	втПосылки.packageId КАК packageId,
		|	втПосылки.secureCode КАК secureCode,
		|	втПосылки.uid КАК uid,
		|	Посылки.Ссылка КАК Ссылка
		|ИЗ
		|	втПосылки КАК втПосылки
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Посылки КАК Посылки
		|		ПО втПосылки.packageId = Посылки.Код
		|ГДЕ
		|	Посылки.Ссылка ЕСТЬ NULL";
	
	Запрос.Параметры.Вставить("тз_Посылки",	тз_Посылки); 
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	счетчик		 	= 0;
	ВсегоЭлементов	= Выборка.Количество();
	
	Пока Выборка.Следующий() Цикл
		счетчик = счетчик + 1;
		
		ПараметрыПосылки	= новый Структура;
		ПараметрыПосылки.Вставить("ПунктВыдачи",		СП_РаботаСоСправочниками.ПолучитьПунктВыдачиПо_Коду(	Выборка.destinationDistributorCode));
		ПараметрыПосылки.Вставить("Участник",			СП_РаботаСоСправочниками.ПолучитьУчастникаПо_Коду(		Выборка.uid));
		ПараметрыПосылки.Вставить("Организатор",		СП_РаботаСоСправочниками.ПолучитьОрганизатораПо_Коду(	Выборка.packageCreatorUid));
		ПараметрыПосылки.Вставить("Покупка",			?(Выборка.firstPid <> 0,СП_РаботаСоСправочниками.ПолучитьПокупкуПо_Коду(Выборка.firstPid),Справочники.Покупки.ПустаяСсылка()));
		ПараметрыПосылки.Вставить("secureCode",			Выборка.secureCode);
		ПараметрыПосылки.Вставить("ДатаЗагрузки",		ТекущаяДата());
		
		Посылка_Ссылка	=	СП_РаботаСоСправочниками.ПолучитьПосылкуПо_Коду(Выборка.packageId);
		СП_РаботаСоСправочниками.ОбновитьПосылку(Посылка_Ссылка,	ПараметрыПосылки);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Загрузка Посылок: " + счетчик + " из " + ВсегоЭлементов ,,строка(счетчик),строка(ВсегоЭлементов));
	КонецЦикла;
	
	Возврат авторизацияВыполнена;
КонецФункции


#КонецОбласти


#Область Вспомогательные

Функция ОбновитьСоставПосылки(об_XDTO)
	ссылкаПосылка	 = СП_РаботаСоСправочниками.ПолучитьПосылкуПо_Коду(об_XDTO.packageId);
	
	ПараметрыПосылки = новый Структура;
	Если об_XDTO.result="error" Тогда
		ПараметрыПосылки.Вставить("Комментарий", 		об_XDTO.message);
		ПараметрыПосылки.Вставить("ПометкаУдаления",	Истина);
	Иначе	
		ПараметрыПосылки.Вставить("Состав", 		об_XDTO.orders.order);
	КонецЕсли;	
	СП_РаботаСоСправочниками.ОбновитьПосылку(ссылкаПосылка, ПараметрыПосылки);	
	
	Возврат новый структура("Посылка, Загружена",ссылкаПосылка,(ссылкаПосылка.Состав.Количество()>0));
КонецФункции


#КонецОбласти


Функция ВыгрузитьНеВыгруженныеПосылки() Экспорт
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	НеВыгруженноНаСайтОстатки.Партия КАК Партия
		|ИЗ
		|	РегистрНакопления.НеВыгруженноНаСайт.Остатки(, ) КАК НеВыгруженноНаСайтОстатки
		|
		|СГРУППИРОВАТЬ ПО
		|	НеВыгруженноНаСайтОстатки.Партия";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Попытка
			об_Разбор=ВыборкаДетальныеЗаписи.Партия.ПолучитьОбъект();
			об_Разбор.Заблокировать();
			об_Разбор.ВыгрузитьНаСайт();
			об_Разбор.Заблокировать();
			об_Разбор.Записать(РежимЗаписиДокумента.Проведение);
		Исключение
		
		КонецПопытки;
	КонецЦикла;
КонецФункции	