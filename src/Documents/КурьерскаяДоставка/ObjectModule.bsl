Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	#Область ПравильноеПроведение
	ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	Документы.КурьерскаяДоставка.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	ДополнительныеСвойства.Вставить("ЭтоНовый",ЭтоНовый());
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	СП_ДвиженияСервер.ОтразитьДвиженияПоРегистру("ОстаткиТоваров", 	ДополнительныеСвойства, Движения, Отказ);
	СП_ДвиженияСервер.ОтразитьДвиженияПоРегистру("Транзит", 		ДополнительныеСвойства, Движения, Отказ);
	СП_ДвиженияСервер.ОтразитьДвиженияПоРегистру("СобранныеЗаказы", ДополнительныеСвойства, Движения, Отказ);
	
	
	
	
	#КонецОбласти
	

КонецПроцедуры


Процедура ЗаполнитьОстатками() экспорт
	Если ЗаказыСПосылками.Количество() = 0 Тогда
		ОбновитьГруппуДоставки();
	КонецЕсли;
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ОстаткиТоваровОстатки.Покупка Как Посылка,
		|	ОстаткиТоваровОстатки.МестоХранения,
		|	ОстаткиТоваровОстатки.Габарит,
		|	ОстаткиТоваровОстатки.Партия,
		|	СвояТочка.Значение Как ПунктВыдачи
		|ПОМЕСТИТЬ Остатки
		|ИЗ
		|	РегистрНакопления.ОстаткиТоваров.Остатки(&Период, Участник = &Участник
		|	И ТИПЗНАЧЕНИЯ(Покупка) = ТИП(Справочник.Посылки)) КАК ОстаткиТоваровОстатки,
		|	Константа.СвояТочка КАК СвояТочка
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ТранзитОстатки.ПокупкаСсылка,
		|	ТранзитОстатки.МестоХранения,
		|	ТранзитОстатки.Габарит,
		|	ТранзитОстатки.Партия,
		|	ТранзитОстатки.Точка
		|ИЗ
		|	РегистрНакопления.Транзит.Остатки(, Участник = &Участник
		|	и ТипЗначения(ПокупкаСсылка) = Тип(Справочник.Посылки)) КАК ТранзитОстатки
		|;
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Остатки.Посылка,
		|	Остатки.МестоХранения,
		|	Остатки.Габарит,
		|	Остатки.Партия,
		|	Остатки.ПунктВыдачи,
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ПраздничныеДни.Дата) КАК ПраздничныхДней,
		|	МАКСИМУМ(ЕСТЬNULL(НегабаритЗначения.Вес, 0)) КАК Вес,
		|	МАКСИМУМ(ЕСТЬNULL(НегабаритЗначения.объем, 0)) КАК Объем,
		|	ВЫРАЗИТЬ(МАКСИМУМ(Мегаордера.Ссылка) КАК Справочник.Мегаордера) КАК ШК
		|ПОМЕСТИТЬ втГабаритыШК
		|ИЗ
		|	Остатки КАК Остатки
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ПраздничныеДни КАК ПраздничныеДни
		|		ПО (ПраздничныеДни.Дата > Остатки.Партия.Дата)
		|		И (ПраздничныеДни.Дата < &Период)
		|		И (НЕ ПраздничныеДни.ПометкаУдаления)
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НегабаритЗначения КАК НегабаритЗначения
		|		ПО Остатки.Партия = НегабаритЗначения.Регистратор
		|		И Остатки.Посылка = НегабаритЗначения.Покупка
		|		И Остатки.Габарит = НегабаритЗначения.Габарит
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Мегаордера КАК Мегаордера
		|		ПО Остатки.Посылка = Мегаордера.Покупка
		|СГРУППИРОВАТЬ ПО
		|	Остатки.МестоХранения,
		|	Остатки.Габарит,
		|	Остатки.ПунктВыдачи,
		|	Остатки.Партия,
		|	Остатки.Посылка
		|;
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	втГабаритыШК.Посылка,
		|	втГабаритыШК.МестоХранения,
		|	втГабаритыШК.Габарит,
		|	втГабаритыШК.Партия,
		|	втГабаритыШК.ПунктВыдачи,
		|	втГабаритыШК.ПраздничныхДней,
		|	РАЗНОСТЬДАТ(втГабаритыШК.Партия.Дата, &Период, ДЕНЬ) - ЕСТЬNULL(втГабаритыШК.ПраздничныхДней, 0) КАК ВремяХранения,
		|	втГабаритыШК.Вес,
		|	втГабаритыШК.Объем,
		|	ЕСТЬNULL(втГабаритыШК.ПраздничныхДней, 0) КАК Праздники,
		|	ЕСТЬNULL(ТарифыПоНаправлениямСрезПоследних.Стоимость, 0) КАК СтоимостьДоставки,
		|	втГабаритыШК.ШК
		|ИЗ
		|	втГабаритыШК КАК втГабаритыШК
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ТарифыПоНаправлениям.СрезПоследних(&Период,) КАК ТарифыПоНаправлениямСрезПоследних
		|		ПО (ТарифыПоНаправлениямСрезПоследних.Куда = &СвойГород)
		|		И втГабаритыШК.Габарит = ТарифыПоНаправлениямСрезПоследних.Габарит
		|		И втГабаритыШК.Посылка.ПерваяТочка.ГородСП = ТарифыПоНаправлениямСрезПоследних.Откуда";
	
	Запрос.УстановитьПараметр("Участник", 	Участник);
	Запрос.УстановитьПараметр("Период", 	?(ЗначениеЗаполнено(Дата), Дата -1,КонецДня(Дата)));
	Запрос.УстановитьПараметр("СвойГород", 	Константы.СвояТочка.Получить().ГородСП);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ЗаказыНаСкладе.Загрузить(результатЗапроса.Выгрузить());
	
//	СписокПосылок	= ЗаказыНаСкладе.ВыгрузитьКолонку("Посылка");
//	СтоСПОбмен_Посылки.Загрузить_СоставПосылкиПоКодам(СписокПосылок);
	
	Для каждого элем из ЗаказыНаСкладе Цикл
		элем.Подбор	= (ЗаказыСПосылками.НайтиСтроки(новый Структура("Посылка", элем.Посылка)).Количество()>0);
				
				
		структураРассчета 			= аСПНаСервере.РассчитатьСтоимостьХранения(Новый структура("Габарит, ВремяХранения, СтоимостьДоставки, БесплатнаяВыдача, вес,Объем", 
//																								элем.Габарит, элем.ВремяХранения, элем.СтоимостьДоставки, элем.Посылка.БесплатнаяВыдача,Элем.вес,Элем.Объем));
																								элем.Габарит, элем.ВремяХранения, элем.СтоимостьДоставки, ложь,Элем.вес,Элем.Объем));
		элем.СтоимостьИтого			= структураРассчета.СтоимостьИтого;
		элем.ОплачиваетОрганизатор  = структураРассчета.ОплачиваетОрганизатор;
		элем.ОплачиваетУчастник		= структураРассчета.ОплачиваетУчастник;
		элем.СтоимостьХранения		= структураРассчета.СтоимостьХранения;
	КонецЦикла;
	
	СтоимостьОплачиваетОрганизатор 	= ЗаказыНаСкладе.Итог("ОплачиваетОрганизатор");
	СтоимостьХранения 				= ЗаказыНаСкладе.Итог("СтоимостьИтого");//Доставка до ПВ
	СтоимостьИтого					= СтоимостьХранения + СтоимостьДоставки; //Курьерская доставка
КонецПроцедуры


Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	Если не  ЗначениеЗаполнено(СобранныйЗаказ) и ЗначениеЗаполнено(Ссылка) Тогда 
		СобранныйЗаказ 		= СП_РаботаСоСправочниками.ПолучитьСобранныйЗаказПо_Коду(Номер);
		параметрыЗаказа 	= Новый Структура("ДокументЗаказ", Ссылка);
		СП_РаботаСоСправочниками.ОбновитьСобранныйЗаказ(СобранныйЗаказ, параметрыЗаказа);
		ПараметрыШК		= Новый Структура("Покупка, СобранныйЗаказ, ПунктВыдачи", 
											СобранныйЗаказ,СобранныйЗаказ,Константы.ПунктВыдачиКурьерскойДоставки.Получить);
		СП_РаботаСоСправочниками.ОбновитьМегаордер(СобранныйЗаказ.ШК, ПараметрыШК)
	КонецЕсли;	
	
	Если Адрес = "" Тогда
		ПолучитьАдресДоставки_Api();
	КонецЕсли;	
	
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение И  
		 СтатусДоставки = Перечисления.СтатусыДоставки.ОжидаетСборки	Тогда
		Если ЗаказыНаСкладе.НайтиСтроки(Новый Структура("Подбор",Истина)).Количество()>0  Тогда
			СтатусДоставки = Перечисления.СтатусыДоставки.Собран;
		Иначе
			СтатусДоставки = Перечисления.СтатусыДоставки.Отменен;
		КонецЕсли	
	КонецЕсли;	
	
//	Если РежимЗаписи = РежимЗаписиДокумента.Проведение И не СчетВыставлен Тогда
//		ВыставитьСчет_Api();
//	КонецЕсли;
		
		
КонецПроцедуры
	


Процедура ВыставитьСчет_Api() Экспорт
	Отправили 	= СП_КурьерскаяДоставка.ТекстЗапроса_Счет_Api(ЭтотОбъект);
	Получили 	= ОтправитьНаСайт(Отправили);
	Если Получили.Результат Тогда
		сз = новый СписокЗначений();
		сз.Добавить(номер);
		результат = СтоСПОбмен_ГруппыДоставки.Загрузить_ПоКодам(сз, истина);	
		СП_КурьерскаяДоставка.ДокументКурьерскойДоставки_из_Api(результат.deliveryGroups[0],ЭтотОбъект);
		СчетВыставлен = Истина;
	КонецЕсли;
КонецПроцедуры

Процедура ОбновитьГруппуДоставки() Экспорт
		сз = новый СписокЗначений();
		сз.Добавить(номер);
		результат = СтоСПОбмен_ГруппыДоставки.Загрузить_ПоКодам(сз, истина);	
		результат.deliveryGroups.Колонки.Добавить("Ссылка", Новый ОписаниеТипов("ДокументСсылка.КурьерскаяДоставка") );
		СП_КурьерскаяДоставка.ДокументКурьерскойДоставки_из_Api(результат.deliveryGroups[0],ЭтотОбъект);
КонецПроцедуры


Функция ПолучитьАдресДоставки_Api() Экспорт
	результат = СП_АдресаДоставки.выполнитьЗапрос(Заказы[0].КодЗаказа,Ссылка );
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Результат.СтруктураАдреса);
КонецФункции


Функция ОтправитьНаСайт(Отправили) 
	СтрокаПротокола						= 	новый Структура ("ДатаНачала, ДатаОкончания,Отправили, Результат, ПолученныеДанные");
	СтрокаПротокола.Отправили			= Отправили;
	СтрокаПротокола.ДатаНачала			=	ТекущаяДата();
	
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