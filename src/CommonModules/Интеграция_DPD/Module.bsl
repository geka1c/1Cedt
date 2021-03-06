
#Область ПрограммныйИнтерфейс


//без габаритов не правильно считает
Функция РассчитатьСтоимость_олд(ПараметрыРасчета)  Экспорт
	ПараметрыРасчета.Вставить("ДоставкаДоТерминала", Истина);
	ПараметрыРасчета.Вставить("ДоставкаОтТерминала", Истина);
	ПараметрыРасчета.Вставить("СписокУслугЧзЗп","PCL");	//"BZP,ECN"

	Протокол						= Интеграция_ТранспортныеКомпании_Общий.ПолучитьСтруктуруПротокола();
	Протокол.ОтправленныеДанные		= Интеграция_ТранспортныеКомпании_Общий.ПолучитьОтправляемыеДанные(ПараметрыРасчета);
	
	//Отправитель = Новый Структура("cityName,index","Владивосток", "690068" );
	//Получатель  = Новый Структура("cityName, index","Москва", "140012" ));
	
	Отправитель = Новый Структура("cityId", Число(Справочники.ТранспортныеКомпании.DPD.КодГородаОтправителя) );
	результат_ПунктВылачи = ПолучитьПунктВыдачи(ПараметрыРасчета.КодПВЗ, ПараметрыРасчета.Город);
	Если результат_ПунктВылачи.ОписаниеОшибки = "" Тогда
		Получатель  = Новый Структура("cityId", Число(результат_ПунктВылачи.ПунктВыдачи.КодГорода) );	
	Иначе
		Протокол.РасчетКалькулятора		= результат_ПунктВылачи.ОписаниеОшибки;
		Протокол.ТекстОшибки			= Протокол.РасчетКалькулятора;
		Протокол.ПолученныеДанные		= Протокол.РасчетКалькулятора;
		Протокол.результат				= "error";
		Протокол.ДатаОкончания		= ТекущаяДата();
		Возврат Протокол;
	Конецесли;	
	
		
	стр_Прокси 	= ПолучитьПроксиКалькуляттор();
	Фабрика		= стр_Прокси.Фабрика;
	Namespace  	= стр_Прокси.Namespace;

	WSП_auth = ПолучитьТэг_Auth(стр_Прокси);
	
	
	WSП_pickup  = Фабрика.Создать(Фабрика.Тип(Namespace,"cityRequest"));
	ЗаполнитьЗначенияСвойств(WSП_pickup  , Отправитель);
	
	WSП_delivery  = Фабрика.Создать(Фабрика.Тип(Namespace,"cityRequest"));
	ЗаполнитьЗначенияСвойств(WSП_delivery , Получатель);
	
	WSП_request = Фабрика.Создать(Фабрика.Тип(Namespace,"serviceCostRequest"));
	WSП_request.auth			= WSП_auth;
	WSП_request.selfPickup		=	ПараметрыРасчета.ДоставкаОтТерминала;
	WSП_request.selfDelivery	=	ПараметрыРасчета.ДоставкаДоТерминала;
	WSП_request.weight			=   ПараметрыРасчета.Вес/1000;                 //кг
	WSП_request.volume			=   ПараметрыРасчета.Ширина/100 * ПараметрыРасчета.Длина/100 * ПараметрыРасчета.Высота/100; //м3
	WSП_request.pickup			= 	WSП_pickup;
	WSП_request.delivery		= 	WSП_delivery;
	WSП_request.serviceCode		=	ПараметрыРасчета.СписокУслугЧзЗп;
	WSП_request.declaredValue   = 	ПараметрыРасчета.ОбъявленнаяСтоимость;
	
	
	
	WSП = Фабрика.Создать(Фабрика.Тип(Namespace,"getServiceCost2"));
	WSП.request = WSП_request;

	Попытка
		РезультатРасчета = стр_Прокси.Прокси.getServiceCost2(WSП);
		Протокол.Результат	 		= "ok";
		Протокол.ТарифТК			= РезультатРасчета.return[0].cost;
		Протокол.РасчетКалькулятора	= "Итоговая цена: "+Протокол.ТарифТК+ " руб."+Символы.ПС+
		"	Дней доставки : "+РезультатРасчета.return[0].days+Символы.ПС+
		"	Услуга доставки  : "+РезультатРасчета.return[0].serviceName;
		Протокол.ПолученныеДанные		= Протокол.РасчетКалькулятора;
	Исключение
		Протокол.Результат	  			=	"error";
		Протокол.РасчетКалькулятора		= ОписаниеОшибки();
		Протокол.ТекстОшибки			= Протокол.РасчетКалькулятора;
		Протокол.ПолученныеДанные		= Протокол.РасчетКалькулятора;
	КонецПопытки;
	Протокол.ДатаОкончания		= ТекущаяДата();
	Возврат Протокол;
КонецФункции



Функция РассчитатьСтоимость(ПараметрыРасчета)  Экспорт
	ПараметрыРасчета.Вставить("ДоставкаДоТерминала", Истина);
	ПараметрыРасчета.Вставить("ДоставкаОтТерминала", Истина);
	ПараметрыРасчета.Вставить("СписокУслугЧзЗп",ПараметрыРасчета.УслугаDPD.Код);	//"BZP,ECN"

	Протокол						= Интеграция_ТранспортныеКомпании_Общий.ПолучитьСтруктуруПротокола();
	Протокол.ОтправленныеДанные		= Интеграция_ТранспортныеКомпании_Общий.ПолучитьОтправляемыеДанные(ПараметрыРасчета);
	
	//Отправитель = Новый Структура("cityName,index","Владивосток", "690068" );
	//Получатель  = Новый Структура("cityName, index","Москва", "140012" ));
	
	Отправитель = Новый Структура("cityId", Число(Справочники.ТранспортныеКомпании.DPD.КодГородаОтправителя) );
	результат_ПунктВылачи = ПолучитьПунктВыдачи(ПараметрыРасчета.КодПВЗ, ПараметрыРасчета.Город);
	Если результат_ПунктВылачи.ОписаниеОшибки = "" Тогда
		Получатель  = Новый Структура("cityId", Число(результат_ПунктВылачи.ПунктВыдачи.КодГорода) );	
	Иначе
		Протокол.РасчетКалькулятора		= результат_ПунктВылачи.ОписаниеОшибки;
		Протокол.ТекстОшибки			= Протокол.РасчетКалькулятора;
		Протокол.ПолученныеДанные		= Протокол.РасчетКалькулятора;
		Протокол.результат				= "error";
		Протокол.ДатаОкончания		= ТекущаяДата();
		Возврат Протокол;
	Конецесли;	
	
		
	стр_Прокси 	= ПолучитьПроксиКалькуляттор();
	Фабрика		= стр_Прокси.Фабрика;
	Namespace  	= стр_Прокси.Namespace;

	WSП_auth = ПолучитьТэг_Auth(стр_Прокси);
	
	параметрыПосылки	= Новый Структура("weight, length, width, height",ПараметрыРасчета.Вес/1000, ПараметрыРасчета.Ширина, ПараметрыРасчета.Длина, ПараметрыРасчета.Высота);
	WSП_parcel  = Фабрика.Создать(Фабрика.Тип(Namespace,"parcelRequest"));
	ЗаполнитьЗначенияСвойств(WSП_parcel  , параметрыПосылки);

	
	
	WSП_pickup  = Фабрика.Создать(Фабрика.Тип(Namespace,"cityRequest"));
	ЗаполнитьЗначенияСвойств(WSП_pickup  , Отправитель);
	
	WSП_delivery  = Фабрика.Создать(Фабрика.Тип(Namespace,"cityRequest"));
	ЗаполнитьЗначенияСвойств(WSП_delivery , Получатель);
	
	WSП_request = Фабрика.Создать(Фабрика.Тип(Namespace,"serviceCostParcelsRequest"));
	WSП_request.auth			= WSП_auth;
	WSП_request.selfPickup		=	ПараметрыРасчета.ДоставкаОтТерминала;
	WSП_request.selfDelivery	=	ПараметрыРасчета.ДоставкаДоТерминала;
	//WSП_request.weight			=   ПараметрыРасчета.Вес/1000;                 //кг
	//WSП_request.volume			=   ПараметрыРасчета.Ширина/100 * ПараметрыРасчета.Длина/100 * ПараметрыРасчета.Высота/100; //м3
	WSП_request.pickup			= 	WSП_pickup;
	WSП_request.delivery		= 	WSП_delivery;
	WSП_request.serviceCode		=	ПараметрыРасчета.СписокУслугЧзЗп;
	WSП_request.declaredValue   = 	ПараметрыРасчета.ОбъявленнаяСтоимость;     
	WSП_request.parcel.Добавить(WSП_parcel);     
	
	
	
	WSП = Фабрика.Создать(Фабрика.Тип(Namespace,"getServiceCostByParcels2"));
	WSП.request = WSП_request;

	Попытка
		РезультатРасчета = стр_Прокси.Прокси.getServiceCostByParcels2(WSП);
		Протокол.Результат	 		= "ok";
		Протокол.ТарифТК			= РезультатРасчета.return[0].cost;
		Протокол.РасчетКалькулятора	= "Итоговая цена: "+Протокол.ТарифТК+ " руб."+Символы.ПС+
		"	Дней доставки : "+РезультатРасчета.return[0].days+Символы.ПС+
		"	Услуга доставки  : "+РезультатРасчета.return[0].serviceName;
		Протокол.ПолученныеДанные		= Протокол.РасчетКалькулятора;
	Исключение
		Протокол.Результат	  			=	"error";
		Протокол.РасчетКалькулятора		= ОписаниеОшибки();
		Протокол.ТекстОшибки			= Протокол.РасчетКалькулятора;
		Протокол.ПолученныеДанные		= Протокол.РасчетКалькулятора;
	КонецПопытки;
	Протокол.ДатаОкончания		= ТекущаяДата();
	Возврат Протокол;
КонецФункции



Функция СозданиеЗаказаНаДоставку(Параметры) Экспорт
	Протокол					= Интеграция_ТранспортныеКомпании_Общий.ПолучитьСтруктуруПротокола(Перечисления.ВидыОбменовСДЭК.СозданиеЗаказаНаДоставку);
	Протокол.ОтправленныеДанные	= Интеграция_ТранспортныеКомпании_Общий.ПолучитьОтправляемыеДанные(Параметры);
	
	Прокси 	= ПолучитьПроксиЗаказ();
	Фабрика		= Прокси.Фабрика;
	Namespace  	= Прокси.Namespace;
	
	WSП_orders 	= Фабрика.Создать(Фабрика.Тип(Namespace,"dpdOrdersData"));
	WSП_orders.auth 	= ПолучитьТэг_Auth(Прокси);
	WSП_orders.header	= ПолучитьТэг_header(Прокси, Параметры);
	WSП_orders.order.Добавить(ПолучитьТэг_order(Прокси, Параметры));

	WSП = Фабрика.Создать(Фабрика.Тип(Namespace,"createOrder"));
	WSП.orders = WSП_orders;

	Попытка
		РезультатРасчета = Прокси.Прокси.createOrder(WSП);
		
		Если 	РезультатРасчета.return.Количество()>0 и 
			 	РезультатРасчета.return[0].status = "OK"  			тогда
			Протокол.Результат	 		= "ok";	
			Протокол.ТрекНомер 			= РезультатРасчета.return[0].orderNum;  //RU012266813
			Протокол.ПолученныеДанные 	= Протокол.ТрекНомер;
		Иначе
			Протокол.Результат	 			= "error";
			Протокол.ПолученныеДанные 		= РезультатРасчета.return[0].errorMessage;
			Протокол.ТекстОшибки     		= Протокол.ПолученныеДанные;
		КонецЕсли;
		
	Исключение
		Протокол.Результат	 			= "error";
		Протокол.ПолученныеДанные 		= ОписаниеОшибки();
		Протокол.ТекстОшибки     		= Протокол.ПолученныеДанные;
		
	КонецПопытки;
	Протокол.ДатаОкончания		= ТекущаяДата();
	Возврат Протокол;
КонецФункции


Функция ПолучитьНаклейкиЗаказа(СписокДокументовОтправления) Экспорт 
	Протокол					= Интеграция_ТранспортныеКомпании_Общий.ПолучитьСтруктуруПротокола(Перечисления.ВидыОбменовСДЭК.ПолучитьКвитанцию);
	Протокол.ОтправленныеДанные	= Интеграция_ТранспортныеКомпании_Общий.ПолучитьОтправляемыеДанные(СписокДокументовОтправления);

	Прокси 		= ПолучитьПроксиНаклейка();

	WSП 			= ПолучитьЭлементТипа(Прокси, "dpdGetLabelFile");
	WSП.auth 		= ПолучитьТэг_Auth(Прокси);
	WSП.fileFormat  = "PDF";
	WSП.pageSize	= "A5";
	
	Для каждого док из СписокДокументовОтправления Цикл
		WSП_order 	=  ПолучитьЭлементТипа(Прокси, "orderParam");
		WSП_order.orderNum 		= док.Значение.НомерЗаказа;
		WSП_order.parcelsNumber	= 1;//Количество наклеек;
		
		WSП.order.Добавить(WSП_order);
	КонецЦикла;
	Попытка
		РезультатРасчета 	= Прокси.Прокси.createLabelFile(WSП);
		Адрес=ПоместитьВоВременноеХранилище(РезультатРасчета.file,Новый УникальныйИдентификатор);
		Протокол.Результат	= "ok";	
		Протокол.Файл 		= Адрес;
		Протокол.ТипФайла 	= "Хранилище";
		Для каждого элем из РезультатРасчета.order Цикл
			Протокол.ПолученныеДанные 	= Протокол.ПолученныеДанные + 
					"трек: "+элем.orderNum +"cтатус: "+элем.status +" "+элем.errorMessage +Символы.ПС;
		КонецЦикла;	
	Исключение
		Протокол.Результат	 			= "error";
		Протокол.ПолученныеДанные 		= ОписаниеОшибки();
		Протокол.ТекстОшибки     		= Протокол.ПолученныеДанные;
	КонецПопытки;

	Возврат	Протокол;
КонецФункции	

Функция УдалениеЗаказа(Параметры) Экспорт
	Протокол					= Интеграция_ТранспортныеКомпании_Общий.ПолучитьСтруктуруПротокола(Перечисления.ВидыОбменовСДЭК.УдалениеЗаказа);
	Протокол.ОтправленныеДанные	= Интеграция_ТранспортныеКомпании_Общий.ПолучитьОтправляемыеДанные(Параметры);
	
	Прокси 	= ПолучитьПроксиЗаказ();
	Фабрика		= Прокси.Фабрика;
	Namespace  	= Прокси.Namespace;
	
	WSП_cancelOrder	= Фабрика.Создать(Фабрика.Тип(Namespace,"cancelOrder"));
	
	WSП 	= Фабрика.Создать(Фабрика.Тип(Namespace,"dpdOrderCancellation"));
	WSП.auth 	= ПолучитьТэг_Auth(Прокси);
	WSП.cancel.Добавить(ПолучитьТэг_cancel(Прокси, Параметры));
	
	WSП_cancelOrder.orders = WSП;
	
	Попытка
		РезультатРасчета = Прокси.Прокси.cancelOrder(WSП_cancelOrder);
		
		Если 	РезультатРасчета.return.Количество()>0 и 
			 	РезультатРасчета.return[0].status = "Canceled"	тогда
			Протокол.Результат	 		= "ok";	
			Протокол.ПолученныеДанные 	= РезультатРасчета.return[0].orderNum +" Удален";
		Иначе
			Протокол.Результат	 			= "error";
			Протокол.ПолученныеДанные 		= РезультатРасчета.return[0].errorMessage;
			Протокол.ТекстОшибки     		= Протокол.ПолученныеДанные;
		КонецЕсли;
		
	Исключение
		Протокол.Результат	 			= "error";
		Протокол.ПолученныеДанные 		= ОписаниеОшибки();
		Протокол.ТекстОшибки     		= Протокол.ПолученныеДанные;
		
	КонецПопытки;
	Протокол.ДатаОкончания		= ТекущаяДата();
	Возврат Протокол;	
КонецФункции	

#КонецОбласти



//
//
Функция ПолучитьСписокПунктовСОграничениеПоВесу(Страна = "RU", город = "Владивосток") Экспорт
	результат = новый Структура("СписокГородов, ОписаниеОшибки",неопределено, "");
	
	
	стр_Прокси 	= ПолучитьПроксиСправочники();
	Фабрика		= стр_Прокси.Фабрика;
	Namespace  	= стр_Прокси.Namespace;

	WSП_auth = ПолучитьТэг_Auth(стр_Прокси);
	
	WSП_request = Фабрика.Создать(Фабрика.Тип(Namespace,"dpdParcelShopRequest"));
	WSП_request.auth		= WSП_auth;
	WSП_request.countryCode	= Страна;
	WSП_request.cityName	= город;

	Попытка
		СписокГородов = стр_Прокси.Прокси.getParcelShops(WSП_request);
		тз_СписокГородов = новый ТаблицаЗначений;
		тз_СписокГородов.Колонки.Добавить("Код", 				Новый ОписаниеТипов("Строка"));
		тз_СписокГородов.Колонки.Добавить("Адрес", 				Новый ОписаниеТипов("Строка"));
		тз_СписокГородов.Колонки.Добавить("Тип",			 	Новый ОписаниеТипов("Строка"));
		тз_СписокГородов.Колонки.Добавить("КодГорода",			Новый ОписаниеТипов("Строка"));
		
		Для каждого пв  из СписокГородов.parcelShop Цикл
			строка_пв 				   = тз_СписокГородов.Добавить();
			строка_пв.код 			   = пв.code;
			строка_пв.Тип			   = ?(пв.parcelShopType = "П", "Постомат", "пункт приема/выдачи посылок");
			строка_пв.Адрес 		   = ПолучитьПредставлениеАдреса(пв.address);
			строка_пв.КодГорода 	   = пв.address.cityId;
		КонецЦикла;
		
		Результат.СписокГородов = тз_СписокГородов;
	Исключение
		результат.ОписаниеОшибки = ОписаниеОшибки();
	КонецПопытки;
	Возврат Результат;
КонецФункции

Функция ПолучитьПунктВыдачи(Код, город)
	ответ = новый структура("ПунктВыдачи,ОписаниеОшибки",Неопределено,"");
	Результат = ПолучитьСписокПунктовСОграничениеПоВесу(,город);
	Если Результат.ОписаниеОшибки = "" Тогда
		масс_Строк = Результат.СписокГородов.НайтиСтроки(новый Структура("Код", Код));
		если масс_Строк.Количество() = 0 Тогда
			ответ.ОписаниеОшибки = "Не удалось получить код города назначения! "+Символы.ПС+
								   "не найден пункт с кодом "+Код+" в городе "+город;
		КонецЕсли;	
		ответ.ПунктВыдачи = масс_Строк[0];
	Иначе
		ответ.ОписаниеОшибки = "Не удалось получить код города назначения! "+Символы.ПС+ Результат.ОписаниеОшибки;
	Конецесли;
	Возврат Ответ;
КонецФункции	



Функция ПолучитьСписокГородовСДоставкойНаложеннымПлатежом() Экспорт
	стр_Прокси 	= ПолучитьПроксиСправочники();
	Фабрика		= стр_Прокси.Фабрика;
	Namespace  	= стр_Прокси.Namespace;

	WSП_auth = ПолучитьТэг_Auth(стр_Прокси);
	
	WSП_request = Фабрика.Создать(Фабрика.Тип(Namespace,"dpdCitiesCashPayRequest"));
	WSП_request.auth		= WSП_auth;
	WSП_request.countryCode	= "RU";
	
	WSП = Фабрика.Создать(Фабрика.Тип(Namespace,"getCitiesCashPay"));
	WSП.request = WSП_request;

	Попытка
		СписокГородов = стр_Прокси.Прокси.getCitiesCashPay(WSП);
		Возврат СписокГородов;
	Исключение
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ОписаниеОшибки());	
	КонецПопытки;
	Возврат Неопределено;
КонецФункции	



Функция ПолучитьТэг_Auth(Прокси)
	ТранспортнаяКомпания = Справочники.ТранспортныеКомпании.DPD;
	WSП_auth = ПолучитьЭлементТипа(Прокси, "auth");
	WSП_auth.clientNumber	= Число(ТранспортнаяКомпания.Логин); //1032002675;
	WSП_auth.clientKey		= ТранспортнаяКомпания.Пароль; //"1E76FC1CBF79D94029065A06AE0C344AECA62BF3";
	Возврат WSП_auth;
КонецФункции	

Функция ПолучитьТэг_header(Прокси, Параметры)
	Отправитель = Справочники.ТранспортныеКомпании.DPD;
	Параметры_АдресОтправителя = Новый Структура("ФИО, КодПВЗ, Город, КонтактноеЛицо, Телефон, email");
	ЗаполнитьЗначенияСвойств(Параметры_АдресОтправителя,Отправитель);
	Параметры_АдресОтправителя.ФИО 				= Отправитель.НаименованиеОтправителя;
	Параметры_АдресОтправителя.КодПВЗ			= Отправитель.КодПунктаСдачи;
	
	WSП_header	= ПолучитьЭлементТипа(Прокси, "header");
	senderAddress = ПолучитьТэг_Address(Прокси, Параметры_АдресОтправителя);
	WSП_header.senderAddress    = senderAddress;
	WSП_header.datePickup 		= Формат(Параметры.ДатаПриемаГруза,"ДФ=yyyy-MM-dd");
	WSП_header.pickupTimePeriod = "9-18";
	WSП_header.payer            = Число(Справочники.ТранспортныеКомпании.DPD.Логин);
	Возврат WSП_header;
КонецФункции

Функция ПолучитьТэг_cancel(Прокси, Параметры)

	WSП_cancel	  = ПолучитьЭлементТипа(Прокси, "orderCancel");
	WSП_cancel.orderNumberInternal    = Параметры.НомерЗаказа;
	WSП_cancel.orderNum 			  = Параметры.НомерДПД;
	Возврат WSП_cancel;
КонецФункции


Функция ПолучитьТэг_order(Прокси, Параметры)
	WSП_order	= ПолучитьЭлементТипа(Прокси, "order");
	
	WSП_order.orderNumberInternal = Параметры.НомерЗаказа;					//Номер заказа в нашей системе
	WSП_order.serviceCode		  = Параметры.УслугаDPD.Код;                //код услуги доставки
	WSП_order.serviceVariant	  = "ТТ";									//вариант доставки    – от терминала DPD до терминала DPD.
	WSП_order.cargoNumPack        = 1;	                                    //количество грузомест
	WSП_order.cargoWeight		  = Параметры.Вес/1000;						// Вес кг	
	WSП_order.cargoVolume         = Параметры.Ширина/100 * Параметры.Длина/100 * Параметры.Высота/100; //м3
	WSП_order.cargoRegistered	  =	Параметры.Хрупкое;
	WSП_order.cargoValue          = Параметры.ОбъявленнаяСтоимость;
	WSП_order.cargoCategory		  = "тнп";	 								// содержимое отправки	
	Если Параметры.МетодОплаты=Перечисления.МетодыОплаты.cod Тогда
		WSП_order.paymentType     =	"ОУП";
	КонецЕсли;	
	//WSП_order.paymentType         = ?(Параметры.МетодОплаты=Перечисления.МетодыОплаты.cod,"ОУП","ОУО");
	WSП_order.receiverAddress     = ПолучитьТэг_Address(Прокси, Параметры);
	Возврат WSП_order;
КонецФункции

Функция ПолучитьТэг_Address(Прокси, Параметры)
	
	WSП_adress	= ПолучитьЭлементТипа(Прокси, "address");
	
	WSП_adress.name 		= Параметры.ФИО;
	WSП_adress.terminalCode = Параметры.КодПВЗ;
	WSП_adress.countryName  = "Россия";
	WSП_adress.city			= Параметры.Город;
	//WSП_adress.street		= Параметры.Улица;
	//WSП_adress.house		= Параметры.Дом;
	//WSП_adress.houseKorpus	= Параметры.Корпус;
	//WSП_adress.flat 		= Параметры.Квартира;
	WSП_adress.contactFio	= ?(Параметры.Свойство("КонтактноеЛицо"),Параметры.КонтактноеЛицо,Параметры.ФИО);
	WSП_adress.contactPhone	= Параметры.Телефон;
	WSП_adress.contactEmail = Параметры.email;
	Возврат WSП_adress; 
КонецФункции	

Функция ПолучитьПредставлениеАдреса(тег)
	Возврат тег.index+", "+тег.cityName+", "+тег.streetAbbr+". "+тег.street+", "+тег.houseNo;
КонецФункции	




//http://wstest.dpd.ru/services/geography2?wsdl
Функция ПолучитьПроксиСправочники()
    //URL = "http://wstest.dpd.ru/services/geography2?wsdl";
	URL = "http://ws.dpd.ru/services/geography2?wsdl";
    WSОпределения 	= Новый WSОпределения(URL);	
	Namespace 		= WSОпределения.Сервисы[0].URIПространстваИмен;
	WSПрокси 		= Новый WSПрокси(WSОпределения, Namespace, WSОпределения.Сервисы[0].Имя, WSОпределения.Сервисы[0].ТочкиПодключения[0].Имя);
	Возврат новый Структура("Прокси,Namespace,Фабрика",WSПрокси, Namespace, WSПрокси.ФабрикаXDTO);
КонецФункции	


//http://wstest.dpd.ru/services/calculator2?wsdl
Функция ПолучитьПроксиКалькуляттор()
    //URL = "http://wstest.dpd.ru/services/calculator2?wsdl";
	URL = "http://ws.dpd.ru/services/calculator2?wsdl";
    WSОпределения 	= Новый WSОпределения(URL);	
	Namespace 		= WSОпределения.Сервисы[0].URIПространстваИмен;
	WSПрокси 		= Новый WSПрокси(WSОпределения, Namespace, WSОпределения.Сервисы[0].Имя, WSОпределения.Сервисы[0].ТочкиПодключения[0].Имя);
	Возврат новый Структура("Прокси,Namespace,Фабрика",WSПрокси, Namespace, WSПрокси.ФабрикаXDTO);
КонецФункции	

//http://wstest.dpd.ru/services/order2?wsdl
Функция ПолучитьПроксиЗаказ()
    //URL = "http://wstest.dpd.ru/services/order2?wsdl";
	URL = "http://ws.dpd.ru/services/order2?wsdl";
    WSОпределения 	= Новый WSОпределения(URL);	
	Namespace 		= WSОпределения.Сервисы[0].URIПространстваИмен;
	WSПрокси 		= Новый WSПрокси(WSОпределения, Namespace, WSОпределения.Сервисы[0].Имя, WSОпределения.Сервисы[0].ТочкиПодключения[0].Имя);
	Возврат новый Структура("Прокси,Namespace,Фабрика",WSПрокси, Namespace, WSПрокси.ФабрикаXDTO);
КонецФункции	

//http://wstest.dpd.ru/services/label-print?wsdl
Функция ПолучитьПроксиНаклейка()
   // URL = "http://wstest.dpd.ru/services/label-print?wsdl";
	URL = "http://ws.dpd.ru/services/label-print?wsdl";
    WSОпределения 	= Новый WSОпределения(URL);	
	Namespace 		= WSОпределения.Сервисы[0].URIПространстваИмен;
	WSПрокси 		= Новый WSПрокси(WSОпределения, Namespace, WSОпределения.Сервисы[0].Имя, WSОпределения.Сервисы[0].ТочкиПодключения[0].Имя);
	Возврат новый Структура("Прокси,Namespace,Фабрика",WSПрокси, Namespace, WSПрокси.ФабрикаXDTO);
КонецФункции	


Функция ПолучитьЭлементТипа(Прокси, ИмяТипа)
	Фабрика		= Прокси.Фабрика;
	Namespace  	= Прокси.Namespace;
	Возврат Фабрика.Создать(Фабрика.Тип(Namespace,ИмяТипа));
КонецФункции	

