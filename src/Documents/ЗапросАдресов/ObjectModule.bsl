
#Область ПрограмммныйИнтерфейс
Процедура  СериолизоватьВХМЛ() Экспорт
	ЗаписьXML=новый ЗаписьXML;
	ЗаписьXML.УстановитьСтроку("UTF-8");
	ЗаписьXML.ЗаписатьНачалоЭлемента("distributors");
	
	ЗаписьXML.ЗаписатьАтрибут("xmlns:xsi","http://www.w3.org/2001/XMLSchema-instance");
	ЗаписьXML.ЗаписатьАтрибут("xmlns:xsd","http://www.w3.org/2001/XMLSchema");
	
	
		ТЗ=РазобратьЗаказы();  
		ДобавитьСписоквХМЛизТЗ(ЗаписьXML,"deliveryDetails","sticker",ТЗ);
		
	ЗаписьXML.ЗаписатьКонецЭлемента();
	ОтправленныеДанные= ЗаписьXML.Закрыть();
	Статус=Перечисления.СтатусОтпавкиНаСайт.Сформирован;
КонецПроцедуры

Процедура  ОтправитьНаСайт() Экспорт
	СтрокаПротокола=ПротоколыПередач.Добавить();
	СтрокаПротокола.ДатаНачала=ТекущаяДата();
	ИмяФайлаОтвета=ОбменССайтом();
	Если аспПроцедурыОбменаДанными.АвторизацияВыполнена(ИмяФайлаОтвета) Тогда
		Статус=Перечисления.СтатусОтпавкиНаСайт.Отправлен;
		СтрокаПротокола.Результат="Авторизация выполнена";
		
	Иначе
		СтрокаПротокола.Результат="Авторизация не выполнена";
	КонецЕсли;	 
	Если ЗначениеЗаполнено(ИмяФайлаОтвета) Тогда
		ПолученныеДанные=ФайлВСтроку(ИмяФайлаОтвета);
	Иначе
		СтрокаПротокола.Результат="Нет ответа";
	КонецЕсли;
	СтрокаПротокола.ДатаОкончания=ТекущаяДата();
КонецПроцедуры

Процедура РаспознатьАдреса() Экспорт
 	тз=аспПроцедурыОбменаДанными.ОбработатьАдресаЗаказовССайта(ПолученныеДанные);
	Если тз=Неопределено Тогда Возврат КонецЕсли;
	Для каждого стр из тз Цикл
		покупка=Справочники.Покупки.ПустаяСсылка();
		Если стр.orderType="sp" Тогда
			Если стр.orderId = "" Тогда
				покупка	= СП_РаботаСоСправочниками.ПолучитьПокупкуПо_Коду(стр.pid);
			Иначе	
				покупка = Заказы.НайтиСтроки(новый структура("КодЗаказа",стр.orderId))[0].Покупка;
			КонецЕсли;	
		ИначеЕсли стр.orderType="bulletin" Тогда
			покупка	= СП_РаботаСоСправочниками.ПолучитьПристройПо_Коду(стр.orderId);
		Иначе	
			Покупка = СП_РаботаСоСправочниками.ПолучитьЗаказПо_Коду(стр.orderId);
		КонецЕсли;	
		участник	= СП_РаботаСоСправочниками.ПолучитьУчастникаПо_Коду(стр.uid);
		Если не ЗначениеЗаполнено(Участник) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Ошибка загрузки адреса. Не найден участник с кодом "+стр.uid);
			Продолжить;
		КонецЕсли;	
		Если не ЗначениеЗаполнено(Покупка) Тогда
			Если стр.orderType="sp" Тогда
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Ошибка загрузки адреса. Не найдена покупка с кодом "+стр.pid);
			Иначе	
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Ошибка загрузки адреса. Не найден заказ с кодом "+стр.orderId);
			КонецЕсли;	
			Продолжить;
		КонецЕсли;
		Если ТипЗнч(Покупка) = Тип("СправочникСсылка.Посылки") Тогда
			найденыеЗаказы=Заказы.НайтиСтроки(новый Структура("КодЗаказа",стр.orderId));
		иначе	
			найденыеЗаказы=Заказы.НайтиСтроки(новый Структура("Покупка,Участник",Покупка,Участник));
		КонецЕсли;	
		Для каждого Заказ из найденыеЗаказы Цикл
			Заказ.РезультатОбмена=стр.result;
			Если стр.result="ok" Тогда
				Если СокрЛП(стр.address)="" Тогда
					Заказ.Адрес	="ул. " +стр.address_street+", д. "+стр.address_building+", кв "+стр.address_apartment;	
				Иначе	
					Заказ.Адрес	=стр.address;	
				КонецЕсли;
			Иначе
				Заказ.Адрес	=стр.message;	
			КонецЕсли;
			Заказ.город		=стр.city;
			Заказ.Регион	=стр.region;
			Заказ.Телефон	=стр.phone;
			Заказ.ФИО		=стр.recipient_name;
			Заказ.Тип		=стр.type;
			Заказ.Индекс	=стр.zipcode;
			Заказ.КодПВЗ    =стр.pvz_code;
			Заказ.email     =стр.email;
			Заказ.cityCode  =стр.city_code;
			Заказ.Улица    	=стр.address_street;
			Заказ.Дом     	=стр.address_building;
			Заказ.Квартира  =стр.address_apartment;

		КонецЦикла;	
	КонецЦикла;	
КонецПроцедуры	

Функция ПолучитьАдреса() Экспорт
	СериолизоватьВХМЛ();
	ОтправитьНаСайт();
	РаспознатьАдреса();
КонецФункции	

#КонецОбласти

#Область ВспомогательныеФункции

Функция РазобратьЗаказы()
	тз=новый ТаблицаЗначений;
	ТЗ.Колонки.Добавить("pid", Новый ОписаниеТипов("Строка"));
	ТЗ.Колонки.Добавить("uid", Новый ОписаниеТипов("Строка"));
	ТЗ.Колонки.Добавить("orderId", Новый ОписаниеТипов("Строка")); 
	ТЗ.Колонки.Добавить("orderType", Новый ОписаниеТипов("Строка")); 
	Для каждого заказ из Заказы Цикл
		Если ТипЗнч(Заказ.Покупка)=Тип("СправочникСсылка.Покупки") Тогда
			стр				= тз.Добавить();
			стр.orderType	= "sp";
			Если Заказ.КодЗаказа = "" Тогда
				стр.pid			= Формат(Заказ.Покупка.Код,"ЧГ=0");
			Иначе 
				стр.orderId 	= Заказ.КодЗаказа;
			КонецЕсли;	
			стр.uid			= Формат(заказ.Участник.Код,"ЧГ=0");
		ИначеЕсли ТипЗнч(Заказ.Покупка)=Тип("СправочникСсылка.Заказы") Тогда
			стр				= тз.Добавить();
			стр.orderType	= "shop";
			стр.orderId 	= Формат(Заказ.Покупка.Код,"ЧГ=0");
			стр.uid			= Формат(заказ.Участник.Код,"ЧГ=0");
		ИначеЕсли 	ТипЗнч(Заказ.Покупка)=Тип("СправочникСсылка.Посылки")  Тогда
			Если Заказ.КодЗаказа = "" Тогда
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не определен код заказа для посылки:"+Заказ.Покупка);
				Продолжить;
			КонецЕсли;	
			
			стр				= тз.Добавить();
			стр.orderType	= "sp";
			стр.orderId 	= Заказ.КодЗаказа;
			стр.uid			= Формат(заказ.Участник.Код,"ЧГ=0");
		ИначеЕсли 	ТипЗнч(Заказ.Покупка)=Тип("СправочникСсылка.Пристрой") Тогда
			Если Заказ.КодЗаказа = "" Тогда
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не определен код заказа для посылки:"+Заказ.Покупка);
				Продолжить;
			КонецЕсли;	
			
			стр				= тз.Добавить();
			стр.orderType	= "bulletin";
			стр.orderId 	= Заказ.КодЗаказа;
			стр.uid			= Формат(заказ.Участник.Код,"ЧГ=0");

		Иначе
			Продолжить;
		КонецЕсли;
	КонецЦикла;
	тз.Свернуть("pid,orderId,orderType,uid");
	возврат тз;
КОнецФункции	

Процедура ДобавитьСписоквХМЛизТЗ(ЗаписьXML,ИмяСписка,ИмяЭлементаСписка,ТЗ)
	ЗаписьXML.ЗаписатьНачалоЭлемента(ИмяСписка);
	Для каждого стр из ТЗ Цикл
		ЗаписьXML.ЗаписатьНачалоЭлемента(ИмяЭлементаСписка);
		Для каждого стрКолонка из ТЗ.колонки Цикл
			Если стр[стрКолонка.Имя]<>""  Тогда
				ЗаписьXML.ЗаписатьНачалоЭлемента(стрКолонка.Имя);
				ЗаписьXML.ЗаписатьТекст(Строка(стр[стрКолонка.Имя]));
				ЗаписьXML.ЗаписатьКонецЭлемента();
			КонецЕсли;
		КОнецЦикла;
		ЗаписьXML.ЗаписатьКонецЭлемента();
	КонецЦикла;
	ЗаписьXML.ЗаписатьКонецЭлемента();
КонецПроцедуры	

Функция ОбменССайтом() 
	Параметры    = новый Структура;
	Параметры.Вставить("token",Константы.Токен.Получить());
	Параметры.Вставить("xml", СтрЗаменить(ОтправленныеДанные,"xmlns=""http://www.100sp.ru/XMLSchema-instance"" ",""));
	АдресСкрипта = Константы.АдресЗагрузкиССайта.Получить();

	ПолученныйФайл=СтоСПОбмен_Общий.ПолучитьПостЗапросом(Параметры,АдресСкрипта);
	Возврат ПолученныйФайл;
КонецФункции

Функция ФайлВСтроку(ИмяФайлаОтвета)
		ТекстФайла="";
		Текст=Новый ЧтениеТекста;
		Текст.Открыть(ИмяФайлаОтвета,КодировкаТекста.UTF8);
		Стр = Текст.ПрочитатьСтроку();
		Пока Стр <> Неопределено Цикл 
			ТекстФайла=ТекстФайла+Стр;
			Стр = Текст.ПрочитатьСтроку();
		КонецЦикла;
		/////
		ТекстФайла=СтрЗаменить(ТекстФайла,"<incomes>","<incomes>"+Символы.ПС);
		ТекстФайла=СтрЗаменить(ТекстФайла,"</income>","</income>"+Символы.ПС);
		ТекстФайла=СтрЗаменить(ТекстФайла,"<returns>","<returns>"+Символы.ПС);
		ТекстФайла=СтрЗаменить(ТекстФайла,"</return>","</return>"+Символы.ПС);
		ТекстФайла=СтрЗаменить(ТекстФайла,"<deliveries>","<deliveries>"+Символы.ПС);
		ТекстФайла=СтрЗаменить(ТекстФайла,"</delivery>","</delivery>"+Символы.ПС);
		ТекстФайла=СтрЗаменить(ТекстФайла,"<cards>","<cards>"+Символы.ПС);
		ТекстФайла=СтрЗаменить(ТекстФайла,"</card>","</card>"+Символы.ПС);
		ТекстФайла=СтрЗаменить(ТекстФайла,"</auth>","</auth>"+Символы.ПС);
		ТекстФайла=СтрЗаменить(ТекстФайла,"<deliveryDetails>","<deliveryDetails>"+Символы.ПС);
		ТекстФайла=СтрЗаменить(ТекстФайла,"</sticker>","</sticker>"+Символы.ПС);


		Возврат ТекстФайла ;
КонецФункции

Процедура ОбработкаПроведения(Отказ, Режим)
	Движения.АдресаЗаказов.Записывать = Истина;
	Для Каждого ТекСтрокаЗаказы Из Заказы Цикл
		Движение = Движения.АдресаЗаказов.Добавить();
		Движение.Период 		= Дата;
		ЗаполнитьЗначенияСвойств(Движение,ТекСтрокаЗаказы);
	КонецЦикла;
КонецПроцедуры

#КонецОбласти
