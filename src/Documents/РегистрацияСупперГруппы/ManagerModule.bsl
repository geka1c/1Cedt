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
	|	ДанныеДокумента.Проведен КАК Проведен
	|ИЗ
	|	Документ.Приходная КАК ДанныеДокумента
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка";
	
	Реквизиты = Запрос.Выполнить().Выбрать();
	Реквизиты.Следующий();
	
	Запрос.УстановитьПараметр("Период",                                                         Реквизиты.Период);
	Запрос.УстановитьПараметр("Номер",                         Реквизиты.Номер);
	Запрос.УстановитьПараметр("ИдентификаторМетаданных",       ОбщегоНазначения.ИдентификаторОбъектаМетаданных(ПолноеИмяОбъекта()));
	Запрос.УстановитьПараметр("ПометкаУдаления",               Реквизиты.ПометкаУдаления);
	Запрос.УстановитьПараметр("Проведен",                      Реквизиты.Проведен);
КонецПроцедуры

#КонецОбласти

#Область Обмен100сп
Функция ПолучитьТэг_superGroupReceipt(Ссылка,НомерСтроки=Неопределено) Экспорт
	ОтборПоСсылке=?(ТипЗнч(Ссылка)=Тип("Массив")," В (&Ссылка) "," = &Ссылка ");
	ОтборПоСтроке=?(ТипЗнч(Ссылка)=Тип("Массив")," В (&НомерСтроки) "," = &НомерСтроки ");

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	РегистрацияСупперГруппыГруппы.Ссылка.Дата КАК Дата,
		|	РегистрацияСупперГруппыГруппы.НомерСтроки КАК НомерСтроки,
		|	РегистрацияСупперГруппыГруппы.СупперГруппа КАК СупперГруппа
		|ИЗ
		|	Документ.РегистрацияСупперГруппы.Группы КАК РегистрацияСупперГруппыГруппы 
		|ГДЕ
		|	РегистрацияСупперГруппыГруппы.Ссылка "+ОтборПоСсылке+" "+?(НомерСтроки=Неопределено,"", "
		|	И РегистрацияСупперГруппыГруппы.НомерСтроки "+ОтборПоСтроке+" ");;
		
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("НомерСтроки", НомерСтроки);

	РезультатЗапроса = Запрос.Выполнить();
		

	
	ВыборкаСупергруппа = РезультатЗапроса.Выбрать();
	
	ЗаписьXML=новый ЗаписьXML;
	ЗаписьXML.УстановитьСтроку("UTF-8");	
	ЗаписьXML.ЗаписатьНачалоЭлемента("Служебный");	
	
	Пока ВыборкаСупергруппа.Следующий() Цикл
		ЗаписьXML.ЗаписатьНачалоЭлемента("superGroupReceipt");
		СтоСП.Вставить_Тэг(ЗаписьXML,"documentNumber",		ВыборкаСупергруппа.СупперГруппа);
		СтоСП.Вставить_Тэг(ЗаписьXML,"actualDeliveryDate",	ВыборкаСупергруппа.Дата);
		
		ЗаписьXML.ЗаписатьКонецЭлемента();    //superGroupReceipt
	КонецЦикла;
	
	ЗаписьXML.ЗаписатьКонецЭлемента();    //Служебный
	рез=ЗаписьXML.Закрыть();
	рез=СтрЗаменить(рез,"<Служебный>","");
	рез=СтрЗаменить(рез,"</Служебный>","");
	Возврат рез;
	
	
КонецФункции
#КонецОбласти


Функция ПолноеИмяОбъекта()
	Возврат "Документ.РегистрацияСупперГруппы";
КонецФункции





// Формирует печатные формы.
//
// Параметры:
//  МассивОбъектов  – Массив    – ссылки на объекты, которые нужно распечатать;
//  ПараметрыПечати – Структура – дополнительные настройки печати;
//  КоллекцияПечатныхФорм – ТаблицаЗначений – сформированные табличные документы (выходной параметр)
//  ОбъектыПечати         – СписокЗначений  – значение – ссылка на объект;
//                                            представление – имя области в которой был выведен объект (выходной параметр);
//  ПараметрыВывода       – Структура       – дополнительные параметры сформированных табличных документов (выходной параметр).
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
#Если Сервер Тогда 
 	
	
    НужноПечататьМакет = УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "СупперГруппа");
    Если НужноПечататьМакет Тогда
        УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
        КоллекцияПечатныхФорм,
        "СупперГруппа",
        НСтр("ru = 'Суппер группа'"),
        ПечатьСупперГруппы(МассивОбъектов, ОбъектыПечати),
        ,
        "Документ.ВыдачаТранзита.ПФ_MXL_СупперГруппа");
	КонецЕсли;		
	
#КонецЕсли 	
КонецПроцедуры

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати – ТаблицаЗначений – состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
    КомандаПечати = КомандыПечати.Добавить();
    КомандаПечати.МенеджерПечати = "Документ.РегистрацияСупперГруппы";
    КомандаПечати.Идентификатор = "СупперГруппа";
    КомандаПечати.Представление = НСтр("ru = 'Суппер группа'");
    КомандаПечати.ПроверкаПроведенияПередПечатью = Истина; 	
	
	
КонецПроцедуры


Функция ПечатьСупперГруппы(МассивОбъектов, ОбъектыПечати) Экспорт
	ТабДок= Новый ТабличныйДокумент;
	Макет = Документы.ВыдачаТранзита.ПолучитьМакет("ПФ_MXL_СупперГруппа");
	Макет.АвтоМасштаб=Истина;
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	РегистрацияСупперГруппыСостав.СупперГруппа КАК СупперГруппа,
		|	РегистрацияСупперГруппыСостав.Участник КАК Участник,
		|	РегистрацияСупперГруппыСостав.Покупка КАК Покупка
		|ИЗ
		|	Документ.РегистрацияСупперГруппы.Состав КАК РегистрацияСупперГруппыСостав
		|ИТОГИ ПО
		|	СупперГруппа";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок");
	Шапка = Макет.ПолучитьОбласть("Шапка");
	ОбластьПокупкиШапка = Макет.ПолучитьОбласть("ПокупкиШапка");
	ОбластьПокупки = Макет.ПолучитьОбласть("Покупки");
	ОбластьПодвал=Макет.ПолучитьОбласть("Подвал");
	ТабДок.Очистить();
	ВставлятьРазделительСтраниц = Ложь;
	
	Пока Выборка.Следующий() Цикл
		ШК=Выборка.СупперГруппа.Код;
		ОбластьШК=Шапка.Области.Шапка;
		

		РисунокШтрихкод=Шапка.Рисунки.РисунокШтрихкод;
		
//		ВнешняяКомпонента = Обработки.ПечатьЭтикетокИЦенников.ПодключитьВнешнююКомпонентуПечатиШтрихкода(); 
		ПараметрыШтрихкода=ЗаполнитьПараметрыОбработки(ШК);
		РисунокШтрихкод.Картинка = МенеджерОборудованияВызовСервера.ПолучитьКартинкуШтрихкода(ПараметрыШтрихкода);

		РисунокШтрихкод.Расположить(ОбластьШК);
		
		
		////
		ТабДок.Вывести(ОбластьЗаголовок);

		Шапка.Параметры.Номер			= "";
		Шапка.Параметры.Дата			= Выборка.СупперГруппа.ДатаСоздания;
		Шапка.Параметры.ТочкаОтправления= Выборка.СупперГруппа.ПерваяТочкаПриема;
		Шапка.Параметры.ТочкаНазначения	= Выборка.СупперГруппа.ПунктВыдачи;
		ТабДок.Вывести(Шапка, Выборка.Уровень());

		ТабДок.Вывести(ОбластьПокупкиШапка);

	
		ВыборкаДетальныеЗаписи = Выборка.Выбрать();
		
		номерСтроки=1;
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			ОбластьПокупки.Параметры.Заполнить(ВыборкаДетальныеЗаписи);
			ОбластьПокупки.Параметры.номерСтроки		= номерСтроки;
			ОбластьПокупки.Параметры.КодПокупки		= ВыборкаДетальныеЗаписи.Покупка.Код;
			ОбластьПокупки.Параметры.КодУчастника   = ВыборкаДетальныеЗаписи.Участник.Код;
			ОбластьПокупки.Параметры.ТипПокупки		= ТипЗнч(ВыборкаДетальныеЗаписи.Покупка);
			ТабДок.Вывести(ОбластьПокупки, ВыборкаДетальныеЗаписи.Уровень());
			номерСтроки=номерСтроки+1;
		КонецЦикла;
		ТабДок.Вывести(ОбластьПодвал);
		ВставлятьРазделительСтраниц = Истина;
	КонецЦикла;
	
	
	Возврат ТабДок;
КонецФункции

Функция ЗаполнитьПараметрыОбработки(Код)
	ПараметрыШтрихкода=новый Структура;
	ПараметрыШтрихкода.Вставить("Ширина",450);
	ПараметрыШтрихкода.Вставить("Высота",120);
	ПараметрыШтрихкода.Вставить("ТипКода",4);
	ПараметрыШтрихкода.Вставить("ОтображатьТекст",истина);
	ПараметрыШтрихкода.Вставить("РазмерШрифта",14);
	ПараметрыШтрихкода.Вставить("Штрихкод",Код);
	
	Возврат ПараметрыШтрихкода;	
	
КонецФункции

