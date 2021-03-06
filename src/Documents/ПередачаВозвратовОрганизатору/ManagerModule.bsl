
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	КомандаПечати 					= КомандыПечати.Добавить();
	КомандаПечати.МенеджерПечати 	= "Документ.ПередачаВозвратовОрганизатору";
	КомандаПечати.Идентификатор 	= "ЧекПросмотр";
	КомандаПечати.Картинка 			= БиблиотекаКартинок.Печать;
	КомандаПечати.Представление 	= НСтр("ru = 'Чек просмотр'");
	
	КомандаПечати 					= КомандыПечати.Добавить();
	КомандаПечати.МенеджерПечати 	= "Документ.ПередачаВозвратовОрганизатору";
	КомандаПечати.Идентификатор 	= "Чек";
	КомандаПечати.Картинка 			= БиблиотекаКартинок.ПечатьСразу;
	КомандаПечати.Представление 	= НСтр("ru = 'Чек'");
	КомандаПечати.СразуНаПринтер	= истина;
	
	
	
	КомандаПечати 							= КомандыПечати.Добавить();
	КомандаПечати.МенеджерПечати 			= "Документ.ПередачаВозвратовОрганизатору";
	КомандаПечати.Идентификатор 			= "ЧекНЗ";
	КомандаПечати.Картинка 					= БиблиотекаКартинок.Печать;
	КомандаПечати.обработчик				= "СтоСП_Печать_Клиент.ЧекНЗПередачаВозвратаОрганизатору";
	КомандаПечати.Представление 			= НСтр("ru = 'Чек НЗ'");
	КомандаПечати.НеВыполнятьЗаписьВФорме	= Истина;	
КонецПроцедуры


// Формирует печатные формы.
//
// Параметры:
//  МассивОбъектов  – Массив    – ссылки на объекты, которые нужно распечатать;
//  ПараметрыПечати – Структура – дополнительные настройки печати;
//  КоллекцияПечатныхФорм – ТаблицаЗначений – сформированные табличные документы (выходной параметр)
//  ОбъектыПечати         – СписокЗначений  – значение – ссылка на объект;
//                                            представление – имя области в которой был выведен объект (выходной параметр);
//  ПараметрыВывода       – Структура       – дополнительные параметры сформированных табличных документов (выходной параметр).
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	#Если Сервер Тогда	
		НужноПечататьМакет 		= УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "Чек");
		
		Если НужноПечататьМакет Тогда
			УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм,
			"Чек",
			НСтр("ru = 'Чек'"),
			ПечатьЧек(МассивОбъектов, ОбъектыПечати),
			,
			"Документ.ПередачаВозвратовОрганизатору.ПФ_MXL_Чек");
		КонецЕсли;	
		
		НужноПечататьМакет = УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ЧекПросмотр");
		
		Если НужноПечататьМакет Тогда
			УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм,
			"ЧекПросмотр",
			НСтр("ru = 'Чек просмотр'"),
			ПечатьЧек(МассивОбъектов, ОбъектыПечати),
			,
			"Документ.ПередачаВозвратовОрганизатору.ПФ_MXL_Чек");
		КонецЕсли;	
		
		НужноПечататьМакет = УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ЧекНЗ");
		
		Если НужноПечататьМакет Тогда
			УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм,
			"ЧекНЗ",
			НСтр("ru = 'Чек НЗ'"),
			ПечатьЧек(МассивОбъектов, ОбъектыПечати),
			,
			"Документ.ПередачаВозвратовОрганизатору.ПФ_MXL_Чек");
		КонецЕсли;	
		
	#КонецЕсли	
КонецПроцедуры




Функция ПечатьЧек(МассивОбъектов, ОбъектыПечати) Экспорт
	ТабДок = Новый ТабличныйДокумент;
	Макет 			= Документы.ПередачаВозвратовОрганизатору.ПолучитьМакет("ПФ_MXL_Чек");
	Запрос 			= Новый Запрос;
	Запрос.Текст 	=	
	"ВЫБРАТЬ
	|	ПередачаВозвратовОрганизатору.Дата КАК Дата,
	|	ПередачаВозвратовОрганизатору.Номер КАК Номер,
	|	ПередачаВозвратовОрганизатору.Организатор КАК Организатор,
	|	ПередачаВозвратовОрганизатору.Получатель КАК Получатель,
	|	ПередачаВозвратовОрганизатору.Покупки.(
	|		Участник КАК Участник,
	|		Покупка КАК Покупка,
	|		Количество КАК Количество,
	|		МестоХранения КАК МестоХранения,
	|		Сумма КАК Сумма
	|	) КАК Покупки
	|ИЗ
	|	Документ.ПередачаВозвратовОрганизатору КАК ПередачаВозвратовОрганизатору
	|ГДЕ
	|	ПередачаВозвратовОрганизатору.Ссылка В(&Ссылка)";
	Запрос.Параметры.Вставить("Ссылка", МассивОбъектов);
	Выборка = Запрос.Выполнить().Выбрать();

	ОбластьЗаголовок 	= Макет.ПолучитьОбласть("Заголовок");
	ОбластьШапка		= Макет.ПолучитьОбласть("Шапка");
	ОбластьПокупки 		= Макет.ПолучитьОбласть("Покупки");
	ОбластьПодвал 		= Макет.ПолучитьОбласть("Подвал");
	ТабДок.Очистить();

	
	ВставлятьРазделительСтраниц = Ложь;
	Пока Выборка.Следующий() Цикл
		Если ВставлятьРазделительСтраниц Тогда
			ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;

		ТабДок.Вывести(ОбластьЗаголовок);

		ОбластьШапка.Параметры.Заполнить(Выборка);
		ТабДок.Вывести(ОбластьШапка, Выборка.Уровень());

		ВыборкаПокупки = Выборка.Покупки.Выбрать();
		ИтогоШт 	= 0;
		ИтогоРуб 	= 0;
		Пока ВыборкаПокупки.Следующий() Цикл
			ОбластьПокупки.Параметры.Заполнить(ВыборкаПокупки);
			
			ИтогоШт 	= ИтогоШт  + ВыборкаПокупки.Количество;
			ИтогоРуб 	= ИтогоРуб + ВыборкаПокупки.Сумма;
			ТабДок.Вывести(ОбластьПокупки, ВыборкаПокупки.Уровень());
		КонецЦикла;

		ОбластьПодвал.Параметры.ИтогоШт 	= ИтогоШт;
		ОбластьПодвал.Параметры.ИтогоРуб 	= ИтогоРуб;
		ТабДок.Вывести(ОбластьПодвал);

		ВставлятьРазделительСтраниц = Истина;
	КонецЦикла;
	ТабДок.АвтоМасштаб = Истина;
	Возврат ТабДок;
КонецФункции


#Область Проведение

Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, ДополнительныеСвойства, Регистры = Неопределено) Экспорт
	
	////////////////////////////////////////////////////////////////////////////
	// Создадим запрос инициализации движений
	
	Запрос = Новый Запрос;
	ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка);
	////////////////////////////////////////////////////////////////////////////
	// Сформируем текст запроса
	ТекстыЗапроса = Новый СписокЗначений;
	//СтоСПОбмен_Общий.Получить_ТекстЗапроса_Обмен100сп (Запрос, ТекстыЗапроса, Регистры);
	СтоСПОбмен_Общий.Получить_ТекстЗапроса_Обмен100СП_РН(Запрос, ТекстыЗапроса, Регистры);
	Получить_ТекстЗапроса_Возвраты(Запрос, ТекстыЗапроса, Регистры);
	Получить_ТекстЗапроса_Расход(Запрос, ТекстыЗапроса, Регистры);
	
	
	ПроведениеСервер.ИницализироватьТаблицыДляДвижений(Запрос, ТекстыЗапроса, ДополнительныеСвойства.ТаблицыДляДвижений, Истина);
	
	
КонецПроцедуры

Процедура ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка)
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Запрос.УстановитьПараметр("Период", ДокументСсылка.Дата);  

КонецПроцедуры





Функция Получить_ТекстЗапроса_Возвраты(Запрос, ТекстыЗапроса, Регистры) 
	
	ИмяРегистра = "Возвраты";
	Если НЕ ПроведениеСервер.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли; 
	ТекстЗапроса = 
		 "ВЫБРАТЬ
		 |	&Период КАК Период,
		 |	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) КАК ВидДвижения,
		 |	ПередачаВозвратовОрганизаторуПокупки.Ссылка.Организатор КАК Организатор,
		 |	ПередачаВозвратовОрганизаторуПокупки.Участник КАК участник,
		 |	ПередачаВозвратовОрганизаторуПокупки.Покупка КАК Покупка,
		 |	ПередачаВозвратовОрганизаторуПокупки.МестоХранения КАК МестоХранения,
		 |	ПередачаВозвратовОрганизаторуПокупки.Количество КАК Количество,
		 |	ПередачаВозвратовОрганизаторуПокупки.Партия КАК Партия,
		 |	ПередачаВозвратовОрганизаторуПокупки.Сумма КАК Сумма
		 |ИЗ
		 |	Документ.ПередачаВозвратовОрганизатору.Покупки КАК ПередачаВозвратовОрганизаторуПокупки
		 |ГДЕ
		 |	ПередачаВозвратовОрганизаторуПокупки.Ссылка = &Ссылка";


	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	Возврат ТекстЗапроса;
КонецФункции

Функция Получить_ТекстЗапроса_Расход(Запрос, ТекстыЗапроса, Регистры) Экспорт
	ИмяРегистра = "Расход";
	Если НЕ ПроведениеСервер.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли; 

	ТекстЗапроса =	"ВЫБРАТЬ
					|	&Период КАК Период,
					|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) КАК ВидДвижения,
					|	Значение(Перечисление.ТипРасхода.Возврат) как ТипРасхода,
					|	ПередачаВозвратовОрганизаторуПокупки.Покупка КАК Покупка,
					|	ПередачаВозвратовОрганизаторуПокупки.участник как участник,
					|	ПередачаВозвратовОрганизаторуПокупки.Количество как Количество,
					|	ПередачаВозвратовОрганизаторуПокупки.Сумма как Сумма,
					|	Ложь как Списано
					|ИЗ
					|	Документ.ПередачаВозвратовОрганизатору.Покупки КАК ПередачаВозвратовОрганизаторуПокупки
					|ГДЕ
					|	ПередачаВозвратовОрганизаторуПокупки.Ссылка = &Ссылка";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	Возврат ТекстЗапроса;

КонецФункции



#КонецОбласти


#Область Обмен100сп
Функция ПолучитьТэг_discard(Ссылка,НомерСтроки=Неопределено) Экспорт
	ОтборПоСсылке=?(ТипЗнч(Ссылка)=Тип("Массив")," В (&Ссылка) "," = &Ссылка ");
	ОтборПоСтроке=?(ТипЗнч(Ссылка)=Тип("Массив")," В (&НомерСтроки) "," = &НомерСтроки ");
	
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПередачаВозвратовОрганизаторуПокупки.Ссылка.Дата КАК Дата,
		|	ПередачаВозвратовОрганизаторуПокупки.ШК КАК ШК
		|ИЗ
		|	Документ.ПередачаВозвратовОрганизатору.Покупки КАК ПередачаВозвратовОрганизаторуПокупки
		|ГДЕ
		|	ПередачаВозвратовОрганизаторуПокупки.Ссылка "+ОтборПоСсылке+" "+?(НомерСтроки=Неопределено,"", "
		|	И ПередачаВозвратовОрганизаторуПокупки.НомерСтроки "+ОтборПоСтроке+" ");
	
	Запрос.УстановитьПараметр("НомерСтроки", НомерСтроки);
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда Возврат ""; КонецЕсли;
	
	Выборка = РезультатЗапроса.Выбрать();
	
	ЗаписьXML=новый ЗаписьXML;
	ЗаписьXML.УстановитьСтроку("UTF-8");	
	ЗаписьXML.ЗаписатьНачалоЭлемента("Служебный");
	Пока Выборка.Следующий() Цикл
		ЗаписьXML.ЗаписатьНачалоЭлемента("discard");
		СтоСП.Вставить_Тэг(ЗаписьXML,"date"	,				Выборка.Дата);
		СтоСП.Вставить_Тэг(ЗаписьXML,"uid"	, 				Формат(Число(Выборка.ШК.Участник.Код),"ЧГ=0"));
		СтоСП.Вставить_Тэг(ЗаписьXML,"discardType"	,		"orgPickUp");		
		СтоСПОбмен_Общий.ЗаполнитьТэгиЗаказаПо_ШК(Выборка.ШК,ЗаписьXML);	
		ЗаписьXML.ЗаписатьКонецЭлемента();
	КонецЦикла;
    ЗаписьXML.ЗаписатьКонецЭлемента();
	рез=ЗаписьXML.Закрыть();
	рез=СтрЗаменить(рез,"<Служебный>","");
	рез=СтрЗаменить(рез,"</Служебный>","");
	Возврат рез;
КонецФункции
#КонецОбласти


Функция ПолноеИмяОбъекта()
	Возврат "Документ.ПередачаВозвратовОрганизатору";
КонецФункции
