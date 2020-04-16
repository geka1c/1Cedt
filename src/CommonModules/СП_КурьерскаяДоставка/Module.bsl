Функция ДокументКурьерскойДоставки_из_Api(стр, документДоставки = неопределено) экспорт
	
	Если документДоставки = Неопределено Тогда
		документНайден		= Документы.КурьерскаяДоставка.НайтиПоНомеру(стр.id);
		Если ЗначениеЗаполнено(документНайден) Тогда
			документДоставки = документНайден.ПолучитьОбъект();
		Иначе
			документДоставки 				= Документы.КурьерскаяДоставка.СоздатьДокумент();
			документДоставки.Номер			= стр.id;
			документДоставки.Дата			= ТекущаяДата();
			документДоставки.СвойКурьер 	= Константы.СвойКурьер.Получить();
		КонецЕсли;

	КонецЕсли;
	Если 	ЗначениеЗаполнено(ДокументДоставки.СтатусДоставки) и 
			ДокументДоставки.СтатусДоставки <> Перечисления.СтатусыДоставки.ОжидаетСборки Тогда 	
			стр.Ссылка	= документДоставки.Ссылка;
			Возврат документДоставки.Ссылка;
	КонецЕсли;

	документДоставки.ТочкаСбора					= СП_РаботаСоСправочниками.ПолучитьПунктВыдачиПо_Коду(стр.distributor_code);
	документДоставки.Статус						= Перечисления.СтатусыГруппыДоставки[стр.status];
	документДоставки.Участник					= СП_РаботаСоСправочниками.ПолучитьУчастникаПо_Коду(стр.uid);
	документДоставки.МинимальнаяДатаДоставки	= СтоСПОбмен_Общий.ДатаИзСтроки(стр.min_delivery_date);
	документДоставки.МаксимальнаяДатаДоставки	= СтоСПОбмен_Общий.ДатаИзСтроки(стр.max_delivery_date);
	документДоставки.СрокХраненияГруппы			= Число(стр.date_range_limit);
	документДоставки.ДатаСоздания				= СтоСПОбмен_Общий.ДатаИзСтроки(стр.created_at);
	документДоставки.ДатаМодификации			= СтоСПОбмен_Общий.ДатаИзСтроки(стр.updated_at);
	документДоставки.МетодОплаты				= ?(стр.payment_method = "",Перечисления.МетодыОплаты.ПустаяСсылка(),Перечисления.МетодыОплаты[стр.payment_method]);
	документДоставки.СтатусДоставки 			= Перечисления.СтатусыДоставки.ОжидаетСборки;
	
	

	ДокументДоставки.Заказы.Очистить();
	для каждого заказ из стр.orders.order Цикл
		новыйЗаказ		= ДокументДоставки.Заказы.Добавить();
		новыйЗаказ.КодЗаказа 				= заказ.orderId;
		новыйЗаказ.Покупка					= СП_РаботаСоСправочниками.ПолучитьЗаказПоXDTO(заказ,"orderType");
		новыйЗаказ.ОбъявленнаяСтоимость		= заказ.payment_sum;
		Если заказ.packages <> Неопределено Тогда
			Для Каждого посылка Из заказ.packages.package Цикл
				ЗаказСПосылкой = ДокументДоставки.ЗаказыСПосылками.Добавить();
				ЗаполнитьЗначенияСвойств(ЗаказСПосылкой, новыйЗаказ);
				ЗаказСПосылкой.Посылка	= СП_РаботаСоСправочниками.ПолучитьПосылкуПо_Коду(Посылка);
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;	
	//	ТочкаНазначения		= СП_РаботаСоСправочниками.ПолучитьПунктВыдачиПо_Коду(стр.recipient_code);

	ДокументДоставки.Догрузить = (ДокументДоставки.ЗаказыСПосылками.Количество()=0);
	
	Попытка
			документДоставки.Записать();
			стр.Ссылка	= документДоставки.Ссылка;
		Возврат документДоставки.Ссылка;
	Исключение
		ТекстСообщения = "Не удалось создать документ Курьерской доставки №"+стр.id+Символы.ПС+
						ОписаниеОшибки();
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
	КонецПопытки;
	

	Возврат Неопределено;			
	
КонецФункции



#Область УдалитьЗаказыИзГруппы
Процедура УдалитьЗаказыИзГруппы(ДокументКД) Экспорт
	ЕстьЗаказыКОтмене = ДокументКД.Заказы.НайтиСтроки(новый Структура("ДоставкаОтменена",Истина)).Количество()>0;
	Если ЕстьЗаказыКОтмене и не ДокументКД.ОтправленаОтмена Тогда
		Отправили 			= ТекстЗапроса_УдалитьЗаказыИзГруппы(ДокументКД);
		Получили			= ОтправитьНаСайт(Отправили, ДокументКД.Ссылка,"Удаление заказов из группы");
		АнализОтвета		= АнализОтвета_УдаленияЗаказовИзГруппы(Получили.ПолученныеДанные);
		Если не АнализОтвета.авторизацияВыполнена Тогда Возврат; КонецЕсли;
		Для Каждого элем из АнализОтвета.groupsUnlink Цикл
			найденыеЗаказы = ДокументКД.Заказы.НайтиСтроки(новый Структура("КодЗаказа",элем.orderId));
			Для каждого Заказ из найденыеЗаказы Цикл
				Если Элем.result = "error" Тогда
					Заказ.ОшибкаОтмены 	= Истина;
					Заказ.Сообщение		= Элем.message; 
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
		ДокументКД.ОтправленаОтмена = Истина;
	КонецЕсли;
КонецПроцедуры	

Функция ТекстЗапроса_УдалитьЗаказыИзГруппы(ДокументКД) 
	ЗаписьXML=Новый ЗаписьXML;
	ЗаписьXML.УстановитьСтроку("UTF-8");
	ЗаписьXML.ЗаписатьНачалоЭлемента("distributors");
	ЗаписьXML.ЗаписатьАтрибут("xmlns:xsi", "http://www.w3.org/2001/XMLSchema-instance");
	ЗаписьXML.ЗаписатьАтрибут("xmlns:xsd", "http://www.w3.org/2001/XMLSchema");

	СписокЗаказовКОтмене	= ДокументКД.Заказы.НайтиСтроки(Новый Структура("ДоставкаОтменена", Истина ));
	
	 Для каждого стр из СписокЗаказовКОтмене Цикл 
		 ЗаписьXML.ЗаписатьНачалоЭлемента("groupsUnlink");
			 ЗаписьXML.ЗаписатьНачалоЭлемента("group");
			 
					 ЗаписьXML.ЗаписатьНачалоЭлемента("delivery_group_id");
					 	ЗаписьXML.ЗаписатьТекст(ДокументКД.Номер);
					 ЗаписьXML.ЗаписатьКонецЭлемента();
					 
					 ЗаписьXML.ЗаписатьНачалоЭлемента("orderType");
						ЗаписьXML.ЗаписатьТекст("sp");
					 ЗаписьXML.ЗаписатьКонецЭлемента();
					 
					ЗаписьXML.ЗаписатьНачалоЭлемента("orderId");
						ЗаписьXML.ЗаписатьТекст(Формат(стр.КодЗаказа, "ЧГ=0"));
					ЗаписьXML.ЗаписатьКонецЭлемента();
					 
					 ЗаписьXML.ЗаписатьНачалоЭлемента("uid");
					 	ЗаписьXML.ЗаписатьТекст(Формат(ДокументКД.Участник.Код,"ЧГ=0"));
					 ЗаписьXML.ЗаписатьКонецЭлемента();
					 
					 
			 
			 ЗаписьXML.ЗаписатьКонецЭлемента();
		 ЗаписьXML.ЗаписатьКонецЭлемента();		 
		 
	 КонецЦикла;





	ЗаписьXML.ЗаписатьКонецЭлемента();
	ОтправленныеДанные = ЗаписьXML.Закрыть();
	ОтправленныеДанные = СтрЗаменить(ОтправленныеДанные, "xmlns=""http://www.100sp.ru/XMLSchema-instance"" ", "");
	Возврат ОтправленныеДанные;
КонецФункции

Функция АнализОтвета_УдаленияЗаказовИзГруппы(ПолученныеДанные)
	стр_Результат			= Новый Структура;

	пространствоИмен		= "http://www.100sp.ru/api/distributor/upload/back";
	авторизацияВыполнена	= ложь;
	Тип_distributors		= ФабрикаXDTO.Тип(пространствоИмен, "distributors");
		
	ПолученныеДанные		= СтрЗаменить(ПолученныеДанные, "http://www.100sp.ru","http://www.100sp.ru/api/distributor/upload/back");
	ЧтениеXML 				= Новый ЧтениеXML;
	ЧтениеXML.УстановитьСтроку(ПолученныеДанные);
	
	Объект_distributors		= ФабрикаXDTO.ПрочитатьXML(ЧтениеXML,Тип_distributors);
	Если Объект_distributors.auth.result	= "ok" Тогда
		авторизацияВыполнена	= истина;
	КонецЕсли;
	                                                                                      
	Если Объект_distributors.groupsUnlink						<> Неопределено Тогда
		ТЗ	= СтоСПОбмен_Общий.ТЗ_поСпискуXDTO(Объект_distributors.groupsUnlink.group);
		стр_Результат.Вставить("groupsUnlink",ТЗ);
	КонецЕсли;

	стр_Результат.Вставить("авторизацияВыполнена",авторизацияВыполнена);
	Возврат стр_Результат;	
	
КонецФункции

#КонецОбласти


#Область ОтправитьВыдачуЗаказов
Процедура Отправить_ВыдачуЗаказов(ДокументКД) Экспорт
	Если не ДокументКД.СвойКурьер Тогда возврат; КонецЕсли;
	
	ЕстьЗаказыКОтправке = ДокументКД.ЗаказыНаСкладе.НайтиСтроки(новый Структура("Подбор",Истина)).Количество()>0;
	Если ЕстьЗаказыКОтправке и не ДокументКД.ОтправленаВыдача Тогда
		Отправили 			= ТекстЗапроса_ВыдачаЗаказа(ДокументКД);
		Получили			= ОтправитьНаСайт(Отправили, ДокументКД.Ссылка,"Выдача заказов");
		АнализОтвета		= АнализОтвета_ВыдачаЗаказов(Получили.ПолученныеДанные);
		Если не АнализОтвета.авторизацияВыполнена Тогда Возврат; КонецЕсли;
		Для Каждого элем из АнализОтвета.deliveries Цикл
			ТекущаяПосылка = СП_РаботаСоСправочниками.ПолучитьПосылкуПо_Коду(элем.PackageId);
			найденыеЗаказы = ДокументКД.ЗаказыНаскладе.НайтиСтроки(новый Структура("Посылка, Подбор",ТекущаяПосылка, Истина));
			Для каждого Заказ из найденыеЗаказы Цикл
				Если Элем.result = "ap" или Элем.result = "ok" Тогда
					Заказ.Отправлено 	= Истина;
				ИначеЕсли Элем.result = "error" Тогда
					Заказ.Отправлено 	= Ложь;
					Заказ.Сообщение		= Элем.message; 
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
		ДокументКД.ОтправленаВыдача = Истина;
	КонецЕсли;
КонецПроцедуры	

Функция АнализОтвета_ВыдачаЗаказов(ПолученныеДанные)
	стр_Результат			= Новый Структура;

	пространствоИмен		= "http://www.100sp.ru/api/distributor/upload/back";
	авторизацияВыполнена	= ложь;
	Тип_distributors		= ФабрикаXDTO.Тип(пространствоИмен, "distributors");
		
	ПолученныеДанные		= СтрЗаменить(ПолученныеДанные, "http://www.100sp.ru","http://www.100sp.ru/api/distributor/upload/back");
	ЧтениеXML 				= Новый ЧтениеXML;
	ЧтениеXML.УстановитьСтроку(ПолученныеДанные);
	
	Объект_distributors		= ФабрикаXDTO.ПрочитатьXML(ЧтениеXML,Тип_distributors);
	Если Объект_distributors.auth.result	= "ok" Тогда
		авторизацияВыполнена	= истина;
	КонецЕсли;
	                                                                                      
	Если Объект_distributors.deliveries						<> Неопределено Тогда
		ТЗ	= СтоСПОбмен_Общий.ТЗ_поСпискуXDTO(Объект_distributors.deliveries.delivery);
		стр_Результат.Вставить("deliveries",ТЗ);
	КонецЕсли;

	стр_Результат.Вставить("авторизацияВыполнена",авторизацияВыполнена);
	Возврат стр_Результат;	
	
КонецФункции

Функция ТекстЗапроса_ВыдачаЗаказа(ДокументКД) 
	ЗаписьXML=Новый ЗаписьXML;
	ЗаписьXML.УстановитьСтроку("UTF-8");
	ЗаписьXML.ЗаписатьНачалоЭлемента("distributors");
	ЗаписьXML.ЗаписатьАтрибут("xmlns:xsi", "http://www.w3.org/2001/XMLSchema-instance");
	ЗаписьXML.ЗаписатьАтрибут("xmlns:xsd", "http://www.w3.org/2001/XMLSchema");

	СписокЗаказовКВыдаче	= ДокументКД.ЗаказыНаСкладе.НайтиСтроки(Новый Структура("Подбор", Истина ));
	ЗаписьXML.ЗаписатьНачалоЭлемента("deliveries");
	 Для каждого стр из СписокЗаказовКВыдаче Цикл 
		ЗаписьXML.ЗаписатьНачалоЭлемента("delivery");
			 
			 СтоСП.Вставить_Тэг(ЗаписьXML,"arrivalNumber"	, 	Прав(ДокументКД.Номер,6));
			 СтоСП.Вставить_Тэг(ЗаписьXML,"date"	, 			ДокументКД.Дата);
			 СтоСП.Вставить_Тэг(ЗаписьXML,"paidSum"	, 			Формат(стр.СтоимостьИтого - стр.ОплачиваетОрганизатор,		"ЧГ=0"));
	         Если Стр.ОплачиваетОрганизатор>0 Тогда
				СтоСП.Вставить_Тэг(ЗаписьXML,"paidSumOrg",			Формат(Стр.ОплачиваетОрганизатор,	"ЧГ=0"));
			 КонецЕсли;	
			 	
			 СтоСП.Вставить_Тэг(ЗаписьXML,"packageId"	, 			Формат(стр.Посылка.Код,"ЧГ=0;"));
			 СтоСП.Вставить_Тэг(ЗаписьXML,"orderType"	, 			"package");
			 СтоСП.Вставить_Тэг(ЗаписьXML,"isSpCourier"	, 			1);
			 
		 ЗаписьXML.ЗаписатьКонецЭлемента();
		 		 
		 
	 КонецЦикла;
	ЗаписьXML.ЗаписатьКонецЭлемента();

	ЗаписьXML.ЗаписатьКонецЭлемента();
	ОтправленныеДанные = ЗаписьXML.Закрыть();
	ОтправленныеДанные = СтрЗаменить(ОтправленныеДанные, "xmlns=""http://www.100sp.ru/XMLSchema-instance"" ", "");
	Возврат ОтправленныеДанные;
КонецФункции
#КонецОбласти





Функция ТекстЗапроса_Счет_Api(ДокументКД)	Экспорт
	 ЗаписьXML=новый ЗаписьXML;
	 ЗаписьXML.УстановитьСтроку("UTF-8");
	 ЗаписьXML.ЗаписатьНачалоЭлемента("distributors");
	 
	 ЗаписьXML.ЗаписатьАтрибут("xmlns:xsi","http://www.w3.org/2001/XMLSchema-instance");
	 ЗаписьXML.ЗаписатьАтрибут("xmlns:xsd","http://www.w3.org/2001/XMLSchema");
	 	
	 
		 ЗаписьXML.ЗаписатьНачалоЭлемента("groupsBill");
			 ЗаписьXML.ЗаписатьНачалоЭлемента("group");
			 
				 ЗаписьXML.ЗаписатьНачалоЭлемента("delivery_group_id");
				 	ЗаписьXML.ЗаписатьТекст(ДокументКД.номер);
				 ЗаписьXML.ЗаписатьКонецЭлемента();
				 
				 ЗаписьXML.ЗаписатьНачалоЭлемента("weight");
				 	ЗаписьXML.ЗаписатьТекст(Формат(0,"ЧГ=0"));
				 ЗаписьXML.ЗаписатьКонецЭлемента();
				 
				 ЗаписьXML.ЗаписатьНачалоЭлемента("width");
				 	ЗаписьXML.ЗаписатьТекст(Формат(0,"ЧГ=0"));
				 ЗаписьXML.ЗаписатьКонецЭлемента();
				 
				 ЗаписьXML.ЗаписатьНачалоЭлемента("height");
				 	ЗаписьXML.ЗаписатьТекст(Формат(0,"ЧГ=0"));
				 ЗаписьXML.ЗаписатьКонецЭлемента();
	 
				 ЗаписьXML.ЗаписатьНачалоЭлемента("length");
				 	ЗаписьXML.ЗаписатьТекст(Формат(0,"ЧГ=0"));
				 ЗаписьXML.ЗаписатьКонецЭлемента();
	 
				 ЗаписьXML.ЗаписатьНачалоЭлемента("prepay_price");
				 	ЗаписьXML.ЗаписатьТекст(Формат(ДокументКД.СтоимостьДоставки,"ЧДЦ=2; ЧГ=0"));
				 ЗаписьXML.ЗаписатьКонецЭлемента();
	 
				 ЗаписьXML.ЗаписатьНачалоЭлемента("cod_price");
				 	ЗаписьXML.ЗаписатьТекст(Формат(ДокументКД.СтоимостьДоставки,"ЧДЦ=2; ЧГ=0"));
				 ЗаписьXML.ЗаписатьКонецЭлемента();
				 
				 ЗаписьXML.ЗаписатьНачалоЭлемента("bill_date");
				 	ЗаписьXML.ЗаписатьТекст(Строка(ДокументКД.Дата));
				 ЗаписьXML.ЗаписатьКонецЭлемента();
				 
			 ЗаписьXML.ЗаписатьКонецЭлемента();
		 ЗаписьXML.ЗаписатьКонецЭлемента();		 
		 

	 ЗаписьXML.ЗаписатьКонецЭлемента();	
	ТекстЗапроса = ЗаписьXML.Закрыть();	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса,"xmlns=""http://www.100sp.ru/XMLSchema-instance"" ","");
	Возврат ТекстЗапроса;	
КонецФункции	

Функция Статистика() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	КурьерскаяДоставка.Статус,
		|	СУММА(1) КАК КоличествоЗаказов
		|ИЗ
		|	Документ.КурьерскаяДоставка КАК КурьерскаяДоставка
		|ГДЕ
		|		КурьерскаяДоставка.СтатусДоставки <> ЗНАЧЕНИЕ(Перечисление.СтатусыДоставки.Отправлен)
		|	 и 	КурьерскаяДоставка.СтатусДоставки <> ЗНАЧЕНИЕ(Перечисление.СтатусыДоставки.Отменен)
		|СГРУППИРОВАТЬ ПО
		|	КурьерскаяДоставка.Статус";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Результат = новый структура;
	
		
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Результат.Вставить(ВыборкаДетальныеЗаписи.статус.имя,ВыборкаДетальныеЗаписи.количествоЗаказов);	// Вставить обработку выборки ВыборкаДетальныеЗаписи
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции	




Функция ОтправитьНаСайт(Отправили, Ссылка, Описание) 
	СтрокаПротокола						= 	новый Структура ("ДатаНачала, ДатаОкончания,Описание, Отправили, Результат, ПолученныеДанные");
	СтрокаПротокола.Отправили			= 	Отправили;
	СтрокаПротокола.ДатаНачала			=	ТекущаяДата();
	СтрокаПротокола.Описание			=	Описание;
	
	АдресСкрипта 		= Константы.АдресВыгрузкиНасайт.Получить();
	Параметры    		= новый Структура;
	Параметры.Вставить("token",	Константы.Токен.Получить());
	Параметры.Вставить("xml", 	Отправили);
	
	ПолученныйФайл		= СтоСПОбмен_Общий.ПолучитьПостЗапросом(Параметры,АдресСкрипта);
	
	Если ПолученныйФайл	= Неопределено Тогда 		
		СтрокаПротокола.Результат		= Ложь; 
		СтрокаПротокола.ДатаОкончания	= ТекущаяДата();
		Возврат СтрокаПротокола;	
	КонецЕсли; 
	Если аспПроцедурыОбменаДанными.АвторизацияВыполнена(ПолученныйФайл) Тогда
		СтрокаПротокола.Результат= Истина;
		СтрокаПротокола.ПолученныеДанные	=  СтоСПОбмен_Общий.ФайлВСтроку(ПолученныйФайл);
	Иначе
		СтрокаПротокола.ПолученныеДанные	= "Авторизация не выполнена" + СтоСПОбмен_Общий.ФайлВСтроку(ПолученныйФайл);
	КонецЕсли;	
	СтрокаПротокола.ДатаОкончания			= ТекущаяДата();
	СтоСПОбмен_Выгрузка100сп.СохранитьПротоколОбмена(СтрокаПротокола,Ссылка);
	Возврат СтрокаПротокола;
КонецФункции