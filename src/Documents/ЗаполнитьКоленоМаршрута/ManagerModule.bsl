#Область Проведение

Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, ДополнительныеСвойства, Регистры = Неопределено) Экспорт
	
	////////////////////////////////////////////////////////////////////////////
	// Создадим запрос инициализации движений
	
	Запрос = Новый Запрос;
	ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка);
	////////////////////////////////////////////////////////////////////////////
	// Сформируем текст запроса
	ТекстыЗапроса = Новый СписокЗначений;
	СтоСПОбмен_Общий.Получить_ТекстЗапроса_Обмен100сп (Запрос, ТекстыЗапроса, Регистры);
	СтоСПОбмен_Общий.Получить_ТекстЗапроса_Обмен100СП_РН(Запрос, ТекстыЗапроса, Регистры);
	
	ПроведениеСервер.ИницализироватьТаблицыДляДвижений(Запрос, ТекстыЗапроса, ДополнительныеСвойства.ТаблицыДляДвижений, Истина);
	
	
КонецПроцедуры

Процедура ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка)
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ДанныеДокумента.Ссылка КАК Ссылка,
	|	ДанныеДокумента.ПометкаУдаления КАК ПометкаУдаления,
	|	ДанныеДокумента.Номер КАК Номер,
	|	ДанныеДокумента.Дата КАК Период,
	|	ДанныеДокумента.Проведен КАК Проведен,
	|	ДанныеДокумента.Комментарий КАК Комментарий
	|ИЗ
	|	Документ.Приходная КАК ДанныеДокумента
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка";
	
	Реквизиты = Запрос.Выполнить().Выбрать();
	Реквизиты.Следующий();
	
	Запрос.УстановитьПараметр("Период",                                                         Реквизиты.Период);
	Запрос.УстановитьПараметр("Номер",                         Реквизиты.Номер);
	Запрос.УстановитьПараметр("ИдентификаторМетаданных",       ОбщегоНазначения.ИдентификаторОбъектаМетаданных(ПолноеИмяОбъекта()));
	Запрос.УстановитьПараметр("Комментарий",                   Реквизиты.Комментарий);
	Запрос.УстановитьПараметр("ПометкаУдаления",               Реквизиты.ПометкаУдаления);
	Запрос.УстановитьПараметр("Проведен",                      Реквизиты.Проведен);
КонецПроцедуры

#КонецОбласти

#Область Обмен100сп
Функция ПолучитьТэг_superGroupStage(Ссылка) Экспорт
	ОтборПоСсылке=?(ТипЗнч(Ссылка)=Тип("Массив")," В (&Ссылка) "," = &Ссылка ");
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЗаполнитьКоленоМаршрута.Супергруппа КАК Супергруппа,
		|	ЗаполнитьКоленоМаршрута.НомерКолена КАК НомерКолена,
		|	ЗаполнитьКоленоМаршрута.ДатаДоставкиПлан КАК ДатаДоставкиПлан,
		|	ЗаполнитьКоленоМаршрута.ДатаДоставкиФакт КАК ДатаДоставкиФакт,
		|	ЗаполнитьКоленоМаршрута.Комментарий КАК Комментарий,
		|	ЗаполнитьКоленоМаршрута.ТрэкНомер КАК ТрэкНомер
		|ИЗ
		|	Документ.ЗаполнитьКоленоМаршрута КАК ЗаполнитьКоленоМаршрута
		|ГДЕ
		|	ЗаполнитьКоленоМаршрута.Ссылка "+ОтборПоСсылке;
		
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	РезультатЗапроса = Запрос.Выполнить();
		

	
	Выборка = РезультатЗапроса.Выбрать();
	
	ЗаписьXML=новый ЗаписьXML;
	ЗаписьXML.УстановитьСтроку("UTF-8");	
	ЗаписьXML.ЗаписатьНачалоЭлемента("Служебный");	
	
	Пока Выборка.Следующий() Цикл
		ЗаписьXML.ЗаписатьНачалоЭлемента("superGroupStage");
		СтоСП.Вставить_Тэг(ЗаписьXML,"documentNumber",			Выборка.Супергруппа.Код);
		СтоСП.Вставить_Тэг(ЗаписьXML,"deliveryNumber",			Выборка.ТрэкНомер);
		СтоСП.Вставить_Тэг(ЗаписьXML,"ordinalNumber",			Выборка.НомерКолена); 
		СтоСП.Вставить_Тэг(ЗаписьXML,"estimateDeliveryDate",	?(ЗначениеЗаполнено(Выборка.ДатаДоставкиПлан),Выборка.ДатаДоставкиПлан,""));
		СтоСП.Вставить_Тэг(ЗаписьXML,"actualDeliveryDate",		?(ЗначениеЗаполнено(Выборка.ДатаДоставкиФакт),Выборка.ДатаДоставкиФакт,""));
		СтоСП.Вставить_Тэг(ЗаписьXML,"deliveryDescription",   	Выборка.Комментарий);
		ЗаписьXML.ЗаписатьКонецЭлемента();    //superGroupStage
	КонецЦикла;
	
	ЗаписьXML.ЗаписатьКонецЭлемента();    //Служебный
	рез=ЗаписьXML.Закрыть();
	рез=СтрЗаменить(рез,"<Служебный>","");
	рез=СтрЗаменить(рез,"</Служебный>","");
	Возврат рез;
	
КонецФункции
#КонецОбласти


Функция ПолноеИмяОбъекта()
	Возврат "Документ.ЗаполнитьКоленоМаршрута";
КонецФункции
