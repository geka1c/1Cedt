#Область ПрограммныйИнтерфейс
Функция ПолучитьСписокДиалогов(НеПрочитанные=Ложь) Экспорт

	ПараметрыЗапроса=Новый Структура();
	ПараметрыЗапроса.Вставить("auth",Константы.Токен.Получить());
	ПараметрыЗапроса.Вставить("is_distributor_auth","true");
	ПараметрыЗапроса.Вставить("page","1");             //Номер страницы
	ПараметрыЗапроса.Вставить("pageSize","10000");         //Количество диалогов на странице
	Если НеПрочитанные Тогда
		ПараметрыЗапроса.Вставить("unread","true");         //Загружать только (не) прочитанные
	Иначе	
		ПараметрыЗапроса.Вставить("updatedFromDate",ПолучитьДатуПоследнегоСообщения());   //Номер страницы
	КонецЕсли;	
	ПараметрыЗапроса.Вставить("ver","1.0");


	
	ИмяМетода="message/getDialogList";
	ИмяФайлаОтвета=ВыполнитьЗапрос(ИмяМетода, ПараметрыЗапроса);
	
	ЧтениеJSON = Новый ЧтениеJSON;
	ЧтениеJSON.ОткрытьФайл(ИмяФайлаОтвета);
	
	пространствоИмен="http://www.100sp.ru/api/mobile";
	Тип_main=ФабрикаXDTO.Тип(пространствоИмен, "main");
	Фабрика=ФабрикаXDTO.ПрочитатьJSON(ЧтениеJSON,Тип_main);
	
	ЧтениеJSON.Закрыть();
	УдалитьФайлы(ИмяФайлаОтвета);
	
	Если Фабрика.dialogList<>Неопределено Тогда
		реквизиты_Дата=Новый Массив;
		реквизиты_Дата.Добавить("updated");
		ТЗ_Диалогов=СтоСПОбмен_Общий.ТЗ_поСпискуXDTO(Фабрика.dialogList,реквизиты_Дата);
	КонецЕсли;
	
#Область УдаляемНеИзменившиесяДиалоги	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	тз.mdid КАК mdid,
		|	тз.unread КАК unread,
		|	тз.updated КАК updated
		|ПОМЕСТИТЬ Внешн
		|ИЗ
		|	&тз КАК тз
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Внешн.mdid КАК mdid,
		|	Внешн.updated КАК updated,
		|	Чат100СП_Диалоги.mdid КАК mdid1
		|ПОМЕСТИТЬ ВсеЗаписи
		|ИЗ
		|	Внешн КАК Внешн
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.Чат100СП_Диалоги КАК Чат100СП_Диалоги
		|		ПО Внешн.mdid = Чат100СП_Диалоги.mdid
		|		и Внешн.unread = Чат100СП_Диалоги.unread
		|			И Внешн.updated = Чат100СП_Диалоги.updated
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВсеЗаписи.mdid КАК mdid,
		|	ВсеЗаписи.updated КАК updated,
		|	ВсеЗаписи.mdid1 КАК mdid1
		|ИЗ
		|	ВсеЗаписи КАК ВсеЗаписи
		|ГДЕ
		|	НЕ ВсеЗаписи.mdid1 ЕСТЬ NULL";
		
		
	Запрос.УстановитьПараметр("тз", ТЗ_Диалогов);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		масс_Найденых=ТЗ_Диалогов.НайтиСтроки(новый Структура("mdid, updated",Выборка.mdid, Выборка.updated));
		ТЗ_Диалогов.Удалить(масс_Найденых[0]);
	КонецЦикла;
#КонецОбласти 	


	ТЗ_Диалогов.Колонки.Добавить("last_message"	,новый ОписаниеТипов("Строка"));
	
	нз_Диалоги=РегистрыСведений.Чат100СП_Диалоги.СоздатьНаборЗаписей();
	Для каждого стр из ТЗ_Диалогов Цикл
		стр.last_message=стр.messages.message[0].body;
		
		нз_Диалоги.Отбор.mdid.Использование	= Истина;
		нз_Диалоги.Отбор.mdid.Значение		= стр.mdid;
		нз_Диалоги.Прочитать();
		нз_Диалоги.Очистить();

		диалог=нз_Диалоги.Добавить();
		ЗаполнитьЗначенияСвойств(диалог,стр);
		диалог.user		= СП_РаботаСоСправочниками.ПолучитьУчастникаПо_Коду(стр.user.uid);
		диалог.opponent	= СП_РаботаСоСправочниками.ПолучитьУчастникаПо_Коду(стр.opponent.uid);
		Если  стр.connected_type="purchase" или стр.connected_type= "shop_order" Тогда
			структураЗаказа	= новый Структура;
			структураЗаказа.Вставить("type",стр.connected_type);
			структураЗаказа.Вставить(?(стр.connected_type="purchase", "pid","orderId"),стр.connected_id);
			диалог.Покупка  = СП_РаботаСоСправочниками.ПолучитьЗаказПоXDTO(структураЗаказа);
		КонецЕсли;
		нз_Диалоги.Записать();
	КонецЦикла;
КонецФункции	


Функция ПолучитьДиалог(ИД_Диалога) Экспорт
	ПараметрыЗапроса=Новый Структура();
	ПараметрыЗапроса.Вставить("auth",Константы.Токен.Получить());
	ПараметрыЗапроса.Вставить("is_distributor_auth","true");
	ПараметрыЗапроса.Вставить("page","1");             	  //Номер страницы
	ПараметрыЗапроса.Вставить("pageSize","10000");        //Количество диалогов на странице
	//ПараметрыЗапроса.Вставить("unread","true");         //Загружать только (не) прочитанные
	ПараметрыЗапроса.Вставить("dialogId",Формат(ИД_Диалога,"ЧГ=0"));     //dialogId
	ПараметрыЗапроса.Вставить("ver","1.0");


	
	ИмяМетода="message/getDialog";
	ИмяФайлаОтвета=ВыполнитьЗапрос(ИмяМетода, ПараметрыЗапроса);
	
	ЧтениеJSON = Новый ЧтениеJSON;
	ЧтениеJSON.ОткрытьФайл(ИмяФайлаОтвета);
	
	пространствоИмен="http://www.100sp.ru/api/mobile";
	Тип_message=ФабрикаXDTO.Тип(пространствоИмен, "main_message");
	Фабрика=ФабрикаXDTO.ПрочитатьJSON(ЧтениеJSON,Тип_message);
	
	ЧтениеJSON.Закрыть();
	УдалитьФайлы(ИмяФайлаОтвета);
	
	Если Фабрика.dialog.messages.message<>Неопределено Тогда
		реквизиты_Дата=Новый Массив;
		реквизиты_Дата.Добавить("created");
		ТЗ_Диалогов=СтоСПОбмен_Общий.ТЗ_поСпискуXDTO(Фабрика.dialog.messages.message,реквизиты_Дата);
		ТЗ_Диалогов.ЗаполнитьЗначения(Фабрика.dialog.mdid,"mdid");
	КонецЕсли;
	
	
	
#Область УдаляемНеИзменившиесяДиалоги	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	тз.mdid КАК mdid,
		|	тз.mid КАК mid,
		|	тз.unread КАК unread
		|ПОМЕСТИТЬ Внешн
		|ИЗ
		|	&тз КАК тз
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Внешн.mdid КАК mdid,
		|	Внешн.mid КАК mid,
		|	Внешн.unread КАК unread,
		|	Чат100СП_Сообщения.mid КАК mid1
		|ПОМЕСТИТЬ ВсеЗаписи
		|ИЗ
		|	Внешн КАК Внешн
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.Чат100СП_Сообщения КАК Чат100СП_Сообщения
		|		ПО Внешн.mdid = Чат100СП_Сообщения.mdid
		|			И Внешн.mid = Чат100СП_Сообщения.mid
		|			И Внешн.unread = Чат100СП_Сообщения.unread
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВсеЗаписи.mdid КАК mdid,
		|	ВсеЗаписи.mid КАК mid,
		|	ВсеЗаписи.unread КАК unread,
		|	ВсеЗаписи.mid1 КАК mid1
		|ИЗ
		|	ВсеЗаписи КАК ВсеЗаписи
		|ГДЕ
		|	НЕ ВсеЗаписи.mid1 ЕСТЬ NULL";
		
		
	Запрос.УстановитьПараметр("тз", ТЗ_Диалогов);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		масс_Найденых=ТЗ_Диалогов.НайтиСтроки(новый Структура("mid",Выборка.mid));
		ТЗ_Диалогов.Удалить(масс_Найденых[0]);
	КонецЦикла;
#КонецОбласти 	

	нз_Диалоги=РегистрыСведений.Чат100СП_Сообщения.СоздатьНаборЗаписей();
	Для каждого стр из ТЗ_Диалогов Цикл
		
		нз_Диалоги.Отбор.mid.Использование	= Истина;
		нз_Диалоги.Отбор.mid.Значение		= стр.mid;
		нз_Диалоги.Прочитать();
		нз_Диалоги.Очистить();
		диалог=нз_Диалоги.Добавить();
		ЗаполнитьЗначенияСвойств(диалог,стр);
		диалог.from_u=СП_РаботаСоСправочниками.ПолучитьУчастникаПо_Коду(стр.from);
		нз_Диалоги.Записать();
	КонецЦикла;
	
	
	
КонецФункции	

 
// Создать диалог с частником 100СП 
//
// Параметры:
//   Парам - Структура - поля:
//   Оппанент - СправочникСсылка.Участники - Участник кому пишем
//   Покупка - СправочникСсылка.Покупки, СправочникСсылка.Заказы , связанная с Диалогом сущность
//	 Сообщение - Строка, текст сообщения, которое появится в диалоге
//   Тема - Строка, тема диалога
// Возвращаемое значение: - РегистрСведенийКлючЗаписи.Чат100СП_Диалоги, Неопределено  
Функция СоздатьДиалог(Парам) Экспорт
	ПараметрыЗапроса=Новый Структура();
	ПараметрыЗапроса.Вставить("auth",Константы.Токен.Получить());
	ПараметрыЗапроса.Вставить("is_distributor_auth","true");
	ПараметрыЗапроса.Вставить("opponentUid"		,Формат(Парам.Оппонент.Код,"ЧГ=0"));    // id кому пишем
	Если ТипЗнч(Парам.Покупка)=Тип("СправочникСсылка.Заказы") Тогда
		ПараметрыЗапроса.Вставить("connectedType"	,"shop_order");        						// тип связанного id, например для заказа в сп — 'purchase'
	Иначе	
		ПараметрыЗапроса.Вставить("connectedType"	,"purchase");        						// тип связанного id, например для заказа в сп — 'purchase'
	КонецЕсли;
	Если ЗначениеЗаполнено(Парам.Покупка) Тогда
		ПараметрыЗапроса.Вставить("connectedId"		,Формат(Число(Парам.Покупка.Код),"ЧГ=0"));     // связанный id
	Иначе	
		ПараметрыЗапроса.Вставить("connectedId"		,"0");     // связанный id
	КонецЕсли;	
//	ПараметрыЗапроса.Вставить("body"			,"\u0422\u0435\u0441\u0442\u043e\u0432\u043e\u0435\u0020\u0441\u043e\u0043e\u0431\u0449\u0435\u0043d\u0438\u0435");     					// текст сообщения, которое появится в диалоге
//	ПараметрыЗапроса.Вставить("subject"			,"\u0422\u0435\u0441\u0442\u043e\u0432\u0430\u044f\u0020\u0442\u0435\u0043c\u0430");     						//тема диалога
	ПараметрыЗапроса.Вставить("body"			,функDOS2Unicode(Парам.Сообщение));     					// текст сообщения, которое появится в диалоге
	ПараметрыЗапроса.Вставить("subject"			,функDOS2Unicode(Парам.Тема));     						//тема диалога
	
	ПараметрыЗапроса.Вставить("ver"				,"1.0");


	
	ИмяМетода="message/createDialog";
	ИмяФайлаОтвета=ВыполнитьЗапрос(ИмяМетода, ПараметрыЗапроса);
	
	ЧтениеJSON = Новый ЧтениеJSON;
	ЧтениеJSON.ОткрытьФайл(ИмяФайлаОтвета);
	
	пространствоИмен="http://www.100sp.ru/api/mobile";
	Тип_message=ФабрикаXDTO.Тип(пространствоИмен, "main_message");
	Тип_main=ФабрикаXDTO.Тип(пространствоИмен, "main");
	об_майн=ФабрикаXDTO.Создать(Тип_main);
	
	//ррр=ПрочитатьJSON(ЧтениеJSON);
	Фабрика=ФабрикаXDTO.ПрочитатьJSON(ЧтениеJSON,Тип_message);
	ЧтениеJSON.Закрыть();
	УдалитьФайлы(ИмяФайлаОтвета);
	Если Фабрика.errors<>Неопределено и Фабрика.errors.Количество()>0 Тогда
		Для каждого ошибка из Фабрика.errors Цикл
			текстОшибки= "Получена ошибка: "+ошибка.type+Символы.ПС+
						"описание: "+ошибка.message;
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(текстОшибки);
		КонецЦикла;
		Возврат Неопределено;
	КонецЕсли;
	Если Фабрика.dialog<>Неопределено Тогда
		реквизиты_Дата=Новый Массив;
		реквизиты_Дата.Добавить("updated");
		об_майн.dialogList.Добавить(Фабрика.dialog);
		ТЗ_Диалогов=СтоСПОбмен_Общий.ТЗ_поСпискуXDTO(об_майн.dialogList,реквизиты_Дата);
	Иначе	
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не удалось создать диалог!");
	КонецЕсли;
	
	ТЗ_Диалогов.Колонки.Добавить("last_message"	,новый ОписаниеТипов("Строка"));
	
	нз_Диалоги=РегистрыСведений.Чат100СП_Диалоги.СоздатьНаборЗаписей();
	Для каждого стр из ТЗ_Диалогов Цикл
		стр.last_message=стр.messages.message[0].body;
		
		нз_Диалоги.Отбор.mdid.Использование	= Истина;
		нз_Диалоги.Отбор.mdid.Значение		= стр.mdid;
		нз_Диалоги.Прочитать();
		диалог=нз_Диалоги.Добавить();
		ЗаполнитьЗначенияСвойств(диалог,стр);
		диалог.user=СП_РаботаСоСправочниками.ПолучитьУчастникаПо_Коду(стр.user.uid);
		диалог.opponent=СП_РаботаСоСправочниками.ПолучитьУчастникаПо_Коду(стр.opponent.uid);
		Если  стр.connected_type="purchase" или стр.connected_type= "shop_order" Тогда
			структураЗаказа	= новый Структура;
			структураЗаказа.Вставить("type",стр.connected_type);
			структураЗаказа.Вставить(?(стр.connected_type="purchase", "pid","orderId"),стр.connected_id);
			диалог.Покупка  = СП_РаботаСоСправочниками.ПолучитьЗаказПоXDTO(структураЗаказа);
		КонецЕсли;
		нз_Диалоги.Записать();
	КонецЦикла;
	Возврат ПолучитьКлючЗаписи(диалог); 
КонецФункции


 
// Отправить сообщение участнику 100СП 
//
// Параметры:
//   ИД_Диалога - Число - Ид Диалога
//   Сообщение - Строка - Сообщение
// Возвращаемое значение: - РегистрСведенийКлючЗаписи.Обмен100спСообщения, Неопределено  
Функция ОтправитьСообщение(ИД_Диалога, Сообщение) Экспорт
	ПараметрыЗапроса=Новый Структура();
	ПараметрыЗапроса.Вставить("auth",Константы.Токен.Получить());
	ПараметрыЗапроса.Вставить("is_distributor_auth","true");
	ПараметрыЗапроса.Вставить("dialogId"		,Формат(ИД_Диалога,"ЧГ=0"));     						//ИД диалога
	ПараметрыЗапроса.Вставить("body"			,функDOS2Unicode(Сообщение));     		// текст сообщения, которое появится в диалоге
	ПараметрыЗапроса.Вставить("ver"				,"1.0");
	
	ИмяМетода="message/sendMessage";
	
	ИмяФайлаОтвета=ВыполнитьЗапрос(ИмяМетода, ПараметрыЗапроса);
	
	ЧтениеJSON = Новый ЧтениеJSON;
	ЧтениеJSON.ОткрытьФайл(ИмяФайлаОтвета);
	
	пространствоИмен="http://www.100sp.ru/api/mobile";
	Тип_message=ФабрикаXDTO.Тип(пространствоИмен, "main_message");
	Тип_main=ФабрикаXDTO.Тип(пространствоИмен, "main");
	об_майн=ФабрикаXDTO.Создать(Тип_main);
	
	//ррр=ПрочитатьJSON(ЧтениеJSON);
	Фабрика=ФабрикаXDTO.ПрочитатьJSON(ЧтениеJSON,Тип_message);
	ЧтениеJSON.Закрыть();
	УдалитьФайлы(ИмяФайлаОтвета);
	Если Фабрика.errors<>Неопределено и Фабрика.errors.Количество()>0 Тогда
		Для каждого ошибка из Фабрика.errors Цикл
			текстОшибки= "Получена ошибка: "+ошибка.type+Символы.ПС+
						"описание: "+ошибка.message;
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(текстОшибки);
		КонецЦикла;
		Возврат Неопределено;
	КонецЕсли;
	Если Фабрика.success=Истина Тогда
		ПолучитьДиалог(ИД_Диалога);	
	Иначе	
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не удалось отправить сообщение!");
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат Истина; 
КонецФункции



 
// Сделать диалог не прочитанным
//
// Параметры:
//   ИД_Диалога - Число - Ид Диалога
// Возвращаемое значение: - РегистрСведенийКлючЗаписи.Обмен100спСообщения, Неопределено  
Функция СделатьДиалогНеПрочитанным(ИД_Диалога) Экспорт
	ПараметрыЗапроса=Новый Структура();
	ПараметрыЗапроса.Вставить("auth",Константы.Токен.Получить());
	ПараметрыЗапроса.Вставить("is_distributor_auth","true");
	ПараметрыЗапроса.Вставить("dialogId"		,Формат(ИД_Диалога,"ЧГ=0"));     						//ИД диалога
	ПараметрыЗапроса.Вставить("ver"				,"1.0");
	
	ИмяМетода="message/markDialogAsUnread";
	
	ИмяФайлаОтвета=ВыполнитьЗапрос(ИмяМетода, ПараметрыЗапроса);
	
	ЧтениеJSON = Новый ЧтениеJSON;
	ЧтениеJSON.ОткрытьФайл(ИмяФайлаОтвета);
	
	пространствоИмен="http://www.100sp.ru/api/mobile";
	Тип_message=ФабрикаXDTO.Тип(пространствоИмен, "main_message");
	Тип_main=ФабрикаXDTO.Тип(пространствоИмен, "main");
	об_майн=ФабрикаXDTO.Создать(Тип_main);
	
	//ррр=ПрочитатьJSON(ЧтениеJSON);
	Фабрика=ФабрикаXDTO.ПрочитатьJSON(ЧтениеJSON,Тип_message);
	ЧтениеJSON.Закрыть();
	УдалитьФайлы(ИмяФайлаОтвета);
	Если Фабрика.errors<>Неопределено и Фабрика.errors.Количество()>0 Тогда
		Для каждого ошибка из Фабрика.errors Цикл
			текстОшибки= "Получена ошибка: "+ошибка.type+Символы.ПС+
						"описание: "+ошибка.message;
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(текстОшибки);
		КонецЦикла;
		Возврат Неопределено;
	КонецЕсли;
	Если Фабрика.success=Истина Тогда
		ПолучитьДиалог(ИД_Диалога);	
	Иначе	
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не удалось отправить сообщение!");
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат Истина; 
КонецФункции





Процедура УдалитьЛокальноСообщенияДиалога(ИД_Диалога) Экспорт
	нз=РегистрыСведений.Чат100СП_Сообщения.СоздатьНаборЗаписей();
	нз.Отбор.mdid.Значение=ИД_Диалога;
	нз.Отбор.mdid.Использование=Истина;
	нз.Прочитать();
	нз.Очистить();
	нз.Записать();
КонецПроцедуры	


#КонецОбласти


#Область Вспомогательные
Функция ВыполнитьЗапрос(ИмяМетода, Параметры)
	Сервер              =Константы.Сервер.Получить();
	
	ИмяФайлаОтвета  	= ПолучитьИмяВременногоФайла("xml");
	ИмяФайлаОтправки	= СформироватьФайлДляPOSTЗапроса(Параметры);
	ЗаголовокHTTP 		= Новый Соответствие();
	ССЛ					= Новый ЗащищенноеСоединениеOpenSSL;
	НТТР 				= Новый HTTPСоединение(Сервер,,,,,,ССЛ);
    Попытка
        Ответ=НТТР.ОтправитьДляОбработки(ИмяФайлаОтправки, "/api/mobile/"+ИмяМетода, ИмяФайлаОтвета, ЗаголовокHTTP);
    Исключение

        #Если Клиент Тогда
            ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Неудачная попытка соединения: " + ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());     
        #Иначе
            ЗаписьЖурналаРегистрации("ЗагрузкаССайта", УровеньЖурналаРегистрации.Ошибка, , , "Неудачная попытка соединения: " + ОписаниеОшибки(),);
			Ошибки=Неопределено;
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки,,"Неудачная попытка соединения: " + ОписаниеОшибки(),);
			ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки);
        #КонецЕсли
        Возврат Неопределено;
    КонецПопытки;
    УдалитьФайлы(ИмяФайлаОтправки);
	Возврат ИмяФайлаОтвета;
КонецФункции

Функция СформироватьФайлДляPOSTЗапроса(ПараметрыЗапроса)
	СтрокаЗапроса = "";
	Для Каждого Параметр Из ПараметрыЗапроса Цикл
		Если Не ПустаяСтрока(СтрокаЗапроса) Тогда
			СтрокаЗапроса = СтрокаЗапроса + ",";
		КонецЕсли;
		СтрокаЗапроса = СтрокаЗапроса +""""+Параметр.Ключ+"""" + ":" + """"+Параметр.Значение+"""";
	КонецЦикла;
	
	//ЗаписьJSON = Новый ЗаписьJSON;
	//ЗаписьJSON/ОткрытьФайл(,,,);
	//ЗаписьJSON.ЗаписатьБезОбработки(СтрокаЗапроса);
	//СтрокаЗапроса
	//
	
	
	ИмяФайлаЗапроса = ПолучитьИмяВременногоФайла("txt");
	
	ФайлЗапроса = Новый ЗаписьТекста(ИмяФайлаЗапроса, КодировкаТекста.ANSI);
	ФайлЗапроса.Записать("{"+СтрокаЗапроса+"}");
	ФайлЗапроса.Закрыть();
	
	Возврат ИмяФайлаЗапроса;
КонецФункции

Функция РазмерФайла(ИмяФайла)
	Файл = Новый Файл(ИмяФайла);
	Возврат Файл.Размер();
КонецФункции

Функция функDOS2Unicode(СтрокаDOS)
	Результат="";
	дл_Строки=СтрДлина(СтрокаDOS);
	Для элем=1 по дл_Строки Цикл
		Результат=Результат+"\u"+СтроковыеФункцииКлиентСервер.ДополнитьСтроку(НРег(Из_10_В_Любую(КодСимвола(СтрокаDOS,элем),16)),4);
	КонецЦикла;	
    Возврат Результат;
КонецФункции

Функция ПолучитьКлючЗаписи(стр)
	Стр_Ключ=новый Структура("mdid,user,opponent,unread,updated");
	ЗаполнитьЗначенияСвойств(Стр_Ключ,Стр);
	Возврат РегистрыСведений.Чат100СП_Диалоги.СоздатьКлючЗаписи(Стр_Ключ);
КонецФункции	

Функция Из_10_В_Любую(Знач Значение=0,Нотация=36) Экспорт
     Если Нотация<=0 Тогда Возврат("") КонецЕсли;
     Значение=Число(Значение);
     Если Значение<=0 Тогда Возврат("0") КонецЕсли;
     Значение=Цел(Значение);
     Результат="";
     Пока Значение>0 Цикл
          Результат=Сред("0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ",Значение%Нотация+1,1)+Результат;
          Значение=Цел(Значение/Нотация) ;
     КонецЦикла;
     Возврат Результат;
КонецФункции


Функция ПолучитьДатуПоследнегоСообщения()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	МАКСИМУМ(Чат100СП_Диалоги.updated) КАК ПоследняяДата
		|ИЗ
		|	РегистрСведений.Чат100СП_Диалоги КАК Чат100СП_Диалоги";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Следующий() и ВыборкаДетальныеЗаписи.ПоследняяДата<>null Тогда
		Возврат ВыборкаДетальныеЗаписи.ПоследняяДата-60*60;
	Иначе
		Возврат НачалоГода(ТекущаяДата());
	КонецЕсли;;
КонецФункции	

#КонецОбласти
