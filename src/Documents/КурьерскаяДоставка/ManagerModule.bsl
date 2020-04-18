

#Область Печать
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	КомандаПечати 					= КомандыПечати.Добавить();
	КомандаПечати.МенеджерПечати 	= "Документ.КурьерскаяДоставка";
	КомандаПечати.Идентификатор 	= "ЧекПросмотр";
	КомандаПечати.Картинка 			= БиблиотекаКартинок.Печать;
	КомандаПечати.Представление 	= НСтр("ru = 'Чек просмотр'");
	
	КомандаПечати 					= КомандыПечати.Добавить();
	КомандаПечати.МенеджерПечати 	= "Документ.КурьерскаяДоставка";
	КомандаПечати.Идентификатор 	= "Чек";
	КомандаПечати.Картинка 			= БиблиотекаКартинок.ПечатьСразу;
	КомандаПечати.Представление 	= НСтр("ru = 'Чек'");
	КомандаПечати.СразуНаПринтер	= истина;
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
			"Документ.Расходная.ПФ_MXL_Чек");
		КонецЕсли;	
		
		НужноПечататьМакет = УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ЧекПросмотр");
		
		Если НужноПечататьМакет Тогда
			УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм,
			"ЧекПросмотр",
			НСтр("ru = 'Чек просмотр'"),
			ПечатьЧек(МассивОбъектов, ОбъектыПечати),
			,
			"Документ.Расходная.ПФ_MXL_Чек");
		КонецЕсли;	
		
		
	#КонецЕсли	
КонецПроцедуры

Функция ПечатьЧек(МассивОбъектов, ОбъектыПечати) 
	#Если Сервер Тогда
		// Создаем табличный документ и устанавливаем имя параметров печати.
		ТабличныйДокумент 						= Новый ТабличныйДокумент;
		ТабличныйДокумент.АвтоМасштаб			=Истина;
		ТабличныйДокумент.ПолеСлева				=0;
		ТабличныйДокумент.ПолеСправа			=0;	 
		ТабличныйДокумент.ИмяПараметровПечати 	= "ПараметрыПечати_Чек";
		Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.Расходная.ПФ_MXL_Чек");
		
		Запрос = Новый Запрос;
		Запрос.Текст =
		"ВЫБРАТЬ
		|	Расходная.Дата КАК Дата,
		|	Расходная.Номер КАК Номер,
		|	Расходная.Участник КАК Участник,
		|	Расходная.Участник.Код КАК КодУчастника,
		|	Расходная.СтоимостьДоставки как СтоимостьДоставки,
		|	Расходная.СобранныйЗаказ.ШК как ШК,
		|	0 КАК ЗаПоискНика,
		|	Расходная.ЗаказыНаСкладе.(
		|		Посылка КАК Покупка,
		|		Посылка.БесплатнаяВыдача как БесплатнаяВыдача,
		|		ЕСТЬNULL(Расходная.ЗаказыНаСкладе.МестоХранения.Родитель.Наименование, """") + ""   \   "" +
		|			Расходная.ЗаказыНаСкладе.МестоХранения.Наименование КАК МестоХранения,
		|		Партия КАК Партия,
		|		Расходная.ЗаказыНаСкладе.Посылка.Организатор КАК Организатор,
		|		ВремяХранения КАК ВремяХранения,
		|		СтоимостьХранения КАК СтоимостьХранения,
		|		Габарит КАК Габарит,
		|		ложь КАК Потерян,
		|		1 КАК Количество,
		|		СтоимостьДоставки КАК СтоимостьДоставки,
		|		СтоимостьИтого Как СтоимостьИтого,
		|		ОплачиваетУчастник,
		|		ОплачиваетОрганизатор) КАК Покупки,
		|	""-"" как КартаУчастника
		|ИЗ
		|	Документ.КурьерскаяДоставка КАК Расходная
		|ГДЕ
		|	Расходная.Ссылка В (&МассивОбъектов)
		|	И Расходная.ЗаказыНаСкладе.Подбор";
		
		Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
		Выборка = Запрос.Выполнить().Выбрать();
		ПервыйДокумент = Истина;
		
		ОбластьШтрихКод		= Макет.ПолучитьОбласть("ШтрихКод"); 
		ОбластьШапка 		= Макет.ПолучитьОбласть("ШапкаДоставки");
		ОбластьЗаПоискНика 	= Макет.ПолучитьОбласть("ЗаПоискНика");
		ОбластьПокупки 		= Макет.ПолучитьОбласть("Покупки");
		ОбластьПокупкиБВ	= Макет.ПолучитьОбласть("ПокупкиБВ");
		ОбластьТовары  		= Макет.ПолучитьОбласть("Товары");
		ОбластьБВИтог 		= Макет.ПолучитьОбласть("ОплачиваетОрганизатор");
		ОбластьПодвал 		= Макет.ПолучитьОбласть("Подвал");
		ОбластьДоставка		= Макет.ПолучитьОбласть("Доставка");
		
		
		
		ВставлятьРазделительСтраниц = Ложь;
		Итого=0;
		бесплатнаяВыдача = 0;
		Пока Выборка.Следующий() Цикл
			Если Не ПервыйДокумент Тогда
				ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
			КонецЕсли;
			ПервыйДокумент = Ложь;
			



				ШтрихКодДокумента = Выборка.ШК;

				ПараметрыШтрихкода = Новый Структура;
				ПараметрыШтрихкода.Вставить("Ширина", 450);
				ПараметрыШтрихкода.Вставить("Высота", 120);
				ПараметрыШтрихкода.Вставить("Штрихкод", Строка(ШтрихКодДокумента));
				ПараметрыШтрихкода.Вставить("ТипКода", 4);
				ПараметрыШтрихкода.Вставить("ОтображатьТекст", Ложь);
				ПараметрыШтрихкода.Вставить("РазмерШрифта", 10);
				ПараметрыШтрихкода.Вставить("УголПоворота", 0); //Одно из следующих значений: 0, 90, 180, 270.
				ПараметрыШтрихкода.Вставить("ПрозрачныйФон", Истина);
				ПараметрыШтрихкода.Вставить("УровеньКоррекцииQR", 0); //Одно из следующих значений: //0, 1, 2, 3. Соответствует: L, M, Q, H.
				РисунокШтрихкод = ОбластьШтрихКод.Рисунки.РисунокШтрихкод;
				РисунокШтрихкод.Картинка = МенеджерОборудованияВызовСервера.ПолучитьКартинкуШтрихкода(ПараметрыШтрихкода);
				РисунокШтрихкод.РазмерКартинки = РазмерКартинки.Пропорционально; 
				РисунокШтрихкод.Расположить(ОбластьШтрихКод.Области.ШтрихКод);
				ТабличныйДокумент.Вывести(ОбластьШтрихКод, Выборка.Уровень());

			ОбластьШапка.Параметры.Заполнить(Выборка);
			ОбластьШапка.Параметры.Дата=Формат(Выборка.Дата,"ДЛФ=ДД");
			ОбластьШапка.Параметры.НазваниеОрганизации=Константы.НазваниеОрганизации.Получить();
			ТабличныйДокумент.Вывести(ОбластьШапка, Выборка.Уровень());
			
			//ТабДок.Вывести(ОбластьПокупкиШапка);
			нпп=1;
			СтоимостьПоиска=Выборка.ЗаПоискНика;
			
			ВыборкаПокупки = Выборка.Покупки.Выбрать();
			Пока ВыборкаПокупки.Следующий() Цикл

					Если ВыборкаПокупки.БесплатнаяВыдача Тогда
						ОбластьВыводаПокупки = ОбластьПокупкиБВ;
						ОбластьВыводаПокупки.Параметры.ОплачиваетУчастник	= ВыборкаПокупки.ОплачиваетУчастник;
					Иначе	 
						ОбластьВыводаПокупки = ОбластьПокупки;
					КонецЕсли;	
					ОбластьВыводаПокупки.Параметры.Заполнить(ВыборкаПокупки);
					ОбластьВыводаПокупки.Параметры.нпп				= нпп;
					ОбластьВыводаПокупки.Параметры.Организатор		= ВыборкаПокупки.Организатор;
					ОбластьВыводаПокупки.Параметры.СтоимостьИтого	= ВыборкаПокупки.ОплачиваетОрганизатор + ВыборкаПокупки.ОплачиваетУчастник;
					ТабличныйДокумент.Вывести(ОбластьВыводаПокупки , ВыборкаПокупки.Уровень());
					
					Итого				= Итого				+ ВыборкаПокупки.ОплачиваетУчастник;
					бесплатнаяВыдача 	= бесплатнаяВыдача	+ ВыборкаПокупки.ОплачиваетОрганизатор; 
					нпп=нпп+1;

			КонецЦикла;
			
			ОбластьДоставка.Параметры.Доставка			= Выборка.СтоимостьДоставки;
			ОбластьБВИтог.Параметры.бесплатнаяВыдача	= бесплатнаяВыдача;
			
			ОбластьПодвал.Параметры.Заполнить(Выборка);
			ОбластьПодвал.Параметры.Итого				= Итого+СтоимостьПоиска+Выборка.СтоимостьДоставки;
			Если бесплатнаяВыдача >0 Тогда
				ТабличныйДокумент.Вывести(ОбластьБВИтог);				
			КонецЕсли;	
			ТабличныйДокумент.Вывести(ОбластьДоставка);
			ТабличныйДокумент.Вывести(ОбластьПодвал);
		КонецЦикла;
		
		
		Возврат ТабличныйДокумент;
	#КонецЕсли
	
	
КонецФункции
#КонецОбласти


#Область Проведение
Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, ДополнительныеСвойства, Регистры = Неопределено) Экспорт
	
	////////////////////////////////////////////////////////////////////////////
	// Создадим запрос инициализации движений
	
	Запрос = Новый Запрос;
	ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка);
	////////////////////////////////////////////////////////////////////////////
	// Сформируем текст запроса
	ТекстыЗапроса = Новый СписокЗначений;
	Получить_ТекстЗапроса_ОстаткиТоваров(Запрос, ТекстыЗапроса, Регистры);
	Получить_ТекстЗапроса_Транзит(Запрос, ТекстыЗапроса, Регистры);
	Получить_ТекстЗапроса_СобранныеЗаказы(Запрос, ТекстыЗапроса, Регистры);
	Получить_ТекстЗапроса_Обмен100СПрн_Ошибки(Запрос, ТекстыЗапроса, Регистры);
	Получить_ТекстЗапроса_НеВыгруженноНаСайт(Запрос, ТекстыЗапроса, Регистры);
	
	ПроведениеСервер.ИницализироватьТаблицыДляДвижений(Запрос, ТекстыЗапроса, ДополнительныеСвойства.ТаблицыДляДвижений, Истина);
	
	
КонецПроцедуры

Процедура ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка)
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	
	Запрос.УстановитьПараметр("Период",                        ДокументСсылка.Дата);
	Запрос.УстановитьПараметр("Номер",                         ДокументСсылка.Номер);
	Запрос.УстановитьПараметр("ИдентификаторМетаданных",       ОбщегоНазначения.ИдентификаторОбъектаМетаданных(ПолноеИмяОбъекта()));
	Запрос.УстановитьПараметр("Комментарий",                   ДокументСсылка.Комментарий);
	Запрос.УстановитьПараметр("ПометкаУдаления",               ДокументСсылка.ПометкаУдаления);
	Запрос.УстановитьПараметр("ПунктВыдачи",               	   Справочники.ТочкиРаздачи.НайтиПоКоду("0100"));
	Запрос.УстановитьПараметр("СвойПунктВыдачи",               Константы.СвояТочка.Получить()); 
	Запрос.УстановитьПараметр("Проведен",                      ДокументСсылка.Проведен);
	Запрос.УстановитьПараметр("КоличествоЗаказов",             ДокументСсылка.ЗаказыНаСкладе.НайтиСтроки(новый Структура("Подбор",Истина)).Количество()); 
 	Запрос.УстановитьПараметр("НеобходимаОтменаЗаказа",        (ДокументСсылка.Заказы.НайтиСтроки(новый Структура("ДоставкаОтменена",Истина)).Количество()>0));
 	Запрос.УстановитьПараметр("НеобходимаОтправкаВыдачи",      (ДокументСсылка.ЗаказыНаСкладе.НайтиСтроки(новый Структура("Подбор",Истина)).Количество()>0 и ДокументСсылка.СвойКурьер) );
 	Запрос.УстановитьПараметр("ЕстьОшибкиПриОтменеЗаказа",     (ДокументСсылка.Заказы.НайтиСтроки(новый Структура("ОшибкаОтмены",Истина)).Количество()>0));
 	Запрос.УстановитьПараметр("ЕстьОшибкиПриОтправкеВыдачи",     (ДокументСсылка.ЗаказыНаСкладе.НайтиСтроки(новый Структура("Отправлено, Подбор",Ложь, Истина)).Количество()>0 и ДокументСсылка.СвойКурьер));
КонецПроцедуры

Функция Получить_ТекстЗапроса_СобранныеЗаказы(Запрос, ТекстыЗапроса, Регистры) Экспорт
	ИмяРегистра = "СобранныеЗаказы";
	Если НЕ ПроведениеСервер.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли; 
	
	
		 ТекстЗапроса = "
		 |
		 |ВЫБРАТЬ
		 |	КурьерскаяДоставка.Ссылка.Дата 			КАК Период,
		 |	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)  КАК ВидДвижения,
		 |	КурьерскаяДоставка.СобранныйЗаказ 		КАК Заказ,
		 |	КурьерскаяДоставка.МестоХранения		КАК МестоХранения,
		 |	&ПунктВыдачи							КАК ПунктВыдачи,
		 |	КурьерскаяДоставка.Ссылка 				КАК Партия,
 		 |	КурьерскаяДоставка.СтоимостьХранения	КАК СтоимостьХранения,
 		 |	КурьерскаяДоставка.СтоимостьДоставки	КАК СтоимостьДоставки,
		 |	&КоличествоЗаказов 						КАК Количество
		 |ИЗ
		 |	Документ.КурьерскаяДоставка 			КАК КурьерскаяДоставка
		 |ГДЕ
		 |	КурьерскаяДоставка.Ссылка = &Ссылка и &КоличествоЗаказов>0
		 |
		 |";
		

	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	Возврат ТекстЗапроса;

КонецФункции



Функция Получить_ТекстЗапроса_ОстаткиТоваров(Запрос, ТекстыЗапроса, Регистры) Экспорт
	ИмяРегистра = "ОстаткиТоваров";
	Если НЕ ПроведениеСервер.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли; 
	
	
		ТекстЗапроса ="
		               |
					   |ВЫБРАТЬ
		               |	ЗаказыНаСкладе.Ссылка.Дата 				КАК Период,
		               |	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)  КАК ВидДвижения,
		               |	ЗаказыНаСкладе.Посылка 					КАК Покупка,
		               |	ЗаказыНаСкладе.МестоХранения 			КАК МестоХранения,
		               |	ЗаказыНаСкладе.Габарит 					КАК Габарит,
		               |	ЗаказыНаСкладе.Посылка.Участник 		КАК Участник,
		               |	ИСТИНА 									КАК Оплачен,
		               |	ЛОЖЬ 									КАК Потерян,
		               |	ЗаказыНаСкладе.Партия 					КАК Партия,
		               |	1 										КАК Количество
		               |ИЗ
		               |	Документ.КурьерскаяДоставка.ЗаказыНаСкладе КАК ЗаказыНаСкладе
		               |ГДЕ
		               |	ЗаказыНаСкладе.ПунктВыдачи = &СвойПунктВыдачи
					   |	и ЗаказыНаСкладе.Ссылка= &Ссылка
					   |	и ЗаказыНаСкладе.Подбор
		               |
					   |
					   |";
		

	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	Возврат ТекстЗапроса;

КонецФункции


Функция Получить_ТекстЗапроса_Транзит(Запрос, ТекстыЗапроса, Регистры) Экспорт
	ИмяРегистра = "Транзит";
	Если НЕ ПроведениеСервер.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли; 
	
	
		ТекстЗапроса ="
		               |
					   |ВЫБРАТЬ
		               |	ЗаказыНаСкладе.Ссылка.Дата 				КАК Период,
		               |	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)  КАК ВидДвижения,
		               |	ЗаказыНаСкладе.Посылка 					КАК ПокупкаСсылка,
		               |	ЗаказыНаСкладе.МестоХранения 			КАК МестоХранения,
		               |	ЗаказыНаСкладе.Габарит 					КАК Габарит,
		               |	ЗаказыНаСкладе.Посылка.Участник 		КАК Участник,
		               |	ЗаказыНаСкладе.ПунктВыдачи		 		КАК Точка,
		               |	ЗаказыНаСкладе.Партия 					КАК Партия,
		               |	1 										КАК Количество
		               |ИЗ
		               |	Документ.КурьерскаяДоставка.ЗаказыНаСкладе КАК ЗаказыНаСкладе
		               |ГДЕ
		               |	ЗаказыНаСкладе.ПунктВыдачи <> &СвойПунктВыдачи
					   |	и ЗаказыНаСкладе.Ссылка= &Ссылка
					   |	и ЗаказыНаСкладе.Подбор
		               |
					   |
					   |";
		

	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	Возврат ТекстЗапроса;

КонецФункции



Функция Получить_ТекстЗапроса_НеВыгруженноНаСайт(Запрос, ТекстыЗапроса, Регистры) Экспорт
	ИмяРегистра = "НеВыгруженноНаСайт";
	Если НЕ ПроведениеСервер.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли; 
	

	 ТекстЗапроса = "
		 |
		 |ВЫБРАТЬ
		 |	Док.Ссылка.Дата КАК Период,
		 |	null КАК Посылка,
		 |	Док.МестоХранения КАК МестоХранения,
		 |	null КАК Габарит,
		 |	Док.СобранныйЗаказ КАК Коробка,
		 |	&ПунктВыдачи КАК ПунктВыдачи,
		 |	Док.Ссылка КАК Партия,
		 |	1 КАК Количество
		 |ИЗ
		 |	Документ.КурьерскаяДоставка КАК Док
		 |ГДЕ
		 |Док.Ссылка = &Ссылка
		 |и
		 |( 
		 |(
	     |	НЕ Док.ОтправленаОтмена
	     |	и &НеобходимаОтменаЗаказа
	     |)
	     |или
	     |(	
	     |	НЕ Док.ОтправленаВыдача
	     |	и &НеобходимаОтправкаВыдачи
	     |)
	     |)
		 |
		 |";
	

	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	Возврат ТекстЗапроса;

КонецФункции

Функция Получить_ТекстЗапроса_Обмен100СПрн_Ошибки(Запрос, ТекстыЗапроса, Регистры)
	ИмяРегистра = "Обмен100СПрн_Ошибки";
	Если НЕ ПроведениеСервер.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли; 

	
	ТекстЗапроса =  "
					|
					|ВЫБРАТЬ
	                |	Док.Дата КАК Период,
	                |	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) КАК ВидДвижения,
	                |	ЗНАЧЕНИЕ(Перечисление.ТипыОбменов100сп.КурьерскаяДоставка) КАК типОбмена,
	                |	Док.Ссылка КАК Партия,
	                |	0 КАК СтрокаВПартии,
	                |	Док.СобранныйЗаказ.ШК КАК Мегаордер,
	                |	""Отмена доставки (не производился обмен)!"" КАК СообщениеОшибки,
	                |	1 КАК КоличествоНеИсправленных
	                |ИЗ
	                |	Документ.КурьерскаяДоставка КАК Док
	                |ГДЕ
	                |	Док.Ссылка = &Ссылка
	                |	И НЕ Док.ОтправленаОтмена
	                |	и &НеобходимаОтменаЗаказа
	                |
	                |ОБЪЕДИНИТЬ ВСЕ
	                |
					|ВЫБРАТЬ
	                |	Док.Дата КАК Период,
	                |	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) КАК ВидДвижения,
	                |	ЗНАЧЕНИЕ(Перечисление.ТипыОбменов100сп.КурьерскаяДоставка) КАК типОбмена,
	                |	Док.Ссылка КАК Партия,
	                |	0 КАК СтрокаВПартии,
	                |	Док.СобранныйЗаказ.ШК КАК Мегаордер,
	                |	""Отмена доставки (Ошибки при отмене заказа)!"" КАК СообщениеОшибки,
	                |	1 КАК КоличествоНеИсправленных
	                |ИЗ
	                |	Документ.КурьерскаяДоставка КАК Док
	                |ГДЕ
	                |	Док.Ссылка = &Ссылка
	                |	И Док.ОтправленаОтмена
	                |	и &ЕстьОшибкиПриОтменеЗаказа
	                |
	                |ОБЪЕДИНИТЬ ВСЕ
	                |
					|
					|ВЫБРАТЬ
	                |	Док.Дата КАК Период,
	                |	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) КАК ВидДвижения,
	                |	ЗНАЧЕНИЕ(Перечисление.ТипыОбменов100сп.КурьерскаяДоставка) КАК типОбмена,
	                |	Док.Ссылка КАК Партия,
	                |	0 КАК СтрокаВПартии,
	                |	Док.СобранныйЗаказ.ШК КАК Мегаордер,
	                |	""Выдача заказа (не производился обмен)!"" КАК СообщениеОшибки,
	                |	1 КАК КоличествоНеИсправленных
	                |ИЗ
	                |	Документ.КурьерскаяДоставка КАК Док
	                |ГДЕ
	                |	Док.Ссылка = &Ссылка
	                |	И НЕ Док.ОтправленаВыдача
	                |	и &НеобходимаОтправкаВыдачи
	                |
	                |ОБЪЕДИНИТЬ ВСЕ
	                |
					|ВЫБРАТЬ
	                |	Док.Дата КАК Период,
	                |	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) КАК ВидДвижения,
	                |	ЗНАЧЕНИЕ(Перечисление.ТипыОбменов100сп.КурьерскаяДоставка) КАК типОбмена,
	                |	Док.Ссылка КАК Партия,
	                |	0 КАК СтрокаВПартии,
	                |	Док.СобранныйЗаказ.ШК КАК Мегаордер,
	                |	""Выдача заказа (Ошибки при отправке выдачи заказа)!"" КАК СообщениеОшибки,
	                |	1 КАК КоличествоНеИсправленных
	                |ИЗ
	                |	Документ.КурьерскаяДоставка КАК Док
	                |ГДЕ
	                |	Док.Ссылка = &Ссылка
	                |	И Док.ОтправленаВыдача
	                |	и &ЕстьОшибкиПриОтправкеВыдачи
	                |
					
					|";
	
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	Возврат ТекстЗапроса;
КонецФункции




#КонецОбласти

Функция ПолноеИмяОбъекта()
	Возврат "Документ.КурьерскаяДоставка";
КонецФункции
