
#Область ЗагрузкаСуперГруппПоДате
Функция Загрузить_СуперГруппыПоДате(Дата) Экспорт
 	ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Загрузка Супергрупп",,0,100);
	
	хмл_отправили			= ПолучитьХМЛ_СуперГруппыПоДате(Дата);
	хмл_получили 			= ПолученныеДанные_СуперГруппыПоДате(хмл_отправили);
	авторизацияВыполнена	= Ложь;
	
	ТЗ						= Новый ТаблицаЗначений;
	ТЗ.Колонки.Добавить("Ошибка");
	
	Если хмл_получили	= Неопределено Тогда 
		стр						= тз.Добавить();
		стр.Ошибка				= "Не удалось соединиться с сайтом";
	Иначе	
		авторизацияВыполнена 	= Разбор_СуперГруппыПоДате(ТЗ,хмл_получили);
	КонецЕсли;
	
	Ошибки_СуперГруппыПоДате(ТЗ);
	
	Если авторизацияВыполнена и ТЗ.Количество()=0 Тогда
		Константы.ПоследняяЗагрузкаСупергрупп.Установить(ТекущаяДата());
	КонецЕсли;		
	
	Возврат новый Структура("Ошибки",ТЗ);
КонецФункции	


Функция ПолучитьХМЛ_СуперГруппыПоДате(Дата) 
	Тип_dataByDates					= ФабрикаXDTO.Тип("http://www.100sp.ru/out","dataByDates");
	Тип_distributors				= ФабрикаXDTO.Тип("http://www.100sp.ru/out","distributors");
	
	Объект_dataByDates				= ФабрикаXDTO.Создать(Тип_dataByDates);
	Объект_dataByDates.superGroups	= Дата;
	
	Объект_distributors=ФабрикаXDTO.Создать(Тип_distributors);
	Объект_distributors.dataByDates	= Объект_dataByDates;
	
	Запись 					= Новый ЗаписьXML;
	Запись.УстановитьСтроку(); 
	ФабрикаXDTO.ЗаписатьXML(Запись, Объект_distributors);
	ДанныеXML 				= Запись.Закрыть();
	ДанныеXML				= "<?xml version=""1.0"" encoding=""UTF-8""?> "+СтрЗаменить(ДанныеXML,"xmlns=""http://www.100sp.ru/out"" ","");
	Возврат ДанныеXML; 
КонецФункции

Функция ПолученныеДанные_СуперГруппыПоДате(ДанныеXML) 
	Параметры    = новый Структура;
	Параметры.Вставить("token",Константы.Токен.Получить());
	Параметры.Вставить("xml", ДанныеXML);
	АдресСкрипта = Константы.АдресЗагрузкиССайта.Получить();

	ПолученныйФайл=СтоСПОбмен_Общий.ПолучитьПостЗапросом(Параметры,АдресСкрипта);
	Если ПолученныйФайл=Неопределено Тогда Возврат Неопределено КонецЕсли;

	ПолученныеДанные=СтоСПОбмен_Общий.ФайлВСтроку(ПолученныйФайл);
	Возврат ПолученныеДанные;
КонецФункции	

Функция Разбор_СуперГруппыПоДате(ТЗЗаказов,ПолученныеДанные) 
	авторизацияВыполнена	= ложь;
	Тип_distributors		= ФабрикаXDTO.Тип("http://www.100sp.ru", "distributors");
	Тип_dataByDates			= ФабрикаXDTO.Тип("http://www.100sp.ru", "dataByDates");
	
	//ТЗЗаказов.Колонки.Добавить("result");
	//ТЗЗаказов.Колонки.Добавить("message");
	//ТЗЗаказов.Колонки.Добавить("distributor_code");
	//ТЗЗаказов.Колонки.Добавить("ТочкаНазначение", новый ОписаниеТипов("СправочникСсылка.ТочкиРаздачи"));
	//ТЗЗаказов.Колонки.Добавить("ГабаритНазначение",новый ОписаниеТипов("СправочникСсылка.Габариты"));
	//ТЗЗаказов.Колонки.Добавить("МестоХраненияНазначение",новый ОписаниеТипов("СправочникСсылка.МестаХранения"));
	
	ЧтениеXML = Новый ЧтениеXML;
	ЧтениеXML.УстановитьСтроку(ПолученныеДанные);
	
	Объект_distributors= ФабрикаXDTO.ПрочитатьXML(ЧтениеXML,Тип_distributors);
	Если Объект_distributors.auth.result="ok" Тогда
		авторизацияВыполнена=истина;
	КонецЕсли;
	Если Объект_distributors.dataByDates=Неопределено Тогда
		Возврат авторизацияВыполнена;
	КонецЕсли;	
	ВсегоЭлементов	= Объект_distributors.dataByDates.superGroups.superGroup.Количество();
	счетчик		 	= 0;
	Для каждого Супергруппа из Объект_distributors.dataByDates.superGroups.superGroup Цикл
		счетчик 	= счетчик + 1;
		ОбновитьСупергруппу(Супергруппа);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Загрузка Супергрупп",,строка(счетчик),строка(ВсегоЭлементов));
		
	КонецЦикла;
	Возврат авторизацияВыполнена;
КонецФункции

Функция Ошибки_СуперГруппыПоДате(ТЗ) 
	//ТЗОшибок=ТЗЗаказов.Скопировать(новый Структура("result","error"));
	//строкиСошибками=ТЗЗаказов.НайтиСтроки(новый Структура("result","error"));
	//Для каждого стр из строкиСошибками Цикл
	//	ТЗЗаказов.Удалить(стр);
	//КонецЦикла;	
	//
	//строкиСвои=ТЗЗаказов.НайтиСтроки(новый Структура("ТочкаНазначение",Константы.СвояТочка.Получить()));
	//Для каждого стр из строкиСвои Цикл
	//	ТЗЗаказов.Удалить(стр);
	//КонецЦикла;	
	Возврат ТЗ;
КонецФункции


#КонецОбласти

#Область ЗагрузкаСоставаСупергруппы

Функция ПолучитьСостав(Супергруппа) Экспорт
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Загрузка состава Супергрупп",,0,100);
	
	хмл_отправили			= ПолучитьХМЛ_СоставСупергруппы(Супергруппа);
	хмл_получили 			= СтоСПОбмен_Общий.Загрузить(хмл_отправили);
	хмл_получили			= СтрЗаменить(хмл_получили,"www.100sp.ru","www.100sp.ru/api/distributor/upload/back");
	авторизацияВыполнена	= Ложь;
	
	Если хмл_получили	= Неопределено Тогда 
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не удалось соединиться с сайтом");
	Иначе	
		авторизацияВыполнена 	= Разбор_СоставСупергруппы(хмл_получили);
	КонецЕсли;
	
	Возврат 1;
КонецФункции


Функция ПолучитьХМЛ_СоставСупергруппы(Супергруппа)
	Если ТипЗнч(Супергруппа)  = Тип("СписокЗначений") Тогда
		Группы = Супергруппа;
	ИначеЕсли ТипЗнч(Супергруппа) = Тип("СправочникСсылка.Мегаордера") Тогда
		Группы = новый СписокЗначений;
		Группы.Добавить(Супергруппа);
	КонецЕсли;	
	
	
	ПолученныеДанные="";
	ЗаписьXML=новый ЗаписьXML;
	ЗаписьXML.УстановитьСтроку("UTF-8");
	ЗаписьXML.ЗаписатьНачалоЭлемента("distributors");
	ЗаписьXML.ЗаписатьАтрибут("xmlns:xsi","http://www.w3.org/2001/XMLSchema-instance");
	ЗаписьXML.ЗаписатьАтрибут("xmlns:xsd","http://www.w3.org/2001/XMLSchema");
	ЗаписьXML.ЗаписатьНачалоЭлемента("superGroups");
	Для каждого стр из Группы Цикл
		ЗаписьXML.ЗаписатьНачалоЭлемента("superGroup");
		ЗаписьXML.ЗаписатьТекст(Стр.Значение.Код);
		ЗаписьXML.ЗаписатьКонецЭлемента();  
	КонецЦикла;
	ЗаписьXML.ЗаписатьКонецЭлемента();	
	ЗаписьXML.ЗаписатьКонецЭлемента();	//groups
	ОтправленныеДанные= ЗаписьXML.Закрыть();
	Возврат ОтправленныеДанные;

КонецФункции

Функция Разбор_СоставСупергруппы(хмл_получили)
	Тип_distributors=ФабрикаXDTO.Тип("http://www.100sp.ru/api/distributor/upload/back", "distributors");
	ЧтениеXML = Новый ЧтениеXML;
	ЧтениеXML.УстановитьСтроку(хмл_получили);
	авторизацияВыполнена=Ложь;
	
	структураXDTO= ФабрикаXDTO.ПрочитатьXML(ЧтениеXML,Тип_distributors);
	Если структураXDTO.auth.result="ok" Тогда
		авторизацияВыполнена=истина;
	Иначе
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не пройдена аутентификация!");
	КонецЕсли;
	
	Если структураXDTO.superGroups<>Неопределено Тогда
		
		Для каждого стр из структураXDTO.superGroups.superGroup Цикл
			СуперГруппа	= СП_Штрихкоды.ПолучитьДанныеПоШК(стр.documentNumber).ШК;	
			тз_Заказов = новый ТаблицаЗначений;
			тз_Заказов.Колонки.Добавить("Заказ");
			тз_Заказов.Колонки.Добавить("Участник");
			Если стр.orders<>Неопределено Тогда
				Для каждого заказ из стр.orders.order Цикл
					СтрокаЗаказов				= тз_Заказов.Добавить();
					Если 	  заказ.orderType	= "package" Тогда    
						СтрокаЗаказов.Заказ 	= СП_РаботаСоСправочниками.ПолучитьПосылкуПо_Коду(заказ.packageId);
						СтрокаЗаказов.Участник	= СП_РаботаСоСправочниками.ПолучитьУчастникаПо_Коду(заказ.receiverUid);
					ИначеЕсли 	  заказ.orderType	= "sp" Тогда    
						СтрокаЗаказов.Заказ 	= СП_РаботаСоСправочниками.ПолучитьПокупкуПо_Коду(заказ.pid);
						СтрокаЗаказов.Участник	= СП_РаботаСоСправочниками.ПолучитьУчастникаПо_Коду(заказ.uid);
					ИначеЕсли заказ.orderType	= "shop" Тогда	
						СтрокаЗаказов.Заказ 	= СП_РаботаСоСправочниками.ПолучитьЗаказПо_Коду(заказ.orderId);
						СтрокаЗаказов.Участник	= СП_РаботаСоСправочниками.ПолучитьУчастникаПо_Коду(заказ.uid);
					ИначеЕсли заказ.orderType	= "bulletin" Тогда	
						СтрокаЗаказов.Заказ 	= СП_РаботаСоСправочниками.ПолучитьПристройПо_Коду(заказ.orderId);
						СтрокаЗаказов.Участник	= СП_РаботаСоСправочниками.ПолучитьУчастникаПо_Коду(заказ.uid);;
					ИначеЕсли заказ.orderType	= "group" Тогда	
						СтрокаЗаказов.Заказ 	= СП_РаботаСоСправочниками.ПолучитьКоробкуПо_Коду(заказ.groupCode);
					КонецЕсли;
				КонецЦикла;	
			КонецЕсли;
			СП_РаботаСоСправочниками.ОбновитьМегаордер(СуперГруппа, Новый Структура("Состав", тз_Заказов));
		КонецЦикла;
	КонецЕсли;
	
	Возврат авторизацияВыполнена;
КонецФункции
#КонецОбласти

#Область Вспомогательные
Процедура ОбновитьСупергруппу(об_XDTO)
	мегаордер_Ссылка	= СП_Штрихкоды.ПолучитьДанныеПоШК(об_XDTO.documentNumber).ШК;
	ПараметрыМегаордера = новый Структура;
	ПараметрыМегаордера.Вставить("ПерваяТочкаПриема",	СП_РаботаСоСправочниками.ПолучитьПунктВыдачиПо_Коду(об_XDTO.distributorFromCode));
	ПараметрыМегаордера.Вставить("ПунктВыдачи",			СП_РаботаСоСправочниками.ПолучитьПунктВыдачиПо_Коду(об_XDTO.distributorToCode));
	ПараметрыМегаордера.Вставить("ДатаСоздания",		СтоСПОбмен_Общий.ДатаИзСтроки(об_XDTO.processedFromAt));
	
	Если об_XDTO.superGroupStages.Свойства().Количество()>0 Тогда
		ПараметрыМегаордера.Вставить("Маршрут", об_XDTO.superGroupStages.superGroupStage);
	КонецЕсли;
	
	СП_РаботаСоСправочниками.ОбновитьМегаордер(мегаордер_Ссылка, ПараметрыМегаордера);
КонецПроцедуры
#КонецОбласти