
#Область ЗагрузкаПристрояПоСпискуУчастников

Функция ПолучитьХМЛ_ПристройПоСпискуУчастников(СписокУчастников)
	Тип_userBulletinOrders	= ФабрикаXDTO.Тип("http://www.100sp.ru/out","distributors.userBulletinOrders");
	Тип_distributors		= ФабрикаXDTO.Тип("http://www.100sp.ru/out","distributors");
	
	Объект_userBulletinOrders = ФабрикаXDTO.Создать(Тип_userBulletinOrders);
	Для каждого элем из СписокУчастников Цикл
		Объект_userBulletinOrders.user.Добавить(элем.Значение.Код);
	КонецЦикла;
	
	Объект_distributors=ФабрикаXDTO.Создать(Тип_distributors);
	Объект_distributors.userBulletinOrders=Объект_userBulletinOrders;
	
	Запись = Новый ЗаписьXML;
	Запись.УстановитьСтроку(); 
	ФабрикаXDTO.ЗаписатьXML(Запись, Объект_distributors);
	ДанныеXML = Запись.Закрыть();
	ДанныеXML="<?xml version=""1.0"" encoding=""UTF-8""?> "+СтрЗаменить(ДанныеXML,"xmlns=""http://www.100sp.ru/out"" ","");
	Возврат ДанныеXML; 
КонецФункции


Функция ПолученныеДанные_ПристройПоСпискуУчастников(ДанныеXML) 
	Параметры    = новый Структура;
	Параметры.Вставить("token",Константы.Токен.Получить());
	Параметры.Вставить("xml", ДанныеXML);
	АдресСкрипта = Константы.АдресЗагрузкиССайта.Получить();

	ПолученныйФайл=СтоСПОбмен_Общий.ПолучитьПостЗапросом(Параметры,АдресСкрипта);
	Если ПолученныйФайл=Неопределено Тогда Возврат Неопределено КонецЕсли;

	ПолученныеДанные=СтоСПОбмен_Общий.ФайлВСтроку(ПолученныйФайл);
	Возврат ПолученныеДанные;
КонецФункции	

Функция Разбор_ПристройПоСпискуУчастников(ТЗЗаказов,ПолученныеДанные) 
	пространствоИмен="http://www.100sp.ru/api/distributor/upload/back";
	ПолученныеДанные=СтрЗаменить(ПолученныеДанные,"http://www.100sp.ru",пространствоИмен);
	авторизацияВыполнена=ложь;
	
	
	Тип_distributors=ФабрикаXDTO.Тип(пространствоИмен, "distributors");
	
	ЧтениеXML = Новый ЧтениеXML;
	ЧтениеXML.УстановитьСтроку(ПолученныеДанные);
	
	Объект_distributors= ФабрикаXDTO.ПрочитатьXML(ЧтениеXML,Тип_distributors);
	Если Объект_distributors.auth.result="ok" Тогда
		авторизацияВыполнена=истина;
	КонецЕсли;
	Если Объект_distributors.userBulletinOrders=Неопределено Тогда
		Возврат авторизацияВыполнена;
	КонецЕсли;	
	
	Для каждого участник из Объект_distributors.userBulletinOrders.user Цикл
		Если участник.result="error"  Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(участник.message);
			продолжить;
		КонецЕсли;		
		Для каждого пристрой из участник.bulletinOrder Цикл
			ответ = СоздатьПристройПоXDTO(пристрой,участник.id);
		КонецЦикла;
	КонецЦикла;
	Возврат авторизацияВыполнена;
КонецФункции

Функция Ошибки_ПристройПоСпискуУчастников(ТЗ) 
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

Функция Загрузить_ПристройПоСпискуУчастников(СписокУчастников) Экспорт
	хмл_отправили=ПолучитьХМЛ_ПристройПоСпискуУчастников(СписокУчастников);
	хмл_получили =ПолученныеДанные_ПристройПоСпискуУчастников(хмл_отправили);
	
	ТЗ=Новый ТаблицаЗначений;
	ТЗ.Колонки.Добавить("Ошибка");
	Если хмл_получили=Неопределено Тогда 
		стр=тз.Добавить();
		стр.Ошибка="Не удалось соединиться с сайтом";
	Иначе	
		возврат Разбор_ПристройПоСпискуУчастников(ТЗ,хмл_получили);
	КонецЕсли;
	Ошибки_ПристройПоСпискуУчастников(ТЗ);
	Возврат новый Структура("Ошибки",ТЗ);
КонецФункции

Функция Загрузить_ПристройПоУчастнику(Участник) Экспорт
	списокУчастников = Новый СписокЗначений;
	списокУчастников.Добавить(Участник);
	Возврат Загрузить_ПристройПоСпискуУчастников(списокУчастников);
КонецФункции	

#КонецОбласти


#Область ОтвязатьПристрояОтПосылки

Функция ПолучитьХМЛ_ОтвязатьПристрояОтПосылки(СписокПристроя)
	Тип_packageStickerOrderUnlink	= ФабрикаXDTO.Тип("http://www.100sp.ru/out","distributors.packageStickerOrderUnlinks.packageStickerOrderUnlink");
	Тип_packageStickerOrderUnlinks	= ФабрикаXDTO.Тип("http://www.100sp.ru/out","distributors.packageStickerOrderUnlinks");
	Тип_distributors				= ФабрикаXDTO.Тип("http://www.100sp.ru/out","distributors");
	
	Объект_packageStickerOrderUnlinks = ФабрикаXDTO.Создать(Тип_packageStickerOrderUnlinks);
	Для каждого элем из СписокПристроя Цикл
		Объект_packageStickerOrderUnlink = ФабрикаXDTO.Создать(Тип_packageStickerOrderUnlink);
		Объект_packageStickerOrderUnlink.orderType = "bulletin";
		Объект_packageStickerOrderUnlink.orderId = Формат(элем.Значение.Код,"ЧГ=0");
		Объект_packageStickerOrderUnlinks.packageStickerOrderUnlink.Добавить(Объект_packageStickerOrderUnlink);
	КонецЦикла;
	
	Объект_distributors=ФабрикаXDTO.Создать(Тип_distributors);
	Объект_distributors.packageStickerOrderUnlinks=Объект_packageStickerOrderUnlinks;
	
	Запись = Новый ЗаписьXML;
	Запись.УстановитьСтроку(); 
	ФабрикаXDTO.ЗаписатьXML(Запись, Объект_distributors);
	ДанныеXML = Запись.Закрыть();
	ДанныеXML="<?xml version=""1.0"" encoding=""UTF-8""?> "+СтрЗаменить(ДанныеXML,"xmlns=""http://www.100sp.ru/out"" ","");
	Возврат ДанныеXML; 
КонецФункции


Функция ПолученныеДанные_ОтвязатьПристрояОтПосылки(ДанныеXML) 
	Параметры    = новый Структура;
	Параметры.Вставить("token",Константы.Токен.Получить());
	Параметры.Вставить("xml", ДанныеXML);
	АдресСкрипта = Константы.АдресВыгрузкиНасайт.Получить();

	ПолученныйФайл=СтоСПОбмен_Общий.ПолучитьПостЗапросом(Параметры,АдресСкрипта);
	Если ПолученныйФайл=Неопределено Тогда Возврат Неопределено КонецЕсли;

	ПолученныеДанные=СтоСПОбмен_Общий.ФайлВСтроку(ПолученныйФайл);
	Возврат ПолученныеДанные;
КонецФункции	

Функция Разбор_ОтвязатьПристрояОтПосылки(ТЗЗаказов,ПолученныеДанные) 
	пространствоИмен="http://www.100sp.ru/api/distributor/upload/back";
	ПолученныеДанные=СтрЗаменить(ПолученныеДанные,"http://www.100sp.ru",пространствоИмен);
	авторизацияВыполнена=ложь;
	
	
	Тип_distributors=ФабрикаXDTO.Тип(пространствоИмен, "distributors");
	
	ЧтениеXML = Новый ЧтениеXML;
	ЧтениеXML.УстановитьСтроку(ПолученныеДанные);
	
	Объект_distributors= ФабрикаXDTO.ПрочитатьXML(ЧтениеXML,Тип_distributors);
	Если Объект_distributors.auth.result="ok" Тогда
		авторизацияВыполнена=истина;
	КонецЕсли;
	Если Объект_distributors.packageStickerOrderUnlinks=Неопределено Тогда
		Возврат авторизацияВыполнена;
	КонецЕсли;	
	
	Для каждого пристрой из Объект_distributors.packageStickerOrderUnlinks.packageStickerOrderUnlink Цикл
		Если пристрой.result="error"  Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(пристрой.message);
			Возврат Ложь
		Иначе	
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Пристрой отвязан с кодом "+Пристрой.orderId+" отвязан!");
		КонецЕсли;		
		//Для каждого пристрой из участник.bulletinOrder Цикл
		//	ответ = СоздатьПристройПоXDTO(пристрой,участник.id);
		//КонецЦикла;
	КонецЦикла;
	Возврат авторизацияВыполнена;
КонецФункции

Функция Ошибки_ОтвязатьПристрояОтПосылки(ТЗ) 
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

Функция Выгрузить_ОтвязатьСписокПристрояОтПосылки(СписокПристроя) Экспорт
	хмл_отправили=ПолучитьХМЛ_ОтвязатьПристрояОтПосылки(СписокПристроя);
	хмл_получили =ПолученныеДанные_ОтвязатьПристрояОтПосылки(хмл_отправили);
	
	ТЗ=Новый ТаблицаЗначений;
	ТЗ.Колонки.Добавить("Ошибка");
	Если хмл_получили=Неопределено Тогда 
		стр=тз.Добавить();
		стр.Ошибка="Не удалось соединиться с сайтом";
	Иначе	
		возврат Разбор_ОтвязатьПристрояОтПосылки(ТЗ,хмл_получили);
	КонецЕсли;
	Ошибки_ОтвязатьПристрояОтПосылки(ТЗ);
	Возврат новый Структура("Ошибки",ТЗ);
КонецФункции

Функция Выгрузить_ОтвязатьПристройОтПосылки(Пристрой) Экспорт
	СписокПристроя = Новый СписокЗначений;
	СписокПристроя.Добавить(Пристрой);
	Возврат Выгрузить_ОтвязатьСписокПристрояОтПосылки(СписокПристроя);
КонецФункции	

#КонецОбласти







#Область Вспомогательные

Функция СоздатьПристройПоXDTO(об_XDTO,КодУчастникаОтпровителя)
	
	КодПристроя			= Формат(Число(об_XDTO.orderId),"ЧГ=0");
	ПристройСсылка		= Справочники.Пристрой.НайтиПоКоду(КодПристроя);	
	Если не ЗначениеЗаполнено(ПристройСсылка) Тогда
		обПристрой		= Справочники.Пристрой.СоздатьЭлемент();
		обПристрой.Код	= КодПристроя;
	Иначе	
		обПристрой		= ПристройСсылка.ПолучитьОбъект();
	КонецЕсли;	
	обПристрой.Наименование			= об_XDTO.bulletinName;
	обПристрой.УчастникОтправитель 	= СП_РаботаСоСправочниками.ПолучитьУчастникаПо_Коду(КодУчастникаОтпровителя);
	обПристрой.Участник         	= СП_РаботаСоСправочниками.ПолучитьУчастникаПо_Коду(об_XDTO.uid);
	обПристрой.ТочкаНазначения		= СП_РаботаСоСправочниками.ПолучитьПунктВыдачиПо_Коду(об_XDTO.distributorCode);
	обПристрой.bulletinId			= об_XDTO.bulletinId;
	обПристрой.secureCode			= об_XDTO.secureCode;
	Попытка
		обПристрой.Записать();
	Исключение
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ОписаниеОшибки());
	КонецПопытки;
	
	Возврат обПристрой.Ссылка;	
	
КонецФункции



#КонецОбласти

