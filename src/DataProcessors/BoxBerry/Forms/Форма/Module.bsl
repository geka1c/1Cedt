
&НаСервере
Процедура СписокГородовНаСервере()
	токен="10000.rbpqbafb";
	
	Точки=ПолучитьСписокТочек();	// Вставить содержимое обработчика.
	
	Сервис=ПолучитьСтоимостьДоставки(100,25051,77521,0,0,0,10,20,30,0);
КонецПроцедуры

&НаКлиенте
Процедура СписокГородов(Команда)
	СписокГородовНаСервере();
КонецПроцедуры

#Область ПубличныйАПИ
//Позволяет получить список городов, в которых есть пункты выдачи заказов Boxberry
Функция ПолучитьСписокГородов() Экспорт
    Прокси = ПолучитьПроксиПаблик().Прокси;
	токен=Константы.ТокенBoxBerry.Получить();
	ТипWSПараметра = Прокси.ФабрикаXDTO.Пакеты.Получить(ПолучитьПроксиПаблик().Адрес).Получить("ListCitiesQuery");
	WSПараметр=Прокси.ФабрикаXDTO.Создать(ТипWSПараметра);
	WSПараметр.token=токен;
	СписокГородов=Прокси.ListCities(WSПараметр);
    
    Возврат СписокГородов;
КонецФункции

//Позволяет получить информацию о всех точках выдачи заказов. При использовании 
//дополнительного параметра ("code" код города в boxberry, можно получить методом ListCities) 
//позволяет выбрать ПВЗ только в заданном городе.
//По умолчанию возвращается список точек с возможностью оплаты при получении заказа
//(параметр 'OnlyPrepaidOrders'=No). Не возвращает отделения, работающие только с предоплаченными 
//посылками. Если вам необходимо увидеть точки, работающие с любым типом посылок, передайте 
//параметр "prepaid" равный 1
Функция ПолучитьСписокТочек(КодГорода=Неопределено,Предоплата=Неопределено) Экспорт
	Прокси = ПолучитьПроксиПаблик().Прокси;
	токен=Константы.ТокенBoxBerry.Получить();	
	ТипWSПараметра = Прокси.ФабрикаXDTO.Пакеты.Получить(ПолучитьПроксиПаблик().Адрес).Получить("ListPointsQuery");
	WSПараметр=Прокси.ФабрикаXDTO.Создать(ТипWSПараметра);
	WSПараметр.token=токен;
	Если ЗначениеЗаполнено(КодГорода)  Тогда WSПараметр.CityCode = КодГорода; КонецЕсли;
	Если ЗначениеЗаполнено(Предоплата) Тогда WSПараметр.prepaid = Предоплата; КонецЕсли;
	СписокТочек=Прокси.ListPoints(WSПараметр);
    
    Возврат СписокТочек;
КонецФункции
	
//Позволяет получить список почтовых индексов, для которых возможна курьерская 
//доставка	
Функция ПолучитьСписокИндексов() Экспорт
	Прокси = ПолучитьПроксиПаблик().Прокси;
	токен=Константы.ТокенBoxBerry.Получить();	
	ТипWSПараметра = Прокси.ФабрикаXDTO.Пакеты.Получить(ПолучитьПроксиПаблик().Адрес).Получить("ListZipsQuery");
	WSПараметр=Прокси.ФабрикаXDTO.Создать(ТипWSПараметра);
	WSПараметр.token=токен;
	СписокИндексов=Прокси.ListZips(WSПараметр);
    
    Возврат СписокИндексов;
КонецФункции



//Процедура Позволяет получить стоимость доставки заказа до ПВЗ с учётом стоимости постоянных 
//услуг, предусмотренных Вашим договором, возможен расчет с учетом курьерской доставки. 
//Возвращает базовую стоимость, стоимость услуг (оповещение, выдача, страховой сбор, 
//прием платежа, курьерская доставка и т.п.), срок доставки с учетом варианта выдачи (получение 
//на ПВЗ или курьерская доставка). 
//Если указан почтовый индекс, расчет будет производиться для курьерской доставки по 
//заданному индексу (код пункта выдачи игнорируется).
//Параметры:
//WSServis - WS ссылка,
//токен - токен
// weight - вес посылки в граммах,
// targetstart - код пункта приема посылок,
// target - код пункта выдачи заказов,
// Обратите внимание! Следующие поля считаются равными 0 если не заполнены:
// ordersum - cтоимость товаров без учета стоимости доставки,
// deliverysum - заявленная ИМ стоимость доставки,
// paysum - сумма к оплате
// height - высота коробки (см),
// width - ширина коробки (см),
// depth - глубина коробки (см),
// zip - индекс города для курьерской доставки
// На выходе будет переменная price содержащая итоговую цену в рублях, а также 
//составляющие этой цены (базовая стоимость и стоимость услуг).
Функция ПолучитьСтоимостьДоставки(weight,targetstart,target,ordersum,deliverysum,paysum,
											height,width,depth,zip) Экспорт
	Прокси = ПолучитьПроксиПаблик().Прокси;
	токен=Константы.ТокенBoxBerry.Получить();    
	price=0;
	price_base=0;
	price_service=0;
	delivery_period=0;
	
    Прокси.DeliveryCosts(токен,weight,targetstart,target,ordersum,deliverysum,paysum,
											height,width,depth,zip,price,price_base,price_service,delivery_period);
    
    Возврат price;
КонецФункции


#КонецОбласти


#Область ЛичныйКабинетАПИ

Процедура ParselCreateНажатие(Элемент)
	Прокси = ПолучитьПроксиЛК();
	токен=Константы.ТокенBoxBerry.Получить();
	
	ТипСписок = Прокси.ФабрикаXDTO.Тип("api.boxberry.de", "ParselCreateQuery");
	ТипShop = Прокси.ФабрикаXDTO.Тип("api.boxberry.de", "ParselCreateShopData");
	ТипCustomer = Прокси.ФабрикаXDTO.Тип("api.boxberry.de", "ParselCreateCustomerData");
	ТипWeights = Прокси.ФабрикаXDTO.Тип("api.boxberry.de", "ParselCreateWeightsData");
	
	// Заполняем параметр:
	WSПараметрСписок = Прокси.ФабрикаXDTO.Создать(ТипСписок);
	
	WSПараметрСписок.token = токен;
	WSПараметрСписок.order_id = "ID заказа в ИМ";
	WSПараметрСписок.PalletNumber = "Номер палеты";
	WSПараметрСписок.barcode = "баркод";                           //Внимание. Если вы передаёте параметр barcode (штрих-код заказа), вам недоступна печать нашей стандартной этикетки.
	WSПараметрСписок.price = "Объявленная стоимость";              //Общая (объявленная) стоимость ЗП, руб
	WSПараметрСписок.payment_sum = "Сумма к оплате";               //Сумма к оплате (сумма, которую необходимо взять с получателя), руб. Рассчитывается как сумма стоимости товарных вложений и стоимости доставки. Стоимость товарных вложений = сумма (<price> x <quantity>) по всем <item>. Стоимость доставки = <delivery_sum> Для полностью предоплаченного заказа указывать 0
	WSПараметрСписок.delivery_sum = "Стоимость доставки";          //Стоимость доставки, которую ИМ объявил получателю, руб.
	WSПараметрСписок.vid = "Тип доставки (1/2)";                   //Вид доставки. Возможные значения: 1 – самовывоз (доставка до ПВЗ), 2 – КД (экспресс-доставка до получателя)
	
	СписокShop = Прокси.ФабрикаXDTO.Создать(ТипShop);
	
	СписокShop.name = "Код ПВЗ";                                   //Код ПВЗ, в котором получатель будет забирать ЗП. Заполняется для самовывоза, для КД – оставить пустым.
	СписокShop.name1 = "Код пункта поступления";                   //Код пункта поступления ЗП (код ПВЗ, в который ИМ сдаёт посылки для доставки). Заполняется всегда, не зависимо от вида доставки. Для ИМ, сдающих отправления на ЦСУ Москва заполняется значением 010
	
	WSПараметрСписок.shop = СписокShop;
	
	СписокCustomer = Прокси.ФабрикаXDTO.Создать(ТипCustomer);
	
	СписокCustomer.fio = "ФИО получателя";                          //ФИО получателя ЗП. Возможные варианты заполнения: «Фамилия Имя Отчество» или «Фамилия Имя» (разделитель – пробел).
																	//Внимание, для полностью предоплаченных заказов необходимо указывать Фамилию, Имя и Отчество получателя, т. к. при выдаче на ПВЗ проверяются паспортные данные.
	СписокCustomer.phone = "Номер телефона";                        //Номер мобильного телефона получателя.
																	//Внимание, если вы используете наше СМС-и/или голосовое оповещение, номер мобильного телефона необходимо передавать в формате 9ХХХХХХХХХ (10 цифр, начиная с девятки).

	СписокCustomer.phone2 = "Доп. номер телефона";
	СписокCustomer.email = "E-mail для оповещений";
	
	//name, address, inn, kpp, r_s, bank, kor_s, bik
	//Наименование юрлица-получателя. 
	//Внимание, данные поля обязательны для заполнения, если заказчиком и плательщиком по ЗП является юрлицо. При этом в поле <fio> указываются данные представителя юрлица, который будет получать ЗП. Для физлиц эти поля не заполняется.	
	//СписокCustomer.name = "Наименование организации";
	//СписокCustomer.address = "Адрес";
	//СписокCustomer.inn = "ИНН";
	//СписокCustomer.kpp = "КПП";
	//СписокCustomer.r_s = "Расчетный счет";
	//СписокCustomer.bank = "Наименование банка";
	//СписокCustomer.kor_s = "Кор. счет";
	//СписокCustomer.bik = "БИК";
	
	WSПараметрСписок.customer = СписокCustomer;
	
	СписокWeights = Прокси.ФабрикаXDTO.Создать(ТипWeights);
	
	СписокWeights.weight = "Вес 1-ого места";
	СписокWeights.weight2 = "0";
	СписокWeights.weight3 = "0";
	СписокWeights.weight4 = "0";
	СписокWeights.weight5 = "0";
	
	WSПараметрСписок.weights = СписокWeights;
	
	// Обращаемся:
	Попытка
		Результат = Прокси.ParselCreate(WSПараметрСписок);
		Сообщить("label: " + СокрЛП(Результат.label) + Символы.ПС + "track: " + СокрЛП(Результат.track));
	Исключение
		Сообщить(ОписаниеОшибки());
	КонецПопытки;
	
КонецПроцедуры
#КонецОбласти



#Область ВспомогательныеФункции
Функция ПолучитьПроксиПаблик()
	WSServis=WSСсылки.WSBoxBerryTest;
	ОписаниеСервиса = WSServis.ПолучитьWSОпределения().Сервисы[0];
    Адрес        = ОписаниеСервиса.URIПространстваИмен;
    ИмяСервиса     = ОписаниеСервиса.Имя;                            
    ИмяПорта     = ОписаниеСервиса.ТочкиПодключения[0].Имя;
    Прокси = WSServis.СоздатьWSПрокси(Адрес,ИмяСервиса,ИмяПорта,,,);
	
	Возврат новый Структура("Прокси,Адрес",Прокси,Адрес);
КонецФункции	

Функция ПолучитьПроксиЛК()
	WSServis=WSСсылки.WSBoxBerryLKTest;
	ОписаниеСервиса = WSServis.ПолучитьWSОпределения().Сервисы[0];
    Адрес        = ОписаниеСервиса.URIПространстваИмен;
    ИмяСервиса     = ОписаниеСервиса.Имя;                            
    ИмяПорта     = ОписаниеСервиса.ТочкиПодключения[0].Имя;
    Прокси = WSServis.СоздатьWSПрокси(Адрес,ИмяСервиса,ИмяПорта,,,);
	Возврат новый Структура("Прокси,Адрес",Прокси,Адрес);
КонецФункции	

#КонецОбласти