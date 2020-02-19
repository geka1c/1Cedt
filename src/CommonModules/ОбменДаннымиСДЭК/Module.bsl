#Область ПрограммныйИнтерфейс

Функция РассчитатьСтоимость(Параметры) Экспорт
	Протокол	= Интеграция_ТранспортныеКомпании_Общий.ПолучитьСтруктуруПротокола();
	Протокол.РасчетКалькулятора		= "";
	Протокол.ТекстОшибки			= "";
	Протокол.ТарифТК				= 0;
	

	Протокол.ОтправленныеДанные  = ОбменДаннымиСДЭК.ПолучитьЖСОНСДЭКРасчитатьТариф(Параметры);
	Протокол.ДатаНачала			 = ТекущаяДата();
	Протокол.ВидОбмена			 = Перечисления.ВидыОбменовСДЭК.СтоимостьПоТарифу;

	Протокол.ПолученныеДанные    = ОбменССайтомСтоимостьТарифа(Протокол.ОтправленныеДанные);
	
	Если Протокол.ПолученныеДанные <> неопределено Тогда
		структураЖсон=ОбменДаннымиСДЭК.РазобратьЖСОН(Протокол.ПолученныеДанные);
		Если структураЖсон.Свойство("error") Тогда
			Протокол.Результат	  =	"error";
			
			Протокол.ТекстОшибки = "Возникли ошибки при расчете стоимости: "+Символы.ПС;
			
			Для каждого элем из структураЖсон.error Цикл
				Протокол.ТекстОшибки 		= Протокол.ТекстОшибки + "код ошибки:"+элем.code+"; описание: "+элем.text+Символы.ПС;
				Протокол.РасчетКалькулятора	= Протокол.РасчетКалькулятора+"код ошибки:"+элем.code+"; описание: "+элем.text+Символы.ПС;
			КонецЦикла;
			
		ИначеЕсли структураЖсон.Свойство("result") Тогда
			Протокол.Результат			= "ok";
			Протокол.ТарифТК			= структураЖсон.result.price;
			Протокол.РасчетКалькулятора	= "сумма за доставку: "+структураЖсон.result.price+ " руб."+Символы.ПС+
			"минимальная дата доставки: "+структураЖсон.result.deliveryDateMin+ " "+Символы.ПС+
			"максимальная дата доставки: "+структураЖсон.result.deliveryDateMax+ " "+Символы.ПС+
			"код тарифа: "+структураЖсон.result.tariffId;
		КонецЕсли;	
	КонецЕсли;
	Протокол.ДатаОкончания = ТекущаяДата();
	
	Возврат	Протокол; 
	
КОнецФункции	

//Функция СозданиеЗаказаНаДоставку(Параметры) Экспорт
//	Протокол					= Интеграция_ТранспортныеКомпании_Общий.ПолучитьСтруктуруПротокола(Перечисления.ВидыОбменовСДЭК.СозданиеЗаказаНаДоставку);
//	Протокол.ОтправленныеДанные	= Интеграция_ТранспортныеКомпании_Общий.ПолучитьОтправляемыеДанные(Параметры);
//	
//	стрХМЛ=ОбменДаннымиСДЭК.ПолучитьХМЛСДЭКСоздатьЗаказ(Ссылка);
//	
//	Протокол.ДатаОкончания		= ТекущаяДата();
//	Возврат Протокол;
//КонецФункции	

#КонецОбласти 







Процедура ЗаписатьНачалоТэга(ЗаписьXML,ИмяТэга,СтрСвойства)
		ЗаписьXML.ЗаписатьНачалоЭлемента(ИмяТэга);
		Для каждого стр из стрСвойства Цикл
			ЗаписьXML.ЗаписатьАтрибут(стр.Ключ		,Строка(стр.Значение));	
		КонецЦикла;	
КонецПроцедуры


Функция ПолучитьХМЛСДЭКСоздатьЗаказ(ДокОтправлениеТранзита)  Экспорт
	
	масСтрокИсключения=ДокОтправлениеТранзита.Заказы.НайтиСтроки(новый Структура("Исключить",Истина));
	ЗаписьXML=новый ЗаписьXML;
	ЗаписьXML.УстановитьСтроку("UTF-8");
	#Область DeliveryRequest
	стрСвойства=ПолучитьСтруктуруТэгаDeliveryRequest(ДокОтправлениеТранзита);
	ЗаписатьНачалоТэга(ЗаписьXML,"DeliveryRequest",СтрСвойства);

		#Область Order
		стрСвойства=ПолучитьСтруктуруТэгаORDER(ДокОтправлениеТранзита);
		ЗаписатьНачалоТэга(ЗаписьXML,"Order",СтрСвойства);
		
			#Область Address
				стрСвойства=ПолучитьСтруктуруТэгаAddress(ДокОтправлениеТранзита);
				ЗаписатьНачалоТэга(ЗаписьXML,"Address",СтрСвойства);
				ЗаписьXML.ЗаписатьКонецЭлемента();
			#КОнецОбласти

			#Область Package
				стрСвойства=ПолучитьСтруктуруТэгаPackage(ДокОтправлениеТранзита);
				ЗаписатьНачалоТэга(ЗаписьXML,"Package",СтрСвойства);
				
				#Область Item 
				 ОбщийВес=ДокОтправлениеТранзита.Вес;
				 
				 ВесОдногоЗаказа=ОбщийВес/(ДокОтправлениеТранзита.Заказы.Количество()-масСтрокИсключения.Количество());
				 
				для каждого стрЗаказ из ДокОтправлениеТранзита.Заказы Цикл
					Если стрЗаказ.Исключить Тогда Продолжить; Конецесли ;
					стрСвойства=ПолучитьСтруктуруТэгаItem(стрЗаказ,ВесОдногоЗаказа,ДокОтправлениеТранзита.Участник.Код);
					ЗаписатьНачалоТэга(ЗаписьXML,"Item",СтрСвойства);
					ЗаписьXML.ЗаписатьКонецЭлемента();
				КонецЦикла;
				#КОнецОбласти
				ЗаписьXML.ЗаписатьКонецЭлемента();
			#КОнецОбласти
			
			#Область AddService
			Если ДокОтправлениеТранзита.СМСОповещение Тогда
				стрСвойства=ПолучитьСтруктуруТэгаAddService("""27""");
				ЗаписатьНачалоТэга(ЗаписьXML,"AddService",стрСвойства);
				ЗаписьXML.ЗаписатьКонецЭлемента();
			КонецЕсли;
			#КОнецОбласти

			
			
		ЗаписьXML.ЗаписатьКонецЭлемента();
		#КОнецОбласти
	ЗаписьXML.ЗаписатьКонецЭлемента();
	#КОнецОбласти
	стр =ЗаписьXML.Закрыть();
	Возврат стр;
КонецФункции	

Функция ПолучитьХМЛСДЭКУдалитьЗаказ(ДокОтправлениеТранзита)  Экспорт
	//ДокОтправлениеТранзита=ДанныеФормыВЗначение(ДанныеФормы,Тип("ДокументОбъект.ОтправлениеТранзита"));
	//ДокОтправлениеТранзита=Документы.ОтправлениеТранзита.СоздатьДокумент();

	ЗаписьXML=новый ЗаписьXML;
	ЗаписьXML.УстановитьСтроку("UTF-8");
	#Область DeleteRequest
	стрСвойства=ПолучитьСтруктуруТэгаDeleteRequest(ДокОтправлениеТранзита);
	ЗаписатьНачалоТэга(ЗаписьXML,"DeleteRequest",СтрСвойства);

		#Область Order
		стрСвойства=ПолучитьСтруктуруТэгаORDERУдаление(ДокОтправлениеТранзита);
		ЗаписатьНачалоТэга(ЗаписьXML,"Order",СтрСвойства);
		
		ЗаписьXML.ЗаписатьКонецЭлемента();
		#КОнецОбласти
	ЗаписьXML.ЗаписатьКонецЭлемента();
	#КОнецОбласти
	стр =ЗаписьXML.Закрыть();
	Возврат стр;

	
	
	
КонецФункции	


Функция ПолучитьХМЛСДЭКПолучитьКвитанцию(ДокОтправлениеТранзита)  Экспорт
	//ДокОтправлениеТранзита=ДанныеФормыВЗначение(ДанныеФормы,Тип("ДокументОбъект.ОтправлениеТранзита"));
	//ДокОтправлениеТранзита=Документы.ОтправлениеТранзита.СоздатьДокумент();

	ЗаписьXML=новый ЗаписьXML;
	ЗаписьXML.УстановитьСтроку("UTF-8");
	#Область OrdersPrint
	стрСвойства=ПолучитьСтруктуруТэгаOrdersPrint(ДокОтправлениеТранзита);
	ЗаписатьНачалоТэга(ЗаписьXML,"OrdersPrint",СтрСвойства);

		#Область Order
		стрСвойства=ПолучитьСтруктуруТэгаORDER_PDF(ДокОтправлениеТранзита);
		ЗаписатьНачалоТэга(ЗаписьXML,"Order",СтрСвойства);
		ЗаписьXML.ЗаписатьКонецЭлемента();
		#КОнецОбласти
	ЗаписьXML.ЗаписатьКонецЭлемента();
	#КОнецОбласти

	стр =ЗаписьXML.Закрыть();
	Возврат стр;
КонецФункции	



Функция ПолучитьЖСОНСДЭКРасчитатьТариф(ДокОтправлениеТранзита) Экспорт
	ЗаписьJSON=новый ЗаписьJSON	;
	ЗаписьJSON.УстановитьСтроку();
	ЗаписатьJSON(ЗаписьJSON,ПолучитьСтруктуруЖСОНДляСтоимостиТарифа(ДокОтправлениеТранзита));
	Возврат ЗаписьJSON.Закрыть();
КонецФункции	

Функция ПолучитьСтруктуруЖСОНДляСтоимостиТарифа(Параметры)
	
	ДатаДокумента		= ПолучитьДатуUTC(Параметры.ДатаДокумента);
	secure 				= ПолучитьСекретныйКод(Параметры.Пароль,Параметры.ДатаДокумента) ;
	
	стрСвойства=новый структура;
	стрСвойства.Вставить("version"			,"1.0");    			
	стрСвойства.Вставить("dateExecute"		,ДатаДокумента);      
	стрСвойства.Вставить("authLogin"		,Параметры.Логин);        		
	стрСвойства.Вставить("secure"			,secure);        	

	стрСвойства.Вставить("senderCityId"		,Параметры.КодГородаОтправителя);        		
	стрСвойства.Вставить("receiverCityId"	,Формат(Параметры.КодГородаПолучателя,"ЧГ=0"));        		
	
	стрТариф1=новый Структура;
	стрТариф1.Вставить("priority",1);
	стрТариф1.Вставить("id",Параметры.Тариф);
	
	массТаифов=новый Массив();
	массТаифов.Добавить(стрТариф1);
	
	стрСвойства.Вставить("tariffList"			,массТаифов);       
	
	стрГабариты1=новый структура;
	стрГабариты1.Вставить("weight"	,Параметры.Вес/1000);
	стрГабариты1.Вставить("length"	,Параметры.Длина);
	стрГабариты1.Вставить("width"	,Параметры.Ширина);
	стрГабариты1.Вставить("height"	,Параметры.Высота);
	
	                                                                
	массГабаритов=новый Массив();
	массГабаритов.Добавить(стрГабариты1);
	
	стрСвойства.Вставить("goods",массГабаритов);        		


	
	Если Параметры.ТяжелыйГруз Тогда
		стрДопУслуги = новый структура;
		стрДопУслуги.Вставить("id", "5");
		
		массДопУслуги = новый Массив();
		массДопУслуги.Добавить(стрДопУслуги);

		стрСвойства.Вставить("services", массДопУслуги);
	КонецЕсли;
	
	Возврат стрСвойства;		
КонецФункции	



#Область ЗаполнениетэговнаУдалениезаказа

Функция ПолучитьСтруктуруТэгаDeleteRequest(ДокОтправлениеТранзита)
	//ДокОтправлениеТранзита=Документы.ОтправлениеТранзита.СоздатьДокумент();

	АккаунтСДЭК			= ДокОтправлениеТранзита.ТочкаНазначения.АккаунтДляОбменаСТК;
	secure_password		= ДокОтправлениеТранзита.ТочкаНазначения.ПарольДляОбменаСТК;
	НомерАктаПП			= Константы.СвояТочка.Получить().Код+"_"+ДокОтправлениеТранзита.Номер;
	ДатаДокумента		= ПолучитьДатуUTC(ДокОтправлениеТранзита.дата);
	//secure 				= "985237b4aee1e6151cce518c3c1a9a63";
	secure 				= ПолучитьСекретныйКод(secure_password,ДокОтправлениеТранзита.Дата) ;
 	стрСвойства=новый структура;
	стрСвойства.Вставить("Number"		,НомерАктаПП);		//varchar(30)		Номер акта приема-передачи/ТТН (сопроводительного документа при передаче груза СДЭК, формируется в системе ИМ), так же используется для удаления заказов
	стрСвойства.Вставить("Date"			,ДатаДокумента);    //date			Дата документа (дата заказа)
	стрСвойства.Вставить("Account"		,АккаунтСДЭК);      //varchar(255)	Идентификатор ИМ, передаваемый СДЭКом.
	стрСвойства.Вставить("Secure"		,secure);        	//varchar(255)	ключ (см. Протокол обмена)
	стрСвойства.Вставить("OrderCount"	,1); 				//number			Общее количество заказов в документе
	Возврат стрСвойства;
	
	
КонецФункции	


Функция ПолучитьСтруктуруТэгаORDERУдаление(ДокОтправлениеТранзита)
	//ДокОтправлениеТранзита=Документы.ОтправлениеТранзита.СоздатьДокумент();
	стрСвойстваЗаказ=новый структура;
	стрСвойстваЗаказ.Вставить("Number",			ДокОтправлениеТранзита.Номер);                 					//varchar(30)	Номер отправления клиента (должен быть уникален в пределах акта приема-передачи)
	Возврат стрСвойстваЗаказ;	
КонецФункции


#КонецОбласти

#Область Заполнениетэговнаполучениеквитанции

Функция  ПолучитьСтруктуруТэгаOrdersPrint(ДокОтправлениеТранзита)
	АккаунтСДЭК			= ДокОтправлениеТранзита.ТочкаНазначения.АккаунтДляОбменаСТК;
	secure_password		= ДокОтправлениеТранзита.ТочкаНазначения.ПарольДляОбменаСТК;
	//НомерАктаПП			= Константы.СвояТочка.Получить().Код+"_"+ДокОтправлениеТранзита.Номер;
	ДатаДокумента		= ПолучитьДатуUTC(ДокОтправлениеТранзита.дата);
	secure 				= ПолучитьСекретныйКод(secure_password,ДокОтправлениеТранзита.Дата) ;
	
	стрСвойства=новый структура;
	стрСвойства.Вставить("Date"			,ДатаДокумента);    //date			Дата документа (дата заказа)
	стрСвойства.Вставить("Account"		,АккаунтСДЭК);      //varchar(255)	Идентификатор ИМ, передаваемый СДЭКом.
	стрСвойства.Вставить("Secure"		,secure);        	//varchar(255)	ключ (см. Протокол обмена)
	стрСвойства.Вставить("OrderCount"	,1);        		//number		Общее количество передаваемых в документе заказов
	стрСвойства.Вставить("CopyCount"	,4);        		//number		Число копий одной квитанции на листе. Рекомендовано указывать не менее 2, одна приклеивается на груз, вторая остается у отправителя.
	Возврат стрСвойства;		
КонецФункции	

Функция  ПолучитьСтруктуруТэгаORDER_PDF(ДокОтправлениеТранзита)
	стрСвойства=новый структура;
	стрСвойства.Вставить("DispatchNumber"	,ДокОтправлениеТранзита.НомерЗаказа);    //number			Номер отправления СДЭК(присваивается при импорте заказов)
	Возврат стрСвойства;		
КонецФункции	

#КОнецОбласти

#Область ЗаполнениетэговнаСозданиезаказа

Функция ПолучитьСтруктуруТэгаDeliveryRequest(ДокОтправлениеТранзита)
	//ДокОтправлениеТранзита=Документы.ОтправлениеТранзита.СоздатьДокумент();

	АккаунтСДЭК			= ДокОтправлениеТранзита.ТочкаНазначения.АккаунтДляОбменаСТК;
	secure_password		= ДокОтправлениеТранзита.ТочкаНазначения.ПарольДляОбменаСТК;
	НомерАктаПП			= Константы.СвояТочка.Получить().Код+"_"+ДокОтправлениеТранзита.Номер;
	текДата=ТекущаяДата();
	ДатаДокумента		= ПолучитьДатуUTC(текДата);
	//ДатаДокумента		= ПолучитьДатуUTC(ДокОтправлениеТранзита.дата);
	//secure 				= "985237b4aee1e6151cce518c3c1a9a63";
	secure 				= ПолучитьСекретныйКод(secure_password,текДата) ;
 	стрСвойства=новый структура;
	стрСвойства.Вставить("Number"		,НомерАктаПП);		//varchar(30)		Номер акта приема-передачи/ТТН (сопроводительного документа при передаче груза СДЭК, формируется в системе ИМ), так же используется для удаления заказов
	стрСвойства.Вставить("Date"			,ДатаДокумента);    //date			Дата документа (дата заказа)
	стрСвойства.Вставить("Currency"		,"RUB");			//varchar(10)		Идентификатор валюты для указания цен (см. Приложение, таблица 6)
	стрСвойства.Вставить("Account"		,АккаунтСДЭК);      //varchar(255)	Идентификатор ИМ, передаваемый СДЭКом.
	стрСвойства.Вставить("Secure"		,secure);        	//varchar(255)	ключ (см. Протокол обмена)
	стрСвойства.Вставить("OrderCount"	,1); 				//number			Общее количество заказов в документе
	Возврат стрСвойства;
	
	
КонецФункции	

Функция ПолучитьСтруктуруТэгаORDER(ДокОтправлениеТранзита)
	//ДокОтправлениеТранзита=Документы.ОтправлениеТранзита.СоздатьДокумент();
	стрСвойстваЗаказ=новый структура;
	стрСвойстваЗаказ.Вставить("Number",			ДокОтправлениеТранзита.Номер);                 					//varchar(30)	Номер отправления клиента (должен быть уникален в пределах акта приема-передачи)
	стрСвойстваЗаказ.Вставить("DateInvoice",	ПолучитьДатуUTC(ДокОтправлениеТранзита.дата)); 					//date			Дата инвойса
	стрСвойстваЗаказ.Вставить("SendCityCode",	ДокОтправлениеТранзита.ГородОтправитель.Код);   //number		Код города отправителя из базы СДЭК
	стрСвойстваЗаказ.Вставить("RecCityCode",	Формат(ДокОтправлениеТранзита.cityCode,"ЧГ=0"));                               //number		Код города получателя из базы СДЭК
	стрСвойстваЗаказ.Вставить("RecipientName",	ДокОтправлениеТранзита.ФИО);          					        //varchar(128)	Получатель (ФИО)
	стрСвойстваЗаказ.Вставить("RecipientEmail",	ДокОтправлениеТранзита.email);                                  //varchar(255)  Email получателя для рассылки уведомлений о движении заказа, для связи в случае недозвона. 
	стрСвойстваЗаказ.Вставить("Phone",			ДокОтправлениеТранзита.Телефон);                                //varchar(50)   Телефон получателя
	стрСвойстваЗаказ.Вставить("TariffTypeCode",	ДокОтправлениеТранзита.Тариф.КодТарифа);                          									//number		Код типа тарифа (см. Приложение, таблица 1)
	стрСвойстваЗаказ.Вставить("DeliveryRecipientCost",	Формат(ДокОтправлениеТранзита.ИтогоСтоимость,"ЧГ=0"));         //real  		Доп. сбор за доставку, которую ИМ берет с получателя (в указанной валюте)							//number		Код типа тарифа (см. Приложение, таблица 1)
	
	стрСвойстваЗаказ.Вставить("Comment",		ДокОтправлениеТранзита.Комментарий);                            //varchar(255)  Комментарий по заказу
	стрСвойстваЗаказ.Вставить("SellerName",		ДокОтправлениеТранзита.ТочкаНазначения.ПродавецДляТК);                                                            //varchar(255)  Истинный продавец. Используется при печати инвойсов для отображения настоящего продавца товара, либо торгового названия
	стрСвойстваЗаказ.Вставить("SellerAddress",	ДокОтправлениеТранзита.ТочкаНазначения.АдресПродавцаДляТК);                                                            //varchar(255)  Адрес истинного продавца. Используется при печати инвойсов для отображения адреса настоящего продавца товара, либо торгового названия
	стрСвойстваЗаказ.Вставить("ShipperName",	ДокОтправлениеТранзита.ТочкаНазначения.ПродавецДляТК);                                                            //varchar(255)  Грузоотправитель. Используется при печати накладной.
	стрСвойстваЗаказ.Вставить("ShipperAddress",	ДокОтправлениеТранзита.ТочкаНазначения.АдресПродавцаДляТК);                                                            //varchar(255)  Адрес грузоотправителя. Используется при печати накладной.
	Возврат стрСвойстваЗаказ;	
КонецФункции

Функция ПолучитьСтруктуруТэгаAddress(ДокОтправлениеТранзита)
	стрСвойстваЗаказ=новый структура;
	Если СокрЛП(ДокОтправлениеТранзита.Тип)="sdecCourier" Тогда
		стрСвойстваЗаказ.Вставить("Street",			ДокОтправлениеТранзита.Улица);
		стрСвойстваЗаказ.Вставить("House",			ДокОтправлениеТранзита.Дом);
		стрСвойстваЗаказ.Вставить("Flat",			ДокОтправлениеТранзита.Квартира);
	Иначе	
		стрСвойстваЗаказ.Вставить("PvzCode",			ДокОтправлениеТранзита.КодПВЗ);            					//varchar(10)	Код ПВЗ (см. «Список пунктов выдачи заказов (ПВЗ)»). Атрибут необходим только для заказов с режим доставки «до склада»
	КонецЕсли;
	Возврат стрСвойстваЗаказ;	
КонецФункции	

Функция ПолучитьСтруктуруТэгаAddService(Код)
	стрСвойстваЗаказ=новый структура;
	стрСвойстваЗаказ.Вставить("ServiceCode",			код);            					//varchar(10)	Тип дополнительной услуги (см. Приложение, таблица 5). 
	Возврат стрСвойстваЗаказ;	
КонецФункции	

Функция ПолучитьСтруктуруТэгаPackage(ДокОтправлениеТранзита)
	стрСвойстваЗаказ=новый структура;
	стрСвойстваЗаказ.Вставить("Number",			"1");            											//varchar(20)	Номер упаковки (можно использовать порядковый номер упаковки заказа), уникален в пределах заказа
	стрСвойстваЗаказ.Вставить("BarCode",		"1");            											//varchar(20)	Штрих-код упаковки (если есть, иначе передавать значение номера упаковки Packege.Number. Параметр используется для оперирования грузом на складах СДЭК), уникален в пределах заказа
	стрСвойстваЗаказ.Вставить("Weight",			Формат(ДокОтправлениеТранзита.Вес,"ЧГ=0"));            					//number		Общий вес (в граммах)
	Если ДокОтправлениеТранзита.Длина>0 и ДокОтправлениеТранзита.Ширина>0 и ДокОтправлениеТранзита.Высота>0 Тогда
		стрСвойстваЗаказ.Вставить("SizeA",			ДокОтправлениеТранзита.Длина);            					//number		Габариты упаковки. Длина (в сантиметрах)
		стрСвойстваЗаказ.Вставить("SizeB",			ДокОтправлениеТранзита.Ширина);            					//number		Габариты упаковки. Ширина (в сантиметрах)
		стрСвойстваЗаказ.Вставить("SizeC",			ДокОтправлениеТранзита.Высота);            					//number		Габариты упаковки. Высота (в сантиметрах)
	КонецЕсли;
	Возврат стрСвойстваЗаказ;
КонецФункции

Функция ПолучитьСтруктуруТэгаItem(стрЗаказ,ВесОдногоЗаказа,Участник)
	стрСвойстваЗаказ=новый структура;
	стрСвойстваЗаказ.Вставить("WareKey",			?(ТипЗнч(стрЗаказ.Покупка)=Тип("СправочникСсылка.Покупки"),"П","З")+"_"+Формат(стрЗаказ.Покупка.Код,"ЧГ=0")+"_"+Формат(Участник,"ЧГ=0")+"_"+стрЗаказ.НомерСтроки);            											//varchar(20)	Идентификатор/артикул товара (Уникален в пределах упаковки Package).
	стрСвойстваЗаказ.Вставить("CostEx",				Формат(стрЗаказ.ОбъявленнаяСтоимость,"ЧН=0; ЧГ=0" ));            									//real			Объявленная стоимость товара (за единицу товара в указанной валюте, значение >=0).
	стрСвойстваЗаказ.Вставить("Cost",				Формат(стрЗаказ.ОбъявленнаяСтоимость,"ЧН=0; ЧГ=0" ));            									//real			Объявленная стоимость товара (за единицу товара в рублях, значение >=0) в рублях. С данного значения рассчитывается страховка.
	стрСвойстваЗаказ.Вставить("PaymentEx",			Формат(стрЗаказ.ОплатаПриПолучении,"ЧН=0; ЧГ=0" ));            					//real			Оплата за товар при получении (за единицу товара в указанной валюте, значение >=0) — наложенный платеж, в случае предоплаты значение = 0.
	стрСвойстваЗаказ.Вставить("Payment",			Формат(стрЗаказ.ОплатаПриПолучении,"ЧН=0; ЧГ=0" ));            					//real			Оплата за товар при получении (за единицу товара в рублях, значение >=0) — наложенный платеж, в случае предоплаты значение = 0.
	стрСвойстваЗаказ.Вставить("Weight",				Формат(ВесОдногоЗаказа,"ЧГ=0"));            					//number		Вес нетто (за единицу товара, в граммах)
	стрСвойстваЗаказ.Вставить("WeightBrutto",		Формат(ВесОдногоЗаказа,"ЧГ=0"));            					//number		Вес брутто (за единицу товара, в граммах)
	стрСвойстваЗаказ.Вставить("Amount",				1);            									//number		Количество единиц товара (в штуках)
	стрСвойстваЗаказ.Вставить("CommentEx",			стрЗаказ.Покупка.Наименование);            		//varchar(255)	Наименование товара  на английском (может также содержать описание товара: размер, цвет)
	стрСвойстваЗаказ.Вставить("Comment",			стрЗаказ.Покупка.Наименование);            		//varchar(255)	Наименование товара на русском (может также содержать описание товара: размер, цвет)
	стрСвойстваЗаказ.Вставить("Link",				"www.100sp.ru");            					//varchar(255)	Ссылка на сайт интернет-магазина с описанием товара
	Возврат стрСвойстваЗаказ;
КонецФункции


#КОнецОбласти

Функция ПолучитьДатуUTC(Дата)
	//UTC=УниверсальноеВремя(Дата);
	//Возврат Формат(Дата, "ДФ=yyyy-MM-ddT00:00:00");
	Возврат Формат(Дата, "ДФ=yyyy-MM-dd");
КонецФункции	


Функция ПолучитьСекретныйКод(secure_password,Дата)
	х=новый ХешированиеДанных(ХешФункция.MD5);
	х.Добавить(ПолучитьДатуUTC(Дата)+"&"+Строка(secure_password));
	Возврат СтрЗаменить(Строка(х.ХешСумма)," ","");
КОнецФункции	




Функция ОбменССайтом(ТК,xml,Отказ,Тип) экспорт 
	Сервер              =ТК.СерверТК;
	Порт				=ТК.ПортТК;
	Если Тип=Перечисления.ВидыОбменовСДЭК.СозданиеЗаказаНаДоставку Тогда
		АдресСкрипта        ="new_orders.php";
	ИначеЕсли Тип=Перечисления.ВидыОбменовСДЭК.ПолучитьКвитанцию Тогда
		АдресСкрипта        ="orders_print.php";
	ИначеЕсли Тип=Перечисления.ВидыОбменовСДЭК.УдалениеЗаказа Тогда
		АдресСкрипта        ="delete_orders.php";
		
	КонецЕсли;
	
	ИспользоватьПрокси=Ложь;
	///////////
	Прокси = Новый ИнтернетПрокси;
	Прокси.НеИспользоватьПроксиДляЛокальныхАдресов = Истина;
	Прокси.Пароль = ""; 
	Прокси.Пользователь = "";
	///////////
	//Логин                 =ПараметрыОбмена.Логин;
	//Пароль				  =ПараметрыОбмена.Пароль;
	Токен=Константы.Токен.Получить();
	
	
	
	Если Тип=Перечисления.ВидыОбменовСДЭК.СозданиеЗаказаНаДоставку или Тип=Перечисления.ВидыОбменовСДЭК.УдалениеЗаказа Тогда
		ИмяФайлаОтвета   = ПолучитьИмяВременногоФайла("ansv");
	ИначеЕсли Тип=Перечисления.ВидыОбменовСДЭК.ПолучитьКвитанцию Тогда
		ИмяФайлаОтвета   = ПолучитьИмяВременногоФайла("pdf");
	//	ИмяФайлаОтвета=СтрЗаменить(ИмяФайлаОтвета,КаталогВременныхФайлов(),ТК.КвитанцииТКпуть) ;
	КонецЕсли;
	
	//ИмяФайлаОтправки = ПолучитьИмяВременногоФайла("post");
	//ФайлОтправки = Новый ЗаписьТекста(ИмяФайлаОтправки, КодировкаТекста.UTF8, Символы.ПС, ЛОЖЬ);
	//
	//
	//
	//Boundary = СтрЗаменить(Строка(Новый УникальныйИдентификатор()), "-", "");
	//

	////Определяем раздел двоичных данных
	//ФайлОтправки.ЗаписатьСтроку("--" + Boundary);

	////Соответствует HTML-тэгу
	////input type="text" name="some_field" value="Some text" /
	//ФайлОтправки.ЗаписатьСтроку("--" + Boundary);
	//
	//ФайлОтправки.ЗаписатьСтроку("Content-disposition: form-data; name=""xml_request""" + Символы.ПС);
	//ФайлОтправки.ЗаписатьСтроку(xml);
	//ФайлОтправки.ЗаписатьСтроку("--" + Boundary);
	//
	//


	//ФайлОтправки.Закрыть();
	
	
	
	//////////////////////
	//
	//ЗаголовокHTTP = Новый Соответствие();
	////При необходимости зададим Referer, например таким образом
	//СтрокаСоединения = СтрокаСоединенияИнформационнойБазы();
	//СерверИсточник = НСтр(СтрокаСоединения, "Srvr") + НСтр(СтрокаСоединения, "Ref");
	//ЗаголовокHTTP.Вставить("Referer", СерверИсточник);

	////Укажем формат данных Content-Type
	//
	////ЗаголовокHTTP.Вставить("Content-Type", "application/x-www-form-urlencoded; boundary=" + Boundary);
	//ЗаголовокHTTP.Вставить("Content-Type", "multipart/form-data; boundary=" + Boundary);

	////Укажем длину POST-запроса Content-Length
	//ФайлОтправки = Новый Файл(ИмяФайлаОтправки);
	//РазмерФайлаОтправки = XMLСтрока(ФайлОтправки.Размер());
	//ЗаголовокHTTP.Вставить("Content-Length", РазмерФайлаОтправки);


	////ИспользоватьПрокси - какая-то логическая переменная, может быть значение флажка на форме или переключатель
	//Если ИспользоватьПрокси Тогда
	//	НТТР = Новый HTTPСоединение(Сервер, Порт, , , Прокси);
	//Иначе
	//	НТТР = Новый HTTPСоединение(Сервер, Порт);
	//КонецЕсли;
	
	ЗаголовокHTTP = Новый Соответствие();
	ЗаголовокHTTP.Вставить("Content-Type", "application/x-www-form-urlencoded");
	
	СтрокаXML	= КодироватьСтроку(xml, 		СпособКодированияСтроки.КодировкаURL);	
	HTTPЗапрос 	= Новый HTTPЗапрос(АдресСкрипта, 	ЗаголовокHTTP);
	HTTPЗапрос.УстановитьТелоИзСтроки("xml_request=" + СтрокаXML, КодировкаТекста.UTF8, ИспользованиеByteOrderMark.НеИспользовать);
	НТТР = Новый HTTPСоединение(Сервер);


	
	
    //Естественно, следует указать имя своего скрипта.
	Попытка
		Ответ = НТТР.ОтправитьДляОбработки(HTTPЗапрос, ИмяФайлаОтвета);
        //ответ=НТТР.ОтправитьДляОбработки(ИмяФайлаОтправки, АдресСкрипта, ИмяФайлаОтвета, ЗаголовокHTTP);
    Исключение
        //Пример обработки ошибки соединения.
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Неудачная попытка соединения: " + ОписаниеОшибки(),,,,Отказ);
		//#Если Клиент Тогда
		//    Сообщить("Неудачная попытка соединения: " + ОписаниеОшибки());
		//#Иначе
		//    ЗаписьЖурналаРегистрации("HTTPСоединение", УровеньЖурналаРегистрации.Ошибка, , , "Неудачная попытка соединения: " + ОписаниеОшибки());
		//#КонецЕсли
		//отказ=истина;
        Возврат Неопределено;
    КонецПопытки;

    //Удалим файл отправки POST-запроса. Больше он нам не нужен.
   // УдалитьФайлы(ИмяФайлаОтправки);

 
	Возврат ИмяФайлаОтвета;
	
КонецФункции


#Область ЗапросСтоимостьТарифа

&НаСервере
Функция ОбменССайтомСтоимостьТарифа(СтрокаЗапроса,Отказ=ложь)  экспорт
	//СтрокаЗапроса = КодироватьСтроку(СтрокаЗапроса, СпособКодированияСтроки.КодировкаURL);
	Заголов = Новый Соответствие();
	Заголов.Вставить("Content-Type", "application/json; charset=UTF-8");
	//lyay({"result":{"price":"1870","deliveryPeriodMin":"1","deliveryPeriodMax":"1","deliveryDateMin":"2014-10-27","deliveryDateMax":"2014-10-27","tariffId":"3","priceByCurrency":1870,"currency":"RUB"}})
	
	Попытка
		Соединение = Новый HTTPСоединение("api.edostavka.ru");//http://api.edostavka.ru/calculator/calculate_price_by_json.php
	Исключение
		Сообщить("Не удалось соединиться с сервером api.edostavka.ru.");
		Возврат Неопределено ;
	КонецПопытки;
	
	// fiddler, говорят, хороший сетевой монитор. http://habrahabr.ru/post/140147/
	HTTPЗапрос = Новый HTTPЗапрос("/calculator/calculate_price_by_jsonp.php?callback=lyay&json=" + СтрокаЗапроса, Заголов);
	
	Попытка
		Ответ = Соединение.Получить(HTTPЗапрос);
		ОтветСтрокой = Сред(ПереобразоватьЮникод(Ответ.ПолучитьТелоКакСтроку()), 6);
		ОтветСтрокой = Сред(ОтветСтрокой, 1, СтрДлина(ОтветСтрокой) - 1);
		//Сообщить(ОтветСтрокой);
		
		//зн = ЭтаОбработка.UnJSON(ОтветСтрокой);
		//Результат = Неопределено;
		//Ошибка = Неопределено;
		//зн.Свойство("result", Результат);
		//зн.Свойство("error", Ошибка);
		//
	Исключение
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Неудачная попытка соединения: " + ОписаниеОшибки(),,,,Отказ);
		Возврат Неопределено;
	КонецПопытки;
	Возврат ОтветСтрокой;
КонецФункции

&НаСервере
Функция ПереобразоватьЮникод(Строка)

    
    ГотововаяСтрока = "" ;
    
    МасУкр = Новый Массив(66) ;
    
    МасУкр[0]="А";   МасУкр[1]="Б";  МасУкр[2]="В";  МасУкр[3]="Г";  МасУкр[4]="Ґ";  МасУкр[5]="Д";
    МасУкр[6]="Е";   МасУкр[7]="Є";  МасУкр[8]="Ж";  МасУкр[9]="З";  МасУкр[10]="И"; МасУкр[11]="І";
    МасУкр[12]="Ї";  МасУкр[13]="Й"; МасУкр[14]="К"; МасУкр[15]="Л"; МасУкр[16]="М"; МасУкр[17]="Н";
    МасУкр[18]="О";  МасУкр[19]="П"; МасУкр[20]="Р"; МасУкр[21]="С"; МасУкр[22]="Т"; МасУкр[23]="У";
    МасУкр[24]="Ф";  МасУкр[25]="Х"; МасУкр[26]="Ц"; МасУкр[27]="Ч"; МасУкр[28]="Ш"; МасУкр[29]="Щ";
    МасУкр[30]="Ь";  МасУкр[31]="Ю"; МасУкр[32]="Я";  

    МасУкр[33]="а";  МасУкр[34]="б"; МасУкр[35]="в"; МасУкр[36]="г"; МасУкр[37]="ґ"; МасУкр[38]="д";
    МасУкр[39]="е";  МасУкр[40]="є"; МасУкр[41]="ж"; МасУкр[42]="з"; МасУкр[43]="и"; МасУкр[44]="і";
    МасУкр[45]="ї";  МасУкр[46]="й"; МасУкр[47]="к"; МасУкр[48]="л"; МасУкр[49]="м"; МасУкр[50]="н";
    МасУкр[51]="о";  МасУкр[52]="п"; МасУкр[53]="р"; МасУкр[54]="с"; МасУкр[55]="т"; МасУкр[56]="у";
    МасУкр[57]="ф";  МасУкр[58]="х"; МасУкр[59]="ц"; МасУкр[60]="ч"; МасУкр[61]="ш"; МасУкр[62]="щ";
    МасУкр[63]="ь";  МасУкр[31]="ю"; МасУкр[65]="я";  
        
    
    МасКод = Новый Массив(66) ;
    
    МасКод[0]="0410";   МасКод[1]="0411";  МасКод[2]="0412";  МасКод[3]="0413";  МасКод[4]="0490";  МасКод[5]="0414";
    МасКод[6]="0415";   МасКод[7]="0404";  МасКод[8]="0416";  МасКод[9]="0417";  МасКод[10]="0418"; МасКод[11]="0406";
    МасКод[12]="0407";  МасКод[13]="0419"; МасКод[14]="041A"; МасКод[15]="041B"; МасКод[16]="041C"; МасКод[17]="041D";
    МасКод[18]="041E";  МасКод[19]="041F"; МасКод[20]="0420"; МасКод[21]="0421"; МасКод[22]="0422"; МасКод[23]="0423";
    МасКод[24]="0424";  МасКод[25]="0425"; МасКод[26]="0426"; МасКод[27]="0427"; МасКод[28]="0428"; МасКод[29]="0429";
    МасКод[30]="042C";  МасКод[31]="042E"; МасКод[32]="042F";  

    МасКод[33]="0430";  МасКод[34]="0431"; МасКод[35]="0432"; МасКод[36]="0413"; МасКод[37]="0491"; МасКод[38]="0434";
    МасКод[39]="0435";  МасКод[40]="0454"; МасКод[41]="0436"; МасКод[42]="0437"; МасКод[43]="0438"; МасКод[44]="0456";
    МасКод[45]="0457";  МасКод[46]="0439"; МасКод[47]="043A"; МасКод[48]="043B"; МасКод[49]="043C"; МасКод[50]="043D";
    МасКод[51]="043E";  МасКод[52]="043F"; МасКод[53]="0440"; МасКод[54]="0441"; МасКод[55]="0442"; МасКод[56]="0443";
    МасКод[57]="0444";  МасКод[58]="0445"; МасКод[59]="0446"; МасКод[60]="0447"; МасКод[61]="0448"; МасКод[62]="0449";
    МасКод[63]="044C";  МасКод[31]="044E"; МасКод[65]="044F";  
    
    
    тмпСтрока = "" ;
    Для Счетчик = 1 По СтрДлина(Строка) Цикл      
        Если Лев(Строка, 1) = "\" Тогда
            Если Лев(Строка, 2) = "\u" Тогда
                
                тмпСтрока = Прав(Лев(Строка, 6),4) ;
                Если МасКод.Найти(тмпСтрока) = Неопределено Тогда
                    СтрокаЗамены = Прав(тмпСтрока, 1) ;
                    тмпСтрока = СтрЗаменить(тмпСтрока,СтрокаЗамены,ТРег(СтрокаЗамены)); 
					Если МасКод.Найти(тмпСтрока) = Неопределено Тогда
						// не найден и не найден. Хрен с ним. Всё-равно это в русском языке. Пользователь и так поймёт.
						// ничего пользователю говорить не будем.  
						//Сообщить("Код символа не найден: " + тмпСтрока);
                    Иначе                      
                        ГотововаяСтрока = ГотововаяСтрока + МасУкр[МасКод.Найти(тмпСтрока)] ;                                   
                    КонецЕсли;
                Иначе
                    ГотововаяСтрока = ГотововаяСтрока + МасУкр[МасКод.Найти(тмпСтрока)] ;               
                КонецЕсли;
                
                Строка = Прав(Строка, (СтрДлина(Строка)-6)) ; 
            Иначе  
                Строка = Прав(Строка, (СтрДлина(Строка)-2)) ;
            КонецЕсли;
        Иначе
            ГотововаяСтрока = ГотововаяСтрока + Лев(Строка, 1) ;
            Строка = Прав(Строка, (СтрДлина(Строка)-1)) ;     
        КонецЕсли;         
    КонецЦикла;   

    Возврат ГотововаяСтрока ;
        
КонецФункции

Функция РазобратьЖСОН(СтрокаЖсон)   Экспорт
	ЧтениеЖсон=Новый ЧтениеJSON;
	ЧтениеЖсон.УстановитьСтроку(СтрокаЖсон);
	структураОтвета=ПрочитатьJSON( ЧтениеЖсон);
	возврат структураОтвета;
КонецФункции

#КонецОбласти


#Область ПолучитьСписокТочек
Функция ОбменССайтомСписокТочек(КодГорода,Отказ)  экспорт
	Заголов = Новый Соответствие();
	Заголов.Вставить("Content-Type", "application/json; charset=UTF-8");
	
	Попытка
		Соединение = Новый HTTPСоединение("integration.cdek.ru",80);//http://api.edostavka.ru/calculator/calculate_price_by_json.php
	Исключение
		Сообщить("Не удалось соединиться с сервером integration.cdek.ru.");
		Возврат Неопределено ;
	КонецПопытки;
	
	// fiddler, говорят, хороший сетевой монитор. http://habrahabr.ru/post/140147/
	HTTPЗапрос = Новый HTTPЗапрос("pvzlist.php?cityid=" + КодГорода+"&type=ALL");
	
	Попытка
		Ответ = Соединение.Получить(HTTPЗапрос);
		ОтветСтрокой = Ответ.ПолучитьТелоКакСтроку();
		ТЗ = ПолучитьТЗточекСДЭК(ОтветСтрокой);
		
		ОтветСтрокой = Сред(ОтветСтрокой, 1, СтрДлина(ОтветСтрокой) - 1);
		//Сообщить(ОтветСтрокой);
		
		//зн = ЭтаОбработка.UnJSON(ОтветСтрокой);
		//Результат = Неопределено;
		//Ошибка = Неопределено;
		//зн.Свойство("result", Результат);
		//зн.Свойство("error", Ошибка);
		//
	Исключение
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Неудачная попытка соединения: " + ОписаниеОшибки(),,,,Отказ);
		Возврат Неопределено;
	КонецПопытки;
	Возврат ТЗ;
КонецФункции


Функция ПолучитьТЗточекСДЭК(ОтветСтрокой)	экспорт
	//СтруктураItems=новый Структура("ИмяТэга,тз","Order",новый Структура("Number,DispatchNumber,Msg,ErrorCode","Строка","Строка","Строка","Строка"));
	СтруктураФайла=новый Структура("pvz,Code,Name,CityCode,CountryCode,CountryName,RegionCode,RegionName,FullAddress,IsDressingRoom,City,WorkTime,Address,Phone,Note,CoordX,CoordY,Type,OwnerCode,WeightLimit,WeightMin,WeightMax",
											"Строка","Строка","Строка","Строка","Строка","Строка","Строка","Строка","Строка","Строка","Строка","Строка","Строка","Строка","Строка","Строка","Строка","Строка","Строка",новый Структура("WeightMin,WeightMax","Строка","Строка"),"Строка","Строка");
	ЧтениеXML = Новый ЧтениеXML;
	ЧтениеXML.УстановитьСтроку(ОтветСтрокой);
	//
	Пока ЧтениеXML.Прочитать() Цикл
		Если  ЧтениеXML.ЛокальноеИмя="PvzList"  и ЧтениеXML.ТипУзла=ТипУзлаXML.НачалоЭлемента Тогда
			тзГрупп=ОбработатьТэг(ЧтениеXML,"Pvz","PvzList",СтруктураФайла);
			Для каждого Стр из тзГрупп Цикл
				если ТипЗнч(Стр.WeightLimit)=Тип("ТаблицаЗначений") и  Стр.WeightLimit.Количество()>0 Тогда
					стр.WeightMin =Стр.WeightLimit[0].WeightMin;
					стр.WeightMax =Стр.WeightLimit[0].WeightMax;
				КонецЕсли;
			КонецЦикла;	
			Возврат тзГрупп;
		КонецЕсли;	
	КонецЦикла;
	Возврат Неопределено;
КонецФункции




#КонецОбласти



Функция ФайлВСтроку(ИмяФайлаОтвета)   Экспорт
		ТекстФайла="";
		Текст=Новый ЧтениеТекста;
		Текст.Открыть(ИмяФайлаОтвета,КодировкаТекста.UTF8);
		Стр = Текст.ПрочитатьСтроку();
		Пока Стр <> Неопределено Цикл 
			ТекстФайла=ТекстФайла+Стр;
			Стр = Текст.ПрочитатьСтроку();
		КонецЦикла;
		/////
		ТекстФайла=СтрЗаменить(ТекстФайла,"/>","/>"+Символы.ПС);
		ТекстФайла=СтрЗаменить(ТекстФайла,"<response>","<response>"+Символы.ПС);
		//ТекстФайла=СтрЗаменить(ТекстФайла,"<groups>","<groups>"+Символы.ПС);
		//ТекстФайла=СтрЗаменить(ТекстФайла,"</groups>","</groups>"+Символы.ПС);
		//ТекстФайла=СтрЗаменить(ТекстФайла,"</barcode>","</barcode>"+Символы.ПС);
		//ТекстФайла=СтрЗаменить(ТекстФайла,"</distributorName>","</distributorName>"+Символы.ПС);
		//ТекстФайла=СтрЗаменить(ТекстФайла,"</ownerName>","</ownerName>"+Символы.ПС);
		//ТекстФайла=СтрЗаменить(ТекстФайла,"</ordersNumber>","</ordersNumber>"+Символы.ПС);
		//ТекстФайла=СтрЗаменить(ТекстФайла,"</code>","</code>"+Символы.ПС);
		//ТекстФайла=СтрЗаменить(ТекстФайла,"</createdAt>","</createdAt>"+Символы.ПС);
		//ТекстФайла=СтрЗаменить(ТекстФайла,"</name>","</name>"+Символы.ПС);
		//ТекстФайла=СтрЗаменить(ТекстФайла,"</result>","</result>"+Символы.ПС);
		Возврат ТекстФайла ;
КонецФункции
	
Функция ПолучитьНомерСДЭК(Файл)	экспорт
	//СтруктураItems=новый Структура("ИмяТэга,тз","Order",новый Структура("Number,DispatchNumber,Msg,ErrorCode","Строка","Строка","Строка","Строка"));
	СтруктураФайла=новый Структура("Number,DispatchNumber,Msg,ErrorCode",
											"Строка","Строка","Строка","Строка");
	ЧтениеXML = Новый ЧтениеXML;
	ЧтениеXML.УстановитьСтроку(ОбменДаннымиСДЭК.ФайлВСтроку(Файл));
	//
	Пока ЧтениеXML.Прочитать() Цикл
		Если  ЧтениеXML.ЛокальноеИмя="response"  и ЧтениеXML.ТипУзла=ТипУзлаXML.НачалоЭлемента Тогда
			тзГрупп=ОбработатьТэг(ЧтениеXML,"Order","response",СтруктураФайла);
			Если тзГрупп.Количество()>1 Тогда
					Для каждого стр из тзГрупп Цикл
						ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Строка(стр.Number)+" , "+ Строка(стр.Msg)+" , "+ Строка(стр.ErrorCode));
					КонецЦикла;				
				Если тзГрупп[тзГрупп.Количество()-1].Msg ="Добавлено заказов 0" Тогда
					Возврат неопределено;
				Иначе	
					Возврат тзГрупп[тзГрупп.Количество()-2].DispatchNumber;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;	
	КонецЦикла;
	Возврат Неопределено;
КонецФункции


Функция ПолучитьНомерСДЭКОшибкаКвитанции(Файл) Экспорт
	//СтруктураItems=новый Структура("ИмяТэга,тз","Order",новый Структура("Number,DispatchNumber,Msg,ErrorCode","Строка","Строка","Строка","Строка"));
	СтруктураФайла=новый Структура("Number,Date,DispatchNumber,Msg,ErrorCode",
											"Строка","Строка","Строка","Строка","Строка");
	ЧтениеXML = Новый ЧтениеXML;
	ЧтениеXML.УстановитьСтроку(ОбменДаннымиСДЭК.ФайлВСтроку(Файл));
	//
	Пока ЧтениеXML.Прочитать() Цикл
		Если  ЧтениеXML.ЛокальноеИмя="response"  и ЧтениеXML.ТипУзла=ТипУзлаXML.НачалоЭлемента Тогда
			тзГрупп=ОбработатьТэг(ЧтениеXML,"Order","response",СтруктураФайла);
			Если тзГрупп.Количество()>0 Тогда
				Для каждого стр из тзГрупп Цикл
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Строка(стр.Number)+" , "+ Строка(стр.Msg)+" , "+ Строка(стр.ErrorCode));
				КонецЦикла;				
				
				Возврат тзГрупп[0].DispatchNumber;
			КонецЕсли;
		КонецЕсли;	
	КонецЦикла;
	Возврат Неопределено;
КонецФункции
	
Функция ПолучитьОтветНаУдалениеСДЭК(Файл)	экспорт
	//СтруктураItems=новый Структура("ИмяТэга,тз","Order",новый Структура("Number,DispatchNumber,Msg,ErrorCode","Строка","Строка","Строка","Строка"));
	СтруктураФайла=новый Структура("Number,Msg,ErrorCode",
											"Строка",,"Строка","Строка");
	ЧтениеXML = Новый ЧтениеXML;
	ЧтениеXML.УстановитьСтроку(ОбменДаннымиСДЭК.ФайлВСтроку(Файл));
	//
	Пока ЧтениеXML.Прочитать() Цикл
		Если  ЧтениеXML.ЛокальноеИмя="response"  и ЧтениеXML.ТипУзла=ТипУзлаXML.НачалоЭлемента Тогда
			тзОтвет=ОбработатьТэг(ЧтениеXML,"DeleteRequest","response",СтруктураФайла);
			массСтрок = тзОтвет.НайтиСтроки(новый Структура("Msg","Удалено заказов:1"));
			Если массСтрок.Количество()>0 Тогда
				Возврат истина;
			Иначе
				Для каждого стрТЗ из тзОтвет Цикл
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Строка(стрТЗ.Number)+" "+Строка(стрТЗ.ErrorCode)+" "+Строка(стрТЗ.Msg));
				КонецЦикла;
				Возврат ложь;
			КонецЕсли;	
		КонецЕсли;	
	КонецЦикла;
	Возврат Ложь;
КонецФункции



	
Функция  ОбработатьТэг(ЧтениеXML,ИмяТэга,ИмяСписка,СтруктураФайла)
	Если  ЧтениеXML.ЛокальноеИмя=ИмяСписка  и ЧтениеXML.ТипУзла=ТипУзлаXML.НачалоЭлемента Тогда
		ТЗрезультат=ТЗпоСтруктуре(СтруктураФайла);
		Пока  Не (ЧтениеXML.ЛокальноеИмя=ИмяСписка  и ЧтениеXML.ТипУзла=ТипУзлаXML.КонецЭлемента) Цикл
			ЧтениеXML.Прочитать();
			Если  ЧтениеXML.ЛокальноеИмя=ИмяТэга  и ЧтениеXML.ТипУзла=ТипУзлаXML.НачалоЭлемента Тогда
	
				новаяСтрока=ТЗрезультат.Добавить();
				если ЧтениеXML.КоличествоАтрибутов()>0 Тогда
					Пока ЧтениеXML.ПрочитатьАтрибут() Цикл
						Если  ТЗрезультат.Колонки.Найти(ЧтениеXML.ЛокальноеИмя)=Неопределено Тогда
							Продолжить;
						КонецЕсли;	
						новаяСтрока[ЧтениеXML.ЛокальноеИмя]=ЧтениеXML.Значение;
					КонецЦикла;	
				КонецЕсли;
				Пока не (ЧтениеXML.ЛокальноеИмя=ИмяТэга  и ЧтениеXML.ТипУзла=ТипУзлаXML.КонецЭлемента) Цикл		
					ЧтениеXML.Прочитать();
					Если ЧтениеXML.ЛокальноеИмя="#text" Тогда продолжить КонецЕсли;
					Если ТЗрезультат.Колонки.Найти(ЧтениеXML.ЛокальноеИмя)<>Неопределено  и ЧтениеXML.ТипУзла=ТипУзлаXML.НачалоЭлемента Тогда
						
						ИмяКолонки=ЧтениеXML.ЛокальноеИмя;
						
						Если ТЗрезультат.колонки[ИмяКолонки].ТипЗначения=новый ОписаниеТипов("ТаблицаЗначений") Тогда
							ТЗЭлемент=ТЗпоСтруктуре(СтруктураФайла[ИмяКолонки]);
							если ЧтениеXML.КоличествоАтрибутов()>0 Тогда
								новаяСтрокаТЗЭлемент=ТЗЭлемент.Добавить();
								Пока ЧтениеXML.ПрочитатьАтрибут() Цикл
									новаяСтрокаТЗЭлемент[ЧтениеXML.ЛокальноеИмя]=ЧтениеXML.Значение;
								КонецЦикла;	
							КонецЕсли;
							
							новаяСтрока[ИмяКолонки]=ТЗЭлемент;
						Иначе
							ЧтениеXML.Прочитать();
							Если ЧтениеXML.ТипУзла=ТипУзлаXML.Текст Тогда
								новаяСтрока[ИмяКолонки]=ЧтениеXML.Значение;
							Иначе
								новаяСтрока[ИмяКолонки]=Неопределено;
							КонецЕсли;
							ЧтениеXML.Прочитать();
						КонецЕсли;
					КОнецЕсли;
				Конеццикла;
			КонецЕсли;
			
		Конеццикла;
	КонецЕсли;
	Возврат ТЗрезультат;
КонецФункции


Функция ТЗпоСтруктуре(СтруктураКолонок)
	тз=новый ТаблицаЗначений;
	Для каждого стр из СтруктураКолонок Цикл
		Если ТипЗнч(стр.Значение)=Тип("Структура") Тогда
			тз.Колонки.Добавить(стр.Ключ,новый ОписаниеТипов("ТаблицаЗначений"));	
		Иначе	
			тз.Колонки.Добавить(стр.Ключ,новый ОписаниеТипов(стр.Значение));	
		КонецЕсли;
	КонецЦикла;
	возврат тз;
КонецФункции	
